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

@Service
@RequiredArgsConstructor
public class SubmitServiceImpl implements SubmitService {
	
	// 이력서 DAO
	 private final SubmitDAO submitDAO;
	

	
	// 일단 여기서 임시로 수행. 나중에 ResumeService로 이동할 메서드 
	// 공고 uid로 해당 공고에 제출 된 ResumDetailInfoBySubmit들을 조회하는 메서드
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
	
	// 페이징 해주는 메서드
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
	
	// 제출내역의 상태값을 변경해주는 메서드
	@Override
	public void changeStatus(Status status, int resumePk, int recruitmentNoticePk) {
		System.out.println("서비스 단" + status + ", " + resumePk + ", " + recruitmentNoticePk);
		
		submitDAO.updateStatusByRegistration(status, resumePk, recruitmentNoticePk);
		
	}

}
