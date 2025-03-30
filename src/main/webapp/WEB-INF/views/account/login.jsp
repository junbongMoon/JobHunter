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
    margin: -40px -60px 30px;  /* 상단 여백을 없애고 컨테이너 끝까지 확장 */
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
</style>

<main class="main">
	<div class="login-container">
		<form action="${pageContext.request.contextPath}/account/login" method="post">
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
				<input type="text" name="id" placeholder="아이디" required /> <input
					type="password" name="password" placeholder="비밀번호" required />
			</div>

			<!-- 인증 필요 시 -->
			<c:if test="${sessionScope.requiresVerification}">

				<!-- 인증 대상 -->
				<input type="hidden" id="authMobile"
					value="${sessionScope.authTargetMobile}" />
				<input type="hidden" id="authEmail"
					value="${sessionScope.authTargetEmail}" />
				<input type="hidden" id="accountType"
					value="${sessionScope.account.accountType}" />
				<input type="hidden" id="method" />

				<div class="form-group">
					<div class="verification-options">
						<label> <input type="radio" name="method" value="email"
							checked /> 이메일 인증
						</label> <label> <input type="radio" name="method" value="phone" />
							전화번호 인증
						</label>
						
						<div class="verification-group">
							<input type="text" id="emailCode" name="emailCode" placeholder="이메일인증코드 입력" />
							<button type="button" id="emailSendBtn" class="btn-confirm">이메일전송</button>
							<button type="button" id="emailVerifyBtn" class="btn-confirm">이메일인증</button>
						</div>

						<div class="verification-group">
							<input type="text" id="phoneCode" name="phoneCode" placeholder="문자인증코드 입력" />
							<button type="button" id="phoneSendBtn" class="btn-confirm">문자전송</button>
							<button type="button" id="phoneVerifyBtn" class="btn-confirm">문자인증</button>
						</div>
					</div>
				</div>
			</c:if>

			<button type="submit" class="btn-confirm" style="width: 100%; margin-top: 20px;">로그인</button>
		</form>
	</div>
	<!-- 파이어베이스 캡챠 넣을곳 -->
	<div id="recaptcha-container"></div>
</main>

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

// 이메일 인증 코드 전송
async function sendEmailVerification(email) {
    
    $.ajax({
        url: "/account/auth/email",
        method: "POST",
  		contentType: "application/json",
    data: JSON.stringify({ email }),
        success: (res) => alert(res),
        error: (xhr) => alert("메일 전송 중 오류 발생: " + xhr.responseText)
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
async function sendPhoneVerification(phoneNumber) {
    // firebase에서 해줌
    firebaseCaptcha() 

    try {
    	confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
        alert("인증 코드가 전송되었습니다.");
    } catch (error) {
        console.error("전화번호 인증 실패:", error);
        alert("전화번호 인증 중 오류 발생.");
    }
}

// 인증 코드 확인(성공하면 onVerificationSuccess 호출)
async function verifyCode(method) {

  if (method === METHOD.PHONE) {
    const code = document.getElementById("phoneCode").value;
    verifyPhoneCode(code)
  } else {
    const code = document.getElementById("emailCode").value;
    verifyEmailCode(code)
  }
}

async function verifyPhoneCode(code) {
    try {
      await confirmationResult.confirm(code);
      onVerificationSuccess(METHOD.PHONE); // 성공 후 콜백 실행
    } catch (error) {
      console.error("코드 인증 실패:", error);
      alert("잘못된 인증 코드입니다.");
    }
}

async function verifyEmailCode(code) {

    const email = document.getElementById("authEmail").value;
    $.ajax({
      url: `/account/auth/email/${code}`,
      method: "POST",
  	  contentType: "application/json",
      data: JSON.stringify({
      email: email
  }),
      success: () => onVerificationSuccess(METHOD.EMAIL),
      error: (xhr) => alert("이메일 인증 실패: " + xhr.responseText)
    });
}



//로그인 페이지 전용: 인증 성공 후 정지 해제 + 리다이렉트
function onVerificationSuccess (method) {

const accountType = document.getElementById("accountType").value;

let value;

if (method === METHOD.PHONE) {
 const intlPhone = document.getElementById("authMobile").value;
 value = formatToKoreanPhoneNumber(intlPhone);
} else {
 value = document.getElementById("authEmail").value;
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
   alert("인증이 완료되었습니다.");
   window.location.href = redirectUrl || "/";
 },
 error: (xhr) => {
   alert("인증 처리 중 오류가 발생했습니다.");
   console.error(xhr.responseText);
 }
});
};

//DOM 로딩 후 버튼 이벤트 연결
window.onload=()=>{
  document.getElementById("emailSendBtn")?.addEventListener("click", () => {
    sendEmailVerification(document.getElementById("authEmail").value);
  });

  document.getElementById("phoneSendBtn")?.addEventListener("click", () => {
    const rawPhone = document.getElementById("authMobile").value;
    const phoneNumber = formatPhoneNumberForFirebase(rawPhone);
    sendPhoneVerification(phoneNumber);
  });

  document.getElementById("emailVerifyBtn")?.addEventListener("click", () => {
    const code = document.getElementById("emailCode").value;
    verifyEmailCode(code);
  });

  document.getElementById("phoneVerifyBtn")?.addEventListener("click", () => {
    const code = document.getElementById("phoneCode").value;
    verifyPhoneCode(code);
  });
}
	
// 탭 전환 효과를 위한 스크립트
document.addEventListener('DOMContentLoaded', function() {
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


