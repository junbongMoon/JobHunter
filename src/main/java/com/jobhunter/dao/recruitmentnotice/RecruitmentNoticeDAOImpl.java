package com.jobhunter.dao.recruitmentnotice;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RecruitmentNoticeDAOImpl implements RecruitmentNoticeDAO {
	private final SqlSession ses;
	private final String NS = "com.testoracle.mapper.recruitmentnoticemapper"; 
	
	@Override
	public int insertRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception {
		// 매퍼 완성 안함... 다이나믹 sql을 사용하자......
		
		return ses.insert(NS + ".insertRecruitmentnotice", recruitmentNoticeDTO);
	}

}
