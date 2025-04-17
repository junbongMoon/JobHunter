package com.jobhunter.controller.notification;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/notification")
@RequiredArgsConstructor
public class NotificationController {

	@GetMapping("/list")
	public String openNotifications() {
		return "notification/notificationList";
	}
}
