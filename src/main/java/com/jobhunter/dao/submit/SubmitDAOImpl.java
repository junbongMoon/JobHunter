package com.jobhunter.dao.submit;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.message.MessageTargetInfoDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.RegistrationVO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmitAndUser;
import com.jobhunter.model.submit.Status;
import com.jobhunter.model.submit.SubmitFromRecruitVO;
import com.jobhunter.model.submit.SubmitSearchDTO;

import lombok.RequiredArgsConstructor;

/**
 * @author 문준봉
 *
 */
@Repository
@RequiredArgsConstructor
public class SubmitDAOImpl implements SubmitDAO {
	
	/**
	 * <p> 
	 * 쿼리문을 실행할 SqlSession 객체
	 * </p>
	 */
	private final SqlSession ses;
	
	/**
	 * <p> 
	 * 제출 관련 Mapper의 NameSpace 값
	 * </p>
	 */
	private final String NS = "com.jobhunter.mapper.submitmapper";
	

 
    /**
     *  @author 문준봉
     *
     * <p>
     * 이력서 상세정보를 조회하는 메서드
     * </p>
     * 
     * @param int recruitmentUid
     * @param PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO
     * @return 해당 공고에 제출된 이력서의 상세 정보
     * @throws Exception
     *
     */
    @Override
    public List<ResumeDetailInfoBySubmit> selectResumDetailInfoBySubmitByRecruitmentUid(int recruitmentUid,
            PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO) throws Exception {
        
        Map<String, Object> params = new HashMap<>();
        params.put("recruitmentUid", recruitmentUid);
        params.put("startRowIndex", pageResponseDTO.getStartRowIndex());
        params.put("rowCntPerPage", pageResponseDTO.getRowCntPerPage());

        return ses.selectList(NS + ".selectRecruitmentsByRecruitmentUid", params);
    }
    

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고에 제출 된 resume의 갯수를 조회하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 공고에 제출 된 resume의 갯수
	 * @throws Exception
	 *
	 */
	@Override
	public int selectTotalCountRowOfResumeByUid(int uid) throws Exception {
		
		return ses.selectOne(NS + ".getTotalCountRowOfRecruitmentByUid", uid);
	}
	

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 이력서에 저장된 파일을 조회하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 이력서에 저장 된 파일 파일 리스트
	 * @throws Exception
	 *
	 */
	@Override
	public List<ResumeUpfileDTO> selectUpfileListByResume(int uid) throws Exception {
		
		return ses.selectList(NS + ".getFileListByResumeUid", uid);
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 제출 상태를 변경하는 메서드
	 * </p>
	 * 
	 * @param Status status
	 * @param int resumePk,
	 * @param int recruitmentNoticePk
	 * @return
	 *
	 */
	@Override
	public int updateStatusByRegistration(Status status, int resumePk, int recruitmentNoticePk) {
		Map<String, Object> params = new HashMap<>();
		params.put("status", status);
		params.put("resumePk", resumePk);
		params.put("recruitmentNoticePk", recruitmentNoticePk);
		
		System.out.println("[DEBUG] 상태 변경 시도 >> " + params);

		int affected = ses.update(NS + ".modifyStatus", params);
		System.out.println("[DEBUG] 영향 받은 행 수: " + affected);
		
		return affected;
		
	}


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 대기중인 제출 이력의 상태를 만료됨으로 변경 해주는 메서드
	 * </p>
	 * 
	 * @param String yesterDayStr
	 * @return 상태가 변경된 이력의 row 갯수
	 *
	 */
	@Override
	public int updateStatusToExpired(String yesterDayStr) {
		
		return ses.update(NS + ".updateStatusToExpired", yesterDayStr);
	}


	@Override
	public int countBySubmittedDateBetween(LocalDateTime start, LocalDateTime end) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("start", start);
		param.put("end", end);
		return ses.selectOne(NS + ".countByCreatedDateBetweenAndRole", param);
	}



	@Override
	public int updateStatusToExpiredBetween(Map<String, Object> param) {
	    return ses.update(NS + ".updateStatusToExpiredBetween", param);
	}

	@Override
	public List<Map<String, Object>> selectExpiredSubmitUserMessageInfoBetween(Map<String, Object> param) {
	    return ses.selectList(NS + ".selectExpiredSubmitUserMessageInfoBetween", param);
	}


	@Override
	public MessageTargetInfoDTO selectMessageTargetInfo(int resumePk, int recruitmentNoticePk) {
		Map<String, Integer> param = new HashMap<>();
		param.put("resumePk", resumePk);
		param.put("recruitmentNoticePk", recruitmentNoticePk);
		
		return ses.selectOne(NS +".selectMessageTargetInfo", param);
	}


	@Override
	public void updateExpiredByRecUid(int uid) throws Exception {
		// TODO Auto-generated method stub
		ses.update(NS +".ExpiredByEntireWatingRegistration", uid);
		
	}


	@Override
	public List<RegistrationVO> selectRegistrationByUidAndStatus(int uid, Status status) {
		Map<String, Object> param = new HashMap<>();
		
		param.put("uid", uid);
		param.put("status", status);
		
		
		return ses.selectList(NS + ".getRegistrationVOLisByUidAndStatus", param);
	}
	

	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 공고에 제출된 신청서를 검색조건에 따라 가져오는 메서드
	 * </p>
	 * 
	 * @param SubmitSearchDTO dto 검색조건과 공고uid를 담은 DTO
	 * @return 검색 조건에 맞는 SubmitFromRecruitVO 리스트
	 *
	 */
	@Override
	public List<SubmitFromRecruitVO> selectResumesByRecruitmentUid(SubmitSearchDTO dto) {
		return ses.selectList(NS + ".selectResumesByRecruitmentUid", dto);
	}
	
	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 공고에 제출된 검색조건에 맞는 신청서의 총 갯수를 가져오는 메서드
	 * </p>
	 * 
	 * @param SubmitSearchDTO dto 검색조건과 공고uid를 담은 DTO
	 * @return int 검색 조건에 맞는 신청서 갯수
	 *
	 */
	@Override
	public int countResumesByRecruitmentUid(SubmitSearchDTO dto) {
		return ses.selectOne(NS + ".countResumesByRecruitmentUid", dto);
	}
	
	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 신청서 하나만 이력서포함해서 가져오는 메서드
	 * </p>
	 * 
	 * @param int registrationNo 신청서 pk
	 * @return 신청서 상세정보
	 *
	 */
    @Override
    public ResumeDetailInfoBySubmitAndUser selectSubmitAndResumeDetailInfo(int registrationNo) throws Exception {
        return ses.selectOne(NS + ".selectOneResumeByRegistrationNo", registrationNo);
    }
    
    /**
	 *  @author 육근우
	 *
	 * <p>
	 * 신청서가 제출된 공고의 작성기업 uid 가져오는 메서드
	 * </p>
	 * 
	 * @param int registrationNo 신청서 pk
	 * @return 신청서가 제출된 공고의 작성기업 uid
	 *
	 */
    @Override
    public int getCompanyUidByRegistrationNo(int registrationNo) throws Exception {
        return ses.selectOne(NS + ".getCompanyUidByRegistrationNo", registrationNo);
    }
	
}
