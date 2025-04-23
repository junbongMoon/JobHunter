package com.jobhunter.dao.point;

public interface PointDAO {

    // 이력서 첨삭 제출 포인트 로그 남기기
    void submitAdvicePointLog(int mentorUid, int sessionUid, int point, int rgAdviceNo) throws Exception;

    // 포인트 로그 업데이트
    int updatePointLog(int rgAdviceNo, String status, String type) throws Exception;
}
