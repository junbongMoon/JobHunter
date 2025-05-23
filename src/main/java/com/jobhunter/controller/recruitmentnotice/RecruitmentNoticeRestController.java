package com.jobhunter.controller.recruitmentnotice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResume;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResumePageDTO;
import com.jobhunter.model.util.TenToFivePageVO;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

/**
 * @author 문준봉
 *
 */
@RestController
@RequestMapping("/recruitmentnotice/rest")
@RequiredArgsConstructor
public class RecruitmentNoticeRestController {

	/**
	 * <p> 
	 * 공고 Service단
	 * </p>
	 */
	private final RecruitmentNoticeService recService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeRestController.class);
	
		/**
		 *  @author 문준봉
		 *
		 * <p>
		 * 내가 작성한 공고 리스트를 가져오는 메서드
		 * </p>
		 * 
		 * @param int companyUid
		 * @param PageRequestDTO pageRequestDTO
		 * @param Model model
		 * @return  공고리스트를 담은 페이징에 정보를 객체를 담은 ResponseEntity
		 *
		 */
		@GetMapping("/list/{companyUid}")
		public ResponseEntity<PageResponseDTO<RecruitmentNotice>> showRecruitmentWirteByUid(@PathVariable("companyUid") int companyUid,
				PageRequestDTO pageRequestDTO, Model model){
			ResponseEntity<PageResponseDTO<RecruitmentNotice>> result = null;		
			
			PageResponseDTO<RecruitmentNotice> pageResponseDTO = recService.getRecruitmentByCompanyUid(companyUid, pageRequestDTO);
			
			result = ResponseEntity.ok().body(pageResponseDTO);
			
			return result;
			
		}
		
		/**
		 *  @author 문준봉
		 *
		 * <p>
		 * 공고 상세정보를 조회하는 메서드
		 * </p>
		 * 
		 * @param uid 공고 pk
		 * @return ResponseEntity와 RecruitmentDetailInfo 공고 상세정보
		 *
		 */
		@GetMapping("/detail/{uid}")
		public ResponseEntity<RecruitmentDetailInfo> showRecruitmentDetailByUid(@PathVariable("uid") int uid){
			ResponseEntity<RecruitmentDetailInfo> result = null;
			
			try {
				RecruitmentDetailInfo detailInfo = recService.getRecruitmentByUid(uid);
				result = ResponseEntity.ok().body(detailInfo);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				result = ResponseEntity.badRequest().body(null);
			}
			
			return result;
		}
		
		/**
		 *  @author 문준봉
		 *
		 * <p>
		 * 공고를 마감시키는 메서드
		 * </p>
		 * 
		 * @param uid 공고 pk
		 * @return ResponseEntity와 성공했는지 여부
		 *
		 */
		@PutMapping("/dueDate/{uid}")
		public ResponseEntity<Boolean> ExpiredDueDateByUid(@PathVariable("uid") int uid){
			ResponseEntity<Boolean> result = null;
			boolean isSuccess = false;
			try {
				isSuccess = recService.modifyDueDateByUid(uid); // 여기서 수정
				result = ResponseEntity.ok().body(isSuccess);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				result = ResponseEntity.badRequest().body(isSuccess);
				
			}
			
			return result;
		}
	
		/**
		 *  @author 육근우
		 *
		 * <p>
		 * 내 공고 리스트 + 해당 공고에 붙은 신청서 갯수를 가져오는 메서드
		 * </p>
		 * 
		 * @param int companyUid
		 * @param PageRequestDTO pageRequestDTO
		 * @param Model model
		 * @return  공고리스트를 담은 페이징에 정보를 객체를 담은 ResponseEntity
		 *
		 */
		@PostMapping("/withResume")
	    public TenToFivePageVO<RecruitmentWithResume> showRecruitmentWithResumeByUid(@RequestBody RecruitmentWithResumePageDTO dto) {
	        try {
	        	TenToFivePageVO<RecruitmentWithResume> result = recService.searchRecruitments(dto);
				return result;
			} catch (Exception e) {
				e.printStackTrace();
			}
	        return null;
	    }
	
}
