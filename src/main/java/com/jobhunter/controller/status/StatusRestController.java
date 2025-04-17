package com.jobhunter.controller.status;

import java.util.Calendar;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.service.status.StatusService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/status/rest")
public class StatusRestController {
	private final StatusService statusService;

	@GetMapping("/ym/")
	public ResponseEntity<List<StatusVODTO>> getMonthListByStatus(){
		
		try {
			statusService.getYearAndMonth();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		// statusService.getDailyChartByPaging(null, null);
		
		
		return null;
	}
	
}
