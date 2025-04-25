package com.jobhunter.model.advancement;

import com.jobhunter.model.util.FileStatus;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author 문준봉
 *
 * <p>
 * Advancement 게시판 업로드 파일 정보 VODTO
 * </p>
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AdvancementUpFileVODTO {

    // 원본 파일명
    private String originalFileName;

    // 새롭게 저장된 파일명 (서버 경로 포함)
    private String newFileName;

    // 썸네일 파일명 (서버 경로 포함)
    private String thumbFileName;

    // 파일 타입 (image/png 등)
    private String fileType;

    // 확장자 (jpg, png 등)
    private String ext;

    // 파일 크기 (byte 단위)
    private long size;

    // 썸네일 Base64 문자열 (미리보기용)
    private String base64Image;
    
    private int refAdvancementNo;
    
    private FileStatus status;
}