// 이메일/전화번호 인증 모듈

// 필요한거
// document.getElementById("authMobile").value;
// document.getElementById("authEmail").value;
// document.getElementById("phoneCode").value;
// document.getElementById("emailCode").value;

import { initializeApp } from "https://www.gstatic.com/firebasejs/11.5.0/firebase-app.js";
import { getAuth, RecaptchaVerifier, signInWithPhoneNumber } from "https://www.gstatic.com/firebasejs/11.5.0/firebase-auth.js";

const firebaseConfig = {
    apiKey: "AIzaSyDh4lq9q7JJMuDFTus-sehJvwyHhACKoyA",
    authDomain: "jobhunter-672dd.firebaseapp.com",
    projectId: "jobhunter-672dd",
    storageBucket: "jobhunter-672dd.appspot.com",
    messagingSenderId: "686284302067",
    appId: "1:686284302067:web:30c6bc60e91aeea963b986",
    measurementId: "G-RHVS9BGBQ7"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
let confirmationResult = null;

// JS에서 enum타입처럼 쓰는거
export const METHOD = {
  EMAIL: "email",
  PHONE: "phone"
};

// 국제번호로 변환 (Firebase 용)
export function formatPhoneNumberForFirebase(koreanNumber) {
  const cleaned = koreanNumber.replace(/-/g, '');
  return cleaned.startsWith('0') ? '+82' + cleaned.substring(1) : cleaned;
}

// 국제번호를 한국 형식으로 되돌림 (서버 전송용)
export function formatToKoreanPhoneNumber(internationalNumber) {
  return internationalNumber.startsWith("+82")
    ? internationalNumber.replace("+82", "0").replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3")
    : internationalNumber;
}

// 인증 코드 전송
export async function sendVerification(method) {
  // 고른 타입 체크해서 각각 실제 전송하는 메서드 호출
  if (method === METHOD.PHONE) {
    const rawPhone = document.getElementById("authMobile").value;
    // firebase 국제번호형식으로 받아서 바꾸는용도
    const phoneNumber = formatPhoneNumberForFirebase(rawPhone);
    await sendPhoneVerification(phoneNumber);
  } else {
    const email = document.getElementById("authEmail").value;
    await sendEmailVerification(email);
  }
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

// 전화번호 인증 코드 전송
async function sendPhoneVerification(phoneNumber) {
// firebase에서 해줌

// 캡챠기능 파이어베이스 기본 제공
if (!window.recaptchaVerifier) {
    window.recaptchaVerifier = new RecaptchaVerifier(auth, 'recaptcha-container', {
        size: 'invisible',
        callback: () => {}
    });
}

    try {
        confirmationResult = await signInWithPhoneNumber(auth, phoneNumber, window.recaptchaVerifier);
        alert("인증 코드가 전송되었습니다.");
    } catch (error) {
        console.error("전화번호 인증 실패:", error);
        alert("전화번호 인증 중 오류 발생.");
    }
}

// 인증 코드 확인(성공하면 onVerificationSuccess 호출)
export async function verifyCode(method, end) {

  if (method === METHOD.PHONE) {
    const code = document.getElementById("phoneCode").value;
    verifyPhoneCode(code, end)
  } else {
    const code = document.getElementById("emailCode").value;
    verifyEmailCode(code, end)
  }
}

async function verifyPhoneCode(code, end) {
    try {
      await confirmationResult.confirm(code);
      window.onVerificationSuccess(METHOD.PHONE, end); // 성공 후 콜백 실행
    } catch (error) {
      console.error("코드 인증 실패:", error);
      alert("잘못된 인증 코드입니다.");
    }
}

async function verifyEmailCode(code, end) {

    const email = document.getElementById("authEmail").value;
    $.ajax({
      url: `/account/auth/email/${code}`,
      method: "POST",
  	  contentType: "application/json",
      data: JSON.stringify({
      email: email
  }),
      success: () => window.onVerificationSuccess(METHOD.EMAIL, end),
      error: (xhr) => alert("이메일 인증 실패: " + xhr.responseText)
    });
}