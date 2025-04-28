package com.jobhunter.model.advancement;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class AdvancementDTO {
	private int advancementNo;
	private String title;
	private String writer;
	private int refUser;
	private String content;

}
