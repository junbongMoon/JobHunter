package com.jobhunter.dao.user;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class UserDAOImpl implements UserDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.usermapper";
	
	@Override
	public UserVO getUserInfo(String uid) throws Exception {
		return ses.selectOne(NS+".getUserInfo", uid);
	}

	@Override
	public AccountVO findByUidAndPassword(String uid, String password) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("uid", uid);
		paramMap.put("password", password);

		return ses.selectOne(NS + ".checkPassword", paramMap);
	}
	
	@Override
	public void updatePassword(String uid, String newPassword) throws Exception {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("uid", uid);
	    paramMap.put("password", newPassword);
	    
	    ses.update(NS + ".updatePassword", paramMap);
	}
	
	@Override
	public void updateEmail(Map<String, String> paramMap) throws Exception {
	    
	    ses.update(NS + ".updateEmail", paramMap);
	}
	
	@Override
	public void updateMobile(Map<String, String> paramMap) throws Exception {
	    
	    ses.update(NS + ".updateMobile", paramMap);
	}

	@Override
	public int updateUserInfo(UserInfoDTO userInfo) throws Exception {
		return ses.update(NS + ".updateUserInfo", userInfo);
	}

	@Override
	public Integer findByKakao(KakaoUserInfoDTO userInfo) throws Exception {
		return ses.selectOne(NS + ".findByKakao", userInfo.getKakaoId());
	}

	@Override
	public Integer registKakao(KakaoUserInfoDTO userInfo) throws Exception {
		ses.insert(NS + ".registKakao", userInfo);
		return userInfo.getUid();
	}

	@Override
	public AccountVO loginByKakaoId(Long kakaoId) throws Exception {
		return ses.selectOne(NS + ".loginByKakaoId", kakaoId);
	}

	@Override
	public boolean findIsUserById(String userId) {
		Boolean result = ses.selectOne(NS + ".findIsUserById", userId);
	    return Boolean.TRUE.equals(result);
	}
	
	@Override
	public int registUser(UserRegisterDTO dto) throws Exception {
		int result = ses.insert(NS + ".registUser", dto);
		if (result > 0) {
			return dto.getUid();
		}
		return 0;
	}

	@Override
	public int linkToKakao(KakaoUserInfoDTO userInfo) throws Exception {
		return ses.update(NS + ".linkToKakao", userInfo);
	}
	
	@Override
	public int deleteMobile(String uid) throws Exception {
		return ses.update(NS + ".deleteMobile", uid);
	}
	
	@Override
	public int deleteEmail(String uid) throws Exception {
		return ses.update(NS + ".deleteEmail", uid);
	}

	@Override
	public void setDeleteAccount(Integer uid) throws Exception {
		ses.update(NS + ".setDeleteAccount", uid);
	}

	
}
