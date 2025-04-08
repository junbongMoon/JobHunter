package com.jobhunter.dao.submit;

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

@Repository
@RequiredArgsConstructor
public class SubmitDAOImpl implements SubmitDAO {
	
	private final SqlSession ses;
	
	private final String NS = "com.jobhunter.mapper.submitmapper";
	

	// join을 이용해 ResumeDetailInfoBySubmit를 조회하는 메서드
    @Override
    public List<ResumeDetailInfoBySubmit> selectResumDetailInfoBySubmitByRecruitmentUid(int recruitmentUid,
            PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO) throws Exception {
        
        Map<String, Object> params = new HashMap<>();
        params.put("recruitmentUid", recruitmentUid);
        params.put("startRowIndex", pageResponseDTO.getStartRowIndex());
        params.put("rowCntPerPage", pageResponseDTO.getRowCntPerPage());

        return ses.selectList(NS + ".selectRecruitmentsByRecruitmentUid", params);
    }
    
    // 공고에 제출 된 resume의 갯수를 조회하는 메서드
	@Override
	public int selectTotalCountRowOfResumeByUid(int uid) throws Exception {
		
		return ses.selectOne(NS + ".getTotalCountRowOfRecruitmentByUid", uid);
	}
	
	// 파일을 조회하는 메서드
	@Override
	public List<ResumeUpfileDTO> selectUpfileListByResume(int uid) throws Exception {
		
		return ses.selectList(NS + ".getFileListByResumeUid", uid);
	}

	@Override
	public void updateStatusByRegistration(Status status, int resumePk, int recruitmentNoticePk) {
		Map<String, Object> params = new HashMap<>();
		params.put("status", status);
		params.put("resumePk", resumePk);
		params.put("recruitmentNoticePk", recruitmentNoticePk);
		
		ses.update(NS + ".modifyStatus", params);
		
	}
	
	
	

}
