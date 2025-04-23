package com.jobhunter.model.reviewboard;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RPageRequestDTO {
    private int page;        // 현재 페이지 번호
    private int size;        // 한 페이지당 게시글 수

    private String searchType;
    private String keyword; 
    
    
    private String sortType;     // 정렬 기준: likes, views 등
    private String resultFilter; // 합격 여부 필터: PASSED, FAILED, PENDING
    private String companyFilter; 
    
    private int writer;
    
    public RPageRequestDTO() {
        this.page = 1;
        this.size = 10;
    }

    public int getOffset() {
        return (page - 1) * size;
    }

    // getter / setter
}
