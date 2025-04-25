package com.jobhunter.dao.advancement;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;

public interface AdvancementDAO {
	
	// 게시물 등록하는 메서드
	public int insertAdvancementByMento(AdvancementDTO advancementDTO) throws Exception;

	public int insertAdvancementFileUpload(AdvancementUpFileVODTO file) throws Exception;
}
