package com.jobhunter.service.company;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.company.CompanyDAO;
import com.jobhunter.model.company.CompanyVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CompanyServiceImpl implements CompanyService {

	private final CompanyDAO dao;
	
	@Override
	public CompanyVO showCompanyHome(String uid) throws Exception {
		return dao.getCompanyInfo(uid);
	}
	
	@Override
	public boolean checkPassword(String uid, String password) throws Exception {
	    return dao.findByUidAndPassword(uid, password);
	}
	
	@Override
	public void updatePassword(String uid, String password) throws Exception {
	    dao.updatePassword(uid, password);
	}
	
	@Override
	public String updateContact(String uid, String type, String value) throws Exception {
	    Map<String, String> map = new HashMap<>();
	    map.put("uid", uid);

	    if ("email".equals(type)) {
	        map.put("email", value);
	        dao.updateEmail(map);
	    } else if ("mobile".equals(type)) {
	        map.put("mobile", value);
	        dao.updateMobile(map);
	    } else {
	        throw new IllegalArgumentException("지원하지 않는 타입입니다.");
	    }

	    return value;
	}
	
}
