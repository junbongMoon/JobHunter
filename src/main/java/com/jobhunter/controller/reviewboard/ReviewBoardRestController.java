package com.jobhunter.controller.reviewboard;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.reviewboard.RPageRequestDTO;
import com.jobhunter.model.reviewboard.ReviewBoardWithReplyVO;
import com.jobhunter.model.util.TenToFivePageVO;
import com.jobhunter.service.reviewboard.ReviewBoardService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/reviewBoard")
@RequiredArgsConstructor
public class ReviewBoardRestController {

	private final ReviewBoardService service;

	@PostMapping("/myReview")
	public TenToFivePageVO<ReviewBoardWithReplyVO> getMyReview(@RequestBody RPageRequestDTO dto) {
		System.out.println(dto);
		try {
			TenToFivePageVO<ReviewBoardWithReplyVO> vo = service.getMyReview(dto);
			System.out.println(vo);
			return vo;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

}
