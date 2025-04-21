package com.jobhunter.controller.
reviewReply;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
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
    @GetMapping("/{boardNo}")
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
}

