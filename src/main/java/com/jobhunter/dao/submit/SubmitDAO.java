package com.jobhunter.dao.submit;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import com.jobhunter.model.message.MessageTargetInfoDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.RegistrationVO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmitAndUser;
import com.jobhunter.model.submit.Status;
import com.jobhunter.model.submit.SubmitFromRecruitVO;
import com.jobhunter.model.submit.SubmitFromUserVO;
import com.jobhunter.model.submit.SubmitSearchDTO;
import com.jobhunter.model.user.UserVO;

public interface SubmitDAO {
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	공고 PK로 제출한 이력서들을 페이징해서 담아오는 메서드
	 * </p>
	 * 
	 * @param int RecruitmentUid
	 * @param PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO
	 * @return 이력서 상세정보를 담은 리스트
	 * @throws Exception
	 *
	 */
	List<ResumeDetailInfoBySubmit> selectResumDetailInfoBySubmitByRecruitmentUid(int RecruitmentUid, 
			PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO) throws Exception;
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고에 제출한 이력서 row수를 가져오는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 조건에 맞는 이력서의 총 row 수
	 * @throws Exception
	 *
	 */
	int selectTotalCountRowOfResumeByUid(int uid) throws Exception;
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 이력서에 있는 파일을 조회하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 이력서에 저장된 파일 리스트
	 * @throws Exception
	 *
	 */
	List<ResumeUpfileDTO> selectUpfileListByResume(int uid) throws Exception;
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *  제출 이력의 상태를 변경 해주는 메서드
	 * </p>
	 * 
	 * @param Status status
	 * @param int resumePk
	 * @param int recruitmentNoticePk
	 * @return 상태 변경을 성공 하면 1, 실패 하면 0
	 *
	 */
	int updateStatusByRegistration(Status status, int resumePk, int recruitmentNoticePk);


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 대기중인 제출 이력의 상태를 만료됨으로 변경 해주는 메서드
	 * </p>
	 * 
	 * @param String yesterDayStr
	 * @return 상태가 변경된 이력의 row 갯수
	 *
	 */
	int updateStatusToExpired(String yesterDayStr);


	int countBySubmittedDateBetween(LocalDateTime start, LocalDateTime end);


	int updateStatusToExpiredBetween(Map<String, Object> param);


	List<Map<String, Object>> selectExpiredSubmitUserMessageInfoBetween(Map<String, Object> param);


	MessageTargetInfoDTO selectMessageTargetInfo(int resumePk, int recruitmentNoticePk);


	List<RegistrationVO> selectRegistrationByUidAndStatus(int uid, Status status);
	
	void updateExpiredByRecUid(int uid) throws Exception;

	
	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 공고에 제출된 검색조건에 맞는 신청서의 총 갯수를 가져오는 메서드
	 * </p>
	 * 
	 * @param SubmitSearchDTO dto 검색조건과 공고uid를 담은 DTO
	 * @return int 검색 조건에 맞는 신청서 갯수
	 *
	 */
	int countResumesByRecruitmentUid(SubmitSearchDTO dto) throws Exception;

	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 공고에 제출된 신청서를 검색조건에 따라 가져오는 메서드
	 * </p>
	 * 
	 * @param SubmitSearchDTO dto 검색조건과 공고uid를 담은 DTO
	 * @return 검색 조건에 맞는 SubmitFromRecruitVO 리스트
	 *
	 */
	List<SubmitFromRecruitVO> selectResumesByRecruitmentUid(SubmitSearchDTO dto) throws Exception;

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
	ResumeDetailInfoBySubmitAndUser selectSubmitAndResumeDetailInfo(int registrationNo) throws Exception;


	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 신청서가 제출된 공고의 작성기업 uid 가져오는 메서드
	 * </p>
	 * 
	 * @param int registrationNo 신청서 pk
	 * @return 신청서가 제출된 공고의 작성기업 uid
	 *
	 */
	int getCompanyUidByRegistrationNo(int registrationNo) throws Exception;



	List<SubmitFromUserVO> selectSubmitFromUser(SubmitSearchDTO dto) throws Exception;


	int countSubmitFromUser(SubmitSearchDTO dto) throws Exception;

	List<UserVO> selectUsersWhoApplied(int Recruitmentuid) throws Exception;


	List<UserVO> selectUsersWhoAppliedPaged(int uid, int pageIndex, int pageSize) throws Exception;

	
	
}
