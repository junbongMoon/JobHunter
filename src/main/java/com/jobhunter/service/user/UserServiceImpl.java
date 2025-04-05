package com.jobhunter.service.user;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

	private final UserDAO dao;
	
	@Override
	public UserVO showMypage(String uid) throws Exception {
		return dao.getUserInfo(uid);
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

	@Override
	public boolean updateUserInfo(UserInfoDTO userInfo) throws Exception {
		return dao.updateUserInfo(userInfo) > 0;
	}
	
}
