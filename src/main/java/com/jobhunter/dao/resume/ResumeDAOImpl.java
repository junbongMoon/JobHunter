package com.jobhunter.dao.resume;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

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

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ResumeDAOImpl implements ResumeDAO {

	private final SqlSession ses;

	private static final String NS = "com.jobhunter.mapper.resumemapper";


	@Override
	public void insertResumeFinal(ResumeDTO resumeDTO) {
		ses.insert(NS + ".insertResumeFinal", resumeDTO);
	}

	@Override
	public void insertJobForm(JobFormDTO jobFormDTO) {
		ses.insert(NS + ".insertJobForm", jobFormDTO);
	}

	@Override
	public void insertSigungu(int resumeNo, int sigunguNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("resumeNo", resumeNo);
		map.put("sigunguNo", sigunguNo);
		ses.insert(NS + ".insertSigungu", map);
	}


	@Override
	public void insertSubCategory(int resumeNo, int subcategoryNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("resumeNo", resumeNo);
		map.put("subcategoryNo", subcategoryNo);
		ses.insert(NS + ".insertSubCategory", map);
	}

	@Override
	public List<RegionDTO> selectAllRegions() {
		return ses.selectList(NS + ".selectAllRegions");
	}

	@Override
	public List<SigunguDTO> selectSigunguByRegion(int regionNo) {
		return ses.selectList(NS + ".selectSigunguByRegion", regionNo);
	}

	@Override
	public List<MajorCategoryDTO> selectAllMajorCategories() {
		return ses.selectList(NS + ".selectAllMajorCategories");
	}

	@Override
	public List<SubCategoryDTO> selectSubCategoriesByMajor(int majorcategoryNo) {
		return ses.selectList(NS + ".selectSubCategoriesByMajor", majorcategoryNo);
	}

	@Override
	public void insertMerit(MeritDTO meritDTO) throws Exception {
		ses.insert(NS + ".insertMerit", meritDTO);
	}

	@Override
	public void insertEducation(EducationDTO educationDTO) throws Exception {
		ses.insert(NS + ".insertEducation", educationDTO);
	}

	@Override
	public void insertHistory(PersonalHistoryDTO historyDTO) throws Exception {
		ses.insert(NS + ".insertHistory", historyDTO);
	}

	@Override
	public void insertLicense(LicenseDTO licenseDTO) throws Exception {
		ses.insert(NS + ".insertLicense", licenseDTO);
	}
	
	@Override
	public void insertResumeUpfile(ResumeUpfileDTO resumeUpfileDTO) throws Exception {
		ses.insert(NS + ".insertResumeUpfile", resumeUpfileDTO);
	}

	@Override
	public List<ResumeVO> selectResumeList(int userUid, int page, int pageSize, String searchTitle) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("userUid", userUid);
		params.put("offset", (page - 1) * pageSize);
		params.put("pageSize", pageSize);
		params.put("searchTitle", searchTitle);
		return ses.selectList(NS + ".selectResumeList", params);
	}

	@Override
	public int selectTotalResumes(int userUid, String searchTitle) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("userUid", userUid);
		params.put("searchTitle", searchTitle);
		return ses.selectOne(NS + ".selectTotalResumes", params);
	}

	@Override
	public List<SigunguVO> selectResumeSigungu(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeSigungu", resumeNo);
	}

	@Override
	public List<SubCategoryVO> selectResumeSubCategory(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeSubCategory", resumeNo);
	}
	
	// 이력서 삭제
	@Override
	public List<ResumeUpfileDTO> selectResumeUpfile(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeUpfile", resumeNo);
	}

	@Override
	public void deleteResume(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteResume", resumeNo);
	}
	
	// 이력서 상세 조회
	@Override
	public ResumeDTO selectResumeDetail(int resumeNo) throws Exception {
		return ses.selectOne(NS + ".selectResumeDetail", resumeNo);
	}

	@Override
	public List<JobFormDTO> selectResumeJobForms(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeJobForms", resumeNo);
	}

	@Override
	public List<MeritDTO> selectResumeMerits(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeMerits", resumeNo);
	}

	@Override
	public List<EducationDTO> selectResumeEducations(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeEducations", resumeNo);
	}

	@Override
	public List<PersonalHistoryDTO> selectResumeHistories(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeHistories", resumeNo);
	}

	@Override
	public List<LicenseDTO> selectResumeLicenses(int resumeNo) throws Exception {
		return ses.selectList(NS + ".selectResumeLicenses", resumeNo);
	}

	@Override
	public void updateResume(ResumeDTO resumeDTO) throws Exception {
		ses.update(NS + ".updateResume", resumeDTO);
	}

	@Override
	public void deleteJobForms(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteJobForms", resumeNo);
	}

	@Override
	public void deleteMerits(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteMerits", resumeNo);
	}

	@Override
	public void deleteResumeSigungu(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteResumeSigungu", resumeNo);
	}

	@Override
	public void deleteResumeSubCategory(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteResumeSubCategory", resumeNo);
	}

	@Override
	public void deleteEducations(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteEducations", resumeNo);
	}

	@Override
	public void deleteHistories(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteHistories", resumeNo);
	}

	@Override
	public void deleteLicenses(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteLicenses", resumeNo);
	}

	@Override
	public void deleteResumeUpfiles(int resumeNo) throws Exception {
		ses.delete(NS + ".deleteResumeUpfiles", resumeNo);
	}

	@Override
	public UserVO selectUserInfo(int userUid) throws Exception {
		return ses.selectOne(NS + ".selectUserInfo", userUid);
	}
	
	@Override
	public void insertRegistration(int resumeNo, int recruitmentNo) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("resumeNo", resumeNo);
		map.put("recruitmentNo", recruitmentNo);
		ses.insert(NS + ".insertRegistration", map);
	}
	
	@Override
	public int checkExistingRegistration(int userUid, int recruitmentNo) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("userUid", userUid);
		map.put("recruitmentNo", recruitmentNo);
		return ses.selectOne(NS + ".checkExistingRegistration", map);
	}

	@Override
	public int checkResumeStatus(int resumeNo) throws Exception {
		return ses.selectOne(NS + ".checkResumeStatus", resumeNo);
	}
}
