package com.jobhunter.service.company;

import java.sql.Timestamp;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.BusinessRequestDTO;
import com.jobhunter.model.company.CompanyInfoDTO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;

public interface CompanyService {

	CompanyVO showCompanyHome(String uid) throws Exception;

	boolean checkPassword(int uid, String password) throws Exception;

	void updatePassword(PasswordDTO dto) throws Exception;

	String updateContact(ContactUpdateDTO dto) throws Exception;

	String valiedBusiness(BusinessRequestDTO dto) throws Exception;

	boolean isCompanyIdExists(String companyId) throws Exception;

	AccountVO registCompany(CompanyRegisterDTO dto) throws Exception;

	boolean updateCompanyInfo(CompanyInfoDTO companyInfo) throws Exception;

	void deleteContact(ContactUpdateDTO dto) throws Exception;

	Timestamp setDeleteAccount(Integer uid) throws Exception;

	void updateProfileImg(Integer uid, String base64) throws Exception;

	void deleteProfileImg(Integer uid) throws Exception;

	void cancelDeleteAccount(Integer uid) throws Exception;

}
