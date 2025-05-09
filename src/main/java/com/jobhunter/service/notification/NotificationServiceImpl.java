package com.jobhunter.service.notification;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.message.MessageDAO;
import com.jobhunter.model.message.MessageDTO;

import lombok.RequiredArgsConstructor;

/**
 * NotificationServiceImpl 클래스는 알림(메시지) 관련 비즈니스 로직을 처리합니다.
 * <p>
 * 메시지를 읽음 처리하거나 삭제하고, 안 읽은 메시지 개수를 가져오는 기능 등을 포함합니다.
 * </p>
 * @author 유지원
 */
@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
	
	private final MessageDAO messageDAO;
	
	/**
     * 모든 알림(메시지)을 가져옵니다.
     * 
     * @return 모든 메시지 목록
     * @throws Exception 예외 발생 시
     */
	@Override
	public List<MessageDTO> getNotificationList(String uid, String accountType) throws Exception {
		return messageDAO.getAllMessages(uid, accountType);
	}
	
	/**
     * 특정 메시지를 읽음 상태로 변경합니다.
     * 
     * @param messageNo 읽음 처리할 메시지 번호
     * @throws Exception 예외 발생 시
     */
	@Override
	@Transactional
	public void markAsRead(int messageNo, String accountType, String uid) throws Exception {
		messageDAO.updateMessageReadStatus(messageNo, accountType, uid);
	}
	
	/**
     * 모든 메시지를 읽음 상태로 변경합니다.
     * 
     * @throws Exception 예외 발생 시
     */
	@Override
	@Transactional
	public void markAllAsRead(String accountType, String uid) throws Exception {
		messageDAO.updateAllMessagesReadStatus(accountType, uid);
	}
	
	 /**
     * 특정 메시지를 삭제합니다.
     * 
     * @param messageNo 삭제할 메시지 번호
     * @throws Exception 예외 발생 시
     */
	@Override
	@Transactional
	public void deleteNotification(int messageNo) throws Exception {
		messageDAO.deleteMessage(messageNo);
	}

	 /**
     * 특정 사용자(uid)의 안 읽은 메시지 수를 가져옵니다.
     * 
     * @param uid 사용자 ID
     * @return 안 읽은 메시지 수
     * @throws Exception 예외 발생 시
     */
	@Override
	public int getUnreadCount(String uid, String accountType) throws Exception {
		return messageDAO.getUnreadCount(uid, accountType);
	}
	
	/**
	 * 페이지네이션을 지원하는 알림 목록 조회 메서드
	 * 
	 * @param uid 사용자 ID
	 * @param accountType 계정 타입
	 * @param page 페이지 번호
	 * @param pageSize 페이지 크기
	 * @return 알림 목록
	 * @throws Exception 예외 발생 시
	 */
	@Override
	public List<MessageDTO> getNotificationListWithPaging(String uid, String accountType, int page, int pageSize) throws Exception {
		return messageDAO.getMessagesWithPaging(uid, accountType, page, pageSize);
	}
	
	/**
	 * 전체 알림 개수를 가져오는 메서드
	 * 
	 * @param uid 사용자 ID
	 * @param accountType 계정 타입
	 * @return 전체 알림 개수
	 * @throws Exception 예외 발생 시
	 */
	@Override
	public int getTotalNotificationCount(String uid, String accountType) throws Exception {
		return messageDAO.getTotalMessageCount(uid, accountType);
	}
}
