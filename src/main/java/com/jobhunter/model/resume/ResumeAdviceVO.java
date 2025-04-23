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
public class ResumeAdviceVO {
    private int adviceNo;
    private int resumeNo;
    private LocalDateTime regDate;
    private int mentorUid;
    private String mentorName;
    private String title;
} 