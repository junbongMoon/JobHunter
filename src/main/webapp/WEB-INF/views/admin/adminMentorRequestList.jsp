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
					
				<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
					<h1 class="h3 mb-4 text-gray-800">일반 유저</h1>

					<!-- 검색 영역 -->
					<div class="mentor-search-controls">
					  <!-- 검색어 입력창 -->
					  <input type="text" id="searchWord" placeholder="검색어를 입력하세요">
					
					  <!-- 페이지당 표시 수 -->
					  <select id="rowCntPerPage">
					    <option value="5">5개</option>
					    <option value="10" selected>10개</option>
					    <option value="20">20개</option>
					    <option value="50">50개</option>
					  </select>
					
					  <!-- 검색 타입 체크박스 -->
					  <div class="search-types">
					    <label><input type="checkbox" name="searchTypes" value="TITLE" checked> 제목</label>
					    <label><input type="checkbox" name="searchTypes" value="WRITER"> 작성자</label>
					    <label><input type="checkbox" name="searchTypes" value="CONTENT"> 내용</label>
					    <label><input type="checkbox" name="searchTypes" value="REJECT"> 반려사유</label>
					    <button type="button" id="clearSearchTypes">전체 초기화</button>
					  </div>
					
					  <!-- 검색 범위 -->
					  <select id="dateRange">
					    <option value="1HOUR">최근 1시간</option>
					    <option value="1DAY">최근 1일</option>
					    <option value="3DAY">최근 3일</option>
					    <option value="1MONTH">최근 1달</option>
					    <option value="CUSTOM">직접 입력</option>
					  </select>
					
					  <!-- 직접 입력용 날짜 선택 -->
					  <div id="customDateInputs" style="display:none;">
					    <input type="datetime-local" id="searchStartDate">
					    <input type="datetime-local" id="searchEndDate">
					  </div>
					
					  <!-- 상태 선택 -->
					  <select id="status">
					    <option value="UNCOMPLETE" selected>처리미완료</option>
					    <option value="COMPLETE">처리완료</option>
					    <option value="PASS">승인됨</option>
					    <option value="FAILURE">거부됨</option>
					    <option value="CHECKED">확인중</option>
					    <option value="WAITING">미확인</option>
					    <option value="ALL">전체</option>
					  </select>
					
					  <!-- 정렬 옵션 버튼 -->
					  <div class="sort-buttons">
					    <button type="button" id="sortPostDate" class="sort-option active">신청일 <span id="arrowPostDate">▼</span></button>
					    <button type="button" id="sortConfirmDate" class="sort-option">처리일 <span id="arrowConfirmDate">▼</span></button>
					  </div>
					
					  <!-- 검색 버튼 -->
					  <button type="button" onclick="fetchMentorRequests()">검색</button>
					</div>
					<!-- 검색 영역 -->
					
					<div class="search-container">
							<div class="col-auto">
								<select name="searchType" class="form-select">
									<option value="name">이름</option>
								</select>
							</div>
							<div class="col-auto">
								<input type="text" name="searchKeyword" class="form-control"
									value="a" placeholder="검색어를 입력하세요">
							</div>
							<div class="col-auto">
								<button type="submit" class="btn btn-primary" onclick="fetchMentorRequests()">검색</button>
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
					</div>

					<!-- 유저 목록 카드 -->
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
										</tr>
									</thead>
									<tbody>
										
											<tr>
												<td>uid</td>
											</tr>
									</tbody>
								</table>
							</div>

							<!-- 페이징 -->
							<nav aria-label="Page navigation">
								<ul class="pagination">
									
										<li class="page-item">
											<a class="page-link"
												href="/admin"
												aria-label="Previous">
												<span aria-hidden="true">&laquo;</span>
											</a>
										</li>

										<li class="page-item">
											<a class="page-link"
												href="/admin">1</a>
										</li>
										
										<li class="page-item">
											<a class="page-link"
												href="/admin"
												aria-label="Next">
												<span aria-hidden="true">&raquo;</span>
											</a>
										</li>
										
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

				<script>
				let sortOption = 'POSTDATE'; // 초기값
				let sortDirection = 'DESC';  // 초기값

				// 전체 초기화 버튼
				$('#clearSearchTypes').on('click', function() {
				    $('input[name="searchTypes"]').prop('checked', false);
				    $('input[name="searchTypes"][value="TITLE"]').prop('checked', true);
				    $('#searchWord').val('');
				});

				// 검색범위 선택시
				$('#dateRange').on('change', function() {
				    const value = $(this).val();
				    if (value === 'CUSTOM') {
				        $('#customDateInputs').show();
				    } else {
				        $('#customDateInputs').hide();
				    }
				});

				// 정렬 버튼 클릭시
				$('.sort-option').on('click', function() {
				    const clickedOption = $(this).attr('id') === 'sortPostDate' ? 'POSTDATE' : 'CONFIRMDATE';

				    if (sortOption === clickedOption) {
				        // 같은 버튼을 다시 누르면 방향 반전
				        sortDirection = (sortDirection === 'ASC') ? 'DESC' : 'ASC';
				    } else {
				        // 다른 버튼 클릭하면 sortOption만 변경, 방향은 그대로
				        sortDirection = 'DESC';
				        sortOption = clickedOption;
				    }

				    // 버튼 색상
				    $('.sort-option').removeClass('active');
				    $(this).addClass('active');

				    // 화살표 업데이트
				    $('#arrowPostDate').text((sortOption === 'POSTDATE' && sortDirection === 'ASC') ? '▲' : '▼');
				    $('#arrowConfirmDate').text((sortOption === 'CONFIRMDATE' && sortDirection === 'ASC') ? '▲' : '▼');
				});

				// 검색 함수
				function fetchMentorRequests() {
				    const rowCntPerPage = parseInt($('#rowCntPerPage').val(), 10);
				    const searchWord = $('#searchWord').val();

				    const selectedSearchTypes = [];
				    $('input[name="searchTypes"]:checked').each(function() {
				        selectedSearchTypes.push($(this).val());
				    });

				    const status = $('#status').val();
				    const dateRange = $('#dateRange').val();

				    let searchStartDate = null;
				    let searchEndDate = null;
				    const now = new Date();

				    if (dateRange === '1HOUR') {
				        searchStartDate = new Date(now.getTime() - 1 * 60 * 60 * 1000);
				    } else if (dateRange === '1DAY') {
				        searchStartDate = new Date(now.getTime() - 24 * 60 * 60 * 1000);
				    } else if (dateRange === '3DAY') {
				        searchStartDate = new Date(now.getTime() - 3 * 24 * 60 * 60 * 1000);
				    } else if (dateRange === '1MONTH') {
				        searchStartDate = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
				    } else if (dateRange === 'CUSTOM') {
				        searchStartDate = $('#searchStartDate').val();
				        searchEndDate = $('#searchEndDate').val();
				    }

				    function formatDate(d) {
				        if (!d) return null;
				        const date = new Date(d);
				        return date.toISOString().slice(0, 19); // 'yyyy-MM-ddTHH:mm:ss'
				    }

				    $.ajax({
				        url: '/mentor/request-list',
				        method: 'POST',
				        contentType: 'application/json',
				        data: JSON.stringify({
				            page: 1,
				            rowCntPerPage: rowCntPerPage,
				            searchWord: searchWord,
				            searchTypes: selectedSearchTypes,
				            searchStartDate: formatDate(searchStartDate),
				            searchEndDate: formatDate(searchEndDate),
				            status: status,
				            sortOption: sortOption,
				            sortDirection: sortDirection
				        }),
				        success: function(response) {
				            console.log('Mentor Requests:', response);
				        },
				        error: function(xhr) {
				            console.error('Failed to fetch mentor requests', xhr);
				        }
				    });
				}

				</script>
			</body>

			</html>