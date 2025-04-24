package com.jobhunter.dao.user;

import java.sql.Timestamp;
import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
import com.jobhunter.model.user.UserVO;

public interface UserDAO {

	UserVO getUserInfo(String uid) throws Exception;

	AccountVO findByUidAndPassword(String uid, String password) throws Exception;

	void updatePassword(String uid, String newPassword) throws Exception;

	void updateEmail(Map<String, String> paramMap) throws Exception;

	void updateMobile(Map<String, String> paramMap) throws Exception;

	int updateUserInfo(UserInfoDTO userInfo) throws Exception;

	Integer findByKakao(KakaoUserInfoDTO userInfo) throws Exception;

	Integer registKakao(KakaoUserInfoDTO userInfo) throws Exception;

	AccountVO loginByKakaoId(Long kakaoId) throws Exception;

	boolean findIsUserById(String userId) throws Exception;

	int registUser(UserRegisterDTO dto) throws Exception;

	int linkToKakao(KakaoUserInfoDTO userInfo) throws Exception;

	int deleteEmail(String uid) throws Exception;

	int deleteMobile(String uid) throws Exception;

	void setDeleteAccount(Integer uid) throws Exception;


	void updateProfileImg(Integer uid, String base64) throws Exception;

	void updateName(Integer uid, String newName) throws Exception;

	int updateUserPoint(int userUid, int point) throws Exception;

	Timestamp getDeleteAccount(Integer uid) throws Exception;

	void cancelDeleteAccount(Integer uid) throws Exception; 

		
	

}
