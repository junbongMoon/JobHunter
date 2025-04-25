package com.jobhunter.dao.advancement;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AdvancementDAOImpl implements AdvancementDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.advancementmapper";
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 	멘토 승급 게시물 등록하는 메서드
	 * </p>
	 * 
	 * @param advancementDTO
	 * @return 등록 성공하면 1, 실패하면 0
	 * @throws Exception
	 *
	 */
	@Override
	public int insertAdvancementByMento(AdvancementDTO advancementDTO) throws Exception {
		
		return ses.insert(NS + ".saveAdvancement", advancementDTO);
	}


	@Override
	public int insertAdvancementFileUpload(AdvancementUpFileVODTO file) throws Exception {
		return ses.insert(NS + ".insertAdvancementFile", file);
	}


	@Override
	public AdvancementVO selectAdvancementByAdvancementNo(int advancementNo) throws Exception {
		
		return ses.selectOne(NS + ".getAdvancementByAdvancementNo", advancementNo);
	}


	@Override
	public List<AdvancementUpFileVODTO> getfileListByAdvancement(int advancementNo) throws Exception {
		
		return ses.selectList(NS + ".getAdvanceFileListByadvancementNo", advancementNo);
	}
	
	

}
