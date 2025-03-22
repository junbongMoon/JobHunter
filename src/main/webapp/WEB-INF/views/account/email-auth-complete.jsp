<!-- ✅ email-auth-complete.jsp (Firebase 이메일 인증 완료 처리 페이지) -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp" />

<main>
    <h2>이메일 인증 완료 중...</h2>

    <script type="module">
        import { initializeApp } from "https://www.gstatic.com/firebasejs/11.5.0/firebase-app.js";
        import { getAuth, isSignInWithEmailLink, signInWithEmailLink } from "https://www.gstatic.com/firebasejs/11.5.0/firebase-auth.js";

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

        const urlParams = new URLSearchParams(window.location.search);
        const redirect = urlParams.get("redirect") || "/";
        const email = window.localStorage.getItem("emailForSignIn");

        // redirect 세션에 저장 (방법 2 적용)
        fetch("/account/restore-redirect", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ redirect })
        });

        if (isSignInWithEmailLink(auth, window.location.href)) {
            signInWithEmailLink(auth, email, window.location.href)
                .then(result => {
                    fetch("/account/verify", {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({
                            type: "email",
                            value: email,
                            userType: "NORMAL"
                        })
                    }).then(res => {
                        if (res.ok) {
                            res.text().then(url => location.href = url);
                        } else {
                            alert("인증 처리 실패");
                        }
                    });
                }).catch(error => {
                    alert("이메일 인증 실패: " + error.message);
                });
        } else {
            alert("유효하지 않은 인증 링크입니다.");
        }
    </script>
</main>

<jsp:include page="../footer.jsp" />
