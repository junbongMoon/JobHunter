package com.jobhunter.dao.status;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;

public interface StatusDAO {

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 일일 통계를 insert하는 메서드
	 * </p>
	 * 
	 * @param status(통계 합)
	 *
	 */
	void insertStatusDate(StatusVODTO status);

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 어제 통계를 얻어오는 메서드
	 * </p>
	 * 
	 * @param LocalDate 어제날짜
	 * @return StatusVODTO 어제 통계
	 *
	 */
	public StatusVODTO selectStatusByYesterDay(LocalDate yesterday);
	
    
    public TotalStatusVODTO selectTotalStatusByYesterDay(LocalDate yesterday, LocalDateTime start, LocalDateTime end);

    
    public void insertTotalStatus(TotalStatusVODTO status);

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 두개의 날짜값을 주고 그 사이의 targetType과 logType인 Log의 수를 조회하는 메서드
	 * </p>
	 * 
	 * @param start 시작 시간
	 * @param end 끝 시간
	 * @param String targetType
	 * @param logType
	 * @return int start ~ end 사이의 targetType과 logType인 Log의 수
	 *
	 */
	
	int selectLogCntBetweenAndRole(LocalDateTime start, LocalDateTime end, String tagetType, String logType);

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 조건에 해당 되는 status List를 조회하는 메서드
	 * </p>
	 * 
	 * @param pageRequestDTO
	 *
	 */
	List<StatusVODTO> getStatusBetweenAndRole(LocalDateTime start, LocalDateTime end) throws Exception;
    

}
