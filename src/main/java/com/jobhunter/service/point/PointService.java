package com.jobhunter.service.point;

public interface PointService {
	
    // 이력서 첨삭 제출 포인트 로그 남기기
    void submitAdvicePointLog(int mentorUid, int sessionUid, int point, int rgAdviceNo) throws Exception;
}
