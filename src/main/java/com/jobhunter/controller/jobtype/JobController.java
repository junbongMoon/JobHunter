package com.jobhunter.controller.jobtype;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jobhunter.service.jobtype.JobService;

@Controller
@RequestMapping("/job")
public class JobController {

    @Autowired
    private JobService jobService;
    
    @GetMapping("/categoryJobType")
    public void addJobCategory() {
    }

    @GetMapping("/fetch")
    public ResponseEntity<String> fetchJobData() {
        try {
            jobService.fetchAndSaveJobData();
            return ResponseEntity.ok("데이터 저장 성공");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("데이터 저장 실패: " + e.getMessage());
        }
    }
    
    @GetMapping("/fetchSubcategory")
    @ResponseBody
    public ResponseEntity<String> fetchSubcategoryData() {
        try {
            jobService.fetchAndSaveSubcategoryData();
            return ResponseEntity.ok("소분류 데이터 저장 성공");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("소분류 데이터 저장 실패: " + e.getMessage());
        }
    }
}

