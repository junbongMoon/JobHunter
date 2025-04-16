package com.jobhunter.dao.admin;

import java.util.List;
import java.util.Map;

import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;

public interface AdminDAO {

	List<UserVO> getAllUsers() throws Exception;

	UserVO getUserById(int uid) throws Exception;

	List<UserVO> getUsersBySearch(Map<String, Object> params) throws Exception;

	int getTotalUserCount(Map<String, Object> params) throws Exception;

	int blockUser(Map<String, Object> params) throws Exception;

	int unblockUser(int uid) throws Exception;

	List<CompanyVO> getAllCompanies() throws Exception;

	CompanyVO getCompanyById(int uid) throws Exception;

	List<CompanyVO> getCompaniesBySearch(Map<String, Object> params) throws Exception;

	int getTotalCompanyCount(Map<String, Object> params) throws Exception;

	int blockCompany(Map<String, Object> params) throws Exception;

	int unblockCompany(int uid) throws Exception;

}
