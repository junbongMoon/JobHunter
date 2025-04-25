package com.jobhunter.controller.reviewReply;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewReply.ReviewReplyDTO;
import com.jobhunter.model.reviewboard.RPageRequestDTO;
import com.jobhunter.model.reviewboard.RPageResponseDTO;
import com.jobhunter.service.reviewReply.ReviewReplyService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/reply")
@RequiredArgsConstructor
public class ReviewReplyRestController {

	private final ReviewReplyService service;

	// 댓글 목록
	@GetMapping("/page")
	public ResponseEntity<RPageResponseDTO<ReviewReplyDTO>> getReplyPage(@RequestParam int boardNo,
			@ModelAttribute RPageRequestDTO pageRequestDTO) {

		try {
			List<ReviewReplyDTO> replies = service.getRepliesByBoardNoWithPaging(boardNo, pageRequestDTO);
			int totalCount = service.getReplyCount(boardNo);

			RPageResponseDTO<ReviewReplyDTO> response = new RPageResponseDTO<>(replies, totalCount, pageRequestDTO);
			return ResponseEntity.ok(response);

		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	// 댓글 등록
	@PostMapping("/add")
	public ResponseEntity<ReviewReplyDTO> addReply(@RequestBody ReviewReplyDTO dto, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}

		dto.setUserId(account.getUid());

		try {
			boolean result = service.insertReply(dto);
			if (result) {
				return ResponseEntity.ok(dto);
			} else {
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	@PostMapping("/update")
	public ResponseEntity<ReviewReplyDTO> updateReply(@RequestBody ReviewReplyDTO dto, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");

		System.out.println(" 요청 DTO: " + dto); // 객체 전체 확인
		System.out.println(" 세션 로그인 UID: " + (account != null ? account.getUid() : "null"));
		System.out.println("️ 댓글 번호: " + dto.getReplyNo());
		System.out.println(" 댓글 작성자 ID: " + dto.getUserId());
		System.out.println(" 수정된 내용: " + dto.getContent());

		if (account == null || dto.getUserId() != account.getUid()) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}

		try {
			boolean result = service.updateReply(dto);
			if (result) {
				return ResponseEntity.ok().build();
			} else {
				System.out.println("❌ 업데이트 실패: 조건 불일치");
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
			}
		} catch (Exception e) {
			e.printStackTrace(); // 콘솔 로그 확인 필수!
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	@PostMapping("/delete")
	public ResponseEntity<Boolean> deleteReply(@RequestBody ReviewReplyDTO dto, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(false);
		}
		if (dto.getReplyNo() <= 0) {
			System.out.println(dto.getReplyNo());
			return ResponseEntity.badRequest().build();
		}
		boolean result = false;
		try {
			result = service.deleteReply(dto.getReplyNo(), account.getUid());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result ? ResponseEntity.ok(true) : ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);
	}

	// 댓글 좋아요 추가
	@PostMapping("/like")
	public ResponseEntity<String> likeReply(@RequestBody Map<String, Integer> payload, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
		}
		int replyNo = payload.get("replyNo");
		int userUid = account.getUid();
		System.out.println("👍 [likeReply] replyNo = " + replyNo + ", userUid = " + userUid);
		try {
			boolean result = service.likeReply(replyNo, userUid);
			return result ? ResponseEntity.ok("좋아요가 추가되었습니다.")
					: ResponseEntity.status(HttpStatus.BAD_REQUEST).body("이미 좋아요를 누르셨습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류 발생");
		}
	}

	// 댓글 좋아요 취소
	@PostMapping("/unlike")
	public ResponseEntity<String> unlikeReply(@RequestBody Map<String, Integer> payload, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account == null) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
		}

		int replyNo = payload.get("replyNo");
		int userUid = account.getUid();

		System.out.println("❌ [unlikeReply] replyNo = " + replyNo + ", userUid = " + userUid);

		try {
			boolean result = service.unlikeReply(replyNo, userUid);
			return result ? ResponseEntity.ok("좋아요가 취소되었습니다.")
					: ResponseEntity.status(HttpStatus.BAD_REQUEST).body("좋아요 상태가 아닙니다.");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류 발생");
		}
	}
}