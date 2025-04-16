package com.jobhunter.dao.recruitmentnotice;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

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

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RecruitmentNoticeDAOImpl implements RecruitmentNoticeDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.recruitmentNoticeMapper"; 
	
	// 공고(템플릿 아님)를 등록하는 메서드
	@Override
	public int insertRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception {
		// 매퍼 완성 안함...
		
		return ses.insert(NS + ".insertRecruitmentnotice", recruitmentNoticeDTO);
	}

	
	// 공고번호 uid로 공고를 조회하는 메서드
	@Override
	public RecruitmentDetailInfo selectRecruitmentByUid(int uid) throws Exception {
		
		return ses.selectOne(NS + ".getBoardDetailInfoByUid", uid);
	}

	// 우대조건을 입력하는 메서드
	@Override
	public int insertAdvantageWithRecruitmentNotice(AdvantageDTO adv) throws Exception{
		
		return ses.insert(NS + ".insertAdvantageWithRecruitmentnotice", adv);
	}
	
	// 면접방식을 입력하는 메서드
	@Override
	public int insertApplicationWithRecruitmentNotice(ApplicationDTO applicationDTO) throws Exception {
		
		return ses.insert(NS +".insertApplicationWithRecruitmentnotice", applicationDTO);
	}

	// 가장 최근에 올린 공고를 조회하는 메서드
	@Override
	public int selectRecentRecruitment(int companyUid) {
		
		return ses.selectOne(NS +".selectMostRecentRecruitmentnoticeByrefCompany", companyUid);
	}

	// 공고에 저장 된 파일을 db에 저장하는 메서드
	@Override
	public int insertRecruitmentFile(RecruitmentnoticeBoardUpfiles file) throws Exception {
		
		return ses.insert(NS +".insertFileWithRecruitmentnotice", file);
	}

	// 공고 row의 총 갯수를 가져오는 메서드(keyword와 searchType에 따라)
	@Override
	public int selectRecruitmentTotalCount(PageRequestDTO pageRequestDTO) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	// 키워드에 따라 공고를 가져오는 메서드
	@Override
	public List<RecruitmentDetailInfo> selectRecruitmentWithKeyword(PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO) {
		// TODO Auto-generated method stub
		
		return ses.selectList(NS + ".selectRecruitmentWithPaging", pageResponseDTO);
	}

	// 면접타입을 가져오는 메서드
	@Override
	public List<Application> getApplications(int recruitmentNoticeUid) throws Exception {
		
		return ses.selectList(NS + ".getApplications", recruitmentNoticeUid);
	}

	// 우대조건들을 가져오는 메서드
	@Override
	public List<Advantage> getAdvantages(int recruitmentNoticeUid) throws Exception {
		
		return ses.selectList(NS + ".getAdvantages", recruitmentNoticeUid);
	}

	// 검색어에 따라 row 총 갯수 조회
	@Override
	public int getSearchResultRowCount(PageRequestDTO pageRequestDTO) throws Exception {
		// TODO Auto-generated method stub
		return ses.selectOne(NS + ".getSearchResultCountRow", pageRequestDTO);
	}

	// row 총 개수 조회
	@Override
	public int getTotalCountRow() throws Exception {
		
		return ses.selectOne(NS + ".getTotalCountRow");
	}

	// 파일 조회하는 메서드
	@Override
	public List<RecruitmentnoticeBoardUpfiles> getFileList(int uid) {
		
		return ses.selectList(NS + ".getFileWithRecruitment", uid);
	}

	// 공고를 삭제하는 메서드
	@Override
	public int deleteRecruitmentByUid(int uid) {
		
		return ses.delete(NS + ".removeRecruitmentByUid", uid);
	}

	// 공고를 수정하는 메서드
	@Override
	public void updateRecruitmentNotice(RecruitmentNoticeDTO dto) throws Exception {
		ses.update(NS +".modifyRecruitmentByUid", dto);
		
	}

	// 접수 방식을 삭제하는 메서드
	@Override
	public void deleteApplication(int uid, Method method) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("uid", uid);
		param.put("method", method);
	
		ses.delete(NS + ".removeApplicationByRecruitmentUid", param);
		
	}



	// 우대조건을 삭제하는 메서드
	@Override
	public void deleteAdvantage(int uid, String advantageType) {
		Map<String, Object> param = new HashMap<>();
		param.put("uid", uid);
		param.put("advantageType", advantageType);

		
		
		ses.delete(NS + ".removeAdvantageByRecruitmentUid", param);
		
	}

	// 파일을 삭제하는 메서드
	@Override
	public void deleteFileFromDatabase(int boardUpFileNo) {
		ses.delete(NS + ".deleteFileFromDatabase", boardUpFileNo);
		
	}

	// 기업이 작성한 공고의 총 갯수를 가져오는 메서드
	@Override
	public int getTotalCountRowByCompanyUid(int companyUid) {
		return ses.selectOne(NS + ".getTotalCountRowByCompanyUid", companyUid);
	}

	// 기업이 작성한 공고리스트를 페이징하여 조회하는 메서드
	@Override
	public List<RecruitmentNotice> selectRecruitmentByCompanyUid(int companyUid, PageResponseDTO<RecruitmentNotice> pageResponseDTO) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("companyUid", companyUid);
	    param.put("startRowIndex", pageResponseDTO.getStartRowIndex());
	    param.put("rowCntPerPage", pageResponseDTO.getRowCntPerPage());

	    return ses.selectList(NS + ".selectRecruitmentByCompanyUid", param);
	}


	@Override
	public RecruitmentNotice selectPreviousPost(int uid) throws Exception {
		// TODO Auto-generated method stub
		return ses.selectOne(NS + ".selectPreviousPost", uid);
	}


	@Override
	public RecruitmentNotice selectNextPost(int uid) throws Exception {
		// TODO Auto-generated method stub
		return ses.selectOne(NS + ".selectNextPost", uid);
	}


	@Override
	public int countByCreatedDateBetween(LocalDateTime start, LocalDateTime end) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("start", start);
		param.put("end", end);
		return ses.selectOne(NS +".countByCreatedDateBetweenAndRole", param);
	}


	@Override
	public void insertCDLogForRecruitment(int recNo) {
		ses.insert(NS + ".insertCreateRecruitmentLog", recNo);
		
	}


	@Override
	public void insertDeleteLogByRecruitment(int uid) {
		ses.insert(NS + ".insertDeleteRecruitmentLog", uid);
		
	}


	@Override
	public int updateDuedateExpireByUid(int uid) {
		
		return ses.update(NS + ".ExpiredDueDateByUid", uid);
	}

	

}
