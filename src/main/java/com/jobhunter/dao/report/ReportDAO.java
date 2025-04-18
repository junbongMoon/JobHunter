package com.jobhunter.dao.report;

import com.jobhunter.model.report.AccountReportDTO;

public interface ReportDAO {

	void insertAccountReport(AccountReportDTO dto) throws Exception;

}
