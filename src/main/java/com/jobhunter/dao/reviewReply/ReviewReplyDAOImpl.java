package com.jobhunter.dao.reviewReply;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.reviewReply.ReviewReplyDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReviewReplyDAOImpl implements ReviewReplyDAO {

	private static Logger logger = LoggerFactory.getLogger(ReviewReplyDAOImpl.class);
	private static final String NS = "com.jobhunter.mapper.reviewreplymapper";

	@Autowired
	private SqlSession ses;


    @Override
    public List<ReviewReplyDTO> selectRepliesByBoardNo(int boardNo) throws Exception{
        return ses.selectList(NS+".selectRepliesByBoardNo", boardNo);
    }

    @Override
    public int insertReply(ReviewReplyDTO dto) throws Exception {
    	return ses.insert(NS+".insertReply", dto);
    }

	@Override
	public int updateReplyDao(ReviewReplyDTO dto) throws Exception {
	    return ses.update(NS+".updateReplyDate", dto);
	}

	@Override
	public int deleteReplyDao(int replyNo, int userId) throws Exception {
	    Map<String, Object> param = new HashMap<>();
	    param.put("replyNo", replyNo);
	    param.put("userId", userId);
	    return ses.update(NS+".deleteReplyDate", param);
	}

	@Override
	public List<ReviewReplyDTO> selectRepliesWithPaging(int boardNo, int offset, int size) throws Exception {
	    Map<String, Object> param = new HashMap<>();
        param.put("boardNo", boardNo);
        param.put("offset", offset);
        param.put("size", size);
        return ses.selectList(NS + ".selectRepliesWithPaging", param);
    }

    @Override
    public int countRepliesByBoardNo(int boardNo) throws Exception {
        return ses.selectOne(NS + ".countRepliesByBoardNo", boardNo);
    }
}

