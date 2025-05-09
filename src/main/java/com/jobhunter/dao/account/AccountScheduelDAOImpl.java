package com.jobhunter.dao.account;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AccountScheduelDAOImpl implements AccountScheduelDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.accountscheduelmapper";
	
	@Override
	public List<Integer> findExpiredUserUids(int limit) {
		return ses.selectList(NS + ".findExpiredUsersUids", limit);
	}
	@Override
	public void insertDeleteUserLogByUid(int uid) {
		ses.delete(NS + ".insertDeleteUserLogByUid", uid);
	}
	@Override
	public void deleteUser(int uid) {
		ses.delete(NS + ".deleteUserByUid", uid);
	}
	
	@Override
	public List<Integer> findExpiredCompanyUids(int limit) {
		return ses.selectList(NS + ".findExpiredCompanyUids", limit);
	}
	@Override
	public void insertDeleteCompanyLogByUid(int uid) {
		ses.delete(NS + ".insertDeleteCompanyLogByUid", uid);
	}
	@Override
	public void deleteCompany(int uid) {
		ses.delete(NS + ".deleteCompanyByUid", uid);
	}
	
}
