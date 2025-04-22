package com.jobhunter.model.report;

import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.customenum.ReportCategory;
import com.jobhunter.model.customenum.ReportType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor  
@AllArgsConstructor
@Builder
public class BoardReportDTO {

	private ReportType reportType; // 항상 BOARD
	private Integer targetAccountUid; // 피신고자 (게시글 작성자 uid)
	private int boardNo;
	private AccountType targetAccountType; // 피신고자 타입 (USER)
	private Integer reporterAccountUid; // 신고자 uid
	private AccountType reporterAccountType; // 신고자 타입
	private ReportCategory reportCategory; // 신고 사유 (스팸, 욕설 등)
	private String reportMessage; // 상세 설명
	private String reportTargetURL; // 해당 게시글 상세 URL


	// 필요 시 값 자동 설정 메서드 추가
	public void applyDefaultValues() {
		this.reportType = ReportType.BOARD;
	
		if (this.targetAccountType == null) this.targetAccountType = AccountType.USER;
		if (this.reporterAccountType == null) this.reporterAccountType = AccountType.USER;
		if (this.reportTargetURL == null && targetAccountUid != null) {
			this.reportTargetURL = "/reviewBoard/detail?boardNo=" + targetAccountUid;
		}
	}
}
