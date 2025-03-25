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
	 <input type="hidden" id="authMobile"
	 value="${sessionScope.authTargetMobile}" />
 <input type="hidden" id="authEmail"
	 value="${sessionScope.authTargetEmail}" />
 <input type="hidden" id="uid"
	 value="${sessionScope.account.uid}" />
 <input type="hidden" id="method" />

	<div>
		<div>기존 전화번호_ 바꾸기누르면 숨겨짐</div> <button>전화번호 바꾸기</button>
		<input type="text" id="authMobile" placeholder="바꿀 번호"><button type="button" onclick="sendVerification(`phone`)">인증번호 발송</button>
		<input type="text" id="phoneCode" placeholder="인증번호"><button type="button" onclick="verifyCode(`phone`, `end`)">인증</button>
	</div>

	<div>
		<div>기존 이메일_ 바꾸기누르면 숨겨짐</div> <button>이메일 바꾸기</button>
		<input type="text" id="authEmail" placeholder="바꿀 이메일"><button type="button" onclick="sendVerification(`email`)">인증번호 발송</button>
		<input type="text" id="emailCode" placeholder="인증번호"><button type="button" onclick="verifyCode(`email`, `end`)">인증</button>
	</div>

	<!-- firebase캡챠 -->
	<div id="recaptcha-container"></div>
</main>
<!-- 풋터 -->

<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>

<script>

window.onload=()=>{
	// 내정보 불러오기
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