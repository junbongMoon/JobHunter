package com.jobhunter.dao.recruitmentnotice;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RecruitmentNoticeDAOImpl implements RecruitmentNoticeDAO {
	private final SqlSession ses;
	private final String NS = "com.testoracle.mapper.recruitmentnoticemapper"; 
	
	// 공고(템플릿 아님)를 등록하는 메서드
	@Override
	public int insertRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception {
		// 매퍼 완성 안함...
		
		return ses.insert(NS + ".insertRecruitmentnotice", recruitmentNoticeDTO);
	}

	
	// 사용자(회사) uid로 공고를 조회하는 메서드
	@Override
	public List<RecruitmentNotice> selectRecruitmentByUid(int uid) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	// 우대조건을 입력하는 메서드
	@Override
	public int insertAdvantageWithRecruitmentNotice(AdvantageDTO adv) {
		
		return ses.insert(NS + ".insertAdvantageWithRecruitmentnotice", adv);
	}

	// 가장 최근에 올린 공고를 조회하는 메서드
	@Override
	public RecruitmentNotice selectRecentRecruitment(int companyUid) {
		
		return ses.selectOne(NS +".", companyUid);
	}

}
