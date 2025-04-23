package com.jobhunter.controller.employment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.employment.EmploymentDTO;
import com.jobhunter.model.employment.EmploymentPageDTO;
import com.jobhunter.service.employment.EmploymentService;

@Controller
@RequestMapping("/employment")
public class EmploymentController {

	@Autowired
	private EmploymentService service;

	@GetMapping("/list")
	public String employList(@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "9") int display,
			@RequestParam(required = false) String keyword, @RequestParam(defaultValue = "latest") String sort,
			Model model) {
		try {
			EmploymentPageDTO dto = service.getEmployment(page, display, keyword, sort);
			int total = dto.getTotal();
			int totalPages = (int) Math.ceil((double) total / display);

						// 페이징 블록 계산
			int blockSize = 10;
			int currentBlock = (int) Math.ceil((double) page / blockSize);
			int startPage = (currentBlock - 1) * blockSize + 1;
			int endPage = Math.min(startPage + blockSize - 1, totalPages);
			boolean hasPrev = startPage > 1;
			boolean hasNext = endPage < totalPages;

			model.addAttribute("listEmploy", dto.getList());
			model.addAttribute("currentPage", page);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("totalCount", total);
			model.addAttribute("keyword", keyword);
			model.addAttribute("sort", sort);
			model.addAttribute("startPage", startPage);
			model.addAttribute("endPage", endPage);
			model.addAttribute("hasPrev", hasPrev);
			model.addAttribute("hasNext", hasNext);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "employment/list";
	}

}
