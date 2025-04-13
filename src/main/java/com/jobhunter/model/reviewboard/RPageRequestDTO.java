package com.jobhunter.model.reviewboard;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class RPageRequestDTO {
    private int page;        // 현재 페이지 번호
    private int size;        // 한 페이지당 게시글 수

    public RPageRequestDTO() {
        this.page = 1;
        this.size = 10;
    }

    public int getOffset() {
        return (page - 1) * size;
    }

    // getter / setter
}
