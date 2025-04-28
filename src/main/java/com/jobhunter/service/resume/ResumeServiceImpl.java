package com.jobhunter.service.resume;

import java.util.Arrays;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.point.PointDAO;
import com.jobhunter.dao.resume.ResumeDAO;
import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.resume.EducationDTO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.LicenseDTO;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.MeritDTO;
import com.jobhunter.model.resume.MyRegistrationAdviceSearchDTO;
import com.jobhunter.model.resume.PersonalHistoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.RegistrationAdviceVO;
import com.jobhunter.model.resume.ResumeAdviceDTO;
import com.jobhunter.model.resume.ResumeAdviceUpfileDTO;
import com.jobhunter.model.resume.ResumeAdviceVO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.model.util.TenToFivePageVO;
import com.jobhunter.model.resume.ResumeAdviceCommentDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ResumeServiceImpl implements ResumeService {

	private final ResumeDAO rdao;
	private final PointDAO pointDAO;
	private final UserDAO userDAO;

	@Override
	@Transactional
	public void finalSaveResume(ResumeDTO resumeDTO) throws Exception {
		rdao.insertResumeFinal(resumeDTO);
		saveJobForms(resumeDTO);
		saveMerits(resumeDTO);
		saveRegions(resumeDTO);
		saveSubCategories(resumeDTO);
		saveEducations(resumeDTO);
		saveHistories(resumeDTO);
		saveLicenses(resumeDTO);
		saveFiles(resumeDTO);
	}

	@Override
	@Transactional
	public void updateResume(ResumeDTO resumeDTO) throws Exception {
		rdao.deleteJobForms(resumeDTO.getResumeNo());
		rdao.deleteMerits(resumeDTO.getResumeNo());
		rdao.deleteResumeSigungu(resumeDTO.getResumeNo());
		rdao.deleteResumeSubCategory(resumeDTO.getResumeNo());
		rdao.deleteEducations(resumeDTO.getResumeNo());
		rdao.deleteHistories(resumeDTO.getResumeNo());
		rdao.deleteLicenses(resumeDTO.getResumeNo());
		rdao.deleteResumeUpfiles(resumeDTO.getResumeNo());

		rdao.updateResume(resumeDTO);
		saveJobForms(resumeDTO);
		saveMerits(resumeDTO);
		saveRegions(resumeDTO);
		saveSubCategories(resumeDTO);
		saveEducations(resumeDTO);
		saveHistories(resumeDTO);
		saveLicenses(resumeDTO);
		saveFiles(resumeDTO);
	}

	// 고용형태 저장
	private void saveJobForms(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getJobForms() != null && !resumeDTO.getJobForms().isEmpty()) {
			for (JobFormDTO jobForm : resumeDTO.getJobForms()) {
				jobForm.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertJobForm(jobForm);
			}
		}
	}

	// 성격 및 장점 저장
	private void saveMerits(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getMerits() != null && !resumeDTO.getMerits().isEmpty()) {
			for (MeritDTO merit : resumeDTO.getMerits()) {
				merit.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertMerit(merit);
			}
		}
	}

	// 지역 저장
	private void saveRegions(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getSigunguNos() != null && !resumeDTO.getSigunguNos().isEmpty()) {
			for (Integer sigunguNo : resumeDTO.getSigunguNos()) {
				rdao.insertSigungu(resumeDTO.getResumeNo(), sigunguNo);
			}
		}
	}

	// 업직종 저장
	private void saveSubCategories(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getSubcategoryNos() != null && !resumeDTO.getSubcategoryNos().isEmpty()) {
			for (Integer subcategoryNo : resumeDTO.getSubcategoryNos()) {
				rdao.insertSubCategory(resumeDTO.getResumeNo(), subcategoryNo);
			}
		}
	}

	// 학력 저장
	private void saveEducations(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getEducations() != null && !resumeDTO.getEducations().isEmpty()) {
			for (EducationDTO education : resumeDTO.getEducations()) {
				education.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertEducation(education);
			}
		}
	}

	// 경력 저장
	private void saveHistories(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getHistories() != null && !resumeDTO.getHistories().isEmpty()) {
			for (PersonalHistoryDTO history : resumeDTO.getHistories()) {
				history.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertHistory(history);
			}
		}
	}

	// 자격증 저장
	private void saveLicenses(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getLicenses() != null && !resumeDTO.getLicenses().isEmpty()) {
			for (LicenseDTO license : resumeDTO.getLicenses()) {
				license.setResumeNo(resumeDTO.getResumeNo());
				rdao.insertLicense(license);
			}
		}
	}

	// 파일 저장
	private void saveFiles(ResumeDTO resumeDTO) throws Exception {
		if (resumeDTO.getFiles() != null && !resumeDTO.getFiles().isEmpty()) {
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
	public List<ResumeVO> getResumeList(int userUid, int page, int pageSize, String searchTitle) throws Exception {
		List<ResumeVO> resumeList = rdao.selectResumeList(userUid, page, pageSize, searchTitle);

		// 각 이력서에 대해 시군구와 업직종 정보를 설정
		for (ResumeVO resume : resumeList) {
			List<SigunguVO> sigunguList = rdao.selectResumeSigungu(resume.getResumeNo());
			List<SubCategoryVO> subCategoryList = rdao.selectResumeSubCategory(resume.getResumeNo());
			resume.setSigunguList(sigunguList);
			resume.setSubcategoryList(subCategoryList);

			// 이력서 상태 확인
			resume.setChecked(rdao.checkResumeStatus(resume.getResumeNo()) > 0);
			// 이력서 첨삭 상태 확인
			resume.setAdvice(rdao.checkResumeAdvice(resume.getResumeNo()) > 0);
		}

		return resumeList;
	}

	@Override
	public int getTotalResumes(int userUid, String searchTitle) throws Exception {
		return rdao.selectTotalResumes(userUid, searchTitle);
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

	// 이력서 제출
	@Override
	public void submitResume(int resumeNo, int recruitmentNo) throws Exception {
		rdao.insertRegistration(resumeNo, recruitmentNo);
	}
	
	// 유저가 공고에 이력서 제출하였는가 확인
	@Override
	public boolean isResumeAlreadySubmitted(int userUid, int recruitmentNo) throws Exception {
		int count = rdao.checkExistingRegistration(userUid, recruitmentNo);
		System.out.println("count: " + count);
		return count > 0;
	}

	// 기업에서 확인중인 공고인가
	@Override
	public boolean isResumeChecked(int resumeNo) throws Exception {
		return rdao.checkResumeStatus(resumeNo) > 0;
	}

	// 이력서 첨삭 상태 확인
	@Override
	public boolean isResumeAdvice(int resumeNo) throws Exception {
		return rdao.checkResumeAdvice(resumeNo) > 0;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public void saveAdvice(ResumeAdviceDTO adviceDTO) throws Exception {
		// 기존 첨삭 내용 삭제
		rdao.deleteExistingAdvice(adviceDTO.getResumeNo(), adviceDTO.getMentorUid());
		
		// 첨삭 내용 저장
		rdao.insertAdvice(adviceDTO);

		if (adviceDTO.getComments() != null && !adviceDTO.getComments().isEmpty()) {
			// 첨삭 코멘트 저장
			for (ResumeAdviceCommentDTO commentDTO : adviceDTO.getComments()) {
				commentDTO.setAdviceNo(adviceDTO.getAdviceNo());
				rdao.insertAdviceComment(commentDTO);
			}
		}

		// 첨부파일 정보가 있는 경우 저장
		if (adviceDTO.getFiles() != null && !adviceDTO.getFiles().isEmpty()) {
			for (com.jobhunter.model.resume.ResumeAdviceUpfileDTO fileDTO : adviceDTO.getFiles()) {
				fileDTO.setAdviceNo(adviceDTO.getAdviceNo());
				rdao.insertAdviceFile(fileDTO);
			}
		}
	}

	@Override
	public void deleteExistingAdvice(int resumeNo, int mentorUid) throws Exception {
		rdao.deleteExistingAdvice(resumeNo, mentorUid);
	}

	@Override
	public ResumeAdviceDTO getAdvice(int resumeNo) throws Exception {
		return rdao.getAdvice(resumeNo);
	}

	@Override
	public List<ResumeAdviceUpfileDTO> getAdviceFiles(int adviceNo) throws Exception {
		return rdao.getAdviceFiles(adviceNo);
	}

	
	@Override
	public TenToFivePageVO<RegistrationAdviceVO> selectRegistrationAdviceByMentorWithPaging(MyRegistrationAdviceSearchDTO dto) {
		List<String> validStatuses = Arrays.asList("COMPLETE", "CANCEL", "WAITING", "CHECKING", "LIVE");

		if (!validStatuses.contains(dto.getStatus())) {
		    dto.setStatus(null);
		}
		List<RegistrationAdviceVO> vo = rdao.selectRegistrationAdviceByMentorWithPaging(dto);
		int totalCnt = rdao.countRegistrationAdviceByMentor(dto);
		TenToFivePageVO<RegistrationAdviceVO> result = new TenToFivePageVO<RegistrationAdviceVO>(vo, dto.getPage(), totalCnt);
		return result;
	}
	
	@Override
	public TenToFivePageVO<ResumeAdviceVO> selectResumeAdviceByUserUid(int uid, int page) {
		int offset = (page - 1) * 5;
		List<ResumeAdviceVO> vo = rdao.selectResumeAdviceByUserUid(uid, offset);
		int totalCnt = rdao.countResumeAdviceByUserUid(uid);
		TenToFivePageVO<ResumeAdviceVO> result = new TenToFivePageVO<ResumeAdviceVO>(vo, page, totalCnt);
		return result;
    }

/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 신청을 처리하는 메서드
	 * </p>
	 * 
	 * @param int mentorUid 첨삭자 UID
	 * @param int resumeNo 이력서 번호
	 * @return 성공 여부
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean submitAdvice(int mentorUid, int resumeNo, int sessionUid, String dueDate) throws Exception {
		// 중복 신청 확인
		int duplicateCount = rdao.checkDuplicateAdvice(mentorUid, resumeNo);
		if (duplicateCount > 0) {
			return false; // 중복 신청이 있으면 실패
		} else {
			// 첨삭 신청 저장
			int result = rdao.insertRegistrationAdvice(mentorUid, resumeNo, dueDate);
			if (result > 0) {
				// 첨삭 신청 번호 가져오기
				int rgAdviceNo = rdao.getRegistrationAdviceNo(mentorUid, resumeNo);
				// 포인트 로그 저장
				pointDAO.submitAdvicePointLog(mentorUid, sessionUid, -1000, rgAdviceNo, dueDate);
				// 포인트 차감
				userDAO.updateUserPoint(sessionUid, -1000);

				return true;
			} 
		}
		return false;
	}

	@Override
	public int getRegistrationAdviceNo(int mentorUid, int resumeNo) throws Exception {
		return rdao.getRegistrationAdviceNo(mentorUid, resumeNo);
	}

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 승인을 처리하는 메서드
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @return 성공 여부
	 */
	@Override
	public boolean acceptAdvice(int resumeNo, int userUid) throws Exception {
		int adviceResult = rdao.changeAdviceStatus(resumeNo, userUid, "CHECKING");
		return adviceResult > 0;
	}

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 거절을 처리하는 메서드
	 * 거절을 하면 첨삭 상태가 첨삭 대기에서 첨삭 거절로 변경됩니다.
	 * 포인트 로그에 포인트 차감 내역이 CANCEL로 업데이트 됩니다.
	 * 포인트를 지불한 유저의 포인트를 돌려줍니다.
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @param int userUid 첨삭자 UID
	 * @param int ownerUid 이력서 주인 UID
	 * @return 성공 여부
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean rejectAdvice(int resumeNo, int userUid, int ownerUid) throws Exception {
		// 첨삭 거절 처리
		int adviceResult = rdao.changeAdviceStatus(resumeNo, userUid, "CANCEL");
		if (adviceResult > 0) {
			// 첨삭 거절한 rgAdviceNo 가져오기
			int rgAdviceNo = rdao.getRegistrationAdviceNo(userUid, resumeNo);
			// 포인트 로그에 포인트 차감 내역이 CANCEL로 업데이트 됩니다.
			int pointResult = pointDAO.updatePointLog(rgAdviceNo, "CANCEL", "reject");
			if (pointResult > 0) {
				// 포인트를 지불한 유저의 포인트를 돌려줍니다.
				userDAO.updateUserPoint(ownerUid, 1000);
				return true;
			}
		}
		return false;
	}

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 종료를 처리하는 메서드
	 * 종료를 하면 첨삭 상태가 CHECKING 에서 COMPLETE로 변경됩니다.
	 * 포인트 로그에 포인트 차감 내역이 COMPLETE로 업데이트 됩니다.
	 * 첨삭을 완료한 유저의 포인트를 증가시킵니다.
	 * </p>
	 * 
	 * @param int resumeNo 이력서 번호
	 * @param int userUid 첨삭자 UID
	 * @param int ownerUid 이력서 주인 UID
	 * @return 성공 여부
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean endAdvice(int resumeNo, int userUid, int ownerUid) throws Exception {
		// 첨삭 종료 처리
		int adviceResult = rdao.changeAdviceStatus(resumeNo, userUid, "COMPLETE");
		if (adviceResult > 0) {
			// 첨삭 내용 테이블 COMPLETE로 업데이트
			int adviceStatusResult = rdao.updateAdviceStatus(resumeNo, "COMPLETE");
			if (adviceStatusResult > 0) {
				// 첨삭 종료한 rgAdviceNo 가져오기
				int rgAdviceNo = rdao.getRegistrationAdviceNo(userUid, resumeNo);
				// 포인트 로그에 포인트 차감 내역이 COMPLETE로 업데이트 됩니다.
				int pointResult = pointDAO.updatePointLog(rgAdviceNo, "COMPLETE", "end");
				if (pointResult > 0) {
					// 첨삭을 완료한 유저의 포인트를 증가시킵니다.
					userDAO.updateUserPoint(userUid, 1000);
					return true;
				}
			}
		}
		return false;
	}
	

	// /**
	//  *  @author 유지원
	//  *
	//  * <p>
	//  * 이력서 첨삭 코멘트를 저장하는 메서드
	//  * </p>
	//  * 
	//  * @param ResumeAdviceCommentDTO commentDTO 코멘트 정보
	//  * @return 성공 여부
	//  */
	// @Override
	// public boolean saveResumeComment(ResumeAdviceCommentDTO commentDTO) throws Exception {
	// 	return rdao.insertResumeComment(commentDTO);
	// }

}
