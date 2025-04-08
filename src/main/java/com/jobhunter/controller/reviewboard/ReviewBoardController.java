package com.jobhunter.controller.reviewboard;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewboard.Likes;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;
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
		model.addAttribute("blist", blist);

		// TODO Auto-generated catch block

		return resultPage;

	}

	// 공고글 게시물을 조회
	@GetMapping("/write")
	public String reviewBoardWrite(HttpSession session, Model model, HttpServletRequest req) {

		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account == null || account.getUid() == 0) {
			return "redirect:/account/login";
		}

		int userUid = account.getUid();
		System.out.println(userUid);

		try {
			List<RecruitmentnoticContentDTO> gonggoList = service.selectgoggo(userUid,
					GetClientIPAddr.getClientIp(req));
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
	public String saveReviewBoard(@ModelAttribute WriteBoardDTO writeBoardDTO,
			@RequestParam(value = "reviewTypeOtherText", required = false) String otherText, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");

		if (account == null || account.getUid() == 0) {
			return "redirect:/account/login";
		}
		writeBoardDTO.setWriter(account.getUid());
		if ("OTHER".equals(writeBoardDTO.getReviewType())) {

			writeBoardDTO.setReviewType("OTHER");

			// 만약 content에 추가할
			if (otherText != null && !otherText.trim().isEmpty()) {
				writeBoardDTO.setContent("[기타 면접유형: " + otherText + "]\n" + writeBoardDTO.getContent());
			}
		}

		// logger.info("리뷰 게시글 저장 시도: " + writeBoardDTO.toString());
		String returnPage = "redirect:./allBoard";

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

	@PostMapping(value = "/like", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> addLike(@RequestBody Likes likes, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");

		if (account == null || account.getUid() == 0) {
			return ResponseEntity.status(401).body("로그인이 필요합니다.");
		}

		try {
			service.addlikes(likes.getUserId(), likes.getBoardNo());
			return ResponseEntity.ok("좋아요가 등록되었습니다.");
		} catch (IllegalArgumentException e) {
			// 여기에서 명확하게 메시지 설정
			return ResponseEntity.badRequest().body("이미 좋아요를 누르셨습니다. 24시간 후 다시 가능합니다.");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body("서버 오류 발생");
		}
	}
	
	@PostMapping(value ="/unlike", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> cancelLike(@RequestBody Likes likes, HttpSession session) {
	    AccountVO account = (AccountVO) session.getAttribute("account");

	    if (account == null || account.getUid() == 0) {
	        return ResponseEntity.status(401).body("로그인이 필요합니다.");
	    }

	    try {
	        boolean success = service.removeLike(likes.getUserId(), likes.getBoardNo());
	        if (success) {
	            return ResponseEntity.ok("좋아요가 취소되었습니다.");
	        } else {
	            return ResponseEntity.status(400).body("더이상 취소를 할 수 없습니다");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(500).body("서버 오류 발생");
	    }
	}

}
