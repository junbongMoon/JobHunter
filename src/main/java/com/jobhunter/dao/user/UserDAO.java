package com.jobhunter.dao.user;

import java.sql.Timestamp;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.PasswordDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
import com.jobhunter.model.user.UserVO;

public interface UserDAO {

	UserVO getUserInfo(int uid) throws Exception;

	AccountVO findByUidAndPassword(int uid, String password) throws Exception;

	void updatePassword(PasswordDTO dto) throws Exception;
	
	void updateContact(ContactUpdateDTO dto) throws Exception;

	int updateUserInfo(UserInfoDTO userInfo) throws Exception;

	Integer findByKakao(KakaoUserInfoDTO userInfo) throws Exception;

	Integer registKakao(KakaoUserInfoDTO userInfo) throws Exception;

	AccountVO loginByKakaoId(Long kakaoId) throws Exception;

	boolean findIsUserById(String userId) throws Exception;

	int registUser(UserRegisterDTO dto) throws Exception;

	int linkToKakao(KakaoUserInfoDTO userInfo) throws Exception;

	int deleteEmail(int uid) throws Exception;

	int deleteMobile(int uid) throws Exception;

	void setDeleteAccount(Integer uid) throws Exception;


	void updateProfileImg(Integer uid, String base64) throws Exception;

	void updateName(Integer uid, String newName) throws Exception;

	int updateUserPoint(int userUid, int point) throws Exception;

	Timestamp getDeleteAccount(Integer uid) throws Exception;

	void cancelDeleteAccount(Integer uid) throws Exception;

	void setUserMentorFlagByAdvancementNo(int advancementNo) throws Exception; 

		
	

}
