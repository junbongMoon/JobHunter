package com.jobhunter.service.like;

public interface LikeService {
	
	// 게시물의 좋아요 수를 조회하는 메서드
	public int getLikeCntByRecruitment(int uid, String boardType) throws Exception;
	
	// 게시물에 해당 유저가 좋아요를 했는지 안했는지 조회하는 메서드
	public boolean hasLiked(int userId, int uid, String boardType) throws Exception;
	
	// 유저가 좋아요 버튼을 누르면 좋아요 로그를 저장하는 메서드
	public boolean saveLike(int userId, int uid, String boardType) throws Exception;
	
	// 유저가 좋아요 취소 버튼을 누르면 좋아요 로그를 삭제하는 메서드
	public boolean deleteLike(int userId, int uid, String boardType) throws Exception;
}
