package com.jobhunter.model.status;

import java.util.List;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Data
@ToString
@Builder
public class FullStatus {
	
	private List<StatusVODTO> statusList;
	private List<TotalStatusVODTO> totalStatusList;

}
