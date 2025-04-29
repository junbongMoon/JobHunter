package com.jobhunter.model.user;

import lombok.Data;

@Data
public class ContactUpdateDTO {
	private int uid;
    private String type;  // "email" or "mobile"
    private String value;
}
