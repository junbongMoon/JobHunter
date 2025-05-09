package com.jobhunter.dao.account;

import java.util.List;

public interface AccountScheduelDAO {

	void deleteUser(int uid);
	void deleteCompany(int uid);
	List<Integer> findExpiredCompanyUids(int limit);
	List<Integer> findExpiredUserUids(int limit);
	void insertDeleteUserLogByUid(int uid);
	void insertDeleteCompanyLogByUid(int uid);

}
