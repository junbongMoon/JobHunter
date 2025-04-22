<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="UTF-8">
			<title>이력서 목록</title>
			<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
			<!-- Bootstrap JS -->
			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
			<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
			<style>
				.resume-card {
					border: 1px solid #e4e4e4;
					border-radius: 12px;
					margin-bottom: 20px;
					box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
					transition: all 0.3s ease;
					background: #fff;
					padding: 25px;
					display: flex;
					flex-direction: column;
					height: 100%;
					min-height: 350px;
				}

				.resume-card:hover {
					transform: translateY(-5px);
					box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
				}

				.row {
					display: flex;
					flex-wrap: wrap;
					margin-right: -15px;
					margin-left: -15px;
				}

				.col-lg-6 {
					padding: 15px;
					height: 100%;
				}

				.resume-title {
					color: var(- -heading-color, #37517e);
					font-size: 1.5rem;
					font-weight: 600;
					margin-bottom: 15px;
					flex: 0 0 auto;
					white-space: nowrap;
					overflow: hidden;
					text-overflow: ellipsis;
					max-width: 90%;
					display: block;
				}

				.resume-info {
					margin-bottom: 10px;
					flex: 1 1 auto;
				}

				.info-item {
					margin-bottom: 20px;
				}

				.info-label {
					color: #6c757d;
					font-size: 0.875rem;
					margin-bottom: 8px;
					display: block;
					font-weight: 600;
				}

				.info-values {
					display: flex;
					flex-wrap: wrap;
					gap: 8px;
					min-height: 35px;
					align-items: flex-start;
					max-height: 80px;
					overflow: hidden;
					position: relative;
				}

				.info-value {
					color: #2c3e50;
					font-weight: 500;
					background-color: #f8f9fa;
					padding: 6px 12px;
					border-radius: 20px;
					font-size: 0.9rem;
					line-height: 1.4;
					white-space: nowrap;
					max-width: 200px;
					overflow: hidden;
					text-overflow: ellipsis;
					display: inline-flex;
					align-items: center;
					height: 32px;
					margin-bottom: 4px;
				}

				.more-indicator {
					position: absolute;
					right: 10px;
					bottom: 5px;
					background-color: #f8f9fa;
					padding: 0 5px;
					color: #6c757d;
					font-size: 0.9rem;
					border-radius: 25px;
				}

				.info-empty {
					color: #adb5bd;
					font-style: italic;
					font-size: 0.9rem;
					padding: 6px 0;
					height: 32px;
					display: flex;
					align-items: center;
				}

				.action-buttons {
					display: flex;
					gap: 12px;
					margin-top: auto;
					flex: 0 0 auto;
					padding-top: 20px;
					border-top: 1px solid #eee;
				}

				.btn-custom {
					padding: 8px 20px;
					border-radius: 25px;
					font-size: 14px;
					font-weight: 500;
					transition: all 0.3s ease;
					display: flex;
					align-items: center;
					gap: 8px;
					border: none;
					cursor: pointer;
					text-decoration: none;
				}

				.btn-edit {
					background-color: #e3f2fd;
					color: #1976d2;
				}

				.btn-edit:hover {
					background-color: #1976d2;
					color: white;
					transform: translateY(-2px);
				}

				.btn-delete {
					background-color: #ffebee;
					color: #d32f2f;
				}

				.btn-delete:hover {
					background-color: #d32f2f;
					color: white;
					transform: translateY(-2px);
				}

				.btn-create {
					background-color: #37517e;
					color: white;
					padding: 10px 25px;
				}

				.btn-create:hover {
					background-color: #4668a2;
					color: white;
					transform: translateY(-2px);
				}

				.section-header {
					text-align: center;
					margin-bottom: 1rem;
					padding: 30px 0;
				}

				.section-header h2 {
					font-size: 2.5rem;
					font-weight: 600;
					color: #37517e;
					position: relative;
					margin-bottom: 20px;
				}

				.section-header h2:after {
					content: "";
					position: absolute;
					display: block;
					width: 50px;
					height: 3px;
					background: #47b2e4;
					bottom: -15px;
					left: 50%;
					transform: translateX(-50%);
				}

				.section-actions {
					display: flex;
					justify-content: space-between;
					align-items: center;
					margin-bottom: 10px;
				}

				.resume-count {
					display: flex;
					align-items: center;
					gap: 5px;
				}

				.resume-count span {
					font-size: 1.1rem;
					color: #37517e;
					font-weight: 600;
				}

				.resume-count .count {
					background-color: #37517e;
					color: white;
					padding: 2px 10px;
					border-radius: 15px;
					margin-left: 5px;
				}

				.no-resumes {
					text-align: center;
					padding: 40px;
					background: #f8f9fa;
					border-radius: 12px;
					margin: 20px 0;
				}

				.no-resumes p {
					color: #6c757d;
					font-size: 1.1rem;
					margin-bottom: 20px;
				}

				.nameWithGoodDay {
					margin-top: 20px;
				}

				/* 페이지네이션 스타일 */
				.pagination {
					margin: 0;
					padding: 0;
					display: flex;
					justify-content: center;
					align-items: center;
					gap: 5px;
				}

				.pagination .page-item {
					list-style: none;
					margin: 0 2px;
				}

				.pagination .page-link {
					display: flex;
					align-items: center;
					justify-content: center;
					min-width: 40px;
					height: 40px;
					padding: 0 12px;
					border-radius: 8px;
					background-color: #fff;
					color: #37517e;
					font-weight: 500;
					text-decoration: none;
					border: 1px solid #e4e4e4;
					transition: all 0.3s ease;
				}

				.pagination .page-link:hover {
					background-color: #f8f9fa;
					color: #47b2e4;
					border-color: #47b2e4;
					transform: translateY(-2px);
				}

				.pagination .page-item.active .page-link {
					background-color: #37517e;
					color: #fff;
					border-color: #37517e;
				}

				.pagination .page-item:first-child .page-link,
				.pagination .page-item:last-child .page-link {
					padding: 0 15px;
					font-size: 1.2rem;
				}

				.pagination .page-item.disabled .page-link {
					background-color: #f8f9fa;
					color: #adb5bd;
					border-color: #e4e4e4;
					cursor: not-allowed;
					transform: none;
				}

				.pagination .page-item.disabled .page-link:hover {
					background-color: #f8f9fa;
					color: #adb5bd;
					border-color: #e4e4e4;
				}

				.btn-search {
					background-color: #f8f9fa;
					color: #37517e;
					border: 1px solid #37517e;
					transition: all 0.3s ease;
				}

				.btn-search:hover {
					background-color: #37517e;
					color: white;
					transform: translateY(-2px);
				}

				.search-area {
					transition: all 0.3s ease;
					overflow: hidden;
				}

				.search-area .card {
					border-color: #e4e4e4;
					box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
				}

				.search-area input {
					border-color: #e4e4e4;
				}

				.search-area input:focus {
					border-color: #47b2e4;
					box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.25);
				}

				.search-area button {
					min-width: 100px;
				}

				.searchBtn {
					background-color: #37517e !important;
					color: white !important;
					border: none !important;
				}

				.searchBtn:hover {
					background-color: #47b2e4 !important;
					color: white !important;
					border: none !important;
				}
			</style>
		</head>

		<body>
			<!-- 헤더 -->
			<jsp:include page="/WEB-INF/views/header.jsp" />

			<!-- 이력서 Section -->
			<section id="team" class="team section">
				<div class="container">
					<!-- Section Title -->
					<div class="section-header">
						<h2>이력서 목록</h2>
						<div class="nameWithGoodDay">
							<h4>${account.accountName}님의하루를응원합니다!</h4>
						</div>
					</div>
					<!-- End Section Title -->

					<!-- Section Actions -->
					<div class="section-actions">
						<div class="resume-count">
							<span>내 이력서</span> <span class="count">${totalResumes}건</span>
						</div>
						<div class="d-flex gap-2">
							<button id="searchToggleBtn" class="btn-custom btn-search">
								<i class="fas fa-search"></i> 검색
							</button>
							<a href="/resume/form" class="btn-custom btn-create"> <i class="fas fa-plus"></i> 새 이력서 작성
							</a>
						</div>
					</div>

					<!-- 검색 영역 -->
					<div id="searchArea" class="search-area mb-4" style="display: none;">
						<div class="card">
							<div class="card-body">
								<form id="searchForm" action="/resume/list" method="get" class="d-flex gap-2">
									<input type="hidden" name="page" value="1"> <input type="hidden" name="pageSize"
										value="${pageSize}">
									<div class="flex-grow-1">
										<input type="text" name="searchTitle" class="form-control"
											placeholder="이력서 제목을 입력하세요" value="${param.searchTitle}">
									</div>
									<button type="submit" class="btn btn-primary searchBtn">
										<i class="fas fa-search"></i> 검색
									</button>
									<button type="button" class="btn btn-secondary" onclick="clearSearch()">
										<i class="fas fa-times"></i> 초기화
									</button>
								</form>
							</div>
						</div>
					</div>
					<!-- End Section Actions -->

					<div class="row">
						<c:choose>
							<c:when test="${empty resumeList}">
								<div class="no-resumes">
									<p>아직 작성된 이력서가 없습니다.</p>
									<a href="/resume/form" class="btn-custom btn-create"> <i class="fas fa-plus"></i> 첫
										이력서 작성하기
									</a>
								</div>
							</c:when>
							<c:otherwise>
								<c:forEach items="${resumeList}" var="resume">
									<div class="col-lg-6">
										<div class="resume-card">
											<h3 class="resume-title">${resume.title}</h3>
											<div class="resume-info">
												<div class="info-item">
													<span class="info-label">희망근무지역</span>
													<div class="info-values">
														<c:choose>
															<c:when test="${empty resume.sigunguList}">
																<span class="info-empty">등록된 희망근무지역이 없습니다</span>
															</c:when>
															<c:otherwise>
																<c:forEach items="${resume.sigunguList}" var="sigungu"
																	varStatus="status">
																	<c:if test="${status.index < 4}">
																		<span class="info-value">${sigungu.regionName}
																			${sigungu.name}</span>
																	</c:if>
																	<c:if test="${status.index == 4}">
																		<span class="more-indicator">...</span>
																	</c:if>
																</c:forEach>
															</c:otherwise>
														</c:choose>
													</div>
												</div>
												<div class="info-item">
													<span class="info-label">희망 업직종</span>
													<div class="info-values">
														<c:choose>
															<c:when test="${empty resume.subcategoryList}">
																<span class="info-empty">등록된 희망업직종이 없습니다</span>
															</c:when>
															<c:otherwise>
																<c:forEach items="${resume.subcategoryList}"
																	var="subcategory" varStatus="status">
																	<c:if test="${status.index < 4}">
																		<span class="info-value">
																			${subcategory.jobName}</span>
																	</c:if>
																	<c:if test="${status.index == 4}">
																		<span class="more-indicator">...</span>
																	</c:if>
																</c:forEach>
															</c:otherwise>
														</c:choose>
													</div>
												</div>
												<small class="text-muted">최종수정일 :
													${resume.regDate.substring(0,4)}년
													${resume.regDate.substring(5,7)}월
													${resume.regDate.substring(8,10)}일</small>
											</div>
											<div class="action-buttons">
												<!-- 첨삭 테스트용 버튼 -->
												<!-- 멘토 첨삭 기능 하는데 로그인 uid랑 resume.userUid가 다르면 readonly 붙음 -->
												<a href="/resume/advice/${resume.resumeNo}" class="btn-custom btn-edit">
													<i class="fas fa-edit"></i>
													첨삭 작성 하기 (멘토)
												</a>
												<!-- 멘티 첨삭 기능 하는데 로그인 uid랑 resume.userUid가 같으면 수정까지 가능 
												만약 다르다면 첨삭 부분만 수정 가능-->
												<a href="/resume/checkAdvice/${resume.resumeNo}"
													class="btn-custom btn-edit">
													<i class="fas fa-edit"></i>
													첨삭 조회 하기 (멘티&멘토) + 수정까지
												</a>
												<!-- 첨삭 제출 페이지 -->
												<a href="/submission/adCheck/?uid=1"
													class="btn-custom btn-edit">
													<i class="fas fa-edit"></i>
													첨삭 제출
												</a>
												<c:choose>
													<c:when test="${resume.checked}">
														<button type="button" class="btn-custom btn-edit"
															onclick="showCheckedResumeModal('수정')">
															<i class="fas fa-edit"></i> 수정하기
														</button>
														<button type="button" class="btn-custom btn-delete"
															onclick="showCheckedResumeModal('삭제')">
															<i class="fas fa-trash"></i> 삭제하기
														</button>
													</c:when>
													<c:when test="${resume.advice}">
														<button type="button" class="btn-custom btn-edit"
															onclick="showAdviceResumeModal('수정')">
															<i class="fas fa-edit"></i> 수정하기
														</button>
														<button type="button" class="btn-custom btn-delete"
															onclick="showAdviceResumeModal('삭제')">
															<i class="fas fa-trash"></i> 삭제하기
														</button>
													</c:when>
													<c:otherwise>
														<a href="/resume/edit/${resume.resumeNo}"
															class="btn-custom btn-edit"> <i class="fas fa-edit"></i>
															수정하기
														</a>
														<button type="button" class="btn-custom btn-delete"
															onclick="deleteResume(${resume.resumeNo})">
															<i class="fas fa-trash"></i> 삭제하기
														</button>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</div>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</section>

			<!-- 페이지네이션 -->
			<c:if test="${totalPages > 1}">
				<div class="container mt-1 mb-5">
					<nav aria-label="Page navigation">
						<ul class="pagination">
							<!-- 이전 블록으로 이동 -->
							<c:if test="${currentBlock > 1}">
								<li class="page-item"><a class="page-link"
										href="/resume/list?page=${startPage - 1}&pageSize=${pageSize}&searchTitle=${param.searchTitle}"
										aria-label="Previous Block"> <i class="fas fa-angle-double-left"></i>
									</a></li>
							</c:if>

							<!-- 이전 페이지로 이동 -->
							<c:if test="${currentPage > 1}">
								<li class="page-item"><a class="page-link"
										href="/resume/list?page=${currentPage - 1}&pageSize=${pageSize}&searchTitle=${param.searchTitle}"
										aria-label="Previous"> <i class="fas fa-chevron-left"></i>
									</a></li>
							</c:if>

							<!-- 페이지 번호 -->
							<c:forEach begin="${startPage}" end="${endPage}" var="i">
								<li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link"
										href="/resume/list?page=${i}&pageSize=${pageSize}&searchTitle=${param.searchTitle}">${i}</a>
								</li>
							</c:forEach>

							<!-- 다음 페이지로 이동 -->
							<c:if test="${currentPage < totalPages}">
								<li class="page-item"><a class="page-link"
										href="/resume/list?page=${currentPage + 1}&pageSize=${pageSize}&searchTitle=${param.searchTitle}"
										aria-label="Next"> <i class="fas fa-chevron-right"></i>
									</a></li>
							</c:if>

							<!-- 다음 블록으로 이동 -->
							<c:if test="${currentBlock < totalBlocks}">
								<li class="page-item"><a class="page-link"
										href="/resume/list?page=${endPage + 1}&pageSize=${pageSize}&searchTitle=${param.searchTitle}"
										aria-label="Next Block"> <i class="fas fa-angle-double-right"></i>
									</a></li>
							</c:if>
						</ul>
					</nav>
				</div>
			</c:if>

			<!-- 재사용 공용 경고 모달창 -->
			<div class="modal fade" id="validationModal" tabindex="-1" aria-labelledby="validationModalLabel"
				aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content text-center">
						<div class="modal-body">
							<p id="validationMessage" class="mb-3">알림 메시지</p>
							<div class="d-flex justify-content-center gap-2">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
								<button type="button" class="btn btn-primary" id="validationCheckBtn">확인</button>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- 결과 알림 모달창 -->
			<div class="modal fade" id="resultModal" tabindex="-1" aria-labelledby="resultModalLabel"
				aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content text-center">
						<div class="modal-body">
							<p id="resultMessage" class="mb-3">알림 메시지</p>
							<button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>

			<script>
				let currentResumeNo = null;

				function deleteResume(resumeNo) {
					currentResumeNo = resumeNo;
					$('#validationMessage').text('정말로 이 이력서를 삭제하시겠습니까?');
					$('#validationCheckBtn').text('삭제');
					$('#validationCheckBtn').off('click').on('click', function () {
						$.ajax({
							url: '/resume/delete/' + currentResumeNo,
							type: 'DELETE',
							success: function (response) {
								$('#validationModal').modal('hide');
								$('#resultMessage').text('이력서가 성공적으로 삭제되었습니다.');
								$('#resultModal').on('hidden.bs.modal', function () {
									location.reload();
								});
								$('#resultModal').modal('show');
							},
							error: function (xhr, status, error) {
								$('#validationModal').modal('hide');
								$('#resultMessage').text('이력서 삭제 중 오류가 발생했습니다.');
								$('#resultModal').modal('show');
							}
						});
					});
					$('#validationModal').modal('show');
				}


				function showCheckedResumeModal(action) {
					const message = action === '수정'
						? '기업에서 확인중인 이력서는 수정할 수 없습니다.'
						: '기업에서 확인중인 이력서는 삭제할 수 없습니다.';

					$('#resultMessage').text(message);
					$('#resultModal').modal('show');
				}

				function showAdviceResumeModal(action) {
					const message = action === '수정'
						? '이력서 첨삭 중인 이력서는 수정할 수 없습니다.'
						: '이력서 첨삭 중인 이력서는 삭제할 수 없습니다.';

					$('#resultMessage').text(message);
					$('#resultModal').modal('show');
				}
				
				$(document).ready(function () {
					// 검색 영역 토글
					$('#searchToggleBtn').click(function () {
						$('#searchArea').slideToggle(300);
					});

					// URL에 검색 파라미터가 있으면 검색 영역 표시
					if ('${param.searchTitle}') {
						$('#searchArea').show();
					}
				});

				// 검색 초기화
				function clearSearch() {
					// 검색어 입력창 초기화
					$('input[name="searchTitle"]').val('');
					// 검색 영역 숨기기
					$('#searchArea').slideUp(300);
					// 검색 결과 초기화를 위해 폼 제출
					$('#searchForm').submit();
				}
			</script>

			<!-- 풋터 -->
			<jsp:include page="/WEB-INF/views/footer.jsp" />

		</body>

		</html>