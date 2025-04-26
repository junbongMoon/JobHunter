package com.jobhunter.dao.mentor;

import java.util.List;

import com.jobhunter.model.mentor.MentorRequestListSearchDTO;
import com.jobhunter.model.mentor.MentorRequestSimpleVO;
import com.jobhunter.model.mentor.MentorRequestVO;

public interface MentorDAO {
	List<MentorRequestSimpleVO> selectMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception;

    int countMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception;

	MentorRequestVO selectMentorRequestDetail(Integer advancementNo) throws Exception;
}
