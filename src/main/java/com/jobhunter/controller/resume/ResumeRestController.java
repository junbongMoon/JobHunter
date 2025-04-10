package com.jobhunter.controller.resume;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.service.resume.ResumeService;
import com.jobhunter.util.resume.FileProcessForResume;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/resume")
@RequiredArgsConstructor
public class ResumeRestController {

	private final ResumeService resumeService;
	private final FileProcessForResume fileProcessForResume;

	@DeleteMapping(value = "/delete/{resumeNo}")
	public ResponseEntity<String> deleteResume(@PathVariable int resumeNo) {
		try {
			// 이력서 상태 확인
			if (resumeService.isResumeChecked(resumeNo)) {
				return ResponseEntity.status(HttpStatus.FORBIDDEN)
					.body("기업에서 확인중인 이력서는 삭제할 수 없습니다.");
			}
			
			// 이력서에 파일이 있다면 파일 또한 서버에서 삭제
			List<ResumeUpfileDTO> upfiles = resumeService.selectResumeUpfile(resumeNo);
			for (ResumeUpfileDTO upfile : upfiles) {
				fileProcessForResume.removeFile(upfile);
			}
			resumeService.deleteResume(resumeNo);
			return ResponseEntity.ok("이력서가 성공적으로 삭제되었습니다.");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이력서 삭제 중 오류가 발생했습니다.");
		}
	}
}
