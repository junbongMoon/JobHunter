package com.jobhunter.dao.submit;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.Status;

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
		
		return ses.update(NS + ".modifyStatus", params);
		
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
	
	
	

}
