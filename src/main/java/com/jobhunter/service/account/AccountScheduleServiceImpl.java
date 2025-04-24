package com.jobhunter.service.account;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.account.AccountScheduelDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AccountScheduleServiceImpl implements AccountScheduleService {
	private final AccountScheduelDAO dao;
	
	@Override
	public void deleteAccount() {
		dao.deleteUser();
		dao.deleteCompany();
	}

}
