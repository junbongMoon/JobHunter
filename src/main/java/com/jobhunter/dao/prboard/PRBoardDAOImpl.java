package com.jobhunter.dao.prboard;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.prboard.PRBoardDTO;
import com.jobhunter.model.prboard.PRBoardVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PRBoardDAOImpl implements PRBoardDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.prboardmapper";

	@Override
	public int insertPRBoard(PRBoardDTO prBoardDTO) throws Exception {
		
		return ses.insert(NS +".savePRBoardByMento", prBoardDTO);
	}

	@Override
	public int selectTotalCntRow() throws Exception {
		
		return ses.selectOne(NS + ".getTotalCountRow");
	}

	@Override
	public List<PRBoardVO> selectPRBoardListByPaging(PageResponseDTO<PRBoardVO> pageResponseDTO) throws Exception {
		
		return ses.selectList(NS + ".getPRBoardListByPaging", pageResponseDTO);
	}
	
	@Override
	public PRBoardVO selectPRBoardDetail(int prBoardNo) throws Exception {
	    return ses.selectOne(NS + ".getPRBoardDetail", prBoardNo);
	}

	@Override
	public int updatePRBoard(PRBoardDTO prBoardDTO) throws Exception {
	    return ses.update(NS + ".updatePRBoard", prBoardDTO);
	}

	@Override
	public int deletePRBoard(int prBoardNo) throws Exception {
	    return ses.delete(NS + ".deletePRBoard", prBoardNo);
	}

}
