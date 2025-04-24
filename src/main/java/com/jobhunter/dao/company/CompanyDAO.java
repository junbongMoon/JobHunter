package com.jobhunter.dao.company;

import java.sql.Timestamp;
import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.CompanyInfoDTO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.company.CompanyVO;

public interface CompanyDAO {

	CompanyVO getCompanyInfo(String uid) throws Exception;

	AccountVO findByUidAndPassword(String uid, String password) throws Exception;

	void updatePassword(String uid, String newPassword) throws Exception;

	void updateEmail(Map<String, String> paramMap) throws Exception;

	void updateMobile(Map<String, String> paramMap) throws Exception;

	boolean findIsCompanyById(String companyId) throws Exception;

	Integer registCompany(CompanyRegisterDTO dto) throws Exception;

	int updateCompanyInfo(CompanyInfoDTO companyInfo) throws Exception;

	int deleteMobile(String uid) throws Exception;

	int deleteEmail(String uid) throws Exception;
	
	void setDeleteAccount(Integer uid) throws Exception;

	void updateProfileImg(Integer uid, String base64) throws Exception;

	Timestamp getDeleteAccount(Integer uid) throws Exception;

	void cancelDeleteAccount(Integer uid) throws Exception;

}
