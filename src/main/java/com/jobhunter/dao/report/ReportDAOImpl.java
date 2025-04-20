package com.jobhunter.dao.report;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.report.AccountReportDTO;
import com.jobhunter.model.report.BoardReportDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReportDAOImpl implements ReportDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.reportmapper";
	
	@Override
	public void insertAccountReport(AccountReportDTO dto) throws Exception {
		ses.insert(NS + ".insertAccountReport", dto);
	}

	@Override
	public void insertBoardReport(BoardReportDTO dro) throws Exception {
		ses.insert(NS + ".insertBoardReport",dro);
		
	}
	
}
