package com.jobhunter.dao.prboard;

import com.jobhunter.model.prboard.PRBoardDTO;

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
	

}
