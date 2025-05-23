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

	private ReportType reportType; // 신고할 타겟 타입
	private Integer targetAccountUid; // 피신고자 (게시글 작성자 uid)
	private int reportTargetPK; // 신고할 타겟의 PK
	private int boardNo;
	private AccountType targetAccountType; // 피신고자 타입 (USER)
	private Integer reporterAccountUid; // 신고자 uid
	private AccountType reporterAccountType; // 신고자 타입
	private ReportCategory reportCategory; // 신고 사유 (스팸, 욕설 등)
	private String reportMessage; // 상세 설명
	private String reportTargetURL; // 해당 게시글 상세 URL

	// 필요 시 값 자동 설정 메서드 추가
	public void applyDefaultValues() {
		

		if (this.targetAccountType == null) {
			this.targetAccountType = AccountType.USER;
		}

		if (this.reporterAccountType == null) {
			this.reporterAccountType = AccountType.USER;
		}

		// URL은 boardNo 기준으로 생성
		if (this.reportTargetURL == null && boardNo > 0) {
			this.reportTargetURL = "/reviewBoard/detail?boardNo=" + boardNo;
		}
	}
}
