<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 상세</title>
</head>
<body>
<jsp:include page="../header.jsp" />

<div class="container">
    <h1>리뷰 상세 페이지</h1>

    <p><strong>지원한 포지션:</strong> ${detail.title}</p>
    <p><strong>작성자:</strong> ${detail.userId}</p>
    <p><strong>회사명:</strong> ${detail.companyName}</p>
    <p><strong>급여 형태:</strong> ${detail.payType}</p>
    <p><strong>공고 설명:</strong> ${detail.detail}</p>

    <hr>

    <p><strong>리뷰 결과:</strong> ${detail.reviewResult}</p>
    <p><strong>리뷰 유형:</strong> ${detail.reviewType}</p>
    <p><strong>난이도:</strong> ${detail.reviewLevel}</p>
    <p><strong>리뷰 내용:</strong> ${detail.content}</p>
    <p><strong>좋아요:</strong> ${detail.likes}</p>

    <br>
    <button onclick="location.href='/reviewBoard/allBoard'">목록으로</button>
</div>
</body>
</html>