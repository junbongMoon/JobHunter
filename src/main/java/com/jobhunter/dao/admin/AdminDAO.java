package com.jobhunter.dao.admin;

import java.util.List;

import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;

public interface AdminDAO {

	List<UserVO> getAllUsers() throws Exception;

	UserVO getUserById(int uid) throws Exception;

	List<UserVO> getUsersBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception;

	int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	int blockUser(int uid, String blockDeadline, String reason) throws Exception;

	int unblockUser(int uid) throws Exception;

	List<CompanyVO> getAllCompanies() throws Exception;

	CompanyVO getCompanyById(int uid) throws Exception;

	List<CompanyVO> getCompaniesBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception;

	int getTotalCompanyCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	int blockCompany(int uid, String blockDeadline, String reason) throws Exception;

	int unblockCompany(int uid) throws Exception;

}
