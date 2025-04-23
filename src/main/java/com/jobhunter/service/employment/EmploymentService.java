package com.jobhunter.service.employment;

import java.util.List;

import com.jobhunter.model.employment.EmploymentDTO;

public interface EmploymentService {

	List<EmploymentDTO> getEmployment(int page) throws Exception;

}
