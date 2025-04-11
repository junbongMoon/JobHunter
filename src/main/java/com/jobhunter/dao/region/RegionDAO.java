package com.jobhunter.dao.region;

import java.util.List;

import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;

public interface RegionDAO {
	// pk값으로 Region(지역)을 조회하는 메서드
	Region selectRegionByRegionNo(int regionNo);
	
	// pk값으로 Sigungu(시군구)를 조회하는 메서드
	Sigungu selectSigunguBySigunguNo(int sigunguNo);
	
	// 지역을 전체 조회하는 메서드
	List<Region> selectEntireRegion();

	// regionNo로 시군구 리스트를 조회하는 메서드
	List<Sigungu> selectSigunguByRegionNo(int regionNo);

	// where_recruit_region에 등록하는 메서드
	int insertRegionWithRecruitmentNotice(int refRecNo, int refRegion) throws Exception;

	// where_recruit_sigungu에 등록하는 메서드
	int insertSigunguWithRecruitmentNotice(int refRecNo, int refSigungu) throws Exception;
	
	// where_recruit_sigungu에 공고에 등록 된 시군구를 수정하는 메서드
	void updateRegionWithRecruitmentNotice(int uid, int regionNo) throws Exception;
	
	// where_recruit_sigungu에 공고에 등록 된 도시를 수정하는 메서드
	void updateSigunguWithRecruitmentNotice(int uid, int sigunguNo);
	


}
