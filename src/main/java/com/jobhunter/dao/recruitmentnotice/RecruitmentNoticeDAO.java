package com.jobhunter.dao.recruitmentnotice;

import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;

public interface RecruitmentNoticeDAO {
	// 공고를 입력하는 메서드
	int insertRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception;

}
