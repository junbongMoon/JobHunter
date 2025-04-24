package com.jobhunter.service.user;


import java.util.Map;
import java.sql.Timestamp;
import java.util.List;


import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.payment.PaymentLogDTO;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
import com.jobhunter.model.user.UserVO;

public interface UserService {

	UserVO showMypage(String uid) throws Exception;

	boolean checkPassword(String uid, String password) throws Exception;

	void updatePassword(String uid, String password) throws Exception;

	String updateContact(String uid, String type, String value) throws Exception;

	boolean updateUserInfo(UserInfoDTO userInfo) throws Exception;

	KakaoUserInfoDTO getKakaoInfo(String accessToken) throws Exception;

	String getKakaoToken(String code, String redirectUri) throws Exception;

	Map<String, Object> loginOrRegisterKakao(KakaoUserInfoDTO userInfo) throws Exception;

	boolean isUserIdExists(String userId) throws Exception;

	AccountVO registUser(UserRegisterDTO dto) throws Exception;


	void linkToKakao(KakaoUserInfoDTO userInfo) throws Exception;

	void deleteContact(String uid, String type) throws Exception;

	Timestamp setDeleteAccount(Integer uid) throws Exception;

	void updateProfileImg(Integer uid, String base64) throws Exception;

	void deleteProfileImg(Integer uid) throws Exception;

	void updateName(Integer uid, String newName) throws Exception;

	boolean addPoint(String userId, int point, PaymentLogDTO paymentLog) throws Exception;

	void cancelDeleteAccount(Integer uid) throws Exception;


}
