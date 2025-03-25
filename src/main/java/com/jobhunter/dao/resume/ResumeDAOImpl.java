package com.jobhunter.dao.resume;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.resume.EducationDTO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.MeritDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SubCategoryDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ResumeDAOImpl implements ResumeDAO {

	private final SqlSession ses;

	private static final String NS = "com.jobhunter.mapper.resumemapper";

	@Override
	public void insertResumeTemp(ResumeDTO resumeDTO) {
		ses.insert(NS + ".insertResumeTemp", resumeDTO);
	}

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
	
	
	


}
