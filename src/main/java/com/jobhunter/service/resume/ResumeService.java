package com.jobhunter.service.resume;

import java.util.List;

import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SubCategoryDTO;

public interface ResumeService {
	void tempSaveResume(ResumeDTO resumeDTO);
    void finalSaveResume(ResumeDTO resumeDTO);

    List<RegionDTO> getAllRegions();
    List<SigunguDTO> getSigunguByRegion(int regionNo);
    
    List<MajorCategoryDTO> getAllMajorCategories();
    List<SubCategoryDTO> getSubCategoriesByMajor(int majorcategoryNo);
}
