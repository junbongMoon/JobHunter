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
	margin-top: 9px;
}

.full-width {
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
	margin-top: 9px;
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
	margin-top: 30px;
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
	color: var(--bs-dark);
	background: var(--bs-primary-bg-subtle);
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

.flex-x-container {
	display: flex;
	flex-direction: row;
}

.between-con {
	justify-content: space-between;
}

.sub-title {
	text-align: center;
}

.btn-kakao {
	margin-bottom: 9px;
}

.btn-otherType {
	margin-left: 30px;
    height: 47px;
    padding: 10px 20px;
    background: var(--bs-gray-300);
    color: var(--default-color);
    border: none;
    border-radius: 8px;
    font-size: 14px;
    transition: all 0.3s ease;
}

.input-left {
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

mark {
	margin-left: 5px;
	font-size: 0.7em;
	background-color: transparent;
}

.spacer {
	margin: auto;
}

.info-defalt{
	color: #666;
}
.info-message{
	color: black;
}
.info-ok{
	color: green;
}
.info-next{
	color: blue;
}
.info-warning{
	color: red;
}
</style>

<main class="main">
	<div class="login-container">
		<form action="${pageContext.request.contextPath}/user/register" method="post" onsubmit="return confirmAll();">

		

		<div class="flex-x-container between-con">
			<h2 class="login-title">개인 회원 가입</h2>
			<div class="btn-kakao" onclick="loginWithKakao()">
				<img src="/resources/forKakao/kakao_login_medium_narrow.png"
					alt="kakao">
			</div>
		</div>
		<hr>

		<h4 class="sub-title">로그인정보</h4>
		<div class="form-group">
			
			<div class="flex-x-container between-con">
				<input class="input-left" type="text" id="id" name="id"
					placeholder="아이디를 입력해주세요." required />
				<button id="checkDuplicateIdBtn" class="btn-confirm" onclick="checkDuplicateId()" disabled>중복 확인</button>
			</div>
			<mark id="idInfoMark">아이디는 영어와 숫자를 조합한 6~20자를 입력해주세요.</mark>

			<input class="full-width" type="password" id="password"
				name="password" placeholder="비밀번호" required />
			<mark id="pwdInfoMark"></mark>

			<input class="full-width" type="password" id="checkPassword"
				placeholder="비밀번호 확인" required />
			<mark id="pwdcheckInfoMark">비밀번호는 영어와 숫자, 특수문자를 전부 포함한 8~20자를 입력해주세요.</mark>

		</div>
		<hr>

		<h4 class="sub-title">회원정보</h4>

		<div class="account-type-tabs">
			<label class="account-type-tab active"> <input type="radio"
				name="nationality" value="DOMESTIC" checked> 내국인
			</label> <label class="account-type-tab"> <input type="radio"
				name="nationality" value="FOREIGN"> 외국인
			</label>
		</div>

		<div class="form-group">

			<input class="full-width" type="text" id="userName" name="name"
				placeholder="성함을 입력해주세요." required />
			<mark id="nameInfoMark" class="info-defalt"> * 해당 내용은 이력서에도 입력될 이름이니 되도록 실명을 추천드립니다.</mark>

			<div class="flex-x-container between-con">
				<input class="input-left" type="text" id="unCheckedEmail"
					placeholder="이메일을 입력해주세요."/>

				<button id="sendEmailBtn" class="btn-confirm" onclick="sendEmailCode()">인증 발송</button>
			</div>
			<mark id="emailInfoMark"></mark>

			<div class="flex-x-container between-con">
				<div
					class="phone-input-group input-left flex-x-container between-con">
					<input type="text" maxlength="3" placeholder="000"
						oninput="handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
					<span>_</span> <input type="text" maxlength="4" placeholder="0000"
						oninput="if(this.value.length >= 4) handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
					<span>_</span> <input type="text" maxlength="4" placeholder="0000"
						oninput="handlePhoneInput(this, null)">
				</div>
				<button id="sendPhoneBtn" class="btn-confirm" onclick="sendPhoneCode()">인증
					발송</button>
			</div>
			<mark id="mobileInfoMark"></mark>

			<input type="hidden" id="authEmail"/>
			<input type="hidden" id="email" name="email">
			<input type="hidden" id="authMobile">
			<input type="hidden" id="mobile" name="mobile">
			<mark class="info-defalt"> * 이메일 혹은 전화번호중 최소 하나 이상 인증을 진행해주시기 바랍니다.</mark>
		</div>

		<hr>
		<label for="acept">
		<input type="checkbox" id="acept">
		개인정보 이용에 동의하십니까?
		</label>
		<hr>

		<button type="submit" class="btn-confirm full-width" onclick="return confirmAll()">회원가입</button>

		<div class="social-login"></div>
		</form>
	</div>
	<!-- 파이어베이스 캡챠 넣을곳 -->
	<div id="recaptcha-container"></div>
</main>

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

		Kakao.Auth.authorize({
		redirectUri: redirectUri,
		scope: 'profile_nickname, account_email'
		});
	}
// 카톡
// 파이어베이스
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
const codeInput = {
	defalt:`<input type="text" id="confirmCode" name="confirmCode"
		placeholder="인증번호를 입력해주세요." required />`,
	failed:`<div class="warning">인증번호 6자리를 입력해주세요.</div>`
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
// 파이어베이스
function checkDuplicateId() {
	$('#checkDuplicateIdBtn').prop('disabled', true);
    const userId = $("#id").val();

    if (!userId || userId.trim().length === 0) {
        $("#idInfoMark").text("아이디를 입력해주세요.").css("color", "red");
        return;
    }

    $.ajax({
        url: "/user/check/id",
        method: "GET",
        data: { userId },
        success: function (isDuplicate) {
            if (isDuplicate) {
                $("#idInfoMark").text("이미 사용 중인 아이디입니다.").removeClass().addClass("info-warning");
            } else {
                $("#idInfoMark").text("사용 가능한 아이디입니다.").removeClass().addClass("info-ok");
            }
        },
        error: function () {
            $("#idInfoMark").text("오류가 발생했습니다.").removeClass().addClass("info-warning");
			$('#checkDuplicateIdBtn').prop('disabled', false);
        }
    });
}
async function sendPhoneCode() {
	const phoneInputs = document.querySelectorAll('.phone-input-group input');
    const formattedNumber = formatPhoneNumber(phoneInputs[0], phoneInputs[1], phoneInputs[2]);

	if (await checkDuplicateMobile(formattedNumber)) {
		return;
	}

	$('#authMobile').val(formattedNumber)

    const phoneNumber = formatPhoneNumberForFirebase(formattedNumber);
    console.log(phoneNumber);
 	// 캡챠_firebase에서 제공해줌
    firebaseCaptcha() 

    try {
    	confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
        window.publicModals.show(codeInput.defalt,
		{
			confirmText: '인증완료',
			cancelText: '취소',
			onConfirm: verifyPhoneCode
    	});
    } catch (error) {
        console.error("전화번호 인증 실패:", error);
        window.publicModals.show("전화번호 인증 중 오류 발생.");
    }
}

async function checkDuplicateMobile(formattedNumber) {
  try {
    const res = await fetch('/account/check/mobile', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        mobile: formattedNumber,
        accountType: "USER"
      })
    });

    const message = await res.text(); // 메시지 확인용
    if (res.ok) {
      console.log('전화번호 중복 없음:', message);
      return false; // 중복 아님
    } else {
      window.publicModals.show('중복된 전화번호입니다');
      return true; // 중복됨
    }

  } catch (e) {
    window.publicModals.show('서버와의 연결이 불안정합니다. 잠시 후 다시 시도해주세요.');
    return true; // 실패 시 중복된 걸로 취급
  }
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
//국제번호로 변환 (Firebase 용)
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



// 이메일 인증 코드 전송
function sendEmailCode() {
	$("#emailInfoMark").text(`이메일을 전송중입니다.`).removeClass().addClass("info-next");
	$('#sendEmailBtn').prop('disabled', true);
	const email = $("#unCheckedEmail").val();
    $.ajax({
        url: "/account/auth/email",
        method: "POST",
  		contentType: "application/json",
		data: JSON.stringify({ 
			email: email,
			checkDuplicate: true,
			accountType: "USER"
		}),
        success: (res) => {
			$("#emailInfoMark").text(`이메일이 전송중되었습니다. 인증을 진행해주세요.`).removeClass().addClass("info-next");
			window.publicModals.show(codeInput.defalt,
			{
				confirmText: '인증완료',
				cancelText: '취소',
				onConfirm: verifyEmailCode
    		});
        },
        error: (xhr) => {
			$("#emailInfoMark").text(`이메일의 전송에 실패했습니다. 잠시후 다시 시도해주세요.`).removeClass().addClass("info-warning");
			$('#sendEmailBtn').prop('disabled', false);
			console.log("메일 전송 중 오류 발생: " + xhr.responseText)
		}
    });
}

function okMobile() {
	const mobile = $("#authMobile").val()
	$("#mobile").val(mobile)
	$("#mobileInfoMark").text(`인증에 성공하였습니다. (현재 전화번호 : \${mobile})`).removeClass().addClass("info-ok");
}

async function verifyPhoneCode() {
	const code = document.getElementById("confirmCode").value;

	if (code.length != 6) {
		window.publicModals.show(codeInput.defalt + codeInput.failed,
			{
				confirmText: '인증완료',
				cancelText: '취소',
				onConfirm: verifyPhoneCode
    		});
		return true;
	}

    try {
      await confirmationResult.confirm(code);
      okMobile();
    } catch (error) {
      console.error("코드 인증 실패:", error);
      window.publicModals.show("잘못된 인증 코드입니다.");
    }
}

function verifyEmailCode() {
	const code = $("#confirmCode").val();
    const email = $("#unCheckedEmail").val();

	if (code.length != 6) {
		window.publicModals.show(codeInput.defalt + codeInput.failed,
			{
				confirmText: '인증완료',
				cancelText: '취소',
				onConfirm: verifyEmailCode
    		});
		return false;
	}

    $.ajax({
		url: `/account/auth/email/\${code}`,
		method: "POST",
		contentType: "application/json",
		data: JSON.stringify({
		email: email
		}),
		success: () => okEmail(),
		error: (xhr) => {
			$("#emailInfoMark").text(`인증에 실패하였습니다. 잠시 후 다시 시도해주세요.`).removeClass().addClass("info-next");
			$('#sendEmailBtn').prop('disabled', false);
			window.publicModals.show("인증에 실패하였습니다. 잠시 후 다시 시도해주세요.")
		}
    });
}

function okEmail() {
	$('#sendEmailBtn').prop('disabled', false);
	const email = $("#unCheckedEmail").val()
	$("#email").val(email)
	$("#emailInfoMark").text(`인증에 성공하였습니다. (현재 이메일 : \${email})`).removeClass().addClass("info-ok");
}
// 인증관련
// message ok next warning
// ==유효성검사==

function confirmAll() {
	if (!$("#idInfoMark").hasClass("info-ok")) {
		$("#id").focus();
		return false;
	}

	if (!pwdIsValid()){
		$("#password").focus();
		return false;
	}

	if (!confirmPassword()){
		$("#checkPassword").focus();
		return false;
	}

	if (!nameIsValid()) {
		$("#userName").focus();
		return false;
	}

	if(!$("#mobile").val() && !$("#email").val()) {
		window.publicModals.show("이메일 혹은 전화번호 인증을 진행해 주세요.")
		$("#pwdcheckInfoMark")[0].scrollIntoView({ behavior: 'smooth' });
	}
	
	if (!$("#acept").is(":checked")) {
		window.publicModals.show("개인정보 이용 동의에 체크해주세요.")
	}

	console.log("검사완료");

	return true;
}

// 아이디
$('#id').on('change keyup', () => {
	idIsValid();
})
function idIsValid() {
	const idValue = $('#id').val();
    const idRegex = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,20}$/;

    if (idRegex.test(idValue)) {
        $("#idInfoMark").text(`중복검사를 진행해주세요`).removeClass().addClass("info-next");
		$('#checkDuplicateIdBtn').prop('disabled', false);
        return true;
    } else {
        $("#idInfoMark").text(`아이디는 영어와 숫자를 조합한 6~20자여야 합니다.`).removeClass().addClass("info-warning");
		$('#checkDuplicateIdBtn').prop('disabled', true);
        return false;
    }
}
// 비밀번호
$('#password').on('change keyup', () => {
	pwdIsValid();
})
function pwdIsValid() {
	const pwdValue = $('#password').val();
    const pwdRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])[a-zA-Z\d!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]{6,20}$/;

    if (pwdRegex.test(pwdValue)) {
        $("#pwdInfoMark").text(`사용 가능한 비밀번호입니다.`).removeClass().addClass("info-ok");
        return true;
    } else {
        $("#pwdInfoMark").text(`비밀번호는 영어와 숫자, 특수문자를 전부 포함한 6~20자여야 합니다.`).removeClass().addClass("info-warning");
        return false;
    }
}

$('#checkPassword').on('change keyup', () => {
    confirmPassword();
});

function confirmPassword() {
	const pwdValue = $('#password').val();
	const checkPwdVal = $('#checkPassword').val();
	if (pwdValue == checkPwdVal) {
		$("#pwdcheckInfoMark").text(`비밀번호가 일치합니다.`).removeClass().addClass("info-ok");
		return true;
	} else {
		$("#pwdcheckInfoMark").text(`비밀번호가 일치하지 않습니다.`).removeClass().addClass("info-warning")
		return false;
	}
}
// 이름
$('#userName').on('change keyup', () => {
	nameIsValid();
})

function nameIsValid() {
	const nameValue = $('#userName').val();

    if (!nameValue) {
		$("#nameInfoMark").text(`이름은 필수 입력사항입니다.`).removeClass().addClass("info-warning");
		return false;
    } else if (nameValue.length >= 100){
		$("#nameInfoMark").text(`이름은 100글자까지만 저장이 가능합니다. 성함이 100문자 이상이라면 죄송하오나 일부만 기입해주시기 바랍니다.`).removeClass().addClass("info-warning");
		return false;
	}
	$("#nameInfoMark").text(`* 해당 내용은 이력서에도 입력될 이름이니 되도록 실명을 추천드립니다.`).removeClass().addClass("info-ok");
	return true;
}
// 이메일
$('#unCheckedEmail').on('change keyup', () => {
	confirmEmail();
})

function confirmEmail() {
	const emailValue = $('#unCheckedEmail').val();
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    if (emailRegex.test(emailValue)) {
        $("#emailInfoMark").text(`인증을 진행해주세요`).removeClass().addClass("info-next");
		$('#sendEmailBtn').prop('disabled', false);
        return true;
    } else {
        $("#emailInfoMark").text(`이메일 형식에 맞지 않습니다.`).removeClass().addClass("info-warning");
		$('#sendEmailBtn').prop('disabled', true);
        return false;
    }
}
// ==유효성검사==
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
});
</script>

<jsp:include page="../footer.jsp" />


