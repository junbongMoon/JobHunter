package com.jobhunter.dao.like;

public interface LikeDAO {
	// 게시물의 좋아요 로그의 갯수를 조회하는 메서드
	public int selectLikeCnt(int uid, String boardType) throws Exception;
	
	// 게시물에 해당 유저가 좋아요를 했는지 안했는지 조회하는 메서드
	public int selectHasLike(int userId, int uid, String boardType) throws Exception;
	
	// 게시물에 좋아요 버튼을 누르면 좋아요로그를 저장하는 메서드
	public int insertLikeLog(int userId, int uid, String boardType) throws Exception;
	
	// 게시물에 좋아요 취소버튼을 누르면 좋아요 로그를 삭제하는 메서드
	public int deleteLikeLog(int userId, int uid, String boardType) throws Exception;
}
