package com.jobhunter.controller.recruitmentnotice;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/recruitmentnotice")
public class RecruitmentNoticeController {
	private final RecruitmentNoticeService recruitmentService;
	
	// 전체 공고 리스트를 출력하는 메서드  
	@GetMapping("/listAll")
	public void showRecruitmentList(PageRequestDTO pageRequestDTO, Model model) {
		try {
			// 공고 전체를 조회하는 메서드
			recruitmentService.getEntireRecruitment(pageRequestDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	// 지역별 공고 리스트를 출력하는 메서드
	
	// 직종별 공고 리스트를 출력하는 메서드
	
	// 공고를 작성하는 페이지를 출력하는 메서드
	@GetMapping("/write")
	public void showRecruitmentWithWrite() {
		
	}
	
	
	
	// 공고를 수정하는 페이지를 출력하는 메서드
	
	// 공고를 삭제하는 페이지를 출력하는 메서드
}
