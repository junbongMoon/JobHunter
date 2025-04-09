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
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;
import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ResumeServiceImpl implements ResumeService {

	private final ResumeDAO rdao;

	@Override
	@Transactional
	public void finalSaveResume(ResumeDTO resumeDTO) throws Exception {
		rdao.insertResumeFinal(resumeDTO); // resumeNo 세팅
		// 아래 저장하는 코드 재사용 가능하게 묶기(?)
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

		// 파일 저장
		if (resumeDTO.getFiles() != null && !resumeDTO.getFiles().isEmpty()) {
			for (ResumeUpfileDTO upfile : resumeDTO.getFiles()) {
				upfile.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertResumeUpfile(upfile);
			}
		}
	}

	@Override
	@Transactional
	public void updateResume(ResumeDTO resumeDTO) throws Exception {
		// 기존 데이터 삭제
		rdao.deleteJobForms(resumeDTO.getResumeNo());
		rdao.deleteMerits(resumeDTO.getResumeNo());
		rdao.deleteResumeSigungu(resumeDTO.getResumeNo());
		rdao.deleteResumeSubCategory(resumeDTO.getResumeNo());
		rdao.deleteEducations(resumeDTO.getResumeNo());
		rdao.deleteHistories(resumeDTO.getResumeNo());
		rdao.deleteLicenses(resumeDTO.getResumeNo());
		
		// 기본 정보 업데이트
		rdao.updateResume(resumeDTO);
		
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

		// 파일 처리
		if (resumeDTO.getFiles() != null && !resumeDTO.getFiles().isEmpty()) {
			rdao.deleteResumeUpfiles(resumeDTO.getResumeNo());
			for (ResumeUpfileDTO upfile : resumeDTO.getFiles()) {
				upfile.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertResumeUpfile(upfile);
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

	// 이력서 리스트 조회
	@Override
	public List<ResumeVO> getResumeList(int userUid, int page, int pageSize) throws Exception {
		List<ResumeVO> resumeList = rdao.selectResumeList(userUid, page, pageSize);

		// 각 이력서에 대해 시군구와 업직종 정보를 설정
		for (ResumeVO resume : resumeList) {
			List<SigunguVO> sigunguList = rdao.selectResumeSigungu(resume.getResumeNo());
			List<SubCategoryVO> subCategoryList = rdao.selectResumeSubCategory(resume.getResumeNo());
			resume.setSigunguList(sigunguList);
			resume.setSubcategoryList(subCategoryList);
		}

		return resumeList;
	}

	@Override
	public int getTotalResumes(int userUid) throws Exception {
		return rdao.selectTotalResumes(userUid);
	}

	@Override
	public List<SigunguVO> getResumeSigungu(int resumeNo) throws Exception {
		return rdao.selectResumeSigungu(resumeNo);
	}

	@Override
	public List<SubCategoryVO> getResumeSubCategory(int resumeNo) throws Exception {
		return rdao.selectResumeSubCategory(resumeNo);
	}

	@Override
	public List<ResumeUpfileDTO> selectResumeUpfile(int resumeNo) throws Exception {
		return rdao.selectResumeUpfile(resumeNo);
	}

	@Override
	public void deleteResume(int resumeNo) throws Exception {
		rdao.deleteResume(resumeNo);
	}

	// 이력서 수정을 위한 해당 이력서 정보 조회
	@Override
	public ResumeDetailDTO getResumeDetailWithAll(int resumeNo) throws Exception {
		ResumeDetailDTO resumeDetail = new ResumeDetailDTO();
		resumeDetail.setResume(rdao.selectResumeDetail(resumeNo));
		resumeDetail.setJobForms(rdao.selectResumeJobForms(resumeNo));
		resumeDetail.setMerits(rdao.selectResumeMerits(resumeNo));
		resumeDetail.setEducations(rdao.selectResumeEducations(resumeNo));
		resumeDetail.setHistories(rdao.selectResumeHistories(resumeNo));
		resumeDetail.setLicenses(rdao.selectResumeLicenses(resumeNo));
		resumeDetail.setFiles(rdao.selectResumeUpfile(resumeNo));
		return resumeDetail;
	}

	// 유저정보 조회
	@Override
	public UserVO getUserInfo(int userUid) throws Exception {
		return rdao.selectUserInfo(userUid);
	}
}
