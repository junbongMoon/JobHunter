package com.jobhunter.model.resume;

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
public class ResumeAdviceCommentDTO {
    private int commentNo;
    private int resumeNo;
    private int lineNo;
    private String commentText;
    private int mentorUid;
    private int adviceNo;
} 