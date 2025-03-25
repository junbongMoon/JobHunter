<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<main class="main">
	<!-- Contact Section -->
	<div>마이페이지</div>
	<!-- /Contact Section -->

	<!-- 인증 대상 -->
	<div>
		<input type="radio" name="method" value="email" checked /> 이메일 인증 <input
			type="radio" name="method" value="phone" /> 전화번호 인증
	</div>

	<div>
		<input type="email" id="newEmail" placeholder="새 이메일 입력" /> <input
			type="text" id="newPhone" placeholder="새 전화번호 입력" />
		<button type="button" onclick="sendVerification()">인증 코드 전송</button>
	</div>

	<div>
		<input type="text" id="code" placeholder="인증 코드 입력" />
		<button type="button" onclick="verifyCode()">인증 확인</button>
	</div>

	<!-- firebase캡챠 -->
	<div id="recaptcha-container"></div>
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
<script type="module">
  import { sendVerification, verifyCode } from '/resources/js/authVerification.js';

  window.sendVerification = sendVerification;
  window.verifyCode = verifyCode;
</script>

<!-- 인증 성공 처리하는 모듈 선택_여기 넣어둔건 이메일이나 번호로 정지해제 -->
<script type="module"
	src="${pageContext.request.contextPath}/resources/js/authBefore_mypage.js"></script>