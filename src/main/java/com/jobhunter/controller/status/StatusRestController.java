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

	@GetMapping(value = "/ym/", produces = "application/json")
	public ResponseEntity<List<String>> getMonthListByStatus(){
		
		ResponseEntity<List<String>> result = null;
		
		try {
			List<String> resultMonth = statusService.getYearAndMonth();
			result = ResponseEntity.ok().body(resultMonth);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
			
		}
		
		
		
		return result;
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
