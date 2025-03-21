package com.jobhunter.service.user;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.user.LoginDTO;
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
	
	public User loginUser(LoginDTO loginDto) {
		
		//인증필요체크
		//로그인 시도
		//실패시 카운트 확인
		//5될거면 인증필요
		//성공시 카운트 0으로
		
		return null;
	}

}
