package com.jobhunter.service.user;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.KakaoUserInfo;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserVO;

public interface UserService {

	UserVO showMypage(String uid) throws Exception;

	boolean checkPassword(String uid, String password) throws Exception;

	void updatePassword(String uid, String password) throws Exception;

	String updateContact(String uid, String type, String value) throws Exception;

	boolean updateUserInfo(UserInfoDTO userInfo) throws Exception;

	KakaoUserInfo getKakaoInfo(String accessToken) throws Exception;

	String getKakaoToken(String code, String redirectUri) throws Exception;

	AccountVO loginOrRegisterKakao(KakaoUserInfo userInfo) throws Exception;

	boolean isUserIdExists(String userId) throws Exception;

}
