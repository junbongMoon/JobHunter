package com.jobhunter.model.resume;

import java.sql.Date;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@Getter
@Setter
@ToString
public class LicenceDTO {
	private int licenceNo;
    private String licenceName;
    private Date licencecol; // 자격증 취득일
    private int resumeNo;
}
