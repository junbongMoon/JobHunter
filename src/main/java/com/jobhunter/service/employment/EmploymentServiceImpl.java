package com.jobhunter.service.employment;

import java.net.URL;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.jobhunter.model.employment.EmploymentDTO;
import com.jobhunter.model.employment.EmploymentPageDTO;
import com.jobhunter.util.PropertiesTask;

@Service
public class EmploymentServiceImpl implements EmploymentService {

	@Override
	public EmploymentPageDTO getEmployment(int page, int display, String keyword, String sort) throws Exception {
	    String apiKey = PropertiesTask.getPropertiesValue("config/employment.properties", "work24.api.key");
	    String apiUrl = "https://www.work24.go.kr/cm/openApi/call/wk/callOpenApiSvcInfo210L21.do"
	            + "?authKey=" + apiKey
	            + "&callTp=L&returnType=XML"
	            + "&startPage=1"
	            + "&display=1000"; // 충분히 많이 받아오기 (API는 최대 1000개 반환 가능)

	    URL url = new URL(apiUrl);
	    DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
	    Document doc = dBuilder.parse(url.openStream());
	    doc.getDocumentElement().normalize();

	    NodeList nList = doc.getElementsByTagName("dhsOpenEmpInfo");
	    List<EmploymentDTO> jobs = new ArrayList<>();

	    for (int i = 0; i < nList.getLength(); i++) {
	        Element elem = (Element) nList.item(i);
	        String title = getTagValue("empWantedTitle", elem);
	        String company = getTagValue("empBusiNm", elem);

	        if (keyword == null || title.contains(keyword) || company.contains(keyword)) {
	            EmploymentDTO job = new EmploymentDTO();
	            job.setEmpSeqno(getTagValue("empSeqno", elem));
	            job.setEmpWantedTitle(title);
	            job.setEmpBusiNm(company);
	            job.setCoClcdNm(getTagValue("coClcdNm", elem));
	            job.setEmpWantedStdt(formatDate(getTagValue("empWantedStdt", elem)));
	            job.setEmpWantedEndt(formatDate(getTagValue("empWantedEndt", elem)));
	            job.setEmpWantedTypeNm(getTagValue("empWantedTypeNm", elem));
	            job.setRegLogImgNm(getTagValue("regLogImgNm", elem));
	            job.setEmpWantedHomepgDetail(getTagValue("empWantedHomepgDetail", elem));
	            jobs.add(job);
	        }
	    }

	    // 정렬
	    if ("deadline".equals(sort)) {
	        jobs.sort(Comparator.comparing(EmploymentDTO::getEmpWantedEndt));
	    } else if ("company".equals(sort)) {
	        jobs.sort(Comparator.comparing(EmploymentDTO::getEmpBusiNm));
	    } else {
	        jobs.sort(Comparator.comparing(EmploymentDTO::getEmpWantedStdt).reversed());
	    }

	    int filteredTotal = jobs.size();
	    int fromIndex = (page - 1) * display;
	    int toIndex = Math.min(fromIndex + display, filteredTotal);
	    List<EmploymentDTO> pagedList = jobs.subList(fromIndex, toIndex);

	    return new EmploymentPageDTO(pagedList, filteredTotal);
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
