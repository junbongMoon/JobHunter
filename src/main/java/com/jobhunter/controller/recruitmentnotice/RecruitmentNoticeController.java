package com.jobhunter.controller.recruitmentnotice;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.Application;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/recruitmentNotice")
@RequiredArgsConstructor
public class RecruitmentNoticeController {
	
	private final RecruitmentNoticeService recService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeController.class);
	
	
	// 회사가 공고를 등록하는 메서드
	@PostMapping(value = "/{uid}", produces = "application/json; charset=utf-8")
	public ResponseEntity<Boolean> saveRecruiment(@PathVariable("uid") int uid,
	         @RequestBody RecruitmentNoticeDTO recruitmentNoticeDTO) {
		logger.info("입력 할 때 들고옴.." + recruitmentNoticeDTO);
		// 현재 작성한 작성회사의 pk를 넣어준다.
		recruitmentNoticeDTO.setRefCompany(uid);
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;
		
		
		try {
			if(recService.saveRecruitmentNotice(recruitmentNoticeDTO)) {
				result = ResponseEntity.ok(true);
			}
		} catch (Exception e) {
			result = ResponseEntity.badRequest().build();
			e.printStackTrace();
		}
		
		
		
		return result;
		
	}
	
	// 회사가 공고를 작성할 때 우대조건을 리스트에 넣어주는 메서드
	@PostMapping(value ="/advantage/{uid}")
	public ResponseEntity<Boolean> saveAdvantageWithRecruitmentNotice(@PathVariable("uid") int uid,
	         @RequestBody AdvantageDTO advantageDTO){
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;
		
		try {
			recService.saveAdvantage(advantageDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return result;
	}
	// 회사가 공고를 작성할 때 지역을 리스트(?)에 메서드
	// 지역은 1개밖에 넣지 않을 것 같다.. 일단 보류
//	@PostMapping(value ="/application/{uid}/{regionCode}")
//	public ResponseEntity<Boolean> saveRegionWithRecruitmentNotice(@PathVariable("uid") int uid,
//			@PathVariable("regionCode") String regionCode){
//		// 성공, 실패 여부를 json으로 응답
//		ResponseEntity<Boolean> result = null;
//		
//		return result;
//	}
	
	
	// 회사가 공고를 작성할 때 면접방식을 리스트에 넣어주는 메서드
	@PostMapping(value ="/application/{uid}")
	public ResponseEntity<Boolean> saveApplicationWithRecruitmentNotice(@PathVariable("uid") int uid,
	         @RequestBody Application application){
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;
		
		
		
		return result;
	}
	
	
	
	// 내가 작성한(템플릿 제외) 공고 불러오는 메서드
	// 아직 미완
	@GetMapping(value = "/company/{uid}")
	public ResponseEntity<List<RecruitmentNotice>> getRecruiment(@PathVariable("uid") int uid){
		ResponseEntity<List<RecruitmentNotice>> result = null;
		List<RecruitmentNotice> recList = null;
		try {
			recList = recService.getRecruitmentByUid(uid);
			result = ResponseEntity.ok(recList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(recList);
		}
		
		return result;
		
		
	}
	
	// 내가 작성한 공고 수정하는 메서드
	
	// 내가 작성한 공고 삭제하는 메서드
	// delete가 아니라 dueDate(마감기한 now()로 설정) update. sql스케쥴러 사용해서 반년 이따 지우자... 
	
	
	
}
