package com.jobhunter.controller.reviewboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.service.reviewboard.ReviewBoardService;

import lombok.RequiredArgsConstructor;
@Controller
@RequestMapping("/reviewBoard")
@RequiredArgsConstructor
public class ReviewBoardController {

	private final ReviewBoardService service;

	private static Logger logger = LoggerFactory.getLogger(ReviewBoardController.class);

	@GetMapping("/allBoard")
	public String listBoard (Model model) {
		


		String resultPage = "reviewBoard/allBoard";
		//String 타입으 뷰로 반환할 경로 지정   
		List<ReviewBoardDTO> blist = null; // 초기값세팅   
			try {
				blist = service.selectReBoard();
			System.out.println(blist);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			model.addAttribute("board",blist);
		
			// TODO Auto-generated catch block
			
		
		return resultPage; 
	
	};

	
	@GetMapping("/write")
	public String reviewBoardWrite() {
		return "reviewBoard/write";
	}

	@PostMapping("/write") 
    public String saveReviewBoard(@ModelAttribute ReviewBoardDTO newReview) {
        logger.info("리뷰 게시글 저장 시도: " + newReview.toString());
        	
        String returnPage = "redirect:./allBoard"; // 기본 리디렉션 경로
        
        
        try {
            if (service.saveReview(newReview)) {
                returnPage += "?status=success";
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnPage += "?status=fail";
        }

        return returnPage;
    }
	
	@GetMapping("/detail")
	public String showReviewDetail(@RequestParam("boardNo") int boardNo, Model model) {
       
		
		try {
			 ReviewDetailViewDTO detail = service.getReviewDetail(boardNo);
			 model.addAttribute("detail", detail);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return "reviewBoard/detail"; 
		
	
}
}
