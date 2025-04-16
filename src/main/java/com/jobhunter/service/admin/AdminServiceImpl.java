package com.jobhunter.service.admin;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.admin.AdminDAO;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

	private final AdminDAO dao;

	@Override
	public List<UserVO> getAllUsers() throws Exception {
		return dao.getAllUsers();
	}

	@Override
	public UserVO getUserById(int uid) throws Exception {
		return dao.getUserById(uid);
	}

	@Override
	public List<UserVO> getUsersBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception {
		return dao.getUsersBySearch(searchType, searchKeyword, statusFilter, page, pageSize);
	}

	@Override
	public int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception {
		return dao.getTotalUserCount(searchType, searchKeyword, statusFilter);
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean blockUser(int uid, Timestamp blockDeadline, String reason) throws Exception {
		return dao.blockUser(uid, blockDeadline.toString(), reason) > 0;
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean unblockUser(int uid) throws Exception {
		return dao.unblockUser(uid) > 0;
	}
	
	// 기업 관련 메서드 구현
	@Override
	public List<CompanyVO> getAllCompanies() throws Exception {
		return dao.getAllCompanies();
	}
	
	@Override
	public CompanyVO getCompanyById(int uid) throws Exception {
		return dao.getCompanyById(uid);
	}
	
	@Override
	public List<CompanyVO> getCompaniesBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception {
		return dao.getCompaniesBySearch(searchType, searchKeyword, statusFilter, page, pageSize);
	}
	
	@Override
	public int getTotalCompanyCount(String searchType, String searchKeyword, String statusFilter) throws Exception {
		return dao.getTotalCompanyCount(searchType, searchKeyword, statusFilter);
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean blockCompany(int uid, Timestamp blockDeadline, String reason) throws Exception {
		return dao.blockCompany(uid, blockDeadline.toString(), reason) > 0;
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean unblockCompany(int uid) throws Exception {
		return dao.unblockCompany(uid) > 0;
	}
}
