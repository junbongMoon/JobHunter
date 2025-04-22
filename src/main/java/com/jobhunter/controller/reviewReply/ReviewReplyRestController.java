package com.jobhunter.controller.reviewReply;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewReply.ReviewReplyDTO;
import com.jobhunter.service.reviewReply.ReviewReplyService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/reply")
@RequiredArgsConstructor
public class ReviewReplyRestController {

	private final ReviewReplyService service;

	// 댓글 목록
	@GetMapping("/list/{boardNo}")
	public ResponseEntity<List<ReviewReplyDTO>> getReplyList(@PathVariable int boardNo) {

		try {
			List<ReviewReplyDTO> replies = service.getRepliesByBoardNo(boardNo);
			return ResponseEntity.ok(replies); // 정상 응답
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

		System.out.println("🔧 요청 DTO: " + dto); // 객체 전체 확인
		System.out.println("🔑 세션 로그인 UID: " + (account != null ? account.getUid() : "null"));
		System.out.println("✏️ 댓글 번호: " + dto.getReplyNo());
		System.out.println("👤 댓글 작성자 ID: " + dto.getUserId());
		System.out.println("💬 수정된 내용: " + dto.getContent());

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

}
