package com.jobhunter.controller.recruitmentnotice;

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
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.Application;
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
	private List<RecruitmentnoticeBoardUpfiles> fileList = new ArrayList<>();
	// 게시글 수정시 업로한 파일 객체들을 임시로 저장
	private List<RecruitmentnoticeBoardUpfiles> modifyFileList = new ArrayList<>();
	private final RecruitmentFileProcess fp;

	// 회사가 공고를 등록하는 메서드
	@PostMapping("/save")
	public String saveRecruitment(@ModelAttribute RecruitmentNoticeDTO dto) {
		boolean result = false;
		

		System.out.println("DTO 확인: " + dto);

		

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
	public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> uploadFile(
	        @RequestParam("file") MultipartFile file,
	        HttpServletRequest request) {
	    try {
	        RecruitmentnoticeBoardUpfiles uploadedFile = fp.saveFileToRealPath(
	                file, request, "/resources/recruitmentFiles");

	        // 유효한 확장자 검사 (보안 강화)
	        if (!uploadedFile.getOriginalFileName().matches("^[a-zA-Z0-9_.-]+$")) {
	            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
	        }

	        uploadedFile.setStatus(FileStatus.NEW);
	        fileList.add(uploadedFile);

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

	    // 보안: 파일명 정규식 검사 (파일 경로 침입 방지)
	    if (!removeFileName.matches("^[a-zA-Z0-9_.-]+$")) {
	        return ResponseEntity.badRequest().body(fileList);
	    }

	    fileList.removeIf(file -> {
	        boolean match = file.getOriginalFileName().equals(removeFileName);
	        if (match) {
	            fp.removeFile(file);
	        }
	        return match;
	    });

	    return ResponseEntity.ok(fileList);
	}
	
	// 전체 파일 리스트 초기화 메서드
	@DeleteMapping("/removeAllFiles")
	public ResponseEntity<Void> removeAllFiles() {
	    for (RecruitmentnoticeBoardUpfiles f : fileList) {
	        fp.removeFile(f);
	    }
	    fileList.clear();
	    return ResponseEntity.ok().build();
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
		ListAllClear();

	}

	// 공고 상세 페이지, 수정 페이지를 출력
	@GetMapping(value = {"/detail", "/modify"})
	public String showRecruitment(@RequestParam("uid") int uid, Model model, HttpServletRequest req) {
		System.out.println(uid);
		
		String returnPage ="";
		
		// 기존 리스트 초기화
					ListAllClear();
		
		try {
			RecruitmentDetailInfo detailInfo = recruitmentService.getRecruitmentByUid(uid);
			
			
			
			// 우대 조건
			if(detailInfo.getAdvantage().size() > 0) {
				for(Advantage advantage : detailInfo.getAdvantage()) {
					AdvantageDTO advdto = AdvantageDTO.builder()
							.advantageType(advantage.getAdvantageType()).build();
							this.advantageList.add(advdto);
				}
			}
			
			// 파일 리스트
			if(detailInfo.getFileList().size() > 0) {
				this.fileList = detailInfo.getFileList();
				this.modifyFileList = detailInfo.getFileList();
				System.out.println(modifyFileList);
			}
			
			// 면접 방식
			for(Application application : detailInfo.getApplication()) {
				ApplicationDTO appdto = ApplicationDTO.builder()
						.method(application.getMethod())
						.detail(application.getDetail())
						.build();
				
				this.applicationList.add(appdto);
				
				
				
			}
			
			String applicationsJson = new ObjectMapper().writeValueAsString(this.applicationList);
			model.addAttribute("applicationsJson", applicationsJson);
			model.addAttribute("RecruitmentDetailInfo", detailInfo);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			returnPage = "redirect:./listAll?status=fail";

		}
		
		
		if(req.getRequestURI().contains("detail")){
			returnPage = "recruitmentnotice/detail";
		}else if(req.getRequestURI().contains("modify")) {
			returnPage = "recruitmentnotice/modify";
		}
		
		if (returnPage.equals("")) {
		    returnPage = "redirect:/recruitmentnotice/listAll?status=fail";
		}

		return returnPage;
	}
	
	
	// 공고를 수정하는 메서드 
	@PostMapping("/modify")
	public String modifyRecruitment(
	        @ModelAttribute RecruitmentNoticeDTO dto,
	        @RequestParam("applicationJson") String applicationJson,
	        @RequestParam("advantageJson") String advantageJson, @RequestParam("uid") int uid) {
		dto.setUid(uid);
	    boolean result = false;

	    System.out.println("수정할 DTO: " + dto);

	    try {
	        ObjectMapper objectMapper = new ObjectMapper();

	        List<ApplicationDTO> applications = objectMapper.readValue(applicationJson, new TypeReference<List<ApplicationDTO>>() {});
	        List<AdvantageDTO> advantages = objectMapper.readValue(advantageJson, new TypeReference<List<AdvantageDTO>>() {});

	        if (dto.getDueDateForString() != null && !dto.getDueDateForString().isEmpty()) {
	            LocalDate date = LocalDate.parse(dto.getDueDateForString());
	            dto.setDueDate(Timestamp.valueOf(date.atStartOfDay()));
	        }

	        // 기존 데이터 불러오기
	        RecruitmentDetailInfo existing = recruitmentService.getRecruitmentByUid(uid);

	        // 서비스로 수정 로직 위임
	        recruitmentService.modifyRecruitmentNotice(dto, advantages, applications, modifyFileList, existing, uid);

	        result = true;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    ListAllClear(); // 리스트 초기화

	    return result
	            ? "redirect:/recruitmentnotice/listAll"
	            : "redirect:/recruitmentnotice/modify?uid=" + uid + "&status=fail";
	}


	// 공고를 삭제하는 메서드
	@DeleteMapping("/remove/{uid}")
	public ResponseEntity<Boolean> removeRecruitment(@PathVariable("uid") int uid) {
		ResponseEntity<Boolean> result = null;
		
		try {
			if(recruitmentService.removeRecruitmentByUid(uid)) {			
				result = ResponseEntity.ok().body(true);
			}else {
				result = ResponseEntity.badRequest().body(false);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    return result; 
	}
	
    // 파일 상태 업데이트
    @PostMapping("/file/status")
    public ResponseEntity<Void> updateFileStatus(
            @RequestParam("fileName") String fileName,
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

    // 수정 취소 시 파일 상태 롤백 및 삭제
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

    // 파일 수정 최종 반영
    @PostMapping("/file/finalize")
    public ResponseEntity<Void> finalizeFileModifications() {
        for (RecruitmentnoticeBoardUpfiles file : modifyFileList) {
            if (file.getStatus() == FileStatus.DELETE) {
                fp.removeFile(file); // 실제 파일 삭제
                recruitmentService.deleteFileFromDatabase(file.getBoardUpFileNo()); // DB에서 삭제
            }
        }
        modifyFileList.clear();
        return ResponseEntity.ok().build();
    }

    // 수정 시 새로 업로드된 파일 추가
    @PostMapping("/file/modify")
    public ResponseEntity<List<RecruitmentnoticeBoardUpfiles>> uploadModifyFile(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {
        try {
            RecruitmentnoticeBoardUpfiles uploadedFile = fp.saveFileToRealPath(
                    file, request, "/resources/recruitmentFiles");

            if (!uploadedFile.getOriginalFileName().matches("^[a-zA-Z0-9_.-]+$")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
            }

            uploadedFile.setStatus(FileStatus.NEW);
            modifyFileList.add(uploadedFile);

            return ResponseEntity.ok(modifyFileList);
        } catch (IOException e) {
            logger.error("파일 업로드 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
	

	// 리스트, 필드를 전부 비워주는 메서드 (다 하고 맨 밑으로 내리자)
	private void ListAllClear() {
		this.advantageList.clear();
		this.applicationList.clear();
		this.fileList.clear();
		this.modifyFileList.clear();

	}

}
