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
import com.jobhunter.model.reviewboard.RPageRequestDTO;
import com.jobhunter.model.reviewboard.RPageResponseDTO;
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
	public String listBoard(@ModelAttribute RPageRequestDTO pageRequestDTO, Model model) {

		System.out.println("검색 타입: " + pageRequestDTO.getSearchType());
		System.out.println("검색어: " + pageRequestDTO.getKeyword());

		try {

			RPageResponseDTO<ReviewBoardDTO> response = service.getPagedBoardList(pageRequestDTO);
			model.addAttribute("pageResult", response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "reviewBoard/allBoard";
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
			List<RecruitmentnoticContentDTO> gonggoList = service.selectgoggo(userUid,
					GetClientIPAddr.getClientIp(req));
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
		logger.info("기타 텍스트: {}", writeBoardDTO.getTypeOtherText());
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
	public String showReviewDetail(@RequestParam("boardNo") int boardNo, @ModelAttribute RPageRequestDTO pageRequestDTO,
			Model model, HttpSession session, HttpServletRequest request) {
		logger.info("상세조회 요청 boardNo: {}", boardNo);

		try {
			AccountVO account = (AccountVO) session.getAttribute("account");

			
				
			ReviewDetailViewDTO detail = service.getReviewDetail(boardNo);
			System.out.println("조회가 없네요:  "+detail);

			if (detail == null) {
				logger.warn("조회 결과 없음!");
				model.addAttribute("errorMessage", "해당 게시글이 존재하지 않습니다.");
			} else {
				logger.info("조회 성공: {}", detail);
			}
			  
			if (account != null) {
				int userId = account.getUid();
				service.insertViews(userId, boardNo, "REBOARD");
				
			}
			
			model.addAttribute("detail", detail);
			model.addAttribute("pageRequestDTO", pageRequestDTO);

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("상세페이지 처리 중 오류", e);
		}

		return "reviewBoard/detail";
	}

	@PostMapping(value = "/like", produces = "application/json;charset=UTF-8")
	public ResponseEntity<MassageCallDTO> addLike(@RequestBody Likes likes, HttpSession session, Model model) {
		AccountVO account = (AccountVO) session.getAttribute("account");

		if (account == null || account.getUid() == 0) {
			return ResponseEntity.status(401)
				.body(new MassageCallDTO("로그인이 필요합니다.", false));
		}

		try {
			boolean liked = service.addlikes(likes.getUserId(), likes.getBoardNo());
			model.addAttribute("isLiked", liked);
			return ResponseEntity.ok(new MassageCallDTO("좋아요가 등록되었습니다.", true));
		} catch (IllegalArgumentException e) {
			return ResponseEntity.badRequest()
				.body(new MassageCallDTO("이미 좋아요를 누르셨습니다. 24시간 후 다시 가능합니다.", false));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body(new MassageCallDTO("서버 오류 발생", false));
		}
	}


	@PostMapping(value = "/unlike", produces = "application/json;charset=UTF-8")
	public ResponseEntity<MassageCallDTO> cancelLike(@RequestBody Likes likes, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");

		if (account == null || account.getUid() == 0) {
			return ResponseEntity.status(401)
				.body(new MassageCallDTO("로그인이 필요합니다.", false));
		}

		try {
			boolean success = service.removeLike(likes.getUserId(), likes.getBoardNo());
			if (success) {
				return ResponseEntity.ok(new MassageCallDTO("좋아요가 취소되었습니다.", true));
			} else {
				return ResponseEntity.status(400)
					.body(new MassageCallDTO("더이상 취소를 할 수 없습니다.", false));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body(new MassageCallDTO("서버 오류 발생", false));
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

	@PostMapping(value = "/delete", produces = "application/json")
	public ResponseEntity<MassageCallDTO> deleteBoardNo(@RequestParam("boardNo") int boardNo) {
	    try {
	        service.deleteBoard(boardNo);
	        return ResponseEntity.ok(
	            MassageCallDTO.builder()
	                .message("게시글이 삭제되었습니다.")
	                .success(true)
	                .build()
	        );
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	            .body(MassageCallDTO.builder()
	                .message("삭제 중 오류 발생")
	                .success(false)
	                .build());
	    }
	}

	@GetMapping("/viewCount")
	public ResponseEntity<MassageCallDTO> getViewCount(@RequestParam("boardNo") int boardNo, HttpSession session) {
		try {
			AccountVO account = (AccountVO) session.getAttribute("account");

			if (account == null) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
						.body(MassageCallDTO.builder().message("로그인이 필요합니다.").success(false).build());
			}

			int userId = account.getUid();
			service.insertViews(userId, boardNo,"REBOARD"); // 24시간 제한 로직 포함
			int views = service.getReviewDetail(boardNo).getViews();

			return ResponseEntity.ok(MassageCallDTO.builder().message(String.valueOf(views)).success(true).build());

		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body(MassageCallDTO.builder().message("조회수 처리 중 오류").success(false).build());
		}
	}

}
