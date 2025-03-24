<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<main class="main">
	<!-- Contact Section -->
	<div>마이페이지</div>
	<!-- /Contact Section -->
</main>
<!-- 풋터 -->

<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>

<script>
console.log("?")
window.onload=()=>{
	$.ajax({
	    url: "/user/info/${sessionScope.account.uid}",
	    method: "GET", // 또는 그대로 POST 유지
	    success: (res) => {
	        console.log(res); // 전체 JSON 출력
	    },
	    error: (xhr) => alert("실패")
	});
}
</script>