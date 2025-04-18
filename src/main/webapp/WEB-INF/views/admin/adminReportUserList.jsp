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
							<h1 class="h3 mb-4 text-gray-800">사용자 신고 목록</h1>

							<!-- 필터 섹션 -->
							<div class="filter-section">
								<div class="row">
									<div class="col-md-3">
										<div class="form-group">
											<label for="reportTypeFilter">신고 유형</label>
											<select class="form-control" id="reportTypeFilter">
												<option value="all">전체</option>
												<option value="USER">일반 사용자</option>
												<option value="COMPANY">기업</option>
												<option value="BOARD">게시판</option>
												<option value="RECRUTMENT">채용공고</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="readStatusFilter">읽음 상태</label>
											<select class="form-control" id="readStatusFilter">
												<option value="all">전체</option>
												<option value="Y">읽음</option>
												<option value="N">미읽음</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="categoryFilter">신고 카테고리</label>
											<select class="form-control" id="categoryFilter">
												<option value="all">전체</option>
												<option value="SPAM">스팸</option>
												<option value="ABUSE">욕설/비방</option>
												<option value="INAPPROPRIATE">부적절한 내용</option>
												<option value="FRAUD">사기</option>
												<option value="OTHER">기타</option>
											</select>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="dateFilter">기간</label>
											<select class="form-control" id="dateFilter">
												<option value="all">전체</option>
												<option value="today">오늘</option>
												<option value="week">이번 주</option>
												<option value="month">이번 달</option>
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
									<div>
										<span class="badge badge-warning mr-2">미읽음: <span
												id="unreadCount">0</span></span>
										<span class="badge badge-success">읽음: <span id="readCount">0</span></span>
									</div>
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
													<th>읽음 여부</th>
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
																<c:when test="${report.reportType == 'RECRUTMENT'}">
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
														<td>${report.reportCategory}</td>
														<td>
															<c:if test="${not empty report.reportMessage}">
																<button class="btn btn-sm btn-link view-message"
																	data-message="${report.reportMessage}">내용
																	보기</button>
															</c:if>
														</td>
														<td>
															<c:if test="${not empty report.reportTargetURL}">
																<a href="${report.reportTargetURL}?reportNo=${report.reportNo}"
																	target="_blank">보기</a>
															</c:if>
														</td>
														<td>
															<c:choose>
																<c:when test="${report.isRead == 'Y'}">
																	<span class="badge badge-success">읽음</span>
																</c:when>
																<c:otherwise>
																	<span class="badge badge-warning">미읽음</span>
																</c:otherwise>
															</c:choose>
														</td>
														<td>
															<fmt:formatDate value="${report.regDate}"
																pattern="yyyy-MM-dd HH:mm:ss" />
														</td>
														<td class="action-buttons">
															<button class="btn btn-sm btn-info view-detail"
																data-report-no="${report.reportNo}">
																<i class="fas fa-eye"></i>
															</button>
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
													<tr class="report-detail-row" id="detail-${report.reportNo}">
														<td colspan="10">
															<div class="report-detail">
																<div class="row">
																	<div class="col-md-6">
																		<h5>신고 상세 정보</h5>
																		<p><strong>신고 번호:</strong> ${report.reportNo}
																		</p>
																		<p><strong>신고 유형:</strong> ${report.reportType}
																		</p>
																		<p><strong>신고 대상:</strong>
																			<c:choose>
																				<c:when
																					test="${report.targetAccountType == 'USER'}">
																					일반 사용자 (${report.targetAccountUid})
																				</c:when>
																				<c:when
																					test="${report.targetAccountType == 'COMPANY'}">
																					기업 (${report.targetAccountUid})
																				</c:when>
																				<c:otherwise>
																					${report.targetAccountType}
																					(${report.targetAccountUid})
																				</c:otherwise>
																			</c:choose>
																		</p>
																		<p><strong>신고자:</strong> 일반 사용자
																			(${report.reporterAccountUid})</p>
																		<p><strong>신고 카테고리:</strong>
																			${report.reportCategory}</p>
																		<p><strong>신고 내용:</strong>
																			${report.reportMessage}</p>
																		<p><strong>신고 일자:</strong>
																			<fmt:formatDate value="${report.regDate}"
																				pattern="yyyy-MM-dd HH:mm:ss" />
																		</p>
																	</div>
																	<div class="col-md-6">
																		<h5>관리자 조치</h5>
																		<div class="report-actions">
																			<c:choose>
																				<c:when
																					test="${report.targetAccountType == 'USER'}">
																					<button
																						class="btn btn-danger block-user-detail"
																						data-uid="${report.targetAccountUid}">
																						<i class="fas fa-ban"></i> 사용자
																						정지
																					</button>
																				</c:when>
																				<c:when
																					test="${report.targetAccountType == 'COMPANY'}">
																					<button
																						class="btn btn-danger block-company-detail"
																						data-uid="${report.targetAccountUid}">
																						<i class="fas fa-ban"></i> 기업 정지
																					</button>
																				</c:when>
																			</c:choose>
																			<button
																				class="btn btn-success mark-read-detail"
																				data-report-no="${report.reportNo}"
																				data-read-status="${report.isRead}">
																				<i class="fas fa-check"></i>
																				<c:choose>
																					<c:when
																						test="${report.isRead == 'Y'}">
																						미읽음으로 표시
																					</c:when>
																					<c:otherwise>
																						읽음으로 표시
																					</c:otherwise>
																				</c:choose>
																			</button>
																			<button
																				class="btn btn-secondary close-detail"
																				data-report-no="${report.reportNo}">
																				<i class="fas fa-times"></i> 닫기
																			</button>
																		</div>
																	</div>
																</div>
															</div>
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
						// 읽음/미읽음 카운트 업데이트
						function updateReadCounts() {
							const unreadCount = $('.badge-warning').length;
							const readCount = $('.badge-success').length;
							$('#unreadCount').text(unreadCount);
							$('#readCount').text(readCount);
						}

						// 초기 카운트 업데이트
						updateReadCounts();

						// 상세 정보 보기 버튼 클릭 이벤트
						$('.view-detail').click(function () {
							const reportNo = $(this).data('report-no');
							$(`#detail-${reportNo}`).toggle();
						});

						// 상세 정보 닫기 버튼 클릭 이벤트
						$('.close-detail').click(function () {
							const reportNo = $(this).data('report-no');
							$(`#detail-${reportNo}`).hide();
						});

						// 신고 내용 보기 버튼 클릭 이벤트
						$('.view-message').click(function () {
							const message = $(this).data('message');
							alert(message);
						});

						// 일반 사용자 정지 버튼 클릭 이벤트
						$('.block-user, .block-user-detail').click(function () {
							const uid = $(this).data('uid');
							const duration = prompt('정지 기간을 입력하세요 (일 단위, 영구 정지는 "permanent" 입력):', '7');

							if (duration) {
								const reason = prompt('정지 사유를 입력하세요:');

								if (reason) {
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
								}
							}
						});

						// 기업 정지 버튼 클릭 이벤트
						$('.block-company, .block-company-detail').click(function () {
							const uid = $(this).data('uid');
							const duration = prompt('정지 기간을 입력하세요 (일 단위, 영구 정지는 "permanent" 입력):', '7');

							if (duration) {
								const reason = prompt('정지 사유를 입력하세요:');

								if (reason) {
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
								}
							}
						});

						// 읽음 표시 버튼 클릭 이벤트
						$('.mark-read, .mark-read-detail').click(function () {
							const reportNo = $(this).data('report-no');
							const currentStatus = $(this).data('read-status');
							const newStatus = currentStatus === 'Y' ? 'N' : 'Y';

							// 실제로는 서버에 상태 변경 요청을 보내야 합니다.
							// 여기서는 프론트엔드에서만 상태를 변경합니다.
							const row = $(`tr[data-report-no="${reportNo}"]`);
							const statusCell = row.find('td:nth-child(8)');

							if (newStatus === 'Y') {
								statusCell.html('<span class="badge badge-success">읽음</span>');
								$(this).data('read-status', 'Y');
								$(this).html('<i class="fas fa-check"></i> 미읽음으로 표시');
							} else {
								statusCell.html('<span class="badge badge-warning">미읽음</span>');
								$(this).data('read-status', 'N');
								$(this).html('<i class="fas fa-check"></i> 읽음으로 표시');
							}

							// 카운트 업데이트
							updateReadCounts();
						});

						// 필터 적용 버튼 클릭 이벤트
						$('#applyFilter').click(function () {
							const reportType = $('#reportTypeFilter').val();
							const readStatus = $('#readStatusFilter').val();
							const category = $('#categoryFilter').val();
							const dateFilter = $('#dateFilter').val();

							// 모든 행 숨기기
							$('tbody tr:not(.report-detail-row)').hide();

							// 필터 조건에 맞는 행만 표시
							$('tbody tr:not(.report-detail-row)').each(function () {
								const row = $(this);
								const rowReportType = row.data('report-type');
								const rowReadStatus = row.data('read-status');
								const rowCategory = row.data('category');
								const rowDate = new Date(row.data('date'));
								const today = new Date();
								const oneWeekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
								const oneMonthAgo = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());

								let showRow = true;

								// 신고 유형 필터
								if (reportType !== 'all' && rowReportType !== reportType) {
									showRow = false;
								}

								// 읽음 상태 필터
								if (readStatus !== 'all' && rowReadStatus !== readStatus) {
									showRow = false;
								}

								// 카테고리 필터
								if (category !== 'all' && rowCategory !== category) {
									showRow = false;
								}

								// 날짜 필터
								if (dateFilter !== 'all') {
									if (dateFilter === 'today' && rowDate.toDateString() !== today.toDateString()) {
										showRow = false;
									} else if (dateFilter === 'week' && rowDate < oneWeekAgo) {
										showRow = false;
									} else if (dateFilter === 'month' && rowDate < oneMonthAgo) {
										showRow = false;
									}
								}

								if (showRow) {
									row.show();
								}
							});

							// 상세 정보 행도 함께 숨기기
							$('.report-detail-row').hide();
						});

						// 필터 초기화 버튼 클릭 이벤트
						$('#resetFilter').click(function () {
							// 모든 필터 선택 초기화
							$('#reportTypeFilter').val('all');
							$('#readStatusFilter').val('all');
							$('#categoryFilter').val('all');
							$('#dateFilter').val('all');

							// 모든 행 표시
							$('tbody tr:not(.report-detail-row)').show();

							// 상세 정보 행 숨기기
							$('.report-detail-row').hide();
						});
					});
				</script>
			</body>

			</html>