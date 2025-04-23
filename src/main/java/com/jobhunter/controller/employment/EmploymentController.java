package com.jobhunter.controller.employment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.employment.EmploymentDTO;
import com.jobhunter.service.employment.EmploymentService;

@Controller
@RequestMapping("/employment")
public class EmploymentController {

	
	@Autowired
	private EmploymentService service; 
	
	@GetMapping("/list")
	public String employList(@RequestParam(defaultValue = "1") int page, Model model) {
	    try {
	        List<EmploymentDTO> listEmploy = service.getEmployment(page);
	        model.addAttribute("listEmploy", listEmploy);
	        model.addAttribute("currentPage", page); // 현재 페이지 넘기기
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return "employment/list";
	}
}
