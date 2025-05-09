package com.jobhunter.dao.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.model.report.ReportMessageVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AdminDAOImpl implements AdminDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.adminmapper";
	
	@Override
	public List<UserVO> getAllUsers() throws Exception {
		return ses.selectList(NS + ".getAllUsers");
	}

	@Override
	public UserVO getUserById(int uid) throws Exception {
		return ses.selectOne(NS + ".getUserById", uid);
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
		
		return ses.selectList(NS + ".getUsersBySearch", params);
	}

	@Override
	public int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("statusFilter", statusFilter);
		
		return ses.selectOne(NS + ".getTotalUserCount", params);
	}

	@Override
	public int blockUser(int uid, String blockDeadline, String reason) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("uid", uid);
		params.put("blockDeadline", blockDeadline);
		params.put("reason", reason);
		
		return ses.update(NS + ".blockUser", params);
	}
	
	@Override
	public int unblockUser(int uid) throws Exception {
		return ses.update(NS + ".unblockUser", uid);
	}

	@Override
	public List<CompanyVO> getAllCompanies() throws Exception {
		return ses.selectList(NS + ".getAllCompanies");
	}

	@Override
	public CompanyVO getCompanyById(int uid) throws Exception {
		return ses.selectOne(NS + ".getCompanyById", uid);
	}

	@Override
	public List<CompanyVO> getCompaniesBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("statusFilter", statusFilter);
		
		int validPage = Math.max(1, page);
		params.put("offset", (validPage - 1) * pageSize);
		params.put("pageSize", pageSize);
		
		return ses.selectList(NS + ".getCompaniesBySearch", params);
	}

	@Override
	public int getTotalCompanyCount(String searchType, String searchKeyword, String statusFilter) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("searchType", searchType);
		params.put("searchKeyword", searchKeyword);
		params.put("statusFilter", statusFilter);
		
		return ses.selectOne(NS + ".getTotalCompanyCount", params);
	}

	@Override
	public int blockCompany(int uid, String blockDeadline, String reason) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("uid", uid);
		params.put("blockDeadline", blockDeadline);
		params.put("reason", reason);
		
		return ses.update(NS + ".blockCompany", params);
	}

	@Override
	public int unblockCompany(int uid) throws Exception {
		return ses.update(NS + ".unblockCompany", uid);
	}
	
	@Override
	public List<ReportMessageVO> getReportsByUserReporter() throws Exception {
		return ses.selectList(NS + ".getReportsByUserReporter");
	}
	
	@Override
	public int updateReportReadStatus(int reportNo, String isRead) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("reportNo", reportNo);
		params.put("isRead", isRead);
		
		return ses.update(NS + ".updateReportReadStatus", params);
	}

	@Override
	public List<ReportMessageVO> getReportsByUserReporterWithFilter(Map<String, String> filterParams, int page, int pageSize) throws Exception {
		Map<String, Object> params = new HashMap<>(filterParams);
		
		int offset = (page - 1) * pageSize;
		params.put("offset", offset);
		params.put("pageSize", pageSize);
		
		return ses.selectList(NS + ".getReportsByUserReporterWithFilter", params);
	}

	@Override
	public int getTotalReportCount(Map<String, String> filterParams) throws Exception {
		return ses.selectOne(NS + ".getTotalReportCount", filterParams);
	}
}
