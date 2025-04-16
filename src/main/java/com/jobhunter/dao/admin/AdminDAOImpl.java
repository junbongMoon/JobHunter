package com.jobhunter.dao.admin;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;

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
	public List<UserVO> getUsersBySearch(Map<String, Object> params) throws Exception {
		return ses.selectList(NS + ".getUsersBySearch", params);
	}

	@Override
	public int getTotalUserCount(Map<String, Object> params) throws Exception {
		return ses.selectOne(NS + ".getTotalUserCount", params);
	}

	@Override
	public int blockUser(Map<String, Object> params) throws Exception {
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
	public List<CompanyVO> getCompaniesBySearch(Map<String, Object> params) throws Exception {
		return ses.selectList(NS + ".getCompaniesBySearch", params);
	}

	@Override
	public int getTotalCompanyCount(Map<String, Object> params) throws Exception {
		return ses.selectOne(NS + ".getTotalCompanyCount", params);
	}

	@Override
	public int blockCompany(Map<String, Object> params) throws Exception {
		return ses.update(NS + ".blockCompany", params);
	}

	@Override
	public int unblockCompany(int uid) throws Exception {
		return ses.update(NS + ".unblockCompany", uid);
	}
}
