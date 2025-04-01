<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function() {

		showDetailInfo();

	});

	function showDetailInfo() {
		const uid = '${RecruitmentDetailInfo.uid}';
		const application = '${RecruitmentDetailInfo.application}';
		const workType = '${RecruitmentDetailInfo.workType}';
		const militaryService = '${RecruitmentDetailInfo.militaryService}';
		const manager = '${RecruitmentDetailInfo.manager}';
		const period = '${RecruitmentDetailInfo.period}';
		const pay = '${RecruitmentDetailInfo.pay}';
		const payType = '${RecruitmentDetailInfo.payType}';
		const personalHistory = '${RecruitmentDetailInfo.personalHistory}';
		const detail = '${RecruitmentDetailInfo.detail}';
		const dueDateRaw = '${RecruitmentDetailInfo.dueDate}';
		const dueDate = new Date(dueDateRaw);
		const fileList = '${RecruitmentDetailInfo.fileList}';
		const count = '${RecruitmentDetailInfo.count}';

		// 마감일 넣어주기
		if (!isNaN(dueDate.getTime())) {
			const formatted = dueDate.toLocaleDateString('ko-KR', {
				year : 'numeric',
				month : 'long',
				day : 'numeric'
			});
			$('#dueDateSpan').text(formatted);
		} else {
			$('#dueDateSpan').text('유효하지 않은 날짜');
		}

		$('#detail').html(detail);

	}
</script>
<style>
.badge {
	margin-right: 5px;
	font-size: 2.5em;
}

h3 {
	font-weight: bold;
}
.card {
  border-radius: 12px;
  background-color: #f9f9f9;
  transition: all 0.2s ease-in-out;
}
.card:hover {
  background-color: #f1f8ff;
  transform: scale(1.01);
}
</style>
<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>
	<main class="main">


		<div class="container">
			<div class="row">

				<div class="col-lg-8">

					<!-- Blog Details Section -->
					<section id="blog-details" class="blog-details section">
						<div class="container" data-aos="fade-up">

							<article class="article">

								<div class="article-content" data-aos="fade-up"
									data-aos-delay="100">
									<div class="content-header">
										<h1 class="title">${RecruitmentDetailInfo.title}</h1>

										<div class="author-info">
											<div class="author-details">
												<!-- 이미지 있으면 이미지 넣을 것 -->
												<div class="info">
													<h4>${RecruitmentDetailInfo.companyName}</h4>
													<span class="role">${RecruitmentDetailInfo.subcategory.jobName}</span>
												</div>
											</div>
											<div class="post-meta">
												<span class="dueDate"><i class="bi bi-calendar3"></i>마감
													<span id="dueDateSpan"></span></span> <span class="divider">•</span>
												<span class="comments"><i class="bi bi-chat-text"></i>
													18 Comments(제출된 이력서 수)</span>
											</div>
										</div>
									</div>

									<div class="content">
										<p class="companyIntroduce">회사 기본 소개</p>
										<div class="categories-widget widget-item card">
											<h3 class="widget-title">지역</h3>
											<p id="region">
												<span class="badge rounded-pill text-bg-primary">${RecruitmentDetailInfo.region.name}</span>
												<span class="badge rounded-pill text-bg-info">${RecruitmentDetailInfo.sigungu.name}</span>
											</p>
										</div>

										<div class="categories-widget widget-item card">
											<h3 class="widget-title">직업</h3>
											<p id="jobType">
												<span class="badge rounded-pill text-bg-primary">${RecruitmentDetailInfo.majorCategory.jobName}</span>
												<span class="badge rounded-pill text-bg-info">${RecruitmentDetailInfo.subcategory.jobName}</span>
											</p>
										</div>

										<div class="card categories-widget widget-item">
                      <h5 class="widget-title">근무</h5>
                      <p class="mb-1 fw-semibold" id="workType">
                        <c:choose>
                          <c:when test="${RecruitmentDetailInfo.workType eq 'FULLTIME'}">정규직</c:when>
                          <c:when test="${RecruitmentDetailInfo.workType eq 'NONREGULAR'}">비정규직</c:when>
                          <c:when test="${RecruitmentDetailInfo.workType eq 'APPOINT'}">위촉직</c:when>
                          <c:when test="${RecruitmentDetailInfo.workType eq 'PARTTIME'}">아르바이트</c:when>
                          <c:when test="${RecruitmentDetailInfo.workType eq 'FREELANCER'}">프리랜서</c:when>
                          <c:otherwise>기타</c:otherwise>
                        </c:choose>
                      </p>
                      <p class="text-muted" id="period">${RecruitmentDetailInfo.period}</p>
                    </div>
                    
                    <div class="card categories-widget widget-item">
                      <h5 class="widget-title">급여</h5>
                      <p class="mb-1 fw-semibold" id="payType">
                        <c:choose>
                          <c:when test="${RecruitmentDetailInfo.payType eq 'HOUR'}">시급</c:when>
                          <c:when test="${RecruitmentDetailInfo.payType eq 'DATE'}">일급</c:when>
                          <c:when test="${RecruitmentDetailInfo.payType eq 'WEEK'}">주급</c:when>
                          <c:when test="${RecruitmentDetailInfo.payType eq 'MONTH'}">월급</c:when>
                          <c:when test="${RecruitmentDetailInfo.payType eq 'YEAR'}">연봉</c:when>
                          <c:otherwise>기타</c:otherwise>
                        </c:choose>
                      </p>
                      <p class="fs-5 fw-bold text-success" id="pay">
                        <fmt:formatNumber value="${RecruitmentDetailInfo.pay}" type="number" groupingUsed="true" /> 원
                      </p>
                    </div>


									<div class="categories-widget widget-item card">
										<h3 class="widget-title">조건</h3>
										<p id="personalHistory">
											<span class="badge rounded-pill text-bg-primary">${RecruitmentDetailInfo.personalHistory}</span>
											<c:forEach var="item"
												items="${RecruitmentDetailInfo.advantage}">
												<span class="badge rounded-pill text-bg-info">${item.advantageType}</span>
											</c:forEach>
										</p>
									</div>

									<div class="categories-widget widget-item card">
										<h2 class="widget-title">상세 정보</h2>
										<div class="highlight-box">

											<p id="detail"></p>
										</div>
									</div>
									<h3>첨부 파일</h3>
									<p id="fileList">첨부 파일 뱃지 형식으로 출력</p>
								</div>

								<div class="meta-bottom">
									<div class="tags-section">
										<h4>Related Topics</h4>
										<div class="tags">
											<ul class="trend-list">
												<li><i class="bi bi-lightning-charge"></i> <span>여기
														클릭하면 모달창(담당자 contact 정보 뜸) 온라인일 시 동적으로 만듬</span></li>
												<li><i class="bi bi-shield-check"></i> <span>여기
														클릭하면 모달창(담당자 contact 정보 뜸) 이메일일 시 동적으로 만듬</span></li>
												<li><i class="bi bi-phone"></i> <span>여기 클릭하면
														모달창(담당자 contact 정보 뜸) 전화일 시 동적으로 만듬</span></li>
												<li><i class="bi bi-phone"></i> <span>여기 클릭하면
														모달창(담당자 contact 정보 뜸) 문자일 시 동적으로 만듬</span></li>
											</ul>
										</div>
									</div>

									<div class="share-section">
										<h4>Share Article</h4>
										<div class="social-links">
											<a href="#" class="twitter"><i class="bi bi-twitter-x"></i></a>
											<a href="#" class="facebook"><i class="bi bi-facebook"></i></a>
											<a href="#" class="linkedin"><i class="bi bi-linkedin"></i></a>
											<a href="#" class="copy-link" title="Copy Link"><i
												class="bi bi-link-45deg"></i></a>
										</div>
									</div>
								</div>
						</div>

						</article>
				</div>
				</section>
				<!-- /Blog Details Section -->


			</div>

			<div class="col-lg-4 sidebar">

				<div class="widgets-container" data-aos="fade-up"
					data-aos-delay="200">

					<!-- Search Widget -->
					<div class="search-widget widget-item">

						<h3 class="widget-title">Search</h3>
						<form action="">
							<input type="text">
							<button type="submit" title="Search">
								<i class="bi bi-search"></i>
							</button>
						</form>

					</div>
					<!--/Search Widget -->

					<!-- Categories Widget -->
					<div class="categories-widget widget-item">

						<h3 class="widget-title">Categories</h3>
						<ul class="mt-3">
							<li><a href="#">지역 <span>(25)</span></a></li>
							<li><a href="#">시군구 <span>(12)</span></a></li>
							<li><a href="#">산업군 <span>(5)</span></a></li>
							<li><a href="#">직업군 <span>(22)</span></a></li>
							<li><a href="#">우대조건 <span>(8)</span></a></li>
							<li><a href="#">면접방식 <span>(14)</span></a></li>
						</ul>

					</div>
					<!--/Categories Widget -->



				</div>

			</div>

		</div>
		</div>
		<!-- 풋터 -->
		<jsp:include page="../footer.jsp"></jsp:include>

	</main>


	<!-- Scroll Top -->
	<a href="#" id="scroll-top"
		class="scroll-top d-flex align-items-center justify-content-center"><i
		class="bi bi-arrow-up-short"></i></a>


</body>
</html>
