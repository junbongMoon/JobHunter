<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	// 페이지 로드시 초기 실행
	$(function () {
	const selectedVal = $('#searchType').val();
	const keywordBox = document.querySelector('#keywordBox');

	// 페이지 로딩 시 input 없으면 렌더링
	if (["region", "jobType", "advantage", "jobform"].includes(selectedVal)) {
		if (!keywordBox.querySelector('input')) {
			const input = document.createElement('input');
			input.type = 'text';
			input.name = 'searchWord';
			input.placeholder = '검색어를 입력하세요';
			input.className = 'form-control';
			input.value = '${param.searchWord}';
			keywordBox.appendChild(input);
		}
	}

	$(document).on('change', '#searchType', function () {
		const selectedVal = $('#searchType').val();
		keywordBox.innerHTML = '';

		if (["region", "jobType", "advantage", "jobform"].includes(selectedVal)) {
			const input = document.createElement('input');
			input.type = 'text';
			input.name = 'searchWord';
			input.placeholder = '검색어를 입력하세요';
			input.className = 'form-control';
			keywordBox.appendChild(input);
		}
	});
});
</script>

<style>
.rectext strong {
	color: #47b2e4;;
}

.recruitmentList {
	margin-top: 20px;
}

.write-btn-container {
	width: 95%;
	margin-bottom: 50px;
}

.write-btn {
	background-color: #47b2e4;
	color: white;
	padding: 10px 20px;
	border-radius: 8px;
	text-decoration: none;
	font-weight: bold;
	transition: background-color 0.3s ease;
}

.write-btn:hover {
	background-color: #1f9fd2;
}

.recruitment {
	margin-bottom: 30px;
}
</style>
<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>
	<main class="main">
		<!-- Blog Posts Section -->

		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<section id="blog-posts" class="blog-posts section">
				<div>
					<c:choose>
						<c:when test="${sessionScope.account.accountType == 'COMPANY'}">
							<div class="write-btn-container text-end">
								<a href="/recruitmentnotice/write" class="write-btn">공고 작성</a>
							</div>
						</c:when>
					</c:choose>
				</div>
				<form action="/recruitmentnotice/listAll" method="get" class="mb-4"
					style="width: 90%; margin: 0 auto;">
					<div class="row">
						<div class="col-md-3">
							<select class="form-select" name="searchType" id="searchType">
								<option value="">검색 조건 없음</option>
								<option value="region"
									${param.searchType == 'region' ? 'selected' : ''}>지역</option>
								<option value="jobType"
									${param.searchType == 'jobType' ? 'selected' : ''}>직업군</option>
								<option value="advantage"
									${param.searchType == 'advantage' ? 'selected' : ''}>우대조건</option>
								<option value="jobform"
									${param.searchType == 'jobform' ? 'selected' : ''}>근무형태</option>
								<option value="highPay"
									${param.searchType == 'highPay' ? 'selected' : ''}>높은금액
									순</option>
								<option value="lowPay"
									${param.searchType == 'lowPay' ? 'selected' : ''}>낮은금액
									순</option>
							</select>
						</div>

						<div class="col-md-6" id="keywordBox">
							<c:if test="${not empty param.searchWord 
										&& not empty param.searchType 
										&& param.searchType != 'highPay' 
										&& param.searchType != 'lowPay'}">
								<input type="text" name="searchWord" class="form-control"
									   placeholder="검색어를 입력하세요"
									   value="${param.searchWord}" />
							</c:if>
						</div>

						<div class="col-md-3 text-end">
							<button type="submit" class="btn btn-primary">검색</button>
						</div>
					</div>
				</form>
				<div class="row gy-4 gx-4">

					<c:forEach var="rec" items="${boardList}">
						<div class="col-lg-6 recruitment">
							<article>
								<h2 class="title">
									<a href="/recruitmentnotice/detail?uid=${rec.uid}">${rec.title}</a>
								</h2>

								<div class="meta-top">
									<ul>
										<li class="d-flex align-items-center"><i
											class="bi bi-person writer"></i> <a href="#">${rec.companyName}</a>
										</li>
										<li class="d-flex align-items-center"><i
											class="bi bi-clock"></i> <a href="#"><time>
													<fmt:formatDate value="${rec.dueDate}" pattern="yyyy-MM-dd" />
												</time></a></li>
									</ul>
								</div>

								<div class="content recruitmentList">
									<p class="rectext">
										<strong>지역:</strong> <span class="badge bg-primary me-2"><c:out
												value="${rec.region.name}" default="-" /></span> <strong>시군구:</strong>
										<span class="badge bg-info me-2"><c:out
												value="${rec.sigungu.name}" default="-" /></span> <br /> <strong>산업군:</strong>
										<span class="badge bg-success me-2"><c:out
												value="${rec.majorCategory.jobName}" default="-" /></span> <strong>직업:</strong>
										<span class="badge bg-warning text-dark me-2"><c:out
												value="${rec.subcategory.jobName}" default="-" /></span> <br /> <strong>우대조건:</strong>
										<c:forEach var="adv" items="${rec.advantage}"
											varStatus="status">
											<c:if test="${status.index < 2}">
												<span class="badge bg-danger me-2">${adv.advantageType}</span>
											</c:if>
										</c:forEach>
										<br /> <strong>면접방식:</strong>
										<c:forEach var="app" items="${rec.application}"
											varStatus="status">
											<c:if test="${status.index < 2}">
												<span class="badge bg-secondary me-2">${app.method}</span>
											</c:if>
										</c:forEach>
									</p>

									<div class="read-more">

										<a href="/recruitmentnotice/detail/?uid=${rec.uid}">바로 가기</a>
									</div>
								</div>
							</article>
						</div>
					</c:forEach>


					<!-- End post list item -->

				</div>
				<!-- End blog posts list -->
		</div>
		<!-- 페이지 블럭 -->
		<div class="pagination justify-content-center mt-4">
			<ul class="pagination">

				<!-- ◀ 이전 블럭 -->
				<c:if test="${pageResponse.startPageNumPerBlock > 1}">
					<li class="page-item"><a class="page-link"
						href="?pageNo=${pageResponse.startPageNumPerBlock - 1}&searchType=${pageResponse.searchType}&searchWord=${pageResponse.searchWord}"
						aria-label="Previous"> <span aria-hidden="true">«</span>
					</a></li>
				</c:if>

				<!-- 페이지 번호 반복 출력 -->
				<c:forEach begin="${pageResponse.startPageNumPerBlock}"
					end="${pageResponse.endPageNumPerBlock}" var="i">
					<li class="page-item ${i == pageResponse.pageNo ? 'active' : ''}">
						<a class="page-link"
						href="?pageNo=${i}&searchType=${pageResponse.searchType}&searchWord=${pageResponse.searchWord}">${i}</a>
					</li>
				</c:forEach>

				<!-- ▶ 다음 블럭 -->
				<c:if
					test="${pageResponse.endPageNumPerBlock < pageResponse.totalPageCnt}">
					<li class="page-item"><a class="page-link"
						href="?pageNo=${pageResponse.endPageNumPerBlock + 1}&searchType=${pageResponse.searchType}&searchWord=${pageResponse.searchWord}"
						aria-label="Next"> <span aria-hidden="true">»</span>
					</a></li>
				</c:if>
			</ul>



		</div>

		</section>


	</main>
	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>

</body>
</html>