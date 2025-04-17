package com.jobhunter.model.admin;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Pagination {
    private int totalCount;      // 전체 게시물 수
    private int currentPage;     // 현재 페이지
    private int pageSize;        // 페이지당 게시물 수
    private int totalPages;      // 전체 페이지 수
    private int startPage;       // 시작 페이지 번호
    private int endPage;         // 끝 페이지 번호
    private boolean prev;        // 이전 페이지 존재 여부
    private boolean next;        // 다음 페이지 존재 여부
    private int blockSize = 5;   // 페이지 블록 크기 (5개씩)

    public Pagination(int totalCount, int currentPage, int pageSize) {
        this.totalCount = totalCount;
        // 페이지 번호가 1보다 작으면 1로 설정
        this.currentPage = Math.max(1, currentPage);
        this.pageSize = pageSize;
        
        // 전체 페이지 수 계산
        this.totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        // 시작 페이지와 끝 페이지 계산 (5개씩 블록)
        this.startPage = ((this.currentPage - 1) / blockSize) * blockSize + 1;
        this.endPage = Math.min(startPage + blockSize - 1, totalPages);
        
        // 이전/다음 페이지 존재 여부
        this.prev = startPage > 1;
        this.next = endPage < totalPages;
    }
} 