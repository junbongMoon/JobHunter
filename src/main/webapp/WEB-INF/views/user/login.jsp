<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- ✅ 헤더 포함 -->
<jsp:include page="../header.jsp" />

<main>
    <h2>로그인</h2>

    <form action="${pageContext.request.contextPath}/user/login" method="post">
        <input type="text" name="userId" placeholder="아이디 또는 전화번호" required />
        <input type="password" name="password" placeholder="비밀번호" required />

        <c:if test="${sessionScope.requiresVerification}">
            <div>
                <label><input type="radio" name="method" value="email" checked /> 이메일 인증</label>
                <label><input type="radio" name="method" value="phone" /> 전화번호 인증</label>

                <button type="button" onclick="sendVerification()">인증 코드 전송</button>
                <input type="text" id="code" name="code" placeholder="인증코드 입력" />
            </div>
        </c:if>

        <button type="submit">로그인</button>
    </form>

    <div id="recaptcha-container"></div>
</main>

<!-- ✅ 푸터 포함 -->
<jsp:include page="../footer.jsp" />

<!-- ✅ Firebase 인증 및 이메일 fetch 통합 -->
<script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/11.5.0/firebase-app.js";
    import { getAuth, RecaptchaVerifier, signInWithPhoneNumber } from "https://www.gstatic.com/firebasejs/11.5.0/firebase-auth.js";

    const firebaseConfig = {
        apiKey: "AIzaSyDh4lq9q7JJMuDFTus-sehJvwyHhACKoyA",
        authDomain: "jobhunter-672dd.firebaseapp.com",
        projectId: "jobhunter-672dd",
        storageBucket: "jobhunter-672dd.firebasestorage.app",
        messagingSenderId: "686284302067",
        appId: "1:686284302067:web:30c6bc60e91aeea963b986",
        measurementId: "G-RHVS9BGBQ7"
    };

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    let confirmationResult;

    window.sendVerification = function () {
        const method = document.querySelector('input[name="method"]:checked').value;
        const userId = document.querySelector('input[name="userId"]').value;

        if (method === 'phone') {
            const appVerifier = new RecaptchaVerifier('recaptcha-container', { size: 'invisible' }, auth);
            signInWithPhoneNumber(auth, userId, appVerifier)
                .then(result => {
                    confirmationResult = result;
                    alert("인증 코드 전송 완료");
                })
                .catch(error => alert("전송 실패: " + error.message));
        } else if (method === 'email') {
            fetch("/user/email-verify", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ email: userId })
            })
            .then(res => {
                if (res.ok) {
                    alert("이메일 인증 링크가 전송되었습니다.");
                } else {
                    alert("이메일 인증 전송 실패");
                }
            });
        }
    };

    window.verifyCode = function () {
        const code = document.getElementById('code').value;
        confirmationResult.confirm(code).then(result => {
            const phone = result.user.phoneNumber;

            fetch("/user/phone-verified", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ phone })
            }).then(res => {
                if (res.ok) {
                    alert("인증 완료");
                    location.reload();
                }
            });
        }).catch(error => alert("인증 실패: " + error.message));
    };
</script>
