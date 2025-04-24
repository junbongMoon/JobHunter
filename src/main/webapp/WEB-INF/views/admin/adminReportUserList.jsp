<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
			<!DOCTYPE html>
			<html lang="en">

			<head>
				<meta charset="UTF-8">
				<title>관리자 페이지 - 사용자 신고 목록</title>
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

					.table-responsive {
						margin-top: 20px;
					}

					.badge {
						font-size: 0.8rem;
					}

					.badge-warning {
						background-color: #ffc107;
						color: #212529;
					}

					.badge-success {
						background-color: #28a745;
						color: #fff;
					}

					.badge-danger {
						background-color: #dc3545;
						color: #fff;
					}

					.badge-info {
						background-color: #17a2b8;
						color: #fff;
					}

					.action-buttons .btn {
						margin-right: 5px;
					}

					.filter-section {
						margin-bottom: 20px;
						padding: 15px;
						background-color: #f8f9fc;
						border-radius: 5px;
					}

					.filter-section .form-group {
						margin-bottom: 10px;
					}

					.report-detail {
						display: none;
						padding: 15px;
						background-color: #f8f9fc;
						border-radius: 5px;
						margin-top: 10px;
					}

					.report-detail.show {
						display: block;
					}

					.report-actions {
						margin-top: 15px;
						padding-top: 15px;
						border-top: 1px solid #dee2e6;
					}
				</style>
			</head>

			<body id="page-top">
				<!-- 헤더 포함 (네비게이션바 + 사이드바 포함) -->
				<jsp:include page="adminheader.jsp"></jsp:include>

				<!-- 메인 콘텐츠 -->
				<div class="container-fluid">
					<div class="row">
						<div class="col-12">
							<h1 class="h3 mb-4 text-gray-800">신고 목록</h1>

							<!-- 필터 섹션 -->
							<div class="filter-section">
								<div class="row">
									<div class="col-md-3">
										<div class="form-group">
											<label for="reportTypeFilter">신고 유형</label>
											<select class="form-control" id="reportTypeFilter" name="reportType">
												<option value="all" ${param.reportType=='all' || empty param.reportType
													? 'selected' : '' }>전체</option>
												<option value="USER" ${param.reportType=='USER' ? 'selected' : '' }>일반
													사용자</option>
												<option value="COMPANY" ${param.reportType=='COMPANY' ? 'selected' : ''
													}>기업</option>
												<option value="BOARD" ${param.reportType=='BOARD' ? 'selected' : '' }>
													게시판</option>
												<option value="RECRUITMENT" ${param.reportType=='RECRUITMENT' ? 'selected'
													: '' }>채용공고</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="readStatusFilter">처리 상태</label>
											<select class="form-control" id="readStatusFilter" name="readStatus">
												<option value="all" ${param.readStatus=='all' || empty param.readStatus
													? 'selected' : '' }>전체</option>
												<option value="Y" ${param.readStatus=='Y' ? 'selected' : '' }>완료
												</option>
												<option value="N" ${param.readStatus=='N' ? 'selected' : '' }>미완료
												</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="categoryFilter">신고 카테고리</label>
											<select class="form-control" id="categoryFilter" name="category">
												<option value="all" ${param.category=='all' || empty param.category
													? 'selected' : '' }>전체</option>
												<option value="SPAM" ${param.category=='SPAM' ? 'selected' : '' }>스팸/광고성
													메시지</option>
												<option value="HARASSMENT" ${param.category=='HARASSMENT' ? 'selected'
													: '' }>욕설/괴롭힘</option>
												<option value="FALSE_INFO" ${param.category=='FALSE_INFO' ? 'selected'
													: '' }>허위 정보</option>
												<option value="ILLEGAL_ACTIVITY" ${param.category=='ILLEGAL_ACTIVITY'
													? 'selected' : '' }>불법 행위</option>
												<option value="INAPPROPRIATE_CONTENT"
													${param.category=='INAPPROPRIATE_CONTENT' ? 'selected' : '' }>부적절한
													프로필/사진</option>
												<option value="MISCONDUCT" ${param.category=='MISCONDUCT' ? 'selected'
													: '' }>부적절한 행동/요구</option>
												<option value="ETC" ${param.category=='ETC' ? 'selected' : '' }>기타 사유
												</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="dateFilter">기간</label>
											<select class="form-control" id="dateFilter" name="dateFilter">
												<option value="all" ${param.dateFilter=='all' || empty param.dateFilter
													? 'selected' : '' }>전체</option>
												<option value="today" ${param.dateFilter=='today' ? 'selected' : '' }>오늘
												</option>
												<option value="week" ${param.dateFilter=='week' ? 'selected' : '' }>이번 주
												</option>
												<option value="month" ${param.dateFilter=='month' ? 'selected' : '' }>이번
													달</option>
											</select>
										</div>
									</div>
								</div>
								<div class="row mt-3">
									<div class="col-12 text-right">
										<button class="btn btn-primary" id="applyFilter">필터 적용</button>
										<button class="btn btn-secondary" id="resetFilter">필터 초기화</button>
									</div>
								</div>
							</div>

							<div class="card shadow mb-4">
								<div class="card-header py-3 d-flex justify-content-between align-items-center">
									<h6 class="m-0 font-weight-bold text-primary">신고 목록</h6>
								</div>
								<div class="card-body">
									<div class="table-responsive">
										<table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
											<thead>
												<tr>
													<th>신고 번호</th>
													<th>신고 유형</th>
													<th>신고 대상</th>
													<th>신고자</th>
													<th>신고 카테고리</th>
													<th>신고 내용</th>
													<th>신고 URL</th>
													<th>처리 여부</th>
													<th>신고 일자</th>
													<th>관리</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach items="${reportList}" var="report">
													<tr data-report-no="${report.reportNo}"
														data-report-type="${report.reportType}"
														data-target-type="${report.targetAccountType}"
														data-read-status="${report.isRead}"
														data-category="${report.reportCategory}"
														data-date="${report.regDate}">
														<td>${report.reportNo}</td>
														<td>
															<c:choose>
																<c:when test="${report.reportType == 'USER'}">
																	<span class="badge badge-info">일반 사용자</span>
																</c:when>
																<c:when test="${report.reportType == 'COMPANY'}">
																	<span class="badge badge-primary">기업</span>
																</c:when>
																<c:when test="${report.reportType == 'BOARD'}">
																	<span class="badge badge-secondary">게시판</span>
																</c:when>
																<c:when test="${report.reportType == 'RECRUITMENT'}">
																	<span class="badge badge-dark">채용공고</span>
																</c:when>
																<c:otherwise>
																	${report.reportType}
																</c:otherwise>
															</c:choose>
														</td>
														<td>
															<c:choose>
																<c:when test="${report.targetAccountType == 'USER'}">
																	<a
																		href="/admin/userDetail/${report.targetAccountUid}?reportNo=${report.reportNo}">일반
																		사용자 (${report.targetAccountUid})</a>
																</c:when>
																<c:when test="${report.targetAccountType == 'COMPANY'}">
																	<a
																		href="/admin/companyDetail/${report.targetAccountUid}?reportNo=${report.reportNo}">기업
																		(${report.targetAccountUid})</a>
																</c:when>
																<c:otherwise>
																	${report.targetAccountType}
																	(${report.targetAccountUid})
																</c:otherwise>
															</c:choose>
														</td>
														<td>일반 사용자 (${report.reporterAccountUid})</td>
														<td>
															<c:choose>
																<c:when test="${report.reportCategory == 'SPAM'}">
																	스팸/광고성 메시지
																</c:when>
																<c:when test="${report.reportCategory == 'HARASSMENT'}">
																	욕설/괴롭힘
																</c:when>
																<c:when test="${report.reportCategory == 'FALSE_INFO'}">
																	허위 정보
																</c:when>
																<c:when
																	test="${report.reportCategory == 'ILLEGAL_ACTIVITY'}">
																	불법 행위
																</c:when>
																<c:when
																	test="${report.reportCategory == 'INAPPROPRIATE_CONTENT'}">
																	부적절한 프로필/사진
																</c:when>
																<c:when test="${report.reportCategory == 'MISCONDUCT'}">
																	부적절한 행동/요구
																</c:when>
																<c:when test="${report.reportCategory == 'ETC'}">
																	기타 사유
																</c:when>
																<c:otherwise>
																	${report.reportCategory}
																</c:otherwise>
															</c:choose>
														</td>
														<td>
															<c:if test="${not empty report.reportMessage}">
																<button class="btn btn-sm btn-link view-message"
																	data-message="${report.reportMessage}">내용
																	보기</button>
															</c:if>
														</td>
														<td>
															<c:if test="${not empty report.reportTargetURL}">
																<a href="${report.reportTargetURL}&reportNo=${report.reportNo}"
																	target="_blank">보기</a>
															</c:if>
														</td>
														<td>
															<c:choose>
																<c:when test="${report.isRead == 'Y'}">
																	<span class="badge badge-success">완료</span>
																</c:when>
																<c:otherwise>
																	<span class="badge badge-warning">미완료</span>
																</c:otherwise>
															</c:choose>
														</td>
														<td>
															<fmt:formatDate value="${report.regDate}"
																pattern="yyyy-MM-dd HH:mm:ss" />
														</td>
														<td class="action-buttons">
															<c:choose>
																<c:when test="${report.targetAccountType == 'USER'}">
																	<button class="btn btn-sm btn-danger block-user"
																		data-uid="${report.targetAccountUid}">
																		<i class="fas fa-ban"></i>
																	</button>
																</c:when>
																<c:when test="${report.targetAccountType == 'COMPANY'}">
																	<button class="btn btn-sm btn-danger block-company"
																		data-uid="${report.targetAccountUid}">
																		<i class="fas fa-ban"></i>
																	</button>
																</c:when>
															</c:choose>
															<button class="btn btn-sm btn-success mark-read"
																data-report-no="${report.reportNo}"
																data-read-status="${report.isRead}">
																<i class="fas fa-check"></i>
															</button>
														</td>
													</tr>
												</c:forEach>
												<c:if test="${empty reportList}">
													<tr>
														<td colspan="10" class="text-center">신고 데이터가 없습니다.</td>
													</tr>
												</c:if>
											</tbody>
										</table>
									</div>
								</div>
							</div>

							<!-- 페이징 -->
							<nav aria-label="Page navigation">
								<ul class="pagination">
									<c:if test="${pagination.prev}">
										<li class="page-item">
											<a class="page-link"
												href="/admin/reportUserList?page=${pagination.startPage - 1}&reportType=${param.reportType}&readStatus=${param.readStatus}&category=${param.category}&dateFilter=${param.dateFilter}"
												aria-label="Previous">
												<span aria-hidden="true">&laquo;</span>
											</a>
										</li>
									</c:if>

									<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}"
										var="pageNum">
										<li class="page-item ${pageNum == pagination.currentPage ? 'active' : ''}">
											<a class="page-link"
												href="/admin/reportUserList?page=${pageNum}&reportType=${param.reportType}&readStatus=${param.readStatus}&category=${param.category}&dateFilter=${param.dateFilter}">${pageNum}</a>
										</li>
									</c:forEach>

									<c:if test="${pagination.next}">
										<li class="page-item">
											<a class="page-link"
												href="/admin/reportUserList?page=${pagination.endPage + 1}&reportType=${param.reportType}&readStatus=${param.readStatus}&category=${param.category}&dateFilter=${param.dateFilter}"
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

				<!-- 정지 모달 -->
				<div class="modal fade" id="blockUserModal" tabindex="-1" aria-labelledby="blockUserModalLabel"
					aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="blockUserModalLabel">유저 정지</h5>
								<button type="button" class="btn-close" onclick="closeBlockUserModal()"
									aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<form id="blockUserForm">
									<input type="hidden" id="blockUserId" name="uid">
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
									onclick="closeBlockUserModal()">취소</button>
								<button type="button" class="btn btn-danger" onclick="submitBlockUser()">확인</button>
							</div>
						</div>
					</div>
				</div>

				<!-- 기업 정지 모달 -->
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
											<input class="form-check-input" type="radio" name="companyBlockDuration"
												id="companyDuration3days" value="3">
											<label class="form-check-label" for="companyDuration3days">3일</label>
										</div>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="companyBlockDuration"
												id="companyDuration7days" value="7">
											<label class="form-check-label" for="companyDuration7days">7일</label>
										</div>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="companyBlockDuration"
												id="companyDuration30days" value="30">
											<label class="form-check-label" for="companyDuration30days">30일</label>
										</div>
										<div class="form-check">
											<input class="form-check-input" type="radio" name="companyBlockDuration"
												id="companyDurationPermanent" value="permanent">
											<label class="form-check-label" for="companyDurationPermanent">영구</label>
										</div>
									</div>
									<div class="mb-3">
										<label for="blockCompanyReason" class="form-label">정지 사유</label>
										<textarea class="form-control" id="blockCompanyReason" name="reason" rows="3"
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

				<!-- 신고 내용 모달 -->
				<div class="modal fade" id="reportMessageModal" tabindex="-1" aria-labelledby="reportMessageModalLabel"
					aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="reportMessageModalLabel">신고 내용</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"></button>
							</div>
							<div class="modal-body">
								<p id="reportMessageContent"></p>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							</div>
						</div>
					</div>
				</div>

				<!-- 푸터 포함 -->
				<jsp:include page="adminfooter.jsp"></jsp:include>

				<!-- Bootstrap Bundle with Popper -->
				<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

				<!-- jQuery -->
				<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

				<script>
					$(document).ready(function () {

						// 상세 정보 닫기 버튼 클릭 이벤트
						$('.close-detail').click(function () {
							const reportNo = $(this).data('report-no');
							$(`#detail-${reportNo}`).hide();
						});

						// 신고 내용 보기 버튼 클릭 이벤트
						$('.view-message').click(function () {
							const message = $(this).data('message');
							$('#reportMessageContent').text(message);
							$('#reportMessageModal').modal('show');
						});

						// 일반 사용자 정지 버튼 클릭 이벤트
						$('.block-user').click(function () {
							const uid = $(this).data('uid');
							$('#blockUserId').val(uid);
							$('#blockUserModal').modal('show');
						});

						// 기업 정지 버튼 클릭 이벤트
						$('.block-company').click(function () {
							const uid = $(this).data('uid');
							$('#blockCompanyId').val(uid);
							$('#blockCompanyModal').modal('show');
						});

						// 읽음 표시 버튼 클릭 이벤트
						$('.mark-read').click(function () {
							const reportNo = $(this).data('report-no');
							const currentStatus = $(this).data('read-status');

							// 현재 상태에 따라 다른 메시지 표시
							if (currentStatus === 'Y') {
								alert('이미 처리되었습니다.');
								return;
							}

							// 확인 대화상자 표시
							if (confirm(`완료 처리 하시겠습니까?`)) {
								$.ajax({
									url: '/admin/updateReportReadStatus',
									type: 'POST',
									data: {
										reportNo: reportNo,
										isRead: 'Y'
									},
									success: function (response) {
										if (response.success) {
											// 상태 변경 성공 시 UI 업데이트
											const row = $(`tr[data-report-no="${reportNo}"]`);
											const statusCell = row.find('td:nth-child(8)');
											statusCell.html('<span class="badge badge-success">완료</span>');

											// 버튼 상태 업데이트
											$('.mark-read').each(function () {
												if ($(this).data('report-no') === reportNo) {
													$(this).data('read-status', 'Y');
												}
											});

											// 페이지 새로고침
											location.reload();
										} else {
											alert('신고 상태 업데이트에 실패했습니다: ' + response.message);
										}
									},
									error: function () {
										alert('서버 오류가 발생했습니다.');
									}
								});
							}
						});

						// 필터 적용 버튼 클릭 이벤트
						$('#applyFilter').click(function () {
							const reportType = $('#reportTypeFilter').val();
							const readStatus = $('#readStatusFilter').val();
							const category = $('#categoryFilter').val();
							const dateFilter = $('#dateFilter').val();

							// 서버에 필터링 요청
							window.location.href = '/admin/reportUserList?reportType=' + reportType +
								'&readStatus=' + readStatus +
								'&category=' + category +
								'&dateFilter=' + dateFilter;
						});

						// 필터 초기화 버튼 클릭 이벤트
						$('#resetFilter').click(function () {
							// 필터 초기화 후 서버에 요청
							window.location.href = '/admin/reportUserList';
						});
					});

					// 사용자 정지 모달 관련 함수
					function closeBlockUserModal() {
						$('#blockUserModal').modal('hide');
					}

					function submitBlockUser() {
						const uid = $('#blockUserId').val();
						const duration = $('input[name="blockDuration"]:checked').val();
						const reason = $('#blockReason').val();

						if (!duration) {
							alert('정지 기간을 선택해주세요.');
							return;
						}

						if (!reason) {
							alert('정지 사유를 입력해주세요.');
							return;
						}

						$.ajax({
							url: '/admin/blockUser/' + uid,
							type: 'POST',
							contentType: 'application/json',
							data: JSON.stringify({
								duration: duration,
								reason: reason
							}),
							success: function (response) {
								if (response.success) {
									alert('사용자가 성공적으로 정지되었습니다.');
									location.reload();
								} else {
									alert('사용자 정지에 실패했습니다: ' + response.message);
								}
							},
							error: function () {
								alert('서버 오류가 발생했습니다.');
							}
						});

						closeBlockUserModal();
					}

					// 기업 정지 모달 관련 함수
					function closeBlockCompanyModal() {
						$('#blockCompanyModal').modal('hide');
					}

					function submitBlockCompany() {
						const uid = $('#blockCompanyId').val();
						const duration = $('input[name="companyBlockDuration"]:checked').val();
						const reason = $('#blockCompanyReason').val();

						if (!duration) {
							alert('정지 기간을 선택해주세요.');
							return;
						}

						if (!reason) {
							alert('정지 사유를 입력해주세요.');
							return;
						}

						$.ajax({
							url: '/admin/blockCompany/' + uid,
							type: 'POST',
							contentType: 'application/json',
							data: JSON.stringify({
								duration: duration,
								reason: reason
							}),
							success: function (response) {
								if (response.success) {
									alert('기업이 성공적으로 정지되었습니다.');
									location.reload();
								} else {
									alert('기업 정지에 실패했습니다: ' + response.message);
								}
							},
							error: function () {
								alert('서버 오류가 발생했습니다.');
							}
						});

						closeBlockCompanyModal();
					}
				</script>
			</body>

			</html>