package com.jobhunter.model.company;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@Getter
@ToString
public class CompanyInfoDTO {
	private Integer uid; // 사용자 고유 ID
    private String addr; // 주소
    private String detailAddr; // 상세주소
    
    private String scale; // 회사규모
    private String homePage; // 회사 홈페이지
    
    private String introduce; // 회사소개
    
    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public void setAddr(String addr) {
        this.addr = nullIfEmpty(addr);
    }

    public void setDetailAddr(String detailAddr) {
    	if (detailAddr != null && detailAddr.length() > 190) {
            detailAddr = detailAddr.substring(0, 190);
        }
    	
        this.detailAddr = nullIfEmpty(detailAddr);
    }

    public void setScale(String scale) {
        this.scale = nullIfEmpty(scale);
    }

    public void setHomePage(String homePage) {
    	if (homePage != null && homePage.length() > 190) {
    		homePage = homePage.substring(0, 190);
        }
    	
        this.homePage = nullIfEmpty(homePage);
    }

    public void setIntroduce(String introduce) {
        this.introduce = nullIfEmpty(introduce);
    }

    private String nullIfEmpty(String str) {
        return (str == null || str.trim().isEmpty()) ? null : str.trim();
    }
}
