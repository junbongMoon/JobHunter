package com.jobhunter.dao.user;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.dao.account.AccountLoginDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.account.findIdDTO;

import lombok.RequiredArgsConstructor;

@Repository("userLoginDAO")
@RequiredArgsConstructor
public class UserLoginDAOImpl implements AccountLoginDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.usermapper";
	
	@Override
	public void setRequiresVerificationFalse(int uid) throws Exception {
		// 맵에서 타입(이메일, 전화번호)이랑 값 받아와서 인증필요여부 해제
	    ses.update(NS + ".setVerificationFalse", uid);
	}

	@Override
	public String isAuthVerifi(String userId) throws Exception {
		// 아이디로 인증 필요한지 체크
		return ses.selectOne(NS+".isAuthVerifi", userId);
	}
	
	@Override
	public AccountVO loginAccount(LoginDTO logindto) throws Exception {
		
		System.out.println(logindto);
		// 로그인 처리(아이디랑 비밀번호로 유저 찾아오기)
		return ses.selectOne(NS+".loginAccount", logindto);
	}
	
	@Override
	public Boolean existsAccountId(String userId) throws Exception {
		return ses.selectOne(NS+".existsAccountId", userId);
	}

	@Override
	public void increaseFailCount(String userId) throws Exception {
		// 로그인 실패하면 해당 아이디 실패횟수 증가
		ses.update(NS + ".increaseFailCount", userId);
	}

	@Override
	public int getFailCount(String userId) throws Exception {
		// 현제 실패 횟수 가져오기
	    return ses.selectOne(NS + ".getFailCount", userId);
	}
	
	@Override
	public void setRequiresVerification(String userId) throws Exception {
		// 인증필요컬럼 인증해야함(Y)로 변경
	    // 원하는걸로 바꾸는거 하려했는데 생각해보니 id기준으로 해제할 일이 없어서 그냥 필요만 넣기로...
	    ses.update(NS + ".setRequiresVerification", userId);
	}

	@Override
	public void resetFailCount(String userId) throws Exception {
		//로그인 성공하면 실패횟수 초기화용
		ses.update(NS + ".resetFailCount", userId);
	}

	@Override
	public AccountVO getAccountByUid(int uid) throws Exception {
		return ses.selectOne(NS + ".getAccountByUid", uid);
	}

	@Override
	public void setAutoLogin(LoginDTO loginDto) throws Exception {
		ses.update(NS + ".setAutoLogin", loginDto);
	}

	@Override
	public void setLoginTime(int uid) throws Exception {
		ses.update(NS + ".setLastLoginDate", uid);
	}

	@Override
	public AccountVO getAccountByAutoLogin(String sessionId) throws Exception {
		return ses.selectOne(NS + ".getAccountByAutoLogin", sessionId);
	}

	@Override
	public AccountVO findAccountByEmail(String email) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("targetType", "email");
		map.put("targetValue", email);
		
		AccountVO result = ses.selectOne(NS + ".findByContect", map);
		return result;
	}
	
	@Override
	public AccountVO findAccountByMobile(String mobile) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("targetType", "mobile");
		map.put("targetValue", mobile);
		
		AccountVO result = ses.selectOne(NS + ".findByContect", map);
		return result;
	}
	
	@Override
	public String getIdByContect(findIdDTO dto) throws Exception {
		AccountVO result = ses.selectOne(NS + ".findByContect", dto);
		return result.getAccountId();
	}

}
