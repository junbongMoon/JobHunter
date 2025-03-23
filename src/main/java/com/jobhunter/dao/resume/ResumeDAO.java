package com.jobhunter.dao.resume;

import java.util.List;

import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SubCategoryDTO;

public interface ResumeDAO {
	void insertResumeTemp(ResumeDTO resumeDTO);

	void insertResumeFinal(ResumeDTO resumeDTO);

	void insertJobForm(JobFormDTO jobFormDTO);

	void insertSigungu(int resumeNo, int sigunguNo);

	void insertSubCategory(int resumeNo, int subcategoryNo);

	List<RegionDTO> selectAllRegions();

	List<SigunguDTO> selectSigunguByRegion(int regionNo);

	List<MajorCategoryDTO> selectAllMajorCategories();

	List<SubCategoryDTO> selectSubCategoriesByMajor(int majorcategoryNo);
}
