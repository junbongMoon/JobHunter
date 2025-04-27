package com.jobhunter.service.advancement;

import java.io.File;
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

	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public boolean modifyAdvancementByMento(AdvancementDTO advancementDTO, List<AdvancementUpFileVODTO> fileList)
	        throws Exception {

	    boolean result = false;

	    // 1. 게시물 내용 수정
	    if (advancementDAO.updateAdvancementByMento(advancementDTO) > 0) {
	        int advancementNo = advancementDTO.getAdvancementNo();

	        // 2. 기존 파일들 모두 삭제 (DB상에서)
	        advancementDAO.deleteFilesByAdvancementNo(advancementNo);

	        // 3. 세션에 있는 새로운 파일들 다시 저장
	        if (fileList != null && !fileList.isEmpty()) {
	            for (AdvancementUpFileVODTO file : fileList) {
	                file.setStatus(FileStatus.COMPLETE);
	                file.setRefAdvancementNo(advancementNo);
	                advancementDAO.insertAdvancementFileUpload(file);
	            }
	        }

	        result = true;
	    }

	    return result;
	}
	
	@Transactional
	@Override
	public boolean deleteAdvancementById(int advancementNo, String realPath) throws Exception {
	    // 1. 첨부파일 목록 조회
	    List<AdvancementUpFileVODTO> fileList = advancementDAO.getfileListByAdvancement(advancementNo);

	    // 2. 서버에 저장된 실제 파일 삭제
	    if (fileList != null && !fileList.isEmpty()) {
	        for (AdvancementUpFileVODTO file : fileList) {
	            // 여기서 넘겨받은 realPath 사용
	            String mainPath = realPath + file.getNewFileName();  // 진짜 파일 경로
	            String thumbPath = realPath + file.getThumbFileName(); // 썸네일 파일 경로

	            File mainFile = new File(mainPath.replace("/", File.separator));
	            File thumbFile = new File(thumbPath.replace("/", File.separator));

	            if (mainFile.exists()) {
	                mainFile.delete();
	            }
	            if (thumbFile.exists()) {
	                thumbFile.delete();
	            }
	        }
	    }

	    // 3. DB에서 파일정보 삭제
	    advancementDAO.deleteFilesByAdvancementNo(advancementNo);

	    // 4. 게시글 삭제
	    int result = advancementDAO.deleteAdvancementById(advancementNo);

	    return result > 0;
	}

}
