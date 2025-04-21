package com.jobhunter.service.prboard;

import com.jobhunter.model.prboard.PRBoardDTO;

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
}
