package com.jobhunter.service.company;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jobhunter.dao.company.CompanyDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.BusinessRequestDTO;
import com.jobhunter.model.company.CompanyInfoDTO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;
import com.jobhunter.util.PropertiesTask;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CompanyServiceImpl implements CompanyService {

	private final CompanyDAO dao;
	
	@Override
	public boolean updateCompanyInfo(CompanyInfoDTO companyInfo) throws Exception {
		return dao.updateCompanyInfo(companyInfo) > 0;
	}
	
	@Override
	public CompanyVO showCompanyHome(int uid) throws Exception {
		return dao.getCompanyInfo(uid);
	}
	
	@Override
	public boolean checkPassword(int uid, String password) throws Exception {
		AccountVO account = dao.findByUidAndPassword(uid, password);
		if (account == null) {
			return false;
		}
	    return true;
	}
	
	@Override
	public void updatePassword(PasswordDTO dto) throws Exception {
	    dao.updatePassword(dto);
	}
	
	@Override
	public String updateContact(ContactUpdateDTO dto) throws Exception {
	    dao.updateContact(dto);
	    return dto.getValue();
	}
	
	@Override
	public String valiedBusiness(BusinessRequestDTO dto) throws Exception {
		
			String serviceKey = PropertiesTask.getPropertiesValue("config/business.properties", "api.key");
            // 외부 API URL
            String apiUrl = "https://api.odcloud.kr/api/nts-businessman/v1/validate?serviceKey=" + serviceKey;

            // 요청 바디 구성
            Map<String, Object> requestBody = new HashMap<>();
            List<Map<String, Object>> businesses = new ArrayList<>();
            Map<String, Object> business = new HashMap<>();
            business.put("b_no", dto.getB_no());
            business.put("start_dt", dto.getStart_dt());
            business.put("p_nm", dto.getP_nm());
            business.put("p_nm2", "");
            business.put("b_nm", "");
            business.put("corp_no", "");
            business.put("b_sector", "");
            business.put("b_type", "");
            business.put("b_adr", "");
            businesses.add(business);
            requestBody.put("businesses", businesses);

            // HttpClient 구성
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.postForEntity(apiUrl, entity, String.class);

            // JSON 문자열 → JsonNode 파싱
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode rootNode = objectMapper.readTree(response.getBody());

            // 예: valid 값 가져오기
            String valid = rootNode.get("data").get(0).get("valid").asText();
            
            return valid;
	}

	@Override
	public boolean isCompanyIdExists(String companyId) throws Exception {
		return dao.findIsCompanyById(companyId);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public 
	AccountVO registCompany(CompanyRegisterDTO dto) throws Exception {
		Integer uid = dao.registCompany(dto);
		return dao.findByUidAndPassword(uid, dto.getPassword());
	}
	
	@Override
	public void deleteContact(ContactUpdateDTO dto) throws Exception {
		if(dto.getType().equals("mobile")) {
			if(dao.deleteMobile(dto.getUid()) != 1) {
				throw new Exception();
			}
		} else {
			if(dao.deleteEmail(dto.getUid()) != 1) {
				throw new Exception();
			}
		}
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public Timestamp setDeleteAccount(Integer uid) throws Exception {
		dao.setDeleteAccount(uid);
		return dao.getDeleteAccount(uid);
	}
	
	@Override
	public void cancelDeleteAccount(Integer uid) throws Exception {
		dao.cancelDeleteAccount(uid);
	}
	
	@Override
	public void updateProfileImg(Integer uid, String base64) throws Exception {
		dao.updateProfileImg(uid, base64);
	}

	@Override
	public void deleteProfileImg(Integer uid) throws Exception {
		dao.updateProfileImg(uid, null);
	}
	
}
