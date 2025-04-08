package com.jobhunter.service.submit;

import com.jobhunter.model.resume.ResumeDetailDTO;

public interface SubmitService {	
		
	
	// 내가 작성한 공고에 제출 된 이력서들을 조회하는 메서드
	public ResumeDetailDTO getResumeWithAll(int RecruitmentUid) throws Exception;


}
