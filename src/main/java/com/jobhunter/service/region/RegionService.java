package com.jobhunter.service.region;

import java.util.List;

import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;

public interface RegionService {
	// 지역 전체 조회하는 메서드
	List<Region> getRegionList() throws Exception;
	
	// 선택한 지역에 따라 시군구 리스트 조회하는 메서드
	List<Sigungu> getSigunguList(int regionNo) throws Exception;
	
	
}
