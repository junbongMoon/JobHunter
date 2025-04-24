package com.jobhunter.dao.resume;

import java.util.List;

import com.jobhunter.model.resume.EducationDTO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.LicenseDTO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.MeritDTO;
import com.jobhunter.model.resume.MyRegistrationAdviceSearchDTO;
import com.jobhunter.model.resume.PersonalHistoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.RegistrationAdviceVO;
import com.jobhunter.model.resume.ResumeAdviceDTO;
import com.jobhunter.model.resume.ResumeAdviceUpfileDTO;
import com.jobhunter.model.resume.ResumeAdviceVO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;
import com.jobhunter.model.user.UserVO;

public interface ResumeDAO {
	// 이력서 저장
	void insertResumeFinal(ResumeDTO resumeDTO);
	
	// 이력서 저장 - 부가정보
	void insertJobForm(JobFormDTO jobFormDTO) throws Exception;

	void insertSigungu(int resumeNo, int sigunguNo);

	void insertSubCategory(int resumeNo, int subcategoryNo);

	// 카테고리 가져오기
	List<RegionDTO> selectAllRegions() throws Exception;

	List<SigunguDTO> selectSigunguByRegion(int regionNo) throws Exception;

	List<MajorCategoryDTO> selectAllMajorCategories() throws Exception;

	List<SubCategoryDTO> selectSubCategoriesByMajor(int majorcategoryNo) throws Exception;
	
	// 이력서 저장 - 부가정보
	void insertMerit(MeritDTO meritDTO) throws Exception;

	void insertEducation(EducationDTO educationDTO) throws Exception;

	void insertHistory(PersonalHistoryDTO historyDTO) throws Exception;

	void insertLicense(LicenseDTO licenseDTO) throws Exception;

	void insertResumeUpfile(ResumeUpfileDTO resumeUpfileDTO) throws Exception;

	// 이력서 목록 조회
	List<ResumeVO> selectResumeList(int userUid, int page, int pageSize, String searchTitle) throws Exception;

	int selectTotalResumes(int userUid, String searchTitle) throws Exception;

	List<SigunguVO> selectResumeSigungu(int resumeNo) throws Exception;

	List<SubCategoryVO> selectResumeSubCategory(int resumeNo) throws Exception;
	
	// 이력서 삭제
	List<ResumeUpfileDTO> selectResumeUpfile(int resumeNo) throws Exception;

	void deleteResume(int resumeNo) throws Exception;

	// 이력서 상세 조회(파일 조회는 재사용)
	ResumeDTO selectResumeDetail(int resumeNo) throws Exception;

	List<JobFormDTO> selectResumeJobForms(int resumeNo) throws Exception;

	List<MeritDTO> selectResumeMerits(int resumeNo) throws Exception;

	List<EducationDTO> selectResumeEducations(int resumeNo) throws Exception;

	List<PersonalHistoryDTO> selectResumeHistories(int resumeNo) throws Exception;

	List<LicenseDTO> selectResumeLicenses(int resumeNo) throws Exception;

	// 이력서 수정
	void updateResume(ResumeDTO resumeDTO) throws Exception;
	
	void deleteJobForms(int resumeNo) throws Exception;
	
	void deleteMerits(int resumeNo) throws Exception;
	
	void deleteResumeSigungu(int resumeNo) throws Exception;
	
	void deleteResumeSubCategory(int resumeNo) throws Exception;
	
	void deleteEducations(int resumeNo) throws Exception;
	
	void deleteHistories(int resumeNo) throws Exception;
	
	void deleteLicenses(int resumeNo) throws Exception;
	
	void deleteResumeUpfiles(int resumeNo) throws Exception;

	// 유저정보 조회
	UserVO selectUserInfo(int userUid) throws Exception;
	
	// 이력서 제출
	void insertRegistration(int resumeNo, int recruitmentNo) throws Exception;
	
	// 중복 지원 확인
	int checkExistingRegistration(int userUid, int recruitmentNo) throws Exception;
	
	// 이력서 상태 확인
	int checkResumeStatus(int resumeNo) throws Exception;

	void insertAdvice(ResumeAdviceDTO adviceDTO) throws Exception;

	void insertAdviceFile(ResumeAdviceUpfileDTO fileDTO) throws Exception; 

	void deleteExistingAdvice(int resumeNo, int mentorUid) throws Exception;

	ResumeAdviceDTO selectAdvice(int resumeNo) throws Exception;

	List<RegistrationAdviceVO> selectRegistrationAdviceByMentorWithPaging(MyRegistrationAdviceSearchDTO dto);

	int countRegistrationAdviceByMentor(MyRegistrationAdviceSearchDTO dto);

	List<ResumeAdviceVO> selectResumeAdviceByUserUid(int uid, int offset);

	int countResumeAdviceByUserUid(int uid);

	List<ResumeAdviceUpfileDTO> selectAdviceFiles(int adviceNo) throws Exception;

	ResumeAdviceDTO getAdvice(int resumeNo) throws Exception;
	List<ResumeAdviceUpfileDTO> getAdviceFiles(int adviceNo) throws Exception;

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 신청을 저장하는 메서드
	 * </p>
	 * 
	 * @param int mentorUid 첨삭자 UID
	 * @param int resumeNo 이력서 번호
	 * @return 성공하면 1, 실패하면 0
	 *
	 */
	int insertRegistrationAdvice(int mentorUid, int resumeNo) throws Exception;
	
	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 신청 중복 여부를 확인하는 메서드
	 * </p>
	 * 
	 * @param int mentorUid 첨삭자 UID
	 * @param int resumeNo 이력서 번호
	 * @return 중복이면 1 이상, 중복이 아니면 0
	 *
	 */
	int checkDuplicateAdvice(int mentorUid, int resumeNo) throws Exception;

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 상태를 확인하는 메서드
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @return 첨삭 상태
	 */
	int checkResumeAdvice(int resumeNo) throws Exception;

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 신청 번호를 가져오는 메서드
	 * </p>
	 * 
	 * @param int mentorUid 첨삭자 UID
	 * @param int resumeNo 이력서 번호
	 * @return 첨삭 신청 번호
	 */
	int getRegistrationAdviceNo(int mentorUid, int resumeNo) throws Exception;

	// /**
	//  *  @author 유지원
	//  *
	//  * <p>
	//  * 이력서 첨삭 승인을 처리하는 메서드
	//  * </p>
	//  * 
	//  * @param int resumeNo 이력서 번호
	//  * @param int userUid 유저 UID
	//  * @return 성공 여부
	//  */
	// void acceptAdvice(int resumeNo, int userUid, String status) throws Exception;
	
	// /**
	//  *  @author 유지원
	//  *
	//  * <p>
	//  * 이력서 첨삭 거절을 처리하는 메서드
	//  * </p>
	//  * 
	//  * @param int resumeNo 이력서 번호
	//  * @param int userUid 유저 UID
	//  * @return 성공 여부
	//  */
	// void rejectAdvice(int resumeNo, int userUid, String status) throws Exception;

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 상태를 변경하는 메서드
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @param int userUid 유저 UID
	 * @param String status 첨삭 상태
	 * @return 성공 여부
	 */
	int changeAdviceStatus(int resumeNo, int userUid, String status) throws Exception;

}
