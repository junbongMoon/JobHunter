package com.jobhunter.controller.recruitmentnotice;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

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
	private String regionCode;
	private String sigunguCode;
	private String majorCategoryCode;
	private String subCategoryCode;
	// 게시글 작성시 업로드한 파일객체들을 임시로 저장
	private List<RecruitmentnoticeBoardUpfiles> fileList = new ArrayList<RecruitmentnoticeBoardUpfiles>();
	// 게시글 수정시 업로한 파일 객체들을 임시로 저장
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
			if (recruitmentService.saveRecruitmentNotice(recruitmentNoticeDTO, advantageList, applicationList,
					regionCode, sigunguCode, fileList, majorCategoryCode, subCategoryCode)) {
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
		this.regionCode = null;
		this.sigunguCode = null;
		this.majorCategoryCode = null;
		this.subCategoryCode = null;

	}
}
