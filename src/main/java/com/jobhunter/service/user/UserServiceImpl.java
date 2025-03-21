package com.jobhunter.service.user;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.user.User;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
	
	private final UserDAO udao;
	
	@Override
	public boolean saveUser(User user) throws Exception {
		// TODO Auto-generated method stub
		boolean result = false;
	
		
		return result;
	}

}
