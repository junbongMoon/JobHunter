package com.jobhunter.model.etc;

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
public class BoardUpFilesVODTO {
	private int boardUpFileNo;
	private String originalFileName;
	private String newFileName;
	private String thumbFileName;
	private String fileType;
	private String ext;
	private long size;
	private String base64Image;
	private int boardNo;
	private FileStatus status;
}
