package com.jobhunter.controller.recruitmentnotice;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/recruitmentnotice")
public class RecruitmentNoticeController {
	private final RecruitmentNoticeService recruitmentService;
	
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
	
	
	
	// 공고를 수정하는 페이지를 출력하는 메서드
	
	// 공고를 삭제하는 페이지를 출력하는 메서드
}
