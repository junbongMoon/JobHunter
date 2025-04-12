<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	
	// 현재 페이지
	let currentPage = 1;
	let isLoading = false;
	let lastPage = false;

	const target = document.querySelector('#observeTarget');

	const observer = new IntersectionObserver((entries) => {
	if (entries[0].isIntersecting && !isLoading && !lastPage) {
		isLoading = true;
		$('#loadingIndicator').show();
		loadMore();
	}
	}, {
	threshold: 1.0 // 타겟 요소가 100% 화면에 들어오면 실행
	});

	observer.observe(target);

	function loadMore() {
	currentPage++; // 페이지 증가

	$.ajax({
		url: "/recruitmentnotice/listMore",
		type: "GET",
		data: {
		pageNo: currentPage,
		searchType: "${param.searchType}",
		searchWord: "${param.searchWord}",
		sortOption: "${param.sortOption}"
		},
		success: function (data) {
		if (data.trim() === "") {
			lastPage = true;
			$('#loadingIndicator').text("더 이상 불러올 데이터가 없습니다.");
			observer.unobserve(target); // 타겟 감시 해제
			return;
		}

		$('.recruitmentContainer').append(data);
		},
		error: function () {
		console.error("불러오기 실패");
		},
		complete: function () {
		isLoading = false;
		$('#loadingIndicator').hide();
		}
	});
	}

</script>

<style>
	.search-bar {
	width: 100%;
	max-width: 100%;
	padding: 1rem 0;
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

	.form-control,
	.form-select {
	height: 50px;
	font-size: 1rem;
	border-radius: 12px;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
	padding: 0.8rem 1.2rem;
	}

	.form-select {
	appearance: none;
	background-color: #ffffff;
	border: 2px solid var(--secondary-color);
	border-radius: 12px;
	padding: 1rem 1.5rem;
	font-size: 1.05rem;
	color: var(--secondary-color);
	font-weight: 500;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
	background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='%233d4d6a' viewBox='0 0 16 16'%3E%3Cpath d='M1.5 5.5l6 6 6-6'/%3E%3C/svg%3E");
	background-repeat: no-repeat;
	background-position: right 1.2rem center;
	background-size: 18px 18px;
	transition: border-color 0.3s ease;
	}

	.form-select:focus {
	border-color: var(--primary-color);
	outline: none;
	}

	.form-check-input[type="radio"] {
	appearance: none;
	width: 18px;
	height: 18px;
	border: 2px solid #3d4d6a;
	border-radius: 50%;
	position: relative;
	margin-top: 0.1rem;
	margin-right: 0.5rem;
	cursor: pointer;
	transition: all 0.2s ease;
	}

	.form-check-input[type="radio"]:checked {
	background-color: #3d4d6a;
	box-shadow: 0 0 0 2px white inset;
	}

	.form-check-label {
	font-weight: 500;
	color: #3d4d6a;
	margin-right: 1.2rem;
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

	.serchBtn {
	height: 56px;
	width: 90%;
	padding: 0.75rem 1.5rem;
	font-size: 1.05rem;
	font-weight: 600;
	color: #ffffff;
	background: linear-gradient(135deg, #3a9fd1, #2e6fa9);
	border: none;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(58, 159, 209, 0.25);
	transition: all 0.3s ease;
	}

	.serchBtn:hover {
	background: linear-gradient(135deg, #345f8c, #264f75);
	box-shadow: 0 6px 16px rgba(46, 111, 169, 0.35);
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

	.form-control {
	border: 2px solid var(--secondary-color);
	border-radius: 12px;
	padding: 1rem 1.5rem;
	font-size: 1.05rem;
	color: var(--secondary-color);
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	transition: border-color 0.3s ease;
	}

	.form-control::placeholder {
	color: #888;
	font-weight: 400;
	}

	.form-control:focus {
	border-color: var(--primary-color);
	box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.15);
	}

	.badge-custom {
	background-color: #f5f8fc;
	color: #2c3e50;
	border: 1px solid #cfd8e3;
	font-size: 0.85rem;
	padding: 0.4em 0.9em;
	border-radius: 1.2rem;
	display: inline-block;
	font-weight: 500;
	margin: 0.2rem 0.3rem 0.2rem 0;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
	}

	.large-radio {
	width: 20px;
	height: 20px;
	margin-right: 0.5rem;
	border: 2px solid #3d4d6a;
	border-radius: 50%;
	appearance: none;
	position: relative;
	cursor: pointer;
	transition: all 0.3s ease;
	}

	.large-radio:checked {
	background-color: #3d4d6a;
	box-shadow: 0 0 0 3px white inset;
	}

	.read-more a{
		background: linear-gradient(135deg, #3a9fd1, #2e6fa9);
	}

	.sort-label {
	font-size: 1.25rem;
	font-weight: 700;
	color: #3d4d6a;
	}

		.pagination .page-link {
	color: #3d4d6a !important;
	background-color: #fff !important;
	border: 1px solid #dee2e6 !important;
	border-radius: 0.4rem !important;
	font-weight: 500 !important;
	transition: all 0.3s ease;
	}

	.pagination .page-link:hover {
	background-color: #e6f3fb !important;
	color: #3a9fd1 !important;
	border-color: #3a9fd1 !important;
	}

	.pagination .page-item.active .page-link {
	background-color: #3a9fd1 !important;
	color: white !important;
	border-color: #3a9fd1 !important;
	font-weight: bold !important;
	}

	.pagination .page-item.disabled .page-link {
	background-color: #f9f9f9 !important;
	color: #ccc !important;
	pointer-events: none;
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
				<form action="/recruitmentnotice/listAll" method="get" class="search-bar mb-4">
					<div class="d-flex flex-wrap align-items-center gap-3 w-100">
						
						<div class="sort-options" style="flex-basis: 25%;">
							<label class="form-label sort-label d-block mb-2">정렬 기준</label>

							<div class="form-check form-check-inline">
							  <input class="form-check-input large-radio" type="radio" name="sortOption" id="sortHigh" value="highPay"
								${param.sortOption == 'highPay' ? 'checked' : ''}>
							  <label class="form-check-label" for="sortHigh">높은 금액 순</label>
							</div>
							<div class="form-check form-check-inline">
							  <input class="form-check-input large-radio" type="radio" name="sortOption" id="sortLow" value="lowPay"
								${param.sortOption == 'lowPay' ? 'checked' : ''}>
							  <label class="form-check-label" for="sortLow">낮은 금액 순</label>
							</div>
							<div class="form-check form-check-inline">
							  <input class="form-check-input large-radio" type="radio" name="sortOption" id="sortdeudate" value="deadlineSoon"
								${param.sortOption == 'deadlineSoon' ? 'checked' : ''}>
							  <label class="form-check-label" for="sortdeudate">마감기한 임박</label>
							</div>
						  </div>
					  

						<!-- 검색 조건 선택 -->
						<div class="flex-grow-1" style="flex-basis: 25%;">
							<select class="form-select w-100" name="searchType" id="searchType">
							<option value="">검색 조건 없음</option>
							<option value="region" ${param.searchType == 'region' ? 'selected' : ''}>지역</option>
							<option value="jobType" ${param.searchType == 'jobType' ? 'selected' : ''}>직업군</option>
							<option value="advantage" ${param.searchType == 'advantage' ? 'selected' : ''}>우대조건</option>
							<option value="jobform" ${param.searchType == 'jobform' ? 'selected' : ''}>근무형태</option>
							</select>
						</div>

						<!-- 키워드 입력 -->
						<div class="flex-grow-1" style="flex-basis: 55%;">
							<input type="text" name="searchWord" class="form-control w-100"
								placeholder="검색어를 입력하세요"
								value="${param.searchWord}" />
						</div>
					
						<!-- 검색 버튼 -->
						<div class="flex-grow-1 text-end" style="flex-basis: 20%;">
							<button type="submit" class="btn serchBtn w-100">검색</button>
						</div>
  

					</div>
				</form>
				<div class="row gy-4 gx-4 recruitmentContainer">

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
													<fmt:formatDate value="${rec.regDate}" pattern="yyyy-MM-dd" />
												</time></a></li>
									</ul>
								</div>

								<div class="content recruitmentList">
									<p class="rectext">
										<span class="badge-custom">${rec.region.name}</span>
										<span class="badge-custom">${rec.sigungu.name}</span>
										<span class="badge-custom">${rec.majorCategory.jobName}</span>
										<span class="badge-custom">${rec.subcategory.jobName}</span>
										<c:forEach var="adv" items="${rec.advantage}" varStatus="status">
										  <c:if test="${status.index < 2}">
											<span class="badge-custom">${adv.advantageType}</span>
										  </c:if>
										</c:forEach>
										<c:forEach var="app" items="${rec.application}" varStatus="status">
										  <c:if test="${status.index < 2}">
											<span class="badge-custom">${app.method}</span>
										  </c:if>
										</c:forEach>
									</p>

									<div class="read-more">

										<a href="/recruitmentnotice/detail/?uid=${rec.uid}" >조회하기</a>
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