package com.jobhunter.controller.advancement;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
import com.jobhunter.model.advancement.AdvancementVO;
import com.jobhunter.model.page.PageRequestDTO;
import com.jobhunter.model.page.PageResponseDTO;
import com.jobhunter.model.util.FileStatus;
import com.jobhunter.service.advancement.AdvancementService;
import com.jobhunter.util.RecruitmentFileProcess;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/advancement")
public class AdvancementController {
    private final AdvancementService advancementService;
    private final RecruitmentFileProcess fp;
    private static final Logger logger = LoggerFactory.getLogger(AdvancementController.class);

    @GetMapping("/write")
    public String showAdvancementWrite( HttpServletRequest request) {
    	
    	 request.getSession().removeAttribute("newfileList"); 
    	
    	return "/advancement/write";
    }

    /**
     *  @author 문준봉
     *
     * <p>
     * 승급 게시물을 등록하는 메서드
     * </p>
     * 
     * @param advancementDTO
     * @param request
     * @return 이동할 페이지
     *
     */
    @PostMapping("/save")
    public String saveAdvancement(@ModelAttribute AdvancementDTO advancementDTO, HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<AdvancementUpFileVODTO> fileList =
                (List<AdvancementUpFileVODTO>) session.getAttribute("newfileList");

        if (fileList == null) fileList = new ArrayList<>();
        int uid = ((AccountVO) session.getAttribute("account")).getUid();
        try {
            boolean success = advancementService.SaveAdvancementByMento(advancementDTO, fileList);
            session.removeAttribute("newfileList"); // 저장 후 초기화
            
            
            return "redirect:/advancement/list?uid=" + uid;
        } catch (Exception e) {
            logger.error("게시글 저장 실패", e);
            return "redirect:/advancement/list?uid=" + uid;
        }
    }

    /**
     *  @author 문준봉
     *
     * <p>
     * 파일을 웹서버와 세션에 저장하는 메서드 
     * </p>
     * 
     * @param file
     * @param request
     * @return ResponseEntity와 저장된 파일 리스트
     *
     */
    @PostMapping("/file")
    public ResponseEntity<List<AdvancementUpFileVODTO>> uploadFile(
            @RequestParam("file") MultipartFile file,
            HttpServletRequest request) {

        try {
            AdvancementUpFileVODTO uploadedFile = fp.saveFileToRealPathForAdvancement(
                    file, request, "/resources/advancementFiles");

            // 파일명 보안 체크
            if (!uploadedFile.getOriginalFileName().matches("^[a-zA-Z0-9_.\\-가-힣\\s]+$")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
            }

            uploadedFile.setStatus(FileStatus.NEW);

            HttpSession session = request.getSession();
            List<AdvancementUpFileVODTO> fileList =
                    (List<AdvancementUpFileVODTO>) session.getAttribute("newfileList");

            if (fileList == null) {
                fileList = new ArrayList<>();
                session.setAttribute("newfileList", fileList);
            }

            fileList.add(uploadedFile);

            return ResponseEntity.ok(fileList);

        } catch (IOException e) {
            logger.error("파일 업로드 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
    
    /**
     *  @author 문준봉
     *
     * <p>
     * 파일을 웹서버와 세션에서 삭제하는 메서드
     * </p>
     * 
     * @param index
     * @param request
     * @return ResponseEntity
     *
     */
    @PostMapping("/deleteFile")
    public ResponseEntity<?> deleteFileFromSession(@RequestParam("index") int index, HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<AdvancementUpFileVODTO> fileList =
                (List<AdvancementUpFileVODTO>) session.getAttribute("newfileList");

        if (fileList != null && index >= 0 && index < fileList.size()) {
            AdvancementUpFileVODTO target = fileList.remove(index);

            // 실제 파일 경로로 삭제
            String realPath = request.getSession().getServletContext().getRealPath("/");
            String os = System.getProperty("os.name").toLowerCase();

            String mainPath = realPath + target.getNewFileName();
            String thumbPath = realPath + target.getThumbFileName();

            File mainFile = new File(os.contains("windows") ? mainPath.replace("/", "\\") : mainPath);
            File thumbFile = new File(os.contains("windows") ? thumbPath.replace("/", "\\") : thumbPath);

            if (mainFile.exists()) mainFile.delete();
            if (thumbFile.exists()) thumbFile.delete();

            logger.info("서버 파일 삭제 완료: {}, {}", mainFile.getName(), thumbFile.getName());
        }

        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/modify")
    public String showModifyAdvancement(@RequestParam("id") int advancementNo, Model model, HttpServletRequest request) {
        try {
            AdvancementVO advancement = advancementService.getAdvancementById(advancementNo);

            if (advancement == null) {
                return "redirect:/user/mypage"; // 존재하지 않으면 마이페이지로 리디렉션
            }

            // 기존 업로드된 파일 세션에 등록 (선택 사항)
            request.getSession().setAttribute("newfileList", advancement.getFileList());

            model.addAttribute("advancement", advancement);
            return "/advancement/modify";

        } catch (Exception e) {
            logger.error("수정 페이지 로딩 실패", e);
            return "redirect:/user/mypage";
        }
    }
    
    @GetMapping("/list")
    public String showAdvancementListByUid(@RequestParam("uid") int uid,PageRequestDTO pageRequestDTO, Model model) {
    	PageResponseDTO<AdvancementVO> result = null;
    	
    	try {
			result = advancementService.getAdvancementListByUid(uid, pageRequestDTO);
			model.addAttribute("pageResponseDTO", result);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	
    	return "/advancement/list";
    }
    
    @GetMapping("/detail")
    public String showAdvancementDetail(@RequestParam("advancementNo") int advancementNo, Model model) {
    	
    	System.out.println("디테일 페이지 호출 됬나?");
        try {
            AdvancementVO advancement = advancementService.getAdvancementById(advancementNo);

            if (advancement == null) {
                return "redirect:/advancement/list?uid=1"; // 글이 없으면 리스트로 리다이렉트
            }
            System.out.println(advancement.getFileList());

            model.addAttribute("advancement", advancement);
            return "/advancement/detail"; // JSP 경로

        } catch (Exception e) {
            logger.error("상세 페이지 로딩 실패", e);
            return "redirect:/advancement/list?uid=1";
        }
    }
    
    /**
     *  @author 문준봉
     *
     * <p>
     * 승급 게시물을 수정하는 메서드
     * </p>
     *
     * @param advancementDTO
     * @param request
     * @return 이동할 페이지
     */
    @PostMapping("/modify")
    public String modifyAdvancement(@ModelAttribute AdvancementDTO advancementDTO, HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<AdvancementUpFileVODTO> fileList =
                (List<AdvancementUpFileVODTO>) session.getAttribute("newfileList");

        if (fileList == null) fileList = new ArrayList<>();

        try {
            boolean success = advancementService.modifyAdvancementByMento(advancementDTO, fileList);
            session.removeAttribute("newfileList"); // 수정 후 세션 정리

            int advancementNo = advancementDTO.getAdvancementNo(); // ✅ 수정한 게시글 번호를 꺼낸다

            return success ? "redirect:/advancement/detail?advancementNo=" + advancementNo : "/user/mypage";

        } catch (Exception e) {
            logger.error("게시글 수정 실패", e);
            return "/user/mypage";
        }
    }
    
    @PostMapping("/delete")
    public ResponseEntity<Boolean> deleteAdvancement(@RequestParam("advancementNo") int advancementNo, HttpServletRequest request) {
        HttpSession session = request.getSession();
        int uid = ((AccountVO) session.getAttribute("account")).getUid();
        
        try {
            String realPath = request.getSession().getServletContext().getRealPath("/");
            boolean success = advancementService.deleteAdvancementById(advancementNo, realPath);
            
            if (success) {
                return ResponseEntity.ok(true);  // ✅ 성공이면 200 OK
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);  // ❗ 실패면 500
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false); // ❗ 예외나면 500
        }
    }
    
}
