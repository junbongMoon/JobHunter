package com.jobhunter.controller.reviewboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.service.reviewboard.ReviewBoardService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/reviewBoard")
@RequiredArgsConstructor
public class ReviewBoardController {

	private final ReviewBoardService service;

	private static Logger logger = LoggerFactory.getLogger(ReviewBoardController.class);

	@GetMapping("/Allboard")
	public String listBoard (Model model, ReviewBoardDTO reviewBoardDTO) {
	
		String result;
		try {
			result = service.selectReBoard(reviewBoardDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result; 
	
	};

}
