package com.jobhunter.model.submit;

import java.util.List;

import com.jobhunter.model.category.SubCategory;
import com.jobhunter.model.customenum.Gender;
import com.jobhunter.model.customenum.MilitaryServe;
import com.jobhunter.model.customenum.Nationality;
import com.jobhunter.model.region.Sigungu;
import com.jobhunter.model.resume.EducationDTO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.LicenseDTO;
import com.jobhunter.model.resume.MeritDTO;
import com.jobhunter.model.resume.PersonalHistoryDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ResumeDetailInfoBySubmitAndUser {
	// 제출 pk
	private int registrationNo;
	// 이력서 pk
	private int resumeNo;
	// 공고 pk
	private int recruitmentNoticePk;
	// 제목
	private String title;
	// 급여형태
	private String payType;
	// 급여액수
	private int pay;
	// 자기소개
	private String introduce;
	// 저장타입
	private String saveType;
	// 작성의 user의 PK
	private int userUid;
	// 제출 이력
	private RegistrationVO registrationVO;
	
	// 고용 형태 리스트
    private List<JobFormDTO> jobForms;
    
    // 성격 및 강점 리스트
    private List<MeritDTO> merits;
    
    // 학력 리스트
    private List<EducationDTO> educations;

    // 경력 리스트
    private List<PersonalHistoryDTO> histories;

    // 자격증 리스트
    private List<LicenseDTO> licenses;
    
    // 시군구 
    private List<Sigungu> sigunguList;
    
    // 직업군
    private List<SubCategory> subcategoryList;
    
    // 프로필 사진 (Base64 문자열)
    private String profileBase64;
    
    
    
    // 유저 기본정보
    private String userName; // 사용자 이름
    private String mobile; // 전화번호
    private String email; // 이메일
    private String addr; // 이메일
    private Gender gender; // 성별 (MALE: 남성, FEMALE: 여성)
    private Integer age; // 나이
    
    private MilitaryServe militaryService; // 병역 사항 (NOT_COMPLETED: 미필, COMPLETED: 군필, EXEMPTED: 면제)
    private Nationality nationality; // 국적 (KOREAN: 한국인, FOREIGNER: 외국인)
    private String disability; // 장애 여부

}
