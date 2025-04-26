package com.jobhunter.service.mentor;

import com.jobhunter.model.mentor.MentorRequestListOfPageVO;
import com.jobhunter.model.mentor.MentorRequestListSearchDTO;
import com.jobhunter.model.mentor.MentorRequestSimpleVO;
import com.jobhunter.model.mentor.MentorRequestVO;

public interface MentorService {

	MentorRequestListOfPageVO<MentorRequestSimpleVO> getMentorRequestList(MentorRequestListSearchDTO dto)
			throws Exception;

	MentorRequestVO selectMentorRequestDetail(Integer advancementNo) throws Exception;

}
