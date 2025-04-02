package com.jobhunter.controller.recruitmentnotice;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.model.util.FileStatus;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;
import com.jobhunter.util.RecruitmentFileProcess;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/recruitmentnotice")
public class RecruitmentNoticeController {
	private final RecruitmentNoticeService recruitmentService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeController.class);

	// 양식을 저장 할 List, 코드들
	private final List<AdvantageDTO> advantageList = new ArrayList<>();
	private final List<ApplicationDTO> applicationList = new ArrayList<>();

	// 게시글 작성시 업로드한 파일객체들을 임시로 저장
	private List<RecruitmentnoticeBoardUpfiles> fileList = new ArrayList<RecruitmentnoticeBoardUpfiles>();
	// 게시글 수정시 업로한 파일 객체들을 임시로 저장
	private List<RecruitmentnoticeBoardUpfiles> modifyFileList;
	private final RecruitmentFileProcess fp;

	// 회사가 공고를 등록하는 메서드
	@PostMapping("/save")
	public String saveRecruitment(RecruitmentNoticeDTO dto) {

		List<ApplicationDTO> appList = new ArrayList<>();
		List<AdvantageDTO> advList = new ArrayList<>();

		System.out.println("DTO 확인: " + dto);

		ObjectMapper objectMapper = new ObjectMapper();

		// 추가 파싱 및 변환
		if (dto.getDueDateForString() != null) {
			LocalDate date = LocalDate.parse(dto.getDueDateForString());
			dto.setDueDate(Timestamp.valueOf(date.atStartOfDay()));
		}

		// 저장 로직 호출
		try {
			recruitmentService.saveRecruitmentNotice(dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		ListAllClear();

		return "redirect:/recruitmentnotice/listAll"; // 혹은 성공 페이지
	}

	// 전체 공고 리스트를 출력하는 메서드
	@GetMapping("/listAll")
	public String showRecruitmentList(PageRequestDTO pageRequestDTO, Model model) {
		try {

			PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO;

			pageResponseDTO = recruitmentService.getEntireRecruitment(pageRequestDTO);

			model.addAttribute("pageResponse", pageResponseDTO); // view에서 pageResponse 사용 가능
			model.addAttribute("boardList", pageResponseDTO.getBoardList()); // 바로 리스트도

		} catch (Exception e) {
			e.printStackTrace();

		}

		return "recruitmentnotice/listAll";
	}

	// 회사가 공고를 작성할 때 면접방식을 리스트에 누적 해주는 메서드
	// 같은 면접방식이 중복 저장되는 문제가 생겼다... 해결해보자
	@PostMapping(value = "/application")
	public ResponseEntity<List<ApplicationDTO>> saveApplicationWithRecruitmentNotice(
			@RequestBody ApplicationDTO applicationDTO) {
		// 성공, 실패 여부를 json으로 응답
		ResponseEntity<List<ApplicationDTO>> result = null;

		boolean isDuplicate = false;
		for (ApplicationDTO appl : applicationList) {
			if (appl.getMethod() == applicationDTO.getMethod()) {
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

	// 공고를 작성할 때 면접방식을 삭제하는 메서드

	@DeleteMapping("/application")
	public ResponseEntity<List<ApplicationDTO>> deleteApplicationWithRecruitmentNotice(
			@RequestBody ApplicationDTO applicationDTO) {
		ResponseEntity<List<ApplicationDTO>> result = null;

		for (int i = 0; i < applicationList.size(); i++) {
			if (applicationList.get(i).getMethod() == applicationDTO.getMethod()) {
				applicationList.remove(i);
			}
		}
		result = ResponseEntity.ok(applicationList);

		System.out.println(applicationList);

		return result;
	}

	// 파일을 저장하는 메서드
	@PostMapping("/file")
	public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> uploadFile(@RequestParam("file") MultipartFile file,
			HttpServletRequest request) {
		try {
			RecruitmentnoticeBoardUpfiles uploadedFile = fp.saveFileToRealPath(file, request,
					"/resources/recruitmentFiles");
			uploadedFile.setStatus(FileStatus.NEW);
			fileList.add(uploadedFile);
			System.out.println(fileList);
			return ResponseEntity.ok(fileList);
		} catch (IOException e) {
			logger.error("파일 업로드 실패", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
		}
	}

	// 파일을 삭제하는 메서드
	@DeleteMapping("/file")
	public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> removeFile(
			@RequestParam("removeFileName") String removeFileName) {
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

	// 지역별 공고 리스트를 출력하는 메서드

	// 직종별 공고 리스트를 출력하는 메서드

	// 공고를 작성하는 페이지를 출력하는 메서드
	@GetMapping("/write")
	public void showRecruitmentWithWrite() {

	}

	// 상세 보기 페이지를 출력
	@GetMapping("/detail/{uid}")
	public String showDetailRecruitment(@PathVariable("uid") int uid, Model model) {
		System.out.println(uid);

		try {
			RecruitmentDetailInfo detailInfo = recruitmentService.getRecruitmentByUid(uid);
			model.addAttribute("RecruitmentDetailInfo", detailInfo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}

		return "recruitmentnotice/detail";
	}

	// 공고를 수정하는 페이지를 출력하는 메서드

	// 공고를 삭제하는 페이지를 출력하는 메서드

	// 리스트, 필드를 전부 비워주는 메서드 (다 하고 맨 밑으로 내리자)
	private void ListAllClear() {
		this.advantageList.clear();
		this.applicationList.clear();
		this.fileList.clear();

	}

}
