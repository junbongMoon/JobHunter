package com.jobhunter.service.notification;

import java.util.List;

import com.jobhunter.model.message.MessageDTO;

/**
 * 알림 관련 서비스 인터페이스
 * 
 * @author 유지원
 */
public interface NotificationService {
	
	/**
	 * 알림 목록을 조회합니다.
	 * 
	 * @param uid 사용자 ID
	 * @param accountType 계정 타입
	 * @return 알림 목록	
	 * @author 유지원
	 */
	List<MessageDTO> getNotificationList(String uid, String accountType) throws Exception;

	/**
	 * 알림을 읽음 상태로 변경합니다.
	 * 
	 * @param messageNo 알림 번호
	 * @param accountType 계정 타입
	 * @param uid 사용자 ID
	 * @author 유지원
	 */
	void markAsRead(int messageNo, String accountType, String uid) throws Exception;

	/**
	 * 모든 알림을 읽음 상태로 변경합니다.
	 * 
	 * @param accountType 계정 타입
	 * @param uid 사용자 ID
	 * @author 유지원
	 */
	void markAllAsRead(String accountType, String uid) throws Exception;

	/**
	 * 알림을 삭제합니다.
	 * 
	 * @param messageNo 알림 번호
	 * @author 유지원
	 */
	void deleteNotification(int messageNo) throws Exception;

	/**
	 * 알림 미읽음 개수를 조회합니다.
	 * 
	 * @param uid 사용자 ID
	 * @param accountType 계정 타입
	 * @return 알림 미읽음 개수
	 * @author 유지원
	 */
	int getUnreadCount(String uid, String accountType) throws Exception;
}
