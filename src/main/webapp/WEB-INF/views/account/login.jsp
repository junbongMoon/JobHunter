<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 헤더 -->
<jsp:include page="../header.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script
	src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script
	src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js"
	integrity="sha384-dok87au0gKqJdxs7msEdBPNnKSRT+/mhTVzq+qOhcL464zXwvcrpjeWvyj1kCdq6"
	crossorigin="anonymous"></script>

<style>
.main {
	padding: 60px 20px;
	min-height: calc(100vh - 200px);
}

.login-container {
	padding: 40px 60px;
	background: white;
	border-radius: 20px;
	max-width: 600px;
	margin: 0 auto;
}

.login-title {
	margin-left: 10px;
	font-weight: 600;
	color: #2c3e50;
	border-bottom: 1px solid #eee;
	line-height: 1.5;
}

.form-group {
	margin-bottom: 20px;
}

.form-group input[type="text"], .form-group input[type="password"] {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 14px;
	margin-bottom: 15px;
}

.form-group input:focus {
	border-color: #47b2e4;
	outline: none;
}

.radio-group {
	display: none;
}

.verification-group {
	display: flex;
	gap: 10px;
	margin-top: 10px;
}

.verification-group input {
	flex: 1;
}

.btn-confirm {
	padding: 10px 20px;
	background: #47b2e4;
	color: white;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 14px;
	transition: all 0.3s ease;
}

.btn-confirm:hover {
	background: #3a8fb8;
}

/* 반응형 디자인 */
@media ( max-width : 768px) {
	.login-container {
		padding: 30px 20px;
	}
}

/* 탭 스타일 */
.account-type-tabs {
	display: flex;
	margin: -40px -60px 30px;
	border-bottom: 1px solid #eee;
}

.account-type-tab {
	flex: 1;
	padding: 20px 15px;
	text-align: center;
	cursor: pointer;
	font-size: 16px;
	font-weight: 500;
	color: #666;
	position: relative;
	transition: all 0.3s ease;
	background: #f8f9fa;
}

.account-type-tab:first-child {
	border-top-left-radius: 20px;
}

.account-type-tab:last-child {
	border-top-right-radius: 20px;
}

.account-type-tab input[type="radio"] {
	display: none;
}

.account-type-tab.active {
	color: #47b2e4;
	background: white;
}

.account-type-tab.active:after {
	content: '';
	position: absolute;
	bottom: -1px;
	left: 0;
	width: 100%;
	height: 1px;
	background: white;
}

.account-type-tab:hover {
	color: #47b2e4;
}

.verification-section {
	display: none;
	padding: 20px 0;
}

.verification-section.active {
	display: block;
}

.target-info {
	background: #f8f9fa;
	padding: 15px;
	border-radius: 8px;
	margin: 20px 0;
	color: #666;
}

.target-info strong {
	color: #47b2e4;
	font-weight: 600;
}

.verification-step {
	margin: 20px 0;
}

.verification-step input {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 8px;
	margin-bottom: 10px;
}

.btn-confirm.full-width {
	width: 100%;
	margin-top: 10px;
}

.verification-methods {
	margin-bottom: 30px;
}

.method-buttons {
	display: flex;
	gap: 10px;
	margin-top: 20px;
}

.btn-method {
	flex: 1;
	padding: 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background: #f8f9fa;
	color: #666;
	cursor: pointer;
	transition: all 0.3s ease;
}

.btn-method.active {
	background: #47b2e4;
	color: white;
	border-color: #47b2e4;
}

.verification-content {
	margin-top: 20px;
}

/* 알럿 모달 스타일 */
.alert-modal-overlay {
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.3);
	z-index: 9998;
}

.alert-modal-box {
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 300px;
	background: white;
	padding: 20px;
	border-radius: 12px;
	box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.15);
	z-index: 9999;
	text-align: center;
}

.alert-modal-content {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 15px;
}

.alert-modal-message {
	font-size: 16px;
	color: #2c3e50;
	line-height: 1.5;
}

.alert-modal-buttons {
	display: flex;
	justify-content: center;
	gap: 10px;
}

.alert-modal-button {
	padding: 8px 20px;
	border: none;
	border-radius: 6px;
	font-size: 14px;
	cursor: pointer;
	transition: all 0.2s ease;
}

.alert-modal-button.confirm {
	background: #47b2e4;
	color: white;
}

.alert-modal-button.cancel {
	background: #f8f9fa;
	color: #666;
}

.alert-modal-button:hover {
	opacity: 0.9;
}

.login-options {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin: 20px 0;
	padding: 15px 0;
	border-top: 1px solid #eee;
	border-bottom: 1px solid #eee;
}

.auto-login {
	display: flex;
	align-items: center;
	gap: 8px;
	color: #666;
}

.auto-login input[type="checkbox"] {
	width: 16px;
	height: 16px;
	cursor: pointer;
}

.find-account {
	display: flex;
	align-items: center;
	gap: 12px;
}

.find-account a {
	color: #666;
	text-decoration: none;
	font-size: 14px;
}

.find-account a:hover {
	color: #47b2e4;
}

.find-account .divider {
	color: #ddd;
	font-size: 12px;
}

@media ( max-width : 768px) {
	.login-options {
		flex-direction: column;
		gap: 15px;
		align-items: flex-start;
	}
	.find-account {
		width: 100%;
		justify-content: center;
	}
}

.login-failed-massege {
	font-size: 14px;
	color: var(--bs-red);
}

.flex-x-container {
	display: flex;
	flex-direction: row;
}

.between-con {
	justify-content: space-between;
}
</style>

<main class="main">
	<div class="login-container">
		<form action="${pageContext.request.contextPath}/account/login"
			method="post">
					<!-- 일반 로그인 시 보여줄 탭 -->
					<div class="account-type-tabs">
						<label class="account-type-tab active"> <input
							type="radio" name="accountType" value="USER" checked> 개인
							회원
						</label> <label class="account-type-tab"> <input type="radio"
							name="accountType" value="COMPANY"> 기업 회원
						</label>
					</div>

					<div class="flex-x-container between-con">
						<h2 class="login-title">&nbsp;&nbsp;로그인</h2>
						<div class="btn-kakao" onclick="loginWithKakao()">
							<img src="/resources/forKakao/kakao_login_medium_narrow.png"
								alt="kakao">
						</div>
					</div>
					<div class="form-group">
						<input type="text" name="id" placeholder="아이디" required /> <input
							type="password" name="password" placeholder="비밀번호" required />
						<c:if
							test="${sessionScope.remainingSeconds != null && sessionScope.remainingSeconds >= 0}">
							<p class="login-failed-massege">5회 이상 로그인에 실패하셨습니다.
								${sessionScope.remainingSeconds}초 후에 다시 시도해 주세요</p>
						</c:if>
					</div>
					<div class="auto-login">
						<input type="checkbox" id="remember" name="remember"> <label
							for="checkbox">자동 로그인</label>
					</div>

					<div class="login-options">

						<div class="find-account">
							<a href="/account/find/id">아이디 찾기</a> <span class="divider">|</span>
							<a href="/account/find/password">비밀번호 찾기</a> <span
								class="divider">|</span> 
								<span style="margin-left:50px;"></span>
								<span>회원가입&nbsp;&nbsp;<a
								href="/user/register">개인</a><span>&nbsp;|</span> <a
								href="/company/register">기업</a></span>


						</div>
					</div>

					<button type="submit" class="btn-confirm full-width">로그인</button>
		</form>
	</div>
</main>

<script>
// #region 전역변수 및 API용
// #region 카톡
Kakao.init('b50a2700ff109d1ab2de2eca4e07fa23');
Kakao.isInitialized();

	function loginWithKakao() {
		// JSP에서 contextPath 동적으로 주입
		let contextPath = '${pageContext.request.contextPath}';
		if (contextPath) {
			contextPath = '/' + contextPath;
		}
		const redirectUri = `\${location.protocol}//\${location.host}\${contextPath}/user/kakao`;

		console.log(contextPath);
		console.log(redirectUri);

		Kakao.Auth.authorize({
		redirectUri: redirectUri,
		scope: 'profile_nickname, account_email'
		});
	}
// #endregion 카톡

// JS에서 enum타입처럼 쓰는거
const METHOD = {
  EMAIL: "email",
  PHONE: "phone"
};
// #endregion 전역변수 및 API용

//DOM 로딩 후 버튼 이벤트 연결
window.onload=()=>{

  // 회원 유형 탭 전환
  const tabs = document.querySelectorAll('.account-type-tab');
  tabs.forEach(tab => {
	tab.addEventListener('click', function () {
		tabs.forEach(t => t.classList.remove('active'));
		this.classList.add('active');

		const radio = this.querySelector('input[type="radio"]');
		if (radio) {
		radio.click();
		}
	});
  });

  // 회원 유형 전환시 이벤트트
  $('input[name="accountType"]').on('change', function() {
    const selectedValue = $('input[name="accountType"]:checked').val();
	console.log('selectedValue: ', selectedValue);

    if (selectedValue === 'USER') {
      // 개인 회원 관련 동작
	  $('.btn-kakao').show(100)
    } else if (selectedValue === 'COMPANY') {
      // 기업 회원 관련 동작
	  $('.btn-kakao').hide(100)
    }
  });

  // URL 쿼리 파라미터 처리
  const urlParams = new URLSearchParams(window.location.search);
  const error = urlParams.get('error');
  const prevAccountType = urlParams.get('accountType');
  const autoLogin = urlParams.get('autoLogin');

  if (error === 'true') {
    window.publicModals.show('아이디 또는 비밀번호가 일치하지 않습니다.');
  }

  if (prevAccountType === 'USER' || prevAccountType === 'COMPANY') {
    tabs.forEach(tab => {
      const radio = tab.querySelector('input[type="radio"]');
      if (radio?.value === prevAccountType) {
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        radio.checked = true;
      }
    });

	if (prevAccountType === 'COMPANY') {
		$('.btn-kakao').hide(100)
	}
  }

  if (autoLogin === "true") {
    const rememberCheckbox = document.getElementById('remember');
    if (rememberCheckbox) {
      console.log("자동로그인?");
      rememberCheckbox.checked = true;
    }
  }
}
</script>

<jsp:include page="../footer.jsp" />


