package com.jobhunter.dao.admin;

import java.util.List;
import java.util.Map;

import com.jobhunter.model.user.UserVO;

public interface AdminDAO {

	List<UserVO> getAllUsers() throws Exception;

	UserVO getUserById(int uid) throws Exception;

	List<UserVO> getUsersBySearch(Map<String, Object> params) throws Exception;

	int getTotalUserCount(Map<String, Object> params) throws Exception;

	int blockUser(Map<String, Object> params) throws Exception;

	int unblockUser(int uid) throws Exception;

}
