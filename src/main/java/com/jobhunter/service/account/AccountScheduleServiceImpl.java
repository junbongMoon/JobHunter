package com.jobhunter.service.account;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.account.AccountScheduelDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AccountScheduleServiceImpl implements AccountScheduleService {
	private final AccountScheduelDAO dao;
	
	private static final int BATCH_SIZE = 10;
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public void deleteUser() {
		int deleted;
        do {
            List<Integer> expiredUserUids = dao.findExpiredUserUids(BATCH_SIZE);
            deleted = expiredUserUids.size();

            for (int uid : expiredUserUids) {
            	dao.insertDeleteUserLogByUid(uid);
                dao.deleteUser(uid);
            }

        } while (deleted == BATCH_SIZE);
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public void deleteCompany() {
		int deleted;
        do {
            List<Integer> expiredCompanyUids = dao.findExpiredCompanyUids(BATCH_SIZE);
            deleted = expiredCompanyUids.size();

            for (int uid : expiredCompanyUids) {
            	dao.insertDeleteCompanyLogByUid(uid);
                dao.deleteCompany(uid);
            }

        } while (deleted == BATCH_SIZE);
	}

}
