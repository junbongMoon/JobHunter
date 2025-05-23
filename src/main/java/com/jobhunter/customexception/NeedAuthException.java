package com.jobhunter.customexception;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

public class NeedAuthException extends RuntimeException {

    private static final ObjectMapper mapper = new ObjectMapper(); // Json으로 만들어주는거 (jackson라이브러리에 있는거)
    private static final int STATUS_CODE = 449; // 에러코드 고정
    private static final String STATUS_TEXT = "NEED_AUTH"; // 에러메시지 제목 고정

    public NeedAuthException() {
        super("권한이 필요합니다.");
    }

    // 알아서 에러코드랑 메시지들 세팅해주는거
    public static void writeToAuthResponse(HttpServletResponse response) throws IOException {
    	// 에러코드 응답할때 필요한 리스폰 셋팅
        response.setContentType("application/json; charset=UTF-8");
        response.setStatus(STATUS_CODE);

        // 에러메시지 세팅
        Map<String, Object> body = new HashMap<>();
        body.put("status", STATUS_TEXT);

        mapper.writeValue(response.getWriter(), body);
    }
}
