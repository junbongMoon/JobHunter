package com.jobhunter.controller.payment;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.payment.PaymentLogDTO;
import com.jobhunter.service.user.UserService;

import lombok.RequiredArgsConstructor;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@Controller
@RequestMapping("/kakao")
@RequiredArgsConstructor
@PropertySource("classpath:config/kakao.properties")
public class KakaoPayController {

    private final String CID = "TC0ONETIME"; // 테스트용 CID
    @Value("${kakao.admin-key}")
    private String adminKey;
    private final UserService userService;

    @RequestMapping(value = "/pay/ready", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> kakaoPayReady(@RequestBody Map<String, Object> param, HttpSession session) {
        RestTemplate restTemplate = new RestTemplate();
        
        System.out.println(adminKey);
        System.out.println("item_name: " + param.get("item_name"));
        System.out.println("total_amount: " + param.get("total_amount"));
        
        AccountVO account = (AccountVO) session.getAttribute("account");
        int userId = account.getUid();
        
        // 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " +  adminKey);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        // 파라미터 설정
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("cid", CID);
        params.add("partner_order_id", "order1234");
        params.add("partner_user_id", Integer.toString(userId));
        params.add("item_name", (String) param.get("item_name"));
        params.add("quantity", "1");
        params.add("total_amount", String.valueOf(param.get("total_amount")));
        params.add("vat_amount", "0");
        params.add("tax_free_amount", "0");
        params.add("approval_url", "http://localhost:8085/kakao/pay/success");
        params.add("cancel_url", "http://localhost:8085/kakao/pay/cancel");
        params.add("fail_url", "http://localhost:8085/kakao/pay/fail");
        
        String itemName = (String) param.get("item_name");
        int totalAmount = Integer.parseInt(param.get("total_amount").toString());

        // 세션에 결제 정보 저장
        session.setAttribute("tidItemName", itemName);
        session.setAttribute("tidAmount", totalAmount);
        

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        try {

            ResponseEntity<Map> response = restTemplate.postForEntity(
            	    "https://kapi.kakao.com/v1/payment/ready", request, Map.class
            	);

            	Map<String, Object> body = response.getBody();
            	String tid = (String) body.get("tid");
            	session.setAttribute("tid", tid);
            
            System.out.println("응답 바디: " + response.getBody());
            return new ResponseEntity<>(response.getBody(), HttpStatus.OK);
        } catch (HttpClientErrorException e) {
            System.out.println("❌ 요청 실패");
            System.out.println("응답 코드: " + e.getStatusCode());
            System.out.println("응답 바디: " + e.getResponseBodyAsString());
            return new ResponseEntity<>(e.getResponseBodyAsString(), e.getStatusCode());
        }
        
    }

    @RequestMapping("/pay/success")
    public ModelAndView success(@RequestParam("pg_token") String pgToken,
                                HttpSession session) {
        ModelAndView mav = new ModelAndView();

        // 1️⃣ 로그인된 사용자 정보 가져오기
        AccountVO account = (AccountVO) session.getAttribute("account"); // Account는 사용자 클래스
        if (account == null) {
            mav.setViewName("payment/payFail");
            mav.addObject("error", "세션 만료 또는 로그인 정보 없음");
            return mav;
        }
        int userId = account.getUid();
        String tid = (String) session.getAttribute("tid"); // 또는 memberDTO 등
        
        if (tid == null) {
            mav.setViewName("payment/payFail");
            mav.addObject("error", "결제 정보가 유실되었습니다. 다시 시도해주세요.");
            return mav;
        }

        // 2️⃣ 카카오 결제 승인 요청
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + adminKey);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("cid", CID);
        params.add("tid", (String) session.getAttribute("tid")); // ready 단계에서 저장한 tid
        params.add("partner_order_id", "order1234");
        params.add("partner_user_id", Integer.toString(userId)); // 실제 로그인된 사용자
        params.add("pg_token", pgToken);
        

        String itemName = (String) session.getAttribute("tidItemName");
        int amount = (int) session.getAttribute("tidAmount");
        
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        PaymentLogDTO log = PaymentLogDTO.builder()
                .useruid(userId)
                .tid(tid)
                .amount(amount)
                .item_name(itemName)
                .build();
        

        try {
            ResponseEntity<String> response = restTemplate.postForEntity(
                "https://kapi.kakao.com/v1/payment/approve", request, String.class);

            System.out.println("결제 승인 성공: " + response.getBody());

            // 3️⃣ 실제 DB에 포인트 충전
            userService.addPoint(Integer.toString(userId), amount, log); // 트랜잭션 서비스 호출

            mav.setViewName("payment/paySuccess");
            mav.addObject("pgToken", pgToken);
        } catch (HttpClientErrorException e) {
            System.out.println("결제 승인 실패: " + e.getResponseBodyAsString());
            mav.setViewName("payment/payFail");
        } catch (Exception e) {
        	e.printStackTrace();
        	
        }

        return mav;
    }

    @RequestMapping("/pay/cancel")
    public void cancel(HttpServletResponse res) throws IOException {
        res.getWriter().write("❌ 사용자가 결제를 취소했습니다.");
    }

    @RequestMapping("/pay/fail")
    public void fail(HttpServletResponse res) throws IOException {
        res.getWriter().write("❌ 결제 실패!");
    }
}
