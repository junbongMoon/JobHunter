<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채용공고</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
.card.custom-job-card {
	display: flex;
	flex-direction: column;
	justify-content: space-between; /* 하단 정렬에 도움 */
	border: 1px solid #47b2e4;
	border-radius: 12px;
	overflow: hidden;
	transition: transform 0.2s ease;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
	height: 100%;
}

.card.custom-job-card:hover {
	transform: translateY(-5px);
}

.card.custom-job-card img {
	width: 100%;
	height: 120px;
	object-fit: contain;
	background-color: #fff;
	padding: 1rem;
}

.card.custom-job-card .card-body {
	display: flex;
	flex-direction: column;
	flex-grow: 1;
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
	flex-grow: 1; /* 내용이 짧아도 빈 공간 확보 */
}

.card.custom-job-card .btn {
	background-color: #47b2e4;
	border: none;
	font-size: 0.9rem;
	padding: 0.4rem 0.8rem;
	border-radius: 6px;
	align-self: flex-start; /* 좌측 정렬 */
	margin-top: 10px;
}

.card.custom-job-card .btn:hover {
	background-color: #3399cc;
}


/* employment 검색바 및 버튼 스타일 */
.search-bar-container {
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
	margin-bottom: 20px;
	align-items: center;
}

.search-input {
	width: 250px; /* 고정 너비 지정 */
	padding: 8px 12px;
	border: 1px solid #ccc;
	border-radius: 8px;
}

.search-select {
	padding: 8px 12px;
	border-radius: 8px;
	border: 1px solid #ccc;
	background-color: #fff;
}

.search-button, .reset-button {
	padding-top: 6px;
	padding-right: 15px;
	padding-bottom: 6px;
	padding-left: 15px;
	border-radius: 8px;
	font-weight: 500;
}

.search-button {
	background-color: #47b2e4;
	color: white;
	border: none;
	padding: 8px 16px;
	border-radius: 8px;
	font-weight: 500;
}

.search-button:hover {
	background-color: #349fce;
}

.reset-button {
	border: 1px solid #47b2e4;
	color: #47b2e4;
	background-color: white;
	padding: 8px 16px;
	border-radius: 8px;
	font-weight: 500;
}

.reset-button:hover {
	background-color: #eaf7fd;
}

.pagination {
	display: flex;
	justify-content: center;
	gap: 8px;
	margin-top: 30px;
	flex-wrap: wrap;
}
/*페이징 css*/
.page-link {
	 color: #47b2e4;
    border: 1px solid #47b2e4;
    border-radius: 6px;
    padding: 6px 14px;
    font-weight: 500;
    background-color: white;
    text-decoration: none;
}

.page-link:hover {
	background-color: #47b2e4;
    color: white;
}

.page-item.active .page-link {
	background-color: #47b2e4;
    color: white;
    border: 1px solid #47b2e4;
}


.recruit-title {
    color: #3d4d6a;
    font-weight: bold;
    font-size: 50px; 
    text-align: center;
    margin-bottom: 20px;
}
</style>
</head>
<body>
	<jsp:include page="../header.jsp"></jsp:include>

	<div class="container mt-4">
	
	<h2 class="recruit-title">공공기관 제공 채용정보</h2>
	
		<!-- 검색바 영역 -->
		<div class="row mb-3">
			<div class="col-12">
				<form method="get" class="search-bar-container">
					<input type="text" name="keyword" class="search-input"
						placeholder="기관명 또는 공고명" value="${keyword}" /> <select
						name="sort" class="search-select">
						<option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
						<option value="deadline" ${sort eq 'deadline' ? 'selected' : ''}>마감임박순</option>
						<option value="company" ${sort eq 'company' ? 'selected' : ''}>기관명순</option>
					</select>

					<button type="submit" class="search-button">검색</button>
					<a href="${pageContext.request.contextPath}/employment/list"
						class="reset-button">초기화</a>
				</form>
			</div>
		</div>



		<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
			<c:forEach var="list" items="${listEmploy}">
				<div class="col">
					<div class="card custom-job-card h-100">
						<img src="${list.regLogImgNm}" class="card-img-top" alt="공고 이미지"
							onerror="this.src='/resources/default-logo.png'">
						<div class="card-body">
							<h5 class="card-title">${list.empWantedTitle}</h5>
							<p class="card-text">
								<strong>기관:</strong> ${list.empBusiNm} (${empty list.coClcdNm ? '사기업' : list.coClcdNm})<br />
								<strong>고용형태:</strong> ${list.empWantedTypeNm}<br /> <strong>기간:</strong>
								${list.empWantedStdt} ~ ${list.empWantedEndt}
							</p>
							<a href="${list.empWantedHomepgDetail}" class="btn btn-primary"
								target="_blank">상세 보기</a>
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
	</div>
	<!-- 페이징 -->
	<div class="mt-4 text-center">
		<c:if test="${totalPages > 1}">
			<ul class="pagination">
				<c:if test="${currentPage > 1}">
					<li class="page-item"><a class="page-link"
						href="?page=${currentPage - 1}&keyword=${keyword}&sort=${sort}">이전</a>
					</li>
				</c:if>

				<c:forEach var="i" begin="${startPage}" end="${endPage}">
					<li class="page-item ${currentPage == i ? 'active' : ''}"><a
						class="page-link"
						href="?page=${i}&keyword=${keyword}&sort=${sort}">${i}</a></li>
				</c:forEach>

				<c:if test="${currentPage < totalPages}">
					<li class="page-item"><a class="page-link"
						href="?page=${currentPage + 1}&keyword=${keyword}&sort=${sort}">다음</a>
					</li>
				</c:if>
			</ul>
		</c:if>
	</div>
</body>
</html>