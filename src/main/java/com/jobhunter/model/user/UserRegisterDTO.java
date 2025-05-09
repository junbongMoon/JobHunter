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
    
    public void setId(String id) {
        this.id = nullIfEmpty(id);
    }

    public void setPassword(String password) {
        this.password = nullIfEmpty(password);
    }

    public void setName(String name) {
        this.name = nullIfEmpty(name);
    }

    public void setEmail(String email) {
        this.email = nullIfEmpty(email);
    }

    public void setMobile(String mobile) {
        this.mobile = nullIfEmpty(mobile);
    }

    private String nullIfEmpty(String str) {
        return (str == null || str.trim().isEmpty()) ? null : str.trim();
    }
}
