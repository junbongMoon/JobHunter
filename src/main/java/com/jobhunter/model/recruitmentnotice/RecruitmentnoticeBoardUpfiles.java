package com.jobhunter.model.recruitmentnotice;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
@ToString
@Builder
public class RecruitmentnoticeBoardUpfiles {
	private int boardUpFileNo;
	private String originalFileName;
	private String newFileName;
	private String ext;
	private int size;
	private String base64Image;
	private int refrecruitmentnoticeNo;
	
}
