package com.jobhunter.dao.like;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class LikeDAOImpl implements LikeDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.likemapper";

	@Override
	public int selectLikeCnt(int uid, String boardType) throws Exception {
	    Map<String, Object> param = new HashMap<>();
	    param.put("uid", uid);
	    param.put("boardType", boardType);
	    return ses.selectOne(NS + ".selectLikeCnt", param);
	}

	@Override
	public int selectHasLike(int userId, int uid, String boardType) throws Exception {
	    Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("uid", uid);
	    param.put("boardType", boardType);
	    return ses.selectOne(NS + ".selectHasLike", param);
	}

	@Override
	public int insertLikeLog(int userId, int uid, String boardType) throws Exception {
	    Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("uid", uid);
	    param.put("boardType", boardType);
	    return ses.insert(NS + ".insertLikeLog", param);
	}

	@Override
	public int deleteLikeLog(int userId, int uid, String boardType) throws Exception {
	    Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("uid", uid);
	    param.put("boardType", boardType);
	    return ses.delete(NS + ".deleteLikeLog", param);
	}

}
