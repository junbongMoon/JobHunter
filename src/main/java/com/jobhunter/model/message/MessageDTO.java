package com.jobhunter.model.message;

import java.sql.Timestamp;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class MessageDTO {
	
	private int messageNo;
	private int toWho;
	private int fromWho;
	private USERTYPE toUserType;
	private USERTYPE fromUserType;
	private String title;
	private String content;
	private String isRead;
	private Timestamp regDate;
}
