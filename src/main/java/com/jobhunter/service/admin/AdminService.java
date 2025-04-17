package com.jobhunter.service.admin;

import java.sql.Timestamp;
import java.util.List;

import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;

public interface AdminService {

	List<UserVO> getAllUsers() throws Exception;

	UserVO getUserById(int uid) throws Exception;

	List<UserVO> getUsersBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize)
			throws Exception;

	int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	boolean blockUser(int uid, Timestamp blockDeadline, String reason) throws Exception;

	boolean unblockUser(int uid) throws Exception;

	List<CompanyVO> getAllCompanies() throws Exception;

	CompanyVO getCompanyById(int uid) throws Exception;

	List<CompanyVO> getCompaniesBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize)
			throws Exception;

	int getTotalCompanyCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	boolean blockCompany(int uid, Timestamp blockDeadline, String reason) throws Exception;

	boolean unblockCompany(int uid) throws Exception;

}
