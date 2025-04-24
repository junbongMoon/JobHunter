package com.jobhunter.controller.submit;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmitAndUser;
import com.jobhunter.model.submit.Status;
import com.jobhunter.service.submit.SubmitService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/submit")
@RequiredArgsConstructor
public class SubmitController {

	// 제출에 대한 Service단
	private final SubmitService submitService;

	// accept.jsp(승인 페이지)로 이동
	@GetMapping("/accept")
	public void showAcceptPage() {

	}

	// 공고에 제출한 이력서의 상세정보들을 조회하는 메서드
	@GetMapping("/submitList/{recruitmentNo}")
	public ResponseEntity<PageResponseDTO<ResumeDetailInfoBySubmit>> GetAppliedForResume(
			@PathVariable("recruitmentNo") int recruitmentNo, PageRequestDTO pageRequestDTO, Model model) {
		ResponseEntity<PageResponseDTO<ResumeDetailInfoBySubmit>> result = null;

		System.out.println(pageRequestDTO);

		try {
			// 공고에 제출한 이력서의 상세정보들을 조회
			PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO = submitService.getResumeWithAll(recruitmentNo,
					pageRequestDTO);
			result = ResponseEntity.ok().body(pageResponseDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
		}

		return result;
	}

	// 제출이력의 status를 변경해주는 메서드
	@PutMapping("/status/{status}/{resumePk}/{recruitmentNoticePk}")
	public ResponseEntity<Boolean> changeStatusByRegistration(@PathVariable("status") Status status,
			@PathVariable("resumePk") int resumePk, @PathVariable("recruitmentNoticePk") int recruitmentNoticePk) {

		System.out.println(
				"status : " + status + ", resumePk :" + resumePk + ", recruitmentNoticePk" + recruitmentNoticePk);
		ResponseEntity<Boolean> result = null;

		submitService.changeStatus(status, resumePk, recruitmentNoticePk);

		result = ResponseEntity.ok().body(true);

		return result;
	}

	// 해당 공고에 제출된 모든 제출이력의 상태 중 WAITING인 것을 EXPIRED를 변경해주는 메서드
	@PutMapping("/expire/{uid}")
	public ResponseEntity<Boolean> expiredEntireWatingRegByRecUid(@PathVariable("uid") int uid) {
		ResponseEntity<Boolean> result = null;

		try {
			submitService.expiredEntireWatingRegByRecUid(uid);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}

	// 신청서 상세조회 페이지로 이동
	@GetMapping("/detail/{registrationNo}")
	public String showAcceptDetail(@PathVariable("registrationNo") int registrationNo, HttpSession session,
			Model model) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		// 신청서 대상 기업 혹은 admin만 열람 가능

		// ResumeDetailInfoBySubmit 가져와야함
		ResumeDetailInfoBySubmitAndUser result = null;
		// TODO 들어가면 읽음처리하고 페이지 내에서 상태변경도 필요...
		try {
			result = submitService.selectSubmitAndResumeDetailInfo(registrationNo, account);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		model.addAttribute("submit", result);

		return "/submit/detail";
	}

}
