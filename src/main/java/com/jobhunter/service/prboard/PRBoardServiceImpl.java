package com.jobhunter.service.prboard;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.prboard.PRBoardDAO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.prboard.PRBoardDTO;
import com.jobhunter.model.prboard.PRBoardVO;
import com.jobhunter.model.util.TenToFivePageVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PRBoardServiceImpl implements PRBoardService {
	private final PRBoardDAO prBoardDAO;

	@Override
	public boolean savePRBoard(PRBoardDTO prBoardDTO) throws Exception {
		boolean result = false;
		
		if(prBoardDAO.insertPRBoard(prBoardDTO) > 0) {
			result = true;
		}
		
		return result;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public PageResponseDTO<PRBoardVO> getprBoardByPagination(PageRequestDTO pageRequestDTO) throws Exception {
		
		int totalRowCnt;
		
		totalRowCnt = prBoardDAO.selectTotalCntRow();
		
		PageResponseDTO<PRBoardVO> pageResponseDTO = pagingProcess(pageRequestDTO, totalRowCnt);
		
		List<PRBoardVO> boardList = prBoardDAO.selectPRBoardListByPaging(pageResponseDTO);
		
		pageResponseDTO.setBoardList(boardList);
		
		System.out.println(boardList);
		
		return pageResponseDTO;
	}
	
	private <T> PageResponseDTO<T> pagingProcess(PageRequestDTO pageRequestDTO, int totalRowCount) {
	    PageResponseDTO<T> pageResponseDTO = new PageResponseDTO<>(
	        pageRequestDTO.getPageNo(),
	        pageRequestDTO.getRowCntPerPage()
	    );
	    
	    System.out.println("pageresponsedto : " + pageResponseDTO);
 
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

	
	@Override
	public PRBoardVO getPRBoardDetail(int prBoardNo) throws Exception {
	    return prBoardDAO.selectPRBoardDetail(prBoardNo);
	}

	@Override
	public boolean updatePRBoard(PRBoardDTO prBoardDTO) throws Exception {
		boolean result = false;
		if(prBoardDAO.updatePRBoard(prBoardDTO) > 0) {
			result = true;
		}
	    return result;
	}

	@Override
	public boolean deletePRBoard(int prBoardNo) throws Exception {
		boolean result = false;
		if(prBoardDAO.deletePRBoard(prBoardNo) > 0) {
			result = true;
		}
	    return result;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public TenToFivePageVO<PRBoardVO> selectMyPRBoard (int uid, int page) throws Exception {
		int offset = (page - 1) * 5;
		List<PRBoardVO> vo = prBoardDAO.selectMyPRBoard(uid, offset);
		int totalCnt = prBoardDAO.selectMyPRBoardCnt(uid);
		TenToFivePageVO<PRBoardVO> result = new TenToFivePageVO<PRBoardVO>(vo, page, totalCnt);
	    return result;
	}
}
