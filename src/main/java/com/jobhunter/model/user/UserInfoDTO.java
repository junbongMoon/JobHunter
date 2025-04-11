package com.jobhunter.model.user;

import com.jobhunter.model.customenum.Gender;
import com.jobhunter.model.customenum.MilitaryService;
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
@ToString
public class UserInfoDTO {
	private Integer uid; // 사용자 고유 ID
    private String addr; // 주소
    private String detailAddr; // 상세주소
    private Gender gender; // 성별 (MALE: 남성, FEMALE: 여성)
    private Integer age; // 나이
    private String payType; // 희망 급여 유형
    private Integer pay; // 희망 급여 금액
    private String introduce; // 자기소개
    private MilitaryService militaryService; // 병역 사항 (NOT_COMPLETED: 미필, COMPLETED: 군필, EXEMPTED: 면제)
    private Nationality nationality; // 국적 (KOREAN: 한국인, FOREIGNER: 외국인)
    private String disability; // 장애 여부
    
    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public void setAddr(String addr) {
        this.addr = nullIfEmpty(addr);
    }

    public void setDetailAddr(String detailAddr) {
        this.detailAddr = nullIfEmpty(detailAddr);
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public void setPayType(String payType) {
        this.payType = nullIfEmpty(payType);
    }

    public void setPay(Integer pay) {
        this.pay = pay;
    }

    public void setIntroduce(String introduce) {
        this.introduce = nullIfEmpty(introduce);
    }

    public void setMilitaryService(MilitaryService militaryService) {
        this.militaryService = militaryService;
    }

    public void setNationality(Nationality nationality) {
        this.nationality = nationality;
    }

    public void setDisability(String disability) {
        this.disability = nullIfEmpty(disability);
    }

    private String nullIfEmpty(String str) {
        return (str == null || str.trim().isEmpty()) ? null : str.trim();
    }
}
