package com.jobhunter.dao.advancement;

import java.util.List;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.advancement.MentorRequestListSearchDTO;
import com.jobhunter.model.advancement.MentorRequestSimpleVO;
import com.jobhunter.model.advancement.MentorRequestVO;
import com.jobhunter.model.advancement.MentorRequestVO.Status;

public interface AdvancementDAO {
	
	// 게시물 등록하는 메서드
	public int insertAdvancementByMento(AdvancementDTO advancementDTO) throws Exception;
	
	// 게시물에 올릴 파일 등록하는 메서드
	public int insertAdvancementFileUpload(AdvancementUpFileVODTO file) throws Exception;
	
	// 게시물을 조회하는 메서드
	public AdvancementVO selectAdvancementByAdvancementNo(int advancementNo) throws Exception;

	public List<AdvancementUpFileVODTO> getfileListByAdvancement(int advancementNo) throws Exception;

	List<MentorRequestSimpleVO> selectMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception;

	int countMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception;

	MentorRequestVO selectMentorRequestDetail(Integer advancementNo) throws Exception;

	void setMentorRequestStatusToFail(int requestNo, String rejectMessage) throws Exception;

	void setMentorRequestStatusToChecked(Integer advancementNo) throws Exception;

	void setMentorRequestStatusToPass(Integer advancementNo) throws Exception;

	int selectRefUserByAdvancementNo(int advancementNo) throws Exception;

	void setMentorRequestStatusToPassByRefUser(Integer refUser) throws Exception;
}
