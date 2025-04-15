package com.jobhunter.service.user;

import java.util.HashMap;
import java.util.List;
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

import com.jobhunter.customexception.DuplicateEmailException;
import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.util.PropertiesTask;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

	private final UserDAO dao;
	
	@Override
	public UserVO showMypage(String uid) throws Exception {
		return dao.getUserInfo(uid);
	}
	
	@Override
	public boolean checkPassword(String uid, String password) throws Exception {
		AccountVO account = dao.findByUidAndPassword(uid, password);
		if (account == null) {
			return false;
		}
	    return true;
	}
	
	@Override
	public void updatePassword(String uid, String password) throws Exception {
	    dao.updatePassword(uid, password);
	}
	
	@Override
	public String updateContact(String uid, String type, String value) throws Exception {
	    Map<String, String> map = new HashMap<>();
	    map.put("uid", uid);

	    if ("email".equals(type)) {
	        map.put("email", value);
	        dao.updateEmail(map);
	    } else if ("mobile".equals(type)) {
	        map.put("mobile", value);
	        dao.updateMobile(map);
	    } else {
	        throw new IllegalArgumentException("지원하지 않는 타입입니다.");
	    }

	    return value;
	}

	@Override
	public boolean updateUserInfo(UserInfoDTO userInfo) throws Exception {
		return dao.updateUserInfo(userInfo) > 0;
	}
	
	@Override
	public String getKakaoToken(String code, String redirectUri) throws Exception {
		
		System.out.println("code : " + code);
		System.out.println("redirectUri : " + redirectUri);
		
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

	    System.out.println("response : " + response);
	    
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
	    
	    System.out.println(kakaoUserInfo);
	    return kakaoUserInfo;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public AccountVO loginOrRegisterKakao(KakaoUserInfoDTO userInfo) throws Exception {
		AccountVO accountVo = null;
		Integer uid = dao.findByKakao(userInfo);
		if (uid == null) {
			AccountVO emailAccount = dao.findByEmail(userInfo);
			if(emailAccount == null) {
				uid = dao.registKakao(userInfo);
			} else {
				throw new DuplicateEmailException();
			}
		}
		
		if (uid != null) {
			accountVo = dao.loginByKakaoId(userInfo.getKakaoId());
		}
		return accountVo;
	}

	@Override
	public boolean isUserIdExists(String userId) throws Exception {
		return dao.findIsUserById(userId);
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public AccountVO registUser(UserRegisterDTO dto) throws Exception {
		Integer uid = dao.registUser(dto);
		return dao.findByUidAndPassword(uid.toString(), dto.getPassword());
	}

	@Override
	public List<UserVO> getAllUsers() throws Exception {
		return dao.getAllUsers();
	}

	@Override
	public UserVO getUserById(int uid) throws Exception {
		return dao.getUserById(uid);
	}

	@Override
	public List<UserVO> getUsersBySearch(String searchType, String searchKeyword, int page, int pageSize) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("offset", (page - 1) * pageSize);
		params.put("pageSize", pageSize);
		
		return dao.getUsersBySearch(params);
	}

	@Override
	public int getTotalUserCount(String searchType, String searchKeyword) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		
		return dao.getTotalUserCount(params);
	}
}
