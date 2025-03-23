package com.jobhunter.service.account;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.jobhunter.dao.account.AccountLoginDAO;
import com.jobhunter.dao.company.CompanyLoginDAOImpl;
import com.jobhunter.dao.user.UserLoginDAOImpl;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.customenum.AccountType;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

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
		case ADMIN: // 일반유저쪽으로 통합되도록
		case NORMAL:
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
	public Map<String, Object> loginAccount(LoginDTO loginDto) throws Exception {
		Map<String, Object> result = new HashMap<>();

		// dao단 선택하기 (일반/기업회원)
		AccountType accountType = loginDto.getAccountType();
		AccountLoginDAO dao = getDAO(accountType);

		// 로그인 시도
		AccountVO account = dao.loginAccount(loginDto);

		if (account == null) {
			// 없는 유저거나 비밀번호 틀림
			// 실패 횟수 증가 전에 유저 존재 여부 확인
			if (dao.existsAccountId(loginDto.getId())) {
				int failCount = dao.getFailCount(loginDto.getId());

				// 실패횟수 증가(인증필요 체크 else로 넣으면 카운트 4일때 증가 안하거나 6되야 인증필요되니까 따로
				if (failCount < 5) {

					dao.increaseFailCount(loginDto.getId());
				}

				// 실패횟수 5되면 인증필요 체크하기
				if (failCount + 1 >= 5) {
					dao.setRequiresVerification(loginDto.getId());
					result.put("auth", true);
				}
			}
			result.put("success", false);
			result.put("message", "아이디 또는 비밀번호가 틀렸습니다.");
			return result;
		}

		// 유저 있음 + 로그인 성공
		dao.resetFailCount(account.getAccountId());

		boolean requiresVerification = "Y".equals(account.getRequiresVerification());

		result.put("account", account);
		result.put("auth", requiresVerification);
		result.put("success", true);

		return result;
	}

}
