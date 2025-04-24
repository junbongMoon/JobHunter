package com.jobhunter.controller.notification;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jobhunter.model.message.MessageDTO;
import com.jobhunter.model.message.MessageRequest;
import com.jobhunter.service.notification.NotificationService;

import lombok.RequiredArgsConstructor;

/**
 * NotificationController 클래스는 알림(메시지)에 대한 웹 요청을 처리하는 컨트롤러입니다.
 * <p>
 * 사용자의 알림 목록 조회, 읽음 처리, 삭제 등의 기능을 제공합니다.
 * </p>
 * @author 유지원
 */
@Controller
@RequestMapping("/notification")
@RequiredArgsConstructor
public class NotificationController {

	private final NotificationService notificationService;

	/**
     * 알림 목록 페이지를 반환합니다.
     *
     * @param model 뷰로 데이터를 전달할 때 사용
     * @return 알림 목록 뷰 이름
     * @author 유지원
     */
	@GetMapping("/list")
	public String openNotifications(Model model, @RequestParam String uid, @RequestParam String accountType) {
		// 현재 로그인한 사용자의 알림 목록을 가져옵니다.
		// 실제 구현에서는 세션에서 사용자 정보를 가져와 해당 사용자의 알림만 조회해야 합니다.
		try {
			model.addAttribute("messages", notificationService.getNotificationList(uid, accountType));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "notification/notificationList";
	}
	
	/**
	 * 페이지네이션을 지원하는 알림 목록 API
	 * 
	 * @param uid 사용자 ID
	 * @param accountType 계정 타입
	 * @param page 페이지 번호
	 * @param pageSize 페이지 크기
	 * @return 알림 목록과 전체 개수를 포함한 JSON 응답
	 * @author 유지원
	 */
	@GetMapping("/listWithPaging")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getNotificationsWithPaging(
			@RequestParam String uid, 
			@RequestParam String accountType,
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int pageSize) {
		Map<String, Object> response = new HashMap<>();
		try {
			List<MessageDTO> messages = notificationService.getNotificationListWithPaging(uid, accountType, page, pageSize);
			int totalCount = notificationService.getTotalNotificationCount(uid, accountType);
			
			response.put("messages", messages);
			response.put("totalCount", totalCount);
			response.put("currentPage", page);
			response.put("hasMore", (page * pageSize) < totalCount);
			
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			e.printStackTrace();
			response.put("error", "알림 목록을 가져오는 중 오류가 발생했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	/**
     * 사용자의 안 읽은 알림 개수를 반환합니다.
     *
     * @param uid 사용자 ID
     * @return 안 읽은 알림 수를 포함한 JSON 응답
     * @author 유지원
     */
	@GetMapping("/unreadCount")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getUnreadCount(@RequestParam String uid, @RequestParam String accountType) {
		Map<String, Object> response = new HashMap<>();
		try {
			int count = notificationService.getUnreadCount(uid, accountType);
			response.put("count", count);
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			e.printStackTrace();
			response.put("count", 0);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	/**
     * 하나의 알림을 읽음 상태로 변경합니다.
     *
     * @param request 메시지 번호를 담고 있는 요청 객체
     * @return 처리 결과(JSON)
     * @author 유지원
     */
	@PostMapping("/markAsRead")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> markAsRead(@RequestParam int messageNo, @RequestParam String accountType, @RequestParam String uid) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        notificationService.markAsRead(messageNo, accountType, uid);
	        response.put("status", "success");
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "읽음 처리 중 오류 발생");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	/**
	 * 모든 알림을 읽음 상태로 변경합니다.
	 *
	 * @param accountType 계정 타입
	 * @param uid 사용자 ID
	 * @return 처리 결과(JSON)	
	 * @author 유지원
	 */
	@PostMapping("/markAllAsRead")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> markAllAsRead(@RequestParam String accountType, @RequestParam String uid) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        notificationService.markAllAsRead(accountType, uid);
	        response.put("status", "success");
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "전체 읽음 처리 중 오류 발생");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

    /**
	 * 특정 알림을 삭제합니다.
	 *
	 * @param request 메시지 번호를 담고 있는 요청 객체
	 * @return 처리 결과(JSON)
	 * @author 유지원
	 */
	@PostMapping("/delete")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> deleteNotification(@RequestBody MessageRequest request) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        notificationService.deleteNotification(request.getMessageNo());
	        response.put("status", "success");
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "알림 삭제 중 오류 발생");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

}
