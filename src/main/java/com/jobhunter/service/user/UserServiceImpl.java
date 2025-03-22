package com.jobhunter.service.user;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.user.LoginDTO;
import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

	private final UserDAO udao;

	@Override
	public boolean saveUser(UserVO user) throws Exception {
		// TODO Auto-generated method stub
		boolean result = false;

		return result;
	}
	
	
	@Override
	public void setRequiresVerificationFalse(String type, String value) throws Exception {
	    Map<String, String> param = new HashMap<>();
	    param.put("type", type);
	    param.put("value", value);
	    udao.setRequiresVerificationFalse(param);
	}

	// 인증 필요 여부 들고가려고 맵으로 반환_그냥 널 체크하면 5번 실패한건지도 모르니까
	// auth 값 true면 이메일/폰 인증창 보여주기
	@Override
	public Map<String, Object> loginUser(LoginDTO loginDto) throws Exception {
	    Map<String, Object> result = new HashMap<>();

	    // 로그인 시도
	    UserVO user = udao.loginUser(loginDto);

	    if (user == null) {
	        // 없는 유저거나 비밀번호 틀림
	        // 실패 횟수 증가 전에 유저 존재 여부 확인
	        if (udao.existsUserId(loginDto.getUserId())) {
	            int failCount = udao.getFailCount(loginDto.getUserId());
	            
	            // 실패횟수 증가(인증필요 체크 else로 넣으면 카운트 4일때 증가 안하거나 6되야 인증필요되니까 따로
	            if (failCount < 5) {
	            	
	                udao.increaseFailCount(loginDto.getUserId());
	            }
	            
	            // 실패횟수 5되면 인증필요 체크하기
	            if (failCount + 1 >= 5) {
	            	udao.setRequiresVerification(loginDto.getUserId());
	                result.put("auth", true);
	            }
	        }
	        result.put("success", false);
	        result.put("message", "아이디 또는 비밀번호가 틀렸습니다.");
	        return result;
	    }

	    // 유저 있음 + 로그인 성공
	    udao.resetFailCount(user.getUserId());

	    boolean requiresVerification = "Y".equals(user.getRequiresVerification());

	    result.put("user", user);
	    result.put("auth", requiresVerification);
	    result.put("success", true);

	    return result;
	}

}
