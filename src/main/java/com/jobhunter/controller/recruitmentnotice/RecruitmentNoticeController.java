package com.jobhunter.controller.recruitmentnotice;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
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
	public ResponseEntity<RecruitmentNoticeDTO> saveRecruiment(@PathVariable("uid") int uid,
	         @RequestBody RecruitmentNoticeDTO recruitmentNoticeDTO) {
		logger.info("입력 할 때 들고옴.." + recruitmentNoticeDTO);
		// 현재 작성한 작성회사의 pk를 넣어준다.
		recruitmentNoticeDTO.setRefCompany(uid);
		ResponseEntity<RecruitmentNoticeDTO> result = null;
		
		try {
			if(recService.saveRecruitmentNotice(recruitmentNoticeDTO)) {
				result = ResponseEntity.ok(recruitmentNoticeDTO);
			}
		} catch (Exception e) {
			result = ResponseEntity.badRequest().body(recruitmentNoticeDTO);
			e.printStackTrace();
		}
		
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
	
}
