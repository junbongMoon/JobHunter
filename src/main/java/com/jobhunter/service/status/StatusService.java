package com.jobhunter.service.status;

import com.jobhunter.model.status.StatusVODTO;

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
	 * 어제 자정 ~ 오늘 자정까지의 통계를 select 하는 메서드
	 * </p>
	 * 
	 * @return StatusVODTO
	 *
	 */
	public StatusVODTO getTotalStatusUntilYesterday();
	
	
	
}
