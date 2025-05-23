package com.jobhunter.model.user;

import java.sql.Timestamp;

import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.customenum.Gender;
import com.jobhunter.model.customenum.MilitaryServe;
import com.jobhunter.model.customenum.Nationality;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@Getter
@Setter
@ToString
public class UserAllVO {
	private Integer uid; // 사용자 고유 ID
    private String userName; // 사용자 이름
    private String mobile; // 전화번호
    private String email; // 이메일
    private String addr; // 주소
    private Gender gender; // 성별 (MALE: 남성, FEMALE: 여성)
    private Integer age; // 나이
    private Timestamp regDate; // 가입 일자
    private AccountType accountType; // 회원 유형
    private String isMentor; //  멘토 권한 ("Y": 멘토, "N": 일반 사용자)
    private String requiresVerification; // 인증 필요 여부 ("Y" 또는 "N")
    private Timestamp blockDeadline; // 계정 정지 기한
    private Timestamp deleteDeadline; // 계정 삭제 대기 기한
    private String blockReason; // 계정 정지 사유
    private Integer loginCnt; // 로그인 실패 횟수
    private Timestamp lastLoginDate; // 마지막 로그인 일자
    private String payType; // 희망 급여 유형
    private Integer pay; // 희망 급여 금액
    private String introduce; // 자기소개
    private String isSocial; // 소셜 로그인 여부 ("Y": 소셜 로그인 사용자, "N": 일반 사용자)
    private MilitaryServe militaryService; // 병역 사항 (NOT_COMPLETED: 미필, COMPLETED: 군필, EXEMPTED: 면제)
    private Nationality nationality; // 국적 (KOREAN: 한국인, FOREIGNER: 외국인)
    private String disability; // 장애 여부
    
//    private List<ResumeVO> resumes;
//    private List<ReviewBoardVO> reviewBoards;
//    private List<ReviewLikeVO> reviewLikes;
}
