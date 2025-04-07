<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>이력서 제출</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="/resources/css/mypage.css">
<style>
	.notice-info {
		background-color: #f8f9fa;
		border-radius: 10px;
		padding: 20px;
		margin-bottom: 30px;
		box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
	}
	.notice-title {
		font-size: 24px;
		font-weight: bold;
		color: #2c3e50;
		margin-bottom: 15px;
	}
	.notice-company {
		font-size: 18px;
		color: #47b2e4;
		margin-bottom: 10px;
	}
	.notice-details {
		display: flex;
		flex-wrap: wrap;
		gap: 20px;
		margin-top: 15px;
	}
	.notice-detail-item {
		display: flex;
		align-items: center;
		gap: 8px;
	}
	.notice-detail-item i {
		color: #47b2e4;
	}
	.error-message {
		background-color: #fff3f3;
		color: #dc3545;
		padding: 15px;
		margin: 20px 0;
		border-radius: 5px;
		text-align: center;
	}
	.back-button {
		display: inline-block;
		padding: 10px 20px;
		background-color: #6c757d;
		color: white;
		text-decoration: none;
		border-radius: 5px;
		margin-top: 10px;
	}
	.back-button:hover {
		background-color: #5a6268;
	}
</style>
</head>

<body>
	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="main">
		<div class="container">
			<h1 class="page-title">이력서 제출</h1>
			
			<!-- 오류 메시지 표시 -->
			<c:if test="${not empty errorMessage}">
				<div class="error-message">
					${errorMessage}
					<br>
					<a href="/recruitmentnotice/listAll" class="back-button">공고 목록으로 돌아가기</a>
				</div>
			</c:if>
			
			<!-- 공고 정보 표시 -->
			<c:if test="${not empty recruitmentNotice}">
				<div class="notice-info">
					<div class="notice-title">${recruitmentNotice.title}</div>
					<div class="notice-company">${recruitmentNotice.companyName}</div>
					<div class="notice-details">
						<div class="notice-detail-item">
							<i class="fas fa-map-marker-alt"></i>
							<span>
								<c:if test="${not empty recruitmentNotice.region}">${recruitmentNotice.region.name}</c:if>
								<c:if test="${not empty recruitmentNotice.sigungu}"> ${recruitmentNotice.sigungu.name}</c:if>
							</span>
						</div>
						<div class="notice-detail-item">
							<i class="fas fa-briefcase"></i>
							<span>${recruitmentNotice.workType}</span>
						</div>
						<div class="notice-detail-item">
							<i class="fas fa-graduation-cap"></i>
							<span>${recruitmentNotice.personalHistory}</span>
						</div>
						<div class="notice-detail-item">
							<i class="fas fa-money-bill-wave"></i>
							<span>
								<c:choose>
									<c:when test="${recruitmentNotice.payType eq 'HOUR'}">시급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'DATE'}">일급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'WEEK'}">주급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'MONTH'}">월급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'YEAR'}">연봉</c:when>
									<c:otherwise>기타</c:otherwise>
								</c:choose>
								<span id="payAmount">${recruitmentNotice.pay}</span>원
							</span>
						</div>
						<div class="notice-detail-item">
							<i class="fas fa-calendar-alt"></i>
							<span id="dueDate">${recruitmentNotice.dueDate}</span>
						</div>
					</div>
				</div>
			</c:if>
			
			<!-- 이력서 선택 섹션 (추후 구현) -->
			<div class="resume-selection">
				<h2><i class="fas fa-file-alt section-icon"></i>제출할 이력서 선택</h2>
				<div class="resume-list">
					<div class="alert alert-info">
						<i class="fas fa-info-circle"></i> 이력서 선택 기능은 추후 구현 예정입니다.
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 풋터 -->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
	
	<script>
		// 페이지 로드 시 실행
		$(document).ready(function() {
			// 급여 금액에 콤마 추가
			var payAmount = $('#payAmount').text();
			if (payAmount) {
				$('#payAmount').text(Number(payAmount).toLocaleString());
			}
			
			// 날짜 형식 변환
			var dueDate = $('#dueDate').text();
			if (dueDate) {
				// 날짜 형식 변환 (YYYY-MM-DD)
				var date = new Date(dueDate);
				var formattedDate = date.getFullYear() + '-' + 
					(String(date.getMonth() + 1).padStart(2, '0')) + '-' + 
					(String(date.getDate()).padStart(2, '0'));
				$('#dueDate').text(formattedDate);
			}
		});
	</script>
</body>

</html>