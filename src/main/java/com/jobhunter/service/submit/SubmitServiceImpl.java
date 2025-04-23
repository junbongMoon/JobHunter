package com.jobhunter.service.submit;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.message.MessageDAO;
import com.jobhunter.dao.submit.SubmitDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.message.MessageDTO;
import com.jobhunter.model.message.MessageTargetInfoDTO;
import com.jobhunter.model.message.USERTYPE;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResume;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResumePageDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.RegistrationVO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmitAndUser;
import com.jobhunter.model.submit.Status;
import com.jobhunter.model.submit.SubmitFromRecruitVO;
import com.jobhunter.model.submit.SubmitSearchDTO;
import com.jobhunter.model.util.TenToFivePageVO;

import lombok.RequiredArgsConstructor;

/**
 * @author 문준봉
 *
 */
@Service
@RequiredArgsConstructor
public class SubmitServiceImpl implements SubmitService {

	/**
	 * <p>
	 * 이력서 DAO
	 * </p>
	 */
	private final SubmitDAO submitDAO;

	private final MessageDAO messageDAO;

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고 uid로 해당 공고에 제출 된 ResumDetailInfoBySubmit들을 조회하는 메서드
	 *         </p>
	 * 
	 * @param int            RecruitmentUid
	 * @param PageRequestDTO pageRequestDTO
	 * @return 제출된 상태의 이력서 상세정보를 담은 페이징에 대한 정보를 담은 객체
	 * @throws Exception
	 *
	 */
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public PageResponseDTO<ResumeDetailInfoBySubmit> getResumeWithAll(int RecruitmentUid, PageRequestDTO pageRequestDTO)
			throws Exception {

		int totalCount = submitDAO.selectTotalCountRowOfResumeByUid(RecruitmentUid);

		PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO = pagingProcess(pageRequestDTO, totalCount);

		List<ResumeDetailInfoBySubmit> resumeList = submitDAO
				.selectResumDetailInfoBySubmitByRecruitmentUid(RecruitmentUid, pageResponseDTO);

		// 각 이력서에 대해 첨부파일도 개별 조회해서 추가
		for (ResumeDetailInfoBySubmit resume : resumeList) {
			List<ResumeUpfileDTO> fileList = submitDAO.selectUpfileListByResume(resume.getResumeNo());
			resume.setFiles(fileList);
		}
		System.out.println(resumeList);

		pageResponseDTO.setBoardList(resumeList);

		return pageResponseDTO;
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         전체 페이지 수, 출력할 rowIndex, 현재 페이지 블럭, 시작 페이지 블럭, 끝 페이지 블럭을 저장하는 메서드
	 *         </p>
	 * 
	 * @param <T>
	 * @param PageRequestDTO pageRequestDTO
	 * @param int            totalRowCount
	 * @return 페이징에 대한 정보를 담은 객체
	 *
	 */
	private <T> PageResponseDTO<T> pagingProcess(PageRequestDTO pageRequestDTO, int totalRowCount) {
		PageResponseDTO<T> pageResponseDTO = new PageResponseDTO<>(pageRequestDTO.getPageNo(),
				pageRequestDTO.getRowCntPerPage());

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

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         제출내역의 상태값을 변경해주는 메서드
	 *         </p>
	 * 
	 * @param Status status
	 * @param int    resumePk
	 * @param int    recruitmentNoticePk
	 * @return 변경이 성공 됬으면 true, 실패했으면 false
	 *
	 */
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public boolean changeStatus(Status status, int resumePk, int recruitmentNoticePk) {
		boolean result = false;
		System.out.println("서비스 단" + status + ", " + resumePk + ", " + recruitmentNoticePk);

		if (submitDAO.updateStatusByRegistration(status, resumePk, recruitmentNoticePk) > 0) {
			result = true;

			// 상태 변경 후 메시지 전송
			if (result) {
				// 필요한 메시지 대상 정보 조회 (예: 유저 번호, 회사 번호 등)
				MessageTargetInfoDTO info = submitDAO.selectMessageTargetInfo(resumePk, recruitmentNoticePk);
				if (info != null) {
					int toUser = info.getUserNo();
					int fromCompany = info.getCompanyNo();
					String companyName = info.getCompanyName();
					String noticeTitle = info.getNoticeTitle();

					String title = "지원 상태 변경 알림";
					String content = "";

					// 상태별 메시지 분기 처리
					switch (status) {
					case PASS:
						content = String.format("[%s]의 [%s] 공고에 지원이 합격 처리되었습니다.", companyName, noticeTitle);
						break;
					case FAILURE:
						content = String.format("[%s]의 [%s] 공고에 지원이 불합격 처리되었습니다.", companyName, noticeTitle);
						break;
					case CHECKED:
						content = String.format("[%s]의 [%s] 공고에 제출된 이력서가 조회 되었습니다.", companyName, noticeTitle);
						break;
					case EXPIRED:
						content = String.format("[%s]의 [%s] 공고가 마감 되어 자동으로 상태가 변경되었습니다.", companyName, noticeTitle);
						break;
					default:
						content = String.format("[%s]의 [%s] 공고 지원 상태가 변경되었습니다.", companyName, noticeTitle);
						break;
					}

					MessageDTO msgDTO = MessageDTO.builder().toWho(toUser).fromWho(fromCompany)
							.toUserType(USERTYPE.USER).fromUserType(USERTYPE.COMPANY).title(title).content(content)
							.build();

					messageDAO.insertMessage(msgDTO);
				}
			}
		}

		return result;
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         마감기한이 지난 공고의 제출 상태가 WATING 인 것들을 EXPIRED로 변경하고 메세지를 보내는 기능
	 *         </p>
	 * 
	 * @param yesterDayStr
	 * @return 만료된 제출 상태의 갯수
	 * @throws Exception
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public int expiredToSubmitBetween(LocalDateTime start, LocalDateTime end) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);

		int updateCount = submitDAO.updateStatusToExpiredBetween(param);

		if (updateCount > 0) {
			List<Map<String, Object>> msgTargets = submitDAO.selectExpiredSubmitUserMessageInfoBetween(param);

			for (Map<String, Object> row : msgTargets) {
				int toUser = (Integer) row.get("userNo");
				int fromCompany = (Integer) row.get("companyNo");
				String companyName = (String) row.get("companyName");
				String noticeTitle = (String) row.get("noticeTitle");

				MessageDTO msgDTO = MessageDTO.builder().toWho(toUser).fromWho(fromCompany).toUserType(USERTYPE.USER)
						.fromUserType(USERTYPE.COMPANY).title("공고 마감 알림")
						.content(String.format("[%s]의 [%s] 공고가 마감되었습니다.", companyName, noticeTitle)).build();

				System.out.println(msgDTO.getContent());

				messageDAO.insertMessage(msgDTO);

			}
		}

		return updateCount;
	}

	/**
	 * @author 문준봉
	 *
	 *         <p>
	 *         공고에 제출이력의 상태가 WAITING인 것들을 전부 EXPIRED로 변경하고 메세지를 보내는 기능
	 *         </p>
	 * 
	 * @param uid 공고번호
	 * @throws Exception
	 *
	 */
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public void expiredEntireWatingRegByRecUid(int uid) throws Exception {
		// WAITING 상태인 제출 내역 조회
		List<RegistrationVO> result = submitDAO.selectRegistrationByUidAndStatus(uid, Status.WAITING);

		for (RegistrationVO reg : result) {
			if (reg.getStatus().equals(Status.WAITING)) {
				int resumePk = reg.getResumePk();
				int recruitmentNoticePk = reg.getRecruitmentNoticePk();

				// 대상자 정보 조회
				MessageTargetInfoDTO info = submitDAO.selectMessageTargetInfo(resumePk, recruitmentNoticePk);

				if (info != null) {
					int toUser = info.getUserNo();
					int fromCompany = info.getCompanyNo();
					String companyName = info.getCompanyName();
					String noticeTitle = info.getNoticeTitle();

					String content = String.format("[%s]의 [%s] 공고가 마감 되어 자동으로 상태가 변경되었습니다.", companyName, noticeTitle);

					MessageDTO msgDTO = MessageDTO.builder().toWho(toUser).fromWho(fromCompany)
							.toUserType(USERTYPE.USER).fromUserType(USERTYPE.COMPANY).title("공고 마감 알림").content(content)
							.build();

					messageDAO.insertMessage(msgDTO);
				}
			} else if (reg.getStatus().equals(Status.CHECKED)) {
				int resumePk = reg.getResumePk();
				int recruitmentNoticePk = reg.getRecruitmentNoticePk();

				// 대상자 정보 조회
				MessageTargetInfoDTO info = submitDAO.selectMessageTargetInfo(resumePk, recruitmentNoticePk);

				if (info != null) {
					int toUser = info.getUserNo();
					int fromCompany = info.getCompanyNo();
					String companyName = info.getCompanyName();
					String noticeTitle = info.getNoticeTitle();

					String content = String.format("[%s]의 [%s] 공고가 마감 되었습니다.", companyName, noticeTitle);

					MessageDTO msgDTO = MessageDTO.builder().toWho(toUser).fromWho(fromCompany)
							.toUserType(USERTYPE.USER).fromUserType(USERTYPE.COMPANY).title("공고 마감 알림").content(content)
							.build();

					messageDAO.insertMessage(msgDTO);

				}
			}

			// 상태 일괄 변경 (WAITING → EXPIRED)
			submitDAO.updateExpiredByRecUid(uid);
		}

	}
	
	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 공고uid를 기반으로 검색조건에 맞는 신청서를 페이징해서 가져오는 메서드 
	 * </p>
	 * 
	 * @param RecruitmentWithResumePageDTO 검색조건과 기업uid등이 담긴 객체
	 * @return 조건에 맞는 공고들
	 * @throws Exception 
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public TenToFivePageVO<SubmitFromRecruitVO> selectResumesByRecruitmentUid(SubmitSearchDTO dto) throws Exception {
	    int totalItems = submitDAO.countResumesByRecruitmentUid(dto);
	    List<SubmitFromRecruitVO> list = submitDAO.selectResumesByRecruitmentUid(dto);

	    TenToFivePageVO<SubmitFromRecruitVO> vo = new TenToFivePageVO<SubmitFromRecruitVO>(list, dto.getPage(), totalItems);

	    return vo;
	}
	
	/**
	 *  @author 육근우
	 *
	 * <p>
	 * 신청서의 대상 기업이 본인이거나 관리자가 접근했을 경우에만 신청서 하나만 이력서포함해서 가져오는 메서드
	 * </p>
	 * 
	 * @param int registrationNo 신청서 pk
	 * @return 신청서 상세정보
	 *
	 */
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public ResumeDetailInfoBySubmitAndUser selectSubmitAndResumeDetailInfo(int registrationNo, AccountVO account) throws Exception {
		
		int companyUid = submitDAO.getCompanyUidByRegistrationNo(registrationNo);
		if((companyUid == account.getUid() && account.getAccountType() == AccountType.COMPANY) || account.getIsAdmin() == "Y") {
			return submitDAO.selectSubmitAndResumeDetailInfo(registrationNo);
		}
	    return null;
	}
}
