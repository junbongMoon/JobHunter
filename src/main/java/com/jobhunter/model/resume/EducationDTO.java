package com.jobhunter.model.resume;

import lombok.Data;

@Data
public class EducationDTO {
	private Integer educationNo;
    private EducationLevel educationLevel;
    private EducationStatus educationStatus;
    private String graduationDate;
    private String customInput;
    private Integer resumeNo;
}
