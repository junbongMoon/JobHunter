package com.jobhunter.controller.resume;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.JobForm;
import com.jobhunter.model.resume.EducationLevel;
import com.jobhunter.model.resume.EducationStatus;
import com.jobhunter.model.resume.MajorCategoryDTO;
import com.jobhunter.model.resume.RegionDTO;
import com.jobhunter.model.resume.ResumeDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.model.resume.SigunguDTO;
import com.jobhunter.model.resume.SigunguVO;
import com.jobhunter.model.resume.SubCategoryDTO;
import com.jobhunter.model.resume.SubCategoryVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.resume.ResumeService;
import com.jobhunter.util.resume.FileProcessForResume;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/resume")
@RequiredArgsConstructor
public class ResumeController {

	private final ResumeService resumeService;
	private final FileProcessForResume fileProcessForResume;

	// 이력서 작성 폼 연결
	@GetMapping("/form")
	public String resumeForm(Model model, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		int userUid = account.getUid();
		try {
			// 지역 목록 조회
			List<RegionDTO> regionList = resumeService.getAllRegions();
			model.addAttribute("regionList", regionList);
			// 업직종 대분류 목록 조회
			List<MajorCategoryDTO> majorList = resumeService.getAllMajorCategories();
			model.addAttribute("majorList", majorList);
			// 유저정보를 가져옴
			UserVO user = resumeService.getUserInfo(userUid);
			model.addAttribute("user", user);
		} catch (Exception e) {
			model.addAttribute("error", "데이터를 불러오는 중 오류가 발생했습니다.");
			return "error";
		}

		// 고용형태 ENUM 목록 추가
		model.addAttribute("jobFormList", JobForm.values());

		// 학력 레벨 ENUM 목록 추가
		model.addAttribute("educationLevelList", EducationLevel.values());

		// 학력 상태 ENUM 목록 추가
		model.addAttribute("educationStatusList", EducationStatus.values());

		// 현재 날짜를 YYYY-MM-DD 형식으로 추가
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
		model.addAttribute("today", today);

		return "resume/resumeForm";
	}

	// 이력서 목록 페이지
	@GetMapping("/list")
	public String resumeFormList(HttpSession session, Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int pageSize) {
		try {
			AccountVO account = (AccountVO) session.getAttribute("account");

			int userUid = account.getUid();
			List<ResumeVO> resumeList = resumeService.getResumeList(userUid, page, pageSize);
			int totalResumes = resumeService.getTotalResumes(userUid);
			int totalPages = (int) Math.ceil((double) totalResumes / pageSize);

			model.addAttribute("resumeList", resumeList);
			model.addAttribute("account", account);
			model.addAttribute("currentPage", page);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("pageSize", pageSize);
			model.addAttribute("totalResumes", totalResumes);
			return "resume/resumeFormList";
		} catch (Exception e) {
			model.addAttribute("error", "이력서 목록을 불러오는 중 오류가 발생했습니다.");
			return "error";
		}
	}

	// 희망 근무 지역: 시/군/구 가져오기
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

	// 희망 업직종: 소분류 가져오기
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

	// 저장
	@PostMapping("/submit-final")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> submitFinal(@RequestBody ResumeDTO resumeDTO) {
		try {
			resumeService.finalSaveResume(resumeDTO);
			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("message", "FINAL 저장 완료");
			response.put("redirectUrl", "/resume/list");
			return ResponseEntity.ok().body(response);
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "최종 저장 실패: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 이력서 첨부파일 업로드
	@PostMapping(value = "/uploadFile", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public Map<String, Object> uploadFile(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		try {
			ResumeUpfileDTO savedFile = fileProcessForResume.saveFileToRealPath(file, request,
					"/resources/resumeUpfiles");
			if (savedFile == null) {
				result.put("success", false);
				result.put("message", "파일 저장 실패");
				return result;
			}
			result.put("success", true);
			result.put("originalFileName", savedFile.getOriginalFileName());
			result.put("newFileName", savedFile.getNewFileName());
			result.put("ext", savedFile.getExt());
			result.put("size", savedFile.getSize());
			result.put("base64Image", savedFile.getBase64Image());
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "파일 업로드 중 오류 발생: " + e.getMessage());
		}
		return result;
	}

	@PostMapping(value = "/deleteFile", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public Map<String, Object> deleteFile(@RequestBody ResumeUpfileDTO fileDTO, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<>();
		try {
			fileProcessForResume.removeFile(fileDTO);
			result.put("success", true);
			result.put("message", "파일이 성공적으로 삭제되었습니다.");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "파일 삭제 중 오류 발생: " + e.getMessage());
		}
		return result;
	}

	// 이력서 수정 페이지 -> /form과 합침 작업 예정
	@GetMapping("/edit/{resumeNo}")
	public String editResumeForm(@PathVariable int resumeNo, Model model, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		int userUid = account.getUid();
		try {
			// 이력서 상태 확인
			if (resumeService.isResumeChecked(resumeNo)) {
				model.addAttribute("error", "기업에서 확인중인 이력서는 수정할 수 없습니다.");
				return "error";
			}
			
			// 기존 이력서 정보 조회
			ResumeDetailDTO resumeDetail = resumeService.getResumeDetailWithAll(resumeNo);
			model.addAttribute("resumeDetail", resumeDetail);

			// 지역 목록 조회
			List<RegionDTO> regionList = resumeService.getAllRegions();
			model.addAttribute("regionList", regionList);

			// 업직종 대분류 목록 조회
			List<MajorCategoryDTO> majorList = resumeService.getAllMajorCategories();
			model.addAttribute("majorList", majorList);

			// 선택된 시군구 목록 조회
			List<SigunguVO> selectedSigungu = resumeService.getResumeSigungu(resumeNo);
			model.addAttribute("selectedSigungu", selectedSigungu);

			// 선택된 업직종 목록 조회
			List<SubCategoryVO> selectedSubCategory = resumeService.getResumeSubCategory(resumeNo);
			model.addAttribute("selectedSubCategory", selectedSubCategory);

			// 고용형태 ENUM 목록 추가
			model.addAttribute("jobFormList", JobForm.values());

			// 학력 레벨 ENUM 목록 추가
			model.addAttribute("educationLevelList", EducationLevel.values());

			// 학력 상태 ENUM 목록 추가
			model.addAttribute("educationStatusList", EducationStatus.values());

			// 현재 날짜를 YYYY-MM-DD 형식으로 추가
			String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
			model.addAttribute("today", today);

			// 유저정보를 가져옴
			UserVO user = resumeService.getUserInfo(userUid);
			model.addAttribute("user", user);

			return "resume/resumeForm";
		} catch (Exception e) {
			model.addAttribute("error", "이력서 정보를 불러오는 중 오류가 발생했습니다.");
			return "error";
		}
	}

	// 이력서 수정 처리
	@PostMapping("/update/{resumeNo}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateResume(@PathVariable int resumeNo,
			@RequestBody ResumeDTO resumeDTO) {
		try {			
			resumeDTO.setResumeNo(resumeNo);
			resumeService.updateResume(resumeDTO);
			Map<String, Object> response = new HashMap<>();
			response.put("success", true);
			response.put("message", "이력서가 성공적으로 수정되었습니다.");
			response.put("redirectUrl", "/resume/list");
			return ResponseEntity.ok().body(response);
		} catch (Exception e) {
			Map<String, Object> response = new HashMap<>();
			response.put("success", false);
			response.put("message", "이력서 수정 실패: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

}
