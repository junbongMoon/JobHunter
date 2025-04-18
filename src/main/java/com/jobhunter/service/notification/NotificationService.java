package com.jobhunter.service.notification;

import java.util.List;

import com.jobhunter.model.message.MessageDTO;

public interface NotificationService {
	

	List<MessageDTO> getNotificationList() throws Exception;
	
	void markAsRead(int messageNo) throws Exception;

	void markAllAsRead() throws Exception;

	void deleteNotification(int messageNo) throws Exception;

	int getUnreadCount(String uid) throws Exception;
}
