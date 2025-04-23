package com.jobhunter.service.recruitmentnotice;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.jobtype.JobDAO;
import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.dao.region.RegionDAO;
import com.jobhunter.dao.submit.SubmitDAO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.Application;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentStats;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResume;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResumePageDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.model.recruitmentnotice.TenToFivePageVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.model.util.FileStatus;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RecruitmentNoticeServiceImpl implements RecruitmentNoticeService {

	// DAO단
	/**
	 * <p> 
	 * 공고 DAO
	 * </p>
	 */
	private final RecruitmentNoticeDAO recdao;
	/**
	 * <p> 
	 * 지역, 시군구 DAO
	 * </p>
	 */
	private final RegionDAO regiondao;
	/**
	 * <p> 
	 * 산업군, 직업군 DAO
	 * </p>
	 */
	private final JobDAO jobdao;
	
	private final SubmitDAO submitdao;
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고를 저장하는 메서드
	 * </p>
	 * 
	 * @param RecruitmentNoticeDTO recruitmentNoticeDTO
	 * @param List<AdvantageDTO> advantageList
	 * @param List<ApplicationDTO> applicationList
	 * @param List<RecruitmentnoticeBoardUpfiles> fileList
	 * @return 저장에 성공 하면 true, 실패하면 false
	 * @throws Exception
	 *
	 */
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

		jobdao.insertMajorCategoryWithRecruitmentnotice(recNo, recruitmentNoticeDTO.getMajorcategoryNo());

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
		
		recdao.insertCDLogForRecruitment(recNo);

		

		return result;
	}


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * uid로 공고를 조회하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 공고의 상세정보
	 * @throws Exception
	 *
	 */
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
			
			// 여기서 제출한 이력List select
			
			List<UserVO> applicants = submitdao.selectUsersWhoApplied(uid); // 신청한 유저 리스트 select
			RecruitmentStats stats = calculateStats(applicants);
			detailInfo.setStats(stats);
			System.out.println("지원한 유저의 통계 : " + detailInfo.getStats());
			
		}
		

		return detailInfo;
	}
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고를 검색어에 따라 페이징해서 조회 해오는 메서드
	 * </p>
	 * 
	 * @param PageRequestDTO pageRequestDTO
	 * @return 공고의 상세정보 리스트를 담은 페이징에 대한 정보 객체
	 * @throws Exception
	 *
	 */
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public PageResponseDTO<RecruitmentDetailInfo> getEntireRecruitment(PageRequestDTO pageRequestDTO) throws Exception {

	    String searchType = pageRequestDTO.getSearchType();
	    String searchWord = pageRequestDTO.getSearchWord();
	    String sortOption = pageRequestDTO.getSortOption(); // ⭐ 새로 추가된 정렬 옵션

	    int totalRowCnt;

	    if ("highPay".equals(sortOption) || "lowPay".equals(sortOption)) {
	        totalRowCnt = recdao.getTotalCountRow(); // 정렬만 할 경우
	    } else if (StringUtils.hasText(searchType) && StringUtils.hasText(searchWord)) {
	        totalRowCnt = recdao.getSearchResultRowCount(pageRequestDTO); // 검색어 있을 경우
	    } else {
	        totalRowCnt = recdao.getTotalCountRow(); // 기본
	    }

	    PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO = pagingProcess(pageRequestDTO, totalRowCnt);

	    // ⚠️ 정렬 기준을 DAO로 전달하기 위해 PageRequestDTO 또는 PageResponseDTO에 sortOption 포함되어야 함
	    pageResponseDTO.setSortOption(sortOption);

	    List<RecruitmentDetailInfo> boardList = recdao.selectRecruitmentWithKeyword(pageResponseDTO);

	    if (boardList == null) {
	        boardList = Collections.emptyList();
	    } else {
	        for (RecruitmentDetailInfo info : boardList) {
	            int uid = info.getUid();
	            info.setApplication(recdao.getApplications(uid));
	            info.setAdvantage(recdao.getAdvantages(uid));
	            info.setFileList(recdao.getFileList(uid));
	        }
	    }

	    pageResponseDTO.setBoardList(boardList);
	    return pageResponseDTO;
	}


	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 페이징 하는 메서드
	 * </p>
	 * 
	 * @param <T>
	 * @param pageRequestDTO
	 * @param totalRowCount
	 * @return <T>리스트를 담은 페이징에 대한 정보 객체
	 *
	 */
	private <T> PageResponseDTO<T> pagingProcess(PageRequestDTO pageRequestDTO, int totalRowCount) {
	    PageResponseDTO<T> pageResponseDTO = new PageResponseDTO<>(
	        pageRequestDTO.getPageNo(),
	        pageRequestDTO.getRowCntPerPage()
	    );
	    
	    System.out.println("pageresponsedto : " + pageResponseDTO);
 
	    pageResponseDTO.setTotalRowCnt(totalRowCount); // 전체 데이터 수

	    if (StringUtils.hasText(pageRequestDTO.getSearchType())) {
	        pageResponseDTO.setSearchType(pageRequestDTO.getSearchType());
	        pageResponseDTO.setSearchWord(pageRequestDTO.getSearchWord());
	    }

	    pageResponseDTO.setTotalPageCnt();       // 전체 페이지 수
	    pageResponseDTO.setStartRowIndex();      // 출력 시작할 rowIndex번호
	    pageResponseDTO.setBlockOfCurrentPage(); // 현재 페이지가 몇번째 블럭에 있는가?
	    pageResponseDTO.setStartPageNumPerBlock();
	    pageResponseDTO.setEndPageNumPerBlock();

	    return pageResponseDTO;
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * uid를 매개변수로 공고를 삭제하는 메서드
	 * </p>
	 * 
	 * @param uid
	 * @return 공고가 삭제 되면 true, 삭제 되지 않으면 false
	 * @throws Exception
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean removeRecruitmentByUid(int uid) throws Exception {
		boolean result = false;

		if (recdao.deleteRecruitmentByUid(uid) > 0) {
			result = true;
		}
		// 삭제 로그 추가
		recdao.insertDeleteLogByRecruitment(uid);

		return result;
	}


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고를 수정하는 메서드
	 * </p>
	 * 
	 * @param RecruitmentNoticeDTO dto
	 * @param List<AdvantageDTO> newAdvList
	 * @param List<ApplicationDTO> newAppList
	 * @param List<RecruitmentnoticeBoardUpfiles> modifyFileList
	 * @param RecruitmentDetailInfo existing
	 * @param int uid
	 * @throws Exception
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public void modifyRecruitmentNotice(RecruitmentNoticeDTO dto, List<AdvantageDTO> newAdvList,
			List<ApplicationDTO> newAppList, List<RecruitmentnoticeBoardUpfiles> modifyFileList,
			RecruitmentDetailInfo existing, int uid) throws Exception {

		// Step 1: 공고 기본 정보 수정
		recdao.updateRecruitmentNotice(dto);
		System.out.println("수정할 파일 리스트 : " + modifyFileList);

		// Step 2: 우대 조건 비교 후 변경
		List<Advantage> oldAdvList = existing.getAdvantage();
		for (Advantage old : oldAdvList) {
			// anyMatch: newAppList 중 하나라도 같은 method가 있으면 true
			boolean existsInNew = newAdvList.stream()
					.anyMatch(newAdv -> newAdv.getAdvantageType().equals(old.getAdvantageType()));
			if (!existsInNew) {
				recdao.deleteAdvantage(uid, old.getAdvantageType()); // <-- 여기 수정
			}
		}

		for (AdvantageDTO newAdv : newAdvList) {
			boolean existsInOld = oldAdvList.stream()
					.anyMatch(old -> old.getAdvantageType().equals(newAdv.getAdvantageType()));
			if (!existsInOld) {
				newAdv.setRecruitmentNoticeUid(uid);
				recdao.insertAdvantageWithRecruitmentNotice(newAdv);
			}
		}

		// Step 3: 면접방식 비교 후 변경 (method가 같을 때 삭제)
		List<Application> oldAppList = existing.getApplication();
		for (Application old : oldAppList) {
			// anyMatch: newAppList 중 하나라도 같은 method가 있으면 true
			boolean existsInNew = newAppList.stream().anyMatch(newApp -> newApp.getMethod() == old.getMethod());
			
			if (!existsInNew) {
				// method가 사라졌다면 삭제
				recdao.deleteApplication(uid, old.getMethod());
			}
		}

		// 새로운 면접 방식이면 추가
		for (ApplicationDTO newApp : newAppList) {
			boolean existsInOld = oldAppList.stream().anyMatch(old -> old.getMethod() == newApp.getMethod());

			if (!existsInOld) {
				newApp.setRecruitmentNoticeUid(uid);
				recdao.insertApplicationWithRecruitmentNotice(newApp);
			}
		}

		// Step 4: 파일 비교 후 변경
		List<RecruitmentnoticeBoardUpfiles> oldFileList = existing.getFileList();
		for (RecruitmentnoticeBoardUpfiles oldFile : oldFileList) {
			boolean stillExists = modifyFileList.stream()
					.anyMatch(newFile -> newFile.getOriginalFileName().equals(oldFile.getOriginalFileName()));
			if (!stillExists) {
				recdao.deleteFileFromDatabase(uid);; // DB + 물리 파일도 제거 필요
			}
		}
		for (RecruitmentnoticeBoardUpfiles newFile : modifyFileList) {
		    boolean existsInOld = oldFileList.stream()
		        .anyMatch(oldFile -> oldFile.getOriginalFileName().equals(newFile.getOriginalFileName()));

		    if (!existsInOld && FileStatus.NEW.equals(newFile.getStatus())) {
		        newFile.setRefrecruitmentnoticeNo(uid);
		        recdao.insertRecruitmentFile(newFile);
		    }
		}

		// Step 5: 직업군, 지역 등 외래키 정보 갱신
		jobdao.updateMajorCategoryWithRecruitmentnotice(uid, dto.getMajorcategoryNo());
		jobdao.updateSubCategoryWithRecruitmentnotice(uid, dto.getSubcategoryNo());
		regiondao.updateRegionWithRecruitmentNotice(uid, dto.getRegionNo());
		regiondao.updateSigunguWithRecruitmentNotice(uid, dto.getSigunguNo());
	}
    
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 파일을 삭제하는 메서드
	 * </p>
	 * 
	 * @param int boardUpFileNo
	 *
	 */
	@Override
	public void deleteFileFromDatabase(int boardUpFileNo) {
		 recdao.deleteFileFromDatabase(boardUpFileNo);
		
	}
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 내가 작성한 공고글 가져오는 메서드
	 * </p>
	 * 
	 * @param int companyUid
	 * @param PageRequestDTO pageRequestDTO
	 * @return 공고정보를 담은 페이징에 대한 정보 객체
	 *
	 */
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public PageResponseDTO<RecruitmentNotice> getRecruitmentByCompanyUid(int companyUid, PageRequestDTO pageRequestDTO) {
	    
	    int totalCount = recdao.getTotalCountRowByCompanyUid(companyUid);

	    PageResponseDTO<RecruitmentNotice> pageResponseDTO = pagingProcess(pageRequestDTO, totalCount);

	    List<RecruitmentNotice> boardList = recdao.selectRecruitmentByCompanyUid(companyUid, pageResponseDTO);
	    if (boardList == null) {
	        boardList = Collections.emptyList();
	    }

	    pageResponseDTO.setBoardList(boardList);
	    return pageResponseDTO;
	}


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *  이전 공고를 조회하는 메서드
	 * </p>
	 * 
	 * @param uid 현재공고번호
	 * @return RecruitmentNotice 이전공고
	 * @throws Exception
	 *
	 */
	@Override
	public RecruitmentNotice getPreviousPost(int uid) throws Exception {
	    return recdao.selectPreviousPost(uid);
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 다음 공고를 조회하는 메서드
	 * </p>
	 * 
	 * @param uid 현재공고번호
	 * @return RecruitmentNotice 다음공고
	 * @throws Exception
	 *
	 */
	@Override
	public RecruitmentNotice getNextPost(int uid) throws Exception {
	    return recdao.selectNextPost(uid);
	}


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고의 마감기한을 now()로 만드는 메서드
	 * </p>
	 * 
	 * @param uid
	 * @return
	 * @throws Exception
	 *
	 */
	@Override
	public boolean modifyDueDateByUid(int uid) throws Exception {
		boolean result = false;
		if(recdao.updateDuedateExpireByUid(uid) > 0) {
			result = true;
		}
		
		return result;
	}
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 조회수 처리를 위한 메서드 
	 * </p>
	 * 
	 * @param uid 공고의 pk
	 * @param viewerUid 유저의 pk
	 * @return 공고의 상세 정보
	 * @throws Exception
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public RecruitmentDetailInfo getRecruitmentWithViewLog(int uid, int viewerUid) throws Exception {
	    // 조회 중복 체크
	    boolean alreadyViewed = recdao.isRecentlyViewed(viewerUid, uid, "RECRUIT");

	    if (!alreadyViewed && viewerUid > 0) {
	        recdao.insertViewsLog(uid, viewerUid, "RECRUIT");
	        recdao.increaseRecruitmentViewCnt(uid);
	    }

	    return getRecruitmentByUid(uid);
	}

	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 기업uid를 기반으로 검색조건에 맞는 공고를 페이징해서 가져오는 메서드 
	 * </p>
	 * 
	 * @param RecruitmentWithResumePageDTO 검색조건과 기업uid등이 담긴 객체
	 * @return 조건에 맞는 공고들
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public TenToFivePageVO<RecruitmentWithResume> searchRecruitments(RecruitmentWithResumePageDTO dto) {
	    int totalItems = recdao.countRecruitments(dto);
	    List<RecruitmentWithResume> list = recdao.searchRecruitments(dto);

	    TenToFivePageVO<RecruitmentWithResume> vo = new TenToFivePageVO<RecruitmentWithResume>(list, dto.getPage(), totalItems);

	    return vo;
	}
	
	public RecruitmentStats calculateStats(List<UserVO> applicants) {
	    RecruitmentStats stats = new RecruitmentStats();

	    int ageSum = 0;
	    int ageCount = 0;

	    for (UserVO user : applicants) {
	    	
	    	 if (user.getGender() != null) {
	             if ("MALE".equalsIgnoreCase(user.getGender().toString())) {
	                 stats.setMaleCount(stats.getMaleCount() + 1);
	             } else if ("FEMALE".equalsIgnoreCase(user.getGender().toString())) {
	                 stats.setFemaleCount(stats.getFemaleCount() + 1);
	             }
	         }


	        if (user.getAge() != null) {
	            int age = user.getAge();
	            ageSum += age;
	            ageCount++;

	            if (age < 20) stats.setTeens(stats.getTeens() + 1);
	            else if (age < 30) stats.setTwenties(stats.getTwenties() + 1);
	            else if (age < 40) stats.setThirties(stats.getThirties() + 1);
	            else if (age < 50) stats.setForties(stats.getForties() + 1);
	            else stats.setFiftiesOrAbove(stats.getFiftiesOrAbove() + 1);
	        } else {
	            stats.setUnknownAgeCount(stats.getUnknownAgeCount() + 1);
	        }
	    }

	    stats.setTotalApplicants(applicants.size());
	    if (ageCount > 0) {
	        stats.setAverageAge(ageSum / (double) ageCount);
	    }

	    return stats;
	}

}
