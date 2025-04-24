package com.jobhunter.model.employment;

import java.util.List;

public class EmploymentPageDTO {
		
	private List<EmploymentDTO> list;
    private int total;

    public EmploymentPageDTO(List<EmploymentDTO> list, int total) {
        this.list = list;
        this.total = total;
    }

    public List<EmploymentDTO> getList() {
        return list;
    }

    public int getTotal() {
        return total;
    }
}
