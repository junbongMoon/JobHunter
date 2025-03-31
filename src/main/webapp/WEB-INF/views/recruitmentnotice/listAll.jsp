<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
	

</script>
<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>
	<main class="main">
	<!-- Blog Posts Section -->
	<section id="blog-posts" class="blog-posts section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<div>${boardList} </div>
			<div class="row gy-4">
				
				
				
					
				<c:forEach var="rec" items="${boardList}">
	<div class="col-lg-6">
		<article>
			<h2 class="title">
				<a href="/recruitmentnotice/detail/${rec.uid}">${rec.title}</a>
			</h2>

			<div class="meta-top">
				<ul>
					<li class="d-flex align-items-center">
						<i class="bi bi-person writer"></i>
						<a href="#">${rec.companyName != null ? rec.companyName : rec.refCompany}</a>
					</li>
					<li class="d-flex align-items-center">
						<i class="bi bi-clock"></i>
						<a href="#"><time><fmt:formatDate value="${bo.dueDate}" pattern="yyyy-MM-dd"/></time></a>
					</li>
				</ul>
			</div>

			<div class="content">
				<p class="rectext">
					<strong>우대조건:</strong>
					<c:forEach var="adv" items="${rec.advantage}" varStatus="status">
						<c:if test="${status.index < 2}">
							<span>${adv.advantageType}</span>
						</c:if>
					</c:forEach>
					<br />
					<strong>면접방식:</strong>
					<c:forEach var="app" items="${rec.application}" varStatus="status">
						<c:if test="${status.index < 2}">
							<span>${app.method}</span>
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

	</section>


	</main>
	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>
	
</body>
</html>