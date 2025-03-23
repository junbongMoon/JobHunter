package com.jobhunter.service.recruitmentnotice;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.dao.region.RegionDAO;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
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
	
	// 임시저장 할 List, 코드들
	private final List<AdvantageDTO> advantageList = new ArrayList<>();
    private final List<ApplicationDTO> applicationList = new ArrayList<>();
    private String regionCode;
    private String sigunguCode;
    private final List<RecruitmentnoticeBoardUpfiles> newFileList = new ArrayList<>();
    private String majorCategoryCode;

	@Override
	@Transactional(propagation = Propagation.REQUIRES_NEW, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception {
		boolean result = false;
		int CompanyUid = recruitmentNoticeDTO.getRefCompany();
		
//		if(recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {
//			result = true;
//		}
		
		// 공고를 제출하는 메서드
		if(recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {
			
			
		// 여러가지 값을 가질 수 있는 것도 저장 해야함 트랜잭션으로 묶어서 공고를 선입력하고 그 uid값을 참조하는 것으로 insert하자
		// 여기서 가장 최근 공고를 조회하는 메서드로 방금 올린 유저의 공고를 가져오자	
		RecruitmentNotice rec = recdao.selectRecentRecruitment(CompanyUid);
		int recNo = rec.getUid();
		// application(), advantage(우대 조건), recruitmentNoticeBoardUpfiles(저장할 파일)
		// where_recruit_region&Sigungu(지역 대분류만도 가능), jobtype_recruit_major(직종), 
		
		// 우대조건을 insert하는 메서드 호출, 리스트가 비어있지 않다면 실행
		if(!advantageList.isEmpty()) {			
			for(AdvantageDTO adventageDTO : advantageList) {
				adventageDTO.setRecruitmentNoticeUid(recNo);
				recdao.insertAdvantageWithRecruitmentNotice(adventageDTO);
					// 우대조건 저장 성공
									
			}
		}
		// 면접방식을 insert하는 메서드 호출, 리스트가 비어있지 않다면...
		if(!applicationList.isEmpty()) {
			for(ApplicationDTO applicationDTO : applicationList) {
				applicationDTO.setRecruitmentNoticeUid(recNo);
				recdao.insertApplicationWithRecruitmentNotice(applicationDTO);
			}
		}
		// 지역
		if(StringUtils.hasText(this.regionCode)){
			int regionCodeForInt = Integer.parseInt(this.regionCode);
			regiondao.insertRegionWithRecruitmentNotice(recNo, regionCodeForInt);
		}
		// 시,군,구
		if(StringUtils.hasText(this.sigunguCode)) {
			int sigunguCodeForInt = Integer.parseInt(this.sigunguCode);
			regiondao.insertSigunguWithRecruitmentNotice(recNo, sigunguCodeForInt);
		}
			result = true;
		}
		
		// 산업군도 있다..
		if(StringUtils.hasText(this.majorCategoryCode)) {
			int majorCategoryForInt = Integer.parseInt(this.majorCategoryCode);
			
		}
		
		return result;
	}
	
	
	
	// 내가 쓴 공고 모두를 조회하는 메서드
	@Override
	public List<RecruitmentNotice> getRecruitmentByUid(int uid) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}


	// 우대조건을 리스트에 저장하는 메서드(성공)
	@Override
	public void saveAdvantage(AdvantageDTO advantageDTO) throws Exception {
		
		advantageList.add(advantageDTO);
		System.out.println(advantageList);
		
	}
	
	


	// 접수 방식을 리스트에 저장하는 메서드
	@Override
	public void saveApplication(ApplicationDTO applicationDTO) {
		applicationList.add(applicationDTO);
		System.out.println(applicationList);
		
	}


	// 지역을 필드에 임시저장하는 메서드
	@Override
	public boolean saveRegion(String regionCode) {
		
		boolean result = false; 
		
		this.regionCode = regionCode;
		System.out.println(this.regionCode);
		
		if(StringUtils.hasText(this.regionCode)) {
			result = true;
		}
		
		return result;
	}


	// 시군구를 필드에 임시저장하는 메서드
	@Override
	public boolean saveSigungu(String sigunguCode) {
		
		boolean result = false;
		
		this.sigunguCode = sigunguCode;
		System.out.println(this.sigunguCode);
		
		if(StringUtils.hasText(this.sigunguCode)) {
			result = true;
		}
		
		return result;
	}


	// 필드에 직업 대분류 임시 저장하는 메서드
	@Override
	public boolean saveMajorCetegory(String majorCategoryNo) {
		
		boolean result = false;
		
		this.majorCategoryCode = majorCategoryNo;
		System.out.println(this.majorCategoryCode);
		
		if(StringUtils.hasText(this.majorCategoryCode)) {
			result = true;
		}
		
		return result;
		
	}


	// 리스트, 필드를 전부 비워주는 메서드 (다 하고 맨 밑으로 내리자)
		private void ListAllClear() {
			this.advantageList.clear();
			this.applicationList.clear();
			this.newFileList.clear();
			this.regionCode = null;
			this.sigunguCode = null;
			this.majorCategoryCode = null;
			
		}

	

}
