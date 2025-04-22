<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카카오페이 결제 테스트</title>
</head>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<h2>5000 포인트 충전</h2>
	<p>결제 금액: <strong>5,000원</strong></p>
	<button onclick="purchasePoints()">충전하기</button>

	<script>
	function purchasePoints() {
	    fetch("/kakao/pay/ready", {
	      method: "POST",
	      headers: { "Content-Type": "application/json" },
	      body: JSON.stringify({
	        item_name: "5000포인트 충전",
	        total_amount: 5000
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
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>
