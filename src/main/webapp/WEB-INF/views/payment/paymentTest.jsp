<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카카오페이 결제 테스트</title>
</head>
<body>
	<h2>카카오페이 테스트 결제</h2>
	<button onclick="kakaoPay()">결제하기</button>

	<script>
  function kakaoPay() {
    fetch("/kakao/pay/ready", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        item_name: "테스트 상품",
        total_amount: 1000
      })
    })
    .then(res => res.json())
    .then(data => {
      if (data.next_redirect_pc_url) {
        window.location.href = data.next_redirect_pc_url;
      } else {
        alert("결제 URL 생성 실패");
      }
    });
  }
</script>
</body>
</html>
