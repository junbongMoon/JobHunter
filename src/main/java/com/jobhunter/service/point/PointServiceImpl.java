package com.jobhunter.service.point;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.point.PointDAO;
import com.jobhunter.dao.user.UserDAO;

import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class PointServiceImpl implements PointService {

    private final PointDAO pointDAO;
    private final UserDAO userDAO;

    @Override
    @Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
    public void submitAdvicePointLog(int mentorUid, int sessionUid, int point, int rgAdviceNo) throws Exception {
        // user -1000 포인트 차감
        userDAO.updateUserPoint(sessionUid, -1000);

        // 포인트 로그 저장
        pointDAO.submitAdvicePointLog(mentorUid, sessionUid, point, rgAdviceNo);
    }
}
