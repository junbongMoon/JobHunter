package com.jobhunter.model.resume;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import lombok.Data;

@Data
public class EducationDTO {
	private Integer educationNo;
    private EducationLevel educationLevel;
    private EducationStatus educationStatus;
    private String graduationDate;
    private String customInput;
    private Integer resumeNo;
    
    public String getFormattedGraduationDate() {
        if (graduationDate == null || graduationDate.isBlank()) return "";

        try {
            // 1. 원본 문자열 -> Date로 파싱
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = inputFormat.parse(graduationDate);

            // 2. 원하는 형식으로 다시 포맷
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy년 MM월 dd일", Locale.KOREA);
            return outputFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
            return graduationDate; // 파싱 실패 시 원래 문자열 반환
        }
    }
}
