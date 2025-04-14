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

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class StatusServiceImpl implements StatusService {

	private UserDAO userDAO;
	private CompanyDAO companyDAO;
	private RecruitmentNoticeDAO recruitmentNoticeDAO;
	private SubmitDAO submitDAO;
	private ReviewBoardDAO reviewBoardDAO;
	private StatusDAO statusDAO;
	

	@Override
	public void saveDateStatusByToDay() {
		// 
        LocalDate today = LocalDate.now().minusDays(1);  // 어제 날짜
        LocalDateTime start = today.atStartOfDay();
        LocalDateTime end = today.plusDays(1).atStartOfDay();

        int newUsers = userDAO.countByCreatedDateBetweenAndRole(start, end, "USERS");
        int newCompanies = companyDAO.countByCreatedDateBetweenAndRole(start, end, "COMPANY");
        int newRecruitmentNoticeCnt = recruitmentNoticeDAO.countByCreatedDateBetween(start, end);
        int newRegistration = submitDAO.countBySubmittedDateBetween(start, end);
        int newReviewBoard = reviewBoardDAO.countByCreatedDateBetween(start, end);

        StatusVODTO status = StatusVODTO.builder()
                .statusDate(LocalDateTime.now())
                .new_Users(newUsers)
                .new_Companies(newCompanies)
                .new_RecruitmentNoticeCnt(newRecruitmentNoticeCnt)
                .new_Registration(newRegistration)
                .new_ReviewBoard(newReviewBoard)
                .build();

        statusDAO.insertStatusDate(status);

	}

}
