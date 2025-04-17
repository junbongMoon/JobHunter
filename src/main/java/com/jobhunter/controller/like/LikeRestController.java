package com.jobhunter.controller.like;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.service.like.LikeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/like")
@RequiredArgsConstructor
public class LikeRestController {

    private final LikeService likeService;

    // 좋아요 저장
    @PostMapping("/save")
    public ResponseEntity<Boolean> saveLike(@RequestParam int userId, @RequestParam int boardNo) {
        try {
            boolean result = likeService.saveLike(userId, boardNo, "RECRUIT");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);
        }
    }

    // 좋아요 취소
    @DeleteMapping("/delete")
    public ResponseEntity<Boolean> deleteLike(@RequestParam int userId, @RequestParam int boardNo) {
        try {
            boolean result = likeService.deleteLike(userId, boardNo, "RECRUIT");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(false);
        }
    }
}

