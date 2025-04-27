package com.jobhunter.service.advancement;

import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.advancement.AdvancementDAO;
import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.prboard.PRBoardVO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
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
	    AdvancementVO advancement = advancementDAO.selectAdvancementByAdvancementNo(advancementNo);

	    if (advancement != null && advancement.getAdvancementNo() > 0) {
	        advancement.setFileList(advancementDAO.getfileListByAdvancement(advancement.getAdvancementNo()));

	        if (advancement.getPostDate() != null) {
	            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
	            advancement.setFormattedPostDate(advancement.getPostDate().format(formatter));
	        }
	    }
	    
	    System.out.println("advancement : " + advancement);

	    return advancement;
	}

	@Override
	public PageResponseDTO<AdvancementVO> getAdvancementListByUid(int uid, PageRequestDTO pageRequestDTO)
			throws Exception {
		int totalRowCnt;

		if (StringUtils.hasText(pageRequestDTO.getSearchType())
				&& StringUtils.hasText(pageRequestDTO.getSearchWord())) {
			totalRowCnt = advancementDAO.getSearchResultRowCount(uid, pageRequestDTO);
		} else {
			totalRowCnt = advancementDAO.getTotalCountRow(uid);
		}

		PageResponseDTO<AdvancementVO> pageResponseDTO = pagingProcess(pageRequestDTO, totalRowCnt);

		List<AdvancementVO> boardList = advancementDAO.selectAdvancementListByPaging(uid, pageResponseDTO);

		if (boardList == null) {
			boardList = Collections.emptyList();
		} else {
			for (AdvancementVO info : boardList) {
				info.setFileList(advancementDAO.getfileListByAdvancement(info.getAdvancementNo()));
			    if (info.getPostDate() != null) {
			        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
			        info.setFormattedPostDate(info.getPostDate().format(formatter));
			    }
			}
		}
		System.out.println("boardList : " + boardList);

		pageResponseDTO.setBoardList(boardList);
		return pageResponseDTO;
	}

	private <T> PageResponseDTO<T> pagingProcess(PageRequestDTO pageRequestDTO, int totalRowCount) {
		PageResponseDTO<T> pageResponseDTO = new PageResponseDTO<>(pageRequestDTO.getPageNo(),
				pageRequestDTO.getRowCntPerPage());

		System.out.println("pageresponsedto : " + pageResponseDTO);

		pageResponseDTO.setTotalRowCnt(totalRowCount); // 전체 데이터 수

		if (StringUtils.hasText(pageRequestDTO.getSearchType())) {
			pageResponseDTO.setSearchType(pageRequestDTO.getSearchType());
			pageResponseDTO.setSearchWord(pageRequestDTO.getSearchWord());
		}

		pageResponseDTO.setTotalPageCnt(); // 전체 페이지 수
		pageResponseDTO.setStartRowIndex(); // 출력 시작할 rowIndex번호
		pageResponseDTO.setBlockOfCurrentPage(); // 현재 페이지가 몇번째 블럭에 있는가?
		pageResponseDTO.setStartPageNumPerBlock();
		pageResponseDTO.setEndPageNumPerBlock();

		return pageResponseDTO;
	}

}
