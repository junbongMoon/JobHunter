package com.jobhunter.controller.recruitmentnotice;

import java.sql.Timestamp;
import java.time.LocalDateTime;
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
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/RecruitmentNotice/rest")
@RequiredArgsConstructor
public class RecruitmentNoticeRestController {

	private final RecruitmentNoticeService recService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeRestController.class);

	// 회사가 공고를 등록하는 메서드
	@PostMapping(value = "/{uid}", produces = "application/json; charset=utf-8")
	public ResponseEntity<Boolean> saveRecruiment(@PathVariable("uid") int uid,
			@RequestBody RecruitmentNoticeDTO recruitmentNoticeDTO) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;

		logger.info("입력 할 때 들고옴.." + recruitmentNoticeDTO);
		// 현재 작성한 작성회사의 pk를 넣어준다.
		recruitmentNoticeDTO.setRefCompany(uid);
		// String으로 받은 값을 int로 바꾸자..
		String[] tempTimeArr = recruitmentNoticeDTO.getDueDateForString().split("-"); // "YYYY-MM-DD-TT-mm"형태로 받는다.
		int year = Integer.parseInt(tempTimeArr[0]);
		int month = Integer.parseInt(tempTimeArr[1]);
		int date = Integer.parseInt(tempTimeArr[2]);
		int time = Integer.parseInt(tempTimeArr[3]);
		int minute = Integer.parseInt(tempTimeArr[4]);
		Timestamp tempTime = Timestamp.valueOf(LocalDateTime.of(year, month, date, time, minute, 0));

		recruitmentNoticeDTO.setDueDate(tempTime);

		try {
			if (recService.saveRecruitmentNotice(recruitmentNoticeDTO)) {
				result = ResponseEntity.ok(true);
			}
		} catch (Exception e) {
			result = ResponseEntity.badRequest().body(false);
			e.printStackTrace();
		}

		return result;

	}

	// 회사가 공고를 작성할 때 우대조건을 리스트에 누적 해주는 메서드
	@PostMapping(value = "/advantage")
	public ResponseEntity<Boolean> saveAdvantageWithRecruitmentNotice(
			@RequestBody AdvantageDTO advantageDTO) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;

		try {
			recService.saveAdvantage(advantageDTO);
			result = ResponseEntity.ok(true);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			result = ResponseEntity.badRequest().body(false);
			e.printStackTrace();
		}

		return result;
	}

	// 회사가 공고를 작성할 때 지역을 필드에 임시저장하는 메서드
	@PostMapping(value = "/region/{regionCode}")
	public ResponseEntity<Boolean> saveRegionWithRecruitmentNotice(@PathVariable("regionCode") String regionCode) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;

		if(recService.saveRegion(regionCode) != false) {
			result = ResponseEntity.ok(true);
		}else {
			result = ResponseEntity.badRequest().body(false);
		}

		return result;
	}

	// 회사가 공고를 작성할 때 시군구를 필드에 임시저장하는 메서드
	@PostMapping(value = "/sigungu/{sigunguCode}")
	public ResponseEntity<Boolean> saveSigunguWithRecruitmentNotice(@PathVariable("sigunguCode") String sigunguCode) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;

		if(recService.saveSigungu(sigunguCode) != false) {
			result = ResponseEntity.ok(true);
		}else {
			result = ResponseEntity.badRequest().body(false);
		}

		return result;
	}

	// 회사가 공고를 작성할 때 면접방식을 리스트에 누적 해주는 메서드
	@PostMapping(value = "/application")
	public ResponseEntity<Boolean> saveApplicationWithRecruitmentNotice(
			@RequestBody ApplicationDTO applicationDTO) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = ResponseEntity.ok(true);

		recService.saveApplication(applicationDTO);

		return result;
	}
	
	// 회사가 공고를 작성할 때 산업군 추가
	@PostMapping(value = "/major/{majorcategoryNo}")
	public ResponseEntity<Boolean> saveMajorCategoryWithRecruitmentNotice(@PathVariable("majorCategoryNo") String majorCategoryNo) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<Boolean> result = null;

		if(recService.saveMajorCetegory(majorCategoryNo) != false) {
			result = ResponseEntity.ok(true);
		}else {
			result = ResponseEntity.badRequest().body(false);
		}

		return result;
	}
	// 회사가 공고를 작성할 때 직업 추가
	
	
	// 내가 작성한(템플릿 제외) 공고 불러오는 메서드
	// 아직 미완
	@GetMapping(value = "/company/{uid}")
	public ResponseEntity<List<RecruitmentNotice>> getRecruiment(@PathVariable("uid") int uid) {
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
