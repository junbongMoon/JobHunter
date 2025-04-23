package com.jobhunter.controller.reviewboard;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.reviewboard.RPageRequestDTO;
import com.jobhunter.model.reviewboard.ReviewBoardWithReplyVO;
import com.jobhunter.model.util.TenToFivePageVO;
import com.jobhunter.service.reviewboard.ReviewBoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/reviewBoard")
@RequiredArgsConstructor
public class ReviewBoardRestController {

	private final ReviewBoardService service;

	@PostMapping("/myReview")
	public TenToFivePageVO<ReviewBoardWithReplyVO> getMyReview(@RequestBody RPageRequestDTO dto) {
		try {
			return service.getMyReview(dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

}
