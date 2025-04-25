package com.jobhunter.service.advancement;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.advancement.AdvancementDAO;
import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.util.FileStatus;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdvancementServiceImpl implements AdvancementService {
	private final AdvancementDAO advancementDAO;
	
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public boolean SaveAdvancementByMento(AdvancementDTO advancementDTO, List<AdvancementUpFileVODTO> fileList)
			throws Exception {
		
		boolean result = false;
		
		if (advancementDAO.insertAdvancementByMento(advancementDTO) > 0) {
		    int advancementNo = advancementDTO.getAdvancementNo(); // useGeneratedKeys로 들어온 값
		    
		    if (fileList != null && !fileList.isEmpty()) {
		        for (AdvancementUpFileVODTO file : fileList) {
		        	file.setStatus(FileStatus.COMPLETE);
		            file.setRefAdvancementNo(advancementNo); // 반드시 설정 필요
		            advancementDAO.insertAdvancementFileUpload(file);
		        }
		    }
		    result = true;
		}
		
		return result;
	}

	@Override
	public AdvancementVO getAdvancementById(int advancementNo) throws Exception {
		AdvancementVO advancementVO = advancementDAO.selectAdvancementByAdvancementNo(advancementNo);
		if(advancementVO.getAdvancementNo() > 0) {
			List<AdvancementUpFileVODTO> fileList = advancementDAO.getfileListByAdvancement(advancementVO.getAdvancementNo());
		}
		return null;
	}
	
	

}
