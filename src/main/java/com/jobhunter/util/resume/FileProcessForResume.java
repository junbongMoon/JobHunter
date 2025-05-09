package com.jobhunter.util.resume;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Base64;
import java.util.Calendar;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.util.ImageMimeType;

@Component
public class FileProcessForResume {

	private String realPath;
	private String saveFilePath;
	private String os;
	private Logger logger = LoggerFactory.getLogger(getClass());

	public FileProcessForResume() {
		this.os = System.getProperty("os.name").toLowerCase();
	}

	public ResumeUpfileDTO saveFileToRealPath(MultipartFile file, HttpServletRequest request, String saveFileDir)
			throws IOException {

		String originalFileName = file.getOriginalFilename();
		String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
		long size = file.getSize();
		String base64Image = null;
		String newFileName;

		// 실제 저장 경로 설정
		this.realPath = request.getSession().getServletContext().getRealPath(saveFileDir);
		logger.info("파일 저장 경로: " + this.realPath);

		String[] ymd = makeCalendarPath();
		makeDirectory(ymd);
		this.saveFilePath = realPath + ymd[ymd.length - 1];

		if (size > 0) {
			newFileName = renameUniqueFileName(originalFileName);
			File saveFile = new File(saveFilePath + File.separator + newFileName);
			FileUtils.writeByteArrayToFile(saveFile, file.getBytes());

			// base64 인코딩은 이미지일 때만
			if (ImageMimeType.isImage(ext)) {
				base64Image = encodeToBase64(saveFile);
			}

			return ResumeUpfileDTO.builder()
					.originalFileName(originalFileName)
					.newFileName(ymd[ymd.length - 1].replace("\\", "/") + "/" + newFileName)
					.ext(ext)
					.size((int) size)
					.base64Image(base64Image)
					.build();
		}

		return null;
	}

	public void removeFile(ResumeUpfileDTO fileDTO) {
		String newFileName = this.os.contains("windows")
				? fileDTO.getNewFileName().replace("/", "\\")
				: fileDTO.getNewFileName();

		File file = new File(this.realPath + newFileName);
		if (file.exists()) file.delete();
	}

	private String encodeToBase64(File file) throws IOException {
		byte[] bytes = FileUtils.readFileToByteArray(file);
		return Base64.getEncoder().encodeToString(bytes);
	}

	private String renameUniqueFileName(String originalFileName) {
		UUID uuid = UUID.randomUUID();
		String uniqueFileName = uuid.toString() + "_" + originalFileName;
		logger.info("유니크 파일명: " + uniqueFileName);
		return uniqueFileName;
	}

	private void makeDirectory(String[] ymd) {
		if (!new File(this.realPath + ymd[ymd.length - 1]).exists()) {
			for (String path : ymd) {
				File tmp = new File(this.realPath + path);
				if (!tmp.exists()) tmp.mkdir();
			}
		}
	}

	private String[] makeCalendarPath() {
		Calendar cal = Calendar.getInstance();
		String year = File.separator + cal.get(Calendar.YEAR);
		String month = year + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);
		String date = month + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));
		logger.info("날짜 기반 폴더 경로: " + year + ", " + month + ", " + date);
		return new String[] { year, month, date };
	}
}
