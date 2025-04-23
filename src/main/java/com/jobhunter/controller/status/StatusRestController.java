package com.jobhunter.controller.status;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.status.FullStatus;
import com.jobhunter.service.status.StatusService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/status/rest")
public class StatusRestController {
	private final StatusService statusService;

	
	@GetMapping("/years")
	public ResponseEntity<List<Integer>> getYears() {
	    try {
	        return ResponseEntity.ok(statusService.getYears());
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.badRequest().build();
	    }
	}

	@GetMapping("/months")
	public ResponseEntity<List<Integer>> getMonths(@RequestParam int year) {
	    try {
	        return ResponseEntity.ok(statusService.getMonthsByYear(year));
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.badRequest().build();
	    }
	}

	@GetMapping("/days")
	public ResponseEntity<List<Integer>> getDays(@RequestParam int year, @RequestParam int month) {
	    try {
	        return ResponseEntity.ok(statusService.getDaysByYearAndMonth(year, month));
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.badRequest().build();
	    }
	}
	
	@PostMapping(value = "/ym/data", produces = "application/json")
	public ResponseEntity<FullStatus> getStatisticsByMonth(@RequestParam String ym) {
		ResponseEntity<FullStatus> result = null;
		
	    try {
	        FullStatus fullStatus = statusService.getFullStatusByMonth(ym);
	        return ResponseEntity.ok(fullStatus);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.badRequest().body(null);
	    }
	    
	    
	}
	
}
