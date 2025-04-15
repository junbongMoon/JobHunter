package com.jobhunter.service.status;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

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
}
