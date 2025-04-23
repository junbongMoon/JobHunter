package com.jobhunter.dao.reviewboard;

import java.time.LocalDateTime;
import java.util.List;

import com.jobhunter.model.reviewboard.Likes;
import com.jobhunter.model.reviewboard.RPageRequestDTO;
import com.jobhunter.model.reviewboard.RPageResponseDTO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewBoardWithReplyVO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;

public interface ReviewBoardDAO {

	List<ReviewBoardDTO> selectListBoard() throws Exception;

	List<RecruitmentnoticContentDTO> selectWriteGonggo(int userUid) throws Exception;

	int insertBoard(WriteBoardDTO writeBoardDTO) throws Exception;

	ReviewDetailViewDTO selectReviewInfo(int boardNo) throws Exception;

//	boolean selectLike(Likes like) throws Exception;

	int insertLike(Likes like) throws Exception;

	int updateBoardLikes(int boardNo) throws Exception;

	int deleteLike(int userId, int boardNo) throws Exception;

	int decreaseBoardLikes(int boardNo) throws Exception;

	WriteBoardDTO selectrecruitmentList(int boardNo) throws Exception;

	int updateReviewBoard(WriteBoardDTO modify) throws Exception;

	int deletBoardNo(int boardNo) throws Exception;

	int checkViewedWithHours(int userId, int boardNo) throws Exception;

	int incrementViews(int boardNo) throws Exception;

	int countAllBoards() throws Exception;

	List<ReviewBoardDTO> selectPagedReviewBoard(RPageRequestDTO pageRequestDTO) throws Exception;

	int countReviewBoard(RPageRequestDTO pageRequestDTO) throws Exception;

	int selectUserIdByBoardNo(int boardNo);

	void insertLog(int uid, String targetType, String logType);

	int insertOrUpdateReviewView(int userId, int boardNo, String viewType) throws Exception;

	int hasUserLikeit(Likes like) throws Exception;

	List<String> ListCompany() throws Exception;
	//신고 아이디 조
	Integer findWriterUidByBoardNo(int boardNo);

	List<ReviewBoardWithReplyVO> findMyReviewWithReply(RPageRequestDTO dto) throws Exception;

	int findMyReviewWithReplyCnt(RPageRequestDTO dto) throws Exception;

}
