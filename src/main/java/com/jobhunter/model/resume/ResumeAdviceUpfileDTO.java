package com.jobhunter.model.resume;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResumeAdviceUpfileDTO {
    private int adviceUpfileNo;
    private String originalFileName;
    private String newFileName;
    private String ext;
    private String size;
    private String base64Image;
    private String status;
    private int adviceNo;
} 