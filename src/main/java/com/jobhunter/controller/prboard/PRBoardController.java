package com.jobhunter.controller.prboard;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.prboard.PRBoardDTO;
import com.jobhunter.service.prboard.PRBoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/prboard")
public class PRBoardController {
	private final PRBoardService prBoardService;
	
	// 글 작성 페이지
    @GetMapping("/write")
    public String showPrBoardWritePage() {
        return "prBoard/write"; // /WEB-INF/views/prBoard/write.jsp
    }

    // 목록 페이지
    @GetMapping("/list")
    public String showPrBoardListPage(PageRequestDTO pageRequestDTO, Model model) {
    	
    	
    	
        // model.addAttribute("data", ...); // 페이징 데이터 추가 가능
        return "prBoard/list"; 
    }

    // 상세 보기 페이지
    @GetMapping("/detail")
    public String showPrBoardDetailPage() {
        return "prBoard/detail"; // /WEB-INF/views/prBoard/detail.jsp
    }
    
    @PostMapping("/write")
    public String handlePrBoardWrite(@ModelAttribute PRBoardDTO prBoardDTO) {

        // TODO: 실제 저장 로직은 service.save(prBoardDTO); 형태로 연결
        System.out.println("작성자: " + prBoardDTO.getWriter());
        System.out.println("제목: " + prBoardDTO.getTitle());
        System.out.println("내용: " + prBoardDTO.getIntroduce());

        try {
			prBoardService.savePRBoard(prBoardDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        

        return "redirect:/prboard/list";
    }

}
