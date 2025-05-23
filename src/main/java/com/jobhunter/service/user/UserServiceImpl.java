package com.jobhunter.service.user;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.jobhunter.dao.payment.PaymentDAO;
import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.payment.PaymentLogDTO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.PasswordDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.util.PropertiesTask;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

	private final UserDAO dao;
	private final PaymentDAO paymentDAO;
	
	@Override
	public UserVO showMypage(int uid) throws Exception {
		return dao.getUserInfo(uid);
	}
	
	@Override
	public boolean checkPassword(int uid, String password) throws Exception {
		AccountVO account = dao.findByUidAndPassword(uid, password);
		if (account == null) {
			return false;
		}
	    return true;
	}
	
	@Override
	public void updatePassword(PasswordDTO dto) throws Exception {
	    dao.updatePassword(dto);
	}
	
	@Override
	public String updateContact(ContactUpdateDTO dto) throws Exception {
		dao.updateContact(dto);

	    return dto.getValue();
	}

	@Override
	public boolean updateUserInfo(UserInfoDTO userInfo) throws Exception {
		return dao.updateUserInfo(userInfo) > 0;
	}
	
	@Override
	public String getKakaoToken(String code, String redirectUri) throws Exception {
		
	    RestTemplate restTemplate = new RestTemplate();

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

	    String serviceKey = PropertiesTask.getPropertiesValue("config/kakao.properties", "api.key");
	    
	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	    params.add("grant_type", "authorization_code");
	    params.add("client_id", serviceKey);
	    params.add("redirect_uri", redirectUri);
	    params.add("code", code);

	    HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

	    ResponseEntity<Map> response = restTemplate.postForEntity("https://kauth.kakao.com/oauth/token", request, Map.class);
	    
	    return (String) response.getBody().get("access_token");
	}
	
	@Override
	public KakaoUserInfoDTO getKakaoInfo(String accessToken) throws Exception {
	    RestTemplate restTemplate = new RestTemplate();

	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", "Bearer " + accessToken);

	    HttpEntity<Void> request = new HttpEntity<>(headers);

	    ResponseEntity<Map> response = restTemplate.exchange(
	        "https://kapi.kakao.com/v2/user/me",
	        HttpMethod.GET,
	        request,
	        Map.class
	    );

	    Map<String, Object> body = response.getBody();
	    Long kakaoId = ((Number) body.get("id")).longValue(); // ← 카카오 고유 ID

	    Map<String, Object> kakaoAccount = (Map<String, Object>) body.get("kakao_account");
	    String email = (String) kakaoAccount.get("email");
	    String nickname = (String) ((Map<String, Object>) body.get("properties")).get("nickname");

	    KakaoUserInfoDTO kakaoUserInfo = KakaoUserInfoDTO.builder()
	    		.email(email)
	    		.nickname(nickname)
	    		.kakaoId(kakaoId)
	    		.build();
	    
	    return kakaoUserInfo;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public Map<String, Object> loginOrRegisterKakao(KakaoUserInfoDTO userInfo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		
		AccountVO accountVo = null;
		Integer uid = dao.findByKakao(userInfo);
		
		if (uid == null) {
			uid = dao.registKakao(userInfo);
			result.put("isFirst", true);
		}
		
		if (uid != null) {
			accountVo = dao.loginByKakaoId(userInfo.getKakaoId());
			result.put("accountVo", accountVo);
		}
		return result;
	}
	
	@Override
	public void linkToKakao(KakaoUserInfoDTO userInfo) throws Exception {
		if (dao.linkToKakao(userInfo) != 1) {
			throw new Exception();
		}
	}

	@Override
	public boolean isUserIdExists(String userId) throws Exception {
		return dao.findIsUserById(userId);
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public AccountVO registUser(UserRegisterDTO dto) throws Exception {
		Integer uid = dao.registUser(dto);
		return dao.findByUidAndPassword(uid, dto.getPassword());
	}


	@Override
	public void deleteContact(ContactUpdateDTO dto) throws Exception {
		if(dto.getType().equals("mobile")) {
			if(dao.deleteMobile(dto.getUid()) != 1) {
				throw new Exception();
			}
		} else {
			if(dao.deleteEmail(dto.getUid()) != 1) {
				throw new Exception();
			}
		}
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public Timestamp setDeleteAccount(Integer uid) throws Exception {
		dao.setDeleteAccount(uid);
		return dao.getDeleteAccount(uid);
	}
	
	@Override
	public void cancelDeleteAccount(Integer uid) throws Exception {
		dao.cancelDeleteAccount(uid);
	}

	@Override
	public void updateProfileImg(Integer uid, String base64) throws Exception {
		dao.updateProfileImg(uid, base64);
	}
	
	@Override
	public void deleteProfileImg(Integer uid) throws Exception {
		dao.updateProfileImg(uid, null);
	}

	@Override
	public void updateName(Integer uid, String newName) throws Exception {
		dao.updateName(uid, newName);
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 유저의 포인트를 증가 시키는 메서드
	 * </p>
	 * 
	 * @param userId
	 * @param point
	 * @throws Exception 
	 *
	 */
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public boolean addPoint(String userId, int point, PaymentLogDTO paymentLog) throws Exception {
		boolean result = false;
		int useruid = Integer.parseInt(userId);
		if( dao.updateUserPoint(useruid, point) > 0) {
			if(paymentDAO.insertPanymentLog(paymentLog) > 0) {
				result = true;
			}
			
		}
		
		return result;
		

	}


}
