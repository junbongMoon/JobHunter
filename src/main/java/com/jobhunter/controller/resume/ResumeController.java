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
import com.jobhunter.model.resume.ResumeAdviceDTO;
import com.jobhunter.model.resume.ResumeAdviceCommentDTO;
import com.jobhunter.model.resume.ResumeAdviceUpfileDTO;
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

/**
 * 이력서 관련 기능을 처리하는 컨트롤러 클래스입니다.
 * <p>
 * 이력서 작성 폼 화면 출력 
 * 이력서 최종 제출 및 저장
 * 이력서 수정 및 업데이트
 * 이력서 삭제
 * 첨부파일 업로드 및 삭제
 * </p>
 * 
 * @author 유지원
 */
@Controller
@RequestMapping("/resume")
@RequiredArgsConstructor
public class ResumeController {
	
	/** 이력서 관련 서비스 */
	private final ResumeService resumeService;
	/** 이력서 파일 처리 클래스 */
	private final FileProcessForResume fileProcessForResume;

	/**
	 * 이력서 작성 폼 페이지를 출력합니다.
	 * <p>
	 * 사용자는 이 페이지에서 이력서를 새로 작성할 수 있습니다.
	 * 지역, 업직종, ENUM 정보, 사용자 정보 등을 미리 조회해서 View에 전달합니다.
	 * </p>
	 * 
	 * @param model JSP에 전달할 데이터
	 * @param session 로그인한 사용자 세션 정보
	 * @return 이력서 작성 JSP 경로
	 * @author 유지원
	 */
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



		return "resume/resumeFormNew";
	}

	/**
	 * 이력서 목록 페이지를 출력합니다.
	 * <p>
	 * 로그인한 사용자의 이력서 목록을 페이징 처리해서 보여줍니다.
	 * <p>
	 * 
	 * @param session      로그인 세션
	 * @param model        View에 전달할 데이터
	 * @param page         현재 페이지 번호 (기본값 1)
	 * @param pageSize     페이지당 표시할 이력서 수 (기본값 10)
	 * @param searchTitle  제목 검색 키워드 (선택)
	 * @return 이력서 목록 JSP 경로
	 * @author 유지원
	 */
	// 이력서 목록 페이지
	@GetMapping("/list")
	public String resumeFormList(HttpSession session, Model model, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int pageSize, @RequestParam(required = false) String searchTitle) {
		try {
			AccountVO account = (AccountVO) session.getAttribute("account");

			int userUid = account.getUid();
			List<ResumeVO> resumeList = resumeService.getResumeList(userUid, page, pageSize, searchTitle);
			int totalResumes = resumeService.getTotalResumes(userUid, searchTitle);
			int totalPages = (int) Math.ceil((double) totalResumes / pageSize);

			// 페이징 블록 계산
			int blockSize = 5;
			int currentBlock = (page - 1) / blockSize;
			int startPage = currentBlock * blockSize + 1;
			int endPage = startPage + blockSize - 1;
			if (endPage > totalPages) {
				endPage = totalPages;
			}
			int totalBlocks = (int) Math.ceil((double) totalPages / blockSize);

			model.addAttribute("resumeList", resumeList);
			model.addAttribute("account", account);
			model.addAttribute("currentPage", page);
			model.addAttribute("totalPages", totalPages);
			model.addAttribute("pageSize", pageSize);
			model.addAttribute("totalResumes", totalResumes);
			model.addAttribute("startPage", startPage);
			model.addAttribute("endPage", endPage);
			model.addAttribute("currentBlock", currentBlock + 1);
			model.addAttribute("totalBlocks", totalBlocks);
			model.addAttribute("searchTitle", searchTitle);

			return "resume/resumeFormList";
		} catch (Exception e) {
			model.addAttribute("error", "이력서 목록을 불러오는 중 오류가 발생했습니다.");
			return "error";
		}
	}

	/**
	 * 선택된 지역(시/도)의 하위 지역(시/군/구) 리스트를 반환합니다.
	 * <p>
	 * AJAX로 동작하며 JSON 형태로 데이터를 반환합니다.
	 * </p>
	 * 
	 * @param regionNo 선택된 지역 번호
	 * @return 시/군/구 목록 (JSON)
	 * @author 유지원
	 */
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

	/**
	 * 선택된 업직종 대분류의 하위 소분류 리스트를 반환합니다.
	 * <p>
	 * AJAX로 동작하며 JSON 형태로 데이터를 반환합니다.
	 * </p>
	 * 
	 * @param majorNo 선택된 대분류 번호
	 * @return 소분류 목록 (JSON)
	 * @author 유지원
	 */
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

	/**
	 * 이력서를 최종 저장합니다.
	 * <p>
	 * 유효성 검사를 통과한 이력서를 DB에 저장합니다.
	 * </p>
	 * 
	 * @param resumeDTO 저장할 이력서 정보(JSON)
	 * @return 저장 성공/실패 여부를 담은 응답 (JSON)
	 * @author 유지원
	 */
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

	/**
	 * 이력서에 첨부할 파일을 서버에 업로드합니다.
	 * <p>
	 * 드래그 앤 드롭으로 업로드된 파일을 처리합니다.
	 * </p>
	 * 
	 * @param file 업로드할 파일
	 * @param request 요청 객체
	 * @return 업로드 결과 (성공 여부, 파일 정보 포함 JSON)
	 * @author 유지원
	 */
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

	/**
	 * 업로드된 파일을 삭제합니다.
	 * <p>
	 * 서버에 저장된 파일을 제거하고, 결과를 JSON으로 반환합니다.
	 *</p>
	 *
	 * @param fileDTO 삭제할 파일 정보
	 * @param request 요청 객체
	 * @return 삭제 결과 (JSON)
	 * @author 유지원
	 */
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

	/**
	 * 기존에 작성된 이력서를 수정할 수 있는 폼을 보여줍니다.
	 * <p>
	 * 사용자가 입력했던 내용들을 DB에서 불러와 view에 출력합니다.
	 * 단, 기업이 확인 중인 이력서는 수정할 수 없습니다.
	 * </p>
	 * 
	 * @param resumeNo 수정할 이력서 번호
	 * @param model    View에 전달할 데이터
	 * @param session  사용자 세션
	 * @return 이력서 수정 폼 JSP 경로 또는 오류 페이지
	 * @author 유지원
	 */
//	@GetMapping({"/edit/{resumeNo}", "/advice/{resumeNo}", "/checkAdvice/{resumeNo}"})
//	public String editResumeForm(@PathVariable int resumeNo, @RequestParam int uid, Model model, HttpSession session, HttpServletRequest request) {
//		AccountVO account = (AccountVO) session.getAttribute("account");
//		int userUid = account.getUid();
//		try {
//			// 수정으로 접근했을 때만 이력서 상태 확인
//			if (request.getRequestURI().contains("/edit/") && resumeService.isResumeChecked(resumeNo)) {
//				model.addAttribute("error", "기업에서 확인중인 이력서는 수정할 수 없습니다.");
//				return "error";
//			}
//
//			// 첨삭 상태 확인
//			if (request.getRequestURI().contains("/edit/") && resumeService.isResumeAdvice(resumeNo)) {
//				model.addAttribute("error", "첨삭 중인 이력서는 수정할 수 없습니다.");
//				return "error";
//			}
//			// 기존 이력서 정보 조회
//			ResumeDetailDTO resumeDetail = resumeService.getResumeDetailWithAll(resumeNo);
//			model.addAttribute("resumeDetail", resumeDetail);
//
//			// 지역 목록 조회
//			List<RegionDTO> regionList = resumeService.getAllRegions();
//			model.addAttribute("regionList", regionList);
//
//			// 업직종 대분류 목록 조회
//			List<MajorCategoryDTO> majorList = resumeService.getAllMajorCategories();
//			model.addAttribute("majorList", majorList);
//
//			// 선택된 시군구 목록 조회
//			List<SigunguVO> selectedSigungu = resumeService.getResumeSigungu(resumeNo);
//			model.addAttribute("selectedSigungu", selectedSigungu);
//
//			// 선택된 업직종 목록 조회
//			List<SubCategoryVO> selectedSubCategory = resumeService.getResumeSubCategory(resumeNo);
//			model.addAttribute("selectedSubCategory", selectedSubCategory);
//
//			// 고용형태 ENUM 목록 추가
//			model.addAttribute("jobFormList", JobForm.values());
//
//			// 학력 레벨 ENUM 목록 추가
//			model.addAttribute("educationLevelList", EducationLevel.values());
//
//			// 학력 상태 ENUM 목록 추가
//			model.addAttribute("educationStatusList", EducationStatus.values());
//
//			// 현재 날짜를 YYYY-MM-DD 형식으로 추가
//			String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
//			model.addAttribute("today", today);
//
//			// 이력서의 유저정보를 가져옴
//			UserVO user = resumeService.getUserInfo(uid);
//			model.addAttribute("user", user);
//			
//			String uri = request.getRequestURI();
//			if (uri.contains("advice")) {
//				model.addAttribute("mode", "advice");
//
//			} else if (uri.contains("checkAdvice")) {
//				// 첨삭 내용 조회
//				ResumeAdviceDTO advice = resumeService.getAdvice(resumeNo);
//				if (advice != null) {
//					model.addAttribute("advice", advice);
//					// 첨삭 파일 조회
//					List<ResumeAdviceUpfileDTO> adviceFiles = resumeService.getAdviceFiles(advice.getAdviceNo());
//					model.addAttribute("adviceFiles", adviceFiles);
//				}
//				model.addAttribute("mode", "checkAdvice");
//			}
//
//			return "resume/resumeForm";
//		} catch (Exception e) {
//			model.addAttribute("error", "이력서 정보를 불러오는 중 오류가 발생했습니다.");
//			return "error";
//		}
//	}

	/**
	 * 기존에 작성된 이력서를 수정(저장)합니다.
	 * <p>
	 * 사용자가 이력서 수정 폼에서 입력한 내용을 받아와 DB에 반영합니다.
	 * 수정 성공 시 이력서 목록 페이지로 리다이렉트 URL을 함께 반환합니다.
	 * <p>
	 * 
	 * @param resumeNo   수정할 이력서의 번호
	 * @param resumeDTO  클라이언트에서 보낸 이력서 데이터 (JSON 형식)
	 * @return 수정 성공 여부와 메시지를 포함한 JSON 응답
	 * @author 유지원
	 */
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

	/**
	 * 이력서 첨삭 내용을 저장합니다.
	 * <p>
	 * 첨삭 내용과 첨부파일 정보를 저장합니다.
	 * </p>
	 * 
	 * @param adviceDTO 첨삭 정보
	 * @return 저장 결과
	 * @author 유지원
	 */
	@PostMapping("/advice/save")
	@ResponseBody
	public Map<String, Object> saveAdvice(@RequestBody ResumeAdviceDTO adviceDTO) {
		Map<String, Object> response = new HashMap<>();

		try {
			resumeService.saveAdvice(adviceDTO);
			response.put("success", true);
			response.put("message", "첨삭이 저장되었습니다.");
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", "첨삭 저장에 실패했습니다: " + e.getMessage());
		}

		return response;
	}
	
	/**
	 * 첨삭 종료 처리
	 * <p>
	 * 첨삭 종료 버튼을 눌렀을 때 첨삭 종료 처리를 합니다.
	 * </p>
	 * 
	 * @param resumeNo 첨삭 종료할 이력서의 번호
	 * @param model    View에 전달할 데이터
	 * @param session  사용자 세션
	 * @return 첨삭 종료 결과 메시지를 포함한 HTTP 응답 객체
	 * @author 유지원
	 */
	@PostMapping("/endAdvice")
	public ResponseEntity<Map<String, Object>> endAdvice(@RequestBody ResumeAdviceDTO adviceDTO, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		int userUid = account.getUid();

		int resumeNo = adviceDTO.getResumeNo();
		int ownerUid = adviceDTO.getOwnerUid();

		Map<String, Object> response = new HashMap<>();
		try {
			resumeService.saveAdvice(adviceDTO);
			// 이력서 첨삭 종료 처리
			boolean result = resumeService.endAdvice(resumeNo, userUid, ownerUid);
			if (result) {
				response.put("message", "첨삭이 종료되었습니다.");
				response.put("url", "/user/mypage/"+userUid);
				response.put("success", true);
				return ResponseEntity.ok().body(response);
			} else {
				response.put("message", "이미 첨삭 종료를 하였습니다.");
				response.put("success", false);
				return ResponseEntity.ok().body(response);
			}
		} catch (Exception e) {
			response.put("message", "첨삭 종료 처리 중 오류가 발생했습니다.");
			response.put("success", false);
			return ResponseEntity.ok().body(response);
		}
	}
	
	
//	테스트용 메서드 입니다. -- 이력서 첨삭 기능 개선 중....
	@GetMapping({"/edit/{resumeNo}", "/advice/{resumeNo}", "/checkAdvice/{resumeNo}"})
	public String editResumeForm(@PathVariable int resumeNo, @RequestParam int uid, Model model, HttpSession session,
			HttpServletRequest request) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		int userUid = account.getUid();
		try {
			// 수정으로 접근했을 때만 이력서 상태 확인
			if (request.getRequestURI().contains("/edit/") && resumeService.isResumeChecked(resumeNo)) {
				model.addAttribute("error", "기업에서 확인중인 이력서는 수정할 수 없습니다.");
				return "error";
			}

			// 첨삭 상태 확인
			if (request.getRequestURI().contains("/edit/") && resumeService.isResumeAdvice(resumeNo)) {
				model.addAttribute("error", "첨삭 중인 이력서는 수정할 수 없습니다.");
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

			// 이력서의 유저정보를 가져옴
			UserVO user = resumeService.getUserInfo(uid);
			model.addAttribute("user", user);

			String uri = request.getRequestURI();
			if (uri.contains("advice")) {
				model.addAttribute("mode", "advice");

			} else if (uri.contains("checkAdvice")) {
				// 첨삭 내용 조회
				ResumeAdviceDTO advice = resumeService.getAdvice(resumeNo);
				if (advice != null) {
					model.addAttribute("advice", advice);
					// 첨삭 파일 조회
					List<ResumeAdviceUpfileDTO> adviceFiles = resumeService.getAdviceFiles(advice.getAdviceNo());
					model.addAttribute("adviceFiles", adviceFiles);
				}
				model.addAttribute("mode", "checkAdvice");
			}

			return "resume/resumeFormTest";
		} catch (Exception e) {
			model.addAttribute("error", "이력서 정보를 불러오는 중 오류가 발생했습니다.");
			return "error";
		}
	}

}
