package com.jobhunter.dao.payment;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.payment.PaymentLogDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PaymentDAOImpl implements PaymentDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.paymentmapper";

	@Override
	public int insertPanymentLog(PaymentLogDTO paymentLogDTO) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

}
