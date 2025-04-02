package com.jobhunter.controller.recruitmentnotice;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/recruitmentnotice")
public class RecruitmentNoticeController {
	private final RecruitmentNoticeService recruitmentService;
	
	// 양식을 저장 할 List, 코드들
		private final List<AdvantageDTO> advantageList = new ArrayList<>();
		private final List<ApplicationDTO> applicationList = new ArrayList<>();
		private String regionCode;
		private String sigunguCode;
		private String majorCategoryCode;
		private String subCategoryCode;
		// 게시글 작성시 업로드한 파일객체들을 임시로 저장
		private List<RecruitmentnoticeBoardUpfiles> fileList = new ArrayList<RecruitmentnoticeBoardUpfiles>();
		// 게시글 수정시 업로한 파일 객체들을 임식로 저장
		private List<RecruitmentnoticeBoardUpfiles> modifyFileList;
	
	// 공고를 저장하는 메서드
	
	
	
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
}
