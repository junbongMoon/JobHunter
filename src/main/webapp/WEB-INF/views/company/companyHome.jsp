<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
	    url: "/company/info/${sessionScope.account.uid}",
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
  url: "/company/password",
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
    url: "/company/password",
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
<script type="module">
  import { sendVerification, verifyCode } from '/resources/js/authVerification.js';

  window.sendVerification = sendVerification;
  window.verifyCode = verifyCode;
</script>

<!-- 인증 성공 처리하는 모듈 선택_여기 넣어둔건 이메일이나 번호로 정지해제 -->
<script type="module"
	src="${pageContext.request.contextPath}/resources/js/authBefore_companyHome.js"></script>