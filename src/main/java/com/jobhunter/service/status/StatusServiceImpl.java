package com.jobhunter.service.status;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.company.CompanyDAO;
import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.dao.resume.ResumeDAO;
import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.dao.status.StatusDAO;
import com.jobhunter.dao.submit.SubmitDAO;
import com.jobhunter.dao.user.UserDAO;
import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StatusServiceImpl implements StatusService {

	private final UserDAO userDAO;
	private final CompanyDAO companyDAO;
	private final RecruitmentNoticeDAO recruitmentNoticeDAO;
	private final SubmitDAO submitDAO;
	private final ReviewBoardDAO reviewBoardDAO;
	private final StatusDAO statusDAO;
	
	@Override
	public void saveDateStatusByToDay() {
        LocalDate today = LocalDate.now().minusDays(1);
        LocalDateTime start = today.atStartOfDay();
        LocalDateTime end = today.plusDays(1).atStartOfDay();

        int newUsers = userDAO.countByCreatedDateBetweenAndRole(start, end, "USERS");
        int newCompanies = companyDAO.countByCreatedDateBetweenAndRole(start, end, "COMPANY");
        int newRecruitmentNoticeCnt = recruitmentNoticeDAO.countByCreatedDateBetween(start, end);
        int newRegistration = submitDAO.countBySubmittedDateBetween(start, end);
        int newReviewBoard = reviewBoardDAO.countByCreatedDateBetween(start, end);

        StatusVODTO status = StatusVODTO.builder()
                .statusDate(LocalDateTime.now())
                .newUsers(newUsers)
                .newCompanies(newCompanies)
                .newRecruitmentNoticeCnt(newRecruitmentNoticeCnt)
                .newRegistration(newRegistration)
                .newReviewBoard(newReviewBoard)
                .build();

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
	    LocalDateTime end = yesterday.plusDays(1).atStartOfDay();
	    
	    TotalStatusVODTO result = statusDAO.selectTotalStatusByYesterDay(yesterday, start, end);
	    return result;
	}

	@Override
	public StatusVODTO getTodayIncrement() {
	    LocalDate today = LocalDate.now().minusDays(1);
	    LocalDateTime start = today.atStartOfDay();
	    LocalDateTime end = today.plusDays(1).atStartOfDay();

	    int newUsers = userDAO.countByCreatedDateBetweenAndRole(start, end, "USERS");
	    int newCompanies = companyDAO.countByCreatedDateBetweenAndRole(start, end, "COMPANY");
	    int newRecruitmentNoticeCnt = recruitmentNoticeDAO.countByCreatedDateBetween(start, end);
	    int newRegistration = submitDAO.countBySubmittedDateBetween(start, end);
	    int newReviewBoard = reviewBoardDAO.countByCreatedDateBetween(start, end);

	    return StatusVODTO.builder()
	            .statusDate(LocalDateTime.now())
	            .newUsers(newUsers)
	            .newCompanies(newCompanies)
	            .newRecruitmentNoticeCnt(newRecruitmentNoticeCnt)
	            .newRegistration(newRegistration)
	            .newReviewBoard(newReviewBoard)
	            .build();
	}

	@Override
	public void saveEntireStatus(TotalStatusVODTO todayTotal) {
	    statusDAO.insertTotalStatus(todayTotal);
	}
	
	@Override
	@Transactional
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

	    // ✅ 로그로 확인
	    System.out.println("어제 누적 통계 : " + yesterdayTotal);
	    System.out.println("오늘 증가량 : " + todayIncrement);
	    System.out.println("오늘 누적 통계 : " + todayTotal);
	}
}
