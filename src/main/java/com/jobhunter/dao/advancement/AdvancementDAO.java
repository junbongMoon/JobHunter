package com.jobhunter.dao.advancement;

import java.util.List;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;

public interface AdvancementDAO {
	
	// 게시물 등록하는 메서드
	public int insertAdvancementByMento(AdvancementDTO advancementDTO) throws Exception;
	
	// 게시물에 올릴 파일 등록하는 메서드
	public int insertAdvancementFileUpload(AdvancementUpFileVODTO file) throws Exception;
	
	// 게시물을 조회하는 메서드
	public AdvancementVO selectAdvancementByAdvancementNo(int advancementNo) throws Exception;

	public List<AdvancementUpFileVODTO> getfileListByAdvancement(int advancementNo) throws Exception;

	public int getSearchResultRowCount(int uid, PageRequestDTO pageRequestDTO) throws Exception;

	public int getTotalCountRow(int uid) throws Exception;

	public List<AdvancementVO> selectAdvancementListByPaging(int uid, PageResponseDTO<AdvancementVO> pageResponseDTO) throws Exception;

	public int updateAdvancementByMento(AdvancementDTO advancementDTO) throws Exception;

	public int deleteFilesByAdvancementNo(int advancementNo) throws Exception;

	public int deleteAdvancementById(int advancementNo) throws Exception;
}
