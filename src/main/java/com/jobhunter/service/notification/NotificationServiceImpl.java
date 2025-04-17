package com.jobhunter.service.notification;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.message.MessageDAO;
import com.jobhunter.model.message.MessageDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
	
	private final MessageDAO messageDAO;
	
	@Override
	public List<MessageDTO> getNotificationList() throws Exception {
		// 실제 구현에서는 현재 로그인한 사용자의 ID를 파라미터로 전달해야 합니다.
		// 예: return messageDAO.getMessagesByUserId(userId);
		return messageDAO.getAllMessages();
	}
	
	@Override
	@Transactional
	public void markAsRead(int messageNo) throws Exception {
		messageDAO.updateMessageReadStatus(messageNo, "Y");
	}
	
	@Override
	@Transactional
	public void markAllAsRead() throws Exception {
		// 실제 구현에서는 현재 로그인한 사용자의 ID를 파라미터로 전달해야 합니다.
		// 예: messageDAO.updateAllMessagesReadStatus(userId, "Y");
		messageDAO.updateAllMessagesReadStatus("Y");
	}
	
	@Override
	@Transactional
	public void deleteNotification(int messageNo) throws Exception {
		messageDAO.deleteMessage(messageNo);
	}

	@Override
	public int getUnreadCount(String uid) throws Exception {
		return messageDAO.getUnreadCount(uid);
	}
}
