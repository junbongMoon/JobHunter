package com.jobhunter.controller.admin;


import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.advancement.MentorRequestListOfPageVO;
import com.jobhunter.model.advancement.MentorRequestListSearchDTO;
import com.jobhunter.model.advancement.MentorRequestSimpleVO;
import com.jobhunter.service.advancement.AdvancementService;

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
	
	private final AdvancementService advancementService;
	
	@PostMapping("/mentor/request-list")
    public MentorRequestListOfPageVO<MentorRequestSimpleVO> getMentorRequestList(@RequestBody MentorRequestListSearchDTO searchDTO) {
        
        MentorRequestListOfPageVO<MentorRequestSimpleVO> result = null;
        
        try {
        	result = advancementService.getMentorRequestList(searchDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return result;
    }
}
