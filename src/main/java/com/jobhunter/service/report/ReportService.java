package com.jobhunter.service.report;

import com.jobhunter.model.report.AccountReportDTO;
import com.jobhunter.model.report.BoardReportDTO;

public interface ReportService {

	void saveAccountReport(AccountReportDTO dto) throws Exception;

	void saveBoardReport(BoardReportDTO dro) throws Exception;

}
