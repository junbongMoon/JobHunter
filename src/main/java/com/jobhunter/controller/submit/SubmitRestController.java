package com.jobhunter.controller.submit;

import java.util.List;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.SubmitFromRecruitVO;
import com.jobhunter.model.submit.SubmitFromUserVO;
import com.jobhunter.model.submit.SubmitSearchDTO;
import com.jobhunter.model.util.TenToFivePageVO;
import com.jobhunter.service.submit.SubmitService;

import lombok.RequiredArgsConstructor;

/**
 * @author 육근우
 *
 */
@RestController
@RequestMapping("/submit")
@RequiredArgsConstructor
public class SubmitRestController {

	// 제출에 대한 Service단
	private final SubmitService submitService;

	/**
	 * @author 육근우
	 *
	 * <p>
	 * 	공고에대한 검색조건에 맞는 페이징된 신청서들 가져오기
	 * </p>
	 * 
	 * @param SubmitSearchDTO dto 검색정보 및 공고uid 담긴 dto
	 * @return 신청서리스트를 담은 페이징된 객체
	 *
	 */
	@PostMapping("/withResume")
	public TenToFivePageVO<SubmitFromRecruitVO> showRecruitmentWithResumeByUid(@RequestBody SubmitSearchDTO dto) {
		try {
			return submitService.selectResumesByRecruitmentUid(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@PostMapping("/withUser")
	public TenToFivePageVO<SubmitFromUserVO> selectSubmitFromUser(@RequestBody SubmitSearchDTO dto) {
		try {
			return submitService.selectSubmitFromUser(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@PostMapping("/files/{registrationNo}")
	public List<ResumeUpfileDTO> getFiles(@PathVariable("registrationNo") int registrationNo) {
		try {
			return submitService.getFiles(registrationNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
