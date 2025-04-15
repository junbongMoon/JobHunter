package com.jobhunter.dao.message;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.message.MessageDTO;

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

}
