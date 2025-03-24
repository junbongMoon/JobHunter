package com.jobhunter.controller.category;

import java.util.List;
import java.util.NoSuchElementException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.category.MajorCategory;
import com.jobhunter.model.category.SubCategory;
import com.jobhunter.service.category.CategoryService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/category")
public class CategoryController {
	private final CategoryService categoryService;
	
	// 산업군 전체 가져오는 메서드
	@GetMapping("/major")
	public ResponseEntity<List<MajorCategory>> getEntireMajorCategory(){
		ResponseEntity<List<MajorCategory>> result = null;
		
		try {
			List<MajorCategory> majorList = categoryService.getEntireMajorCategory();
			result = ResponseEntity.ok(majorList);
		} catch (NoSuchElementException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
		}catch (Exception e) {
			result = ResponseEntity.badRequest().body(null);
		}
		
		
		return result;
	}
	
	// 산업군pk로 해당되는 직종들 가져오는 메서드
	@GetMapping("/sub/{refMajorNo}")
	public ResponseEntity<List<SubCategory>> getSubCategoryByMajorNo(@PathVariable int refMajorNo){
		ResponseEntity<List<SubCategory>> result = null;
		
		try {
			List<SubCategory> subList = categoryService.getSubCategory(refMajorNo);
			result = ResponseEntity.ok(subList);
		} catch (NoSuchElementException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
		} catch (Exception e) {
			result = ResponseEntity.badRequest().body(null);
		}
		
		return result; 
	}
}
