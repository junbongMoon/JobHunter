package com.jobhunter.controller.reviewboard;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;
import com.jobhunter.model.user.UserAllVO;
import com.jobhunter.service.reviewboard.ReviewBoardService;
import com.jobhunter.util.GetClientIPAddr;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/reviewBoard")
@RequiredArgsConstructor
public class ReviewBoardController {

	private final ReviewBoardService service;

	private static Logger logger = LoggerFactory.getLogger(ReviewBoardController.class);

	@GetMapping("/allBoard")
	public String listBoard(Model model) {

		String resultPage = "reviewBoard/allBoard";
		// String 타입으 뷰로 반환할 경로 지정
		List<ReviewBoardDTO> blist = null; // 초기값세팅
		try {
			blist = service.selectReBoard();
			System.out.println(blist);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		model.addAttribute("board", blist);

		// TODO Auto-generated catch block

		return resultPage;

	};
		// 공고글 게시물을 조회 
	@GetMapping("/write")
	public String reviewBoardWrite(HttpSession session, Model model, HttpServletRequest req) {

	    AccountVO account = (AccountVO) session.getAttribute("account");
	    if (account == null) {
	        return "redirect:/account/login";
	    }

	    int userUid = account.getUid(); 

	    try {
	        List<RecruitmentnoticContentDTO> gonggoList = service.selectgoggo(userUid, GetClientIPAddr.getClientIp(req));
	        model.addAttribute("gonggoList", gonggoList);
	        model.addAttribute("userUid", userUid);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/account/login";
	    }

	    return "reviewBoard/write";
	}
		// 게시물 작성 저장 
	@PostMapping("/write")
	public String saveReviewBoard(@ModelAttribute WriteBoardDTO writeBoardDTO, HttpSession session) {
	    AccountVO account = (AccountVO) session.getAttribute("account");
	    if (account == null) {
	        return "redirect:/account/login";
	    }

	    writeBoardDTO.setWriter(account.getUid());

	    //logger.info("리뷰 게시글 저장 시도: " + writeBoardDTO.toString());
	    String returnPage = "redirect:./allBoard";
	    //logger.info("writeBoardDTO.toString());
	    //logger.info("reviewResult 넘어온 값 = {}", writeBoardDTO.getReviewResult());

	    try {
	        if (service.saveReview(writeBoardDTO)) {
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
