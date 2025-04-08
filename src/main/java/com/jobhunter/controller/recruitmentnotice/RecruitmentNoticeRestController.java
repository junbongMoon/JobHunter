package com.jobhunter.controller.recruitmentnotice;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/recruitmentnotice/rest")
@RequiredArgsConstructor
public class RecruitmentNoticeRestController {

	private final RecruitmentNoticeService recService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeRestController.class);
	
	
	// 내가 작성한 공고 리스트를 가져오는 메서드
		@GetMapping("/writeBy/{companyUid}")
		public PageResponseDTO<RecruitmentNotice> showRecruitmentWirteByUid(@PathVariable("companyUid") int companyUid,
				PageRequestDTO pageRequestDTO, Model model){
			PageResponseDTO<RecruitmentNotice> result = null;
			
			recService.getRecruitmentByCompanyUid(companyUid, pageRequestDTO);
			
			
			return result;
			
		}
	



	
}
