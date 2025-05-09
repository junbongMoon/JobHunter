package com.jobhunter.dao.jobtype;

public interface JobDAO {
	void insertJobCategory(String jobName);

	Integer findMajorCategoryNoByName(String jobName);

	void insertSubcategory(Integer refMajorcategoryNo, String jobName);
	
	int insertMajorCategoryWithRecruitmentnotice(int refRecNo, int majorCategortCode) throws Exception;
	
	int insertSubCategoryWithRecruitmentnotice(int refRecNo, int refSubNo) throws Exception;
	
	// 공고의 직업군을 수정하는 메서드
	void updateSubCategoryWithRecruitmentnotice(int uid, int subcategoryNo) throws Exception;
	
	// 공고의 산업군을 수정하는 메서드
	void updateMajorCategoryWithRecruitmentnotice(int uid, int majorcategoryNo);
}
