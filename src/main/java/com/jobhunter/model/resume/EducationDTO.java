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
public class EducationDTO {
	private int educationNo;
    private String educationLevel;
    private String educationStatus;
    private String customInput;
    private int resumeNo;
}
