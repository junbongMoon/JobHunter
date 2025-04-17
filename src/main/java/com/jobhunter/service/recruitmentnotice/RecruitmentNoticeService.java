package com.jobhunter.service.recruitmentnotice;

import java.util.Date;
import java.util.List;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.Advantage;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

public interface RecruitmentNoticeService {
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고를 입력하는 메서드
	 * </p>
	 * 
	 * @param RecruitmentNoticeDTO recruitmentNoticeDTO
	 * @param List<AdvantageDTO> advantageList
	 * @param List<ApplicationDTO> applicationList
	 * @param List<RecruitmentnoticeBoardUpfiles> fileList
	 * @return 저장에 성공하면 true, 실패하면 false
	 * @throws Exception
	 *
	 */
	boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO, List<AdvantageDTO> advantageList, List<ApplicationDTO> applicationList, List<RecruitmentnoticeBoardUpfiles> fileList) throws Exception;
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * uid로 공고를 조회하는 메서드
	 * </p>
	 * 
	 * @param uid
	 * @return
	 * @throws Exception
	 *
	 */
	RecruitmentDetailInfo getRecruitmentByUid(int uid) throws Exception;
		 
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고 전체를 조회하는 메서드(템플릿 제외)
	 * </p>
	 * 
	 * @param PageRequestDTO pageRequestDTO
	 * @return 공고의 상세정보 리스트를 담은 페이징에 대한 정보를 담은 객체
	 * @throws Exception
	 *
	 */
	PageResponseDTO<RecruitmentDetailInfo> getEntireRecruitment(PageRequestDTO pageRequestDTO) throws Exception;
		
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고를 삭제하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 삭제에 성공하면 true, 실패하면 false
	 * @throws Exception
	 *
	 */
	boolean removeRecruitmentByUid(int uid) throws Exception;
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고를 수정하는 메서드
	 * </p>
	 * 
	 * @param RecruitmentNoticeDTO dto
	 * @param List<AdvantageDTO> advantageList
	 * @param List<ApplicationDTO> applicationList
	 * @param List<RecruitmentnoticeBoardUpfiles> fileList
	 * @param RecruitmentDetailInfo existing
	 * @param int uid
	 * @throws Exception
	 *
	 */
	void modifyRecruitmentNotice(RecruitmentNoticeDTO dto, List<AdvantageDTO> advantageList,
			List<ApplicationDTO> applicationList, List<RecruitmentnoticeBoardUpfiles> fileList,
			RecruitmentDetailInfo existing, int uid) throws Exception;
	// 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 파일을 삭제하는 메서드
	 * </p>
	 * 
	 * @param boardUpFileNo
	 *
	 */
	void deleteFileFromDatabase(int boardUpFileNo);
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	회사 pk를 매개변수로 받아 공고만 조회하는 메서드
	 * </p>
	 * 
	 * @param companyUid
	 * @param pageRequestDTO
	 * @return 공고의 정보를 담은 페이징에 대한 정보를 담은 객체
	 *
	 */
	PageResponseDTO<RecruitmentNotice> getRecruitmentByCompanyUid(int companyUid, PageRequestDTO pageRequestDTO);


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 이전 공고를 조회하는 메서드
	 * </p>
	 * 
	 * @param uid 현재 공고번호
	 * @return RecruitmentNotice 이전 공고
	 * @throws Exception
	 *
	 */
	RecruitmentNotice getPreviousPost(int uid) throws Exception;


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 다음 공고를 조회하는 메서드
	 * </p>
	 * 
	 * @param uid 다음 공고 번호
	 * @return RecruitmentNotice 다음 공고
	 * @throws Exception
	 *
	 */
	RecruitmentNotice getNextPost(int uid) throws Exception;


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고의 마감기한을 만료 시키는 메서드
	 * </p>
	 * 
	 * @param uid (공고의 pk)
	 * @return 성공하면 true, 실패하면 false
	 * @throws Exception
	 *
	 */
	boolean modifyDueDateByUid(int uid) throws Exception;


	public RecruitmentDetailInfo getRecruitmentWithViewLog(int uid, int viewerUid) throws Exception;
	

}
