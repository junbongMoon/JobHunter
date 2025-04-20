package com.jobhunter.controller.report;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.report.AccountReportDTO;
import com.jobhunter.model.report.BoardReportDTO;
import com.jobhunter.service.report.ReportService;

import lombok.RequiredArgsConstructor;

/**
 * 계정 신고기능 관련 컨트롤러입니다.
 * <p>
 * 계정 관련의 신고기능의 API 처리를 맡습니다.
 * </p>
 */
@RestController
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportRestController {
	private final ReportService reportService;

	@PostMapping("/account")
	public ResponseEntity<Void> reportAccount(@RequestBody AccountReportDTO dto) {
		// 실제 신고 저장 처리 (서비스에서 DB 저장 등)
		try {
			reportService.saveAccountReport(dto);

			return ResponseEntity.ok().build(); // 상태 코드 200 OK 응답
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 상태 코드 500 응답
		}
	}

	@PostMapping("/board")
	public ResponseEntity<Void> reportBoard(@RequestBody BoardReportDTO boardReportDTO , HttpSession session) {
		 AccountVO account = (AccountVO) session.getAttribute("account");
		 if (account == null) {
		        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		    }
		 
		 try {
			boardReportDTO.setReporterAccountUid(account.getUid());
			boardReportDTO.applyDefaultValues();
		
			reportService.saveBoardReport(boardReportDTO);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			e.printStackTrace(); // 로그 찍기
			return ResponseEntity.status(500).build();
		}
	}

}
