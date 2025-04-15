<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html lang="en">

		<head>
			<meta charset="UTF-8">
			<title>관리자 페이지</title>
			<!-- Bootstrap CSS -->
			<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
			<!-- Font Awesome -->
			<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
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
				<h1 class="h3 mb-4 text-gray-800">유저 목록</h1>

				<!-- 검색 영역 -->
				<div class="search-container">
					<form action="/admin/userList" method="get" class="row g-3">
						<div class="col-auto">
							<select name="searchType" class="form-select">
								<option value="name" ${param.searchType=='name' ? 'selected' : '' }>이름</option>
								<option value="email" ${param.searchType=='email' ? 'selected' : '' }>이메일</option>
								<option value="mobile" ${param.searchType=='mobile' ? 'selected' : '' }>전화번호</option>
							</select>
						</div>
						<div class="col-auto">
							<input type="text" name="searchKeyword" class="form-control" value="${param.searchKeyword}"
								placeholder="검색어를 입력하세요">
						</div>
						<div class="col-auto">
							<button type="submit" class="btn btn-primary">검색</button>
						</div>
						<!-- 검색 초기화 -->
						<div class="col-auto">
							<button type="button" class="btn btn-secondary" onclick="resetSearch()">초기화</button>
						</div>
					</form>
				</div>

				<!-- 유저 목록 카드 -->
				<div class="card shadow mb-4">
					<div class="card-header py-3">
						<h6 class="m-0 font-weight-bold text-primary">전체 유저 목록</h6>
					</div>
					<div class="card-body">
						<div class="table-responsive">
							<table class="table table-bordered table-hover">
								<thead>
									<tr>
										<th>UID</th>
										<th>이름</th>
										<th>이메일</th>
										<th>전화번호</th>
										<th>성별</th>
										<th>나이</th>
										<th>가입일</th>
										<th>상태</th>
										<th>관리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${userList}" var="user">
										<tr>
											<td>${user.uid}</td>
											<td>${user.userName}</td>
											<td>${user.email}</td>
											<td>${user.mobile}</td>
											<td>
												<c:choose>
													<c:when test="${user.gender == 'MALE'}">남성</c:when>
													<c:when test="${user.gender == 'FEMALE'}">여성</c:when>
													<c:otherwise>-</c:otherwise>
												</c:choose>
											</td>
											<td>${user.age}</td>
											<td>${user.regDate}</td>
											<td>
												<c:choose>
													<c:when test="${user.blockDeadline != null}">
														<span class="badge bg-danger">정지</span>
													</c:when>
													<c:when test="${user.deleteDeadline != null}">
														<span class="badge bg-warning">삭제예정</span>
													</c:when>
													<c:when test="${user.requiresVerification == 'Y'}">
														<span class="badge bg-info">인증필요</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-success">정상</span>
													</c:otherwise>
												</c:choose>
											</td>
											<td>
												<button class="btn btn-info btn-sm"
													onclick="viewUserDetail(${user.uid})">
													<i class="fas fa-eye"></i> 상세
												</button>
												<c:if test="${user.blockDeadline == null}">
													<button class="btn btn-danger btn-sm"
														onclick="blockUser(${user.uid})">
														<i class="fas fa-ban"></i> 정지
													</button>
												</c:if>
												<c:if test="${user.blockDeadline != null}">
													<button class="btn btn-success btn-sm"
														onclick="unblockUser(${user.uid})">
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
											href="/admin/userList?page=${pagination.startPage - 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}"
											aria-label="Previous">
											<span aria-hidden="true">&laquo;</span>
										</a>
									</li>
								</c:if>

								<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="pageNum">
									<li class="page-item ${pageNum == pagination.currentPage ? 'active' : ''}">
										<a class="page-link"
											href="/admin/userList?page=${pageNum}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">${pageNum}</a>
									</li>
								</c:forEach>

								<c:if test="${pagination.next}">
									<li class="page-item">
										<a class="page-link"
											href="/admin/userList?page=${pagination.endPage + 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}"
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

			<script>
				// 검색 초기화
				function resetSearch() {
					window.location.href = '/admin/userList';
				}

				// 유저 상세 정보 보기
				function viewUserDetail(uid) {
					window.location.href = '/admin/userDetail/' + uid;
				}

				// // 유저 계정 정지
				// function blockUser(uid) {
				// 	if (confirm('정말로 이 유저를 정지시키겠습니까?')) {
				// 		// AJAX로 정지 요청 보내기
				// 		fetch('/admin/blockUser/' + uid, {
				// 			method: 'POST',
				// 			headers: {
				// 				'Content-Type': 'application/json'
				// 			}
				// 		})
				// 			.then(response => response.json())
				// 			.then(data => {
				// 				if (data.success) {
				// 					alert('유저가 정지되었습니다.');
				// 					location.reload();
				// 				} else {
				// 					alert('유저 정지에 실패했습니다.');
				// 				}
				// 			})
				// 			.catch(error => {
				// 				console.error('Error:', error);
				// 				alert('처리 중 오류가 발생했습니다.');
				// 			});
				// 	}
				// }

				// // 유저 계정 정지 해제
				// function unblockUser(uid) {
				// 	if (confirm('정말로 이 유저의 정지를 해제하겠습니까?')) {
				// 		// AJAX로 정지 해제 요청 보내기
				// 		fetch('/admin/unblockUser/' + uid, {
				// 			method: 'POST',
				// 			headers: {
				// 				'Content-Type': 'application/json'
				// 			}
				// 		})
				// 			.then(response => response.json())
				// 			.then(data => {
				// 				if (data.success) {
				// 					alert('유저의 정지가 해제되었습니다.');
				// 					location.reload();
				// 				} else {
				// 					alert('유저 정지 해제에 실패했습니다.');
				// 				}
				// 			})
				// 			.catch(error => {
				// 				console.error('Error:', error);
				// 				alert('처리 중 오류가 발생했습니다.');
				// 			});
				// 	}
				// }
			</script>
		</body>

		</html>