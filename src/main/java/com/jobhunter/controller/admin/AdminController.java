package com.jobhunter.controller.admin;

import java.util.List;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.user.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminController {

	private final UserService userService;
	
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {

		return "admin/adminhome";
	}
	
	@GetMapping("/admin/userList")
	public String adminUserList(Locale locale, Model model) {
		try {
			List<UserVO> userList = userService.getAllUsers();
			model.addAttribute("userList", userList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "admin/adminUserList";
	}
	
	@GetMapping("/admin/userBlockList")
	public String adminUserBlockList(Locale locale, Model model) {
		return "admin/adminUserBlockList";
	}
	
	

}
