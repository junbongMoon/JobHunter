package com.jobhunter.dao.company;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.CompanyInfoDTO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CompanyDAOImpl implements CompanyDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.companymapper";
	
	@Override
	public CompanyVO getCompanyInfo(int uid) throws Exception {
		CompanyVO vo = ses.selectOne(NS+".getCompanyInfo", uid);
		if (vo != null && (vo.getCompanyImg() == null || vo.getCompanyImg().isEmpty())) {
			vo.setCompanyImg(null); // 세터가 기본이미지 설정함
		}
		return vo;
	}
	
	@Override
	public int updateCompanyInfo(CompanyInfoDTO companyInfo) throws Exception {
		System.out.println(companyInfo);
		return ses.update(NS + ".updateCompanyInfo", companyInfo);
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
	public boolean findIsCompanyById(String companyId) throws Exception {
		Boolean result = ses.selectOne(NS + ".findIsCompanyById", companyId);
	    return Boolean.TRUE.equals(result);
	}

	@Override
	public Integer registCompany(CompanyRegisterDTO dto) throws Exception {
		int result = ses.insert(NS + ".registCompany", dto);
		if (result > 0) {
			return dto.getUid();
		}
		return 0;
	}
	
	@Override
	public int deleteMobile(Integer uid) throws Exception {
		return ses.update(NS + ".deleteMobile", uid);
	}
	
	@Override
	public int deleteEmail(Integer uid) throws Exception {
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
	public void updateProfileImg(Integer uid, String base64) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("uid", uid);
	    paramMap.put("img", base64);
	    
		ses.update(NS + ".updateProfileImg", paramMap);
	}
}
