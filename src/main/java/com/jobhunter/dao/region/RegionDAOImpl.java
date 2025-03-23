package com.jobhunter.dao.region;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RegionDAOImpl implements RegionDAO {
	private final SqlSession ses;
	private final String NS = "com.testoracle.mapper.regionmapper";

	@Override
	public Region selectRegionByRegionNo(int regionNo) {
		// 지역번호 pk로 지역을 조회하는 메서드
		
		return ses.selectOne(NS + ".getRegionByRegionNo", regionNo);
	}
	
	@Override
	public Sigungu selectSigunguBySigunguNo(int sigunguNo) {
		// 시군구번호 pk로 시군구를 조회하는 메서드
		
		return ses.selectOne(NS + ".getSigunguBySigunguNo", sigunguNo);
	}
	
	@Override
	public List<Region> selectEntireRegion() {
		// 지역을 전체 조회하는 메서드
		
		return ses.selectList(NS + ".getEntireRegion");
	}

	@Override
	public List<Sigungu> selectSigunguByRegionNo(int regionNo) {
		// 지역번호로 그 지역을 참조하는 시군구를 조회하는 메서드
		
		return ses.selectList(NS +".getSigunguByRegionNo", regionNo);
	}

	@Override
	public int insertRegionWithRecruitmentNotice(int refRecNo, int refRegion) throws Exception{
		// 공고와 지역을 이어주는 관계 테이블에 insert하는 메서드
		Map<String, Integer> tempMap = new HashMap<String, Integer>();
		tempMap.put("refRecNo", refRecNo);
		tempMap.put("refRegion", refRegion);
		
		return ses.insert(NS + ".insertRegionByRecruitmentNotice", tempMap);
	}

	@Override
	public int insertSigunguWithRecruitmentNotice(int refRecNo, int refSigungu) throws Exception{
		// 공고와 시군구를 이어주는 관계 테이블에 insert하는 메서드
		
		Map<String, Integer> tempMap = new HashMap<String, Integer>();
		tempMap.put("refRecNo", refRecNo);
		tempMap.put("refSigungu", refSigungu);
		
		return ses.insert(NS + ".insertSigunguByRecruitmentNotice", tempMap);
	}

	

	

}
