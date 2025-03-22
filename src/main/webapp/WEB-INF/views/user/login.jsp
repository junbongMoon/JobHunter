<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <!-- 여기에 CSS 링크 필요 시 추가 -->
</head>
<body>
    <!-- 헤더 -->
    <jsp:include page="../header.jsp" />

    <main class="main">
        <!-- 로그인 영역 -->
        <div class="login-container">
            <h2>로그인</h2>

            <c:if test="${param.error == 'true'}">
                <div class="error">아이디 또는 비밀번호가 잘못되었습니다.</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/login" method="post">
                <div class="form-group">
                    <label for="userId">아이디</label>
                    <input type="text" name="userId" id="userId" required />
                </div>
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" name="password" id="password" required />
                </div>
                <div class="remember-me">
                    <input type="checkbox" name="remember" id="remember" />
                    <label for="remember">자동 로그인</label>
                </div>
                <button type="submit" class="submit-btn">로그인</button>
            </form>
        </div>
        <!-- /로그인 영역 -->
    </main>

    <!-- 풋터 -->
    <jsp:include page="../footer.jsp" />
</body>
</html>
