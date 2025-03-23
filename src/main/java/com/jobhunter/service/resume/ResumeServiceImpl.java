package com.jobhunter.service.resume;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.resume.ResumeDAO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SubCategoryDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ResumeServiceImpl implements ResumeService {

	private final ResumeDAO rdao;

	@Override
	@Transactional
	public void tempSaveResume(ResumeDTO resumeDTO) {
		rdao.insertResumeTemp(resumeDTO); // resumeNo 자동 세팅

		// 고용형태 저장
		if (resumeDTO.getJobForms() != null) {
			for (JobFormDTO jobForm : resumeDTO.getJobForms()) {
				jobForm.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertJobForm(jobForm);
			}
		}

		// 지역 저장
		if (resumeDTO.getSigunguNos() != null) {
			for (Integer sigunguNo : resumeDTO.getSigunguNos()) {
				rdao.insertSigungu(resumeDTO.getResumeNo(), sigunguNo);
			}
		}

		// 업직종 대분류 저장
		if (resumeDTO.getMajorcategoryNos() != null) {
			for (Integer majorNo : resumeDTO.getMajorcategoryNos()) {
				rdao.insertMajorCategory(resumeDTO.getResumeNo(), majorNo);
			}
		}

		// 업직종 소분류 저장
		if (resumeDTO.getSubcategoryNos() != null) {
			for (Integer subcategoryNo : resumeDTO.getSubcategoryNos()) {
				rdao.insertSubCategory(resumeDTO.getResumeNo(), subcategoryNo);
			}
		}
	}

	@Override
	@Transactional
	public void finalSaveResume(ResumeDTO resumeDTO) {
		rdao.insertResumeFinal(resumeDTO); // resumeNo 자동 세팅

		if (resumeDTO.getJobForms() != null) {
			for (JobFormDTO jobForm : resumeDTO.getJobForms()) {
				jobForm.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertJobForm(jobForm);
			}
		}

		if (resumeDTO.getSigunguNos() != null) {
			for (Integer sigunguNo : resumeDTO.getSigunguNos()) {
				rdao.insertSigungu(resumeDTO.getResumeNo(), sigunguNo);
			}
		}

		// 업직종 대분류 저장
		if (resumeDTO.getMajorcategoryNos() != null) {
			for (Integer majorNo : resumeDTO.getMajorcategoryNos()) {
				rdao.insertMajorCategory(resumeDTO.getResumeNo(), majorNo);
			}
		}

		// 업직종 소분류 저장
		if (resumeDTO.getSubcategoryNos() != null) {
			for (Integer subcategoryNo : resumeDTO.getSubcategoryNos()) {
				rdao.insertSubCategory(resumeDTO.getResumeNo(), subcategoryNo);
			}
		}
	}

	@Override
	public List<RegionDTO> getAllRegions() {
		return rdao.selectAllRegions();
	}

	@Override
	public List<SigunguDTO> getSigunguByRegion(int regionNo) {
		return rdao.selectSigunguByRegion(regionNo);
	}

	@Override
	public List<MajorCategoryDTO> getAllMajorCategories() {
		return rdao.selectAllMajorCategories();
	}

	@Override
	public List<SubCategoryDTO> getSubCategoriesByMajor(int majorcategoryNo) {
		return rdao.selectSubCategoriesByMajor(majorcategoryNo);
	}

}
