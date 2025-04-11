package com.jobhunter.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Base64;
import java.util.Calendar;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.imgscalr.Scalr;
import org.imgscalr.Scalr.Mode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

@Component
public class RecruitmentFileProcess {

	private String realPath;
	private String saveFilePath;
	private String os;

	private Logger logger = LoggerFactory.getLogger(getClass());

	public RecruitmentFileProcess() {
		this.os = System.getProperty("os.name").toLowerCase();
	}

	/** 유저 프로필 삭제 */
	public void removeMemberImg(String userImgName) {
		File removeFile = new File(this.realPath + File.separator + userImgName);
		removeFile.delete();
	}

	/** 유저 프로필 저장 */
	public String saveUserProfile(String userId, MultipartFile userImg, HttpServletRequest req) throws IOException {
		String originalFileName = userImg.getOriginalFilename();
		String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);

		this.realPath = req.getSession().getServletContext().getRealPath("/resources/memberImg");
		logger.info("파일 저장 경로 : " + this.realPath);

		String fileName = userId + "." + ext;
		File saveUserImgFile = new File(realPath + File.separator + fileName);
		FileUtils.writeByteArrayToFile(saveUserImgFile, userImg.getBytes());

		return fileName;
	}

	/** 실제 파일 저장 처리 */
	public RecruitmentnoticeBoardUpfiles saveFileToRealPath(
	        MultipartFile file,
	        HttpServletRequest request,
	        String saveFileDir) throws IOException {

	    RecruitmentnoticeBoardUpfiles result = null;

	    String originalFileName = file.getOriginalFilename();
	    String fileType = file.getContentType();
	    String ext = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
	    long size = file.getSize();
	    String thumbFileName = null;
	    String base64Image = null;

	    String newFileName = null;

	    this.realPath = request.getSession().getServletContext().getRealPath(saveFileDir);
	    logger.info("파일 저장 경로 : " + this.realPath);

	    String[] ymd = makeCalendarPath();
	    makeDirectory(ymd);
	    this.saveFilePath = realPath + ymd[ymd.length - 1]; // 예: /2025/03/27

	    String webPath = "/resources/recruitmentFiles"; // 브라우저 접근용 경로

	    if (size > 0) {
	        newFileName = renameUniqueFileName(originalFileName);
	        File saveFile = new File(saveFilePath + File.separator + newFileName);
	        FileUtils.writeByteArrayToFile(saveFile, file.getBytes());

	        if (ImageMimeType.isImage(ext.toLowerCase())) {
	            thumbFileName = makeThumbnailImage(newFileName);
	            base64Image = makeBase64Encoding(thumbFileName);
	        }

	        result = RecruitmentnoticeBoardUpfiles.builder()
	                .originalFileName(originalFileName)
	                .newFileName(webPath + ymd[ymd.length - 1].replace("\\", "/") + "/" + newFileName)
	                .thumbFileName(webPath + ymd[ymd.length - 1].replace("\\", "/") + "/" + thumbFileName)
	                .fileType(fileType)
	                .ext(ext)
	                .size(size)
	                .base64Image(base64Image)
	                .build();

	        logger.info("파일 저장 완료: " + result);
	    }

	    return result;
	}

	/** 파일 삭제 */
	public void removeFile(RecruitmentnoticeBoardUpfiles removeFile) {
		String newFilePath = this.realPath + (this.os.contains("windows")
				? removeFile.getNewFileName().replace("/", "\\")
				: removeFile.getNewFileName());

		File file = new File(newFilePath);
		file.delete();

		if (ImageMimeType.isImage(removeFile.getExt().toLowerCase())) {
			String thumbPath = this.realPath + (this.os.contains("windows")
					? removeFile.getThumbFileName().replace("/", "\\")
					: removeFile.getThumbFileName());
			new File(thumbPath).delete();
		}
	}

	private String renameUniqueFileName(String originalFileName) {
		String uuid = UUID.randomUUID().toString();
		return uuid + "_" + originalFileName;
	}

	private String makeThumbnailImage(String newFileName) throws IOException {
	    File originalFile = new File(this.saveFilePath + File.separator + newFileName);
	    BufferedImage originalImage = ImageIO.read(originalFile);

	    if (originalImage == null) {
	        logger.error("이미지 파일이 아니거나 읽기 실패: " + newFileName);
	        throw new IOException("유효한 이미지 파일이 아닙니다: " + newFileName);
	    }

	    BufferedImage thumbnail = Scalr.resize(originalImage, Mode.FIT_TO_WIDTH, 50);
	    String thumbName = "thumb_" + newFileName;

	    File thumbFile = new File(this.saveFilePath + File.separator + thumbName);
	    String ext = newFileName.substring(newFileName.lastIndexOf(".") + 1).toLowerCase();  // <- 확장자 소문자 처리

	    ImageIO.write(thumbnail, ext, thumbFile);

	    return thumbName;
	}

	private String makeBase64Encoding(String thumbFileName) throws IOException {
		File thumb = new File(this.saveFilePath + File.separator + thumbFileName);
		byte[] bytes = FileUtils.readFileToByteArray(thumb);
		return Base64.getEncoder().encodeToString(bytes);
	}

	private void makeDirectory(String[] ymd) {
		if (!new File(this.realPath + ymd[ymd.length - 1]).exists()) {
			for (String path : ymd) {
				File dir = new File(this.realPath + path);
				if (!dir.exists()) dir.mkdir();
			}
		}
	}

	private String[] makeCalendarPath() {
		Calendar cal = Calendar.getInstance();
		String year = File.separator + cal.get(Calendar.YEAR);
		String month = year + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);
		String date = month + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));
		return new String[] { year, month, date };
	}
}