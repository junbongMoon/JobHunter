package com.jobhunter.controller.notification;

import java.util.HashMap;
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

import com.jobhunter.model.message.MessageRequest;
import com.jobhunter.service.notification.NotificationService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/notification")
@RequiredArgsConstructor
public class NotificationController {

	private final NotificationService notificationService;

	@GetMapping("/list")
	public String openNotifications(Model model) {
		// 현재 로그인한 사용자의 알림 목록을 가져옵니다.
		// 실제 구현에서는 세션에서 사용자 정보를 가져와 해당 사용자의 알림만 조회해야 합니다.
		try {
			model.addAttribute("messages", notificationService.getNotificationList());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "notification/notificationList";
	}
	
	@GetMapping("/unreadCount")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getUnreadCount(@RequestParam String uid) {
		Map<String, Object> response = new HashMap<>();
		try {
			int count = notificationService.getUnreadCount(uid);
			response.put("count", count);
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			e.printStackTrace();
			response.put("count", 0);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	@PostMapping("/markAsRead")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> markAsRead(@RequestBody MessageRequest request) {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        notificationService.markAsRead(request.getMessageNo());
	        response.put("status", "success");
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "읽음 처리 중 오류 발생");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

	@PostMapping("/markAllAsRead")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> markAllAsRead() {
	    Map<String, Object> response = new HashMap<>();
	    try {
	        notificationService.markAllAsRead();
	        response.put("status", "success");
	        return ResponseEntity.ok(response);
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "전체 읽음 처리 중 오류 발생");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
	    }
	}

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
