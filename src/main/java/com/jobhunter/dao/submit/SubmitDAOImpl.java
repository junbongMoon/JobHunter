package com.jobhunter.dao.submit;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class SubmitDAOImpl implements SubmitDAO {
	
	private final SqlSession ses;
	
	private final String NS = "com.jobhunter.mapper.submitmapper";
	


    @Override
    public List<ResumeDetailInfoBySubmit> selectResumDetailInfoBySubmitByRecruitmentUid(int recruitmentUid,
            PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO) throws Exception {
        
        Map<String, Object> params = new HashMap<>();
        params.put("recruitmentUid", recruitmentUid);
        params.put("startRowIndex", pageResponseDTO.getStartRowIndex());
        params.put("rowCntPerPage", pageResponseDTO.getRowCntPerPage());

        return ses.selectList(NS + ".selectRecruitmentsByRecruitmentUid", params);
    }

	@Override
	public int selectTotalCountRowOfResumeByUid(int uid) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

}
