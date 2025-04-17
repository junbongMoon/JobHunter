package com.jobhunter.customexception;

public class LoginBlockedException extends RuntimeException {

	private final int remainingSeconds;

    public LoginBlockedException(int remainingSeconds) {
        super("로그인 차단 중, 남은 시간: " + remainingSeconds + "초");
        this.remainingSeconds = remainingSeconds;
    }

    public int getRemainingSeconds() {
        return remainingSeconds;
    }
}
