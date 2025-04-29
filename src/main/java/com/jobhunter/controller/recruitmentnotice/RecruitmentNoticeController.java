package com.jobhunter.controller.recruitmentnotice;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.Application;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.model.util.FileStatus;
import com.jobhunter.service.like.LikeService;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;
import com.jobhunter.util.RecruitmentFileProcess;

import lombok.RequiredArgsConstructor;

/**
 * @author 문준봉
 *         <p>
 *         공고를 담당하는 Controller
 *         </p>
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/recruitmentnotice")
public class RecruitmentNoticeController {
	private final RecruitmentNoticeService recruitmentService;
	private final LikeService likeService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeController.class);

	/**
	 * 우대조건을 저장하는 리스트 필드
	 */
	private final List<AdvantageDTO> advantageList = new ArrayList<>();
	/**
	 * 면접 방식을 저장하는 리스트 필드
	 */
	private final List<ApplicationDTO> applicationList = new ArrayList<>();

	/**
	 * 작성 페이지에서 업로드하는 파일들을 저장하는 파일 리스트
	 */
	private List<RecruitmentnoticeBoardUpfiles> fileList = new ArrayList<>();
	// 게시글 수정시 업로한 파일 객체들을 임시로 저장
	/**
	 * 수정 페이지에서 수정된 파일을 저장하는 파일 리스트
	 */
	private List<RecruitmentnoticeBoardUpfiles> modifyFileList = new ArrayList<>();
	/**
	 * 파일 처리 객체
	 */
	private final RecruitmentFileProcess fp;

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         회사가 공고를 등록하는 메서드
	 *         </p>
	 * 
	 * @param dto
	 * @return 리스트페이지로 이동하는 String을 반환
	 *
	 */
	@PostMapping("/save")
	public String saveRecruitment(@ModelAttribute RecruitmentNoticeDTO dto) {
		boolean result = false;

		System.out.println("DTO 확인: " + dto);
		System.out.println("Period 값 확인: " + dto.getPeriod()); // ← 여기도 로그 확인!

		if (dto.getDueDateForString() != null && !dto.getDueDateForString().isEmpty()) {
			LocalDate date = LocalDate.parse(dto.getDueDateForString());
			dto.setDueDate(Timestamp.valueOf(date.atStartOfDay()));
		}

		// 저장 로직 호출
		try {
			recruitmentService.saveRecruitmentNotice(dto, advantageList, applicationList, fileList);
			result = true;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		System.out.println(result);

		ListAllClear();

		return "redirect:/recruitmentnotice/listAll"; // 혹은 성공 페이지
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         전체 공고 리스트를 출력하는 메서드
	 *         </p>
	 * 
	 * @param pageRequestDTO
	 * @param model
	 * @return 리스트페이지로 이동하는 String을 반환
	 *
	 */
	@GetMapping("/listAll")
	public String showRecruitmentList(PageRequestDTO pageRequestDTO, Model model) {
		
		try {

			PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO;
			System.out.println(pageRequestDTO);
			pageResponseDTO = recruitmentService.getEntireRecruitment(pageRequestDTO);

			model.addAttribute("pageResponse", pageResponseDTO); // view에서 pageResponse 사용 가능
			model.addAttribute("boardList", pageResponseDTO.getBoardList()); // 바로 리스트도

		} catch (Exception e) {
			e.printStackTrace();

		}

		return "recruitmentnotice/listAll";
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         회사가 공고를 작성할 때 면접방식을 리스트에 누적 해주는 메서드
	 *         </p>
	 * 
	 * @param applicationDTO
	 * @return 면접방식을 담은 리스트를 담은 ResponseEntity
	 *
	 */
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

	@GetMapping("/listMore")
	public String loadMoreRecruitments(@RequestParam("pageNo") int pageNo,
			@RequestParam(required = false) String searchType, @RequestParam(required = false) String searchWord,
			@RequestParam(required = false) String sortOption, Model model) {

		PageRequestDTO pageRequestDTO = PageRequestDTO.builder().pageNo(pageNo).rowCntPerPage(10) // ★ 반드시 명시해야 함!
				.searchType(searchType).searchWord(searchWord).sortOption(sortOption).build();

		PageResponseDTO<RecruitmentDetailInfo> response;
		try {
			response = recruitmentService.getEntireRecruitment(pageRequestDTO);
			model.addAttribute("boardList", response.getBoardList());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "recruitmentnotice/recruitmentListFragment";
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고를 작성할 때 면접방식을 삭제하는 메서드
	 *         </p>
	 * 
	 * @param applicationDTO
	 * @return 면접방식을 담은 리스트를 담은 ResponseEntity
	 *
	 */
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

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         파일을 저장하는 메서드
	 *         </p>
	 * 
	 * @param files
	 * @param request
	 * @return 공고에 저장 된 파일을 담은 리스트를 담은 ResponseEntity
	 *
	 */
	@PostMapping("/file")
	public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> uploadFile(@RequestParam("file") MultipartFile[] files,
			HttpServletRequest request) {

		List<RecruitmentnoticeBoardUpfiles> uploadedFiles = new ArrayList<>();

		try {
			for (MultipartFile file : files) {
				RecruitmentnoticeBoardUpfiles uploadedFile = fp.saveFileToRealPath(file, request,
						"/resources/recruitmentFiles");

				uploadedFile.setStatus(FileStatus.NEW);
				uploadedFiles.add(uploadedFile);
				this.fileList.add(uploadedFile); // <-- ★ fileList에도 추가해야 save할 때 같이 넘어간다!!
			}
			System.out.println(uploadedFiles);

			return ResponseEntity.ok(uploadedFiles);

		} catch (IOException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
		}
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         파일을 삭제하는 메서드
	 *         </p>
	 * 
	 * @param removeFileName
	 * @return ResponseEntity<List<RecruitmentnoticeBoardUpfiles>>
	 *
	 */
	@DeleteMapping("/file/{removeFileName:.+}")
	public ResponseEntity<Void> removeFile(
	        @PathVariable("removeFileName") String removeFileName,
	        HttpServletRequest request) {

	    System.out.println("삭제할 파일명 : " + removeFileName);

	    if (!removeFileName.matches("^[a-zA-Z0-9_.-]+$")) {
	        return ResponseEntity.badRequest().build();
	    }

	    String realPath = request.getSession().getServletContext().getRealPath("/");

	    fileList.removeIf(file -> {
	        System.out.println("file.originalFileName: [" + file.getOriginalFileName() + "]");
	        System.out.println("removeFileName:       [" + removeFileName + "]");
	        boolean match = file.getOriginalFileName().equals(removeFileName);
	        if (match) {
	            fp.removeFile(file);
	        }
	        return match;
	    });

	    return ResponseEntity.ok().build(); // 🔁 본문 없이 200 OK
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         필드의 파일 리스트 전체 초기화 메서드
	 *         </p>
	 * 
	 * @return ResponseEntity<Void>
	 *
	 */
	@DeleteMapping("/removeAllFiles")
	public ResponseEntity<Void> removeAllFiles() {
		for (RecruitmentnoticeBoardUpfiles f : fileList) {
			fp.removeFile(f);
		}
		fileList.clear();
		return ResponseEntity.ok().build();
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고를 작성할 때 우대조건을 리스트에 누적 해주는 메서드
	 *         </p>
	 * 
	 * @param advantageDTO
	 * @return 공고에 저장 된 우대조건을 담은 리스트를 담은 ResponseEntity
	 *
	 */
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

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         회사가 공고를 작성할 때 우대조건을 리스트에서 삭제 해주는 메서드
	 *         </p>
	 * 
	 * @param advantageType
	 * @return 공고에 저장 된 우대조건을 담은 리스트를 담은 ResponseEntity
	 *
	 */
	@DeleteMapping(value = "/advantage/{advantageType}")
	public ResponseEntity<List<AdvantageDTO>> deleteAdvantage(@PathVariable("advantageType") String advantageType) {
		ResponseEntity<List<AdvantageDTO>> result = null;

		if (this.advantageList.removeIf(adv -> adv.getAdvantageType().equals(advantageType))) {
			System.out.println("우대조건 삭제 : " + advantageList);

		}
		result = ResponseEntity.ok(this.advantageList);

		return result;
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고를 작성하는 페이지를 출력하는 메서드
	 *         </p>
	 * 
	 *
	 */
	@GetMapping("/write")
	public void showRecruitmentWithWrite() {
		ListAllClear();

	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고 상세 페이지, 수정 페이지를 출력
	 *         </p>
	 * 
	 * @param uid
	 * @param model
	 * @param req
	 * @return 쿼리스트링으로 상태를 알려주고 리스트 페이지를 반환
	 *
	 */
	@GetMapping(value = { "/detail", "/modify" })
	public String showRecruitment(@RequestParam("uid") int uid, Model model, HttpServletRequest req) {
		System.out.println(uid);

		String returnPage = "";

		// 기존 리스트 초기화
		
		ListAllClear();

		try {
			RecruitmentDetailInfo detailInfo = recruitmentService.getRecruitmentByUid(uid);

			if (req.getRequestURI().contains("detail")) {
				AccountVO loginUser = (AccountVO) req.getSession().getAttribute("account");
				int viewerUid = loginUser != null ? loginUser.getUid() : 0;

				detailInfo = recruitmentService.getRecruitmentWithViewLog(uid, viewerUid);

				// ⭐ 좋아요 정보 추가
				boolean hasLiked = likeService.hasLiked(viewerUid, uid, "RECRUIT");
				int likeCnt = likeService.getLikeCntByRecruitment(uid, "RECRUIT");

				model.addAttribute("hasLiked", hasLiked);
				model.addAttribute("likeCnt", likeCnt);
			} else {
				detailInfo = recruitmentService.getRecruitmentByUid(uid);
			}

			// 우대 조건
			if (detailInfo.getAdvantage().size() > 0) {
				for (Advantage advantage : detailInfo.getAdvantage()) {
					AdvantageDTO advdto = AdvantageDTO.builder().advantageType(advantage.getAdvantageType()).build();
					this.advantageList.add(advdto);
				}
			}

			// 파일 리스트
			if (detailInfo.getFileList().size() > 0) {
				this.fileList = detailInfo.getFileList();
				this.modifyFileList = detailInfo.getFileList();
				System.out.println(modifyFileList);
				String modifyFileListJson = new ObjectMapper().writeValueAsString(this.modifyFileList);
				model.addAttribute("modifyFileListJson", modifyFileListJson);
			}

			// 면접 방식
			for (Application application : detailInfo.getApplication()) {
				ApplicationDTO appdto = ApplicationDTO.builder().method(application.getMethod())
						.detail(application.getDetail()).build();

				this.applicationList.add(appdto);

			}

			// 이전/다음 글 추가
			RecruitmentNotice prevPost = recruitmentService.getPreviousPost(uid);
			RecruitmentNotice nextPost = recruitmentService.getNextPost(uid);

			String applicationsJson = new ObjectMapper().writeValueAsString(this.applicationList);
			model.addAttribute("applicationsJson", applicationsJson);
			model.addAttribute("RecruitmentDetailInfo", detailInfo);
			model.addAttribute("prevPost", prevPost);
			model.addAttribute("nextPost", nextPost);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			returnPage = "redirect:./listAll?status=fail";

		}

		if (req.getRequestURI().contains("detail")) {
			returnPage = "recruitmentnotice/detail";
		} else if (req.getRequestURI().contains("modify")) {
			returnPage = "recruitmentnotice/modify";
		}

		if (returnPage.equals("")) {
			returnPage = "redirect:/recruitmentnotice/listAll?status=fail";
		}

		return returnPage;
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고를 수정하는 메서드
	 *         </p>
	 * 
	 * @param dto
	 * @param applicationJson
	 * @param advantageJson
	 * @param uid
	 * @return 쿼리스트링으로 상태를 알려주고 리스트 페이지를 반환
	 *
	 */
	@PostMapping("/modify")
	public String modifyRecruitment(@ModelAttribute RecruitmentNoticeDTO dto,
			@RequestParam("applicationJson") String applicationJson,
			@RequestParam("advantageJson") String advantageJson,
			@RequestParam("modifyFileListJson") String modifyFileListJson, @RequestParam("uid") int uid,
			HttpServletRequest request // ✅ request 추가
	) {
		dto.setUid(uid);
		boolean result = false;
		List<RecruitmentnoticeBoardUpfiles> deletedFiles = new ArrayList<>();

		try {
			ObjectMapper objectMapper = new ObjectMapper();

			List<ApplicationDTO> applications = objectMapper.readValue(applicationJson,
					new TypeReference<List<ApplicationDTO>>() {
					});
			List<AdvantageDTO> advantages = objectMapper.readValue(advantageJson,
					new TypeReference<List<AdvantageDTO>>() {
					});
			List<RecruitmentnoticeBoardUpfiles> modifyFileList = new ArrayList<>();

			if (modifyFileListJson != null && !modifyFileListJson.isEmpty()) {
				System.out.println(modifyFileList);
				modifyFileList = objectMapper.readValue(modifyFileListJson,
						new TypeReference<List<RecruitmentnoticeBoardUpfiles>>() {
						});
			}

			if (dto.getDueDateForString() != null && !dto.getDueDateForString().isEmpty()) {
				LocalDate date = LocalDate.parse(dto.getDueDateForString());
				dto.setDueDate(Timestamp.valueOf(date.atStartOfDay()));
			}

			RecruitmentDetailInfo existing = recruitmentService.getRecruitmentByUid(uid);

			// ❗ 삭제할 파일 목록 따로 수집
			for (RecruitmentnoticeBoardUpfiles oldFile : existing.getFileList()) {
			    boolean fileDeleted = modifyFileList.stream()
			        .anyMatch(newFile -> newFile.getOriginalFileName().equals(oldFile.getOriginalFileName()) && FileStatus.DELETE.equals(newFile.getStatus()));

			    if (fileDeleted) {
			        deletedFiles.add(oldFile);
			    }
			}
			
			if (result) {

			    for (RecruitmentnoticeBoardUpfiles file : deletedFiles) {
			        fp.removeFile(file);
			    }
			}
			
			System.out.println(modifyFileList);

			// DB만 수정
			recruitmentService.modifyRecruitmentNotice(dto, advantages, applications, modifyFileList, existing, uid);

			result = true;

		} catch (Exception e) {
			e.printStackTrace();
		}

		if (result) {
			// ✅ 파일 삭제 (DB 성공했을 때만!)
			String realPath = request.getSession().getServletContext().getRealPath("/");
			for (RecruitmentnoticeBoardUpfiles file : deletedFiles) {
				deletePhysicalFile(realPath, file);
			}
		}

		ListAllClear();
		return result ? "redirect:/recruitmentnotice/listAll"
				: "redirect:/recruitmentnotice/modify?uid=" + uid + "&status=fail";
	}

	private void deletePhysicalFile(String realPath, RecruitmentnoticeBoardUpfiles file) {
		try {
			String os = System.getProperty("os.name").toLowerCase();

			String mainPath = realPath + file.getNewFileName();
			String thumbPath = realPath + file.getThumbFileName();

			File mainFile = new File(os.contains("windows") ? mainPath.replace("/", "\\") : mainPath);
			File thumbFile = new File(os.contains("windows") ? thumbPath.replace("/", "\\") : thumbPath);

			if (mainFile.exists())
				mainFile.delete();
			if (thumbFile.exists())
				thumbFile.delete();

			System.out.println("삭제 완료: " + mainFile.getName() + ", " + thumbFile.getName());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고를 삭제하는 메서드
	 *         </p>
	 * 
	 * @param uid
	 * @return Boolean을 담은 ResponseEntity
	 *
	 */
	@DeleteMapping("/remove/{uid}")
	public ResponseEntity<Boolean> removeRecruitment(@PathVariable("uid") int uid, HttpServletRequest request) {
		ResponseEntity<Boolean> result = null;

		try {
			
			RecruitmentDetailInfo detailInfo = recruitmentService.getRecruitmentByUid(uid);
			
			if (recruitmentService.removeRecruitmentByUid(uid)) {
				
				if (detailInfo != null && detailInfo.getFileList() != null) {
	                String realPath = request.getSession().getServletContext().getRealPath("/");

	                for (RecruitmentnoticeBoardUpfiles file : detailInfo.getFileList()) {
	                    deletePhysicalFile(realPath, file);
	                }
	            }
				
				result = ResponseEntity.ok().body(true);
			} else {
				result = ResponseEntity.badRequest().body(false);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         파일 상태 업데이트
	 *         </p>
	 * 
	 * @param fileName
	 * @param status
	 * @return ResponseEntity<Void>
	 *
	 */
	@PostMapping("/file/status")
	public ResponseEntity<Void> updateFileStatus(@RequestParam("fileName") String fileName,
			@RequestParam("status") String status) {

		System.out.println(fileName);

		for (RecruitmentnoticeBoardUpfiles file : modifyFileList) {
			if (file.getOriginalFileName().equals(fileName)) {
				if ("delete".equalsIgnoreCase(status)) {
					file.setStatus(FileStatus.DELETE);

				} else if ("cancel".equalsIgnoreCase(status)) {
					file.setStatus(null);
				}
			}
		}
		System.out.println(modifyFileList);

		return ResponseEntity.ok().build();
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         수정 취소 시 파일 상태 롤백 및 삭제
	 *         </p>
	 * 
	 * @return ResponseEntity<Void>
	 *
	 */
	@PostMapping("/file/cancel")
	public ResponseEntity<Void> cancelFileModifications() {
		for (RecruitmentnoticeBoardUpfiles file : modifyFileList) {
			if (file.getStatus() == FileStatus.DELETE) {
				file.setStatus(null);
			} else if (file.getStatus() == FileStatus.NEW) {
				fp.removeFile(file);
			}
		}
		modifyFileList.clear();
		return ResponseEntity.ok().build();
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         파일 수정 최종 반영
	 *         </p>
	 * 
	 * @return ResponseEntity<Void>
	 *
	 */
	@PostMapping("/file/finalize")
	public ResponseEntity<Void> finalizeFileModifications() {
		System.out.println("호출됬나?");
		for (RecruitmentnoticeBoardUpfiles file : modifyFileList) {
			if (file.getStatus() == FileStatus.DELETE) {
				fp.removeFile(file); // 실제 파일 삭제
				recruitmentService.deleteFileFromDatabase(file.getBoardUpFileNo()); // DB에서 삭제
			}
		}
		modifyFileList.clear();
		return ResponseEntity.ok().build();
	}

	//
	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         수정 시 새로 업로드된 파일 추가
	 *         </p>
	 * 
	 * @param file
	 * @param request
	 * @return 공고에 저장 된 파일을 담은 리스트를 담은 ResponseEntity
	 *
	 */
	@PostMapping("/file/modify")
	public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> uploadModifyFile(
			@RequestParam("file") MultipartFile file, HttpServletRequest request) {
		try {
			RecruitmentnoticeBoardUpfiles uploadedFile = fp.saveFileToRealPath(file, request,
					"/resources/recruitmentFiles");

			if (!uploadedFile.getOriginalFileName().matches("^[a-zA-Z0-9_.-]+$")) {
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
			}

			uploadedFile.setStatus(FileStatus.NEW);
			modifyFileList.add(uploadedFile);
			System.out.println(modifyFileList);

			return ResponseEntity.ok(modifyFileList);
		} catch (IOException e) {
			logger.error("파일 업로드 실패", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
		}
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         이 컨트롤러의 필드를 전부 비워주는 메서드
	 *         </p>
	 * 
	 *
	 */
	private void ListAllClear() {
		this.advantageList.clear();
		this.applicationList.clear();
		this.fileList.clear();
		this.modifyFileList.clear();

	}

}
