package com.jobhunter.dao.submit;

import java.util.List;

import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.submit.ResumeDetailInfoBySubmit;
import com.jobhunter.model.submit.Status;

public interface SubmitDAO {
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *	공고 PK로 제출한 이력서들을 페이징해서 담아오는 메서드
	 * </p>
	 * 
	 * @param int RecruitmentUid
	 * @param PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO
	 * @return 이력서 상세정보를 담은 리스트
	 * @throws Exception
	 *
	 */
	List<ResumeDetailInfoBySubmit> selectResumDetailInfoBySubmitByRecruitmentUid(int RecruitmentUid, 
			PageResponseDTO<ResumeDetailInfoBySubmit> pageResponseDTO) throws Exception;
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고에 제출한 이력서 row수를 가져오는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 조건에 맞는 이력서의 총 row 수
	 * @throws Exception
	 *
	 */
	int selectTotalCountRowOfResumeByUid(int uid) throws Exception;
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 이력서에 있는 파일을 조회하는 메서드
	 * </p>
	 * 
	 * @param int uid
	 * @return 이력서에 저장된 파일 리스트
	 * @throws Exception
	 *
	 */
	List<ResumeUpfileDTO> selectUpfileListByResume(int uid) throws Exception;
	
	 
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *  제출 이력의 상태를 변경 해주는 메서드
	 * </p>
	 * 
	 * @param Status status
	 * @param int resumePk
	 * @param int recruitmentNoticePk
	 * @return 상태 변경을 성공 하면 1, 실패 하면 0
	 *
	 */
	int updateStatusByRegistration(Status status, int resumePk, int recruitmentNoticePk);
}
