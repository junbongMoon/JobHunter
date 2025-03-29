<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 헤더 -->
<jsp:include page="../header.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>


<main>
	<h2>로그인</h2>

	<form action="${pageContext.request.contextPath}/account/login"
		method="post">
		<!-- ID / PW -->
		<input type="text" name="id" placeholder="아이디" required /> <input
			type="password" name="password" placeholder="비밀번호" required />


		<!-- 회원 유형 선택 -->
		<div style="margin: 10px 0;">
			<label> <input type="radio" name="accountType" value="USER"
				checked> 개인 회원
			</label> <label> <input type="radio" name="accountType"
				value="COMPANY"> 기업 회원
			</label>
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

			<div>
				<label> <input type="radio" name="method" value="email"
					checked /> 이메일 인증
				</label> <label> <input type="radio" name="method" value="phone" />
					전화번호 인증
				</label>
				
				<button type="button" id="emailSendBtn">이메일전송</button>
				<input type="text" id="emailCode" name="emailCode" placeholder="이메일인증코드 입력" />
				<button type="button" id="emailVerifyBtn">이메일인증</button>

				<button type="button" id="phoneSendBtn">문자전송</button>
				<input type="text" id="phoneCode" name="phoneCode" placeholder="문자인증코드 입력" />
				<button type="button" id="phoneVerifyBtn">문자인증</button>
			</div>
		</c:if>


		<button type="submit">로그인</button>
	</form>
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
    // firebase에서 해줌
    if (window.recaptchaVerifier) {
      window.recaptchaVerifier.clear(); // 기존 캡차 해제
      delete window.recaptchaVerifier;
    }
    // 캡챠기능 파이어베이스 기본 제공
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
	
</script>

<jsp:include page="../footer.jsp" />


