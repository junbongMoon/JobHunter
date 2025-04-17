package com.jobhunter.dao.status;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class StatusDAOImpl implements StatusDAO {

	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.statusmapper";

	@Override
	public void insertStatusDate(StatusVODTO status) {
		ses.insert(NS + ".saveDateStatus", status);

	}

	@Override
	public StatusVODTO selectStatusByYesterDay(LocalDate yesterday) {

		return ses.selectOne(NS + ".getDateStatusByYesterDay", yesterday);
	}

	@Override
	public TotalStatusVODTO selectTotalStatusByYesterDay(LocalDate yesterday, LocalDateTime start, LocalDateTime end) {
		Map<String, Object> params = new HashMap<>();
		params.put("start", start);
		params.put("end", end);
		System.out.println(params);
		return ses.selectOne(NS + ".getTotalStatusByYesterDay", params);
	}

	@Override
	public void insertTotalStatus(TotalStatusVODTO status) {
		ses.insert(NS + ".insertTotalStatus", status);
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * start ~ end까지의 tagetType의 Log 갯수를 조회하는 메서드
	 * </p>
	 * 
	 * @param start
	 * @param end
	 * @param string
	 * @return int start ~ end까지의 tagetType의 Log 갯수
	 *
	 */
	@Override
	public int selectLogCntBetweenAndRole(LocalDateTime start, LocalDateTime end, String targetType, String logType) {
		 
		Map<String, Object> params = new HashMap<>();
	    params.put("start", start);
	    params.put("end", end);
	    params.put("targetType", targetType);
	    params.put("logType", logType);
		
	    return ses.selectOne(NS + ".getCountLogBetweenStartAndEndByTarget", params);
		
	}

	@Override
	public List<StatusVODTO> getStatusBetweenAndRole(LocalDateTime start, LocalDateTime end) {
		Map<String, Object> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);
		

		return ses.selectList(NS + ".getDailyStatusBetweenStartAndEndByTarget", param);
	}

	@Override
	public List<TotalStatusVODTO> getTotalStatusBetweenAndRole(LocalDateTime start, LocalDateTime end)
			throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("start", start);
		param.put("end", end);
		
		
		return ses.selectList(NS + ".getTotalStatusBetweenStartAndEndByTarget", param);
	}

}
