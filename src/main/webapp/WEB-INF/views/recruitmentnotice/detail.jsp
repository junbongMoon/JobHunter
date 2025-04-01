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
	
	// 데이터를 출력 하는 함수
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

		// 마감일 출력
		
		if (!isNaN(dueDate.getTime())) { // dueDateRaw가 날짜형식이 아니면 Invalid Date객체 생성, .getTime()이 NaN을 반환
			const formatted = dueDate.toLocaleDateString('ko-KR', {
				year : 'numeric', // 숫자
				month : 'long', // n월
				day : '2-digit' // 2자리
			});
			$('#dueDateSpan').text(formatted);
		} else {
			$('#dueDateSpan').text('유효하지 않은 날짜');
		}

		$('#detail').html(detail);

	}
	
	// 모달 띄우기
	function openContactModal(method, detail) {
		const message = detail && detail.trim() !== '' ? detail
				: `${method} 방식으로 접수 가능합니다.`;

		$('#contactModalBody').text(message);
		const modal = new bootstrap.Modal(document
				.getElementById('contactModal'));
		modal.show();
	}
	
	function downloadFile(boardUpFileNo){
		// 아작스 불러서 파일 저장
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

.trend-list {
	list-style-type: none;
	padding-left: 0;
}

.trend-list li:hover {
	background-color: #f1f8ff;
	transform: scale(1.01);
}

#fileList .badge {
	margin-right: 6px;
	margin-bottom: 4px;
	font-size: 0.9rem;
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
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'FULLTIME'}">정규직</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'NONREGULAR'}">비정규직</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'APPOINT'}">위촉직</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'PARTTIME'}">아르바이트</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'FREELANCER'}">프리랜서</c:when>
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
												<fmt:formatNumber value="${RecruitmentDetailInfo.pay}"
													type="number" groupingUsed="true" />
												원
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
										<p id="fileList">
											<c:if test="${not empty RecruitmentDetailInfo.fileList}">
												<c:forEach var="file"
													items="${RecruitmentDetailInfo.fileList}">
													<span class="badge rounded-pill text-bg-secondary"
														onclick="downloadFile(${file.boardUpFileNo})">
														${file.originalFileName} </span>
												</c:forEach>
											</c:if>
										</p>
									</div>

									<div class="meta-bottom">
										<div class="tags-section">
											<h4>Related Topics</h4>
											<div class="tags">
												<ul class="trend-list">
													<c:forEach var="app"
														items="${RecruitmentDetailInfo.application}">
														<c:choose>
															<c:when test="${app.method eq 'ONLINE'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/internet100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>온라인
																		접수 안내</span></li>
															</c:when>
															<c:when test="${app.method eq 'EMAIL'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/mail100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>이메일
																		접수 안내</span></li>
															</c:when>
															<c:when test="${app.method eq 'PHONE'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/phone100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>전화
																		접수 안내</span></li>
															</c:when>
															<c:when test="${app.method eq 'TEXT'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/mobile100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>문자
																		접수 안내</span></li>
															</c:when>
														</c:choose>
													</c:forEach>
												</ul>
											</div>
										</div>

										<div class="share-section">
											<h4>Share Article</h4>
											<div class="social-links mt-2">
												<div class="d-flex gap-2">
													<button type="button" class="btn btn-secondary"
														onclick="location.href='/recruitmentnotice/listAll'">목록으로</button>
													<button type="button" class="btn btn-primary"
														onclick="location.href='/recruitmentnotice/modify?uid=${RecruitmentDetailInfo.uid}'">수정</button>
													<button type="button" class="btn btn-danger"
														onclick="deleteRecruitment('${RecruitmentDetailInfo.uid}')">삭제</button>
												</div>
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


	<!-- 접수 방법 모달 -->
	<div class="modal fade" id="contactModal" tabindex="-1"
		aria-labelledby="contactModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="contactModalLabel">접수 방법</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>
				<div class="modal-body" id="contactModalBody">
					<!-- 여기에 내용이 동적으로 삽입됩니다 -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
