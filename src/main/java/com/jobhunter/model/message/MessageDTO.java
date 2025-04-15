package com.jobhunter.model.message;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
@ToString
@Builder
public class MessageDTO {
	
	private int to;
	private int from;
	private USERTYPE toUserType;
	private USERTYPE fromUserType;
	private String title;
	private String content;
	

}
