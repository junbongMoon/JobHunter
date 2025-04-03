package com.jobhunter.service.recruitmentnotice;

import java.util.Collections;
import java.util.List;
import java.util.NoSuchElementException;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.jobtype.JobDAO;
import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.dao.region.RegionDAO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.Application;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RecruitmentNoticeServiceImpl implements RecruitmentNoticeService {

	// DAO단
	private final RecruitmentNoticeDAO recdao;
	private final RegionDAO regiondao;
	private final JobDAO jobdao;

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO, List<AdvantageDTO> advantageList,
			List<ApplicationDTO> applicationList, List<RecruitmentnoticeBoardUpfiles> fileList) throws Exception {
		boolean result = false;
		int CompanyUid = recruitmentNoticeDTO.getRefCompany();
		int recNo = 0;

//		if(recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {
//			result = true;
//		}

		// 공고를 제출하는 메서드
		if (recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {

			recNo = recdao.selectRecentRecruitment(CompanyUid);
		}
		
		System.out.println(recNo);
		System.out.println(recruitmentNoticeDTO);
		// 우대 조건을 입력하는 메서드 호출
		if (!advantageList.isEmpty()) {
			// advantageList에서 하나씩 꺼내서 insert
			for (AdvantageDTO advDTO : advantageList) {
				advDTO.setRecruitmentNoticeUid(recNo);
				// 여기서 insert
				recdao.insertAdvantageWithRecruitmentNotice(advDTO);
			}
		}
		if (!applicationList.isEmpty()) {
			for (ApplicationDTO aplDTO : applicationList) {
				aplDTO.setRecruitmentNoticeUid(recNo);
				// 여기서 insert
				recdao.insertApplicationWithRecruitmentNotice(aplDTO);
			}
		}

		jobdao.insertMajorCategoryWithRecruitmentnotice(recNo,
				recruitmentNoticeDTO.getMajorcategoryNo());

		jobdao.insertSubCategoryWithRecruitmentnotice(recNo, recruitmentNoticeDTO.getSubcategoryNo());

		regiondao.insertRegionWithRecruitmentNotice(recNo, recruitmentNoticeDTO.getRegionNo());

		// 여기서 insert
		regiondao.insertSigunguWithRecruitmentNotice(recNo, recruitmentNoticeDTO.getSigunguNo());

		if (fileList.size() > 0) {
			for (RecruitmentnoticeBoardUpfiles file : fileList) {
				// 여기서 insert
				file.setRefrecruitmentnoticeNo(recNo);
				recdao.insertRecruitmentFile(file);
			}
		}

		return result;
	}

	// uid(pk)로 공고를 조회하는 메서드
	@Override
	public RecruitmentDetailInfo getRecruitmentByUid(int uid) throws Exception {

		RecruitmentDetailInfo detailInfo = recdao.selectRecruitmentByUid(uid);

		if (detailInfo != null) {
			List<Application> applications = recdao.getApplications(uid);
			List<Advantage> advantages = recdao.getAdvantages(uid);
			List<RecruitmentnoticeBoardUpfiles> fileList = recdao.getFileList(uid);

			detailInfo.setApplication(applications != null ? applications : Collections.emptyList());
			detailInfo.setAdvantage(advantages != null ? advantages : Collections.emptyList());
			detailInfo.setFileList(fileList != null ? fileList : Collections.emptyList());
		}
		System.out.println(detailInfo);

		return detailInfo;
	}

	// 공고 전체를 조회하는 메서드
	@Override
	public PageResponseDTO<RecruitmentDetailInfo> getEntireRecruitment(PageRequestDTO pageRequestDTO) throws Exception {

		// 전체 공고수 조회
		int totalRowCnt = recdao.selectRecruitmentTotalCount(pageRequestDTO);
		// pageResponseDTO 설정
		PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO = pagingProcess(pageRequestDTO);

		// 전체 검색어에 따라 공고를 가져오는 메서드
		List<RecruitmentDetailInfo> boardList = recdao.selectRecruitmentWithKeyword(pageResponseDTO);
		System.out.println(boardList);

		if (boardList == null) {
			boardList = Collections.emptyList(); // 빈 리스트로 처리

		} else {
			//
			for (RecruitmentDetailInfo info : boardList) {
				if (info != null) {
					int uid = info.getUid();

					List<Application> applications = recdao.getApplications(uid);
					List<Advantage> advantages = recdao.getAdvantages(uid);
					List<RecruitmentnoticeBoardUpfiles> fileList = recdao.getFileList(uid);

					info.setApplication(applications != null ? applications : Collections.emptyList());
					info.setAdvantage(advantages != null ? advantages : Collections.emptyList());
					info.setFileList(fileList != null ? fileList : Collections.emptyList());
				} else {
					throw new NoSuchElementException();
				}
			}
		}

		// PageResponseDTO에 넣어주기
		pageResponseDTO.setBoardList(boardList);

		System.out.println(pageResponseDTO);

		return pageResponseDTO;
	}
	
	// 페이징하여 공고를 출력하는 메서드
	private PageResponseDTO<RecruitmentDetailInfo> pagingProcess(PageRequestDTO pageRequestDTO) throws Exception {
		PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO = new PageResponseDTO<RecruitmentDetailInfo>(
				pageRequestDTO.getPageNo(), pageRequestDTO.getRowCntPerPage());

		// 기본 페이징
		if (StringUtils.hasText(pageRequestDTO.getSearchType())) {
			// 검색 안함
			pageResponseDTO.setTotalRowCnt(recdao.getTotalCountRow()); // 전체 데이터 수
		} else if (!StringUtils.hasText(pageRequestDTO.getSearchType())) {
			// 검색 함
			pageResponseDTO.setSearchType(pageRequestDTO.getSearchType());
			pageResponseDTO.setSearchWord(pageRequestDTO.getSearchWord());

			pageResponseDTO.setTotalRowCnt(recdao.getSearchResultRowCount(pageRequestDTO));
		}

		pageResponseDTO.setTotalPageCnt(); // 전체 페이지 수
		pageResponseDTO.setStartRowIndex(); // 출력 시작할 rowIndex번호

		// 페이징 블럭을 표시하기 위해
		pageResponseDTO.setBlockOfCurrentPage(); // 현재 페이지가 몇번째 블럭에 있는가?
		pageResponseDTO.setStartPageNumPerBlock(); // 블럭에서의 시작페이지 번호
		pageResponseDTO.setEndPageNumPerBlock(); // 블럭에서의 끝페이지 번호

		return pageResponseDTO;

	}
	
	// uid를 매개변수로 공고를 삭제하는 메서드
	@Override
	public boolean removeRecruitmentByUid(int uid) {
		boolean result = false;
		
		if(recdao.deleteRecruitmentByUid(uid) > 0) {
			result = true;
		}
		
		return result;
	}

}
