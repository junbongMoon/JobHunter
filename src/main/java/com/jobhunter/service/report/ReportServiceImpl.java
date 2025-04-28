package com.jobhunter.service.report;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.report.ReportDAO;
import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.customenum.ReportType;
import com.jobhunter.model.report.AccountReportDTO;
import com.jobhunter.model.report.BoardReportDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {
	
	private final ReportDAO dao;

	private final ReviewBoardDAO Rdao;
	
	@Override
	public void saveAccountReport(AccountReportDTO dto) throws Exception {
		
		// reportType, reportTargetPK 자동 설정
	    dto.setReportType();
	    dto.setReportTargetPK();
	   
	    dao.insertAccountReport(dto);
	}

	@Override
	public void saveBoardReport(BoardReportDTO dro) throws Exception {
    

		
		System.out.println("dro : " + dro);
		
		if (dro.getTargetAccountUid() == null) {
			throw new IllegalArgumentException("해당 게시글의 작성자를 찾을 수 없습니다.");
		}
		



		if (dro.getReporterAccountUid().equals(dro.getTargetAccountUid()) && dro.getReporterAccountType().equals(dro.getTargetAccountType())) {
	        throw new IllegalArgumentException("본인이 작성한 게시글은 신고할 수 없습니다.");
	    }

		
	
		dao.insertBoardReport(dro);
		
	}
}
