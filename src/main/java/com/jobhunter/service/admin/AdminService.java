package com.jobhunter.service.admin;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import com.jobhunter.model.admin.Pagination;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.report.ReportMessageVO;
import com.jobhunter.model.user.UserVO;

/**
 * 관리자 서비스 인터페이스입니다.
 * <p>
 * 관리자 페이지에서 필요한 기능들을 정의합니다.
 * </p>
 * 
 * @author 유지원
 */
public interface AdminService {

	/**
	 * 일반유저를 일정 기간 또는 영구적으로 정지시킵니다.
	 *
	 * @param uid 일반유저 고유 번호
	 * @param blockDeadline 정지 해제 날짜
	 * @param reason 정지 사유
	 * @param adminUid 정지한 관리자의 고유 번호
	 * @return 정지 성공 여부
	 * @throws Exception 
	 * @author 유지원
	 */
	boolean blockUser(int uid, Timestamp blockDeadline, String reason, int adminUid) throws Exception;

	/**
	 * 일반유저 정지를 해제합니다.
	 *
	 * @param uid 일반유저 고유 번호
	 * @return 정지 해제 성공 여부
	 * @throws Exception 
	 * @author 유지원
	 */
	boolean unblockUser(int uid) throws Exception;

	/**
	 * 기업유저를 일정 기간 또는 영구적으로 정지시킵니다.
	 *
	 * @param uid 기업유저 고유 번호
	 * @param blockDeadline 정지 해제 날짜
	 * @param reason 정지 사유
	 * @param adminUid 정지한 관리자의 고유 번호
	 * @return 정지 성공 여부
	 * @throws Exception 
	 * @author 유지원
	 */
	boolean blockCompany(int uid, Timestamp blockDeadline, String reason, int adminUid) throws Exception;

	/**
	 * 기업유저 정지를 해제합니다.
	 *
	 * @param uid 기업유저 고유 번호
	 * @return 정지 해제 성공 여부
	 * @throws Exception 
	 * @author 유지원
	 */
	boolean unblockCompany(int uid) throws Exception;

	/**
	 * 검색 조건에 맞는 일반유저 목록을 조회합니다.
	 *
	 * @param searchType 검색 타입 (예: name, email)
	 * @param searchKeyword 검색어
	 * @param statusFilter 상태 필터 (예: all, normal, blocked 등)
	 * @param page 현재 페이지 번호
	 * @param pageSize 페이지당 표시할 게시물 수
	 * @return 일반유저 목록
	 * @throws Exception 
	 * @author 유지원
	 */
	List<UserVO> getUsersBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception;

	/**
	 * 검색 조건에 맞는 일반유저의 총 수를 조회합니다.
	 *
	 * @param searchType 검색 타입 (예: name, email)
	 * @param searchKeyword 검색어
	 * @param statusFilter 상태 필터 (예: all, normal, blocked 등)
	 * @return 일반유저의 총 수
	 * @throws Exception 
	 * @author 유지원
	 */
	int getTotalUserCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	/**
	 * 검색 조건에 맞는 기업유저 목록을 조회합니다.
	 *
	 * @param searchType 검색 타입 (예: companyName)
	 * @param searchKeyword 검색어
	 * @param statusFilter 상태 필터 (예: all, blocked 등)
	 * @param page 현재 페이지 번호
	 * @param pageSize 페이지당 표시할 게시물 수
	 * @return 기업유저 목록
	 * @throws Exception 
	 * @author 유지원
	 */
	List<CompanyVO> getCompaniesBySearch(String searchType, String searchKeyword, String statusFilter, int page, int pageSize) throws Exception;

	/**
	 * 검색 조건에 맞는 기업유저의 총 수를 조회합니다.
	 *
	 * @param searchType 검색 타입 (예: companyName)
	 * @param searchKeyword 검색어
	 * @param statusFilter 상태 필터 (예: all, blocked 등)
	 * @return 기업유저의 총 수
	 * @throws Exception 
	 * @author 유지원
	 */
	int getTotalCompanyCount(String searchType, String searchKeyword, String statusFilter) throws Exception;

	/**
	 * 일반유저의 상세 정보를 조회합니다.
	 *
	 * @param uid 일반유저 고유 번호
	 * @return 일반유저 정보
	 * @throws Exception 
	 * @author 유지원
	 */
	UserVO getUserById(int uid) throws Exception;

	/**
	 * 기업유저의 상세 정보를 조회합니다.
	 *
	 * @param uid 기업유저 고유 번호
	 * @return 기업유저 정보
	 * @throws Exception 
	 * @author 유지원
	 */
	CompanyVO getCompanyById(int uid) throws Exception;

	/**
	 * 모든 일반유저를 조회합니다.
	 *
	 * @return 모든 일반유저 목록
	 * @throws Exception 
	 * @author 유지원
	 */
	List<UserVO> getAllUsers() throws Exception;

	/**
	 * 모든 기업유저를 조회합니다.
	 *
	 * @return 모든 기업유저 목록
	 * @throws Exception 
	 * @author 유지원
	 */
	List<CompanyVO> getAllCompanies() throws Exception;
	
	/**
	 * reporterAccountType이 USER인 신고 데이터를 조회합니다.
	 *
	 * @return 신고 데이터 목록
	 * @throws Exception
	 * @author 유지원
	 */
	List<ReportMessageVO> getReportsByUserReporter() throws Exception;
	
	/**
	 * 신고 상태를 읽음/미읽음으로 변경합니다.
	 *
	 * @param reportNo 신고 번호
	 * @param isRead 읽음 상태 (Y/N)
	 * @return 업데이트 성공 여부
	 * @throws Exception
	 * @author 유지원
	 */
	boolean updateReportReadStatus(int reportNo, String isRead) throws Exception;

	/**
	 * 사용자가 신고한 목록을 필터링하여 조회합니다.
	 * 
	 * @param filterParams 필터링 파라미터
	 * @param page 현재 페이지 번호
	 * @param pageSize 페이지당 표시할 게시물 수
	 * @return 필터링된 신고 목록
	 * @throws Exception
	 * @author 유지원
	 */
	List<ReportMessageVO> getReportsByUserReporterWithFilter(Map<String, String> filterParams, int page, int pageSize) throws Exception;

	/**
	 * 필터링된 신고 목록의 총 개수를 조회합니다.
	 * 
	 * @param filterParams 필터링 파라미터
	 * @return 필터링된 신고 목록의 총 개수
	 * @throws Exception
	 * @author 유지원
	 */
	int getTotalReportCount(Map<String, String> filterParams) throws Exception;
}
