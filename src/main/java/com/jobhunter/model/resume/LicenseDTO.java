package com.jobhunter.model.resume;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@Getter
@Setter
@ToString
public class LicenseDTO {
	private int licenseNo;
    private String licenseName;
    private String acquisitionDate;
    private String institution;
    private int resumeNo;
    
    public String getFormattedAcquisitionDate() {
        if (acquisitionDate == null || acquisitionDate.isBlank()) return "";

        try {
            // 1. 원본 문자열 -> Date로 파싱
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = inputFormat.parse(acquisitionDate);

            // 2. 원하는 형식으로 다시 포맷
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy년 MM월 dd일", Locale.KOREA);
            return outputFormat.format(date);
        } catch (Exception e) {
            e.printStackTrace();
            return acquisitionDate; // 파싱 실패 시 원래 문자열 반환
        }
    }
}
