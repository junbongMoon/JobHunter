package com.jobhunter.model.resume;

import java.sql.Date;

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
public class ResumeboardUpfilesDTO {
	private int boardUpFileNo;
    private String originalFileName;
    private String newFileName;
    private String ext;
    private int size;
    private String base64Image;
    private int refResumeNo;
}
