package com.jobhunter.controller.region;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.etc.AddrSearchDTO;
import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;
import com.jobhunter.service.region.RegionService;
import com.jobhunter.util.PropertiesTask;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/region")
public class RegionController {
	private final RegionService regionService;

	// 도시 전체 갖고 오는 메서드
	@GetMapping("/list")
	public ResponseEntity<List<Region>> getRegionList() {
		ResponseEntity<List<Region>> result = null;

		try {
			result = ResponseEntity.ok(regionService.getRegionList());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
		}

		return result;
	}

	// 시군구 전체 갖고 오는 메서드
	@GetMapping("/sigungu/{regionNo}")
	public ResponseEntity<List<Sigungu>> getSigunguList(@PathVariable("regionNo") int regionNo) {
		ResponseEntity<List<Sigungu>> result = null;

		try {
			result = ResponseEntity.ok(regionService.getSigunguList(regionNo));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			result = ResponseEntity.badRequest().body(null);
		}

		return result;
	}

	@PostMapping(value = "/getAddrApi", produces = "application/json; charset=utf-8")
	public ResponseEntity<String> searchBlog(@RequestBody AddrSearchDTO dto, HttpServletResponse response) {
		try {
			String confmKey = PropertiesTask.getPropertiesValue("config/address.properties", "api.key"); // 승인키

			String currentPage = dto.getCurrentPage();
			String keyword = dto.getKeyword();

			String apiUrl = "https://business.juso.go.kr/addrlink/addrLinkApi.do?resultType=json&countPerPage=10&currentPage="
					+ currentPage + "&keyword="
					+ URLEncoder.encode(keyword, "UTF-8") + "&confmKey="
					+ confmKey;

			URL url = new URL(apiUrl);
			BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
			StringBuffer sb = new StringBuffer();
			String tempStr = null;
			while (true) {
				tempStr = br.readLine();
				if (tempStr == null)
					break;
				sb.append(tempStr);
			}
			br.close();

			return ResponseEntity.status(HttpStatus.OK).body(sb.toString());
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

}
