package com.jobhunter.controller.advancement;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/advancement")
public class AdvancementController {
	
	
	public String showAdvancementPage() {
		
		return "/advancement/mento";
	}
}
