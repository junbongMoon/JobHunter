package com.jobhunter.dao.region;

import java.util.List;

import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;

/**
 * @author 문준봉
 *
 */
public interface RegionDAO {

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * pk값으로 Region(지역)을 조회하는 메서드
	 * </p>
	 * 
	 * @param int regionNo
	 * @return 도시 정보
	 *
	 */
	Region selectRegionByRegionNo(int regionNo);
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *  pk값으로 Sigungu(시군구)를 조회하는 메서드
	 * </p>
	 * 
	 * @param int sigunguNo
	 * @return 시군구 정보
	 *
	 */
	Sigungu selectSigunguBySigunguNo(int sigunguNo);
	

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 도시 전체 조회하는 메서드
	 * </p>
	 * 
	 * @return 도시 리스트
	 *
	 */
	List<Region> selectEntireRegion();

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * regionNo로 시군구 리스트를 조회하는 메서드
	 * </p>
	 * 
	 * @param int regionNo
	 * @return 시군구 정보 리스트
	 *
	 */
	List<Sigungu> selectSigunguByRegionNo(int regionNo);

	// where_recruit_region에 등록하는 메서드
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고의 도시 정보를 등록하는 메서드
	 * </p>
	 * 
	 * @param refRecNo
	 * @param refRegion
	 * @return 성공 하면 1, 실패하면 0
	 * @throws Exception
	 *
	 */
	int insertRegionWithRecruitmentNotice(int refRecNo, int refRegion) throws Exception;

	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고의 시군구 정보를 등록하는 메서드
	 * </p>
	 * 
	 * @param int refRecNo
	 * @param int refSigungu
	 * @return 성공 하면 1, 실패하면 0
	 * @throws Exception
	 *
	 */
	int insertSigunguWithRecruitmentNotice(int refRecNo, int refSigungu) throws Exception;
	

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * where_recruit_sigungu에 공고에 등록 된 시군구를 수정하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @param int regionNo
	 * @throws Exception
	 *
	 */
	void updateRegionWithRecruitmentNotice(int uid, int regionNo) throws Exception;
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * where_recruit_sigungu에 공고에 등록 된 도시를 수정하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @param int sigunguNo
	 *
	 */
	void updateSigunguWithRecruitmentNotice(int uid, int sigunguNo);
	


}
