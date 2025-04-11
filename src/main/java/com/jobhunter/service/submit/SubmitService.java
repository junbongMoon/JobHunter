package com.jobhunter.service.submit;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.Status;

public interface SubmitService {	
		
	
	// 내가 작성한 공고에 제출 된 이력서들을 조회하는 메서드
	public PageResponseDTO<ResumeDetailInfoBySubmit> getResumeWithAll(int RecruitmentUid, PageRequestDTO pageRequestDTO) throws Exception;
	
	// 제출 이력의 상태를 변경 해주는 메서드
	public void changeStatus(Status status, int resumePk, int recruitmentNoticePk);


}
