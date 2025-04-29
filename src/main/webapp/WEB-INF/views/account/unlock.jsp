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

<style>
.main {
	padding: 60px 20px;
	min-height: calc(100vh - 200px);
}

.login-container {
	background: white;
	border-radius: 20px;
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

.form-group input[type="text"] {
	text-align: center;
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	font-size: 24px;
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
		<div class="flex-x-container between-con">
			<h2 class="login-title">계정 잠금 해제</h2>
		</div>
		
		<br/>
		<h4>${unlockDTO.loginCnt}번의 로그인 실패로 인하여 계정이 잠금조치 되었습니다.</h4>
		<h4>인증을 통해 잠금을 해제해주세요.</h4>
		
		<hr>

		<div class="account-type-tabs">
			<label class="account-type-tab active"> <input type="radio"
				name="method" value="mobile" checked> 메시지
			</label> <label class="account-type-tab"> <input type="radio"
				name="method" value="email"> 이메일
			</label>
		</div>

		<div class="form-group">
			<input type="text" id="targetValue" value="연동된 연락처 :" readonly/>
		</div>
		<hr>

		<button id="modalOpenBtn" type="button" class="btn-confirm full-width" onclick="sendCode()">인증번호 발송</button>
	</div>
	<!-- 파이어베이스 캡챠 넣을곳 -->
	<div id="recaptcha-container"></div>
</main>

<script>

$(()=>{
	selectedValues()
})

// #region API 및 포메팅
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
//국제번호로 변환 (Firebase 용)
function formatPhoneNumberForFirebase(koreanNumber) {
	const cleaned = koreanNumber.replace(/-/g, '');
	return cleaned.startsWith('0') ? '+82' + cleaned.substring(1) : cleaned;
}
// #endregion

const targetUid = '${unlockDTO.uid}'
const targetAccountType = '${unlockDTO.accountType}'
const targetMobile = '${unlockDTO.mobile}'
const targetEmail = '${unlockDTO.email}'

// 인증 유형 탭 전환
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

// 인증 유형 전환시 이벤트
$('input[name="method"]').on('change', function() {
	selectedValues()
});

function selectedValues() {
	const selectedValue = $('input[name="method"]:checked').val();
	console.log('selectedValue: ', selectedValue);

  if (selectedValue === 'mobile') {
	if (targetMobile) {
		$('#targetValue').val('연동된 연락처 : ' + targetMobile)
		$('#modalOpenBtn').prop('disabled', false);
	} else {
		$('#targetValue').val('연동된 전화번호가 없습니다.')
		$('#modalOpenBtn').prop('disabled', true);
	}
  } else if (selectedValue === 'email') {
	if (targetEmail) {
		$('#targetValue').val('연동된 연락처 : ' + targetEmail)
		$('#modalOpenBtn').prop('disabled', false);
	} else {
		$('#targetValue').val('연동된 이메일이 없습니다.')
		$('#modalOpenBtn').prop('disabled', true);
	}
  }
}

function sendCode() {
	$('#modalOpenBtn').prop('disabled', true);
	const selectedValue = $('input[name="method"]:checked').val();
	if (selectedValue === 'mobile') {
		sendMobileCode()
	} else if (selectedValue === 'email') {
		sendEmailCode()
	}
}

async function sendMobileCode() {
    const phoneNumber = formatPhoneNumberForFirebase(targetMobile);
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
        window.publicModals.show("인증번호 전송중 오류가 발생했습니다. fireBase http이슈 혹은 사용횟수 초과등의 가능성이 있으니 강제진행을 원하신다면 백도어 버튼을 눌러주세요.", {
			onConfirm: ()=>{okMobile("0000")},
			confirmText: "백도어",
			cancelText: "취소"
		});
    }
	$('#modalOpenBtn').prop('disabled', false);
}

// 이메일 인증 코드 전송
function sendEmailCode() {
    $.ajax({
        url: "/account/auth/email",
        method: "POST",
		contentType: "application/json",
		data: JSON.stringify({ 
			email: targetEmail
		}),
        success: (res) => {
			window.publicModals.show(codeInput.defalt,
			{
				confirmText: '인증완료',
				cancelText: '취소',
				onConfirm: verifyEmailCode
            });
        },
        error: (xhr) => {
			window.publicModals.show("인증번호 발송에 실패하였습니다. 이메일을 확인하시고 잠시 후 다시 시도해주세요.")
		},
		complete: () => {
			$('#modalOpenBtn').prop('disabled', false);
		}
    });
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
		const result = await confirmationResult.confirm(code);
		const idToken = await result.user.getIdToken();
		okMobile(idToken)
	} catch (error) {
      console.error("코드 인증 실패:", error);
      window.publicModals.show("인증에 실패하였습니다. 잠시 후 다시 시도해주세요.");
    }
}

function okMobile(idToken) {
	$.ajax({
		type: 'POST',
		url: '/account/auth/mobile/verify',
		contentType: 'application/json',
		data: JSON.stringify({
		confirmType: "unlockAccountMobile",
		confirmToken: idToken
		}),
		success: function(res) {
			okAuth()
		},
		error: function(err) {
			window.publicModals.show("인증에 실패하였습니다. 잠시 후 다시 시도해주세요.")
		}
	});
}

function verifyEmailCode() {
	const code = $("#confirmCode").val();

	if (code.length != 6) {
		window.publicModals.show(codeInput.defalt + codeInput.failed,
			{
				confirmText: '인증완료',
				cancelText: '취소',
				onConfirm: verifyEmailCode,
				onCancel: () => {$('#sendEmailBtn').prop('disabled', false)}
    		});
		return false;
	}

    $.ajax({
		url: `/account/auth/email/verify/\${code}`,
		method: "POST",
		contentType: "application/json",
		data: JSON.stringify({
		email: targetEmail,
        confirmType: "unlockAccountEmail"
		}),
		success: () => {okAuth()},
		error: (xhr) => {
			window.publicModals.show("인증에 실패하였습니다. 잠시 후 다시 시도해주세요.")
		}
    });
}

function okAuth() {
	$.ajax({
        url: "/account/auth",
        method: "POST",
		contentType: "application/json",
		data: JSON.stringify({ 
			uid: targetUid,
			accountType: targetAccountType
		}),
        success: (res) => {
			window.publicModals.show("인증에 성공하였습니다.",
			{
				confirmText: '확인',
				onConfirm: (()=>{location.href = "/account/login";})
            });
        },
        error: (xhr) => {
			window.publicModals.show("인증중 문제가 발생하였습니다. 잠시 후 새로고침 뒤 다시 시도해주세요.")
		}
    });
}

</script>

<jsp:include page="../footer.jsp" />


