package com.jobhunter.service.recruitmentnotice;

import java.util.List;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

public interface RecruitmentNoticeService {
	// 공고를 입력하는 메서드
	boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO, List<AdvantageDTO> advantageList, List<ApplicationDTO> applicationList, List<RecruitmentnoticeBoardUpfiles> fileList) throws Exception;
	// uid로 공고를 조회하는 메서드
	RecruitmentDetailInfo getRecruitmentByUid(int uid) throws Exception;
		 
	// 공고 전체를 조회하는 메서드(템플릿 제외)
	PageResponseDTO<RecruitmentDetailInfo> getEntireRecruitment(PageRequestDTO pageRequestDTO) throws Exception;
	
	// 공고를 수정하는 메서드 
	
	
	// 공고를 삭제하는 메서드
	boolean removeRecruitmentByUid(int uid) throws Exception;
	
	// 공고를 수정하는 메서드
	void modifyRecruitmentNotice(RecruitmentNoticeDTO dto, List<AdvantageDTO> advantageList,
			List<ApplicationDTO> applicationList, List<RecruitmentnoticeBoardUpfiles> fileList,
			RecruitmentDetailInfo existing, int uid) throws Exception;
	// 파일을 삭제하는 메서드
	void deleteFileFromDatabase(int boardUpFileNo);
	//
	PageResponseDTO<RecruitmentNotice> getRecruitmentByCompanyUid(int companyUid, PageRequestDTO pageRequestDTO);
	
}
