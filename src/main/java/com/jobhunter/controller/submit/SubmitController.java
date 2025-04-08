package com.jobhunter.controller.submit;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeDetailDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.Status;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;
import com.jobhunter.service.resume.ResumeService;
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
	public ResponseEntity<PageResponseDTO<ResumeDetailInfoBySubmit>> GetAppliedForResume(@PathVariable("recruitmentNo") int recruitmentNo,
			PageRequestDTO pageRequestDTO, Model model){
		ResponseEntity<PageResponseDTO<ResumeDetailInfoBySubmit>> result = null;
		
		System.out.println(pageRequestDTO);
		
		try {
			// 공고에 제출한 이력서의 상세정보들을 조회
			PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO = submitService.getResumeWithAll(recruitmentNo, pageRequestDTO);
			result = ResponseEntity.ok().body(pageResponseDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
		}
		
		return result;
	}
	
	// 제출이력의 status를 변경해주는 메서드
	@PutMapping("/status/{status}/{registrationNo}/{recruitmentNoticePk}")
	public ResponseEntity<Boolean> changeStatusByRegistration(@PathVariable("status") Status status, @PathVariable("resumePk") int resumePk,
			@PathVariable("recruitmentNoticePk") int recruitmentNoticePk) {
		ResponseEntity<Boolean> result = null;
		
		submitService.changeStatus(status, resumePk, recruitmentNoticePk);
		
		result = ResponseEntity.ok().body(true);
		
		return result;
	}
	
	// 합격 여부
	@PutMapping("/passed")
	public String PassedByRegistration() {
		
		
		
	// 승인 페이지로 다시 되돌아가게 하자.
		return null;
	}
	
	
	
	
}
