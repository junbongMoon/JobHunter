<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script
	src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script
	src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>

<main class="main">
	<!-- Contact Section -->
	<div>마이페이지</div>
	<!-- /Contact Section -->

	<!-- 인증 대상 -->
	<input type="hidden" id="authMobile" /> <input type="hidden"
		id="phoneCode" /> <input type="hidden" id="authEmail" /> <input
		type="hidden" id="emailCode" /> <input type="hidden" id="uid"
		value="${sessionScope.account.uid}" />

	<div>
		비밀번호 변경
		<button>변경</button>
	</div>

	<div>
		<div>
			<!--변경 누르면 모달창으로 나옴-->
			<input type="text" id="nowPassword" placeholder="현재 비밀번호">
			<button id="passwordBtn" type="button">확인</button>
		</div>

		<div>
			<!--비번확인 성공하면 모달창에 대신 띄움-->
			<div>
				<!--전화/이메일 선택하는 버튼 만들고 이거 나옴-->
		<button type="button" id="startMobileVerifiBtn">전화로 인증</button>
				<input type="text" id="pwdToPhoneCode" placeholder="인증번호">
				<button type="button" id="endVerifiPwdToPhoneBtn">인증</button>
	</div>
			<div>
				<!--전화/이메일 선택하는 버튼 만들고 이거 나옴-->
		<button type="button" id="startEmailVerifiBtn">이메일로 인증</button>
				<input type="text" id="pwdToEmailCode" placeholder="인증번호">
				<button type="button" id="endVerifiPwdToEmailBtn">인증</button>
	</div>
	</div>

		<span id="changePwdTap" style="display: none;"> <!--전화/이메일 인증 성공하면 이거 모달창에 대신 띄움-->
			<input type="text" id="changePassword" placeholder="바꿀 비밀번호">
			<input type="text" id="checkPassword" placeholder="비밀번호 확인">
			<button type="button" onclick="changePassword()">변경</button> <!--변경 성공하면 모달창 지움-->
		</span>
	</div>

	<div>
		<div id="Mobile">
			<div id="nowMobile">기존 전화번호</div>
			<button>전화번호 바꾸기</button>
		</div>
		<!--바꾸기누르면 숨겨짐 인증끝나면 다시 나옴-->
		<div id="startPhoneVerifiTap">
			<!--바꾸기누르면 나오고 인증번호 발송하면 숨겨짐-->
			<input type="text" id="changeMobile" placeholder="바꿀 번호">
			<button type="button" id="changeMobileStartVerifiBtn">인증번호
				발송</button>
		</div>
		<div id="endPhoneVerifiTap">
			<!--인증번호 발송하면 나오고 인증하면 숨겨짐-->
			<input type="text" id="pneToPhoneCode" placeholder="인증번호">
			<button type="button" id="changeMobileEndVerifiBtn">인증</button>
		</div>
	</div>

	<div>
		<div id="Email">
			<div id="nowEmail">기존 이메일</div>
			<button>이메일 바꾸기</button>
	</div>
		<!--바꾸기누르면 숨겨짐 인증끝나면 다시 나옴-->
		<div id="startEmailVerifiTap">
			<!--바꾸기누르면 나오고 인증번호 발송하면 숨겨짐-->
			<input type="text" id="changeEmail" placeholder="바꿀 이메일">
			<button type="button" id="changeEmailStartVerifiBtn">인증번호 발송</button>
		</div>
		<div id="endEmailVerifiTap">
			<!--인증번호 발송하면 나오고 인증하면 숨겨짐-->
			<input type="text" id="pneToEmailCode" placeholder="인증번호">
			<button type="button" id="changeEmailEndVerifiBtn">인증</button>
	</div>
	</div>

	<!-- firebase캡챠 -->
	<div id="recaptcha-container"></div>
</main>

<script>

const METHOD = {
EMAIL: "email",
PHONE: "phone"
};
//국제번호로 변환 (Firebase 용)
function formatPhoneNumberForFirebase(koreanNumber) {
	const cleaned = koreanNumber.replace(/-/g, '');
	return cleaned.startsWith('0') ? '+82' + cleaned.substring(1) : cleaned;
}
//국제번호를 한국 형식으로 되돌림 (서버 전송용)
function formatToKoreanPhoneNumber(internationalNumber) {
	return internationalNumber.startsWith("+82")
 		? internationalNumber.replace("+82", "0").replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3")
 		: internationalNumber;
}

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
	if (window.recaptchaVerifier) {
 		window.recaptchaVerifier.clear();
        delete window.recaptchaVerifier;
	}
	window.recaptchaVerifier = new RecaptchaVerifier(auth, 'recaptcha-container', {
    	size: 'invisible',
    	callback: () => {}
	});
}

$(()=>{
	getInfo()

	$(document).on('click', '#passwordBtn', ()=>{
		checkPassword();
	});
	
	$(document).on('click', '#startMobileVerifiBtn', ()=>{
		startVerifi(`phone`,`pwd`)
	});
	$(document).on('click', '#startEmailVerifiBtn', ()=>{
		startVerifi(`email`,`pwd`)
	});
	$(document).on('click', '#endVerifiPwdToPhoneBtn', ()=>{
		endVerifiPwdMobile()
	});
	$(document).on('click', '#endVerifiPwdToEmailBtn', ()=>{
		endVerifiPwdEmail()
	});
	$(document).on('click', '#changeMobileStartVerifiBtn', ()=>{
		startVerifi(`phone`,`pne`)
	});
	$(document).on('click', '#changeEmailStartVerifiBtn', ()=>{
		startVerifi(`email`,`pne`)
	});
	$(document).on('click', '#changeMobileEndVerifiBtn', ()=>{
		endVerifiPneMobile()
	});
	$(document).on('click', '#changeEmailEndVerifiBtn', ()=>{
		endVerifiPneEmail()
	});
})

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
		// 비밀번호 변경 2차 인증(전화, 이메일)창 띄우기기
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

async function startVerifi(type, method) {

	if (type === 'phone') {
        const rawPhone = 
			method === 'pne'
            ? document.getElementById('changeMobile').value
            : "${sessionScope.account.mobile}";

        document.getElementById('authMobile').value = rawPhone;

        // firebase 국제번호형식으로 받아서 바꾸는용도
        const phoneNumber = formatPhoneNumberForFirebase(rawPhone);

        firebaseCaptcha()
 		try {
     		confirmationResult = await signInWithPhoneNumber(auth, phoneNumber, window.recaptchaVerifier);
     		alert("인증 코드가 전송되었습니다.");
 		} catch (error) {
     		console.error("전화번호 인증 실패:", error);
     		alert("문자 전송에 실패했습니다다");
 		}

    } else if (type === 'email') {
        const email = 
			method === 'pne'
            ? document.getElementById('changeEmail').value
            : "${sessionScope.account.email}";

        document.getElementById('authEmail').value = authTargetEmail;

        $.ajax({
     		url: "/account/auth/email",
     		method: "POST",
	 		contentType: "application/json",
 	 		data: JSON.stringify({email}),
	 		async: false,
     		success: (res) => {alert("메일 전송 성공: " + res)},
     		error: (xhr) => {alert("메일 전송 중 오류 발생: " + xhr.responseText)}
 		});

    }

}

async function endVerifiPwdMobile() {
    const mobileCode = document.getElementById('pwdToPhoneCode').value
    document.getElementById('phoneCode').value = mobileCode;

	try {
   		await confirmationResult.confirm(mobileCode);
   		viewChangePassword(); // 성공 후 콜백 실행
 	} catch (error) {
   		console.error("코드 인증 실패:", error);
   		alert("잘못된 인증 코드입니다.");
 	}
}
async function endVerifiPwdEmail() {
	const email = document.getElementById("authEmail").value;
	const emailCode = document.getElementById('pwdToEmailCode').value
    document.getElementById('emailCode').value = emailCode;

	$.ajax({
    	url: `/account/auth/email/${emailCode}`,
    	method: "POST",
    	contentType: "application/json",
    	data: JSON.stringify({ email: email }),
    	async: false,
    	success: () => {viewChangePassword()},
    	error: (xhr) =>{alert("이메일 인증 실패: " + xhr.responseText)}
    });
}
async function endVerifiPneMobile() {

        const mobileCode = document.getElementById('pneToPhoneCode').value
        document.getElementById('phoneCode').value = mobileCode;

		try {
   			await confirmationResult.confirm(mobileCode);
   			const uid = document.getElementById("uid").value;
			const intlPhone = document.getElementById("authMobile").value;
			const value = formatToKoreanPhoneNumber(intlPhone);

			const dto = {
				type: "mobile",
				value,
				uid
			};

			$.ajax({
				url: "/user/contact",
				method: "patch",
				contentType: "application/json",
				data: JSON.stringify(dto),
				success: (val) => {
				applyChange(val, METHOD.PHONE);
				},
				error: (xhr) => {
				alert("인증 처리 중 오류가 발생했습니다.");
				console.error(xhr.responseText);
				}
			});
 		} catch (error) {
   			console.error("코드 인증 실패:", error);
   			alert("잘못된 인증 코드입니다.");
 		}

}
async function endVerifiPneEmail() {
		const email = document.getElementById("authEmail").value;

        const emailCode = document.getElementById('pneToEmailCode').value
        document.getElementById('emailCode').value = emailCode;

		$.ajax({
    		url: `/account/auth/email/${emailCode}`,
    		method: "POST",
    		contentType: "application/json",
    		data: JSON.stringify({ email: email }),
    		async: false,
    		success: () => {
					const uid = document.getElementById("uid").value;

					let value = email;

					const dto = {
						type: "email",
						value,
						uid
					};

					$.ajax({
						url: "/user/contact",
						method: "patch",
						contentType: "application/json",
						data: JSON.stringify(dto),
						success: (val) => {
						applyChange(val, METHOD.EMAIL);
						},
						error: (xhr) => {
						alert("인증 처리 중 오류가 발생했습니다.");
						console.error(xhr.responseText);
						}
					});
				},
				error: (xhr) =>{alert("이메일 인증 실패: " + xhr.responseText)}
			});
    
}

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

function viewChangePassword() {
	document.getElementById("changePwdTap").style.display = "block";
}

</script>

<!-- 풋터 -->
<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>