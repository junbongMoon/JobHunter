package com.jobhunter.dao.user;

import java.util.Map;

import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserVO;

public interface UserDAO {

	UserVO getUserInfo(String uid) throws Exception;

	Boolean findByUidAndPassword(String uid, String password) throws Exception;

	void updatePassword(String uid, String newPassword) throws Exception;

	void updateEmail(Map<String, String> paramMap) throws Exception;

	void updateMobile(Map<String, String> paramMap) throws Exception;

	int updateUserInfo(UserInfoDTO userInfo) throws Exception;

}
