package com.jobhunter.dao.recruitmentnotice;

import java.time.LocalDateTime;
import java.util.List;

import com.jobhunter.model.customenum.Method;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.*;

public interface RecruitmentNoticeDAO {

    /**
     * @author 문준봉
     * 
     * <p>공고를 저장하는 메서드</p>
     * 
     * @param recruitmentNoticeDTO 등록할 공고 데이터
     * @return 삽입된 row 수
     * @throws Exception 예외 발생 시
     */
    int insertRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p> 공고 상세정보를 조회하는 메서드 </p>
     * 
     * @param uid 공고 uid
     * @return 상세 공고 정보
     * @throws Exception 예외 발생 시
     */
    RecruitmentDetailInfo selectRecruitmentByUid(int uid) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>우대조건을 저장하는 메서드</p>
     * 
     * @param advantageDTO 우대 조건 정보
     * @return 삽입된 row 수
     * @throws Exception 예외 발생 시
     */
    int insertAdvantageWithRecruitmentNotice(AdvantageDTO advantageDTO) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p> 면접방식을 저장하는 메서드 </p>
     * 
     * @param applicationDTO 접수 방법 정보
     * @return 삽입된 row 수
     * @throws Exception 예외 발생 시
     */
    int insertApplicationWithRecruitmentNotice(ApplicationDTO applicationDTO) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>회사가 최근 저장한 공고를 1개를 조회하는 메서드</p>
     * 
     * @param companyUid 회사 UID
     * @return 최근 등록된 공고의 UID
     */
    int selectRecentRecruitment(int companyUid);

    /**
     * @author 문준봉
     * 
     * <p>공고첨부파일을 저장하는 메서드</p>
     * 
     * @param file 첨부파일 정보
     * @return 삽입된 row 수
     * @throws Exception 예외 발생 시
     */
    int insertRecruitmentFile(RecruitmentnoticeBoardUpfiles file) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>페이지조건에 맞는 공고의 TotalRow를 조회하는 메서드</p>
     * 
     * @param pageRequestDTO 검색 조건
     * @return 전체 공고 수
     * @throws Exception 예외 발생 시
     */
    int selectRecruitmentTotalCount(PageRequestDTO pageRequestDTO) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p> 검색어와 검색타입, 정렬 기준에 따라서 공고를 페이징해서 조회하는 메서드 </p>
     * 
     * @param pageResponseDTO 페이징 조건
     * @return 공고 리스트
     */
    List<RecruitmentDetailInfo> selectRecruitmentWithKeyword(PageResponseDTO<RecruitmentDetailInfo> pageResponseDTO);

    /**
     * @author 문준봉
     * 
     * <p>해당 공고에 있는 면접방식을 조회하는 메서드</p>
     * 
     * @param recruitmentNoticeUid 공고 UID
     * @return 접수 방법 리스트
     * @throws Exception 예외 발생 시
     */
    List<Application> getApplications(int recruitmentNoticeUid) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>해당 공고에 있는 우대조건을 조회하는 메서드</p>
     * 
     * @param recruitmentNoticeUid 공고 UID
     * @return 우대 조건 리스트
     * @throws Exception 예외 발생 시
     */
    List<Advantage> getAdvantages(int recruitmentNoticeUid) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>페이지조건에 맞는 공고의 TotalRow를 조회하는 메서드</p>
     * 
     * @param pageRequestDTO 검색 조건
     * @return 검색 결과 row 수
     * @throws Exception 예외 발생 시
     */
    int getSearchResultRowCount(PageRequestDTO pageRequestDTO) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>공고의 totalRow를 조회하는 메서드</p>
     * 
     * @return 전체 row 수
     * @throws Exception 예외 발생 시
     * 
     */
    int getTotalCountRow() throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>공고에 첨부 된 첨부파일 리스트를 조회하는 메서드</p>
     * 
     * @param uid 공고 UID
     * @return 첨부파일 리스트
     */
    List<RecruitmentnoticeBoardUpfiles> getFileList(int uid);

    /**
     * @author 문준봉
     * 
     * <p>공고를 삭제하는 메서드</p>
     * 
     * @param uid 공고 UID
     * @return 삭제된 row 수
     * @throws Exception 예외 발생 시
     */
    int deleteRecruitmentByUid(int uid) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>공고를 수정하는 메서드</p>
     * 
     * @param dto 수정할 공고 데이터
     * @throws Exception 예외 발생 시
     */
    void updateRecruitmentNotice(RecruitmentNoticeDTO dto) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>면접 방식을 삭제하는 메서드</p>
     * 
     * @param uid 공고 UID
     * @param method 삭제할 접수 방법
     * @throws Exception 예외 발생 시
     */
    void deleteApplication(int uid, Method method) throws Exception;

    /**
     * @author 문준봉
     * @param boardUpFileNo 파일 고유 번호
     */
    void deleteFileFromDatabase(int boardUpFileNo);

    /**
     * @author 문준봉
     * 
     * <p>우대조건을 삭제하는 메서드</p>
     * 
     * @param uid 공고 UID
     * @param advantageType 삭제할 우대 조건
     * @throws Exception 예외 발생 시
     */
    void deleteAdvantage(int uid, String advantageType) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>해당 uid의 유저가 작성한 공고의 totalRow를 조회하는 메서드</p>
     * 
     * @param companyUid 회사 UID
     * @return 작성한 공고 수
     */
    int getTotalCountRowByCompanyUid(int companyUid);

    /**
     * @author 문준봉
     * @param companyUid 회사 UID
     * @param pageResponseDTO 페이징 정보
     * @return 공고 리스트
     */
    List<RecruitmentNotice> selectRecruitmentByCompanyUid(int companyUid, PageResponseDTO<RecruitmentNotice> pageResponseDTO);

    /**
     * @author 문준봉
     * 
     * <p>이전 글을 조회하는 메서드</p>
     * 
     * @param uid 현재 공고 UID
     * @return 이전 글
     * @throws Exception 예외 발생 시
     */
    RecruitmentNotice selectPreviousPost(int uid) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>다음 글을 조회하는 메서드</p>
     * 
     * @param uid 현재 공고 UID
     * @return 다음 글
     * @throws Exception 예외 발생 시
     */
    RecruitmentNotice selectNextPost(int uid) throws Exception;

    /**
     * @author 문준봉
     * 
     * <p>시작일과 종료일 사이의 생성 된 공고 수를 조회하는 메서드</p>
     * 
     * @param start 시작일
     * @param end 종료일
     * @return 작성된 공고 수
     */
    int countByCreatedDateBetween(LocalDateTime start, LocalDateTime end);

    /**
     * @author 문준봉
     * 
     * <p>생성/삭제 로고를 작성하는 메서드</p>
     * 
     * @param recNo 공고 번호
     */
    void insertCDLogForRecruitment(int recNo);

    /**
     * @author 문준봉
     * 
     * <p>삭제 로그를 작성하는 메서드</p>
     * 
     * @param uid 공고 번호
     */
    void insertDeleteLogByRecruitment(int uid);

    /**
     * @author 문준봉
     * 
     *  <p>공고의 마감기한을 현재시간으로 변경하는 메서드</p>
     * 
     * @param uid 공고 UID
     * @return 변경된 row 수
     * @throws Exception 예외 발생 시
     */
    int updateDuedateExpireByUid(int uid) throws Exception;

    /**
     * @author 문준봉
     * 
     *  <p>조회 로그를 저장하는 메서드</p>
     * 
     * @param boardNo 게시물 번호
     * @param userId 사용자 번호
     * @param viewType 조회 타입
     */
    void insertViewsLog(int boardNo, int userId, String viewType);

    /**
     * @author 문준봉
     * 
     *  <p>조회로그에 해당유저가 24시간 이내 조회된 기록이 있는지 확인하는 메서드</p>
     * 
     * @param userId 사용자 번호
     * @param boardNo 게시물 번호
     * @param viewType 조회 타입
     * @return 최근 24시간 내 조회 여부
     */
    boolean isRecentlyViewed(int userId, int boardNo, String viewType);

    /**
     * @author 문준봉
     * 
     *  <p>공고의 총 조회 수를 증가 시키는 메서드</p>
     * 
     * @param boardNo 공고 번호
     * @return 증가된 조회수
     */
    int increaseRecruitmentViewCnt(int boardNo);


	List<RecruitmentWithResume> searchRecruitments(RecruitmentWithResumePageDTO dto);

	int countRecruitments(RecruitmentWithResumePageDTO dto);

	int increaseRecruitmentLikeCnt(int uid) throws Exception;

	int decreaseRecruitmentLikeCnt(int uid) throws Exception;

}
