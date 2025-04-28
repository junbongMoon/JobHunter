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
	display:flex;
}

.form-group input[type="text"] {
	text-align: center;
	flex:1;
	padding: 12px;
	border: 1px solid #ddd;
	font-size: 18px;
}

.form-group input:focus {
	border-color: #47b2e4;
	outline: none;
}

.form-group select {
	text-align: center;
	width:25%;
	padding: 12px;
	border: 1px solid #ddd;
	font-size: 18px;
}

.full-width {
	width: 100%;
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

.phone-input-group {
	flex:1;
}

.phone-input-group span {
	font-size: 25px;
	font-weight: 400;
	padding: 5px;
	text-align: center;
}

.phone-input-group input {
	max-width: 150px;
}

mark {
	margin-left: 5px;
	font-size: 0.7em;
	background-color: transparent;
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
		<div class="flex-x-container between-con">
			<h2 class="login-title">계정 찾기</h2>
		</div>
		
		<br/>
		<h4>비밀번호 찾기</h4>
		
		<hr>

		<div class="account-type-tabs">
			<label class="account-type-tab active"> <input type="radio"
				name="targetType" value="USER" checked> 개인 회원
			</label> <label class="account-type-tab"> <input type="radio"
				name="targetType" value="COMPANY"> 기업 회원
			</label>
		</div>

		<div class="form-group">
		
			<div id="targetMobile" class="phone-input-group flex-x-container between-con" style="display: none;">
				<input type="text" maxlength="3" placeholder="000"
						oninput="handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
					<span>⁃⁃</span> 
				<input type="text" maxlength="4" placeholder="0000"
						oninput="if(this.value.length >= 4) handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
					<span>⁃⁃</span> 
				<input type="text" maxlength="4" placeholder="0000"
						oninput="handlePhoneInput(this, null)">
			</div>
			
			<input type="text" id="targetEmail" placeholder="연락처를 입력해주세요"/>
			
			<select id="targetMethod">
				<option value="email">이메일인증</option>
                <option value="mobile">모바일인증</option>
            </select>
            
		</div>
		<div class="form-group">
			<input style="width: 100%;" type="text" id="accountId" placeholder="아이디를 입력해주세요"/>
		</div>
		<div class="form-group">
			<input style="width: 100%; display:none;" type="text" id="businessNum" placeholder="사업자 등록번호를 입력해주세요"/>
		</div>
		<hr>
		<a href="/account/login" style="float:right; margin-right:10px">로그인</a>
		<span style="float:right">|</span>
		<a href="/account/find/id" style="float:right">아이디 찾기</a>
		<button id="modalOpenBtn" type="button" class="btn-confirm full-width" onclick="sendCode()">인증번호 발송</button>
	</div>
	<!-- 파이어베이스 캡챠 넣을곳 -->
	<div id="recaptcha-container"></div>
</main>

<script>

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
//캡챠기능 파이어베이스 기본 제공 (1회용이라 초기화)
function firebaseCaptcha() {
    if (!window.recaptchaVerifier) {
      window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier('recaptcha-container', {
          size: 'invisible',
          callback: () => {}
        });
    }
}
//국제번호로 변환 (Firebase 용)
function formatPhoneNumberForFirebase(koreanNumber) {
	if(koreanNumber) {
		const cleaned = koreanNumber.replace(/-/g, '');
		return cleaned.startsWith('0') ? '+82' + cleaned.substring(1) : cleaned;
	}
	return null;
}
// 파이어베이스
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

// #endregion

// #region 인증 유형 탭 전환
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
$('input[name="targetType"]').on('change', () => {
	const selectedValue = $('input[name="targetType"]:checked').val();

	if (selectedValue === 'USER') {
		$('#businessNum').hide(250)
	} else if (selectedValue === 'COMPANY') {
		$('#businessNum').show(250)
	}
});

$('#targetMethod').on('change', () => {
	const selectedValue = $('#targetMethod').val();

	if (selectedValue === 'email') {
		$('#targetMobile').hide()
		$('#targetEmail').show()
	} else if (selectedValue === 'mobile') {
		$('#targetEmail').hide()
		$('#targetMobile').show()
	}
})
// #endregion

function sendCode() {
	$('#modalOpenBtn').prop('disabled', true);

	const selectedType = $('input[name="targetType"]:checked').val();
	const value = $('#businessNum').val().replace(/[^\d]/g, '');
	const targetId = $('#accountId').val();
	const targetMethod = $('#targetMethod').val();

	if (selectedType === 'COMPANY' && value.length != 10) {
		window.publicModals.show("정확한 사업자 등록번호를 입력해주세요.")
		$('#modalOpenBtn').prop('disabled', false);
		return;
	}

	if (targetId == null || targetId.length < 6) {
		window.publicModals.show("올바른 아이디를 입력해주세요")
		$('#modalOpenBtn').prop('disabled', false);
		return;
	}

	if (targetMethod === 'mobile') {
		sendPhoneCode()
	} else {
		sendEmailCode()
	}
}

// 모바일 인증번호 전송
async function sendPhoneCode() {
	const phoneInputs = document.querySelectorAll('#targetMobile input');
    const formattedNumber = formatPhoneNumber(phoneInputs[0], phoneInputs[1], phoneInputs[2]);

    const phoneNumber = formatPhoneNumberForFirebase(formattedNumber);

	if (phoneNumber == null || phoneNumber.length <= 10) {
		window.publicModals.show("올바른 전화번호를 입력해주세요")
		$('#modalOpenBtn').prop('disabled', false);
		return;
	}

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
        window.publicModals.show("인증번호 발송에 실패했습니다. http이슈 혹은 firebase횟수 초과등의 가능성이 있으니 강제진행을 원하신다면 백도어 버튼을 눌러주세요.(포트폴리오용)",
        	{
        		confirmText: "백도어",
        		cancelText: "취소",
        		onConfirm: okMobile
        	});
    }
	$('#modalOpenBtn').prop('disabled', false);
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
		window.publicModals.show(codeInput.defalt + codeInput.failed,
			{
				confirmText: '인증완료',
				cancelText: '취소',
				onConfirm: verifyPhoneCode
    		});
		return true;
    }
}

// 인증성공
function okMobile() {
	const phoneInputs = document.querySelectorAll('#targetMobile input');
    const formattedNumber = formatPhoneNumber(phoneInputs[0], phoneInputs[1], phoneInputs[2]);
	const selectedType = $('input[name="targetType"]:checked').val();
	const businessNum = $('#businessNum').val().replace(/[^\d]/g, '');
	const accountId = $('accountId').val()

	$.ajax({
        url: "/account/find/id",
        method: "POST",
  		contentType: "application/json",
		data: JSON.stringify({ 
			targetId: accountId,
			targetType: "mobile",
			targetValue: formattedNumber,
			accountType: selectedType,
			businessNum: businessNum
		}),
        success: (res) => {
			if (!res.Uid) {
				window.publicModals.show("해당 연락처를 사용중인 아이디가 존재하지 않습니다.")
			} else {
				showNewPwdModal('', res.Uid)
			}
        },
        error: (xhr) => {
			console.log(xhr);
			window.publicModals.show("해당 계정이 존재하지 않습니다.")
		}
    });
}


// 이메일

// 이메일 인증 코드 전송
function sendEmailCode() {
	const email = $("#targetEmail").val();

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

    if (!emailRegex.test(email)) {
		window.publicModals.show("올바르지 않은 이메일 형식입니다.")
		$('#modalOpenBtn').prop('disabled', false);
		return;
    }

    $.ajax({
        url: "/account/auth/email",
        method: "POST",
  		contentType: "application/json",
		data: JSON.stringify({ 
			email: email
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
			window.publicModals.show("이메일 전송에 실패하였습니다. 잠시뒤 다시 시도해주세요.")
		},
		complete: () => {$('#modalOpenBtn').prop('disabled', false);}
    });
}

function verifyEmailCode() {
	const code = $("#confirmCode").val();

    const email = $("#targetEmail").val();

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
		url: `/account/auth/email/verify/\${code}`,
		method: "POST",
		contentType: "application/json",
		data: JSON.stringify({
		email: email
		}),
		success: () => okEmail(),
		error: (xhr) => {
			window.publicModals.show(codeInput.defalt + codeInput.failed,
			{
				confirmText: '인증완료',
				cancelText: '취소',
				onConfirm: verifyEmailCode
    		});
		}
    });
	return false;
}

function okEmail() {
	const accountId = $("#accountId").val();
	const email = $("#targetEmail").val();
	const selectedType = $('input[name="targetType"]:checked').val();
	const businessNum = $('#businessNum').val().replace(/[^\d]/g, '');

	$.ajax({
        url: "/account/find/id",
        method: "POST",
  		contentType: "application/json",
		data: JSON.stringify({ 
			targetId: accountId,
			targetType: "email",
			targetValue: email,
			accountType: selectedType,
			businessNum: businessNum
		}),
        success: (res) => {
			if (!res.Uid) {
				window.publicModals.show("해당 계정이 존재하지 않습니다.")
			} else {
				showNewPwdModal('', res.Uid)
			}
        },
        error: (xhr) => {
			console.log(xhr);
			window.publicModals.show("해당 계정이 존재하지 않습니다.")
		},
		complete: () => {$('#modalOpenBtn').prop('disabled', false);}
    });
}



function showNewPwdModal(text, uid) {
	const modalText = `
	<input id="changePassword" type="password" style="min-width: 300px;" placeholder="변경할 비밀번호를 입력하세요.">
	<input id="checkPassword" type="password" style="min-width: 300px;" placeholder="비밀번호를 다시 한번 입력해주세요.">
	<input id="changeUid" type="hidden" value='\${uid}'>
	`

	const failedText = modalText + text;

	window.publicModals.show(failedText,{
	onConfirm: () => {changePassword(); return false;},
	confirmText:'변경완료',
	cancelText:'취소',
	size_x:'350px'
	})
}

function changePassword() {
	const changePassword = $('#changePassword').val();
	const checkPassword = $('#checkPassword').val();
	const changeUid = $('#changeUid').val();

	const pwdRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])[a-zA-Z\d!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]{6,20}$/;

	if (!pwdRegex.test(changePassword)) {
		const failedText = `<div style="color:red; margin-top: 10px; font-size:0.8em">비밀번호는 영어와 숫자, 특수문자를 전부 포함한 6~20자여야 합니다.</div>`
		showNewPwdModal(failedText, changeUid)
		return;
	}

	if (changePassword !== checkPassword) {
	const failedText = `<div style="color:red; margin-top: 10px; text-size:0.8em">비밀번호 재입력란을 다시 한번 확인해주세요.</div>`
	showNewPwdModal(failedText, changeUid)
	return;
}

	const selectedType = $('input[name="targetType"]:checked').val();
	const targetUrl = selectedType === 'COMPANY' ? "/company/password" : "/user/password";

	$.ajax({
	url: targetUrl,
	method: "patch",
	contentType: "application/json",
	data: JSON.stringify({ uid: changeUid, password: changePassword }),
	success: () => {
		window.publicModals.show(
			"비밀번호가 변경되었습니다. 로그인페이지로 이동하시겠습니까?",
			{
				confirmText: '이동',
				cancelText: '취소',
				onConfirm: () => {location.href = "/account/login";}
			});
	},
	error: (xhr) => {
		const failedText = `<div style="color:red; margin-top: 10px; text-size:0.8em">비밀번호 변경중 오류가 발생했습니다. 잠시후 다시 시도해 주세요.</div>`
		showNewPwdModal(failedText, changeUid)
		return;
	}
	});
}


document.getElementById('businessNum').addEventListener('input', formatNumber);
// 숫자 포맷팅 함수 (사업자번호)
function formatNumber(e) {
    // 숫자 이외의 문자 제거
    let value = e.target.value.replace(/[^\d]/g, '');
    // 길이 제한 (10자리까지만)
    if (value.length > 10) {
        value = value.substring(0, 10);
    }
    // 포맷: 123-45-67890
    let formatted = value;
    if (value.length > 3 && value.length <= 5) {
        formatted = value.slice(0, 3) + '-' + value.slice(3);
    } else if (value.length > 5) {
        formatted = value.slice(0, 3) + '-' + value.slice(3, 5) + '-' + value.slice(5);
    }

    e.target.value = formatted;
}

</script>

<jsp:include page="../footer.jsp" />


