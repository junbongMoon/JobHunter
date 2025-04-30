package com.jobhunter.model.user;

import lombok.Data;

@Data
public class PasswordDTO {
	private int uid;
    private String password;
    private String whereFrom;
    private String contact;
    private String contactType;
}
