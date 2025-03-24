package com.jobhunter.dao.user;

import com.jobhunter.model.user.UserVO;

public interface UserDAO {

	UserVO getUserInfo(String uid) throws Exception;

}
