package com.jobhunter.service.recruitmentnotice;

import java.util.List;

import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

public interface RecruitmentNoticeService {
	// 공고를 입력하는 메서드
	boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO, List<AdvantageDTO> advantageList, List<ApplicationDTO> applicationList, String regionCode, String sigunguCode, List<RecruitmentnoticeBoardUpfiles> fileList, String majorCategortCode, String subCategoryCode) throws Exception;
	// 내가 작성한 공고를 조회하는 메서드
	List<RecruitmentNotice> getRecruitmentByUid(int uid) throws Exception;
	// 내가 작성한 공고(템플릿)을 조회하는 메서드
	List<RecruitmentNotice> getRecruitmenTempByUid(int uid) throws Exception;	 
	// 공고 전체를 조회하는 메서드(템플릿 제외)
	List<RecruitmentNotice> getEntireRecruitment() throws Exception;
	// 파일을 실제 db에 저장하는 메서드
	
	// 공고를 수정하는 메서드 
	
	// 공고를 삭제하는 메서드
	 
	// 템플릿 공고를 저장하는 메서드(공고를 입력하는 메서드와 같되 status값만 'N'으로)
	// 그냥 dynamic sql을 사용하자.. 또 만들지 말자... view에서 input hidden으로 두면 될듯
	
}
