package com.jobhunter.dao.message;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.message.MessageDTO;
import com.jobhunter.model.message.USERTYPE;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class MessageDAOImpl implements MessageDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.messagemapper";

	@Override
	public void insertMessage(MessageDTO messageDTO) {
		ses.insert(NS + ".saveMessage", messageDTO);
	}
	
	@Override
	public List<MessageDTO> getAllMessages(String uid, String accountType) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("uid", uid);
		params.put("accountType", accountType);
		return ses.selectList(NS + ".getAllMessages", params);
	}
	
	@Override
	public List<MessageDTO> getMessagesByUserId(int userId, String userType) throws Exception {
		MessageDTO params = new MessageDTO();
		params.setToWho(userId);
		params.setToUserType(USERTYPE.valueOf(userType));
		return ses.selectList(NS + ".getMessagesByUserId", params);
	}
	
	@Override
	public void updateMessageReadStatus(int messageNo, String isRead) throws Exception {
		MessageDTO params = new MessageDTO();
		params.setMessageNo(messageNo);
		params.setIsRead(isRead);
		ses.update(NS + ".updateMessageReadStatus", params);
	}
	
	@Override
	public void updateAllMessagesReadStatus(String isRead) throws Exception {
		ses.update(NS + ".updateAllMessagesReadStatus", isRead);
	}
	
	@Override
	public void deleteMessage(int messageNo) throws Exception {
		ses.delete(NS + ".deleteMessage", messageNo);
	}

	@Override
	public int getUnreadCount(String uid) throws Exception {
		return ses.selectOne(NS + ".getUnreadCount", uid);
	}
}
