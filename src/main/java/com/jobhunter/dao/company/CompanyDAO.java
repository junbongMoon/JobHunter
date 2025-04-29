package com.jobhunter.dao.company;

import java.sql.Timestamp;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.CompanyInfoDTO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;

public interface CompanyDAO {

	CompanyVO getCompanyInfo(String uid) throws Exception;

	AccountVO findByUidAndPassword(int uid, String password) throws Exception;

	void updatePassword(PasswordDTO dto) throws Exception;
	
	void updateContact(ContactUpdateDTO dto) throws Exception;

	boolean findIsCompanyById(String companyId) throws Exception;

	Integer registCompany(CompanyRegisterDTO dto) throws Exception;

	int updateCompanyInfo(CompanyInfoDTO companyInfo) throws Exception;

	int deleteMobile(Integer uid) throws Exception;

	int deleteEmail(Integer uid) throws Exception;
	
	void setDeleteAccount(Integer uid) throws Exception;

	void updateProfileImg(Integer uid, String base64) throws Exception;

	Timestamp getDeleteAccount(Integer uid) throws Exception;

	void cancelDeleteAccount(Integer uid) throws Exception;

}
