package com.jobhunter.dao.recruitmentnotice;

import java.util.List;

import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

public interface RecruitmentNoticeDAO {
	// 공고를 입력하는 메서드
	int insertRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception;

	List<RecruitmentNotice> selectRecruitmentByUid(int uid) throws Exception;

	int insertAdvantageWithRecruitmentNotice(AdvantageDTO advantageDTO) throws Exception;
	
	int insertApplicationWithRecruitmentNotice(ApplicationDTO applicationDTO) throws Exception;

	int selectRecentRecruitment(int companyUid);

	int insertRecruitmentFile(RecruitmentnoticeBoardUpfiles file) throws Exception;

	

	

}
