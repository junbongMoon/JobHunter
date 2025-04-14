package com.jobhunter.dao.company;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.company.CompanyVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CompanyDAOImpl implements CompanyDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.companymapper";
	
	@Override
	public CompanyVO getCompanyInfo(String uid) throws Exception {
		return ses.selectOne(NS+".getCompanyInfo", uid);
	}

	@Override
	public AccountVO findByUidAndPassword(String uid, String password) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("uid", uid);
		paramMap.put("password", password);

		return ses.selectOne(NS + ".checkPassword", paramMap);
	}
	
	@Override
	public void updatePassword(String uid, String newPassword) throws Exception {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("uid", uid);
	    paramMap.put("password", newPassword);
	    
	    ses.update(NS + ".updatePassword", paramMap);
	}
	
	@Override
	public void updateEmail(Map<String, String> paramMap) throws Exception {
	    
	    ses.update(NS + ".updateEmail", paramMap);
	}
	
	@Override
	public void updateMobile(Map<String, String> paramMap) throws Exception {
	    
	    ses.update(NS + ".updateMobile", paramMap);
	}

	@Override
	public boolean findIsCompanyById(String companyId) throws Exception {
		Boolean result = ses.selectOne(NS + ".findIsCompanyById", companyId);
		System.out.println(result);
	    return Boolean.TRUE.equals(result);
	}

	@Override
	public Integer registCompany(CompanyRegisterDTO dto) throws Exception {
		int result = ses.insert(NS + ".registCompany", dto);
		if (result > 0) {
			return dto.getUid();
		}
		return 0;
	}

	@Override
	public int countByCreatedDateBetweenAndRole(LocalDateTime start, LocalDateTime end, String string) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("start", start);
		param.put("end", end);
		param.put("string", string);
		return ses.selectOne(NS +".countByCreatedDateBetweenAndRole", param);
	}
	
	
}
