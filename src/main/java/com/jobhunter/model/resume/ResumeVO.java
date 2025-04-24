package com.jobhunter.model.resume;

import java.util.List;
import lombok.Data;

@Data
public class ResumeVO {
    private int resumeNo;
    private String title;
    private int userUid;
    private String saveType;
	private String regDate;
    private List<SigunguVO> sigunguList;
    private List<SubCategoryVO> subcategoryList;
    private boolean checked;  // 이력서가 기업에서 확인되었는지 여부
    private boolean advice;  // 이력서가 첨삭 중인지 여부
} 