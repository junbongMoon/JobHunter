package com.jobhunter.controller.resume;

import java.util.List;

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
		model.addAttribute("regionList", resumeService.getAllRegions());
		model.addAttribute("majorList", resumeService.getAllMajorCategories());
		return "resume/resumeForm"; // JSP 파일명
	}

	// 희망 근무 지역: 시/군/구 가져오기 (AJAX)
	@GetMapping("/getSigungu")
	@ResponseBody
	public List<SigunguDTO> getSigungu(@RequestParam("regionNo") int regionNo) {
		return resumeService.getSigunguByRegion(regionNo);
	}

	// 희망 업직종: 소분류 가져오기 (AJAX)
	@GetMapping("/getSubCategory")
	@ResponseBody
	public List<SubCategoryDTO> getSubCategory(@RequestParam("majorNo") int majorNo) {
		return resumeService.getSubCategoriesByMajor(majorNo);
	}

	// 임시 저장
	@PostMapping("/submit-temp")
	@ResponseBody
	public String submitTempResume(@RequestBody ResumeDTO resumeDTO) {
		resumeService.tempSaveResume(resumeDTO);
		return "success";
	}

	// 최종 저장
	@PostMapping("/submit-final")
	@ResponseBody
	public String submitFinalResume(@RequestBody ResumeDTO resumeDTO) {
		resumeService.finalSaveResume(resumeDTO);
		return "success";
	}

}
