package com.jobhunter.service.resume;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.resume.ResumeDAO;
import com.jobhunter.model.resume.EducationDTO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.LicenseDTO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.MeritDTO;
import com.jobhunter.model.resume.PersonalHistoryDTO;
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
	public void tempSaveResume(ResumeDTO resumeDTO) throws Exception {
		rdao.insertResumeTemp(resumeDTO); // resumeNo 세팅

		// 고용형태 저장
		if (resumeDTO.getJobForms() != null && !resumeDTO.getJobForms().isEmpty()) {
			for (JobFormDTO jobForm : resumeDTO.getJobForms()) {
				jobForm.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertJobForm(jobForm);
			}
		}
		
		// 성격 및 장점 저장
		if (resumeDTO.getMerits() != null && !resumeDTO.getMerits().isEmpty()) {
			for (MeritDTO merit : resumeDTO.getMerits()) {
				merit.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertMerit(merit);
			}
		}

		// 지역 저장
		if (resumeDTO.getSigunguNos() != null && !resumeDTO.getSigunguNos().isEmpty()) {
			for (Integer sigunguNo : resumeDTO.getSigunguNos()) {
				rdao.insertSigungu(resumeDTO.getResumeNo(), sigunguNo);
			}
		}

		// 업직종 저장
		if (resumeDTO.getSubcategoryNos() != null && !resumeDTO.getSubcategoryNos().isEmpty()) {
			for (Integer subcategoryNo : resumeDTO.getSubcategoryNos()) {
				rdao.insertSubCategory(resumeDTO.getResumeNo(), subcategoryNo);
			}
		}

		// 학력 저장
		if (resumeDTO.getEducations() != null && !resumeDTO.getEducations().isEmpty()) {
			for (EducationDTO education : resumeDTO.getEducations()) {
				education.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertEducation(education);
			}
		}

		// 경력 저장
		if (resumeDTO.getHistories() != null && !resumeDTO.getHistories().isEmpty()) {
			for (PersonalHistoryDTO history : resumeDTO.getHistories()) {
				history.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertHistory(history);
			}
		}

		// 자격증 저장
		if (resumeDTO.getLicenses() != null && !resumeDTO.getLicenses().isEmpty()) {
			for (LicenseDTO license : resumeDTO.getLicenses()) {
				license.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertLicense(license);
			}
		}
	}

	@Override
	@Transactional
	public void finalSaveResume(ResumeDTO resumeDTO) throws Exception {
		rdao.insertResumeFinal(resumeDTO); // resumeNo 세팅

		// 고용형태 저장
		if (resumeDTO.getJobForms() != null && !resumeDTO.getJobForms().isEmpty()) {
			for (JobFormDTO jobForm : resumeDTO.getJobForms()) {
				jobForm.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertJobForm(jobForm);
			}
		}

		// 성격 및 장점 저장
		if (resumeDTO.getMerits() != null && !resumeDTO.getMerits().isEmpty()) {
			for (MeritDTO merit : resumeDTO.getMerits()) {
				merit.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertMerit(merit);
			}
		}

		// 지역 저장
		if (resumeDTO.getSigunguNos() != null && !resumeDTO.getSigunguNos().isEmpty()) {
			for (Integer sigunguNo : resumeDTO.getSigunguNos()) {
				rdao.insertSigungu(resumeDTO.getResumeNo(), sigunguNo);
			}
		}

		// 업직종 저장
		if (resumeDTO.getSubcategoryNos() != null && !resumeDTO.getSubcategoryNos().isEmpty()) {
			for (Integer subcategoryNo : resumeDTO.getSubcategoryNos()) {
				rdao.insertSubCategory(resumeDTO.getResumeNo(), subcategoryNo);
			}
		}

		// 학력 저장
		if (resumeDTO.getEducations() != null && !resumeDTO.getEducations().isEmpty()) {
			for (EducationDTO education : resumeDTO.getEducations()) {
				education.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertEducation(education);
			}
		}

		// 경력 저장
		if (resumeDTO.getHistories() != null && !resumeDTO.getHistories().isEmpty()) {
			for (PersonalHistoryDTO history : resumeDTO.getHistories()) {
				history.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertHistory(history);
			}
		}

		// 자격증 저장
		if (resumeDTO.getLicenses() != null && !resumeDTO.getLicenses().isEmpty()) {
			for (LicenseDTO license : resumeDTO.getLicenses()) {
				license.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertLicense(license);
			}
		}
	}

	// 카테고리 가져오기
	@Override
	public List<RegionDTO> getAllRegions() throws Exception {
		return rdao.selectAllRegions();
	}

	@Override
	public List<SigunguDTO> getSigunguByRegion(int regionNo) throws Exception {
		return rdao.selectSigunguByRegion(regionNo);
	}

	@Override
	public List<MajorCategoryDTO> getAllMajorCategories() throws Exception {
		return rdao.selectAllMajorCategories();
	}

	@Override
	public List<SubCategoryDTO> getSubCategoriesByMajor(int majorcategoryNo) throws Exception {
		return rdao.selectSubCategoriesByMajor(majorcategoryNo);
	}

}
