package com.jobhunter.model.mentor;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MentorRequestListSearchDTO {
	
	private int page = 1;					// 불러올 페이지
	private int rowCntPerPage = 10;			// 1페이지 표시 갯수
    private int totalRowCount;              // 전체 데이터 수 (검색 결과)
	private String searchWord;				// 검색어
	private List<SearchType> searchTypes;   // 검색종류
    private Date searchStartDate;           // 검색 시작할 작성일시
    private Date searchEndDate;           	// 검색 끝나는 작성일시
    private Status status;           		// 신청 상태
    private SortOption sortOption;			// 정렬 기준
    private SortDirection sortDirection;	// 정렬 방식
    
    public int getOffset() {
		return (page - 1) * rowCntPerPage;
	}

    public enum Status {
        PASS, 		// 승인됨
        FAILURE,	// 거부됨
        CHECKED,	// 확인중
        WAITING,	// 미확인(조회안됨)
        COMPLETE,	// 처리완료된 신청(승인 or 거부)
        UNCOMPLETE,	// 처리미완료된 신청(확인중 or 미확인)
        ALL			// 모든 내역
    }
    
    public enum SearchType {
        TITLE,		// 제목
        WRITER,		// 작성자이름
        CONTENT,	// 내용
        REJECT		// 거절사유
    }
    
    public enum SortOption {
    	POSTDATE,		// 신청일
    	CONFIRMDATE		// 처리일
    }
    
    public enum SortDirection {
    	ASC,
    	DESC
    }
}
