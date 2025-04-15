package com.jobhunter.dao.message;

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
	
}
