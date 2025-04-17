package com.jobhunter.model.submit;

import java.util.List;

import com.jobhunter.model.category.SubCategory;
import com.jobhunter.model.region.Sigungu;
import com.jobhunter.model.resume.EducationDTO;
import com.jobhunter.model.resume.JobFormDTO;
import com.jobhunter.model.resume.LicenseDTO;
import com.jobhunter.model.resume.MeritDTO;
import com.jobhunter.model.resume.PersonalHistoryDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SubCategoryDTO;

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
public class ResumeDetailInfoBySubmit {
	// 제출 pk
	private int registrationNo;
	// 이력서 pk
	private int resumeNo;
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
    
    // 첨부파일 리스트
    private List<ResumeUpfileDTO> files;
    
    // 시군구 
    private List<Sigungu> sigunguList;
    
    // 직업군
    private List<SubCategory> subcategoryList;

}
