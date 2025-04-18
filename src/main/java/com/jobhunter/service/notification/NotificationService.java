package com.jobhunter.service.notification;

import java.util.List;

import com.jobhunter.model.message.MessageDTO;

public interface NotificationService {
	

	List<MessageDTO> getNotificationList(String uid, String accountType) throws Exception;
	
	void markAsRead(int messageNo, String accountType, String uid) throws Exception;

	void markAllAsRead(String accountType, String uid) throws Exception;

	void deleteNotification(int messageNo) throws Exception;

	int getUnreadCount(String uid, String accountType) throws Exception;
}
