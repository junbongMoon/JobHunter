package com.jobhunter.service.submit;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.submit.SubmitDAO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.Status;

import lombok.RequiredArgsConstructor;

/**
 * @author 문준봉
 *
 */
@Service
@RequiredArgsConstructor
public class SubmitServiceImpl implements SubmitService {
	
	 
	 /**
	 * <p> 
	 * 이력서 DAO
	 * </p>
	 */
	private final SubmitDAO submitDAO;
	
 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	공고 uid로 해당 공고에 제출 된 ResumDetailInfoBySubmit들을 조회하는 메서드
	 * </p>
	 * 
	 * @param int RecruitmentUid
	 * @param PageRequestDTO pageRequestDTO
	 * @return 제출된 상태의 이력서 상세정보를 담은 페이징에 대한 정보를 담은 객체
	 * @throws Exception
	 *
	 */
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public PageResponseDTO<ResumeDetailInfoBySubmit> getResumeWithAll(int RecruitmentUid, PageRequestDTO pageRequestDTO) throws Exception {
		
		int totalCount = submitDAO.selectTotalCountRowOfResumeByUid(RecruitmentUid);
		
		PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO = pagingProcess(pageRequestDTO, totalCount);
		
		List<ResumeDetailInfoBySubmit> resumeList = submitDAO.selectResumDetailInfoBySubmitByRecruitmentUid(RecruitmentUid, pageResponseDTO);
		
		// 각 이력서에 대해 첨부파일도 개별 조회해서 추가
	    for (ResumeDetailInfoBySubmit resume : resumeList) {
	        List<ResumeUpfileDTO> fileList = submitDAO.selectUpfileListByResume(resume.getResumeNo());
	        resume.setFiles(fileList);
	    }
			
		pageResponseDTO.setBoardList(resumeList);
		
		
		return pageResponseDTO;
	}
	

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 전체 페이지 수, 출력할 rowIndex, 현재 페이지 블럭, 시작 페이지 블럭, 끝 페이지 블럭을 저장하는 메서드
	 * </p>
	 * 
	 * @param <T>
	 * @param PageRequestDTO pageRequestDTO
	 * @param int totalRowCount
	 * @return 페이징에 대한 정보를 담은 객체
	 *
	 */
	private <T> PageResponseDTO<T> pagingProcess(PageRequestDTO pageRequestDTO, int totalRowCount) {
	    PageResponseDTO<T> pageResponseDTO = new PageResponseDTO<>(
	        pageRequestDTO.getPageNo(),
	        pageRequestDTO.getRowCntPerPage()
	    );

	    pageResponseDTO.setTotalRowCnt(totalRowCount); // 전체 데이터 수

	    if (StringUtils.hasText(pageRequestDTO.getSearchType())) {
	        pageResponseDTO.setSearchType(pageRequestDTO.getSearchType());
	        pageResponseDTO.setSearchWord(pageRequestDTO.getSearchWord());
	    }

	    pageResponseDTO.setTotalPageCnt();       // 전체 페이지 수
	    pageResponseDTO.setStartRowIndex();      // 출력 시작할 rowIndex번호
	    pageResponseDTO.setBlockOfCurrentPage(); // 현재 페이지가 몇번째 블럭에 있는가?
	    pageResponseDTO.setStartPageNumPerBlock();
	    pageResponseDTO.setEndPageNumPerBlock();

	    return pageResponseDTO;
	}
	

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 제출내역의 상태값을 변경해주는 메서드
	 * </p>
	 * 
	 * @param Status status
	 * @param int resumePk
	 * @param int recruitmentNoticePk
	 * @return 변경이 성공 됬으면 true, 실패했으면 false
	 *
	 */
	@Override
	public boolean changeStatus(Status status, int resumePk, int recruitmentNoticePk) {
		boolean result = false;
		System.out.println("서비스 단" + status + ", " + resumePk + ", " + recruitmentNoticePk);
		
		
		if(submitDAO.updateStatusByRegistration(status, resumePk, recruitmentNoticePk) > 0) {
			result = true;
		}
		return result;
	}
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	
	 * </p>
	 * 
	 * @param yesterDayStr
	 * @return 만료된 제출 상태의 갯수
	 * @throws Exception
	 *
	 */
	@Override
	public int expiredToSubmit(String yesterDayStr) throws Exception {
	    // 어제 마감된 공고를 기준으로 WATING 상태를 EXPIRED로 변경
	    return submitDAO.updateStatusToExpired(yesterDayStr);
	}

}
