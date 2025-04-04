<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>면접 후기 상세보기</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    :root {
      --heading-color: #003366;
      --nav-dropdown-hover-color: #88ccee;
      --background-color: #ffffff;
    }
    .section-title {
      font-size: 50px;
      font-weight: bold;
      color: var(--heading-color);
      margin:auto;
    }
    .info-label {
      font-size: 14px;
      font-weight: bold;
      color: #555;
      margin-bottom: auto;
      
    }
    .info-value {
      font-size: 16px;
      margin-bottom: 16px;
      color: #222;
    }
    .info-group {
      margin-bottom: 24px;
    }
    .section-box {
      background-color: var(--background-color);
      border: 1px solid #eee;
      border-radius: 10px;
      padding: 32px;
      margin-bottom: 40px;
    }
  </style>
</head>
<body class="bg-light">

<jsp:include page="../header.jsp" />
<div class= "container">
<!-- 기업 정보 -->
<div class="section-box">
  <h5 class="mb-4 fw-bold text-primary">기업 정보</h5>
  <div class="row">
    <div class="col-md-6">
      <div class="info-label">회사명</div>
      <div class="info-value">${detail.companyName}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">공고 상세</div>
      <div class="info-value">${detail.detail}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">근무 형태</div>
      <div class="info-value">${detail.workType}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">근무 기간</div>
      <div class="info-value">${detail.period}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">급여 형태</div>
      <div class="info-value">${detail.payType}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">경력 사항</div>
      <div class="info-value">${detail.personalHistory}</div>
    </div>
  </div>
</div>

<!-- 지원자 정보 -->
<div class="section-box">
  <h5 class="mb-4 fw-bold text-primary">지원자 정보</h5>
  <div class="row">
    <div class="col-md-6">
      <div class="info-label">작성자 ID</div>
      <div class="info-value">${detail.userId}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">이력서 제목</div>
      <div class="info-value">${detail.title}</div>
    </div>
  </div>
</div>

<!-- 면접 후기 -->
<div class="section-box">
  <h5 class="mb-4 fw-bold text-primary">면접 후기</h5>
  <div class="row">
    <div class="col-md-6">
      <div class="info-label">면접 유형</div>
      <div class="info-value">${detail.reviewType}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">면접 결과</div>
      <div class="info-value">${detail.reviewResult}</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">난이도</div>
      <div class="info-value">${detail.reviewLevel} / 5</div>
    </div>
    <div class="col-md-6">
      <div class="info-label">조회수</div>
      <div class="info-value">${detail.views}</div>
    </div>
    <div class="col-md-12">
      <div class="info-label">후기 내용</div>
      <div class="info-value">${detail.content}</div>
    </div>
  </div>
</div>

  <!-- 좋아요 및 조회수 -->
  <div class="text-end text-muted mb-3">
    👍 ${detail.likes} &nbsp;&nbsp;&nbsp; 👁️ ${detail.views}
  </div>

  <!-- 버튼 -->
  <div class="text-center">
    <a href="${pageContext.request.contextPath}/reviewBoard/allBoard" class="btn btn-outline-secondary">← 목록으로</a>
  </div>

</div>

</body>
</html>
