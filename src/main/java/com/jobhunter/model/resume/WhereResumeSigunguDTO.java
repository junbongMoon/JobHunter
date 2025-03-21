package com.jobhunter.model.resume;

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
public class WhereResumeSigunguDTO {
    private int where_resume_sigunguNo;
    private int refSigunguNo;
    private int refResumeNo;
}
