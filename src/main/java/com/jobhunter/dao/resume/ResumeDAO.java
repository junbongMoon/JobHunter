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

public interface ResumeDAO {
	void insertResumeTemp(ResumeDTO resumeDTO);

	void insertResumeFinal(ResumeDTO resumeDTO);

	void insertJobForm(JobFormDTO jobFormDTO) throws Exception;

	void insertSigungu(int resumeNo, int sigunguNo);

	void insertSubCategory(int resumeNo, int subcategoryNo);

	List<RegionDTO> selectAllRegions() throws Exception;

	List<SigunguDTO> selectSigunguByRegion(int regionNo) throws Exception;

	List<MajorCategoryDTO> selectAllMajorCategories() throws Exception;

	List<SubCategoryDTO> selectSubCategoriesByMajor(int majorcategoryNo) throws Exception;
	
	void insertMerit(MeritDTO meritDTO) throws Exception;

	void insertEducation(EducationDTO educationDTO) throws Exception;

	void insertHistory(PersonalHistoryDTO historyDTO) throws Exception;

	void insertLicense(LicenseDTO licenseDTO) throws Exception;

	void insertResumeUpfile(ResumeUpfileDTO resumeUpfileDTO) throws Exception;

	// 이력서 목록 조회
	List<ResumeVO> selectResumeList(int userUid) throws Exception;

	List<SigunguVO> selectResumeSigungu(int resumeNo) throws Exception;

	List<SubCategoryVO> selectResumeSubCategory(int resumeNo) throws Exception;
}
