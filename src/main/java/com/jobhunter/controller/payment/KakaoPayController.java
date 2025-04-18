package com.jobhunter.controller.payment;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@Controller
@RequestMapping("/kakao")
public class KakaoPayController {

    private final String CID = "TC0ONETIME"; // 테스트용 CID
    @Value("${kakao.admin-key}")
    private String adminKey;

    @RequestMapping(value = "/pay/ready", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> kakaoPayReady(@RequestBody Map<String, Object> param) {
        RestTemplate restTemplate = new RestTemplate();
        
        System.out.println(adminKey);

        // 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " +  adminKey);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        // 파라미터 설정
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("cid", CID);
        params.add("partner_order_id", "order1234");
        params.add("partner_user_id", "user1234");
        params.add("item_name", (String) param.get("item_name"));
        params.add("quantity", "1");
        params.add("total_amount", String.valueOf(param.get("total_amount")));
        params.add("vat_amount", "0");
        params.add("tax_free_amount", "0");
        params.add("approval_url", "http://localhost:8080/kakao/pay/success");
        params.add("cancel_url", "http://localhost:8080/kakao/pay/cancel");
        params.add("fail_url", "http://localhost:8080/kakao/pay/fail");

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);

        ResponseEntity<Map> response = restTemplate.postForEntity("https://kapi.kakao.com/v1/payment/ready", request, Map.class);
        return response;
    }

    @RequestMapping("/pay/success")
    public ModelAndView success(@RequestParam("pg_token") String pgToken) {
        ModelAndView mav = new ModelAndView("paySuccess");
        mav.addObject("pgToken", pgToken);
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
