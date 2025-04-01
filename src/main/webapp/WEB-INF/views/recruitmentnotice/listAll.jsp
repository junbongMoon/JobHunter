<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<style>
.rectext strong{
	color: #47b2e4;;
	
}

</style>
<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>
	<main class="main">
		<!-- Blog Posts Section -->
		<section id="blog-posts" class="blog-posts section">

			<div class="container" data-aos="fade-up" data-aos-delay="100">
				<div class="row gy-4">

					<c:forEach var="rec" items="${boardList}">
						<div class="col-lg-6">
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

								<div class="content">
									<p class="rectext">
										<strong>지역:</strong>
										<span class="badge bg-primary me-2"><c:out value="${rec.region.name}" default="-" /></span>
										<strong>시군구:</strong>
										<span class="badge bg-info me-2"><c:out value="${rec.sigungu.name}" default="-" /></span>
										<br /> 
										<strong>산업군:</strong>
										<span class="badge bg-success me-2"><c:out value="${rec.majorCategory.jobName}" default="-" /></span>
										<strong>직업:</strong>
										<span class="badge bg-warning text-dark me-2"><c:out value="${rec.subcategory.jobName}" default="-" /></span>
										<br /> 
										<strong>우대조건:</strong>
										<c:forEach var="adv" items="${rec.advantage}" varStatus="status">
											<c:if test="${status.index < 2}">
												<span class="badge bg-danger me-2">${adv.advantageType}</span>
											</c:if>
										</c:forEach>
										<br /> 
										<strong>면접방식:</strong>
										<c:forEach var="app" items="${rec.application}" varStatus="status">
											<c:if test="${status.index < 2}">
												<span class="badge bg-secondary me-2">${app.method}</span>
											</c:if>
										</c:forEach>
									</p>

									<div class="read-more">
										<a href="/recruitmentnotice/detail/${rec.uid}">바로 가기</a>
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
							href="?pageNo=${pageResponse.startPageNumPerBlock - 1}"
							aria-label="Previous"> <span aria-hidden="true">«</span>
						</a></li>
					</c:if>

					<!-- 페이지 번호 반복 출력 -->
					<c:forEach begin="${pageResponse.startPageNumPerBlock}"
						end="${pageResponse.endPageNumPerBlock}" var="i">
						<li class="page-item ${i == pageResponse.pageNo ? 'active' : ''}">
							<a class="page-link" href="?pageNo=${i}">${i}</a>
						</li>
					</c:forEach>

					<!-- ▶ 다음 블럭 -->
					<c:if
						test="${pageResponse.endPageNumPerBlock < pageResponse.totalPageCnt}">
						<li class="page-item"><a class="page-link"
							href="?pageNo=${pageResponse.endPageNumPerBlock + 1}"
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