package com.jobhunter.model.advancement;

import java.time.LocalDateTime;
import java.util.List;

import com.jobhunter.model.submit.Status;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class AdvancementVO {
	private int advancementNo;
	private String title;
	private String writer;
	private int refUser;
	private String content;
	private LocalDateTime postDate;
	private Status status;
	private String formattedPostDate;
	
	
	
	private List<AdvancementUpFileVODTO> fileList;
}
