package com.jobhunter.controller.advancement;

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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.model.advancement.AdvancementDTO;
import com.jobhunter.model.advancement.AdvancementUpFileVODTO;
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
    public String showAdvancementWrite() {
    	
    	return "/advancement/write";
    }

    @PostMapping("/save")
    public String saveAdvancement(@ModelAttribute AdvancementDTO advancementDTO, HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<AdvancementUpFileVODTO> fileList =
                (List<AdvancementUpFileVODTO>) session.getAttribute("newfileList");

        if (fileList == null) fileList = new ArrayList<>();

        try {
            boolean success = advancementService.SaveAdvancementByMento(advancementDTO, fileList);
            session.removeAttribute("newfileList"); // 저장 후 초기화
            return success ?
                    "redirect:/advancement/list?action=success" :
                    "redirect:/advancement/list?action=fail";
        } catch (Exception e) {
            logger.error("게시글 저장 실패", e);
            return "redirect:/advancement/list?action=fail";
        }
    }

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
}
