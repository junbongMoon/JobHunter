package com.jobhunter.service.report;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.report.ReportDAO;
import com.jobhunter.model.report.AccountReportDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {
	
	private final ReportDAO dao;
	
	@Override
	public void saveAccountReport(AccountReportDTO dto) throws Exception {
		
		// reportType, reportTargetURL 자동 설정
	    dto.setReportType();
	    dto.setReportTargetURL();
	    
	    dao.insertAccountReport(dto);
	}
}
