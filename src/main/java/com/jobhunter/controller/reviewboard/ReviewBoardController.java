package com.jobhunter.controller.reviewboard;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewboard.Likes;
import com.jobhunter.model.reviewboard.MassageCallDTO;
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
//	    if (account == null) {
//	        return "redirect:/account/login?returnUrl=/reviewBoard/write";
//	    }

	    int userUid = account.getUid();
	    try {
	        List<RecruitmentnoticContentDTO> gonggoList = service.selectgoggo(userUid, GetClientIPAddr.getClientIp(req));
	        model.addAttribute("gonggoList", gonggoList);
	        model.addAttribute("userUid", userUid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return "reviewBoard/write";
	}


	// 게시물 작성 저장
	@PostMapping("/write")
	public String saveReviewBoard(@ModelAttribute WriteBoardDTO writeBoardDTO, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
	
		writeBoardDTO.setWriter(account.getUid());
		try {
			if (service.saveReview(writeBoardDTO)) {
				return "redirect:/reviewBoard/detail?boardNo=" + writeBoardDTO.getBoardNo();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/reviewBoard/allBoard?status=fail";
	}

	@GetMapping("/detail")
	public String showReviewDetail(@RequestParam("boardNo") int boardNo, Model model,
			@ModelAttribute("reviewTypeOtherText") String otherText) {
		logger.info("상세조회 요청 boardNo: " + boardNo);

		try {
			ReviewDetailViewDTO detail = service.getReviewDetail(boardNo);
			if (detail == null) {
				logger.warn("조회 결과 없음!");
			} else {
				logger.info("조회 성공: " + detail.toString());
			}

			model.addAttribute("detail", detail);
			if (otherText != null) {
				model.addAttribute("reviewTypeOtherText", otherText);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "reviewBoard/detail";
	}

	@PostMapping(value = "/like", produces = "text/plain;charset=UTF-8")
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

	@PostMapping(value = "/unlike", produces = "text/plain;charset=UTF-8")
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

	@GetMapping("/modify")
	public String showModify(@RequestParam("boardNo") int boardNo, Model model, HttpSession session,
			HttpServletRequest req) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account == null) {
			throw new IllegalStateException("세션에 사용자 정보가 없습니다.");
		}
		int userUid = account.getUid();

		try {

			List<RecruitmentnoticContentDTO> gonggoList = service.selectgoggo(userUid,
					GetClientIPAddr.getClientIp(req));
			model.addAttribute("gonggoList", gonggoList);

			WriteBoardDTO writeBoardDTO = service.getReviewBoardUpdate(boardNo);
			model.addAttribute("writeBoardDTO", writeBoardDTO);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "reviewBoard/modify";
	}

	@PostMapping("/modify")
	public String updateReview(@ModelAttribute WriteBoardDTO modify) {
	    String returnPage;

	    try {
	        boolean result = service.updateReviewBoard(modify);

	        if (result) {
	            returnPage = "redirect:/reviewBoard/detail?boardNo=" + modify.getBoardNo();
	        } else {
	            returnPage = "redirect:/reviewBoard/modify?boardNo=" + modify.getBoardNo() + "&status=fail";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        returnPage = "redirect:/reviewBoard/modify?boardNo=" + modify.getBoardNo() + "&status=error";
	    }
	    return returnPage;
	}


}
