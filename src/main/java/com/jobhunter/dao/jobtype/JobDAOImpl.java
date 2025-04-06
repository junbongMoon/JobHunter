package com.jobhunter.dao.jobtype;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class JobDAOImpl implements JobDAO {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "com.example.mapper.JobMapper";

    @Override
    public void insertJobCategory(String jobName) {
        sqlSession.insert(NAMESPACE + ".insertJobCategory", jobName);
    }
    
    @Override
    public Integer findMajorCategoryNoByName(String jobName) {
        return sqlSession.selectOne(NAMESPACE + ".findMajorCategoryNoByName", jobName);
    }

    @Override
    public void insertSubcategory(Integer refMajorcategoryNo, String jobName) {
        Map<String, Object> params = new HashMap<>();
        params.put("refMajorcategoryNo", refMajorcategoryNo);
        params.put("jobName", jobName);
        sqlSession.insert(NAMESPACE + ".insertSubcategory", params);
    }
    
    // 공고에 산업군 넣어주는 메서드
	@Override
	public int insertMajorCategoryWithRecruitmentnotice(int refRecNo, int refMajorNo) throws Exception {
		Map<String, Integer> param = new HashMap<>();
		param.put("refRecNo", refRecNo);
		param.put("refMajorNo", refMajorNo);
		
		
		return sqlSession.insert(NAMESPACE + ".insertMajorJobTypeWithRecruitmentnotice", param);
	}
	
	// 공고에 직업 입력해주는 메서드
	@Override
	public int insertSubCategoryWithRecruitmentnotice(int refRecNo, int refSubNo) throws Exception {
		
		Map<String, Integer> param = new HashMap<>();
		param.put("refRecNo", refRecNo);
		param.put("refSubNo", refSubNo);
		
		
		return sqlSession.insert(NAMESPACE + ".insertSubJobTypeWithRecruitmentnotice", param);
	}
	
	// 공고에 등록 된 직업군을 수정하는 메서드
	@Override
	public void updateSubCategoryWithRecruitmentnotice(int uid, int subcategoryNo) throws Exception {
		
		Map<String, Integer> param = new HashMap<>();
		param.put("uid", uid);
		param.put("subcategoryNo", subcategoryNo);
		
		sqlSession.update(NAMESPACE + ".updateSubCategoryWithRecruitmentnotice", param);
		
	}
	
	// 공고에 등록된 산업군을 수정하는 메서드
	@Override
	public void updateMajorCategoryWithRecruitmentnotice(int uid, int majorcategoryNo) {
		
		Map<String, Integer> param = new HashMap<>();
		param.put("uid", uid);
		param.put("majorcategoryNo", majorcategoryNo);
		
		sqlSession.update(NAMESPACE + ".updateMajorCategoryWithRecruitmentnotice", param);
		
	}
}
