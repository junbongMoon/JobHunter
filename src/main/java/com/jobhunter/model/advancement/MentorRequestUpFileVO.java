package com.jobhunter.model.advancement;

import lombok.Data;

@Data
public class MentorRequestUpFileVO {
	private Integer upfileNo;            // 파일 고유 번호
    private String originalFileName;     // 원본 파일명
    private String newFileName;           // 서버에 저장된 파일명 (경로 포함)
    private String thumbFileName;         // 썸네일 파일명 (경로 포함)
    private String fileType;              // 파일 MIME 타입
    private String ext;                   // 파일 확장자
    private Integer size;                 // 파일 크기 (byte)
    private String base64Image;           // 썸네일 Base64 인코딩 문자열
    private Integer refAdvancementNo;     // 연결된 게시글 번호 (advancement.advancementNo)
}
