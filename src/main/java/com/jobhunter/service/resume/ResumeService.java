package com.jobhunter.service.resume;

import java.util.List;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.MyRegistrationAdviceSearchDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.RegistrationAdviceVO;
import com.jobhunter.model.resume.ResumeAdviceDTO;
import com.jobhunter.model.resume.ResumeAdviceUpfileDTO;
import com.jobhunter.model.resume.ResumeAdviceVO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.ResumeAdviceCommentDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.model.util.TenToFivePageVO;

public interface ResumeService {

	void finalSaveResume(ResumeDTO resumeDTO) throws Exception;

	List<RegionDTO> getAllRegions() throws Exception;

	List<SigunguDTO> getSigunguByRegion(int regionNo) throws Exception;

	List<MajorCategoryDTO> getAllMajorCategories() throws Exception;

	List<SubCategoryDTO> getSubCategoriesByMajor(int majorcategoryNo) throws Exception;

	// 이력서 목록 조회
	List<ResumeVO> getResumeList(int userUid, int page, int pageSize, String searchTitle) throws Exception;

	int getTotalResumes(int userUid, String searchTitle) throws Exception;

	List<SigunguVO> getResumeSigungu(int resumeNo) throws Exception;

	List<SubCategoryVO> getResumeSubCategory(int resumeNo) throws Exception;

	List<ResumeUpfileDTO> selectResumeUpfile(int resumeNo) throws Exception;

	void deleteResume(int resumeNo) throws Exception;

	// 이력서 상세 정보 조회
	ResumeDetailDTO getResumeDetailWithAll(int resumeNo) throws Exception;

	// 이력서 수정
	void updateResume(ResumeDTO resumeDTO) throws Exception;

	// 유저정보 조회
	UserVO getUserInfo(int userUid) throws Exception;

	// 이력서 제출
	void submitResume(int resumeNo, int recruitmentNo) throws Exception;

	// 중복 지원 확인
	boolean isResumeAlreadySubmitted(int userUid, int recruitmentNo) throws Exception;

	// 이력서 상태 확인
	boolean isResumeChecked(int resumeNo) throws Exception;

	TenToFivePageVO<RegistrationAdviceVO> selectRegistrationAdviceByMentorWithPaging(MyRegistrationAdviceSearchDTO dto);

	TenToFivePageVO<ResumeAdviceVO> selectResumeAdviceByUserUid(int uid, int page);

	// 이력서 첨삭 상태 확인
	boolean isResumeAdvice(int resumeNo) throws Exception;

	void saveAdvice(ResumeAdviceDTO adviceDTO) throws Exception;

	void deleteExistingAdvice(int resumeNo, int mentorUid) throws Exception;

	ResumeAdviceDTO getAdvice(int resumeNo, int adviceNo) throws Exception;

	List<ResumeAdviceUpfileDTO> getAdviceFiles(int adviceNo) throws Exception;
	
	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 신청을 처리하는 메서드
	 * </p>
	 * 
	 * @param int mentorUid 첨삭자 UID
	 * @param int resumeNo 이력서 번호
	 * @return 성공 여부
	 *
	 */
	boolean submitAdvice(int mentorUid, int resumeNo, int sessionUid, String dueDate) throws Exception;

	int getRegistrationAdviceNo(int mentorUid, int resumeNo) throws Exception;


	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 승인을 처리하는 메서드
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @param int userUid 첨삭자 UID
	 * @return 성공 여부
	 */
	boolean acceptAdvice(int resumeNo, int userUid) throws Exception;

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 거절을 처리하는 메서드
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @param int userUid 첨삭자 UID
	 * @param int ownerUid 이력서 주인 UID
	 * @return 성공 여부
	 */
	boolean rejectAdvice(int resumeNo, int userUid, int ownerUid) throws Exception;

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 종료를 처리하는 메서드
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @param int userUid 첨삭자 UID
	 * @param int ownerUid 이력서 주인 UID
	 * @return 성공 여부
	 */
	boolean endAdvice(int resumeNo, int userUid, int ownerUid) throws Exception;

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 코멘트를 조회하는 메서드
	 * </p>
	 * 
	 * @param int adviceNo 첨삭 번호
	 * @return 첨삭 코멘트 목록
	 */
	List<ResumeAdviceCommentDTO> getAdviceComments(int adviceNo) throws Exception;

	void expireRegistrationAdvice(AccountVO loginAcc) throws Exception;
}
