package com.jobhunter.dao.account;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AccountScheduelDAOImpl implements AccountScheduelDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.accountscheduelmapper";
	@Override
	public void deleteUser() {
		System.out.println("유저 삭제하기");
	}
	@Override
	public void deleteCompany() {
		System.out.println("기업 삭제하기");
	}
}
