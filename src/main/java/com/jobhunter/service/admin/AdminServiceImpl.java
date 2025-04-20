package com.jobhunter.service.admin;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.admin.AdminDAO;
import com.jobhunter.dao.message.MessageDAO;
import com.jobhunter.dao.report.ReportDAO;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.message.MessageDTO;
import com.jobhunter.model.message.USERTYPE;
import com.jobhunter.model.report.ReportMessageVO;
import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

/**
 * 관리자 서비스 구현 클래스입니다.
 * <p>
 * 관리자 페이지에서 필요한 기능들을 구현합니다.
 * </p>
 * 
 * @author 유지원
 */
@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

	private final AdminDAO dao;
	private final MessageDAO messageDAO;
	private final ReportDAO reportDAO;

	@Override
	public List<UserVO> getAllUsers() throws Exception {
		return dao.getAllUsers();
	}

	@Override
	public UserVO getUserById(int uid) throws Exception {
		return dao.getUserById(uid);
	}

	@Override
	public List<UserVO> getUsersBySearch(String searchType, String searchKeyword, String statusFilter, int page,
			int pageSize) throws Exception {
		return dao.getUsersBySearch(searchType, searchKeyword, statusFilter, page, pageSize);
	}

	@Override
	public int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception {
		return dao.getTotalUserCount(searchType, searchKeyword, statusFilter);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean blockUser(int uid, Timestamp blockDeadline, String reason, int adminUid) throws Exception {
		boolean result = dao.blockUser(uid, blockDeadline.toString(), reason) > 0;

		// 날짜 포맷 설정
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분");

		// 포맷된 날짜 문자열 만들기
		String formattedDate = sdf.format(blockDeadline);

		if (result) {
			// 정지된 유저 정보 조회
			UserVO user = dao.getUserById(uid);
			if (user != null) {
				// 메시지 생성
				String content = String.format("[%s]님 계정이 정지 처리 되었습니다. 정지 해제일은 [%s] 입니다.", user.getUserName(),
						formattedDate);

				// 메시지 저장
				MessageDTO messageDTO = MessageDTO.builder().toWho(uid).fromWho(adminUid).toUserType(USERTYPE.USER)
						.fromUserType(USERTYPE.ADMIN).title("계정 정지 알림").content(content).build();

				messageDAO.insertMessage(messageDTO);
			}
		}

		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean unblockUser(int uid) throws Exception {
		return dao.unblockUser(uid) > 0;
	}

	// 기업 관련 메서드 구현
	@Override
	public List<CompanyVO> getAllCompanies() throws Exception {
		return dao.getAllCompanies();
	}

	@Override
	public CompanyVO getCompanyById(int uid) throws Exception {
		return dao.getCompanyById(uid);
	}

	@Override
	public List<CompanyVO> getCompaniesBySearch(String searchType, String searchKeyword, String statusFilter, int page,
			int pageSize) throws Exception {
		return dao.getCompaniesBySearch(searchType, searchKeyword, statusFilter, page, pageSize);
	}

	@Override
	public int getTotalCompanyCount(String searchType, String searchKeyword, String statusFilter) throws Exception {
		return dao.getTotalCompanyCount(searchType, searchKeyword, statusFilter);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean blockCompany(int uid, Timestamp blockDeadline, String reason, int adminUid) throws Exception {
		boolean result = dao.blockCompany(uid, blockDeadline.toString(), reason) > 0;

		// 날짜 포맷 설정
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분");

		// 포맷된 날짜 문자열 만들기
		String formattedDate = sdf.format(blockDeadline);

		if (result) {
			// 정지된 기업 정보 조회
			CompanyVO company = dao.getCompanyById(uid);
			if (company != null) {
				// 메시지 생성
				String content = String.format("[%s]님 계정이 정지 처리 되었습니다. 정지 해제일은 [%s] 입니다.", company.getCompanyId(),
						formattedDate);

				// 메시지 저장
				MessageDTO messageDTO = MessageDTO.builder().toWho(uid).fromWho(adminUid).toUserType(USERTYPE.COMPANY)
						.fromUserType(USERTYPE.ADMIN).title("계정 정지 알림").content(content).build();

				messageDAO.insertMessage(messageDTO);
			}
		}

		return result;
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean unblockCompany(int uid) throws Exception {
		return dao.unblockCompany(uid) > 0;
	}

	@Override
	public List<ReportMessageVO> getReportsByUserReporter() throws Exception {
		return reportDAO.getReportsByUserReporter();
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean updateReportReadStatus(int reportNo, String isRead) throws Exception {
		return dao.updateReportReadStatus(reportNo, isRead) > 0;
	}

	@Override
	public List<ReportMessageVO> getReportsByUserReporterWithFilter(Map<String, String> filterParams, int page, int pageSize) throws Exception {
		return dao.getReportsByUserReporterWithFilter(filterParams, page, pageSize);
	}

	@Override
	public int getTotalReportCount(Map<String, String> filterParams) throws Exception {
		return dao.getTotalReportCount(filterParams);
	}
}
