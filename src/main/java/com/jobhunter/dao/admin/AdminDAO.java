package com.jobhunter.dao.admin;

import java.util.List;
import java.util.Map;

import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.model.report.ReportMessageVO;

public interface AdminDAO {

	List<UserVO> getAllUsers() throws Exception;

	UserVO getUserById(int uid) throws Exception;

	List<UserVO> getUsersBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception;

	int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	int blockUser(int uid, String blockDeadline, String reason) throws Exception;

	int unblockUser(int uid) throws Exception;

	List<CompanyVO> getAllCompanies() throws Exception;

	CompanyVO getCompanyById(int uid) throws Exception;

	List<CompanyVO> getCompaniesBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception;

	int getTotalCompanyCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	int blockCompany(int uid, String blockDeadline, String reason) throws Exception;

	int unblockCompany(int uid) throws Exception;

	/**
	 * reporterAccountType이 USER인 신고 데이터를 조회합니다.
	 *
	 * @return 신고 데이터 목록
	 * @throws Exception
	 */
	List<ReportMessageVO> getReportsByUserReporter() throws Exception;
	
	/**
	 * 신고 상태를 읽음/미읽음으로 변경합니다.
	 *
	 * @param reportNo 신고 번호
	 * @param isRead 읽음 상태 (Y/N)
	 * @return 업데이트 성공 여부
	 * @throws Exception
	 */
	int updateReportReadStatus(int reportNo, String isRead) throws Exception;

	/**
	 * 사용자가 신고한 목록을 필터링하여 조회합니다.
	 * 
	 * @param filterParams 필터링 파라미터
	 * @param page 현재 페이지 번호
	 * @param pageSize 페이지당 표시할 게시물 수
	 * @return 필터링된 신고 목록
	 * @throws Exception
	 */
	List<ReportMessageVO> getReportsByUserReporterWithFilter(Map<String, String> filterParams, int page, int pageSize) throws Exception;

	/**
	 * 필터링된 신고 목록의 총 개수를 조회합니다.
	 * 
	 * @param filterParams 필터링 파라미터
	 * @return 필터링된 신고 목록의 총 개수
	 * @throws Exception
	 */
	int getTotalReportCount(Map<String, String> filterParams) throws Exception;

}
