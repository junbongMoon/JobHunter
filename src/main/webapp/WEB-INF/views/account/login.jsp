<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 헤더 -->
<jsp:include page="../header.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>

<style>
  .main {
    padding: 60px 20px;
    background: #f8f9fa;
    min-height: calc(100vh - 200px);
  }

  .login-container {
    padding: 40px 60px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
    max-width: 600px;
    margin: 0 auto;
  }

  .login-title {
    font-size: 24px;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 30px;
    padding-bottom: 15px;
    border-bottom: 1px solid #eee;
  }

  .form-group {
    margin-bottom: 20px;
  }

  .form-group input[type="text"],
  .form-group input[type="password"] {
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
  @media (max-width: 768px) {
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

  .social-login {
    margin-top: 20px;
  }

  .btn-kakao {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    width: 100%;
    padding: 12px;
    border: none;
    border-radius: 8px;
    background: #FEE500;
    color: #000000;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s ease;
  }

  .btn-kakao:hover {
    background: #FDD835;
  }

  .btn-kakao img {
    width: 20px;
    height: 20px;
  }

  @media (max-width: 768px) {
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
</style>

<main class="main">
	<div class="login-container">
		<form action="${pageContext.request.contextPath}/account/login" method="post">
			<c:choose>
				<c:when test="${sessionScope.requiresVerification}">
					<!-- 인증 방법 선택 -->
					<div class="verification-methods">
						<h2 class="login-title">인증 방법 선택</h2>
						<div class="method-buttons">
							<button type="button" class="btn-method active" data-method="email">
								이메일 인증
							</button>
							<button type="button" class="btn-method" data-method="phone">
								전화번호 인증
							</button>
						</div>
					</div>

					<!-- 이메일 인증 컨텐츠 -->
					<div id="emailContent" class="verification-content">

						<div id="emailVerificationContent">
							<div class="target-info">
								인증 이메일 주소: <strong>${sessionScope.account.email}</strong>
							</div>
							<div id="emailSendSection" class="verification-step">
								<button type="button" id="emailSendBtn" class="btn-confirm full-width">인증 메일 발송</button>
							</div>
						</div>

						<div id="emailVerifySection" class="verification-step" style="display: none;">
							<input type="text" id="emailCode" name="emailCode" placeholder="인증번호 입력" />
							<button type="button" id="emailVerifyBtn" class="btn-confirm full-width">인증 완료</button>
						</div>
					</div>

					<!-- 전화번호 인증 컨텐츠 -->
					<div id="phoneContent" class="verification-content" style="display: none;">

						<div id="phoneVerificationContent">
							<div class="target-info">
								인증 전화번호: <strong>${sessionScope.account.mobile}</strong>
							</div>
							<div id="phoneSendSection" class="verification-step">
								<button type="button" id="phoneSendBtn" class="btn-confirm full-width">인증번호 발송</button>
							</div>
						</div>

						<div id="phoneVerifySection" class="verification-step" style="display: none;">
							<input type="text" id="phoneCode" name="phoneCode" placeholder="인증번호 입력" />
							<button type="button" id="phoneVerifyBtn" class="btn-confirm full-width">인증 완료</button>
						</div>

					</div>

					<input type="hidden" id="method" name="method" value="email" />
					<input type="hidden" id="accountType" value="${sessionScope.account.accountType}" />
				</c:when>
				<c:otherwise>
					<!-- 일반 로그인 시 보여줄 탭 -->
					<div class="account-type-tabs">
						<label class="account-type-tab active">
							<input type="radio" name="accountType" value="USER" checked>
							개인 회원
						</label>
						<label class="account-type-tab">
							<input type="radio" name="accountType" value="COMPANY">
							기업 회원
			        </label>
		      </div>

					<h2 class="login-title">로그인 정보 입력</h2>
					<div class="form-group">
						<input type="text" name="id" placeholder="아이디" required />
						<input type="password" name="password" placeholder="비밀번호" required />
						<c:if test="${sessionScope.remainingSeconds != null && sessionScope.remainingSeconds >= 0}">
							<p class="login-failed-massege">
								5회 이상 로그인에 실패하셨습니다. ${sessionScope.remainingSeconds}초 후에 다시 시도해 주세요
							</p>
						</c:if>
					</div>

					<div class="login-options">
						<div class="auto-login">
							<input type="checkbox" id="autoLogin" name="autoLogin">
							<label for="autoLogin">자동 로그인</label>
						</div>
            
						<div class="find-account">
							<a href="/account/find/id">아이디 찾기</a>
							<span class="divider">|</span>
							<a href="/account/find/password">비밀번호 찾기</a>
						</div>
					</div>
					
          <button type="submit" class="btn-confirm full-width">로그인</button>

					<div class="social-login">
						<button type="button" class="btn-kakao" onclick="kakao()">
							<img src="#" alt="kakao">
							카카오 로그인
						</button>
			    	</div>
				</c:otherwise>
			</c:choose>
	</form>
	</div>
	<!-- 파이어베이스 캡챠 넣을곳 -->
	<div id="recaptcha-container"></div>
</main>

<!-- 알럿 모달 추가 -->
<div id="alertModalOverlay" class="alert-modal-overlay" style="display: none;"></div>
<div id="alertModal" class="alert-modal-box" style="display: none;">
  <div class="alert-modal-content">
    <div class="alert-modal-message"></div>
    <div class="alert-modal-buttons"></div>
  </div>
</div>

<script>
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
  if (autoLogin == "on") {
	  const tabs = document.querySelectorAll('#autoLogin');
    if (tabs) {
      tabs.checked = true; // 체크 상태로 만들기
    }
  }
});
</script>

<jsp:include page="../footer.jsp" />


