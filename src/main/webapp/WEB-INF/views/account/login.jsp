<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="../header.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<main>
	<h2>로그인</h2>

	<form action="${pageContext.request.contextPath}/account/login"
		method="post">
		<!-- ID / PW -->
		<input type="text" name="id" placeholder="아이디" required /> <input
			type="password" name="password" placeholder="비밀번호" required />

		<!-- 회원 유형 hidden -->
		<input type="hidden" name="accountType" value="COMPANY" />
		<!-- 일반 로그인이라면 NORMAL 로 바꾸면 됨 -->
		<!-- 기업 로그인이라면 COMPANY 로 바꾸면 됨 -->
		<div>${sessionScope.requiresVerification}</div>

		<!-- 인증 필요 시 -->
		<c:if test="${sessionScope.requiresVerification}">

			<!-- 인증 대상 -->
			<input type="hidden" id="authMobile"
				value="${sessionScope.authTargetMobile}" />
			<input type="hidden" id="authEmail"
				value="${sessionScope.authTargetEmail}" />
			<input type="hidden" id="accountType"
				value="${sessionScope.user.userType}" />

			<div>
				<label> <input type="radio" name="method" value="email"
					checked /> 이메일 인증
				</label> <label> <input type="radio" name="method" value="phone" />
					전화번호 인증
				</label>

				<button type="button" onclick="sendVerification()">인증 코드 전송</button>
				<input type="text" id="code" name="code" placeholder="인증코드 입력" />
				<button type="button" onclick="verifyCode()">인증 확인</button>
			</div>
		</c:if>


		<button type="submit">로그인</button>
	</form>
	<!-- 파이어베이스 캡챠 넣을곳 -->
	<div id="recaptcha-container"></div>
</main>

<jsp:include page="../footer.jsp" />

<!-- 인증용 JS 모듈 -->
<script type="module">
  import { sendVerification, verifyCode } from '/resources/js/authVerification.js';

  window.sendVerification = sendVerification;
  window.verifyCode = verifyCode;
</script>

<!-- 인증 성공 처리하는 모듈 선택_여기 넣어둔건 이메일이나 번호로 정지해제 -->
<script type="module" src="${pageContext.request.contextPath}/resources/js/authBefore.js"></script>
