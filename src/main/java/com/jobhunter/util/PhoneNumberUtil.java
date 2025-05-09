package com.jobhunter.util;

public class PhoneNumberUtil {
	public static String toKoreanFormat(String firebasePhoneNumber) {
        if (firebasePhoneNumber == null || !firebasePhoneNumber.startsWith("+82")) {
            return firebasePhoneNumber; // 국제번호가 아니면 그대로 반환
        }

        // +82 → 0 으로 시작 변경
        String raw = "0" + firebasePhoneNumber.substring(3); // "+82" 제거하고 앞에 0 붙임

        // 숫자만 필터링
        raw = raw.replaceAll("[^0-9]", "");

        // 휴대폰 번호 형식으로 변환 (예: 01012345678 → 010-1234-5678)
        if (raw.length() == 11) {
            return raw.replaceFirst("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
        } else if (raw.length() == 10) {
            return raw.replaceFirst("(\\d{3})(\\d{3})(\\d{4})", "$1-$2-$3");
        } else {
            return raw; // 예외적인 경우 그냥 반환
        }
    }
}
