package com.jobhunter.dao.status;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

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
    public TotalStatusVODTO selectTotalStatusByYesterDay
    (LocalDate yesterday, LocalDateTime start, LocalDateTime end){
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

}
