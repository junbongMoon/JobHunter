package com.jobhunter.dao.log;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.customenum.AccountType;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AccountLogDAOImpl implements AccountLogDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.accountlogmapper";
	
	@Override
	public void insertRegisterLog(Integer uid, AccountType accountType) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("uid", uid);
		param.put("accountType", accountType);
		ses.insert(NS + ".insertRegisterLog", param);
	}
}
