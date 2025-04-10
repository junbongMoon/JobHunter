package com.jobhunter.service.company;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.BusinessRequestDTO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.company.CompanyVO;

public interface CompanyService {

	CompanyVO showCompanyHome(String uid) throws Exception;

	boolean checkPassword(String uid, String password) throws Exception;

	void updatePassword(String uid, String password) throws Exception;

	String updateContact(String uid, String type, String value) throws Exception;

	String valiedBusiness(BusinessRequestDTO dto) throws Exception;

	boolean isCompanyIdExists(String companyId) throws Exception;

	AccountVO registUser(CompanyRegisterDTO dto) throws Exception;

}
