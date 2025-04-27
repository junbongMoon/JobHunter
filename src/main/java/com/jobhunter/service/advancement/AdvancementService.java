package com.jobhunter.service.advancement;

import java.util.List;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.advancement.MentorRequestListOfPageVO;
import com.jobhunter.model.advancement.MentorRequestListSearchDTO;
import com.jobhunter.model.advancement.MentorRequestSimpleVO;
import com.jobhunter.model.advancement.MentorRequestVO;

public interface AdvancementService {
	
	// 승급 게시물 등록하는 메서드
	public boolean SaveAdvancementByMento(AdvancementDTO advancementDTO, List<AdvancementUpFileVODTO> fileList) throws Exception;

	public AdvancementVO getAdvancementById(int advancementNo) throws Exception;

	MentorRequestVO selectMentorRequestDetail(Integer advancementNo) throws Exception;

	MentorRequestListOfPageVO<MentorRequestSimpleVO> getMentorRequestList(MentorRequestListSearchDTO dto)
			throws Exception;

	public void confirmMentorRequest(int requestNo) throws Exception;

	public void dropMentorRequest(int requestNo, String rejectMessage) throws Exception;
	
}
