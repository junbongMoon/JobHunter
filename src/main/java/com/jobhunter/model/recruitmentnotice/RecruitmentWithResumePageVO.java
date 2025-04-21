package com.jobhunter.model.recruitmentnotice;

import java.util.List;
import java.util.ArrayList;
import lombok.Data;

@Data
public class RecruitmentWithResumePageVO {

    // 현재 페이지 번호
    private int currentPage;

    // 전체 항목 수
    private int totalItems;

    // 전체 페이지 수
    private int totalPages;

    // 이전/다음 페이지 존재 여부
    private boolean hasPrevPage;
    private boolean hasNextPage;

    // 이전/다음 블럭 존재 여부
    private boolean hasPrevBlock;
    private boolean hasNextBlock;

    // 현재 페이징 블럭의 시작/끝 페이지 번호
    private int startPage;
    private int endPage;

    // 현재 블럭 내 페이지 번호들
    private List<Integer> pageList;

    // 현재 페이지 항목들
    private List<RecruitmentWithResume> items;

    // 생성자에서 페이징 계산까지 수행
    public RecruitmentWithResumePageVO(List<RecruitmentWithResume> items, int currentPage, int totalItems) {
        this.items = items;
        this.currentPage = currentPage;
        this.totalItems = totalItems;

        final int pageSize = 5;     // 한 페이지당 콘텐츠 수
        final int blockSize = 10;   // 한 블럭당 페이지 수

        // 총 페이지 수
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);

        // 페이지 기준 이전/다음
        this.hasPrevPage = currentPage > 1;
        this.hasNextPage = currentPage < totalPages;

        // 블럭 계산
        this.startPage = ((currentPage - 1) / blockSize) * blockSize + 1;
        this.endPage = Math.min(startPage + blockSize - 1, totalPages);

        // 블럭 기준 이전/다음
        this.hasPrevBlock = startPage > 1;
        this.hasNextBlock = endPage < totalPages;

        // 블럭 내 페이지 리스트
        this.pageList = new ArrayList<>();
        for (int i = startPage; i <= endPage; i++) {
            pageList.add(i);
        }
    }
}
