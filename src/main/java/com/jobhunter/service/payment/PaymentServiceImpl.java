package com.jobhunter.service.payment;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.payment.PaymentDAO;
import com.jobhunter.model.payment.PaymentLogDTO;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class PaymentServiceImpl implements PaymentService {
	private final PaymentDAO paymentDAO;

	@Override
	public int savePanymentLog(PaymentLogDTO paymentLogDTO) throws Exception {
		
		
		return paymentDAO.insertPanymentLog(paymentLogDTO);
	}

}
