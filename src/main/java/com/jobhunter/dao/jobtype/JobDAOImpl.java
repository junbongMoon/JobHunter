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
}
