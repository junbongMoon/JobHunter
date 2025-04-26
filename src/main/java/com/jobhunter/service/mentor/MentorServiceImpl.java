package com.jobhunter.service.mentor;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.mentor.MentorDAO;
import com.jobhunter.model.mentor.MentorRequestListOfPageVO;
import com.jobhunter.model.mentor.MentorRequestListSearchDTO;
import com.jobhunter.model.mentor.MentorRequestSimpleVO;
import com.jobhunter.model.mentor.MentorRequestVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MentorServiceImpl implements MentorService {
	private final MentorDAO dao;
	
	@Override
	public MentorRequestListOfPageVO<MentorRequestSimpleVO> getMentorRequestList(MentorRequestListSearchDTO dto) throws Exception {
		List<MentorRequestSimpleVO> list = dao.selectMentorRequestSimpleList(dto);
        int total = dao.countMentorRequestSimpleList(dto);
        return new MentorRequestListOfPageVO<>(list, dto.getPage(), total);
	}
	
	@Override
	public MentorRequestVO selectMentorRequestDetail(Integer advancementNo) throws Exception {
		return dao.selectMentorRequestDetail(advancementNo);
	}
}