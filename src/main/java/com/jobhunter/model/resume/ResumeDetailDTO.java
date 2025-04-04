package com.jobhunter.model.resume;

import java.util.List;

import lombok.Data;

@Data
public class ResumeDetailDTO {
	private ResumeDTO resume;
    private List<JobFormDTO> jobForms;
    private List<MeritDTO> merits;
    private List<EducationDTO> educations;
    private List<PersonalHistoryDTO> histories;
    private List<LicenseDTO> licenses;
    private List<ResumeUpfileDTO> files;
}
