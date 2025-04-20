package com.jobhunter.model.payment;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * @author 문준봉
 *
 *<p>결제 로그 DTO</p>
 */
@Data
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@ToString
public class PaymentLogDTO {
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
	

}
