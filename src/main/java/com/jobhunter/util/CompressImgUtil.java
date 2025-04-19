package com.jobhunter.util;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.MemoryCacheImageOutputStream;

import org.imgscalr.Scalr;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class CompressImgUtil {
	public byte[] compressToJpg(MultipartFile file, int maxSizeBytes) throws IOException {
	    BufferedImage inputImage = ImageIO.read(file.getInputStream());

	    // 투명 배경 있는 이미지 → RGB로 변환
	    BufferedImage rgbImage = new BufferedImage(
	        inputImage.getWidth(), inputImage.getHeight(), BufferedImage.TYPE_INT_RGB);
	    Graphics2D g = rgbImage.createGraphics();
	    g.drawImage(inputImage, 0, 0, Color.WHITE, null);
	    g.dispose();

	    // [1] 고정 해상도 축소 (예: 최대 1280px)
	    int targetWidth = rgbImage.getWidth();
	    int targetHeight = rgbImage.getHeight();
	    int maxDimension = 1280;

	    if (targetWidth > maxDimension || targetHeight > maxDimension) {
	        if (targetWidth >= targetHeight) {
	            targetHeight = (int)((double)targetHeight / targetWidth * maxDimension);
	            targetWidth = maxDimension;
	        } else {
	            targetWidth = (int)((double)targetWidth / targetHeight * maxDimension);
	            targetHeight = maxDimension;
	        }
	        rgbImage = Scalr.resize(rgbImage, Scalr.Method.QUALITY, targetWidth, targetHeight);
	    }

	    // [2] 압축 반복
	    float quality = 1.0f;

	    while (true) {
	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        ImageWriter jpgWriter = ImageIO.getImageWritersByFormatName("jpg").next();
	        ImageWriteParam param = jpgWriter.getDefaultWriteParam();
	        param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
	        param.setCompressionQuality(quality);

	        jpgWriter.setOutput(new MemoryCacheImageOutputStream(baos));
	        jpgWriter.write(null, new IIOImage(rgbImage, null, null), param);
	        jpgWriter.dispose();

	        byte[] result = baos.toByteArray();

	        if (result.length <= maxSizeBytes) {
	            return result;
	        }

	        quality -= 0.05f;

	        if (quality < 0.1f) {
	            throw new IOException("압축 실패: 설정한 용량 이하로 줄일 수 없습니다.");
	        }
	    }
	}
}
