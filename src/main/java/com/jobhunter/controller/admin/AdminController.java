package com.jobhunter.controller.admin;


import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.admin.AdminService;
import com.jobhunter.service.status.StatusService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 페이지 관련 컨트롤러입니다.
 * <p>
 * 관리자 페이지에서 홈페이지에 대한 관리를 맡습니다.
 * </p>
 */
@Controller
@RequiredArgsConstructor
public class AdminController {


	private final StatusService statusService;
	private final AdminService adminService;
	
	/**
	 * 관리자 홈 페이지를 반환합니다.
	 * 
	 * @param locale 클라이언트 로케일 정보
	 * @param model 뷰에 전달할 데이터
	 * @return 관리자 홈 JSP 페이지 경로
	 */
  // 문준봉
	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String showCharts(Locale locale, Model model) {

		LocalDate now = LocalDate.now();
		LocalDateTime start = now.withDayOfMonth(1).atStartOfDay(); // 이번 달 1일 00:00:00
		LocalDateTime end = now.plusDays(1).atStartOfDay().minusSeconds(1); // 오늘 23:59:59

		try {
			List<StatusVODTO> monthchart = statusService.getDailyChartByPaging(start, end);
			List<TotalStatusVODTO> totalMonthchart = statusService.getTotalStatusBetweenStartAndEnd(start, end);
			System.out.println(monthchart);
			model.addAttribute("daliyCharts", monthchart);
			model.addAttribute("totalCharts", totalMonthchart);
			if (!totalMonthchart.isEmpty()) {
			    TotalStatusVODTO latestTotal = totalMonthchart.get(totalMonthchart.size() - 1);
			    model.addAttribute("latestTotal", latestTotal);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "/admin/admincharts";
	}
	
	/**
	 * 일반유저 목록을 조회하고 페이징 및 검색 조건을 적용합니다.
	 * @param page 현재 페이지 번호
	 * @param searchType 검색 타입 (예: name, email)
	 * @param searchKeyword 검색어
	 * @param statusFilter 상태 필터 (예: all, normal, blocked 등)
	 * @param model 뷰에 전달할 데이터
	 * @return 일반유저 목록 JSP 페이지 경로
	 * 
	 * @author 유지원
	 */
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
	
	/**
	 * 특정 일반유저의 상세 정보를 조회합니다.
	 *
	 * @param model 뷰에 전달할 데이터
	 * @param uid 일반유저 고유 번호
	 * @return 일반유저 상세 정보 JSP 경로
	 * 
	 * @author 유지원
	 */
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
	
	/**
	 * 기업유저 목록을 조회하고 페이징 및 검색 조건을 적용합니다.
	 *
	 * @param page 현재 페이지 번호
	 * @param searchType 검색 타입 (예: companyName)
	 * @param searchKeyword 검색어
	 * @param statusFilter 상태 필터 (예: all, blocked 등)
	 * @param model 뷰에 전달할 데이터
	 * @return 기업유저 목록 JSP 페이지 경로
	 * 
	 * @author 유지원
	 */
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
	
	/**
	 * 특정 기업유저의 상세 정보를 조회합니다.
	 *
	 * @param model 뷰에 전달할 데이터
	 * @param uid 기업유저 고유 번호
	 * @return 기업유저 상세 정보 JSP 경로
	 * 
	 * @author 유지원
	 */
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
	
	/**
	 * 일반유저를 일정 기간 또는 영구적으로 정지시킵니다.
	 *
	 * @param uid 일반유저 고유 번호
	 * @param request 요청 바디에 포함된 정지 기간(duration)과 정지 사유(reason)
	 * @return 처리 결과를 담은 JSON 응답
	 * 
	 * @author 유지원
	 */
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

	/**
	 * 일반유저 정지를 해제합니다.
	 *
	 * @param uid 일반유저 고유 번호
	 * @return 처리 결과를 담은 JSON 응답
	 * 
	 * @author 유지원
	 */
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
	
	/**
	 * 기업유저를 일정 기간 또는 영구적으로 정지시킵니다.
	 *
	 * @param uid 기업유저 고유 번호
	 * @param request 요청 바디에 포함된 정지 기간(duration)과 사유(reason)
	 * @return 처리 결과를 담은 JSON 응답
	 * 
	 * @author 유지원
	 */
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

	/**
	 * 기업유저 정지를 해제합니다.
	 *
	 * @param uid 기업유저 고유 번호
	 * @return 처리 결과를 담은 JSON 응답
	 * 
	 * @author 유지원
	 */
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
