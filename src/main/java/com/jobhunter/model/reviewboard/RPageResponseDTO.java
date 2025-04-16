package com.jobhunter.model.reviewboard;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RPageResponseDTO<T> {

	 private List<T> boardList;
	    private int totalCount;
	    private int page;
	    private int size;
	    private int startPage;
	    private int endPage;
	    private boolean hasPrev;
	    private boolean hasNext;
	    
	    
	    //검색 기능 변수 
	    private String searchType;  
	    private String keyword;

	    public RPageResponseDTO(List<T> boardList, int totalCount, RPageRequestDTO requestDTO) {
	        this.boardList = boardList;
	        this.totalCount = totalCount;
	        this.page = requestDTO.getPage();
	        this.size = requestDTO.getSize();
	        
	        this.searchType = requestDTO.getSearchType();
	        this.keyword = requestDTO.getKeyword();
	        

	        int tempEnd = (int)(Math.ceil(page / 10.0)) * 10;
	        this.startPage = tempEnd - 9;
	        this.endPage = Math.min(tempEnd, (int)Math.ceil(totalCount / (double)size));
	        this.hasPrev = startPage > 1;
	        this.hasNext = totalCount > endPage * size;
	    }
	    
}
