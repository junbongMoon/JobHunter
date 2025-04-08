package com.jobhunter.dao.submit;

import java.util.List;

import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;

public interface SubmitDAO {
	
	// 공고 PK로 제출한 이력서들을 페이징해서 담아오는 메서드
	List<ResumeDetailInfoBySubmit> selectResumDetailInfoBySubmitByRecruitmentUid(int RecruitmentUid, 
			PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO) throws Exception;
	
	// 공고에 제출한 이력서 row수를 가져오는 메서드
	int selectTotalCountRowOfResumeByUid(int uid) throws Exception;
	
	// 이력서에 있는 파일을 조회하는 메서드
	List<ResumeUpfileDTO> selectUpfileListByResume(int uid) throws Exception;
}
