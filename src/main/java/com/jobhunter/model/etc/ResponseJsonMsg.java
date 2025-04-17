package com.jobhunter.model.etc;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@AllArgsConstructor
public class ResponseJsonMsg {
	private int code;
    private String message;
    
    public static ResponseJsonMsg of(int code, String message) {
        return new ResponseJsonMsg(code, message);
    }

    public static ResponseJsonMsg success(String message) {
        return new ResponseJsonMsg(200, message);
    }

    public static ResponseJsonMsg error(String message) {
        return new ResponseJsonMsg(500, message);
    }

    public static ResponseJsonMsg notFound(String message) {
        return new ResponseJsonMsg(404, message);
    }

    public static ResponseJsonMsg success() {
        return new ResponseJsonMsg(200, "success");
    }

    public static ResponseJsonMsg error() {
        return new ResponseJsonMsg(500, "error");
    }

    public static ResponseJsonMsg notFound() {
        return new ResponseJsonMsg(404, "notFound");
    }
}
