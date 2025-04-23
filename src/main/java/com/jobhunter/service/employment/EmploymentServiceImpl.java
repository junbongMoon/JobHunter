package com.jobhunter.service.employment;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.w3c.dom.Element;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.jobhunter.model.employment.EmploymentDTO;
import com.jobhunter.util.PropertiesTask;

@Service
public class EmploymentServiceImpl implements EmploymentService {

	@Override
	public List<EmploymentDTO> getEmployment(int page) throws Exception {

		List<EmploymentDTO> jobs = new ArrayList<>();
		String apiKey = PropertiesTask.getPropertiesValue("config/employment.properties", "work24.api.key");
		System.out.println("🔑 불러온 API 키: " + apiKey);  // 이 줄 추가
		if (apiKey == null || apiKey.isEmpty()) {
			throw new IllegalStateException("API 키를 불러올 수 없습니다. work24.properties를 확인하세요.");
		}

		String apiUrl = "https://www.work24.go.kr/cm/openApi/call/wk/callOpenApiSvcInfo210L21.do"
	            + "?authKey=" + apiKey
	            + "&callTp=L&returnType=XML"
	            + "&startPage=" + page
	            + "&display=9";
		
		URL url = new URL(apiUrl);
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(url.openStream());
		doc.getDocumentElement().normalize();

		NodeList nList = doc.getElementsByTagName("dhsOpenEmpInfo");
		System.out.println("📄 공고 수: " + nList.getLength()); // ← 이 줄 추가
		for (int i = 0; i < nList.getLength(); i++) {
			Element elem = (Element) nList.item(i);
			 System.out.println("✅ 제목: " + getTagValue("empWantedTitle", elem));
			
			EmploymentDTO job = new EmploymentDTO();
			
			job.setEmpSeqno(getTagValue("empSeqno", elem));
			job.setEmpWantedTitle(getTagValue("empWantedTitle", elem));
			job.setEmpBusiNm(getTagValue("empBusiNm", elem));
			job.setCoClcdNm(getTagValue("coClcdNm", elem));
			job.setEmpWantedStdt(formatDate(getTagValue("empWantedStdt", elem)));
			job.setEmpWantedEndt(formatDate(getTagValue("empWantedEndt", elem)));
			job.setEmpWantedTypeNm(getTagValue("empWantedTypeNm", elem));
			job.setRegLogImgNm(getTagValue("regLogImgNm", elem));
			job.setEmpWantedHomepgDetail(getTagValue("empWantedHomepgDetail", elem));

			jobs.add(job);
		}

		return jobs;
	}

	private String formatDate(String yyyymmdd) {
		if (yyyymmdd != null && yyyymmdd.length() == 8) {
			return yyyymmdd.substring(0, 4) + "-" + yyyymmdd.substring(4, 6) + "-" + yyyymmdd.substring(6, 8);
		}
		return yyyymmdd; // 형식 이상할 때 그냥 반환
	}

	private String getTagValue(String tag, Element element) {
		NodeList nodeList = element.getElementsByTagName(tag);
		if (nodeList.getLength() > 0 && nodeList.item(0).getFirstChild() != null) {
			return nodeList.item(0).getTextContent();
		}
		return "";
	}

}
