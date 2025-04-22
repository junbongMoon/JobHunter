package com.jobhunter.dao.payment;

import com.jobhunter.model.payment.PaymentLogDTO;

public interface PaymentDAO {
	int insertPanymentLog(PaymentLogDTO paymentLogDTO) throws Exception;

}
