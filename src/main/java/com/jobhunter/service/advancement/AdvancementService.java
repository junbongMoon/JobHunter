package com.jobhunter.service.advancement;

import java.util.List;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;

public interface AdvancementService {
	
	// 승급 게시물 등록하는 메서드
	public boolean SaveAdvancementByMento(AdvancementDTO advancementDTO, List<AdvancementUpFileVODTO> fileList) throws Exception;
	
}
