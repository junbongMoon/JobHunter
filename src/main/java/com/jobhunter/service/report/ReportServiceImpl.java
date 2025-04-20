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
		
		// reportType, reportTargetURL 자동 설정
	    dto.setReportType();
	    dto.setReportTargetURL();
	   
	    dao.insertAccountReport(dto);
	}

	@Override
	public void saveBoardReport(BoardReportDTO dro) throws Exception {
		Integer writerUid = Rdao.findWriterUidByBoardNo(dro.getBoardNo());

		if (writerUid == null) {
			throw new IllegalArgumentException("해당 게시글의 작성자를 찾을 수 없습니다.");
		}

		// 작성자 정보를 DTO에 세팅
		dro.setTargetAccountUid(writerUid);
		dro.setTargetAccountType(AccountType.USER);
		dro.setReportType(ReportType.BOARD);        
		dro.setReportTargetURL("/reviewBoard/detail?boardNo=" + dro.getBoardNo());
	

		
	
		dao.insertBoardReport(dro);
		
	}
}
