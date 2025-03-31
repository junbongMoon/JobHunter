package com.jobhunter.model.resume;

import java.util.List;
import lombok.Data;

@Data
public class ResumeVO {
    private int resumeNo;
    private String title;
    private int uid;
    private String saveType;
    private List<SigunguVO> sigunguList;
    private List<SubCategoryVO> subcategoryList;
} 