package com.jobhunter.controller.report;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.customenum.ReportCategory;
import com.jobhunter.model.customenum.ReportType;
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
	public ResponseEntity<Void> reportBoard(@RequestBody BoardReportDTO boardReportDTO, HttpSession session, Model model) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		
		System.out.println("BoardReportDTO : " + boardReportDTO);

		if (account == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}

		try {
			// 신고자 UID 설정
			boardReportDTO.setReporterAccountUid(account.getUid());

			// Enum, URL 등 자동값 설정
			if(boardReportDTO.getReportType() == ReportType.BOARD) {
				System.out.println("여기 들어옴");
				boardReportDTO.applyDefaultValues();
			}		

			// 서비스로 위임
			reportService.saveBoardReport(boardReportDTO);
			model.addAttribute("reportCategories", ReportCategory.values());
			return ResponseEntity.ok().build();

		} catch (Exception e) {
			e.printStackTrace(); // 콘솔 로그
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	
	

}
