package com.jobhunter.controller.admin;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jobhunter.model.admin.Pagination;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.admin.AdminService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminController {

	private final AdminService adminService;
	
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {

		return "admin/adminhome";
	}
	
	@GetMapping("/admin/userList")
	public String adminUserList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "searchType", defaultValue = "name") String searchType,
			@RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
			@RequestParam(value = "statusFilter", defaultValue = "all") String statusFilter,
			Model model) {
		try {
			// 페이지 번호가 1보다 작으면 1로 설정
			page = Math.max(1, page);
			
			int pageSize = 10; // 페이지당 표시할 게시물 수
			
			// 전체 게시물 수 조회 (상태 필터 포함)
			int totalCount = adminService.getTotalUserCount(searchType, searchKeyword, statusFilter);
			
			// 페이징 객체 생성
			Pagination pagination = new Pagination(totalCount, page, pageSize);
			
			// 게시물 목록 조회 (상태 필터 포함)
			List<UserVO> userList = adminService.getUsersBySearch(searchType, searchKeyword, statusFilter, page, pageSize);
			
			model.addAttribute("userList", userList);
			model.addAttribute("pagination", pagination);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchKeyword", searchKeyword);
			model.addAttribute("statusFilter", statusFilter);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "admin/adminUserList";
	}
	
	@GetMapping("/admin/userDetail/{uid}")
	public String adminUserDetail(Model model, @PathVariable("uid") int uid) {
		try {
			UserVO user = adminService.getUserById(uid);
			model.addAttribute("user", user);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "admin/adminUserDetail";
	}
	
	@GetMapping("/admin/companyList")
	public String adminCompanyList(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "searchType", defaultValue = "companyName") String searchType,
			@RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
			@RequestParam(value = "statusFilter", defaultValue = "all") String statusFilter,
			Model model) {
		try {
			// 페이지 번호가 1보다 작으면 1로 설정
			page = Math.max(1, page);
			
			int pageSize = 10; // 페이지당 표시할 게시물 수
			
			// 전체 게시물 수 조회 (상태 필터 포함)
			int totalCount = adminService.getTotalCompanyCount(searchType, searchKeyword, statusFilter);
			
			// 페이징 객체 생성
			Pagination pagination = new Pagination(totalCount, page, pageSize);
			
			// 게시물 목록 조회 (상태 필터 포함)
			List<CompanyVO> companyList = adminService.getCompaniesBySearch(searchType, searchKeyword, statusFilter, page, pageSize);
			
			model.addAttribute("companyList", companyList);
			model.addAttribute("pagination", pagination);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchKeyword", searchKeyword);
			model.addAttribute("statusFilter", statusFilter);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "admin/adminCompanyList";
	}
	
	@GetMapping("/admin/companyDetail/{uid}")
	public String adminCompanyDetail(Model model, @PathVariable("uid") int uid) {
		try {
			CompanyVO company = adminService.getCompanyById(uid);
			model.addAttribute("company", company);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "admin/adminCompanyDetail";
	}
	
	@PostMapping("/admin/blockUser/{uid}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> blockUser(
	        @PathVariable("uid") int uid, 
	        @RequestBody Map<String, String> request) {

	    try {
	        String duration = request.get("duration");
	        String reason = request.get("reason");

	        // 정지 기간 계산
	        Timestamp blockDeadline;
	        if ("permanent".equals(duration)) {
	            blockDeadline = Timestamp.valueOf("9999-09-09 00:00:00");
	        } else {
	            int days = Integer.parseInt(duration);
	            Calendar cal = Calendar.getInstance();
	            cal.add(Calendar.DAY_OF_MONTH, days);
	            blockDeadline = new Timestamp(cal.getTimeInMillis());
	        }

	        boolean success = adminService.blockUser(uid, blockDeadline, reason);

	        Map<String, Object> response = new HashMap<>();
	        response.put("success", success);

	        if (success) {
	            return ResponseEntity.ok(response);
	        } else {
	            response.put("message", "유저 정지에 실패했습니다.");
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, Object> error = new HashMap<>();
	        error.put("success", false);
	        error.put("message", "처리 중 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
	    }
	}

	@PostMapping("/admin/unblockUser/{uid}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> unblockUser(@PathVariable("uid") int uid) {
	    try {
	        boolean success = adminService.unblockUser(uid);

	        Map<String, Object> response = new HashMap<>();
	        response.put("success", success);

	        if (success) {
	            return ResponseEntity.ok(response);
	        } else {
	            response.put("message", "유저 정지 해제에 실패했습니다.");
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, Object> error = new HashMap<>();
	        error.put("success", false);
	        error.put("message", "처리 중 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
	    }
	}
	
	@PostMapping("/admin/blockCompany/{uid}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> blockCompany(
	        @PathVariable("uid") int uid, 
	        @RequestBody Map<String, String> request) {

	    try {
	        String duration = request.get("duration");
	        String reason = request.get("reason");

	        // 정지 기간 계산
	        Timestamp blockDeadline;
	        if ("permanent".equals(duration)) {
	            blockDeadline = Timestamp.valueOf("9999-09-09 00:00:00");
	        } else {
	            int days = Integer.parseInt(duration);
	            Calendar cal = Calendar.getInstance();
	            cal.add(Calendar.DAY_OF_MONTH, days);
	            blockDeadline = new Timestamp(cal.getTimeInMillis());
	        }

	        boolean success = adminService.blockCompany(uid, blockDeadline, reason);

	        Map<String, Object> response = new HashMap<>();
	        response.put("success", success);

	        if (success) {
	            return ResponseEntity.ok(response);
	        } else {
	            response.put("message", "기업 정지에 실패했습니다.");
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, Object> error = new HashMap<>();
	        error.put("success", false);
	        error.put("message", "처리 중 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
	    }
	}

	@PostMapping("/admin/unblockCompany/{uid}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> unblockCompany(@PathVariable("uid") int uid) {
	    try {
	        boolean success = adminService.unblockCompany(uid);

	        Map<String, Object> response = new HashMap<>();
	        response.put("success", success);

	        if (success) {
	            return ResponseEntity.ok(response);
	        } else {
	            response.put("message", "기업 정지 해제에 실패했습니다.");
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        Map<String, Object> error = new HashMap<>();
	        error.put("success", false);
	        error.put("message", "처리 중 오류가 발생했습니다.");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
	    }
	}
}
