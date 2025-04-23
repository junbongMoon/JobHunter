<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채용공고</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
.card.custom-job-card {
  border: 1px solid #47b2e4;/* 얇은 테두리 추가 */
  border-radius: 12px;
  overflow: hidden;
  transition: transform 0.2s ease;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
}

.card.custom-job-card:hover {
  transform: translateY(-5px);
}

.card.custom-job-card img {
  width: 100%;
  height: 120px; /* 기존보다 작게 줄임 */
  object-fit: contain; /* 비율 유지하며 꽉 채우지 않음 */
  background-color: #fff;
  padding: 1rem; 
}

.card.custom-job-card .card-body {
  padding: 1rem;
}

.card.custom-job-card .card-title {
  font-size: 1rem;
  font-weight: bold;
  color: #003366;
  margin-bottom: 0.75rem;
}

.card.custom-job-card .card-text {
  font-size: 0.85rem;
  color: #555;
  line-height: 1.5;
  margin-bottom: 0.75rem;
}

.card.custom-job-card .btn {
  background-color: #007bff;
  border: none;
  font-size: 0.9rem;
  padding: 0.4rem 0.8rem;
  border-radius: 6px;
}

.card.custom-job-card .btn:hover {
  background-color: #0056b3;
}



</style>
</head>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-4">
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach var="list" items="${listEmploy}">
            <div class="col">
                <div class="card custom-job-card h-100">
                    <img src="${list.regLogImgNm}" class="card-img-top" alt="공고 이미지" onerror="this.src='/resources/default-logo.png'">
                    <div class="card-body">
                        <h5 class="card-title">${list.empWantedTitle}</h5>
                        <p class="card-text">
                            <strong>기관:</strong> ${list.empBusiNm} (${list.coClcdNm})<br/>
                            <strong>고용형태:</strong> ${list.empWantedTypeNm}<br/>
                            <strong>기간:</strong> ${list.empWantedStdt} ~ ${list.empWantedEndt}
                        </p>
                        <a href="${list.empWantedHomepgDetail}" class="btn btn-primary" target="_blank">상세 보기</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="container mt-4">
    <!-- 카드 목록 -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach var="list" items="${listEmploy}">
            <!-- 카드 출력 동일 -->
        </c:forEach>
    </div>

    <!-- 페이징 -->
    <div class="mt-4 text-center">
        <c:set var="current" value="${currentPage}" />
        <c:forEach begin="1" end="10" var="i"> <%-- 최대 10페이지 가정 --%>
            <a href="?page=${i}" class="btn btn-sm ${current == i ? 'btn-dark' : 'btn-outline-secondary'} mx-1">${i}</a>
        </c:forEach>
    </div>
</div>


</body>
</html>