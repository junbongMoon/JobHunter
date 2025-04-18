package com.jobhunter.util;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.Color;
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

        float quality = 1.0f;
        int width = rgbImage.getWidth();

        while (true) {
            BufferedImage resized = Scalr.resize(rgbImage, Scalr.Method.ULTRA_QUALITY, width);

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageWriter jpgWriter = ImageIO.getImageWritersByFormatName("jpg").next();
            ImageWriteParam param = jpgWriter.getDefaultWriteParam();
            param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
            param.setCompressionQuality(quality);

            jpgWriter.setOutput(new MemoryCacheImageOutputStream(baos));
            jpgWriter.write(null, new IIOImage(resized, null, null), param);
            jpgWriter.dispose();

            byte[] result = baos.toByteArray();
            if (result.length <= maxSizeBytes) {
                return result;
            }

            quality -= 0.05f;
            if (quality < 0.1f) {
                quality = 1.0f;
                width *= 0.9;
            }

            if (width < 100) {
                throw new IOException("이미지를 1MB 이하로 압축할 수 없습니다.");
            }
        }
    }
}
