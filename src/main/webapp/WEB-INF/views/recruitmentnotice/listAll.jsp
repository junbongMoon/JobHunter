<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>

</script>

<style>
	  :root {
    --primary-color: #47b2e4;
    --secondary-color: #3d4d6a;
    --text-color: #444444;
    --light-bg: #f3f5fa;
    --border-color: #e1e1e1;
  }

  body {
    background-color: var(--light-bg);
    color: var(--text-color);
  }

  .form-header {
    background: white;
    padding: 2rem;
    border-radius: 15px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
    margin-bottom: 2rem;
  }

  .form-header h3 {
    color: var(--secondary-color);
    font-weight: 700;
    margin-bottom: 1rem;
  }

  .form-header p {
    color: var(--text-color);
    margin-bottom: 0;
  }

  .form-section {
    background: white;
    padding: 2rem;
    border-radius: 15px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
    margin-bottom: 2rem;
  }
  
  .custom-select-wrapper label {
    color: var(--secondary-color);
    font-weight: 600;
    margin-bottom: 0.8rem;
  }

  .form-select, .form-control {
    border: 2px solid var(--border-color);
    border-radius: 8px;
    padding: 0.8rem 1rem;
    transition: all 0.3s ease;
  }

  .form-select:focus, .form-control:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.25);
  }

  .form-check-input:checked {
    background-color: var(--primary-color);
    border-color: var(--primary-color);
  }

  .form-check-label {
    color: var(--secondary-color);
    font-weight: 500;
	font-weight: 500;
  }

  .input-group {
    margin-bottom: 1.5rem;
  }
  .input-group label {
    color: var(--secondary-color);
    font-weight: 600;
    margin-bottom: 0.8rem;
  }

  .btn-primary {
    background-color: var(--primary-color);
    border-color: var(--primary-color);
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
  }

  .btn-primary:hover {
    background-color: #3a9fd1;
    border-color: #3a9fd1;
    transform: translateY(-2px);
  }

  .btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
  }

  .btn-danger:hover {
    background-color: #c82333;
    border-color: #bd2130;
    transform: translateY(-2px);
  }

  .fileUploadArea {
    border: 2px dashed var(--border-color);
    background-color: white;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }

  .fileUploadArea label {
    color: var(--secondary-color);
    font-weight: 500;
  }

  .preview {
    background: white;
    padding: 1rem;
    border-radius: 8px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
  }

  .preview img {
    max-width: 100px;
    border-radius: 5px;
  }

  .modal-content {
    border-radius: 15px;
    border: none;
  }

  .modal-header {
    background-color: var(--primary-color);
    color: white;
    border-radius: 15px 15px 0 0;
  }

  .modal-title {
    font-weight: 600;
  }

  .btn-close {
    color: white;
  }

  .advantageArea {
    background: white;
    padding: 1rem;
    border-radius: 8px;
    margin-top: 1rem;
  }

  .advantage-item {
    background: var(--light-bg);
    padding: 0.8rem;
    border-radius: 8px;
    margin-bottom: 0.5rem;
  }

  .addAdvantageBtn {
    background-color: var(--primary-color);
    color: white;
    border: none;
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
  }

  .addAdvantageBtn:hover {
    background-color: #3a9fd1;
    transform: translateY(-2px);
  }

  #summernote {
    border: 2px solid var(--border-color);
    border-radius: 8px;
  }

  .note-editor.note-frame {
    border: none !important;
  }

  .note-editor.note-frame .note-editing-area .note-editable {
    background-color: white;
    color: var(--text-color);
  }

  .note-editor.note-frame .note-toolbar {
    background-color: var(--light-bg);
    border-bottom: 2px solid var(--border-color);
  }

  .note-editor.note-frame .note-statusbar {
    background-color: var(--light-bg);
  }

  .badge-custom {
  background-color: #3d4d6a;
  color: white;
  font-size: 0.85rem;
  padding: 0.45em 0.8em;
  border-radius: 1rem;
  display: inline-block;
  font-weight: 500;
  margin-right: 0.3rem;
  margin-bottom: 0.3rem;
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

							</select>
						</div>

						<div class="col-md-6" id="keywordBox">
								<input type="text" name="searchWord" class="form-control"
									   placeholder="검색어를 입력하세요"
									   value="${param.searchWord}" />
							
						</div>

						<div class="col-md-3 text-end">
							<button type="submit" class="btn btn-primary" style="background-color: #47b2e4;">검색</button>
						</div>

						<div class="col-md-3">
							<label class="form-label">정렬 기준</label><br>
							<div class="form-check form-check-inline">
							  <input class="form-check-input" type="radio" name="sortOption" id="sortHigh" value="highPay"
								${param.sortOption == 'highPay' ? 'checked' : ''}>
							  <label class="form-check-label" for="sortHigh">높은 금액 순</label>
							</div>
							<div class="form-check form-check-inline">
							  <input class="form-check-input" type="radio" name="sortOption" id="sortLow" value="lowPay"
								${param.sortOption == 'lowPay' ? 'checked' : ''}>
							  <label class="form-check-label" for="sortLow">낮은 금액 순</label>
							</div>

							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="sortOption" id="sortdeudate" value="deadlineSoon"
								  ${param.sortOption == 'lowPay' ? 'checked' : ''}>
								<label class="form-check-label" for="sortdeudate">마감기한 임박</label>
							  </div>
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
												value="${rec.region.name}" default="-" /></span> <strong>시군구 </strong>
										<span class="badge bg-info me-2"><c:out
												value="${rec.sigungu.name}" default="-" /></span> <br /> <strong>산업군 </strong>
										<span class="badge bg-success me-2"><c:out
												value="${rec.majorCategory.jobName}" default="-" /></span> <strong>직업 </strong>
										<span class="badge bg-warning text-dark me-2"><c:out
												value="${rec.subcategory.jobName}" default="-" /></span> <br /> <strong>우대조건 </strong>
										<c:forEach var="adv" items="${rec.advantage}"
											varStatus="status">
											<c:if test="${status.index < 2}">
												<span class="badge bg-danger me-2">${adv.advantageType}</span>
											</c:if>
										</c:forEach>
										<br /> <strong>면접방식 </strong>
										<c:forEach var="app" items="${rec.application}"
											varStatus="status">
											<c:if test="${status.index < 2}">
												<span class="badge bg-secondary me-2">${app.method}</span>
											</c:if>
										</c:forEach>
									</p>

									<div class="read-more">

										<a href="/recruitmentnotice/detail/?uid=${rec.uid}">조회하기</a>
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