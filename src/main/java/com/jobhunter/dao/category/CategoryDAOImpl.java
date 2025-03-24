package com.jobhunter.dao.category;

import java.util.List;

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

}
