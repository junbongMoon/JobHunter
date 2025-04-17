package com.jobhunter.dao.message;

import java.util.List;

import com.jobhunter.model.message.MessageDTO;

public interface MessageDAO {
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 메세지를 insert하는 메서드
	 * </p>
	 * 
	 * @param to
	 * @param from
	 * @param toUserType
	 * @param fromUserType
	 * @param title
	 * @param content
	 *
	 */
	public void insertMessage(MessageDTO messageDTO);
	
	/**
	 * 모든 메시지를 가져오는 메서드
	 * @author 유지원
	 * @return 메시지 목록
	 */
	public List<MessageDTO> getAllMessages() throws Exception;
	
	/**
	 * 특정 사용자의 메시지를 가져오는 메서드
	 * @param userId 사용자 ID
	 * @param userType 사용자 타입 (USER, COMPANY, ADMIN)
	 * @author 유지원
	 * 
	 * @return 메시지 목록
	 */
	public List<MessageDTO> getMessagesByUserId(int userId, String userType) throws Exception;
	
	/**
	 * 메시지의 읽음 상태를 업데이트하는 메서드
	 * @param messageNo 메시지 번호
	 * @param isRead 읽음 상태 (Y/N)
	 * @author 유지원
	 */
	public void updateMessageReadStatus(int messageNo, String isRead) throws Exception;
	
	/**
	 * 모든 메시지의 읽음 상태를 업데이트하는 메서드
	 * @param isRead 읽음 상태 (Y/N)
	 * @author 유지원
	 */
	public void updateAllMessagesReadStatus(String isRead) throws Exception;
	
	/**
	 * 메시지를 삭제하는 메서드
	 * @param messageNo 메시지 번호
	 * @author 유지원
	 */
	public void deleteMessage(int messageNo) throws Exception;

	/**
	 * 읽지 않은 메시지 개수를 가져오는 메서드
	 * @return 읽지 않은 메시지 개수
	 * @author 유지원
	 */
	public int getUnreadCount(String uid) throws Exception;
}
