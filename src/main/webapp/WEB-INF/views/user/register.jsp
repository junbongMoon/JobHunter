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
	<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js" integrity="sha384-dok87au0gKqJdxs7msEdBPNnKSRT+/mhTVzq+qOhcL464zXwvcrpjeWvyj1kCdq6" crossorigin="anonymous"></script>

<style>
.main {
	padding: 60px 20px;
	background: #f8f9fa;
	min-height: calc(100vh - 200px);
}

.login-container {
	background: white;
	border-radius: 20px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
	max-width: 700px;
	margin: 0 auto;
}

.login-title {
	font-weight: 600;
	color: #2c3e50;
	border-bottom: 1px solid #eee;
	line-height: 1.5;
}

.form-group {
	margin-bottom: 20px;
}

.form-group input[type="text"], .form-group input[type="password"] {
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 14px;
	margin-bottom: 15px;
}

.full-width{
	width: 100%;
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
	flex: 1;
	height: 47px;
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

.social-login {
	margin-top: 20px;
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
	color: var(- -bs-red);
}

.flex-x-container{
	display: flex;
	flex-direction: row;
}

.between-con{
	justify-content: space-between;
}

.sub-title{
	text-align: center;
}

.btn-kakao {
	margin-bottom: 9px;
}

.input-left{
	margin-right: 20px;
	width: 80%;
}

.phone-input-group input {
	width: 30%;
}

.phone-input-group span {
	font-size: 27px;
	font-weight: 600;
	text-align: center;
	flex: 1;
}

</style>

<main class="main">
	<div class="login-container">
		<!-- <form action="${pageContext.request.contextPath}/user/register" method="post"> -->
			
			<div class="account-type-tabs">
				<label class="account-type-tab active"> <input type="radio"
					name="accountType" value="USER" checked> 개인 회원
				</label> <label class="account-type-tab"> <input type="radio"
					name="accountType" value="COMPANY"> 기업 회원
				</label>
			</div>

			<div class="flex-x-container between-con">
				<h2 class="login-title">개인 회원가입</h2>
				<div class="btn-kakao" onclick="loginWithKakao()">
					<img src="/resources/forKakao/kakao_login_medium_narrow.png" alt="kakao">
				</div>
			</div>
			<hr>

			<h4 class="sub-title">로그인정보</h4>
			<div class="form-group">
				<div class="flex-x-container between-con">
					<input class="input-left" type="text" id="id" name="id" placeholder="아이디를 입력해주세요." required />
					<button class="btn-confirm">중복확인</button>
				</div>
				<input class="full-width" type="password" id="password" name="password" placeholder="비밀번호" required />
				<input class="full-width" type="password" id="checkPassword" placeholder="비밀번호 확인" required />
			</div>
			<hr>

			<h4 class="sub-title">회원정보</h4>
			<div class="form-group">
				<input class="full-width" type="text" id="userName" name="name" placeholder="성함을 입력해주세요." required />
				<div class="flex-x-container between-con">
					<input class="input-left" type="text" id="email" name="email" placeholder="이메일을 입력해주세요." required />
					<button class="btn-confirm">인증</button>
				</div>
				<div class="flex-x-container between-con">
					<div class="phone-input-group input-left flex-x-container between-con">
						<input type="text" maxlength="3" placeholder="000" oninput="handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
						<span>-</span>
						<input type="text" maxlength="4" placeholder="0000" oninput="if(this.value.length >= 4) handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
						<span>-</span>
						<input type="text" maxlength="4" placeholder="0000" oninput="handlePhoneInput(this, null)">
					</div>
					<button class="btn-confirm" onclick="startVerifiPhone()">확인</button>
				</div>
				<input type="hidden" id="mobile" name="mobile" >
			</div>

			<hr>

			<button type="submit" class="btn-confirm full-width">로그인</button>

			<div class="social-login">
			</div>
		<!-- </form> -->
	</div>
	<!-- 파이어베이스 캡챠 넣을곳 -->
	<div id="recaptcha-container"></div>
</main>

<!-- 알럿 모달 추가 -->
<div id="alertModalOverlay" class="alert-modal-overlay"
	style="display: none;"></div>
<div id="alertModal" class="alert-modal-box" style="display: none;">
	<div class="alert-modal-content">
		<div class="alert-modal-message"></div>
		<div class="alert-modal-buttons"></div>
	</div>
</div>

<script>
// 카톡
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

	// 아래는 데모를 위한 UI 코드입니다.
	displayToken()
	function displayToken() {
		var token = getCookie('authorize-access-token');

		if(token) {
		Kakao.Auth.setAccessToken(token);
		Kakao.Auth.getStatusInfo()
			.then(function(res) {
			if (res.status === 'connected') {
				document.getElementById('token-result').innerText
				= 'login success, token: ' + Kakao.Auth.getAccessToken();
			}
			})
			.catch(function(err) {
			Kakao.Auth.setAccessToken(null);
			});
		}
	}

	function getCookie(name) {
		var parts = document.cookie.split(name + '=');
		if (parts.length === 2) { return parts[1].split(';')[0]; }
	}
// 카톡


function startVerifiPhone() {
	const phoneInputs = document.querySelectorAll('.phone-input-group input');
    const formattedNumber = formatPhoneNumber(phoneInputs[0], phoneInputs[1], phoneInputs[2]);
    console.log(formattedNumber);
}

// 전화번호 입력 처리 함수
function handlePhoneInput(input, nextInput) {
    input.value = input.value.replace(/[^0-9]/g, '');
    if (input.value.length >= 3 && nextInput) {
      	nextInput.focus();
    }
}

// 전화번호 포맷팅 함수
function formatPhoneNumber(input1, input2, input3) {
    const num1 = input1.value;
    const num2 = input2.value;
    const num3 = input3.value;
    
    if (num1.length === 3 && num2.length === 4 && num3.length === 4) {
      	return `\${num1}-\${num2}-\${num3}`;
    }
    return null;
}

const firebaseConfig = {
    apiKey: "AIzaSyDh4lq9q7JJMuDFTus-sehJvwyHhACKoyA",
    authDomain: "jobhunter-672dd.firebaseapp.com",
    projectId: "jobhunter-672dd",
    storageBucket: "jobhunter-672dd.appspot.com",
    messagingSenderId: "686284302067",
    appId: "1:686284302067:web:30c6bc60e91aeea963b986",
    measurementId: "G-RHVS9BGBQ7"
};
firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
let confirmationResult = null;
// JS에서 enum타입처럼 쓰는거
const METHOD = {
  EMAIL: "email",
  PHONE: "phone"
};
// 국제번호로 변환 (Firebase 용)
function formatPhoneNumberForFirebase(koreanNumber) {
  const cleaned = koreanNumber.replace(/-/g, '');
  return cleaned.startsWith('0') ? '+82' + cleaned.substring(1) : cleaned;
}
// 국제번호를 한국 형식으로 되돌림 (서버 전송용)
function formatToKoreanPhoneNumber(internationalNumber) {
  return internationalNumber.startsWith("+82")
    ? internationalNumber.replace("+82", "0").replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3")
    : internationalNumber;
}

// 알럿 모달 유틸리티
const alertUtils = {
  show: (message, options = {}) => {
    const {
      confirmText = '확인',
      cancelText = null,
      onConfirm = null,
      onCancel = null
    } = options;

    const overlay = document.getElementById('alertModalOverlay');
    const modal = document.getElementById('alertModal');
    const messageEl = modal.querySelector('.alert-modal-message');
    const buttonsEl = modal.querySelector('.alert-modal-buttons');

    messageEl.textContent = message;
    
    let buttonsHTML = '';
    if (cancelText) {
      buttonsHTML += `<button class="alert-modal-button cancel">${cancelText}</button>`;
    }
    buttonsHTML += `<button class="alert-modal-button confirm">${confirmText}</button>`;
    
    buttonsEl.innerHTML = buttonsHTML;

    overlay.style.display = 'block';
    modal.style.display = 'block';

    const confirmBtn = modal.querySelector('.alert-modal-button.confirm');
    const cancelBtn = modal.querySelector('.alert-modal-button.cancel');

    confirmBtn.onclick = () => {
      if (onConfirm) onConfirm();
      alertUtils.hide();
    };

    if (cancelBtn) {
      cancelBtn.onclick = () => {
        if (onCancel) onCancel();
        alertUtils.hide();
      };
    }
  },
  hide: () => {
    document.getElementById('alertModalOverlay').style.display = 'none';
    document.getElementById('alertModal').style.display = 'none';
  }
};

// 이메일 인증 코드 전송
async function sendEmailVerification() {
    
    const email = "${sessionScope.account.email}";

    $.ajax({
        url: "/account/auth/email",
        method: "POST",
  		  contentType: "application/json",
        data: JSON.stringify({ email }),
        success: (res) => {
          alertUtils.show("메일 전송 성공: " + res);
        document.getElementById('emailVerifySection').style.display = 'block';
        document.getElementById('emailVerificationContent').style.display = 'none';
        },
        error: (xhr) => alertUtils.show("메일 전송 중 오류 발생: " + xhr.responseText)
    });
}

//캡챠기능 파이어베이스 기본 제공 (1회용이라 초기화)
function firebaseCaptcha() {
    if (!window.recaptchaVerifier) {
      window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier('recaptcha-container', {
          size: 'invisible',
          callback: () => {}
        });
    }
}
// 전화번호 인증 코드 전송
async function sendPhoneVerification() {

  const phoneNumber = formatPhoneNumberForFirebase("${sessionScope.account.mobile}");

    // 캡챠_firebase에서 제공해줌
    firebaseCaptcha() 

    try {
    	confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
        alertUtils.show("인증 코드가 전송되었습니다.");
        document.getElementById('phoneSendSection').style.display = 'none';
        document.getElementById('phoneVerifySection').style.display = 'block';
        document.getElementById('phoneVerificationContent').style.display = 'none';
    } catch (error) {
        console.error("전화번호 인증 실패:", error);
        alertUtils.show("전화번호 인증 중 오류 발생.");
    }
}

async function verifyPhoneCode(code) {
    try {
      await confirmationResult.confirm(code);
      onVerificationSuccess(METHOD.PHONE); // 성공 후 콜백 실행
    } catch (error) {
      console.error("코드 인증 실패:", error);
      alertUtils.show("잘못된 인증 코드입니다.");
    }
}

async function verifyEmailCode(code) {
    const email = "${sessionScope.account.email}";
    $.ajax({
      url: `/account/auth/email/${code}`,
      method: "POST",
  	  contentType: "application/json",
      data: JSON.stringify({
      email: email
  }),
      success: () => onVerificationSuccess(METHOD.EMAIL),
      error: (xhr) => alertUtils.show("이메일 인증 실패: " + xhr.responseText)
    });
}

function onVerificationSuccess(method) {
    const accountType = "${sessionScope.account.accountType}";
    if (!accountType) {
    	alertUtils.show("세션이 만료되었습니다. 새로고침 후 다시 시도해 주세요.")
        return;
    }

    let value;
    if (method === METHOD.PHONE) {
        const intlPhone = "${sessionScope.account.mobile}";
        if (!intlPhone) {
          alertUtils.show("세션이 만료되었습니다. 새로고침 후 다시 시도해 주세요.")
            return;
        }
      value = formatToKoreanPhoneNumber(intlPhone);
    } else {
            const email = "${sessionScope.account.email}";
            if (!email) {
              alertUtils.show("세션이 만료되었습니다. 새로고침 후 다시 시도해 주세요.")
                return;
            }
            value = email;
    }

    const dto = {
    type: method === METHOD.PHONE ? "mobile" : "email",
    value,
    accountType
    };

    $.ajax({
    url: "/account/auth",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify(dto),
    success: (redirectUrl) => {
                console.log(redirectUrl);
                alertUtils.show("인증이 완료되었습니다.", {
                    onConfirm: () => {
                window.location.href = redirectUrl || "/";
                    }
                });
    },
    error: (xhr) => {
                alertUtils.show("인증 처리 중 오류가 발생했습니다.");
      console.error(xhr.responseText);
    }
    });
}

//DOM 로딩 후 버튼 이벤트 연결
window.onload=()=>{
  document.getElementById("emailSendBtn")?.addEventListener("click", () => {
    sendEmailVerification();
  });

  document.getElementById("phoneSendBtn")?.addEventListener("click", () => {
    sendPhoneVerification()
  });

  document.getElementById("emailVerifyBtn")?.addEventListener("click", () => {
    const code = document.getElementById("emailCode").value;
    verifyEmailCode(code);
  });

  document.getElementById("phoneVerifyBtn")?.addEventListener('click', function() {
    const code = document.getElementById('phoneCode')?.value;
    if (code) {
    verifyPhoneCode(code);
    } else {
      alertUtils.show("인증 코드를 입력해주세요.");
    }
  });
}
	
// 탭 전환 효과를 위한 스크립트
document.addEventListener('DOMContentLoaded', function() {
  // 회원 유형 탭 전환
  const tabs = document.querySelectorAll('.account-type-tab');
  
  tabs.forEach(tab => {
    tab.addEventListener('click', function() {
      // 모든 탭에서 active 클래스 제거
      tabs.forEach(t => t.classList.remove('active'));
      // 클릭된 탭에 active 클래스 추가
      this.classList.add('active');
    });
  });

  // 인증 방법 전환 (이메일/전화번호)
  const methodButtons = document.querySelectorAll('.btn-method');
  const methodInput = document.getElementById('method');
  
  methodButtons.forEach(button => {
    button.addEventListener('click', function() {
      const method = this.dataset.method;
      
      // 버튼 활성화 상태 변경
      methodButtons.forEach(btn => btn.classList.remove('active'));
      this.classList.add('active');
      
      // hidden input 값 업데이트
      methodInput.value = method;
      
      // 컨텐츠 전환
      document.getElementById('emailContent').style.display = method === 'email' ? 'block' : 'none';
      document.getElementById('phoneContent').style.display = method === 'phone' ? 'block' : 'none';
    });
  });

  // URL에서 쿼리스트링 파라미터 가져오기
  const urlParams = new URLSearchParams(window.location.search);
  const error = urlParams.get('error');
  const prevAccountType = urlParams.get('accountType');
  const autoLogin = urlParams.get('autoLogin');

  // 로그인 실패 메시지 표시
  if (error === 'true') {
    alertUtils.show('아이디 또는 비밀번호가 일치하지 않습니다.');
  }

  // 이전 회원 유형 선택 상태 복원
  if (prevAccountType === 'USER' || prevAccountType === 'COMPANY') {
    const tabs = document.querySelectorAll('.account-type-tab');
    tabs.forEach(tab => {
      const radio = tab.querySelector('input[type="radio"]');
      if (radio.value === prevAccountType) {
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        radio.checked = true;
      }
    });
  }
  
  // 이전 자동로그인 선택 상태 복원
  if (autoLogin == "true") {
	  const tabs = document.getElementById('remember');
    if (tabs) {
    	console.log("자동로그인?")
      tabs.checked = true; // 체크 상태로 만들기
    }
  }
});
</script>

<jsp:include page="../footer.jsp" />


