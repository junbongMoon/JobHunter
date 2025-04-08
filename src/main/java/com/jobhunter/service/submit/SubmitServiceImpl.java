package com.jobhunter.service.submit;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.dao.resume.ResumeDAO;
import com.jobhunter.model.resume.ResumeDetailDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SubmitServiceImpl implements SubmitService {
	
	// 이력서 DAO
	private ResumeDAO resumeDAO;
	// 공고 DAO
	private RecruitmentNoticeDAO recruitmentNoticeDAO;
	
	@Override
	public ResumeDetailDTO getResumeWithAll(int RecruitmentUid) throws Exception {
		
		return null;
	}

}
