package com.jobhunter.service.resume;

import java.util.List;

import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;

public interface ResumeService {
	void tempSaveResume(ResumeDTO resumeDTO) throws Exception;
    void finalSaveResume(ResumeDTO resumeDTO) throws Exception;
    

    List<RegionDTO> getAllRegions() throws Exception;
    List<SigunguDTO> getSigunguByRegion(int regionNo) throws Exception;
    
    List<MajorCategoryDTO> getAllMajorCategories() throws Exception;
    List<SubCategoryDTO> getSubCategoriesByMajor(int majorcategoryNo) throws Exception;

    // 이력서 목록 조회
    List<ResumeVO> getResumeList(int userUid, int page, int pageSize) throws Exception;
    int getTotalResumes(int userUid) throws Exception;
    List<SigunguVO> getResumeSigungu(int resumeNo) throws Exception;
    List<SubCategoryVO> getResumeSubCategory(int resumeNo) throws Exception;
}
