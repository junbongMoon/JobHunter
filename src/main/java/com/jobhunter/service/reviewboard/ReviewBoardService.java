package com.jobhunter.service.reviewboard;

import java.util.List;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewboard.Likes;
import com.jobhunter.model.reviewboard.RPageRequestDTO;
import com.jobhunter.model.reviewboard.RPageResponseDTO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewBoardWithReplyVO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;
import com.jobhunter.model.util.TenToFivePageVO;

public interface ReviewBoardService {

	// 게시글 조회
	List<ReviewBoardDTO> selectReBoard() throws Exception;

	// 작성 페이지에 공고정보 조회
	List<RecruitmentnoticContentDTO> selectgoggo(int userUid, String ip) throws Exception;

	// 게시글 저장 --
	boolean saveReview(WriteBoardDTO writeBoardDTO) throws Exception;

	// 상세페이지 조회
	ReviewDetailViewDTO getReviewDetail(int boardNo) throws Exception;

	// 좋아요 기능
	boolean addlikes(Likes likes) throws Exception;

	// 좋아요 취소
	boolean removeLike(Likes likes) throws Exception;

	// 상세 페이지에 좋아요가 잇는지 없는지 조회 메서
	boolean hasUserLiked(int userId, int boardNo) throws Exception;

	// 수정 조회
	WriteBoardDTO getReviewBoardUpdate(int boardNo) throws Exception;

	// 수정 저장
	boolean updateReviewBoard(WriteBoardDTO modify) throws Exception;

	boolean deleteBoard(int boardNo) throws Exception;

	// 조회수 조회
	boolean oneViewCount(int userId, int boardNo) throws Exception;

	// 조회수 증가
	void insertViews(int userId, int boardNo, String viewType) throws Exception;

	RPageResponseDTO<ReviewBoardDTO> getPagedBoardList(RPageRequestDTO pageRequestDTO) throws Exception;

	List<String> getCompanyList() throws Exception;

	TenToFivePageVO<ReviewBoardWithReplyVO> getMyReview(RPageRequestDTO dto) throws Exception;





	
	

	

	

}
