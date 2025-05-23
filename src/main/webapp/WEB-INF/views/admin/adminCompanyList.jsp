<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
			<!DOCTYPE html>
			<html lang="en">

			<head>
				<meta charset="UTF-8">
				<title>관리자 페이지</title>
				<!-- Bootstrap CSS -->
				<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
				<!-- Font Awesome -->
				<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
					rel="stylesheet">
				<style>
					.search-container {
						margin-bottom: 20px;
					}

					.pagination {
						margin-top: 20px;
						justify-content: center;
					}

					.table th {
						background-color: #f8f9fc;
					}
				</style>
			</head>

			<body id="page-top">
				<!-- 헤더 포함 (네비게이션바 + 사이드바 포함) -->
				<jsp:include page="adminheader.jsp"></jsp:include>

				<!-- 본문 내용 -->
				<div class="container-fluid">
					<h1 class="h3 mb-4 text-gray-800">기업 유저</h1>

					<!-- 검색 영역 -->
					<div class="search-container">
						<form action="/admin/companyList" method="get" class="row g-3">
							<div class="col-auto">
								<select name="searchType" class="form-select">
									<option value="companyName" ${param.searchType=='companyName' ? 'selected' : '' }>
										기업명</option>
									<option value="companyId" ${param.searchType=='companyId' ? 'selected' : '' }>기업 ID
									</option>
									<option value="email" ${param.searchType=='email' ? 'selected' : '' }>이메일</option>
									<option value="mobile" ${param.searchType=='mobile' ? 'selected' : '' }>전화번호
									</option>
								</select>
							</div>
							<div class="col-auto">
								<input type="text" name="searchKeyword" class="form-control"
									value="${param.searchKeyword}" placeholder="검색어를 입력하세요">
							</div>
							<div class="col-auto">
								<button type="submit" class="btn btn-primary">검색</button>
							</div>
							<!-- 검색 초기화 -->
							<div class="col-auto">
								<button type="button" class="btn btn-secondary" onclick="resetSearch()">초기화</button>
							</div>
							<!-- 상태 필터 라디오 버튼 추가 -->
							<div class="mt-3 d-flex align-items-center">
								<strong class="me-3">상태 필터:</strong>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="statusFilter" id="statusAll"
										value="all" ${param.statusFilter=='all' || param.statusFilter==null ? 'checked'
										: '' } onchange="filterByStatus(this.value)">
									<label class="form-check-label" for="statusAll">전체</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="statusFilter" id="statusNormal"
										value="normal" ${param.statusFilter=='normal' ? 'checked' : '' }
										onchange="filterByStatus(this.value)">
									<label class="form-check-label" for="statusNormal">정상</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="statusFilter" id="statusBlocked"
										value="blocked" ${param.statusFilter=='blocked' ? 'checked' : '' }
										onchange="filterByStatus(this.value)">
									<label class="form-check-label" for="statusBlocked">정지</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="statusFilter"
										id="statusPendingDelete" value="pending_delete"
										${param.statusFilter=='pending_delete' ? 'checked' : '' }
										onchange="filterByStatus(this.value)">
									<label class="form-check-label" for="statusPendingDelete">삭제예정</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="statusFilter"
										id="statusRequiresVerification" value="requires_verification"
										${param.statusFilter=='requires_verification' ? 'checked' : '' }
										onchange="filterByStatus(this.value)">
									<label class="form-check-label" for="statusRequiresVerification">인증필요</label>
								</div>
							</div>
						</form>
					</div>

					<!-- 기업 목록 카드 -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">목록</h6>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table table-bordered table-hover">
									<thead>
										<tr>
											<th>UID</th>
											<th>기업명</th>
											<th>기업 ID</th>
											<th>사업자번호</th>
											<th>대표자</th>
											<th>이메일</th>
											<th>전화번호</th>
											<th>가입일</th>
											<th>상태</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${companyList}" var="company">
											<tr>
												<td>${company.uid}</td>
												<td>${company.companyName}</td>
												<td>${company.companyId}</td>
												<td>${company.businessNum}</td>
												<td>${company.representative}</td>
												<td>${company.email}</td>
												<td>${company.mobile}</td>
												<fmt:formatDate value="${company.regDate}" pattern="yyyy-MM-dd"
													var="formattedDate" />
												<td>${formattedDate}</td>
												<td>
													<c:choose>
														<c:when test="${company.blockDeadline != null}">
															<span class="badge bg-danger">정지</span>
														</c:when>
														<c:when test="${company.deleteDeadline != null}">
															<span class="badge bg-warning">삭제예정</span>
														</c:when>
														<c:when test="${company.requiresVerification == 'Y'}">
															<span class="badge bg-info">인증필요</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-success">정상</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<button class="btn btn-info btn-sm"
														onclick="viewCompanyDetail(${company.uid})">
														<i class="fas fa-eye"></i> 상세
													</button>
													<c:if test="${company.blockDeadline == null}">
														<button class="btn btn-danger btn-sm"
															onclick="blockCompany(${company.uid})">
															<i class="fas fa-ban"></i> 정지
														</button>
													</c:if>
													<c:if test="${company.blockDeadline != null}">
														<button class="btn btn-success btn-sm"
															onclick="unblockCompany(${company.uid})">
															<i class="fas fa-check"></i> 해제
														</button>
													</c:if>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>

							<!-- 페이징 -->
							<nav aria-label="Page navigation">
								<ul class="pagination">
									<c:if test="${pagination.prev}">
										<li class="page-item">
											<a class="page-link"
												href="/admin/companyList?page=${pagination.startPage - 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&statusFilter=${param.statusFilter}"
												aria-label="Previous">
												<span aria-hidden="true">&laquo;</span>
											</a>
										</li>
									</c:if>

									<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}"
										var="pageNum">
										<li class="page-item ${pageNum == pagination.currentPage ? 'active' : ''}">
											<a class="page-link"
												href="/admin/companyList?page=${pageNum}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&statusFilter=${param.statusFilter}">${pageNum}</a>
										</li>
									</c:forEach>

									<c:if test="${pagination.next}">
										<li class="page-item">
											<a class="page-link"
												href="/admin/companyList?page=${pagination.endPage + 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}&statusFilter=${param.statusFilter}"
												aria-label="Next">
												<span aria-hidden="true">&raquo;</span>
											</a>
										</li>
									</c:if>
								</ul>
							</nav>
						</div>
					</div>
				</div>

				<!-- 푸터 포함 -->
				<jsp:include page="adminfooter.jsp"></jsp:include>

				<!-- Bootstrap Bundle with Popper -->
				<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

				<!-- 정지 모달 -->
				<div class="modal fade" id="blockCompanyModal" tabindex="-1" aria-labelledby="blockCompanyModalLabel"
					aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="blockCompanyModalLabel">기업 정지</h5>
								<button type="button" class="btn-close" onclick="closeBlockCompanyModal()"
									aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<form id="blockCompanyForm">
									<input type="hidden" id="blockCompanyId" name="uid">
									<div class="mb-3">
										<label class="form-label">정지 기간</label>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="blockDuration"
												id="duration3days" value="3">
											<label class="form-check-label" for="duration3days">3일</label>
										</div>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="blockDuration"
												id="duration7days" value="7">
											<label class="form-check-label" for="duration7days">7일</label>
										</div>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="blockDuration"
												id="duration30days" value="30">
											<label class="form-check-label" for="duration30days">30일</label>
										</div>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="blockDuration"
												id="durationPermanent" value="permanent">
											<label class="form-check-label" for="durationPermanent">영구</label>
										</div>
									</div>
									<div class="mb-3">
										<label for="blockReason" class="form-label">정지 사유</label>
										<textarea class="form-control" id="blockReason" name="reason" rows="3"
											required></textarea>
									</div>
								</form>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary"
									onclick="closeBlockCompanyModal()">취소</button>
								<button type="button" class="btn btn-danger" onclick="submitBlockCompany()">확인</button>
							</div>
						</div>
					</div>
				</div>

				<script>
					// 검색 초기화
					function resetSearch() {
						window.location.href = '/admin/companyList';
					}

					// 상태 필터 적용
					function filterByStatus(status) {
						const currentUrl = new URL(window.location.href);
						currentUrl.searchParams.set('statusFilter', status);
						currentUrl.searchParams.set('page', '1'); // 필터 변경 시 1페이지로 이동
						window.location.href = currentUrl.toString();
					}

					// 기업 상세 정보 보기
					function viewCompanyDetail(uid) {
						window.location.href = '/admin/companyDetail/' + uid;
					}

					let blockCompanyModalInstance = null;
					// 기업 계정 정지 모달 열기
					function blockCompany(uid) {
						document.getElementById('blockCompanyId').value = uid;
						document.getElementById('blockReason').value = '';
						document.querySelector('input[name="blockDuration"][value="3"]').checked = true;

						const modalElement = document.getElementById('blockCompanyModal');
						blockCompanyModalInstance = new bootstrap.Modal(modalElement, {
							backdrop: 'static',
							keyboard: false
						});
						blockCompanyModalInstance.show();
					}

					// 모달 닫기
					function closeBlockCompanyModal() {
						if (blockCompanyModalInstance) {
							blockCompanyModalInstance.hide();
						}
					}

					// 기업 계정 정지 제출
					function submitBlockCompany() {
						const uid = document.getElementById('blockCompanyId').value;
						const duration = document.querySelector('input[name="blockDuration"]:checked').value;
						const reason = document.getElementById('blockReason').value;

						if (!reason) {
							alert('정지 사유를 입력해주세요.');
							return;
						}

						// AJAX로 정지 요청 보내기
						fetch('/admin/blockCompany/' + uid, {
							method: 'POST',
							headers: {
								'Content-Type': 'application/json'
							},
							body: JSON.stringify({
								duration: duration,
								reason: reason
							})
						})
							.then(response => response.json())
							.then(data => {
								if (data.success) {
									alert('기업이 정지되었습니다.');
									location.reload();
								} else {
									alert('기업 정지에 실패했습니다.');
								}
							})
							.catch(error => {
								console.error('Error:', error);
								alert('처리 중 오류가 발생했습니다.');
							});
					}

					// 기업 계정 정지 해제
					function unblockCompany(uid) {
						if (confirm('정말로 이 기업의 정지를 해제하겠습니까?')) {
							// AJAX로 정지 해제 요청 보내기
							fetch('/admin/unblockCompany/' + uid, {
								method: 'POST',
								headers: {
									'Content-Type': 'application/json'
								}
							})
								.then(response => response.json())
								.then(data => {
									if (data.success) {
										alert('기업의 정지가 해제되었습니다.');
										location.reload();
									} else {
										alert('기업 정지 해제에 실패했습니다.');
									}
								})
								.catch(error => {
									console.error('Error:', error);
									alert('처리 중 오류가 발생했습니다.');
								});
						}
					}
				</script>
			</body>

			</html>