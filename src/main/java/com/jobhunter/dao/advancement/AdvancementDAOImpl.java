package com.jobhunter.dao.advancement;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.advancement.MentorRequestListSearchDTO;
import com.jobhunter.model.advancement.MentorRequestSimpleVO;
import com.jobhunter.model.advancement.MentorRequestVO;
import com.jobhunter.model.advancement.MentorRequestVO.Status;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AdvancementDAOImpl implements AdvancementDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.advancementmapper";
	
	@Override
	public List<MentorRequestSimpleVO> selectMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception {
		return ses.selectList(NS + ".selectMentorRequestSimpleList", dto);
	}
	@Override
	public int countMentorRequestSimpleList(MentorRequestListSearchDTO dto) throws Exception {
		return ses.selectOne(NS + ".countMentorRequestSimpleList", dto);
	}
	
	@Override
	public MentorRequestVO selectMentorRequestDetail(Integer advancementNo) throws Exception {
		return ses.selectOne(NS + ".selectMentorRequestDetail", advancementNo);
	}
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 	멘토 승급 게시물 등록하는 메서드
	 * </p>
	 * 
	 * @param advancementDTO
	 * @return 등록 성공하면 1, 실패하면 0
	 * @throws Exception
	 *
	 */
	@Override
	public int insertAdvancementByMento(AdvancementDTO advancementDTO) throws Exception {
		
		return ses.insert(NS + ".saveAdvancement", advancementDTO);
	}


	@Override
	public int insertAdvancementFileUpload(AdvancementUpFileVODTO file) throws Exception {
		return ses.insert(NS + ".insertAdvancementFile", file);
	}


	@Override
	public AdvancementVO selectAdvancementByAdvancementNo(int advancementNo) throws Exception {
		
		return ses.selectOne(NS + ".getAdvancementByAdvancementNo", advancementNo);
	}


	@Override
	public List<AdvancementUpFileVODTO> getfileListByAdvancement(int advancementNo) throws Exception {
		return ses.selectList(NS + ".getAdvanceFileListByadvancementNo", advancementNo);
	}
	
	@Override
	public void setMentorRequestStatusToChecked(Integer advancementNo) throws Exception {
		ses.update(NS + ".setMentorRequestStatusToChecked", advancementNo);
	}
	
	@Override
	public void setMentorRequestStatusToPass(Integer advancementNo) throws Exception {
		ses.update(NS + ".setMentorRequestStatusToPass", advancementNo);
	}
	
	@Override
	public void setMentorRequestStatusToFail(int requestNo, String rejectMessage) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("advancementNo", requestNo);
		param.put("rejectMessage", rejectMessage);
		ses.update(NS + ".setMentorRequestStatusToFail", param);
	}
	
	@Override
	public int selectRefUserByAdvancementNo(int advancementNo) throws Exception {
		return ses.selectOne(NS + ".selectRefUserByAdvancementNo", advancementNo);
	}
	
	@Override
	public void setMentorRequestStatusToPassByRefUser(Integer refUser) throws Exception {
		ses.update(NS + ".setMentorRequestStatusToPassByRefUser", refUser);
	}

}
