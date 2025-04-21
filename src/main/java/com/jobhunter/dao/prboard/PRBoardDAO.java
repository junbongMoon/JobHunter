package com.jobhunter.dao.prboard;

import java.util.List;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.prboard.PRBoardDTO;
import com.jobhunter.model.prboard.PRBoardVO;

public interface PRBoardDAO {
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 멘토PR 게시물을 insert하는 메서드
	 * </p>
	 * 
	 * @param prBoardDTO
	 * @return 성공하면 1, 실패하면 0
	 * @throws Exception
	 *
	 */
	int insertPRBoard(PRBoardDTO prBoardDTO) throws Exception;

	int selectTotalCntRow() throws Exception;

	List<PRBoardVO> selectPRBoardListByPaging(PageResponseDTO<PRBoardVO> pageResponseDTO) throws Exception;
	

}
