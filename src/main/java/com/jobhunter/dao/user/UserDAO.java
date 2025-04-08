package com.jobhunter.dao.user;

import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.KakaoUserInfo;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserVO;

public interface UserDAO {

	UserVO getUserInfo(String uid) throws Exception;

	Boolean findByUidAndPassword(String uid, String password) throws Exception;

	void updatePassword(String uid, String newPassword) throws Exception;

	void updateEmail(Map<String, String> paramMap) throws Exception;

	void updateMobile(Map<String, String> paramMap) throws Exception;

	int updateUserInfo(UserInfoDTO userInfo) throws Exception;

	Integer findByKakao(KakaoUserInfo userInfo) throws Exception;

	Integer registKakao(KakaoUserInfo userInfo) throws Exception;

	AccountVO loginByKakaoId(Long kakaoId) throws Exception;

	boolean findIsUserById(String userId) throws Exception;

	AccountVO findByEmail(KakaoUserInfo userInfo) throws Exception;

}
