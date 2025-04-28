package com.jobhunter.dao.point;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;
import java.util.HashMap;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class PointDAOImpl implements PointDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.pointmapper";

	@Override
	public void submitAdvicePointLog(int mentorUid, int sessionUid, int point, int rgAdviceNo, String dueDate) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("mentorUid", mentorUid);
		params.put("sessionUid", sessionUid);
		params.put("point", point);
		params.put("rgAdviceNo", rgAdviceNo);
		params.put("dueDate", dueDate);
		ses.insert(NS + ".submitAdvicePointLog", params);
	}

	@Override
	public int updatePointLog(int rgAdviceNo, String status, String type) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("rgAdviceNo", rgAdviceNo);
		params.put("status", status);
		params.put("type", type);
		return ses.update(NS + ".updatePointLog", params);
	}
}
