package com.jobhunter.customexception;

import com.jobhunter.model.account.UnlockDTO;

public class AccountLockException extends RuntimeException {

	private final UnlockDTO unlockDTO;

    public AccountLockException(UnlockDTO unlockDTO) {
        super("인증이 필요한 계정입니다.");
        this.unlockDTO = unlockDTO;
    }

    public UnlockDTO getUnlockDTO() {
        return unlockDTO;
    }
}
