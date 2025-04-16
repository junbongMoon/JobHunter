package com.jobhunter.controller.admin;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;
import com.jobhunter.service.status.StatusService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminController {

	private final StatusService statusService;

	@RequestMapping(value = "/admin", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {

		return "admin/adminhome";
	}

	@RequestMapping(value = "/admin/admincharts", method = RequestMethod.GET)
	public String showCharts(Locale locale, Model model) {

		LocalDate now = LocalDate.now();
		LocalDateTime start = now.withDayOfMonth(1).atStartOfDay(); // 이번 달 1일 00:00:00
		LocalDateTime end = now.plusDays(1).atStartOfDay().minusSeconds(1); // 오늘 23:59:59

		try {
			List<StatusVODTO> monthchart = statusService.getDailyChartByPaging(start, end);
			List<TotalStatusVODTO> totalMonthchart = statusService.getTotalStatusBetweenStartAndEnd(start, end);
			System.out.println(monthchart);
			model.addAttribute("daliyCharts", monthchart);
			model.addAttribute("totalCharts", totalMonthchart);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "/admin/admincharts";
	}
}
