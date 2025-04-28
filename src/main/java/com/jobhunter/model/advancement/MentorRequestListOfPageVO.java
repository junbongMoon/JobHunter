package com.jobhunter.model.advancement;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * 멘토 신청글 검색에 필요한 정보들 담긴 페이징객체
 * <p>
 * 
 * </p>
 * 
 * @author 육근우
 */
@Data
public class MentorRequestListOfPageVO<T> {
	
	private int page = 1;					// 불러올 페이지
	private int rowCntPerPage = 10;			// 1페이지 표시 갯수
    private int totalRowCount;              // 전체 데이터 수 (검색 결과)

    // 전체 페이지 수
    private int totalPages;

    // 이전/다음 블럭 존재 여부
    private boolean hasPrevBlock;
    private boolean hasNextBlock;

    // 현재 페이징 블럭의 시작/끝 페이지 번호
    private int startPage;
    private int endPage;

    // 현재 블럭 내 페이지 번호들
    private List<Integer> pageList;

    // 현재 페이지 항목들
    private List<T> items;
    
    // 블록당 페이지 수 (고정)
    private final int blockSize = 10;

    public MentorRequestListOfPageVO(List<T> items, int page, int rowCntPerPage, int totalRowCount) {
        this.items = items;
        this.page = page;
        this.rowCntPerPage = rowCntPerPage;
        this.totalRowCount = totalRowCount;

        // 총 페이지 수 계산
        this.totalPages = (int) Math.ceil((double) totalRowCount / rowCntPerPage);

        // 블록 시작/끝 계산
        this.startPage = ((page - 1) / blockSize) * blockSize + 1;
        this.endPage = Math.min(startPage + blockSize - 1, totalPages);

        // 블록 기준 이전/다음 존재 여부
        this.hasPrevBlock = startPage > 1;
        this.hasNextBlock = endPage < totalPages;

        // 현재 블록 내 페이지 리스트 생성
        this.pageList = new ArrayList<>();
        for (int i = startPage; i <= endPage; i++) {
            pageList.add(i);
        }
    }
    
    public enum Status {
        PASS, 		// 승인됨
        FAILURE,	// 거부됨
        CHECKED,	// 확인중
        WAITING,	// 미확인(조회안됨)
        COMPLETE,	// 처리완료된 신청(승인 or 거부)
        UNCOMPLETE	// 처리미완료된 신청(확인중 or 미확인)
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
