package com.jobhunter.dao.recruitmentnotice;

import java.time.LocalDateTime;
import java.util.List;

import com.jobhunter.model.customenum.Method;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.Application;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

public interface RecruitmentNoticeDAO {
	// 공고를 입력하는 메서드
	int insertRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception;
	
	// 내가 쓴 공고를 select하는 메서드
	RecruitmentDetailInfo selectRecruitmentByUid(int uid) throws Exception;
	
	// 우대조건을 insert하는  메서드
	int insertAdvantageWithRecruitmentNotice(AdvantageDTO advantageDTO) throws Exception;
	
	// 면접 방식을 insert하는 메서드
	int insertApplicationWithRecruitmentNotice(ApplicationDTO applicationDTO) throws Exception;
	
	// 가장 최근에 올린 공고의 uid를 가져오는 메서드
	int selectRecentRecruitment(int companyUid);
	
	// 파일을 업로드하는 메서드
	int insertRecruitmentFile(RecruitmentnoticeBoardUpfiles file) throws Exception;

	// 전체 공고수를 가져오는 메서드
	int selectRecruitmentTotalCount(PageRequestDTO pageRequestDTO) throws Exception;
	
	// 키워드에 따라 페이징 된 공고를 가져오는 메서드
	List<RecruitmentDetailInfo> selectRecruitmentWithKeyword(PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO);
	
	// uid를 가지고 면접타입들을 조회하는 메서드
	List<Application> getApplications(int recruitmentNoticeUid) throws Exception;
	
	// uid를 가지고 우대조건들을 조회하는 메서드
	List<Advantage> getAdvantages(int recruitmentNoticeUid) throws Exception;
	
	// 검색어에 따라 list를 조회하는 메서드
	int getSearchResultRowCount(PageRequestDTO pageRequestDTO) throws Exception;
	
	// 총 row의 갯수 얻어오는 메서드
	int getTotalCountRow() throws Exception;
	
	// 공고의 uid를 매개변수로 RecruitmentnoticeBoardUpfiles를 조회하는 메서드
	List<RecruitmentnoticeBoardUpfiles> getFileList(int uid);
	
	// 공고를 삭제하는 메서드
	int deleteRecruitmentByUid(int uid) throws Exception;
	
	// 공고를 수정하는 메서드
	void updateRecruitmentNotice(RecruitmentNoticeDTO dto) throws Exception;
	
	// 면접 방식을 삭제하는 메서드
	void deleteApplication(int uid, Method method) throws Exception;
	
	// 파일을 삭제하는 메서드
	void deleteFileFromDatabase(int boardUpFileNo);
	
	// 우대조건을 삭제하는 메서드
	void deleteAdvantage(int uid, String advantageType) throws Exception;
	
	// 내가 작성한 공고수를 가져오는 메서드
	int getTotalCountRowByCompanyUid(int companyUid);
	
	// 내가 작성한 공고 리스트를 조회하는 메서드
	List<RecruitmentNotice> selectRecruitmentByCompanyUid(int companyUid,
			PageResponseDTO<RecruitmentNotice> pageResponseDTO);

	RecruitmentNotice selectPreviousPost(int uid) throws Exception;

	RecruitmentNotice selectNextPost(int uid) throws Exception;

	int countByCreatedDateBetween(LocalDateTime start, LocalDateTime end);
}
