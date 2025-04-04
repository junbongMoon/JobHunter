package com.jobhunter.model.page;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class PageRequestDTO {
   private int pageNo = 1;  // 현재 페이지 번호
   private int rowCntPerPage = 10;  // 1페이지당 보여줄 row의 수

   private String searchType;
   private String searchWord;
}
