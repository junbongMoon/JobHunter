package com.jobhunter.controller;

import java.io.IOException;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.util.CompressImgUtil;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/util")
@RequiredArgsConstructor
public class UtilController {
	
	private final CompressImgUtil compressImgUtil;
	
	@PostMapping("/compressImg")
	public ResponseEntity<byte[]> compressImage(@RequestParam("file") MultipartFile file, @RequestParam("maxSize") int maxSizeBytes) {
	    try {
	        byte[] compressedJpg = compressImgUtil.compressToJpg(file, maxSizeBytes);

	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(MediaType.IMAGE_JPEG);
	        headers.setContentLength(compressedJpg.length);

	        return new ResponseEntity<>(compressedJpg, headers, HttpStatus.OK);

	    } catch (IOException e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	    }
	}
}
