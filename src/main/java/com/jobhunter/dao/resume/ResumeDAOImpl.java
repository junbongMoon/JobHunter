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
import com.jobhunter.model.resume.MyRegistrationAdviceSearchDTO;
import com.jobhunter.model.resume.PersonalHistoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.RegistrationAdviceVO;
import com.jobhunter.model.resume.ResumeAdviceDTO;
import com.jobhunter.model.resume.ResumeAdviceUpfileDTO;
import com.jobhunter.model.resume.ResumeAdviceVO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.model.resume.ResumeAdviceCommentDTO;

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

	@Override
	public void insertAdvice(ResumeAdviceDTO adviceDTO) throws Exception {
		ses.insert(NS + ".insertAdvice", adviceDTO);
	}

	@Override
	public void insertAdviceFile(ResumeAdviceUpfileDTO fileDTO) throws Exception {
		ses.insert(NS + ".insertAdviceFile", fileDTO);
	}

	@Override
	public ResumeAdviceDTO selectAdvice(int resumeNo) throws Exception {
		return ses.selectOne(NS + ".selectAdvice", resumeNo);
	}

	@Override
	public List<ResumeAdviceUpfileDTO> selectAdviceFiles(int adviceNo) throws Exception {
		return ses.selectList(NS + ".selectAdviceFiles", adviceNo);
	}

	@Override
	public ResumeAdviceDTO getAdvice(int resumeNo) throws Exception {
		return ses.selectOne(NS + ".getAdvice", resumeNo);
	}

	@Override
	public List<ResumeAdviceUpfileDTO> getAdviceFiles(int adviceNo) throws Exception {
		return ses.selectList(NS + ".getAdviceFiles", adviceNo);
	}

	@Override
	public void deleteExistingAdvice(int resumeNo, int mentorUid) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("resumeNo", resumeNo);
		params.put("mentorUid", mentorUid);
		ses.delete(NS + ".deleteExistingAdvice", params);
	}
	
	@Override
	public List<RegistrationAdviceVO> selectRegistrationAdviceByMentorWithPaging(MyRegistrationAdviceSearchDTO dto) {
		return ses.selectList(NS + ".selectRegistrationAdviceByMentorWithPaging", dto);
	}
	
	@Override
	public int countRegistrationAdviceByMentor(MyRegistrationAdviceSearchDTO dto) {
		return ses.selectOne(NS + ".countRegistrationAdviceByMentor", dto);
	}
	
	@Override
	public List<ResumeAdviceVO> selectResumeAdviceByUserUid(int uid, int offset) {
		Map<String, Integer> param = new HashMap<String, Integer>();
		param.put("userUid", uid);
		param.put("offset", offset);
		return ses.selectList(NS + ".selectResumeAdviceByUserUid", param);
	}
	
	@Override
	public int countResumeAdviceByUserUid(int uid) {
		return ses.selectOne(NS + ".countResumeAdviceByUserUid", uid);
	}

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 신청을 저장하는 메서드
	 * </p>
	 * 
	 * @param int mentorUid 첨삭자 UID
	 * @param int resumeNo 이력서 번호
	 * @return 성공하면 1, 실패하면 0
	 *
	 */
	@Override
	public int insertRegistrationAdvice(int mentorUid, int resumeNo, String dueDate) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("mentorUid", mentorUid);
		params.put("resumeNo", resumeNo);
		params.put("dueDate", dueDate);

		return ses.insert(NS + ".insertRegistrationAdvice", params);
	}

	/**
	 *  @author 유지원
	 *
	 * <p>
	 * 이력서 첨삭 신청 중복 여부를 확인하는 메서드
	 * </p>
	 * 
	 * @param int mentorUid 첨삭자 UID
	 * @param int resumeNo 이력서 번호
	 * @return 중복이면 1 이상, 중복이 아니면 0
	 *
	 */
	@Override
	public int checkDuplicateAdvice(int mentorUid, int resumeNo) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("mentorUid", mentorUid);
		params.put("resumeNo", resumeNo);

		return ses.selectOne(NS + ".checkDuplicateAdvice", params);
	}

	// 이력서 첨삭 상태 확인
	@Override
	public int checkResumeAdvice(int resumeNo) throws Exception {
		return ses.selectOne(NS + ".checkResumeAdvice", resumeNo);
	}

	@Override
	public int getRegistrationAdviceNo(int mentorUid, int resumeNo) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("mentorUid", mentorUid);
		params.put("resumeNo", resumeNo);
		return ses.selectOne(NS + ".getRegistrationAdviceNo", params);
	}

	// @Override
	// public void acceptAdvice(int resumeNo, int userUid) throws Exception {
	// 	Map<String, Object> params = new HashMap<>();
	// 	params.put("resumeNo", resumeNo);
	// 	params.put("userUid", userUid);
	// 	ses.update(NS + ".acceptAdvice", params);
	// }

	// @Override
	// public void rejectAdvice(int resumeNo, int userUid) throws Exception {
	// 	Map<String, Object> params = new HashMap<>();
	// 	params.put("resumeNo", resumeNo);
	// 	params.put("userUid", userUid);
	// 	ses.update(NS + ".rejectAdvice", params);
	// }

	@Override
	public int changeAdviceStatus(int resumeNo, int userUid, String status) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("resumeNo", resumeNo);
		params.put("userUid", userUid);
		params.put("status", status);
		return ses.update(NS + ".changeAdviceStatus", params);
	}

	@Override
	public int updateAdviceStatus(int resumeNo, String status) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("resumeNo", resumeNo);
		params.put("status", status);
		return ses.update(NS + ".updateAdviceStatus", params);
	}

	@Override
	public int insertAdviceComment(ResumeAdviceCommentDTO commentDTO) throws Exception {
		return ses.insert(NS + ".insertAdviceComment", commentDTO);
	}
}
