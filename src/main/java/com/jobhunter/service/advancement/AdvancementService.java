package com.jobhunter.service.advancement;

import java.util.List;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;

public interface AdvancementService {
	
	// 승급 게시물 등록하는 메서드
	public boolean SaveAdvancementByMento(AdvancementDTO advancementDTO, List<AdvancementUpFileVODTO> fileList) throws Exception;
	
	// 승급 게시물을 advancementNo(pk)로 조회하는 메서드
	public AdvancementVO getAdvancementById(int advancementNo) throws Exception;
	
	// 승급 게시물 리스트를 작성자 uid로 조회하는 게시물
	public PageResponseDTO<AdvancementVO> getAdvancementListByUid(int uid, PageRequestDTO pageRequestDTO) throws Exception;

	public boolean modifyAdvancementByMento(AdvancementDTO advancementDTO, List<AdvancementUpFileVODTO> fileList) throws Exception;
	
}
