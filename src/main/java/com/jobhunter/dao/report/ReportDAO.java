package com.jobhunter.dao.report;

import com.jobhunter.model.report.AccountReportDTO;
import com.jobhunter.model.report.BoardReportDTO;

public interface ReportDAO {

	void insertAccountReport(AccountReportDTO dto) throws Exception;

	void insertBoardReport(BoardReportDTO dro) throws Exception;

}
