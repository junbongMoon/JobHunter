package com.jobhunter.service.category;

import java.util.List;

import com.jobhunter.model.category.MajorCategory;
import com.jobhunter.model.category.SubCategory;

public interface CategoryService {
	// 산업군 전체를 가져오는 메서드
	List<MajorCategory> getEntireMajorCategory() throws Exception;
	
	// 산업군 pk에 해당하는 직업군을 가져오는 메서드
	List<SubCategory> getSubCategory(int refMajorcategoryNo) throws Exception;
}
