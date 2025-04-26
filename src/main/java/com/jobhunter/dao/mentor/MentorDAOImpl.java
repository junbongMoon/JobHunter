package com.jobhunter.dao.mentor;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.mentor.MentorRequestListSearchDTO;
import com.jobhunter.model.mentor.MentorRequestSimpleVO;
import com.jobhunter.model.mentor.MentorRequestVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class MentorDAOImpl implements MentorDAO{
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.mentormapper";
	
	@Override
	public List<MentorRequestSimpleVO> selectMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception {
		return ses.selectList(NS + ".selectMentorRequestSimpleList", dto);
	}
	@Override
	public int countMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception {
		return ses.selectOne(NS + ".countMentorRequestSimpleList", dto);
	}
	
	@Override
	public MentorRequestVO selectMentorRequestDetail(Integer advancementNo) throws Exception {
		return ses.selectOne(NS + ".selectMentorRequestDetail", advancementNo);
	}

}
