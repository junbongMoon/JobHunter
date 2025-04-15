package com.jobhunter.service.admin;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.admin.AdminDAO;
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
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("statusFilter", statusFilter);
		
		int validPage = Math.max(1, page);
		params.put("offset", (validPage - 1) * pageSize);
		params.put("pageSize", pageSize);
		
		return dao.getUsersBySearch(params);
	}

	@Override
	public int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("statusFilter", statusFilter);
		
		return dao.getTotalUserCount(params);
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean blockUser(int uid, Timestamp blockDeadline, String reason) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("uid", uid);
		params.put("blockDeadline", blockDeadline);
		params.put("blockReason", reason);
		
		return dao.blockUser(params) > 0;
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean unblockUser(int uid) throws Exception {
		return dao.unblockUser(uid) > 0;
	}
}
