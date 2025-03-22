<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="../header.jsp" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<main>
	<h2>로그인</h2>

	<form action="${pageContext.request.contextPath}/account/login"
		method="post">
		<!-- ID / PW -->
		<input type="text" name="id" placeholder="아이디" required /> <input
			type="password" name="password" placeholder="비밀번호" required />

		<!-- 회원 유형 선택 or hidden -->
		<input type="hidden" name="userType" value="NORMAL" />
		<%-- 기업 로그인이라면 COMPANY 로 바꾸면 됨 --%>
		<div>${sessionScope.requiresVerification}</div>

		<!-- 인증 필요 시 -->
		<c:if test="${sessionScope.requiresVerification}">

			<!-- 인증 대상 -->
			<input type="hidden" id="authMobile"
				value="${sessionScope.authTargetMobile}" />
			<input type="hidden" id="authEmail"
				value="${sessionScope.authTargetEmail}" />
			<input type="hidden" id="userType"
				value="${sessionScope.user.userType}" />

			<div>
				<label> <input type="radio" name="method" value="email"
					checked /> 이메일 인증
				</label> <label> <input type="radio" name="method" value="phone" />
					전화번호 인증
				</label>

				<button type="button" onclick="sendVerification()">인증 코드 전송</button>
				<input type="text" id="code" name="code" placeholder="인증코드 입력" />
				<button type="button" onclick="verifyCode()">인증 확인</button>
			</div>
		</c:if>


		<button type="submit">로그인</button>
	</form>

	<div id="recaptcha-container"></div>
</main>

<jsp:include page="../footer.jsp" />

<!-- Firebase 인증 및 이메일 fetch 통합 -->
<script type="module">
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

    // 📞 국제번호로 변환 (Firebase 용)
    function formatPhoneNumberForFirebase(koreanNumber) {
        const cleaned = koreanNumber.replace(/-/g, '');
        if (cleaned.startsWith('0')) {
            return '+82' + cleaned.substring(1);
        }
        return cleaned;
    }

    // 📞 국제번호를 한국 형식으로 되돌림 (서버 전송용)
    function formatToKoreanPhoneNumber(internationalNumber) {
        if (internationalNumber.startsWith("+82")) {
            const withoutCountryCode = internationalNumber.replace("+82", "0");
            return withoutCountryCode.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
        }
        return internationalNumber;
    }

    // 🔐 인증 코드 전송
    window.sendVerification = async () => {
        const method = document.querySelector('input[name="method"]:checked').value;

        if (method === "phone") {
            const rawPhoneNumber = document.getElementById("authMobile").value;
            const phoneNumber = formatPhoneNumberForFirebase(rawPhoneNumber);

            // Invisible reCAPTCHA
            window.recaptchaVerifier = new RecaptchaVerifier(auth, 'recaptcha-container', {
                size: 'invisible',
                callback: (response) => {}
            });

            try {
                confirmationResult = await signInWithPhoneNumber(auth, phoneNumber, window.recaptchaVerifier);
                alert("인증 코드가 전송되었습니다.");
                console.log("Firebase confirmationResult:", confirmationResult);
            } catch (error) {
                console.error("전화번호 인증 실패:", error);
                alert("전화번호 인증 중 오류 발생.");
            }
        } else {
            alert("이메일 인증은 준비 중입니다.");
        }
    };

    // ✅ 인증 코드 확인 후 서버에 인증 완료 통보 (Ajax)
    window.verifyCode = async () => {
        const method = document.querySelector('input[name="method"]:checked').value;

        if (method === "phone") {
            const code = document.getElementById("code").value;

            try {
                const result = await confirmationResult.confirm(code);
                console.log("전화번호 인증 성공:", result);
                sendVerificationSuccess(); // Ajax 전송
            } catch (error) {
                console.error("코드 인증 실패:", error);
                alert("잘못된 인증 코드입니다.");
            }
        } else {
            alert("이메일 인증은 준비 중입니다.");
        }
    };

    // 🔁 서버에 인증 완료 상태 전송 (Ajax)
    function sendVerificationSuccess() {
        const method = document.querySelector('input[name="method"]:checked').value;
        const userType = document.getElementById("userType").value;
        let value;

        if (method === "phone") {
            const intlPhone = document.getElementById("authMobile").value;
            value = formatToKoreanPhoneNumber(intlPhone);
        } else {
            value = document.getElementById("authEmail").value;
        }

        const dto = {
            type: method === "phone" ? "mobile" : "email",
            value: value,
            userType: userType
        };

        $.ajax({
            url: "/account/verify",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify(dto),
            success: function (redirectUrl) {
                alert("인증이 완료되었습니다.");
                window.location.href = redirectUrl || "/";
            },
            error: function (xhr) {
                alert("인증 처리 중 오류가 발생했습니다.");
                console.error(xhr.responseText);
            }
        });
    }
</script>

