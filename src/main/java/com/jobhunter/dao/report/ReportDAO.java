package com.jobhunter.dao.report;

import java.util.List;

import com.jobhunter.model.report.AccountReportDTO;

import com.jobhunter.model.report.BoardReportDTO;

import com.jobhunter.model.report.ReportMessageVO;


public interface ReportDAO {

	void insertAccountReport(AccountReportDTO dto) throws Exception;
	
	/**
	 * reporterAccountType이 USER인 신고 데이터를 조회합니다.
	 * 
	 * @return 신고 데이터 목록
	 * @throws Exception
	 */
	List<ReportMessageVO> getReportsByUserReporter() throws Exception;

	void insertBoardReport(BoardReportDTO dro) throws Exception;

}
