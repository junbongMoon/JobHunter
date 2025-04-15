package com.jobhunter.controller.admin;

import java.util.List;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.admin.Pagination;
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
	public String adminUserList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "searchType", defaultValue = "name") String searchType,
			@RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
			Model model) {
		try {
			// 페이지 번호가 1보다 작으면 1로 설정
			page = Math.max(1, page);
			
			int pageSize = 1; // 페이지당 표시할 게시물 수
			
			// 전체 게시물 수 조회
			int totalCount = userService.getTotalUserCount(searchType, searchKeyword);
			
			// 페이징 객체 생성
			Pagination pagination = new Pagination(totalCount, page, pageSize);
			
			// 게시물 목록 조회
			List<UserVO> userList = userService.getUsersBySearch(searchType, searchKeyword, page, pageSize);
			
			model.addAttribute("userList", userList);
			model.addAttribute("pagination", pagination);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchKeyword", searchKeyword);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "admin/adminUserList";
	}
	
	@GetMapping("/admin/userDetail/{uid}")
	public String adminUserDetail(Model model, @PathVariable("uid") int uid) {
		try {
			UserVO user = userService.getUserById(uid);
			model.addAttribute("user", user);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "admin/adminUserDetail";
	}
	
	@GetMapping("/admin/userBlockList")
	public String adminUserBlockList(Locale locale, Model model) {
		return "admin/adminUserBlockList";
	}
	
	

}
