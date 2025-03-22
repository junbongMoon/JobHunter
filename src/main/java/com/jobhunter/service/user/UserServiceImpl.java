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

	// 인증 필요 여부 들고가려고 맵으로 반환_그냥 널 체크하면 5번 실패한건지도 모르니까
	// auth 값 true면 이메일인증창 보여주기
	@Override
	public Map<String, Object> loginUser(LoginDTO loginDto) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		// 인증필요체크
		if ("Y".equals(udao.isAuthVerifi(loginDto.getUserId()))) {
			result.put("auth", true);
			return result;
		}
		// 로그인 시도
		UserVO loginUser = udao.loginUser(loginDto);
		

		// 실패시 카운트 확인
		// 5될거면 인증필요
		// 성공시 카운트 0으로

		// 인증필요 들고가야할거같은데?

		if (loginUser == null) {
	        // 로그인 실패: 실패 카운트 증가
			udao.increaseFailCount(loginDto.getUserId());
			int failCount = udao.getFailCount(loginDto.getUserId());

	        // 실패 횟수가 5 이상이면 인증 필요
	        if (failCount >= 5) {
	        	udao.setRequiresVerification(loginDto.getUserId(), "Y");
	            result.put("auth", true);
	            return result;
	        }

	        // 인증 필요는 아니지만 로그인 실패
	        result.put("auth", false);
	        result.put("success", false);
	        return result;
	    }

	    // 로그인 성공: 실패 카운트 초기화
	    udao.resetFailCount(loginDto.getUserId());

	    // 로그인 성공 정보 반환
	    result.put("auth", false);  // 인증 필요 없음
	    result.put("success", true);
	    result.put("user", loginUser);  // 필요시 사용자 정보도 반환

	    return result;
	}

}
