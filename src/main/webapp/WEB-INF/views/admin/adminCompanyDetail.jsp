<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
			<!DOCTYPE html>
			<html lang="en">

			<head>
				<meta charset="UTF-8">
				<title>기업 상세 정보 - 관리자 페이지</title>
			</head>

			<body id="page-top">

				<!-- 헤더 포함 (네비게이션바 + 사이드바 포함) -->
				<jsp:include page="adminheader.jsp"></jsp:include>

				<!-- 본문 내용 -->
				<div class="container-fluid">
					<h1 class="h3 mb-4 text-gray-800">기업 상세 정보</h1>

					<!-- 뒤로가기 버튼 -->
					<div class="mb-4">
						<c:choose>
							<c:when test="${not empty param.reportNo}">
								<a href="/admin/reportUserList" class="btn btn-secondary"> <i class="fas fa-arrow-left"></i> 목록으로
									돌아가기
								</a>
							</c:when>
							<c:otherwise>
								<a href="/admin/companyList" class="btn btn-secondary"> <i class="fas fa-arrow-left"></i> 목록으로
									돌아가기
								</a>
							</c:otherwise>
						</c:choose>
					</div>

					<!-- 기업 상세 정보 카드 -->
					<div class="row">
						<!-- 기본 정보 카드 -->
						<div class="col-xl-6 col-lg-6">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">기본 정보</h6>
								</div>
								<div class="card-body">
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">기업 ID</div>
										<c:if test="${company.uid == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.uid != null}">
											<div class="col-md-8">${company.uid}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">기업명</div>
										<c:if test="${company.companyName == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.companyName != null}">
											<div class="col-md-8">${company.companyName}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">사업자 번호</div>
										<c:if test="${company.businessNum == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.businessNum != null}">
											<div class="col-md-8">${company.businessNum}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">대표자명</div>
										<c:if test="${company.representative == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.representative != null}">
											<div class="col-md-8">${company.representative}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">이메일</div>
										<c:if test="${company.email == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.email != null}">
											<div class="col-md-8">${company.email}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">전화번호</div>
										<c:if test="${company.mobile == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.mobile != null}">
											<div class="col-md-8">${company.mobile}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">주소</div>
										<c:if test="${company.addr == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.addr != null}">
											<div class="col-md-8">${company.addr}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">회원 유형</div>
										<div class="col-md-8">
											<c:choose>
												<c:when test="${company.accountType == 'COMPANY'}">기업회원</c:when>
												<c:otherwise>-</c:otherwise>
											</c:choose>
										</div>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">가입일</div>
										<div class="col-md-8">
											<fmt:formatDate value="${company.regDate}" pattern="yyyy-MM-dd HH:mm:ss" />
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- 계정 상태 및 추가 정보 카드 -->
						<div class="col-xl-6 col-lg-6">
							<div class="card shadow mb-4">
								<div class="card-header py-3">
									<h6 class="m-0 font-weight-bold text-primary">계정 상태 및 추가 정보</h6>
								</div>
								<div class="card-body">
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">계정 상태</div>
										<div class="col-md-8">
											<c:choose>
												<c:when test="${company.blockDeadline != null}">
													<span class="badge badge-danger">정지</span>
													<small class="text-muted ml-2"> (정지 기한:
														<fmt:formatDate value="${company.blockDeadline}"
															pattern="yyyy-MM-dd" />)
													</small>
												</c:when>
												<c:when test="${company.deleteDeadline != null}">
													<span class="badge badge-warning">삭제예정</span>
													<small class="text-muted ml-2"> (삭제 예정일:
														<fmt:formatDate value="${company.deleteDeadline}"
															pattern="yyyy-MM-dd" />)
													</small>
												</c:when>
												<c:when test="${company.requiresVerification == 'Y'}">
													<span class="badge badge-info">인증필요</span>
												</c:when>
												<c:otherwise>
													<span class="badge badge-success">정상</span>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
									<c:if test="${company.blockDeadline != null}">
										<div class="row mb-3">
											<div class="col-md-4 font-weight-bold">정지 사유</div>
											<c:if test="${company.blockReason == null}">
												<div class="col-md-8">-</div>
											</c:if>
											<c:if test="${company.blockReason != null}">
												<div class="col-md-8">${company.blockReason}</div>
											</c:if>
										</div>
									</c:if>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">로그인 실패 횟수</div>
										<div class="col-md-8">${company.loginCnt}</div>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">마지막 로그인</div>
										<div class="col-md-8">
											<c:if test="${company.lastLoginDate != null}">
												<fmt:formatDate value="${company.lastLoginDate}"
													pattern="yyyy-MM-dd HH:mm:ss" />
											</c:if>
											<c:if test="${company.lastLoginDate == null}">
												-
											</c:if>
										</div>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">기업 규모</div>
										<c:if test="${company.scale == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.scale != null}">
											<div class="col-md-8">${company.scale}</div>
										</c:if>
									</div>
									<div class="row mb-3">
										<div class="col-md-4 font-weight-bold">홈페이지</div>
										<c:if test="${company.homePage == null}">
											<div class="col-md-8">-</div>
										</c:if>
										<c:if test="${company.homePage != null}">
											<div class="col-md-8">
												<a href="${company.homePage}" target="_blank">${company.homePage}</a>
											</div>
										</c:if>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- 기업 소개 카드 -->
					<div class="card shadow mb-4">
						<div class="card-header py-3">
							<h6 class="m-0 font-weight-bold text-primary">기업 소개</h6>
						</div>
						<div class="card-body">
							<c:if test="${company.introduce != null && company.introduce != ''}">
								<p>${company.introduce}</p>
							</c:if>
							<c:if test="${company.introduce == null || company.introduce == ''}">
								<p class="text-muted">기업 소개가 없습니다.</p>
							</c:if>
						</div>
					</div>


					<!-- 관리 버튼 -->
					<div class="mb-4">
						<c:if test="${company.blockDeadline == null}">
							<button class="btn btn-danger" onclick="blockCompany(${company.uid})">
								<i class="fas fa-ban"></i> 계정 정지
							</button>
						</c:if>
						<c:if test="${company.blockDeadline != null}">
							<button class="btn btn-success" onclick="unblockCompany(${company.uid})">
								<i class="fas fa-check"></i> 계정 정지 해제
							</button>
						</c:if>
					</div>
				</div>

				<!-- 푸터 포함 -->
				<jsp:include page="adminfooter.jsp"></jsp:include>

				<!-- 정지 모달 -->
				<div class="modal fade" id="blockCompanyModal" tabindex="-1" aria-labelledby="blockCompanyModalLabel"
					aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="blockCompanyModalLabel">기업 정지</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
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
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
								<button type="button" class="btn btn-danger" onclick="submitBlockCompany()">확인</button>
							</div>
						</div>
					</div>
				</div>

				<!-- 페이지 로드 시 실행되는 스크립트 -->
				<script>
					// 기업 계정 정지 모달 열기
					function blockCompany(uid) {
						document.getElementById('blockCompanyId').value = uid;
						document.getElementById('blockReason').value = '';
						document.querySelector('input[name="blockDuration"][value="3"]').checked = true;
						new bootstrap.Modal(document.getElementById('blockCompanyModal')).show();
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