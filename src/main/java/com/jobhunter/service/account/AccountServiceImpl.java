package com.jobhunter.service.account;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.customexception.AccountLockException;
import com.jobhunter.customexception.LoginBlockedException;
import com.jobhunter.dao.account.AccountLoginDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.account.LoginFailedDTO;
import com.jobhunter.model.account.UnlockDTO;
import com.jobhunter.model.account.findIdDTO;
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
			throw new IllegalArgumentException("잘못된 계정 형식입니다.");
		}
	}

	@Override
	public void setRequiresVerificationFalse(int uid, AccountType accountType) throws Exception {
		AccountLoginDAO dao = getDAO(accountType);
		dao.setRequiresVerificationFalse(uid);
		dao.getAccountByUid(uid);

	}

	// 인증 필요 여부 들고가려고 맵으로 반환_그냥 널 체크하면 5번 실패한건지도 모르니까
	// auth 값 true면 이메일/폰 인증창 보여주기
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public AccountVO loginAccount(LoginDTO loginDto, String sessionId) throws Exception {

		// dao단 선택하기 (일반/기업회원)
		AccountType accountType = loginDto.getAccountType();
		AccountLoginDAO dao = getDAO(accountType);

		LoginFailedDTO loginFailedDTO = failedMap.getOrDefault(sessionId,
				LoginFailedDTO.builder().loginFailCnt(0).build());

		if (loginFailedDTO.getLoginFailCnt() >= 5) {
			Timestamp now = new Timestamp(System.currentTimeMillis());
			if (loginFailedDTO.getBlockTime() != null && now.before(loginFailedDTO.getBlockTime())) {
				int remainingSeconds = (int) ((loginFailedDTO.getBlockTime().getTime() - now.getTime()) / 1000); // 초
																													// 단위로
																													// 변환

				throw new LoginBlockedException(remainingSeconds);
			} else {
				failedMap.remove(sessionId);
				loginFailedDTO = LoginFailedDTO.builder().loginFailCnt(0).build();
			}
		}

		// 로그인 시도
		AccountVO account = dao.loginAccount(loginDto);

		if (account == null) {
			// 없는 유저거나 비밀번호 틀림

			// 실패 횟수 증가 전에 유저 존재 여부 확인
			if (dao.existsAccountId(loginDto.getId())) {
				int failCount = dao.getFailCount(loginDto.getId());

				// 실패횟수 증가(인증필요 체크 else로 넣으면 카운트 9일때 증가 안하거나 11되야 인증필요되니까 따로
				if (failCount < 10) {

					dao.increaseFailCount(loginDto.getId());
				}

				// 실패횟수 10되면 인증필요 체크하기
				if (failCount + 1 >= 10) {
					dao.setRequiresVerification(loginDto.getId());
				}
			}

			// 실패 횟수 증가 및 차단 여부 판단
			int newFailCount = loginFailedDTO.getLoginFailCnt() + 1;
			loginFailedDTO.setLoginFailCnt(newFailCount);

			if (newFailCount >= 5) {
				int blockSeconds = 30;
				Timestamp blockUntil = new Timestamp(System.currentTimeMillis() + blockSeconds * 1000L);
				loginFailedDTO.setBlockTime(blockUntil);
				failedMap.put(sessionId, loginFailedDTO);
				throw new LoginBlockedException(blockSeconds);
			}

			failedMap.put(sessionId, loginFailedDTO);

			throw new NoSuchElementException();
		} else if ("Y".equals(account.getRequiresVerification())) {
			// 로그인은 했는데 너무 실패해서 정지상태임
			UnlockDTO unlockDTO = new UnlockDTO(account);

			throw new AccountLockException(unlockDTO);

		} else {
			// 로그인 성공

			// 마지막 로그인일자 갱신
			dao.resetFailCount(account.getAccountId());
			dao.setLoginTime(account.getUid());
			failedMap.remove(sessionId);

			// 자동로그인
			if (loginDto.isRemember()) {
				loginDto.setAutoLogin(sessionId);
				dao.setAutoLogin(loginDto);
			}
		}

		return account;
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
	public Boolean checkDuplicateContact(String target, AccountType type, String targetType) throws Exception {
		AccountLoginDAO dao = getDAO(type);
		AccountVO account = dao.findAccountByContact(target, targetType);
		if (account != null) {
			return true;
		}
		return false;
	}

	@Override
	public Map<String, Object> getIdByContect(findIdDTO dto) throws Exception {
		AccountLoginDAO dao = getDAO(dto.getAccountType());
		
		AccountVO account = dao.getIdByContect(dto);
		String id = account.getAccountId();
		
		String maskingId = id.substring(0, 2) + "****" + id.substring(id.length() - 2);
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("Id", maskingId);
		result.put("Uid", account.getUid());

		return result;
	}

}
