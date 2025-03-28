<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>

<main class="main">
	<!-- Contact Section -->
	<div>마이페이지</div>
	<!-- /Contact Section -->

	<!-- 인증 대상 -->
	<input type="hidden" id="authMobile" />
	<input type="hidden" id="phoneCode" />
	<input type="hidden" id="authEmail" />
	<input type="hidden" id="emailCode" />
	<input type="hidden" id="uid" value="${sessionScope.account.uid}" />

	<div>비밀번호 변경
		<button>변경</button>
	</div>

	<div>
		<div><!--변경 누르면 모달창으로 나옴-->
		<input type="text" id="nowPassword" placeholder="현재 비밀번호"><button type="button" onclick="checkPassword()">확인</button>
		</div>

		<div><!--비번확인 성공하면 모달창에 대신 띄움-->
			<div><!--전화/이메일 선택하는 버튼 만들고 이거 나옴-->
		<button type="button" onclick="startVerifi(`phone`,`pwd`)">전화로 인증</button>
		<input type="text" id="pwdToPhoneCode" placeholder="인증번호"><button type="button" onclick="endVerifi(`phone`, `pwd`)">인증</button>
	</div>
	<div><!--전화/이메일 선택하는 버튼 만들고 이거 나옴-->
		<button type="button" onclick="startVerifi(`email`,`pwd`)">이메일로 인증</button>
		<input type="text" id="pwdToEmailCode" placeholder="인증번호"><button type="button" onclick="endVerifi(`email`, `pwd`)">인증</button>
	</div>
	</div>

		<span id="changePwdTap" style="display:none;"><!--전화/이메일 인증 성공하면 이거 모달창에 대신 띄움-->
			<input type="text" id="changePassword" placeholder="바꿀 비밀번호">
			<input type="text" id="checkPassword" placeholder="비밀번호 확인">
			<button type="button" onclick="changePassword()">변경</button><!--변경 성공하면 모달창 지움-->
		</span></div>

	<div>
		<div id="Mobile"><div id="nowMobile">기존 전화번호 </div> <button>전화번호 바꾸기</button></div><!--바꾸기누르면 숨겨짐 인증끝나면 다시 나옴-->
		<div id="startPhoneVerifiTap"><!--바꾸기누르면 나오고 인증번호 발송하면 숨겨짐-->
			<input type="text" id="changeMobile" placeholder="바꿀 번호"><button type="button" onclick="startVerifi(`phone`,`pne`)">인증번호 발송</button>
		</div>
		<div id="endPhoneVerifiTap"><!--인증번호 발송하면 나오고 인증하면 숨겨짐-->
			<input type="text" id="pneToPhoneCode" placeholder="인증번호"><button type="button" onclick="endVerifi(`phone`,`pne`)">인증</button>
		</div>
	</div>

	<div>
		<div id="Email"><div id="nowEmail">기존 이메일 </div> <button>이메일 바꾸기</button></div><!--바꾸기누르면 숨겨짐 인증끝나면 다시 나옴-->
		<div id="startEmailVerifiTap"><!--바꾸기누르면 나오고 인증번호 발송하면 숨겨짐-->
		<input type="text" id="changeEmail" placeholder="바꿀 이메일"><button type="button" onclick="startVerifi(`email`,`pne`)">인증번호 발송</button>
	</div>
	<div id="endEmailVerifiTap"><!--인증번호 발송하면 나오고 인증하면 숨겨짐-->
		<input type="text" id="pneToEmailCode" placeholder="인증번호"><button type="button" onclick="endVerifi(`email`,`pne`)">인증</button>
	</div>
	</div>

	<!-- firebase캡챠 -->
	<div id="recaptcha-container"></div>
</main>
<!-- 풋터 -->

<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>

<script>

window.onload=()=>{
	getInfo()
}

function getInfo() {
	$.ajax({
	    url: "/user/info/${sessionScope.account.uid}",
	    method: "GET",
	    success: (result) => {
	        console.log(result); // 전체 JSON 출력
	    },
	    error: (xhr) => alert("실패")
	});
}

function checkPassword() {
	uid = document.getElementById('uid').value
	nowPassword = document.getElementById('nowPassword').value

	$.ajax({
  url: "/user/password",
  method: "POST",
  contentType: "application/json",
  data: JSON.stringify({ uid, password: nowPassword }),
  success: (result) => {
    if (result === true) {
      alert("비밀번호 확인 완료. 인증을 진행해주세요.");
    } else {
      alert("비밀번호가 틀렸습니다.");
    }
  },
  error: (xhr) => {
    alert("비밀번호 확인 중 오류 발생");
  }
});

	
}

function startVerifi(type, method) {

	if (type === 'phone') {
        const authTargetMobile = method === 'pne'
            ? document.getElementById('changeMobile').value
            : "${sessionScope.account.mobile}";
        document.getElementById('authMobile').value = authTargetMobile;
    } else if (type === 'email') {
        const authTargetEmail = method === 'pne'
            ? document.getElementById('changeEmail').value
            : "${sessionScope.account.email}";
        document.getElementById('authEmail').value = authTargetEmail;
    }

	sendVerification(type);
}

function endVerifi(type, method) {
	if (type === 'phone') {
        const mobileCode = method === 'pne'
		?document.getElementById('pneToPhoneCode').value
		:document.getElementById('pwdToPhoneCode').value
        document.getElementById('phoneCode').value = mobileCode;
    } else if (type === 'email') {
        const emailCode = method === 'pne'
		?document.getElementById('pneToEmailCode').value
		:document.getElementById('pwdToEmailCode').value
        document.getElementById('emailCode').value = emailCode;
    }

	if (method === 'pne') {
		verifyCode(type, `changePnE`);
	} else {
		verifyCode(type, `changePwd`);
	}
}

function viewChangePassword() {
	document.getElementById("changePwdTap").style.display = "block";
}

function changePassword() {
	const changePassword =document.getElementById('changePassword').value
	const checkPassword = document.getElementById('checkPassword').value
	if (changePassword !== checkPassword) {
    alert("비밀번호가 일치하지 않습니다.");
    return;
  }

  const uid = document.getElementById('uid').value;

  $.ajax({
    url: "/user/password",
    method: "patch",
    contentType: "application/json",
    data: JSON.stringify({ uid, password: changePassword }),
    success: () => {
      alert("비밀번호가 성공적으로 변경되었습니다.");
      // 입력 필드 초기화
      document.getElementById('changePassword').value = "";
      document.getElementById('checkPassword').value = "";
      document.getElementById('nowPassword').value = "";
      document.getElementById('changePwdTap').style.display = "none";
    },
    error: (xhr) => {
      alert("비밀번호 변경 중 오류가 발생했습니다.");
      console.error(xhr.responseText);
    }
  });
}


</script>

<script>
//이메일/전화번호 인증 모듈

//필요한거
//document.getElementById("authMobile").value;
//document.getElementById("authEmail").value;
//document.getElementById("phoneCode").value;
//document.getElementById("emailCode").value;

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

//JS에서 enum타입처럼 쓰는거
export const METHOD = {
EMAIL: "email",
PHONE: "phone"
};

//국제번호로 변환 (Firebase 용)
export function formatPhoneNumberForFirebase(koreanNumber) {
const cleaned = koreanNumber.replace(/-/g, '');
return cleaned.startsWith('0') ? '+82' + cleaned.substring(1) : cleaned;
}

//국제번호를 한국 형식으로 되돌림 (서버 전송용)
export function formatToKoreanPhoneNumber(internationalNumber) {
return internationalNumber.startsWith("+82")
 ? internationalNumber.replace("+82", "0").replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3")
 : internationalNumber;
}

//인증 코드 전송
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

//이메일 인증 코드 전송
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

function resetRecaptcha() {
if (window.recaptchaVerifier) {
 window.recaptchaVerifier.clear(); // 기존 캡차 해제
 delete window.recaptchaVerifier;
}
}
//전화번호 인증 코드 전송
async function sendPhoneVerification(phoneNumber) {
//firebase에서 해줌
resetRecaptcha();
//캡챠기능 파이어베이스 기본 제공
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

//인증 코드 확인(성공하면 onVerificationSuccess 호출)
export async function verifyCode(method, actionType) {

if (method === METHOD.PHONE) {
 const code = document.getElementById("phoneCode").value;
 verifyPhoneCode(code, actionType)
} else {
 const code = document.getElementById("emailCode").value;
 verifyEmailCode(code, actionType)
}
}

async function verifyPhoneCode(code, actionType) {
 try {
   await confirmationResult.confirm(code);
   onVerificationSuccess(METHOD.PHONE, actionType); // 성공 후 콜백 실행
 } catch (error) {
   console.error("코드 인증 실패:", error);
   alert("잘못된 인증 코드입니다.");
 }
}

async function verifyEmailCode(code, actionType) {

 const email = document.getElementById("authEmail").value;
 $.ajax({
   url: `/account/auth/email/${code}`,
   method: "POST",
	  contentType: "application/json",
   data: JSON.stringify({
   email: email
}),
   success: () => onVerificationSuccess(METHOD.EMAIL, actionType),
   error: (xhr) => alert("이메일 인증 실패: " + xhr.responseText)
 });
}

</script>


<script>
	// 인증 성공 후 인증했던 이메일/전화번호 변경
	onVerificationSuccess = (method, actionType) => {

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
	      url: "/user/contact",
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
</script>