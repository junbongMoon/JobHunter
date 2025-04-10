package com.jobhunter.dao.reviewboard;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	@Override
    public LocalDateTime selectLike(int userId, int boardNo) throws Exception {
        Map<String, Object> selectMap = new HashMap<>();
        selectMap.put("userId", userId);
        selectMap.put("boardNo", boardNo);
        return ses.selectOne(NS + ".selectLastLikeTime", selectMap);
    }

    @Override
    public int insertLike(int userId, int boardNo) {
        Map<String, Object> insertMap = new HashMap<>();
        insertMap.put("userId", userId);
        insertMap.put("boardNo", boardNo);
        return ses.insert(NS + ".insertLike", insertMap);
    }

    @Override
    public int updateBoardLikes(int boardNo) {
    	logger.debug("likes 증가 시도, boardNo: {}", boardNo); 
    	return ses.update(NS + ".updateBoardLikes", boardNo);
    }

    @Override
    public int deleteLike(int userId, int boardNo) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("boardNo", boardNo);
        return ses.delete(NS + ".deleteLike", map);
    }

    @Override
    public int decreaseBoardLikes(int boardNo) throws Exception {
        return ses.update(NS + ".decreaseBoardLikes", boardNo);
    }

	@Override
	public WriteBoardDTO selectrecruitmentList(int boardNo) throws Exception {
		
		return ses.selectOne(NS + ".selectModifyReviewBoard",boardNo);
	}

	@Override
	public int updateReviewBoard(WriteBoardDTO modify) throws Exception {

		return ses.update(NS + ".updateReviewBoard" ,modify);
	}


}
