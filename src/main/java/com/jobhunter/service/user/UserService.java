package com.jobhunter.service.user;

import com.jobhunter.model.user.User;

public interface UserService {
	// 유저를 저장하는
	boolean saveUser(User user) throws Exception;
}
