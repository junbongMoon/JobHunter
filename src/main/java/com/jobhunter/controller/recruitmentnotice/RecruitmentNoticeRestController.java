package com.jobhunter.controller.recruitmentnotice;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.model.etc.FileStatus;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;
import com.jobhunter.util.RecruitmentFileProcess;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/recruitmentnotice/rest")
@RequiredArgsConstructor
public class RecruitmentNoticeRestController {

	private final RecruitmentNoticeService recService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeRestController.class);
	private final RecruitmentFileProcess fp;

	// 양식을 저장 할 List, 코드들
	private final List<AdvantageDTO> advantageList = new ArrayList<>();
	private final List<ApplicationDTO> applicationList = new ArrayList<>();
	private String regionCode;
	private String sigunguCode;
	private String majorCategoryCode;
	private String subCategoryCode;
	// 게시글 작성시 업로드한 파일객체들을 임시로 저장
	private List<RecruitmentnoticeBoardUpfiles> fileList = new ArrayList<RecruitmentnoticeBoardUpfiles>();
	   // 게시글 수정시 업로한 파일 객체들을 임식로 저장
	private List<RecruitmentnoticeBoardUpfiles> modifyFileList;

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
		 Timestamp dueDate = recruitmentNoticeDTO.getDueDate();
	        LocalDateTime onlyDate = dueDate.toLocalDateTime().withHour(0).withMinute(0).withSecond(0);
	        recruitmentNoticeDTO.setDueDate(Timestamp.valueOf(onlyDate));

		

		try {
			if (recService.saveRecruitmentNotice(recruitmentNoticeDTO, advantageList, applicationList, regionCode,
					sigunguCode, fileList, majorCategoryCode, subCategoryCode)) {
				// service 단도 바꿔주자
				result = ResponseEntity.ok(true);
			}
		} catch (Exception e) {
			result = ResponseEntity.badRequest().body(false);
			e.printStackTrace();
		}
		
		// 리스트 필드 다 비워주기
		ListAllClear();

		return result;

	}

	// 회사가 공고를 작성할 때 우대조건을 리스트에 누적 해주는 메서드
	@PostMapping(value = "/advantage")
	public ResponseEntity<List<AdvantageDTO>> saveAdvantageWithRecruitmentNotice(
			@RequestBody AdvantageDTO advantageDTO) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<List<AdvantageDTO>> result = null;

		
		if (advantageDTO != null) {
			advantageList.add(advantageDTO);
			result = ResponseEntity.ok(this.advantageList);
		} else {
			result = ResponseEntity.badRequest().body(this.advantageList);
		}
		
		System.out.println(advantageList);
		return result;
	}

	

	// 회사가 공고를 작성할 때 지역을 필드에 임시저장하는 메서드
	@PostMapping(value = "/region/{regionCode}")
	public ResponseEntity<String> saveRegionWithRecruitmentNotice(@PathVariable("regionCode") String regionCode) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<String> result = null;

		this.regionCode = regionCode;
		System.out.println(this.regionCode);

		if (StringUtils.hasText(this.regionCode) && !this.regionCode.equals("-1")) {
			result = ResponseEntity.ok(this.regionCode);
		} else {
			result = ResponseEntity.badRequest().body(this.regionCode);
		}

		this.sigunguCode = null;

		return result;
	}

	// 회사가 공고를 작성할 때 시군구를 필드에 임시저장하는 메서드
	@PostMapping(value = "/sigungu/{sigunguCode}")
	public ResponseEntity<String> saveSigunguWithRecruitmentNotice(@PathVariable("sigunguCode") String sigunguCode) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<String> result = null;

		this.sigunguCode = sigunguCode;
		System.out.println(this.sigunguCode);

		if (StringUtils.hasText(this.sigunguCode) && !this.sigunguCode.equals("-1")) {
			result = ResponseEntity.ok(this.sigunguCode);
		}

		return result;
	}

	// 회사가 공고를 작성할 때 면접방식을 리스트에 누적 해주는 메서드
	// 같은 면접방식이 중복 저장되는 문제가 생겼다... 해결해보자
	@PostMapping(value = "/application")
	public ResponseEntity<List<ApplicationDTO>> saveApplicationWithRecruitmentNotice(
			@RequestBody ApplicationDTO applicationDTO) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<List<ApplicationDTO>> result = null;
		
		boolean isDuplicate = false;
		for(ApplicationDTO appl : applicationList) {
			if(appl.getMethod() == applicationDTO.getMethod()) {
				isDuplicate = true;
			}
		}
		
		// 같은 이름의 method가 들어올 경우 방지
		if (applicationDTO != null && !isDuplicate) {
			applicationList.add(applicationDTO);
			result = ResponseEntity.ok(this.applicationList);
		} else {
			result = ResponseEntity.badRequest().body(this.applicationList);
		}

		System.out.println(applicationList);

		return result;
	}

	// 회사가 공고를 작성할 때 산업군 추가
	@PostMapping(value = "/major/{majorCategoryNo}")
	public ResponseEntity<String> saveMajorCategoryWithRecruitmentNotice(
			@PathVariable("majorCategoryNo") String majorCategoryNo) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<String> result = null;

		this.majorCategoryCode = majorCategoryNo;
		System.out.println(this.majorCategoryCode);

		if (StringUtils.hasText(this.majorCategoryCode)) {
			result = ResponseEntity.ok(this.majorCategoryCode);

		} else {
			result = ResponseEntity.badRequest().body(this.majorCategoryCode);
		}

		return result;
	}

	// 회사가 공고를 작성할 때 직업 추가
	@PostMapping(value = "/sub/{subCategoryNo}")
	public ResponseEntity<String> saveSubCategoryWithRecruitmentNotice(
			@PathVariable("subCategoryNo") String subCategoryNo) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<String> result = null;

		this.subCategoryCode = subCategoryNo;
		System.out.println(this.subCategoryCode);

		if (StringUtils.hasText(this.subCategoryCode)) {
			result = ResponseEntity.ok(this.subCategoryCode);

		} else {
			result = ResponseEntity.badRequest().body(this.subCategoryCode);
		}

		return result;
	}
	
	
	
	// 공고를 작성할 때 면접방식을 삭제하는 메서드
	
	@DeleteMapping("/application")
	public ResponseEntity<List<ApplicationDTO>> deleteApplicationWithRecruitmentNotice(@RequestBody ApplicationDTO applicationDTO){
		ResponseEntity<List<ApplicationDTO>> result = null;
		
		for(int i = 0; i < applicationList.size(); i++) {
			if(applicationList.get(i).getMethod() == applicationDTO.getMethod()) {
				applicationList.remove(i);
			}
		}
		result = ResponseEntity.ok(applicationList);
		
		System.out.println(applicationList);
		
		return result;
	}
	
	
	// 회사가 공고를 작성할 때 우대조건을 리스트에서 삭제 해주는 메서드
		@DeleteMapping(value = "/advantage/{advantageType}")
		public ResponseEntity<List<AdvantageDTO>> deleteAdvantage(@PathVariable("advantageType") String advantageType) {
			ResponseEntity<List<AdvantageDTO>> result = null;

			
			if (this.advantageList.removeIf(adv -> adv.getAdvantageType().equals(advantageType))) {
				System.out.println("우대조건 삭제 : " + advantageList);
				
			} 
			result = ResponseEntity.ok(this.advantageList);
			
			return result;
		}
	
	
	
	 @PostMapping("/file")
	    public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> uploadFile(@RequestParam("file") MultipartFile file,
	                                                                          HttpServletRequest request) {
	        try {
	            RecruitmentnoticeBoardUpfiles uploadedFile = fp.saveFileToRealPath(file, request, "/resources/recruitmentFiles");
	            uploadedFile.setStatus(FileStatus.NEW);
	            fileList.add(uploadedFile);
	            System.out.println(fileList);
	            return ResponseEntity.ok(fileList);
	        } catch (IOException e) {
	            logger.error("파일 업로드 실패", e);
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
	        }
	    }

	    @DeleteMapping("/file")
	    public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> removeFile(@RequestParam("removeFileName") String removeFileName) {
	        fileList.removeIf(f -> {
	            if (f.getOriginalFileName().equals(removeFileName)) {
	                fp.removeFile(f);
	                System.out.println(fileList);
	                return true;
	            }
	            return false;
	        });
	        return ResponseEntity.ok(fileList);
	    }
	
	
	

	// 내가 작성한 공고 수정하는 메서드

	// 내가 작성한 공고 삭제하는 메서드
	// delete가 아니라 dueDate(마감기한 now()로 설정) update. sql스케쥴러 사용해서 반년 이따 지우자...

	// 리스트, 필드를 전부 비워주는 메서드 (다 하고 맨 밑으로 내리자)
	private void ListAllClear() {
		this.advantageList.clear();
		this.applicationList.clear();
		this.fileList.clear();
		this.regionCode = null;
		this.sigunguCode = null;
		this.majorCategoryCode = null;
		this.subCategoryCode = null;

	}
}
