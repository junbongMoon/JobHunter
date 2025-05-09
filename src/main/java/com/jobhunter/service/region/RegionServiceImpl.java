package com.jobhunter.service.region;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.region.RegionDAO;
import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RegionServiceImpl implements RegionService {
	
	private final RegionDAO rdao;
	
	// 도시 전체 조회
	@Override
	public List<Region> getRegionList() throws Exception {
		List<Region> regionList = rdao.selectEntireRegion();
		return regionList;
	}
	
	// 시군구 regionNo로 가져오기
	@Override
	public List<Sigungu> getSigunguList(int regionNo) throws Exception {
		List<Sigungu> sigunguList = rdao.selectSigunguByRegionNo(regionNo);
		return sigunguList;
	}

}
