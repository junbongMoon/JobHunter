package com.jobhunter.service.employment;

import java.util.List;

import com.jobhunter.model.employment.EmploymentDTO;
import com.jobhunter.model.employment.EmploymentPageDTO;

public interface EmploymentService {

	EmploymentPageDTO getEmployment(int page, int display, String keyword, String sort) throws Exception;

	
}
