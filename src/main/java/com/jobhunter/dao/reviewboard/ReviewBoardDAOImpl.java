package com.jobhunter.dao.reviewboard;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;


@Repository
 class ReviewBoardDAOImpl implements ReviewBoardDAO{
	
	private static Logger logger = LoggerFactory.getLogger(ReviewBoardDAOImpl.class);
	private static final String NS = "com.jobhunter.mapper.reviewboardmapper";

	@Autowired
	private SqlSession ses;
	

	
	@Override
	public List<ReviewBoardDTO> selectListBoard() throws Exception {
	
		
		
		return ses.selectList(NS +".allList");
		
	}
	
	@Override
	public List<RecruitmentnoticContentDTO> selectWriteGonggo(int userUid)throws Exception{
		 
		return ses.selectList(NS+".gonggoAll",userUid);
	}


	@Override
	public int insertBoard(WriteBoardDTO writeBoardDTO) throws Exception {
		
		return ses.insert(NS + ".insertReview",writeBoardDTO);
	}



	@Override
	public ReviewDetailViewDTO selectReviewInfo(int boardNo) throws Exception {
        return ses.selectOne(NS + ".detailAll", boardNo);
}


}
