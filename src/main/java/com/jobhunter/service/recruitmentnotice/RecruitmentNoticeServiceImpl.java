package com.jobhunter.service.recruitmentnotice;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RecruitmentNoticeServiceImpl implements RecruitmentNoticeService {
	
	private final RecruitmentNoticeDAO recdao;

	@Override
	@Transactional(propagation = Propagation.REQUIRES_NEW, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception {
		boolean result = false;
		
		// 공고를 제출하는 메서드
		recdao.insertRecruitmentNotice(recruitmentNoticeDTO);
		// 여러가지 값을 가질 수 있는 것도 저장 해야함 트랜잭션으로 묶어서 공고를 선입력하고 그 uid값을 참조하는 것으로 insert하자
		
		// application(), advantage(), ecruitmentnoticeboardupfiles(있다면..), 
		// where_recruit_region(지역), jobtype_recruit_sub(있다면..)
		
		
		return result;
	}

	@Override
	public List<RecruitmentNotice> getRecruitmentByUid(int uid) throws Exception {
		// 내가 작성한 공고(템플릿 제외)를 가져오는 메서드
		
		return recdao.selectRecuitmentByUid(uid);
	}

}
