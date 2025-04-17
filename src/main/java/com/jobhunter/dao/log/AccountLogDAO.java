package com.jobhunter.dao.log;

import com.jobhunter.model.customenum.AccountType;

public interface AccountLogDAO {

	void insertRegisterLog(Integer uid, AccountType accountType) throws Exception;

}
