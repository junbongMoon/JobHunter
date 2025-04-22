package com.jobhunter.model.payment;

import java.time.LocalDateTime;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@ToString
public class PaymentLogVO {
	/**
	 * 로그 PK값
	 */
	private int LogNo;
	/**
	 * 유저 PK값
	 */
	private int useruid;
	/**
	 * 카카오 결제 고유번호
	 */
	private String tid;
	/**
	 * 결제 금액
	 */
	private int amount;
	/**
	 * 결제한 상품명
	 */
	private String item_name;
	
	/**
	 * 로그 생성일
	 */
	private LocalDateTime created_at;

}
