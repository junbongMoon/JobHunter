package com.jobhunter.service.report;

import com.jobhunter.model.report.AccountReportDTO;

public interface ReportService {

	void saveAccountReport(AccountReportDTO dto) throws Exception;

}
