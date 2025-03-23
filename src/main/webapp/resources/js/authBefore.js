import {
  getSelectedMethod,
  formatToKoreanPhoneNumber,
  METHOD
} from "/resources/js/authVerification.js";

// 로그인 페이지 전용: 인증 성공 후 정지 해제 + 리다이렉트
window.onVerificationSuccess = () => {

  const method = getSelectedMethod();
  const userType = document.getElementById("userType").value;
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
    userType
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
