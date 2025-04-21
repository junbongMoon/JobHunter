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
    private int adviceNo;
    private String adviceFileName;
    private String originalFileName;
    private LocalDateTime regDate;
} 