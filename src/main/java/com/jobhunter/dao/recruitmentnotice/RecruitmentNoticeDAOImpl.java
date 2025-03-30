package com.jobhunter.dao.recruitmentnotice;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.page.PageRequestDTO;
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

	
	// 사용자(회사) uid로 공고를 조회하는 메서드
	@Override
	public List<RecruitmentNotice> selectRecruitmentByUid(int uid) throws Exception {
		// TODO Auto-generated method stub
		return null;
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
	public List<RecruitmentDetailInfo> selectRecruitmentWithKeyword(PageRequestDTO pageRequestDTO) {
		// TODO Auto-generated method stub
		
		return ses.selectList(NS + ".selectRecruitmentWithPaging", pageRequestDTO);
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


	@Override
	public int getSearchResultRowCount(PageRequestDTO pageRequestDTO) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}


	@Override
	public int getTotalCountRow(PageRequestDTO pageRequestDTO) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}


	

}
