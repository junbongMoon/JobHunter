<!-- resume_detail_view.jsp (조회 전용 뷰) -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>이력서 조회</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        .container { max-width: 1000px; margin: auto; padding: 2rem; }
        .section-title { font-size: 1.25rem; font-weight: bold; margin-top: 2rem; }
        .readonly-box { background-color: #f9f9f9; padding: 1rem; border-radius: 8px; margin-top: 0.5rem; }
        .photo { max-width: 200px; max-height: 200px; object-fit: contain; border-radius: 8px; }
        .badge-box span { margin-right: 0.5rem; margin-bottom: 0.5rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/header.jsp" />
<div class="container">
    <h2>이력서 조회</h2>

    <!-- 프로필 사진 -->
    <div class="section-title">증명 사진</div>
    <div>
        <c:if test="${not empty submit.profileBase64}">
            <img src="${submit.profileBase64}" class="photo" alt="프로필 사진" />
        </c:if>
    </div>

    <!-- 이력서 제목 -->
    <div class="section-title">이력서 제목</div>
    <div class="readonly-box">${submit.title}</div>

    <!-- 고용 형태 -->
    <div class="section-title">고용 형태</div>
    <div class="badge-box">
        <c:forEach var="jf" items="${submit.jobForms}">
            <span class="badge bg-secondary">${jf.form}</span>
        </c:forEach>
    </div>

    <!-- 희망 급여 -->
    <div class="section-title">희망 급여</div>
    <div class="readonly-box">${submit.payType} / <fmt:formatNumber value="${submit.pay}" pattern="#,#00"/> 원</div>

    <!-- 희망 근무 지역 -->
    <div class="section-title">희망 근무 지역</div>
    <div class="badge-box">
        <c:forEach var="s" items="${submit.sigunguList}">
            <span class="badge bg-info">${s.regionName} ${s.name}</span>
        </c:forEach>
    </div>

    <!-- 희망 업직종 -->
    <div class="section-title">희망 업직종</div>
    <div class="badge-box">
        <c:forEach var="sc" items="${submit.subcategoryList}">
            <span class="badge bg-primary">${sc.jobName}</span>
        </c:forEach>
    </div>

    <!-- 성격 및 강점 -->
    <div class="section-title">성격 및 강점</div>
    <div class="badge-box">
        <c:forEach var="m" items="${submit.merits}">
            <span class="badge bg-success">${m.meritContent}</span>
        </c:forEach>
    </div>

    <!-- 학력 사항 -->
    <div class="section-title">학력 사항</div>
    <c:forEach var="edu" items="${submit.educations}">
        <div class="readonly-box">
            ${edu.educationLevel} / ${edu.educationStatus} / ${edu.customInput} / ${edu.graduationDate}
        </div>
    </c:forEach>

    <!-- 경력 사항 -->
    <div class="section-title">경력 사항</div>
    <c:forEach var="h" items="${submit.histories}">
        <div class="readonly-box">
            ${h.companyName} - ${h.position} (${h.startDate} ~ <c:out value="${h.endDate != null ? h.endDate : '재직중'}"/>)<br>
            <small>${h.jobDescription}</small>
        </div>
    </c:forEach>

    <!-- 자격증 -->
    <div class="section-title">자격증</div>
    <c:forEach var="l" items="${submit.licenses}">
        <div class="readonly-box">
            ${l.licenseName} / ${l.institution} / ${l.acquisitionDate}
        </div>
    </c:forEach>

    <!-- 자기소개 -->
    <div class="section-title">자기소개</div>
    <div class="readonly-box" style="white-space: pre-wrap">${submit.introduce}</div>

    <!-- 첨부파일 -->
    <div class="section-title">첨부파일</div>
    <c:forEach var="f" items="${submit.files}">
        <div class="readonly-box">
            <a href="/resume/download/${f.newFileName}" download>${f.originalFileName}</a>
        </div>
    </c:forEach>
</div>
<jsp:include page="/WEB-INF/views/footer.jsp" />
</body>
</html>