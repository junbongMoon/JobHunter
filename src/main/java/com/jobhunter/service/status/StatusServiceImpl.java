package com.jobhunter.service.status;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.company.CompanyDAO;
import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.dao.resume.ResumeDAO;
import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.dao.status.StatusDAO;
import com.jobhunter.dao.submit.SubmitDAO;
import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StatusServiceImpl implements StatusService {

	private final SubmitDAO submitDAO;
	private final StatusDAO statusDAO;
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 일일 통계를 입력하는 메서드
	 * </p>
	 * 
	 *
	 */
	@Override
	public void saveDateStatusByToDay() {

        StatusVODTO status = this.getTodayIncrement();

        statusDAO.insertStatusDate(status);
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	어제 작성된 누적 통계를 조회하는 메서드
	 * </p>
	 * 
	 * @return TotalStatusVODTO 어제의 누적 통계
	 *
	 */
	@Override
	public TotalStatusVODTO getTotalStatusUntilYesterday() {
	    LocalDate yesterday = LocalDate.now().minusDays(1);
	    LocalDateTime start = yesterday.atStartOfDay();
	    LocalDateTime end = yesterday.plusDays(1).atStartOfDay().minusSeconds(1);
	    
	    TotalStatusVODTO result = statusDAO.selectTotalStatusByYesterDay(yesterday, start, end);
	    return result;
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 오늘 통계 증가량을 조회하는 메서드
	 * </p>
	 * 
	 * @return StatusVODTO 일일 유저, 기업, 공고, 제출, 리뷰의 합계
	 *
	 */
	@Override
	public StatusVODTO getTodayIncrement() {
	    LocalDate today = LocalDate.now().minusDays(1);
	    LocalDateTime start = today.atStartOfDay();
	    LocalDateTime end = today.plusDays(1).atStartOfDay().minusSeconds(1);
	    
        int todayCreateUsers = statusDAO.selectLogCntBetweenAndRole(start, end, "USER", "CREATE");
        int todayDeleteUsers = statusDAO.selectLogCntBetweenAndRole(start, end, "USER", "DELETE");
        
        System.out.println("todayCreateUsers : " + todayCreateUsers +"todayDeleteUsers : " + todayDeleteUsers);
        
        int todayCreateCompanies = statusDAO.selectLogCntBetweenAndRole(start, end, "COMPANY", "CREATE");
        int todayDeleteCompanies = statusDAO.selectLogCntBetweenAndRole(start, end, "COMPANY", "DELETE");
        
        int todayCreateRecruitments = statusDAO.selectLogCntBetweenAndRole(start, end, "RECRUITMENT", "CREATE");
        int todayDeleteRecruitments = statusDAO.selectLogCntBetweenAndRole(start, end, "RECRUITMENT", "DELETE");
        
        int todayCreateReviews = statusDAO.selectLogCntBetweenAndRole(start, end, "REVIEW", "CREATE");
        int todayDeleteReviews = statusDAO.selectLogCntBetweenAndRole(start, end, "REVIEW", "DELETE");

        int newUsers = todayCreateUsers - todayDeleteUsers;
	    int newCompanies = todayCreateCompanies - todayDeleteCompanies;
	    int newRecruitmentNoticeCnt = todayCreateRecruitments - todayDeleteRecruitments;
	    int newRegistration = submitDAO.countBySubmittedDateBetween(start, end);
	    int newReviewBoard = todayCreateReviews - todayDeleteReviews;

	    return StatusVODTO.builder()
	            .statusDate(LocalDateTime.now())
	            .newUsers(newUsers)
	            .newCompanies(newCompanies)
	            .newRecruitmentNoticeCnt(newRecruitmentNoticeCnt)
	            .newRegistration(newRegistration)
	            .newReviewBoard(newReviewBoard)
	            .build();
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 누적 통계를 입력하는 메서드
	 * </p>
	 * 
	 * @param todayTotal
	 *
	 */
	@Override
	public void saveEntireStatus(TotalStatusVODTO todayTotal) {
	    statusDAO.insertTotalStatus(todayTotal);
	}
	
	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public void runDailyStatistics() {
	    // 1. 일일 증가량 저장 (status 테이블)
	    this.saveDateStatusByToDay();

	    // 2. 어제 누적 통계 조회
	    TotalStatusVODTO yesterdayTotal = this.getTotalStatusUntilYesterday();

	    // 3. 오늘의 증가량 계산
	    StatusVODTO todayIncrement = this.getTodayIncrement();

	    // 4. 오늘 누적 통계 계산
	    TotalStatusVODTO todayTotal;
	    LocalDateTime targetDate = LocalDate.now().minusDays(1).atStartOfDay();

	    if (yesterdayTotal == null) {
	        todayTotal = TotalStatusVODTO.builder()
	                .statusDate(targetDate)
	                .totalUsers(todayIncrement.getNewUsers())
	                .totalCompanies(todayIncrement.getNewCompanies())
	                .totalRecruitmentNoticeCnt(todayIncrement.getNewRecruitmentNoticeCnt())
	                .totalRegistration(todayIncrement.getNewRegistration())
	                .totalReviewBoard(todayIncrement.getNewReviewBoard())
	                .build();
	    } else {
	        todayTotal = TotalStatusVODTO.builder()
	                .statusDate(targetDate)
	                .totalUsers(yesterdayTotal.getTotalUsers() + todayIncrement.getNewUsers())
	                .totalCompanies(yesterdayTotal.getTotalCompanies() + todayIncrement.getNewCompanies())
	                .totalRecruitmentNoticeCnt(yesterdayTotal.getTotalRecruitmentNoticeCnt() + todayIncrement.getNewRecruitmentNoticeCnt())
	                .totalRegistration(yesterdayTotal.getTotalRegistration() + todayIncrement.getNewRegistration())
	                .totalReviewBoard(yesterdayTotal.getTotalReviewBoard() + todayIncrement.getNewReviewBoard())
	                .build();
	    }

	    // 5. 누적 통계 저장 (total_status 테이블)
	    this.saveEntireStatus(todayTotal);

	    // 로그로 확인
	    System.out.println("어제 누적 통계 : " + yesterdayTotal);
	    System.out.println("오늘 증가량 : " + todayIncrement);
	    System.out.println("오늘 누적 통계 : " + todayTotal);
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 일일 통계를 페이징해서 가져오는 메서드
	 * </p>
	 * 
	 * @param pageRequestDTO
	 * @return
	 * @throws Exception
	 *
	 */
	@Override
	public List<StatusVODTO> getDailyChartByPaging(LocalDateTime start, LocalDateTime end) throws Exception {
		
		List<StatusVODTO> result = null;
		
		result = statusDAO.getStatusBetweenAndRole(start, end);
		

		
		return result;
	}
	

}
