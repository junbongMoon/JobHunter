package com.jobhunter.service.notification;

import java.util.List;

import com.jobhunter.model.message.MessageDTO;

public interface NotificationService {
	
	/**
	 * 알림 목록을 가져오는 메서드
	 * @return 알림 목록
	 * @throws Exception 
	 */
	List<MessageDTO> getNotificationList() throws Exception;
	
	/**
	 * 알림을 읽음 상태로 변경하는 메서드
	 * @param messageNo 알림 번호
	 * @throws Exception 
	 */
	void markAsRead(int messageNo) throws Exception;
	
	/**
	 * 모든 알림을 읽음 상태로 변경하는 메서드
	 * @throws Exception
	 */
	void markAllAsRead() throws Exception;
	
	/**
	 * 알림을 삭제하는 메서드
	 * @param messageNo 알림 번호
	 * @throws Exception
	 */
	void deleteNotification(int messageNo) throws Exception;
	
	/**
	 * 읽지 않은 알림 개수를 가져오는 메서드
	 * @return 읽지 않은 알림 개수
	 * @throws Exception
	 */
	int getUnreadCount(String uid) throws Exception;
}
