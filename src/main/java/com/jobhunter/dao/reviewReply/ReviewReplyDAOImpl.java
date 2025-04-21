package com.jobhunter.dao.reviewReply;

import java.util.List;

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
}

