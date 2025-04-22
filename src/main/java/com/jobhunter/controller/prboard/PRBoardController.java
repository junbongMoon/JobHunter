package com.jobhunter.controller.prboard;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.prboard.PRBoardDTO;
import com.jobhunter.model.prboard.PRBoardVO;
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
    	PageResponseDTO<PRBoardVO> result;
    	try {
			result = prBoardService.getprBoardByPagination(pageRequestDTO);
			model.addAttribute("pageResponseDTO", result);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	
        // model.addAttribute("data", ...); // 페이징 데이터 추가 가능
        return "prBoard/list"; 
    }

    @GetMapping("/detail")
    public String showPrBoardDetailPage(@RequestParam("prBoardNo") int prBoardNo, Model model) {
        try {
            PRBoardVO boardDetail = prBoardService.getPRBoardDetail(prBoardNo);
            model.addAttribute("prBoard", boardDetail);
        } catch (Exception e) {
            e.printStackTrace();
            // 에러 페이지로 리다이렉트하거나 예외처리
            return "prBoard/list";
        }

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
    
 // --- Controller ---
    @GetMapping("/modify")
    public String showModifyPage(@RequestParam("prBoardNo") int prBoardNo, Model model) {
        try {
            PRBoardVO board = prBoardService.getPRBoardDetail(prBoardNo);
            model.addAttribute("prBoard", board);
            return "prBoard/modify";
        } catch (Exception e) {
            e.printStackTrace();
            return "prBoard/list";
        }
    }

    @PostMapping("/modify")
    public String handleModify(@ModelAttribute PRBoardDTO prBoardDTO) {
    	int boardNo = prBoardDTO.getPrBoardNo();
    	System.out.println(boardNo);
        try {
            prBoardService.updatePRBoard(prBoardDTO);
            
        } catch (Exception e) {
            e.printStackTrace();
            return "error/500";
        }
        return "redirect:/prboard/detail?prBoardNo=" + prBoardDTO.getPrBoardNo();
    }

    @GetMapping("/remove")
    public String handleRemove(@RequestParam("prBoardNo") int prBoardNo) {
        try {
            prBoardService.deletePRBoard(prBoardNo);
        } catch (Exception e) {
            e.printStackTrace();
            return "error/500";
        }
        return "redirect:/prboard/list";
    }

}
