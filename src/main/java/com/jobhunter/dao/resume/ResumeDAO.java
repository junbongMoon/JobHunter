package com.jobhunter.dao.resume;

import java.util.List;

import com.jobhunter.model.resume.EducationDTO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.LicenseDTO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.MeritDTO;
import com.jobhunter.model.resume.PersonalHistoryDTO;
import com.jobhunter.model.resume.RegionDTO;
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
	List<ResumeVO> selectResumeList(int userUid, int page, int pageSize) throws Exception;

	int selectTotalResumes(int userUid) throws Exception;

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
}
