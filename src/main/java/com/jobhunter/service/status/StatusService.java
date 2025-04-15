package com.jobhunter.service.status;

import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;

/**
 * @author 문준봉
 *
 */
public interface StatusService {
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 어제 자정 ~ 오늘 자정까지의 통계를 insert하는 메서드
	 * </p>
	 * 
	 *
	 */
	public void saveDateStatusByToDay();
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 어제 자정 ~ 오늘 자정까지의 누적 통계를 select 하는 메서드
	 * </p>
	 * 
	 * @return StatusVODTO
	 *
	 */
	public TotalStatusVODTO getTotalStatusUntilYesterday();
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	오늘 작성 된 통계를 얻어오는 메서드
	 * </p>
	 * 
	 * @return 오늘의 통계 StatusVODTO
	 *
	 */
	public StatusVODTO getTodayIncrement();


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	전체 통계를 insert 하는 메서드
	 * </p>
	 * 
	 * @param todayTotal
	 *
	 */
	public void saveEntireStatus(TotalStatusVODTO todayTotal);
	
	public void runDailyStatistics();
}
