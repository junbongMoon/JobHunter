package com.jobhunter.service.recruitmentnotice;

import java.util.List;

import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;

public interface RecruitmentNoticeService {
	// 공고를 입력하는 메서드
	boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception;
	// 내가 작성한 공고를 조회하는 메서드
	List<RecruitmentNotice> getRecruitmentByUid(int uid) throws Exception;
	// 내가 작성한 공고(템플릿)을 조회하는 메서드
	void saveAdvantage(AdvantageDTO advantageDTO) throws Exception;
	
	 
	// 내가 등록한 공고를 조회하는 메서드
	 
	// 공고 전체를 조회하는 메서드
	
	// 공고를 수정하는 메서드 
	
	// 공고를 삭제하는 메서드
	 
	// 템플릿 공고를 저장하는 메서드(공고를 입력하는 메서드와 같되 status값만 'N'으로)
}
