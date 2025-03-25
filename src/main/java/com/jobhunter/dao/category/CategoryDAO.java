package com.jobhunter.dao.category;

import java.util.List;

import com.jobhunter.model.category.MajorCategory;
import com.jobhunter.model.category.SubCategory;

public interface CategoryDAO {
	
	// 산업군 대분류 전체를 조회하는 메서드
	List<MajorCategory> selectAllMajorCategory() throws Exception;
	
	// 산업군 번호(pk)에 따라 해당 직업군을 조회하는 메서드
	List<SubCategory> selectSubCategoryWithRefMajorCategoryNo(int refMajorcategoryNo) throws Exception;
	
	// 공고를 작성할 때 산업군 대분류 저장하는 메서드
	int insertMajorCategoryWithRecruitmentNotice(int refRecNo, int refMajorNo) throws Exception;
	
	// 공고를 작성할 때 직업군 소분류 저장하는 메서드
	int insertSubCategoryWithRecruitmentNotice(int refRecNo, int refSubNo) throws Exception;
	
}
