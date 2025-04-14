package com.jobhunter.dao.status;

import java.time.LocalDate;

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
	
    
    public TotalStatusVODTO selectTotalStatusByYesterDay(LocalDate yesterday);

    
    public void insertTotalStatus(TotalStatusVODTO status);
    

}
