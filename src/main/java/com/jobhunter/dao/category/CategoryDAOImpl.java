package com.jobhunter.dao.category;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.category.MajorCategory;
import com.jobhunter.model.category.SubCategory;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CategoryDAOImpl implements CategoryDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.categorymapper";

	@Override
	public List<MajorCategory> selectAllMajorCategory() throws Exception {
		
		return ses.selectList(NS + ".selectAllMajorCategory");
	}

	@Override
	public List<SubCategory> selectSubCategoryWithRefMajorCategoryNo(int refMajorcategoryNo) throws Exception {
		
		return ses.selectList(NS + ".selectSubCategoryByRefmajorcategoryNo", refMajorcategoryNo);
	}

	@Override
	public int insertMajorCategoryWithRecruitmentNotice(int refRecNo, int refMajorNo) throws Exception {
		Map<String, Integer> param = new HashMap<String, Integer>(); 
		param.put("refRecNo", refRecNo);
		param.put("refMajorNo", refMajorNo);
				
		return ses.insert(NS + ".insertMajorCategoryWithRecruitmentNotice", param);
	}

	@Override
	public int insertSubCategoryWithRecruitmentNotice(int refRecNo, int refSubNo) throws Exception {
		Map<String, Integer> param = new HashMap<String, Integer>(); 
		param.put("refRecNo", refRecNo);
		param.put("refSubNo", refSubNo);
				
		return ses.insert(NS + ".insertSubCategoryWithRecruitmentNotice", param);
	}

}
