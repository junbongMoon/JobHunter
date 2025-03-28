package com.jobhunter.controller.region;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;
import com.jobhunter.service.region.RegionService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/region")
public class RegionController {
	private final RegionService regionService;
	
	// 도시 전체 갖고 오는 메서드
	@GetMapping("/list")
	public ResponseEntity<List<Region>> getRegionList(){
		ResponseEntity<List<Region>> result = null;
		
		try {
			result = ResponseEntity.ok(regionService.getRegionList());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
		}
		
		return result;
	}
	
	// 시군구 전체 갖고 오는 메서드
		@GetMapping("/sigungu/{regionNo}")
		public ResponseEntity<List<Sigungu>> getSigunguList(@PathVariable("regionNo") int regionNo){
			ResponseEntity<List<Sigungu>> result = null;
			
			try {
				result = ResponseEntity.ok(regionService.getSigunguList(regionNo));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				result = ResponseEntity.badRequest().body(null);
			}
			
			return result;
		}
}
