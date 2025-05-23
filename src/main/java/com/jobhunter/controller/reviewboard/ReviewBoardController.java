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
import org.springframework.web.bind.annotation.ResponseBody;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.reviewboard.Likes;
import com.jobhunter.model.reviewboard.MessageCallDTO;
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
			List<String> companyList = service.getCompanyList();
			model.addAttribute("companyList", companyList);
			model.addAttribute("pageResult", response);
			System.out.println("companyFilter: " + pageRequestDTO.getCompanyFilter());
			System.out.println("resultFilter: " + pageRequestDTO.getResultFilter());
			System.out.println("DTO: " + pageRequestDTO); //

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "reviewBoard/allBoard";
	}

	// 공고글 게시물을 조회
	@GetMapping("/write")
	public String reviewBoardWrite(HttpSession session, Model model, HttpServletRequest req) {
		AccountVO account = (AccountVO) session.getAttribute("account");

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
		AccountVO account = (AccountVO) session.getAttribute("account");
		boolean isCompanyAccount = false; // ⭐ 회사계정 여부 기본 false
		logger.info("account: {}", account);

		try {
			ReviewDetailViewDTO detail = service.getReviewDetail(boardNo);
			if (detail == null) {
				logger.warn("조회 결과 없음!");
				model.addAttribute("errorMessage", "해당 게시글이 존재하지 않습니다.");
			} else {
				logger.info("조회 성공: {}", detail);
				if (detail.getLikes() == null) {
					detail.setLikes(0);
				}
			}

			boolean isLiked = false;

			if (account != null) {
				int userId = account.getUid();
				service.insertViews(userId, boardNo, "REBOARD"); // 조회수 추가
				isLiked = service.hasUserLiked(userId, boardNo);

				if (account.getAccountType() == AccountType.COMPANY) {
					isCompanyAccount = true;
				}
			}

			model.addAttribute("detail", detail);
			model.addAttribute("pageRequestDTO", pageRequestDTO);
			model.addAttribute("isLiked", isLiked);
			model.addAttribute("isCompanyAccount", isCompanyAccount);

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("상세페이지 처리 중 오류", e);
		}

		return "reviewBoard/detail"; // JSP로 이동
	}

	@PostMapping(value = "/like", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public ResponseEntity<MessageCallDTO> addLike(@RequestBody Likes likes, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");

		// 로그인 체크
		if (account == null || account.getUid() == 0) {
			return ResponseEntity.status(401).body(new MessageCallDTO("로그인이 필요합니다.", false));
		}

		// 회사 계정 체크
		if (account.getAccountType() == AccountType.COMPANY) {
			return ResponseEntity.status(403).body(new MessageCallDTO("회사 계정은 좋아요를 등록할 수 없습니다.", false));
		}

		// 세션에서 userId 주입
		likes.setUserId(account.getUid());
		likes.setLikeType("REBOARD"); // 여기서 LikeType도 서버에서 확실히 세팅하는게 좋아.

		try {
			boolean alreadyLiked = service.hasUserLiked(likes.getUserId(), likes.getBoardNo());
			if (alreadyLiked) {
				return ResponseEntity.badRequest().body(new MessageCallDTO("이미 좋아요를 누르셨습니다.", false));
			}

			// 고친 부분: Likes 객체 통으로 넘긴다
			service.addlikes(likes);

			return ResponseEntity.ok(new MessageCallDTO("좋아요가 등록되었습니다.", true));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body(new MessageCallDTO("서버 오류 발생", false));
		}
	}

	@PostMapping(value = "/unlike", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public ResponseEntity<MessageCallDTO> cancelLike(@RequestBody Likes likes, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");

		// 1. 로그인 체크
		if (account == null || account.getUid() == 0) {
			return ResponseEntity.status(401).body(new MessageCallDTO("로그인이 필요합니다.", false));
		}

		// 2. 회사 계정 체크
		if (account.getAccountType() == AccountType.COMPANY) {
			return ResponseEntity.status(403).body(new MessageCallDTO("회사 계정은 좋아요를 취소할 수 없습니다.", false));
		}

		// 3. 세션에서 userId 세팅
		likes.setUserId(account.getUid());

		try {
			boolean success = service.removeLike(likes); // ✨ 수정! userId, boardNo 담긴 Likes 객체 통으로 넘긴다

			if (success) {
				return ResponseEntity.ok(new MessageCallDTO("좋아요가 취소되었습니다.", true));
			} else {
				return ResponseEntity.status(400).body(new MessageCallDTO("좋아요 취소가 실패했습니다.", false));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(500).body(new MessageCallDTO("서버 오류 발생", false));
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
			if (writeBoardDTO.getWriter() != userUid) {
				throw new SecurityException("본인의 게시글만 수정할 수 있습니다.");
			}
			model.addAttribute("writeBoardDTO", writeBoardDTO);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return "reviewBoard/modify";
	}

	@PostMapping("/modify")
	public String updateReview(@ModelAttribute WriteBoardDTO modify, HttpSession session) {
		String returnPage;

		AccountVO account = (AccountVO) session.getAttribute("account");

		// 1. 로그인 체크
		if (account == null) {
			return "redirect:/member/login"; // 로그인 안 했으면 로그인 페이지로
		}

		// 2. 회사 계정 차단
		if (account.getAccountType() == AccountType.COMPANY) {
			return "redirect:/reviewBoard/detail?boardNo=" + modify.getBoardNo() + "&status=forbidden";
		}

		try {
			// 3. 작성자 본인 확인
			WriteBoardDTO original = service.getReviewBoardUpdate(modify.getBoardNo());
			if (original == null || original.getWriter() != account.getUid()) {
				return "redirect:/reviewBoard/detail?boardNo=" + modify.getBoardNo() + "&status=forbidden";
			}

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

	@PostMapping("/delete")
	@ResponseBody
	public ResponseEntity<MessageCallDTO> deleteBoardNo(@RequestParam("boardNo") int boardNo, HttpSession session) {
		try {
			AccountVO account = (AccountVO) session.getAttribute("account");

			// 1. 로그인 체크
			if (account == null) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
						.body(MessageCallDTO.builder().message("로그인이 필요합니다.").success(false).build());
			}

			// 2. 회사 계정 차단
			if (account.getAccountType() == AccountType.COMPANY) {
				return ResponseEntity.status(HttpStatus.FORBIDDEN)
						.body(MessageCallDTO.builder().message("회사 계정은 게시글을 삭제할 수 없습니다.").success(false).build());
			}

			int userUid = account.getUid();

			// 3. 작성자 본인 확인
			WriteBoardDTO writeBoardDTO = service.getReviewBoardUpdate(boardNo);
			if (writeBoardDTO == null || writeBoardDTO.getWriter() != userUid) {
				return ResponseEntity.status(HttpStatus.FORBIDDEN)
						.body(MessageCallDTO.builder().message("본인의 게시글만 삭제할 수 있습니다.").success(false).build());
			}

			// 4. 삭제 수행
			service.deleteBoard(boardNo);
			return ResponseEntity.ok(MessageCallDTO.builder().message("게시글이 삭제되었습니다.").success(true).build());

		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body(MessageCallDTO.builder().message("삭제 중 서버 오류 발생").success(false).build());
		}
	}

	@GetMapping("/viewCount")
	@ResponseBody
	public ResponseEntity<MessageCallDTO> getViewCount(@RequestParam("boardNo") int boardNo, HttpSession session) {
		try {
			AccountVO account = (AccountVO) session.getAttribute("account");

			if (account == null) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
						.body(MessageCallDTO.builder().message("로그인이 필요합니다.").success(false).build());
			}

			int userId = account.getUid();
			service.insertViews(userId, boardNo, "REBOARD"); // 조회수 기록 (24시간 제한 포함)

			ReviewDetailViewDTO detail = service.getReviewDetail(boardNo);
			if (detail == null) {
				return ResponseEntity.status(HttpStatus.NOT_FOUND)
						.body(MessageCallDTO.builder().message("해당 게시글을 찾을 수 없습니다.").success(false).build());
			}

			int views = detail.getViews();

			return ResponseEntity.ok(MessageCallDTO.builder().message(String.valueOf(views)).success(true).build());

		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body(MessageCallDTO.builder().message("조회수 처리 중 오류").success(false).build());
		}
	}

}
