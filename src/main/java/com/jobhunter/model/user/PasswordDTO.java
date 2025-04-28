package com.jobhunter.model.user;

import lombok.Data;

@Data
public class PasswordDTO {
	private String uid;
    private String password;
    private String whereFrom;
}
