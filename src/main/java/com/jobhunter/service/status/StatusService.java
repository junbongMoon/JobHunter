package com.jobhunter.service.status;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.status.FullStatus;
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
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 일일 통계, 전체 통계를 insert 하는 메서드
	 * </p>
	 * 
	 *
	 */
	public void runDailyStatistics();
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 일일 차트를 페이징해서 조회하는 메서드
	 * </p>
	 * 
	 * @param pageRequestDTO (현재 페이지, 페이지 당 출력할 row의 수)
	 * @return 페이징 된 일일 데이터
	 * @throws Exception
	 *
	 */
	public List<StatusVODTO> getDailyChartByPaging(LocalDateTime start, LocalDateTime end) throws Exception;


	public List<TotalStatusVODTO> getTotalStatusBetweenStartAndEnd(LocalDateTime start, LocalDateTime end) throws Exception;


	public List<String> getYearAndMonth() throws Exception;


	public FullStatus getFullStatusByMonth(String ym) throws Exception;
}
