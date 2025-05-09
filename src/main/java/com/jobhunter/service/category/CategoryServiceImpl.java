package com.jobhunter.service.category;

import java.util.List;
import java.util.NoSuchElementException;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.category.CategoryDAO;
import com.jobhunter.model.category.MajorCategory;
import com.jobhunter.model.category.SubCategory;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {
	
	private final CategoryDAO cdao;
	
	@Override
	public List<MajorCategory> getEntireMajorCategory() throws Exception {
		List<MajorCategory> result = cdao.selectAllMajorCategory();
		
		if(result.isEmpty()) {
			new NoSuchElementException();
		}
		return result;
	}

	@Override
	public List<SubCategory> getSubCategory(int refMajorcategoryNo) throws Exception {
		List<SubCategory> result = cdao.selectSubCategoryWithRefMajorCategoryNo(refMajorcategoryNo);
		
		if(result.isEmpty()) {
			new NoSuchElementException();
		}
		
		return result;
	}

}
