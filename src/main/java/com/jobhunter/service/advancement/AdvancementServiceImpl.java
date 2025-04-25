package com.jobhunter.service.advancement;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.advancement.AdvancementDAO;
import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdvancementServiceImpl implements AdvancementService {
	private final AdvancementDAO advancementDAO;

	@Override
	public boolean SaveAdvancementByMento(AdvancementDTO advancementDTO, List<AdvancementUpFileVODTO> fileList)
			throws Exception {
		
		boolean result = false;
		
		if (advancementDAO.insertAdvancementByMento(advancementDTO) > 0) {
		    int advancementNo = advancementDTO.getAdvancementNo(); // useGeneratedKeys로 들어온 값
		    
		    if (fileList != null && !fileList.isEmpty()) {
		        for (AdvancementUpFileVODTO file : fileList) {
		            file.setRefAdvancementNo(advancementNo); // 반드시 설정 필요
		            advancementDAO.insertAdvancementFileUpload(file);
		        }
		    }
		    result = true;
		}
		
		return result;
	}
	
	

}
