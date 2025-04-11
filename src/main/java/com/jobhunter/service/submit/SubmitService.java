package com.jobhunter.service.submit;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.Status;

/**
 * @author 문준봉
 *
 */
public interface SubmitService {	
		
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	내가 작성한 공고에 제출 된 이력서들을 조회하는 메서드
	 * </p>
	 * 
	 * @param RecruitmentUid
	 * @param pageRequestDTO
	 * @return
	 * @throws Exception
	 *
	 */
	public PageResponseDTO<ResumeDetailInfoBySubmit> getResumeWithAll(int RecruitmentUid, PageRequestDTO pageRequestDTO) throws Exception;
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 제출 이력의 상태를 변경 해주는 메서드
	 * </p>
	 * 
	 * @param status
	 * @param resumePk
	 * @param recruitmentNoticePk
	 * @return
	 *
	 */
	public boolean changeStatus(Status status, int resumePk, int recruitmentNoticePk);

	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	공고의 마감 기한이 만료 되었을 때 제출 된 이력서의 상태를 만료(EXPIRED) 상태로 변경 하는 메서드
	 * </p>
	 * 
	 * @param yesterDayStr
	 * @return
	 * @throws Exception
	 *
	 */
	public int expiredToSubmit(String yesterDayStr) throws Exception;
}
