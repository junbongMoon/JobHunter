package com.jobhunter.service.reviewboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;

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
	public boolean saveReview(WriteBoardDTO writeBoardDTO) throws Exception {
		boolean result = false;
		int boardInsert = Rdao.insertBoard(writeBoardDTO);

		System.out.println("insertBoard() 결과: " + boardInsert);

		if (boardInsert > 0) {
			System.out.println("리뷰 등록 성공");
			result = true;
		} else {
			System.out.println("리뷰 등록 실패");
		}

		return result;
	}


	@Override
	public ReviewDetailViewDTO getReviewDetail(int boardNo)throws Exception {
		// TODO Auto-generated method stub
		return Rdao.selectReviewInfo(boardNo);
	}

}

