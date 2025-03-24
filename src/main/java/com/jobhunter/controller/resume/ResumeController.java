package com.jobhunter.controller.resume;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.service.resume.ResumeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/resume")
@RequiredArgsConstructor
public class ResumeController {

	private final ResumeService resumeService;

	// 이력서 작성 폼 연결
	@GetMapping("/form")
	public String resumeForm(Model model) {
		try {
			model.addAttribute("regionList", resumeService.getAllRegions());
			model.addAttribute("majorList", resumeService.getAllMajorCategories());
			return "resume/resumeForm"; // JSP 파일명
		} catch (Exception e) {
			model.addAttribute("error", "데이터를 불러오는 중 오류가 발생했습니다.");
			return "error";
		}
	}

	// 이력서 목록 페이지
	@GetMapping("/resumeFormList")
	public String resumeFormList() {
		return "resume/resumeFormList";
	}

	// 희망 근무 지역: 시/군/구 가져오기 (AJAX)
	@GetMapping("/getSigungu")
	@ResponseBody
	public ResponseEntity<?> getSigungu(@RequestParam("regionNo") int regionNo) {
		try {
			List<SigunguDTO> sigunguList = resumeService.getSigunguByRegion(regionNo);
			return ResponseEntity.ok(sigunguList);
		} catch (Exception e) {
			Map<String, String> response = new HashMap<>();
			response.put("error", "시/군/구 목록을 불러오는 중 오류가 발생했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 희망 업직종: 소분류 가져오기 (AJAX)
	@GetMapping("/getSubCategory")
	@ResponseBody
	public ResponseEntity<?> getSubCategory(@RequestParam("majorNo") int majorNo) {
		try {
			List<SubCategoryDTO> subCategoryList = resumeService.getSubCategoriesByMajor(majorNo);
			return ResponseEntity.ok(subCategoryList);
		} catch (Exception e) {
			Map<String, String> response = new HashMap<>();
			response.put("error", "소분류 목록을 불러오는 중 오류가 발생했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// TEMP저장
	@PostMapping("/submit-temp")
	@ResponseBody
	public ResponseEntity<?> submitTemp(@RequestBody ResumeDTO resumeDTO) {
		try {
			resumeService.tempSaveResume(resumeDTO);
			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("message", "TEMP 저장 완료");
			response.put("redirectUrl", "/resume/resumeFormList");
			return ResponseEntity.ok().body(response);
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "저장 실패: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 최종 저장
	@PostMapping("/submit-final")
	@ResponseBody
	public ResponseEntity<?> submitFinal(@RequestBody ResumeDTO resumeDTO) {
		try {
			resumeService.finalSaveResume(resumeDTO);
			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("message", "FINAL 저장 완료");
			response.put("redirectUrl", "/resume/resumeFormList");
			return ResponseEntity.ok().body(response);
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "최종 저장 실패: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

}
