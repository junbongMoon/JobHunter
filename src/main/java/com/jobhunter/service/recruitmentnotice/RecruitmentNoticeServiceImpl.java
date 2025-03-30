package com.jobhunter.service.recruitmentnotice;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.jobtype.JobDAO;
import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.dao.region.RegionDAO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RecruitmentNoticeServiceImpl implements RecruitmentNoticeService {

	// DAO단
	private final RecruitmentNoticeDAO recdao;
	private final RegionDAO regiondao;
	private final JobDAO jobdao;

	

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO, List<AdvantageDTO> advantageList, List<ApplicationDTO> applicationList, String regionCode, String sigunguCode, List<RecruitmentnoticeBoardUpfiles> fileList, String majorCategortCode, String subCategoryCode) throws Exception {
		boolean result = false;
		int CompanyUid = recruitmentNoticeDTO.getRefCompany();
		int recNo = 0;

//		if(recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {
//			result = true;
//		}

		// 공고를 제출하는 메서드
		if (recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {

			// 여러가지 값을 가질 수 있는 것도 저장 해야함 트랜잭션으로 묶어서 공고를 선입력하고 그 uid값을 참조하는 것으로 insert하자
			// 여기서 가장 최근 공고를 조회하는 메서드로 방금 올린 유저의 공고를 가져오자
			 
			recNo = recdao.selectRecentRecruitment(CompanyUid);

			// 파일 아직 대기중

		}
		// 우대 조건을 입력하는 메서드 호출
		if(!advantageList.isEmpty()) {
			// advantageList에서 하나씩 꺼내서 insert
			for(AdvantageDTO advDTO : advantageList) {
				advDTO.setRecruitmentNoticeUid(recNo);
				// 여기서 insert
				recdao.insertAdvantageWithRecruitmentNotice(advDTO);
			}
		}
		if(!applicationList.isEmpty()) {
			for(ApplicationDTO aplDTO : applicationList) {
				aplDTO.setRecruitmentNoticeUid(recNo);
				// 여기서 insert
				recdao.insertApplicationWithRecruitmentNotice(aplDTO);
			}
		}
		if(StringUtils.hasText(regionCode)) {
			// 여기서 insert
			
			regiondao.insertRegionWithRecruitmentNotice(recNo, Integer.parseInt(regionCode));
		}
		if(StringUtils.hasText(sigunguCode)) {
			// 여기서 insert
			regiondao.insertSigunguWithRecruitmentNotice(recNo, Integer.parseInt(regionCode));
		}
		if(fileList.size() > 0) {
			for(RecruitmentnoticeBoardUpfiles file : fileList) {
				// 여기서 insert
				file.setRefrecruitmentnoticeNo(recNo);
				recdao.insertRecruitmentFile(file);
			}
		}
		if(StringUtils.hasText(majorCategortCode)) {
			// 여기서 insert
			jobdao.insertMajorCategoryWithRecruitmentnotice(recNo, Integer.parseInt(majorCategortCode));
			
		}
		if(StringUtils.hasText(subCategoryCode)) {
			// 여기서 insert
			jobdao.insertSubCategoryWithRecruitmentnotice(recNo, Integer.parseInt(subCategoryCode));
		}
			
			
		return result;
	}

	// 내가 쓴 공고 모두를 조회하는 메서드
	@Override
	public List<RecruitmentNotice> getRecruitmentByUid(int uid) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	
	// 공고 전체를 조회하는 메서드
	@Override
	public PageResponseDTO<RecruitmentDetailInfo> getEntireRecruitment(PageRequestDTO pageRequestDTO) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}
	

	

}
