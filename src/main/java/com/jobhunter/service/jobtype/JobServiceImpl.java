package com.jobhunter.service.jobtype;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.jobhunter.dao.jobtype.JobDAO;


@Service
@PropertySource("classpath:config/jobtype.properties")
public class JobServiceImpl implements JobService {

    @Autowired
    private JobDAO jobDAO;
    
    @Value("${authKey}")
    private String apiKey;

    @Override
    public void fetchAndSaveJobData() throws Exception {
        String apiUrl = "https://www.work24.go.kr/cm/openApi/call/wk/callOpenApiSvcInfo212L01.do"
                + "?authKey=" + apiKey
                + "&returnType=XML"
                + "&target=JOBCD";

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(apiUrl, String.class);
        String xmlData = response.getBody();

        // XML 데이터 파싱
        Set<String> jobCategories = parseXML(xmlData);

        // 중복 제거 후 DB 저장
        for (String jobName : jobCategories) {
            jobDAO.insertJobCategory(jobName);
        }
    }

    private Set<String> parseXML(String xmlData) throws Exception {
        Set<String> jobCategories = new HashSet<>();
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document document = builder.parse(new InputSource(new StringReader(xmlData)));

        NodeList jobList = document.getElementsByTagName("jobList");

        for (int i = 0; i < jobList.getLength(); i++) {
            Element jobElement = (Element) jobList.item(i);
            String jobClcdNM = jobElement.getElementsByTagName("jobClcdNM").item(0).getTextContent().trim();
            jobCategories.add(jobClcdNM); // 중복 방지
        }
        return jobCategories;
    }
    
    
    @Override
    public void fetchAndSaveSubcategoryData() throws Exception {
    	String apiUrl = "https://www.work24.go.kr/cm/openApi/call/wk/callOpenApiSvcInfo212L01.do"
                + "?authKey=" + apiKey
                + "&returnType=XML"
                + "&target=JOBCD";
    	
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(apiUrl, String.class);
        String xmlData = response.getBody();

        // XML 데이터 파싱
        List<Map<String, String>> subcategoryList = parseXMLsec(xmlData);

        // DB 저장
        for (Map<String, String> subcategory : subcategoryList) {
            String majorCategoryName = subcategory.get("majorCategory"); // 대분류명
            String subCategoryName = subcategory.get("subCategory"); // 소분류명

            // 대분류 테이블에서 majorcategoryNo 찾기
            Integer majorCategoryNo = jobDAO.findMajorCategoryNoByName(majorCategoryName);
            
            if (majorCategoryNo != null) {
                // 소분류를 저장할 때 대분류 번호를 함께 저장
                jobDAO.insertSubcategory(majorCategoryNo, subCategoryName);
            } else {
                System.out.println("대분류 없음 (저장되지 않음): " + majorCategoryName);
            }
        }
    }

    private List<Map<String, String>> parseXMLsec(String xmlData) throws Exception {
        List<Map<String, String>> subcategoryList = new ArrayList<>();
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document document = builder.parse(new InputSource(new StringReader(xmlData)));

        NodeList jobList = document.getElementsByTagName("jobList");

        for (int i = 0; i < jobList.getLength(); i++) {
            Element jobElement = (Element) jobList.item(i);
            String jobClcdNM = jobElement.getElementsByTagName("jobClcdNM").item(0).getTextContent().trim(); // 대분류명
            String jobNm = jobElement.getElementsByTagName("jobNm").item(0).getTextContent().trim(); // 소분류명

            Map<String, String> subcategoryMap = new HashMap<>();
            subcategoryMap.put("majorCategory", jobClcdNM);
            subcategoryMap.put("subCategory", jobNm);
            subcategoryList.add(subcategoryMap);
        }
        return subcategoryList;
    }
}
