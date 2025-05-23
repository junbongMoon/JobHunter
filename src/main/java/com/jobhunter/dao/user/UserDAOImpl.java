package com.jobhunter.dao.user;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.PasswordDTO;
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
	public UserVO getUserInfo(int uid) throws Exception {
		UserVO user = ses.selectOne(NS + ".getUserInfo", uid);

		// 후처리: 프로필 이미지가 없을 경우 기본 이미지로 설정
		if (user != null && (user.getUserImg() == null || user.getUserImg().isEmpty())) {
			user.setUserImg(null); // 세터에서 기본값 세팅하도록 null 전달
		}

		return user;
	}

	@Override
	public AccountVO findByUidAndPassword(int uid, String password) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("uid", uid);
		paramMap.put("password", password);

		AccountVO account = ses.selectOne(NS + ".checkPassword", paramMap);

		// 후처리: 프로필 이미지가 없으면 기본값 설정
		if (account != null && (account.getProfileImg() == null || account.getProfileImg().isEmpty())) {
			account.setProfileImg(null); // 기본 이미지 세터가 작동하도록 null 전달
		}

		return account;
	}
	
	@Override
	public void updatePassword(PasswordDTO dto) throws Exception {
	    ses.update(NS + ".updatePassword", dto);
	}
	
	@Override
	public void updateContact(ContactUpdateDTO dto) throws Exception {
	    ses.update(NS + ".updateContact", dto);
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
		AccountVO account = ses.selectOne(NS + ".loginByKakaoId", kakaoId);

		// 후처리: 프로필 이미지가 없으면 기본값 설정
		if (account != null && (account.getProfileImg() == null || account.getProfileImg().isEmpty())) {
			account.setProfileImg(null); // 기본 이미지 세터가 작동하도록 null 전달
		}

		return account;
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
	public int deleteMobile(int uid) throws Exception {
		return ses.update(NS + ".deleteMobile", uid);
	}
	
	@Override
	public int deleteEmail(int uid) throws Exception {
		return ses.update(NS + ".deleteEmail", uid);
	}

	@Override
	public void setDeleteAccount(Integer uid) throws Exception {
		ses.update(NS + ".setDeleteAccount", uid);
	}
	@Override
	public Timestamp getDeleteAccount(Integer uid) throws Exception {
		return ses.selectOne(NS + ".getDeleteDeadline", uid);
	}
	@Override
	public void cancelDeleteAccount(Integer uid) throws Exception {
		ses.selectOne(NS + ".cancelDeleteAccount", uid);
	}

	@Override
	public int updateUserPoint(int userUid, int point) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("userUid", userUid);
		param.put("point", point);
		
		
		return ses.update(NS + ".modifyUserPoint", param);
	}


	
	@Override
	public void updateProfileImg(Integer uid, String base64) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("uid", uid);
	    paramMap.put("img", base64);
	    
		ses.update(NS + ".updateProfileImg", paramMap);
	}

	@Override
	public void updateName(Integer uid, String newName) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("uid", uid);
	    paramMap.put("name", newName);
	    
		ses.update(NS + ".updateName", paramMap);
	}
	
	@Override
	public void setUserMentorFlagByAdvancementNo(int advancementNo) throws Exception {
		ses.update(NS + ".setUserMentorFlagByAdvancementNo", advancementNo);
	}
}
