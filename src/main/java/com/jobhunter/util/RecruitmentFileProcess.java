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

import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;

@Component
public class RecruitmentFileProcess {

	/**
	 * <p> 
	 * 실제 파일 경로
	 * </p>
	 */
	private String realPath;
	
	/**
	 * <p> 
	 * 파일이 저장 될 경로
	 * </p>
	 */
	private String saveFilePath;
	
	/**
	 * <p> 
	 * os
	 * </p>
	 */
	private String os;

	private Logger logger = LoggerFactory.getLogger(getClass());

	/**
	 * <p> 
	 * 현재 os의 이름을 얻어와 소문자로 바꿔주는 메서드
	 * </p>
	 */
	public RecruitmentFileProcess() {
		this.os = System.getProperty("os.name").toLowerCase();
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 유저 프로필 삭제
	 * </p>
	 * 
	 * @param userImgName
	 *
	 */
	public void removeMemberImg(String userImgName) {
		File removeFile = new File(this.realPath + File.separator + userImgName);
		removeFile.delete();
	}


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 유저 프로필 저장하는 메서드
	 * </p>
	 * 
	 * @param userId
	 * @param userImg
	 * @param req
	 * @return
	 * @throws IOException
	 *
	 */
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


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 웹서버에 파일 저장 처리해주는 메서드
	 * </p>
	 * 
	 * @param file
	 * @param request
	 * @param saveFileDir
	 * @return 공고에 저장할 파일
	 * @throws IOException
	 *
	 */
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

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 웹서버에 저장 된 파일 삭제
	 * </p>
	 * 
	 * @param removeFile
	 *
	 */
	public void removeFile(RecruitmentnoticeBoardUpfiles removeFile) {
	    String webPrefix = "/resources/recruitmentFiles";

	    String relativeMain = removeFile.getNewFileName().replace(webPrefix, "");
	    String relativeThumb = removeFile.getThumbFileName().replace(webPrefix, "");

	    String absoluteMain = this.realPath + (os.contains("windows") ? relativeMain.replace("/", "\\") : relativeMain);
	    String absoluteThumb = this.realPath + (os.contains("windows") ? relativeThumb.replace("/", "\\") : relativeThumb);

	    File mainFile = new File(absoluteMain);
	    System.out.println("🔍 [삭제 시도] 메인 파일 경로: " + mainFile.getAbsolutePath());
	    if (mainFile.exists()) {
	        System.out.println("✅ 메인 파일 삭제 " + (mainFile.delete() ? "성공" : "실패"));
	    } else {
	        System.out.println("❌ 메인 파일이 존재하지 않습니다.");
	    }

	    if (ImageMimeType.isImage(removeFile.getExt())) {
	        File thumbFile = new File(absoluteThumb);
	        System.out.println("🔍 [삭제 시도] 썸네일 경로: " + thumbFile.getAbsolutePath());
	        if (thumbFile.exists()) {
	            System.out.println("✅ 썸네일 삭제 " + (thumbFile.delete() ? "성공" : "실패"));
	        } else {
	            System.out.println("❌ 썸네일이 존재하지 않습니다.");
	        }
	    }
	}
	


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * UUID로 새로운 파일명을 반환하는 메서드
	 * </p>
	 * 
	 * @param String originalFileName
	 * @return UUID_원래파일명
	 *
	 */
	private String renameUniqueFileName(String originalFileName) {
		String uuid = UUID.randomUUID().toString();
		return uuid + "_" + originalFileName;
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 이미지 파일을 썸네일 파일로 만들어주는 메서드
	 * </p>
	 * 
	 * @param String newFileName
	 * @return 썸네일 파일
	 * @throws IOException
	 *
	 */
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

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 썸네일 파일을 Base64 문자열로 바꿔주는 메서드
	 * </p>
	 * 
	 * @param String thumbFileName
	 * @return Base64 문자열
	 * @throws IOException
	 *
	 */
	private String makeBase64Encoding(String thumbFileName) throws IOException {
		File thumb = new File(this.saveFilePath + File.separator + thumbFileName);
		byte[] bytes = FileUtils.readFileToByteArray(thumb);
		return Base64.getEncoder().encodeToString(bytes);
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 디렉토리를 만들어주는 메서드
	 * </p>
	 * 
	 * @param String[] ymd
	 *
	 */
	private void makeDirectory(String[] ymd) {
		if (!new File(this.realPath + ymd[ymd.length - 1]).exists()) {
			for (String path : ymd) {
				File dir = new File(this.realPath + path);
				if (!dir.exists()) dir.mkdir();
			}
		}
	}

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 *  오늘 날짜의 String 배열을 만들어주는 메서드
	 * </p>
	 * 
	 * @return String[]형식의 {YYYY, MM, DD}
	 *
	 */
	private String[] makeCalendarPath() {
		Calendar cal = Calendar.getInstance();
		String year = File.separator + cal.get(Calendar.YEAR);
		String month = year + File.separator + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);
		String date = month + File.separator + new DecimalFormat("00").format(cal.get(Calendar.DATE));
		return new String[] { year, month, date };
	}
	
	public AdvancementUpFileVODTO saveFileToRealPathForAdvancement(
		    MultipartFile file,
		    HttpServletRequest request,
		    String saveFileDir) throws IOException {

		    RecruitmentnoticeBoardUpfiles origin = this.saveFileToRealPath(file, request, saveFileDir);

		    // 여기서 recruitmentFiles를 advancementFiles로 강제 교체
		    String correctedNewFileName = origin.getNewFileName().replace("/recruitmentFiles", "/advancementFiles");
		    String correctedThumbFileName = origin.getThumbFileName().replace("/recruitmentFiles", "/advancementFiles");

		    return AdvancementUpFileVODTO.builder()
		        .originalFileName(origin.getOriginalFileName())
		        .newFileName(correctedNewFileName)
		        .thumbFileName(correctedThumbFileName)
		        .fileType(origin.getFileType())
		        .ext(origin.getExt())
		        .size(origin.getSize())
		        .base64Image(origin.getBase64Image())
		        .build();
		}
}