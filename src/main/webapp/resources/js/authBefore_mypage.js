import { sendVerification, verifyCode } from '/resources/js/authVerification.js';

window.toggleEmailChange = () => {
  document.getElementById("emailChangeBox").style.display = 'block';
};

window.togglePhoneChange = () => {
  document.getElementById("phoneChangeBox").style.display = 'block';
};

window.sendVerificationEmail = () => {
  const email = document.getElementById('newEmail').value;
  if (!email) return alert("이메일을 입력하세요");
  sendVerification('email', email);
};

window.sendVerificationPhone = () => {
  const phone = document.getElementById('newPhone').value;
  if (!phone) return alert("전화번호를 입력하세요");
  sendVerification('phone', phone);
};

window.verifyEmailCode = async () => {
  const code = document.getElementById('emailCode').value;
  const email = document.getElementById('newEmail').value;
  const result = await verifyCode('email', code);

  if (result.success) {
    const res = await fetch('/account/updateEmail', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email })
    });
    const json = await res.json();
    alert(json.success ? '이메일이 변경되었습니다.' : '이메일 변경 실패: ' + json.message);
    if (json.success) location.reload();
  } else {
    alert('인증 실패');
  }
};

window.verifyPhoneCode = async () => {
  const code = document.getElementById('phoneCode').value;
  const phone = document.getElementById('newPhone').value;
  const result = await verifyCode('phone', code);

  if (result.success) {
    const res = await fetch('/account/updatePhone', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ phone })
    });
    const json = await res.json();
    alert(json.success ? '전화번호가 변경되었습니다.' : '전화번호 변경 실패: ' + json.message);
    if (json.success) location.reload();
  } else {
    alert('인증 실패');
  }
};
