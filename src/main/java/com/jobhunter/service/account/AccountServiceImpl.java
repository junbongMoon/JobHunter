package com.jobhunter.service.account;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.account.AccountLoginDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.account.LoginFailedDTO;
import com.jobhunter.model.customenum.AccountType;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

	private Map<String, LoginFailedDTO> failedMap = new HashMap<>();
	
	// 인터페이스 통합으로 하려니까 빈객체 주입에 문제생겨서 이걸로 강제주입
	@Autowired
	@Qualifier("userLoginDAO")
	private AccountLoginDAO userDAO;
	// 어떤 빈 주입할지 확실하게 표기할때 쓰는거_@RequiredArgsConstructor랑은 안먹혀서 @Autowired사용
	@Autowired
	@Qualifier("companyLoginDAO")
	private AccountLoginDAO companyDAO;
	
	// DAO 선택 (return했으니까 break 굳이 안넣음)
	private AccountLoginDAO getDAO(AccountType type) {

		switch (type) {
		case USER:
			return userDAO;
		case COMPANY:
			return companyDAO;
		default:
			throw new IllegalArgumentException("Unsupported account type: " + type);
		}
	}

	@Override
	public void setRequiresVerificationFalse(String type, String value, AccountType accountType) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("type", type);
		param.put("value", value);
		getDAO(accountType).setRequiresVerificationFalse(param);
	}

	// 인증 필요 여부 들고가려고 맵으로 반환_그냥 널 체크하면 5번 실패한건지도 모르니까
	// auth 값 true면 이메일/폰 인증창 보여주기
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public Map<String, Object> loginAccount(LoginDTO loginDto, String sessionId) throws Exception {
		Map<String, Object> result = new HashMap<>();

		// dao단 선택하기 (일반/기업회원)
		AccountType accountType = loginDto.getAccountType();
		AccountLoginDAO dao = getDAO(accountType);

		LoginFailedDTO loginFailedDTO = failedMap.getOrDefault(sessionId, LoginFailedDTO.builder().loginFailCnt(0).build());
		
		System.out.println(failedMap);
		
		Timestamp now = new Timestamp(System.currentTimeMillis());
		if(loginFailedDTO.getLoginFailCnt() >= 5) {
			if (loginFailedDTO.getBlockTime() != null && now.before(loginFailedDTO.getBlockTime())) {
				long remainingMillis = loginFailedDTO.getBlockTime().getTime() - now.getTime();
				int remainingSeconds = (int) (remainingMillis / 1000); // 초 단위로 변환
			    
			    result.put("remainingSeconds", remainingSeconds); // 남은 시간(초) 추가
			    return result;
			} else {
				failedMap.remove(sessionId);
				loginFailedDTO = LoginFailedDTO.builder().loginFailCnt(0).build();
			}
		}
		
		// 로그인 시도
		AccountVO account = dao.loginAccount(loginDto);

		if (account == null) {
			// 없는 유저거나 비밀번호 틀림
			
			// 컬렉션 실패횟수 증가
			loginFailedDTO.setLoginFailCnt(loginFailedDTO.getLoginFailCnt() + 1);
			if (loginFailedDTO.getLoginFailCnt() >= 5) {
			    // 로그인 차단 시간 설정 (30초 후)
			    long blockDurationMillis = 30 * 1000; // 30초
			    Timestamp blockUntil = new Timestamp(System.currentTimeMillis() + blockDurationMillis);
			    loginFailedDTO.setBlockTime(blockUntil);
			    result.put("remainingSeconds", 30); // 남은 시간(초) 추가
			};
			failedMap.put(sessionId,loginFailedDTO);
			
			// 실패 횟수 증가 전에 유저 존재 여부 확인
			if (dao.existsAccountId(loginDto.getId())) {
				int failCount = dao.getFailCount(loginDto.getId());

				// 실패횟수 증가(인증필요 체크 else로 넣으면 카운트 29일때 증가 안하거나 31되야 인증필요되니까 따로
				if (failCount < 10) {

					dao.increaseFailCount(loginDto.getId());
				}

				// 실패횟수 30되면 인증필요 체크하기
				if (failCount + 1 >= 10) {
					dao.setRequiresVerification(loginDto.getId());
				}
			}
			result.put("success", false);
			result.put("message", "아이디 또는 비밀번호가 틀렸습니다.");
			return result;
		}

		// 유저 있음 + 로그인 성공
		dao.resetFailCount(account.getAccountId());

		boolean requiresVerification = "Y".equals(account.getRequiresVerification());
		
		if (!requiresVerification) { // 로그인 성공
			// 마지막 로그인일자 갱신
			dao.setLoginTime(account.getUid());
			failedMap.remove(sessionId);
			
			if (loginDto.isRemember()) { // 자동로그인
				loginDto.setAutoLogin(sessionId);
				dao.setAutoLogin(loginDto);
			}
		}
		
		// 결과 정리
		result.put("account", account);
		result.put("auth", requiresVerification);
		result.put("success", true);

		return result;
	}

	@Override
	public AccountVO refreshAccount(int uid, AccountType type) throws Exception {
		return getDAO(type).getAccountByUid(uid);
	}

	@Override
	public AccountVO findAccountByAutoLogin(String sessionId, AccountType type) throws Exception {
		AccountLoginDAO dao = getDAO(type);
		AccountVO account = dao.getAccountByAutoLogin(sessionId);
		if (account != null) {
			boolean requiresVerification = "Y".equals(account.getRequiresVerification());
			if (requiresVerification) {
				dao.setLoginTime(account.getUid());
			}
		}
		return account;
	}

	@Override
	public Boolean checkDuplicateEmail(String email, AccountType type) throws Exception {
		AccountLoginDAO dao = getDAO(type);
		AccountVO account = dao.findAccountByEmail(email);
		if(account != null) {
			return true;
		}
		return false;
	}
	
	@Override
	public Boolean checkDuplicateMobile(String mobile, AccountType type) throws Exception {
		AccountLoginDAO dao = getDAO(type);
		AccountVO account = dao.findAccountByMobile(mobile);
		
		if(account != null) {
			System.out.println(account);
			return true;
		}
		return false;
	}

}
