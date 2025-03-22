package com.jobhunter.service.recruitmentnotice;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNotice;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RecruitmentNoticeServiceImpl implements RecruitmentNoticeService {
	
	private final RecruitmentNoticeDAO recdao;
	private final List<AdvantageDTO> advantageList = new ArrayList<>();
    private final List<ApplicationDTO> applicationList = new ArrayList<>();
    private final List<Region> regionList = new ArrayList<>();
    private final List<Sigungu> sigunguList = new ArrayList<>();
    private final List<RecruitmentnoticeBoardUpfiles> newFileList = new ArrayList<>();

	@Override
	@Transactional(propagation = Propagation.REQUIRES_NEW, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean saveRecruitmentNotice(RecruitmentNoticeDTO recruitmentNoticeDTO) throws Exception {
		boolean result = false;
		int CompanyUid = 0;
		
		if(recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {
			result = true;
		}
		
		// 공고를 제출하는 메서드
//		if(recdao.insertRecruitmentNotice(recruitmentNoticeDTO) > 0) {
			
			
		// 여러가지 값을 가질 수 있는 것도 저장 해야함 트랜잭션으로 묶어서 공고를 선입력하고 그 uid값을 참조하는 것으로 insert하자
		// 여기서 공고를 조회하는 메서드로 해당 유저의 공고를 가져오자	
		
		// application(), advantage(우대 조건), recruitmentNoticeBoardUpfiles(저장할 파일)
		// where_recruit_region&Sigungu(지역 대분류만도 가능), jobtype_recruit_major(직종), 
		
		// 우대조건을 insert하는 메서드 호출, 리스트가 비어있지 않다면 실행
//		if(!advantageList.isEmpty()) {
//			
//			for(AdvantageDTO adv : advantageList) {
//				if(recdao.insertAdvantageWithRecruitmentNotice(adv, ) > 0) {
//					// 우대조건 저장 성공
//				}else {
//					// 우대조건 저장 실패
//				}
//			}
//		}
//		// 
//		if(!applicationList.isEmpty()) {
//			
//		}
//		}
		return result;
	}
	
	
	
	// 공고를 조회하는 메서드
	@Override
	public List<RecruitmentNotice> getRecruitmentByUid(int uid) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}


	// 우대조건을 리스트에 저장하는 메서드
	@Override
	public void saveAdvantage(AdvantageDTO advantageDTO) throws Exception {
		
		advantageList.add(advantageDTO);
		
	}
	
	
	

	

}
