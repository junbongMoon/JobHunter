package com.jobhunter.model.user;

import lombok.Data;

@Data
public class ContactUpdateDTO {
	private String uid;
    private String type;  // "email" or "mobile"
    private String value;
}
