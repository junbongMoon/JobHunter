package com.jobhunter.model.resume;

import java.time.LocalDateTime;
import java.util.List;

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
public class ResumeAdviceDTO {
    private int adviceNo;
    private int resumeNo;
    private String adviceContent;
    private LocalDateTime regDate;
    private List<ResumeAdviceUpfileDTO> files;
    private int mentorUid;
    
    private int ownerUid;
} 