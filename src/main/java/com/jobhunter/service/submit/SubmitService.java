package com.jobhunter.service.submit;

import java.time.LocalDateTime;

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
	 * @param int RecruitmentUid
	 * @param PageRequestDTO pageRequestDTO
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
	 * @param Status status
	 * @param int resumePk
	 * @param int recruitmentNoticePk
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
	 * @param String yesterDayStr
	 * @return
	 * @throws Exception
	 *
	 */
	public int expiredToSubmitBetween(LocalDateTime start, LocalDateTime end) throws Exception;


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 해당 공고에 지원한 상태가 WAITING인 제출 된 이력서들의 상태를 만료(EXPIRED) 상태로 변경 하는 메서드
	 * </p>
	 * 
	 * @param uid 공고 uid
	 * @throws Exception
	 *
	 */
	public void expiredEntireWatingRegByRecUid(int uid) throws Exception;
}
