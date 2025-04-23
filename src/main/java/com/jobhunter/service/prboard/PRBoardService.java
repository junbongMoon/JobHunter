package com.jobhunter.service.prboard;

import java.util.List;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.prboard.PRBoardDTO;
import com.jobhunter.model.prboard.PRBoardVO;
import com.jobhunter.model.util.TenToFivePageVO;

public interface PRBoardService {
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 멘토 PR 게시글을 저장하는 메서드
	 * </p>
	 * 
	 * @param prBoardDTO
	 * @return 저장에 성공하면 true, 실패하면 false
	 * @throws Exception
	 *
	 */
	public boolean savePRBoard(PRBoardDTO prBoardDTO) throws Exception;

	public PageResponseDTO<PRBoardVO> getprBoardByPagination(PageRequestDTO pageRequestDTO) throws Exception;

	public PRBoardVO getPRBoardDetail(int prBoardNo) throws Exception;

	public boolean updatePRBoard(PRBoardDTO prBoardDTO) throws Exception;

	public boolean deletePRBoard(int prBoardNo) throws Exception;

	TenToFivePageVO<PRBoardVO> selectMyPRBoard(int uid, int page) throws Exception;
}
