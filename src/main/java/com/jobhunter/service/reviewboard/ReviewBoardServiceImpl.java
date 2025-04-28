package com.jobhunter.service.reviewboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResume;
import com.jobhunter.model.reviewboard.Likes;
import com.jobhunter.model.reviewboard.RPageRequestDTO;
import com.jobhunter.model.reviewboard.RPageResponseDTO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewBoardWithReplyVO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;
import com.jobhunter.model.util.TenToFivePageVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewBoardServiceImpl implements ReviewBoardService {

	private final ReviewBoardDAO Rdao;

	private static Logger logger = LoggerFactory.getLogger(ReviewBoardServiceImpl.class);

	@Override
	public List<ReviewBoardDTO> selectReBoard() throws Exception {

		return Rdao.selectListBoard();
	}

	@Override
	public List<RecruitmentnoticContentDTO> selectgoggo(int userUid, String ip) throws Exception {
		if (userUid > 0) {
			List<RecruitmentnoticContentDTO> list = Rdao.selectWriteGonggo(userUid);

			for (RecruitmentnoticContentDTO dto : list) {
				System.out.println("ip: " + dto);
			}
		} else {
			System.out.println("유효하지 않은 사용자 ID입니다.");
		}
		return Rdao.selectWriteGonggo(userUid);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveReview(WriteBoardDTO writeBoardDTO) throws Exception {
		boolean result = false;
		int boardInsert = Rdao.insertBoard(writeBoardDTO);

		System.out.println("insertBoard() 결과: " + boardInsert);

		if (boardInsert > 0) {
			System.out.println("리뷰 등록 성공");
			Rdao.insertLog(writeBoardDTO.getUserId(), "REVIEW", "CREATE");
			result = true;
		} else {
			System.out.println("리뷰 등록 실패");
		}

		return result;
	}

	@Override
	public ReviewDetailViewDTO getReviewDetail(int boardNo) throws Exception {

		return Rdao.selectReviewInfo(boardNo);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean addlikes(Likes likes) throws Exception {

	    // 3. 좋아요 추가
	    Rdao.insertLike(likes);

	    // 4. 게시글 좋아요 수 증가
	    Rdao.updateBoardLikes(likes.getBoardNo());

	    return true;
	}


	@Override

	public boolean hasUserLiked(int userId, int boardNo) throws Exception {
		 try {
		        Likes like = Likes.builder()
		                .userId(userId)
		                .boardNo(boardNo)
		                .likeType("REBOARD")
		                .build();

		        return Rdao.hasUserLikeit(like) > 0;
		    } catch (Exception e) {
		        // 에러 로그 기록
		        
		        return false; 
		    }
		}
	

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public boolean removeLike(Likes likes) throws Exception {
	    int result = Rdao.deleteLike(likes);
	    if (result > 0) {
	        Rdao.updateBoardLikes(likes.getBoardNo()); // 좋아요 수 감소
	        return true;
	    } else {
	        return false;
	    }
	}

	@Override
	public WriteBoardDTO getReviewBoardUpdate(int boardNo) throws Exception {

		return Rdao.selectrecruitmentList(boardNo);
	}

	@Override
	public boolean updateReviewBoard(WriteBoardDTO modify) throws Exception {
		int result = Rdao.updateReviewBoard(modify);

		if (result > 0) {
			return true; // 수정 성공
		}
		return false; // 수정 실패
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean deleteBoard(int boardNo) throws Exception {
		int userId = Rdao.selectUserIdByBoardNo(boardNo);
		Rdao.insertLog(userId, "REVIEW", "DELETE");
		Rdao.deletBoardNo(boardNo);
		return true;

	}

	@Override
	public boolean oneViewCount(int userId, int boardNo) throws Exception {
		int count = Rdao.checkViewedWithHours(userId, boardNo);
		return count == 0; // 조회 기록이 없다
	}

	public void insertViews(int userId, int boardNo, String viewType) throws Exception {
		// 최근 24시간 이내 조회했는지 검사
		int count = Rdao.checkViewedWithHours(userId, boardNo);
		if (count == 0) {
			// INSERT or UPDATE 처리
			Rdao.insertOrUpdateReviewView(userId, boardNo, "REBOARD");
			Rdao.incrementViews(boardNo);
		}
	}

	@Override
	public RPageResponseDTO<ReviewBoardDTO> getPagedBoardList(RPageRequestDTO pageRequestDTO) throws Exception {

		// 1. 전체 게시글 수 (검색 조건 포함)
		int totalCount = Rdao.countReviewBoard(pageRequestDTO);
		
		System.out.println("조회된 게시글 수: " + totalCount);
		// 2. 현재 페이지에 해당하는 게시글 목록
		List<ReviewBoardDTO> boardList = Rdao.selectPagedReviewBoard(pageRequestDTO);

		// 3. 응답 DTO 생성 및 반환
		return new RPageResponseDTO<ReviewBoardDTO>(boardList, totalCount, pageRequestDTO);
	}

	@Override
	public List<String> getCompanyList() throws Exception {
	
		return Rdao.ListCompany();
	}

	@Override
	public TenToFivePageVO<ReviewBoardWithReplyVO> getMyReview(RPageRequestDTO dto) throws Exception {
		List<ReviewBoardWithReplyVO> list = Rdao.findMyReviewWithReply(dto);
		int totalItems = Rdao.findMyReviewWithReplyCnt(dto);
		
		
		TenToFivePageVO<ReviewBoardWithReplyVO> vo = new TenToFivePageVO<ReviewBoardWithReplyVO>(list, dto.getPage(), totalItems);
		System.out.println(vo + "서비스");
		return vo;
	}

}
