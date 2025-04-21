package com.jobhunter.service.prboard;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.prboard.PRBoardDAO;
import com.jobhunter.model.prboard.PRBoardDTO;

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

}
