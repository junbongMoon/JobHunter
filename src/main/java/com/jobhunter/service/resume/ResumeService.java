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

public interface ResumeService {

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
}
