import {
  formatToKoreanPhoneNumber,
  METHOD
} from "/resources/js/authVerification.js";

// 인증 성공 후 인증했던 이메일/전화번호 변경
window.onVerificationSuccess = (method, actionType) => {

  if (actionType === 'changePwd') {
    viewChangePassword();
  } else {

    const uid = document.getElementById("uid").value;

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
      uid
    };
  
    $.ajax({
      url: "/company/contact",
      method: "patch",
      contentType: "application/json",
      data: JSON.stringify(dto),
      success: (val) => {
        applyChange(val, method);
      },
      error: (xhr) => {
        alert("인증 처리 중 오류가 발생했습니다.");
        console.error(xhr.responseText);
      }
    });
  }

};

function applyChange(val, method) {
  if (method === METHOD.PHONE) {
    alert("전화번호가 변경되었습니다.");
    document.getElementById("nowMobile").innerText = `${val}`;
    document.getElementById("changeMobile").value = "";
    document.getElementById("pneToPhoneCode").value = "";
  } else {
    alert("이메일이 변경되었습니다.");
    document.getElementById("nowEmail").innerText = `${val}`;
    document.getElementById("changeEmail").value = "";
    document.getElementById("pneToEmailCode").value = "";
  }
}


