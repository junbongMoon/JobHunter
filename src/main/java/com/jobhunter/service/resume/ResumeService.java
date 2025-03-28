package com.jobhunter.service.resume;

import java.util.List;

import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SubCategoryDTO;

public interface ResumeService {
	void tempSaveResume(ResumeDTO resumeDTO) throws Exception;
    void finalSaveResume(ResumeDTO resumeDTO) throws Exception;
    

    List<RegionDTO> getAllRegions() throws Exception;
    List<SigunguDTO> getSigunguByRegion(int regionNo) throws Exception;
    
    List<MajorCategoryDTO> getAllMajorCategories() throws Exception;
    List<SubCategoryDTO> getSubCategoriesByMajor(int majorcategoryNo) throws Exception;
}
