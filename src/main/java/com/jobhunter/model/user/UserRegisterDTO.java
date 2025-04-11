package com.jobhunter.model.user;

import com.jobhunter.model.customenum.Nationality;

import lombok.Data;

@Data
public class UserRegisterDTO {
	private int uid;
	private String id;
    private String password;
    private String name;
    private Nationality nationality;
    private String email;
    private String mobile;
}
