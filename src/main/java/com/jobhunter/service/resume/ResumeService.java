package com.jobhunter.service.resume;

import java.util.List;

import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.model.resume.ResumeAdviceDTO;
import com.jobhunter.model.resume.ResumeAdviceUpfileDTO;

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

	// 이력서 첨삭 상태 확인
	boolean isResumeAdvice(int resumeNo) throws Exception;

	void saveAdvice(ResumeAdviceDTO adviceDTO);

	void deleteExistingAdvice(int resumeNo, int mentorUid);

	ResumeAdviceDTO getAdvice(int resumeNo);

	List<ResumeAdviceUpfileDTO> getAdviceFiles(int adviceNo);
	
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
	boolean submitAdvice(int mentorUid, int resumeNo) throws Exception;

	int getRegistrationAdviceNo(int mentorUid, int resumeNo);
}
