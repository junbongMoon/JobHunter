package com.jobhunter.model.recruitmentnotice;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class RecruitmentStats {
    private int totalApplicants;
    private int maleCount;
    private int femaleCount;
    private int unknownAgeCount;
    private double averageAge;

    private int teens;
    private int twenties;
    private int thirties;
    private int forties;
    private int fiftiesOrAbove;
}
