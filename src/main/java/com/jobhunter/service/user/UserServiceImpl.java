package com.jobhunter.service.user;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.user.UserDAO;
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
	
}
