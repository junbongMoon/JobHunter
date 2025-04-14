package com.jobhunter.controller.admin;

import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class AdminController {
	
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {

		return "admin/adminhome";
	}
	
	@GetMapping("/admin/userList")
	public String adminUserList(Locale locale, Model model) {
		return "admin/adminUserList";
	}
	
	@GetMapping("/admin/userBlockList")
	public String adminUserBlockList(Locale locale, Model model) {
		return "admin/adminUserBlockList";
	}
	
	

}
