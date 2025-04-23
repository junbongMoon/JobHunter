package com.jobhunter.service.submit;

import java.time.LocalDateTime;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmitAndUser;
import com.jobhunter.model.submit.Status;
import com.jobhunter.model.submit.SubmitFromRecruitVO;
import com.jobhunter.model.submit.SubmitSearchDTO;
import com.jobhunter.model.util.TenToFivePageVO;

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


	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 공고uid를 기반으로 검색조건에 맞는 신청서를 페이징해서 가져오는 메서드 
	 * </p>
	 * 
	 * @param RecruitmentWithResumePageDTO 검색조건과 기업uid등이 담긴 객체
	 * @return 조건에 맞는 공고들
	 *
	 */
	TenToFivePageVO<SubmitFromRecruitVO> selectResumesByRecruitmentUid(SubmitSearchDTO dto) throws Exception;


	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 신청서 하나만 이력서포함해서 가져오는 메서드
	 * </p>
	 * 
	 * @param int registrationNo 신청서 pk
	 * @return 신청서 상세정보
	 *
	 */
	ResumeDetailInfoBySubmitAndUser selectSubmitAndResumeDetailInfo(int registrationNo, AccountVO account) throws Exception;
}
