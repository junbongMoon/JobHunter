package com.jobhunter.controller.payment;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/payment")
public class PaymentController {
	
	@GetMapping("/paymentTest")
	public void showPaymentTest() {
		
	}
	
}
