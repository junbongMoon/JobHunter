<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>면접 후기 작성</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <h2 class="mb-4">면접 후기 작성</h2>

<div class="container mt-5">
    <c:if test="${not empty sessionScope.account}">
        <form action="${pageContext.request.contextPath}/reviewBoard/write" method="post">
            <!-- 공고 선택 -->
            <div class="mb-3">
                <label class="form-label">공고 선택<span class="text-danger">*</span></label>
                <select class="form-select" name="companyName" required>
                    <option value="" selected disabled>지원한 공고를 선택하세요</option>
                    <c:forEach var="gonggo" items="${gonggoList}">
                        <option value="${gonggo.companyName}">
                            [${gonggo.companyName}] ${gonggo.recruitmentTitle} | ${gonggo.workType} | ${gonggo.payType}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- 면접 유형 -->
              <div class="mb-3">
                <label class="form-label">면접 유형<span class="text-danger">*</span></label><br>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="reviewType" value="FACE_TO_FACE" required> 대면
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="reviewType" value="VIDEO"> 비대면
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="reviewType" value="PHONE"> 전화면접
                </div>
            </div>

            <!-- 면접 난이도 -->
            <div class="mb-3">
                <label class="form-label">면접 난이도<span class="text-danger">*</span></label>
                <select class="form-select" name="reviewLevel" required>
                    <option value="" selected disabled>난이도를 선택하세요</option>
                    <option value="1">⭐️</option>
                    <option value="2">⭐️⭐️</option>
                    <option value="3">⭐️⭐️⭐️</option>
                    <option value="4">⭐️⭐️⭐️⭐️</option>
                    <option value="5">⭐️⭐️⭐️⭐️⭐️</option>
                </select>
            </div>

            <!-- 면접 결과 -->
            <div class="mb-3">
                <label class="form-label">면접 결과<span class="text-danger">*</span></label>
                <select class="form-select" name="reviewResult" required>
                    <option value="" selected disabled>결과를 선택하세요</option>
                    <option value="합격">합격</option>
                    <option value="불합격">불합격</option>
                    <option value="진행중">진행중</option>
                </select>
            </div>

            <!-- 리뷰 내용 -->
            <div class="mb-3">
                <label class="form-label">리뷰 내용<span class="text-danger">*</span></label>
                <textarea class="form-control" name="content" rows="6" placeholder="면접 질문, 분위기 등을 자유롭게 작성해주세요." required></textarea>
            </div>

            <!-- writer 정보 숨김 전달 -->
            <input type="hidden" name="writer" value="${sessionScope.account.uid}" />

            <button type="submit" class="btn btn-primary">후기 등록</button>
            <a href="${pageContext.request.contextPath}/reviewBoard/allBoard" class="btn btn-secondary">취소</a>
        </form>
    </c:if>

    <c:if test="${empty sessionScope.account}">
        <div class="alert alert-warning" role="alert">
            로그인 후 이용 가능한 기능입니다. <a href="${pageContext.request.contextPath}/account/login" class="alert-link">로그인하러 가기</a>
        </div>
    </c:if>
</div>
</body>
</html>
