package com.jobhunter.model.user;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class KakaoUserInfoDTO {
	private Integer uid;
	private String email;
    private String nickname;
    private Long kakaoId;
}
