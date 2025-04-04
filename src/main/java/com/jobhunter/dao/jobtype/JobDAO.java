package com.jobhunter.dao.jobtype;

public interface JobDAO {
	void insertJobCategory(String jobName);

	Integer findMajorCategoryNoByName(String jobName);

	void insertSubcategory(Integer refMajorcategoryNo, String jobName);
	
	int insertMajorCategoryWithRecruitmentnotice(int refRecNo, int majorCategortCode) throws Exception;
	
	int insertSubCategoryWithRecruitmentnotice(int refRecNo, int refSubNo) throws Exception;
}
