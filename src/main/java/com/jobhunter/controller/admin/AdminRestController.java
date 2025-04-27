package com.jobhunter.controller.admin;


import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.mentor.MentorRequestListOfPageVO;
import com.jobhunter.model.mentor.MentorRequestListSearchDTO;
import com.jobhunter.model.mentor.MentorRequestSimpleVO;
import com.jobhunter.service.mentor.MentorService;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 페이지 관련 컨트롤러입니다.
 * <p>
 * 관리자 페이지에서 홈페이지에 대한 관리를 맡습니다.
 * </p>
 */
@RestController
@RequiredArgsConstructor
public class AdminRestController {
	
	private final MentorService mentorService;
	
	@PostMapping("/mentor/request-list")
    public MentorRequestListOfPageVO<MentorRequestSimpleVO> getMentorRequestList(@RequestBody MentorRequestListSearchDTO searchDTO) {
        System.out.println("받은 검색 조건: " + searchDTO);
        
        MentorRequestListOfPageVO<MentorRequestSimpleVO> result = null;
        
        try {
        	result = mentorService.getMentorRequestList(searchDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return result;
    }
}
