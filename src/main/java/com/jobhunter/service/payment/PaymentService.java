package com.jobhunter.service.payment;

import com.jobhunter.model.payment.PaymentLogDTO;

public interface PaymentService {
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 결제로그를 등록하는 메서드
	 * </p>
	 * 
	 * @param paymentLogDTO 
	 * @return 변화한 row의 갯수
	 * @throws Exception
	 *
	 */
	public int savePanymentLog(PaymentLogDTO paymentLogDTO) throws Exception;

}
