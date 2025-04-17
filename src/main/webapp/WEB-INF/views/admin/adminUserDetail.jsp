<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>유저 상세 정보 - 관리자 페이지</title>
</head>

<body id="page-top">

	<!-- 헤더 포함 (네비게이션바 + 사이드바 포함) -->
	<jsp:include page="adminheader.jsp"></jsp:include>

	<!-- 본문 내용 -->
	<div class="container-fluid">
		<h1 class="h3 mb-4 text-gray-800">유저 상세 정보</h1>

		<!-- 뒤로가기 버튼 -->
		<div class="mb-4">
			<a href="/admin/userList" class="btn btn-secondary"> <i
				class="fas fa-arrow-left"></i> 목록으로 돌아가기
			</a>
		</div>

		<!-- 유저 상세 정보 카드 -->
		<div class="row">
			<!-- 기본 정보 카드 -->
			<div class="col-xl-6 col-lg-6">
				<div class="card shadow mb-4">
					<div class="card-header py-3">
						<h6 class="m-0 font-weight-bold text-primary">기본 정보</h6>
					</div>
					<div class="card-body">
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">유저 ID</div>
							<c:if test="${user.uid == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.uid != null}">
								<div class="col-md-8">${user.uid}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">이름</div>
							<c:if test="${user.userName == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.userName != null}">
								<div class="col-md-8">${user.userName}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">이메일</div>
							<c:if test="${user.email == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.email != null}">
								<div class="col-md-8">${user.email}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">전화번호</div>
							<c:if test="${user.mobile == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.mobile != null}">
								<div class="col-md-8">${user.mobile}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">주소</div>
							<c:if test="${user.addr == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.addr != null}">
								<div class="col-md-8">${user.addr}${user.detailAddr}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">성별</div>
							<div class="col-md-8">
								<c:choose>
									<c:when test="${user.gender == 'MALE'}">남성</c:when>
									<c:when test="${user.gender == 'FEMALE'}">여성</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">나이</div>
							<c:if test="${user.age == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.age != null}">
								<div class="col-md-8">${user.age}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">회원 유형</div>
							<div class="col-md-8">
								<c:choose>
									<c:when test="${user.accountType == 'USER'}">일반회원</c:when>
									<c:when test="${user.accountType == 'COMPANY'}">기업회원</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">가입일</div>
							<div class="col-md-8">
								<fmt:formatDate value="${user.regDate}"
									pattern="yyyy-MM-dd HH:mm:ss" />
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
									<c:when test="${user.blockDeadline != null}">
										<span class="badge badge-danger">정지</span>
										<small class="text-muted ml-2"> (정지 기한: <fmt:formatDate
												value="${user.blockDeadline}" pattern="yyyy-MM-dd" />)
										</small>
									</c:when>
									<c:when test="${user.deleteDeadline != null}">
										<span class="badge badge-warning">삭제예정</span>
										<small class="text-muted ml-2"> (삭제 예정일: <fmt:formatDate
												value="${user.deleteDeadline}" pattern="yyyy-MM-dd" />)
										</small>
									</c:when>
									<c:when test="${user.requiresVerification == 'Y'}">
										<span class="badge badge-info">인증필요</span>
									</c:when>
									<c:otherwise>
										<span class="badge badge-success">정상</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<c:if test="${user.blockDeadline != null}">
							<div class="row mb-3">
								<div class="col-md-4 font-weight-bold">정지 사유</div>
								<c:if test="${user.blockReason == null}">
									<div class="col-md-8">-</div>
								</c:if>
								<c:if test="${user.blockReason != null}">
									<div class="col-md-8">${user.blockReason}</div>
								</c:if>
							</div>
						</c:if>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">로그인 실패 횟수</div>
							<div class="col-md-8">${user.loginCnt}</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">마지막 로그인</div>
							<div class="col-md-8">
								<c:if test="${user.lastLoginDate != null}">
									<fmt:formatDate value="${user.lastLoginDate}"
										pattern="yyyy-MM-dd HH:mm:ss" />
								</c:if>
								<c:if test="${user.lastLoginDate == null}">
                                                -
                                            </c:if>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">희망 급여 유형</div>
							<c:if test="${user.payType == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.payType != null}">
								<div class="col-md-8">${user.payType}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">희망 급여 금액</div>
							<c:if test="${user.pay == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.pay != null}">
								<div class="col-md-8">
									<fmt:formatNumber value="${user.pay}" pattern="#,###" />
									원
								</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">병역 사항</div>
							<div class="col-md-8">
								<c:choose>
									<c:when test="${user.militaryService == 'NOT_SERVED'}">미필</c:when>
									<c:when test="${user.militaryService == 'SERVED'}">군필</c:when>
									<c:when test="${user.militaryService == 'EXEMPTED'}">면제</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">국적</div>
							<div class="col-md-8">
								<c:choose>
									<c:when test="${user.nationality == 'DOMESTIC'}">내국인</c:when>
									<c:when test="${user.nationality == 'FOREIGN'}">외국인</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">장애 여부</div>
							<c:if test="${user.disability == null}">
								<div class="col-md-8">-</div>
							</c:if>
							<c:if test="${user.disability != null}">
								<div class="col-md-8">${user.disability}</div>
							</c:if>
						</div>
						<div class="row mb-3">
							<div class="col-md-4 font-weight-bold">소셜 로그인</div>
							<div class="col-md-8">
								<c:choose>
									<c:when test="${user.isSocial == 'Y'}">소셜 로그인 사용자</c:when>
									<c:when test="${user.isSocial == 'N'}">일반 사용자</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 자기소개 카드 -->
		<div class="card shadow mb-4">
			<div class="card-header py-3">
				<h6 class="m-0 font-weight-bold text-primary">자기소개</h6>
			</div>
			<div class="card-body">
				<c:if test="${user.introduce != null && user.introduce != ''}">
					<p>${user.introduce}</p>
				</c:if>
				<c:if test="${user.introduce == null || user.introduce == ''}">
					<p class="text-muted">자기소개가 없습니다.</p>
				</c:if>
			</div>
		</div>


		<!-- 관리 버튼 -->
		<div class="mb-4">
			<c:if test="${user.blockDeadline == null}">
				<button class="btn btn-danger" onclick="blockUser(${user.uid})">
					<i class="fas fa-ban"></i> 계정 정지
				</button>
			</c:if>
			<c:if test="${user.blockDeadline != null}">
				<button class="btn btn-success" onclick="unblockUser(${user.uid})">
					<i class="fas fa-check"></i> 계정 정지 해제
				</button>
			</c:if>
		</div>
	</div>

	<!-- 푸터 포함 -->
	<jsp:include page="adminfooter.jsp"></jsp:include>

	<!-- 정지 모달 -->
	<div class="modal fade" id="blockUserModal" tabindex="-1" aria-labelledby="blockUserModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="blockUserModalLabel">유저 정지</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="blockUserForm">
						<input type="hidden" id="blockUserId" name="uid">
						<div class="mb-3">
							<label class="form-label">정지 기간</label>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="blockDuration" id="duration3days" value="3">
								<label class="form-check-label" for="duration3days">3일</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="blockDuration" id="duration7days" value="7">
								<label class="form-check-label" for="duration7days">7일</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="blockDuration" id="duration30days" value="30">
								<label class="form-check-label" for="duration30days">30일</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="blockDuration" id="durationPermanent" value="permanent">
								<label class="form-check-label" for="durationPermanent">영구</label>
							</div>
						</div>
						<div class="mb-3">
							<label for="blockReason" class="form-label">정지 사유</label>
							<textarea class="form-control" id="blockReason" name="reason" rows="3" required></textarea>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-danger" onclick="submitBlockUser()">확인</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 페이지 로드 시 실행되는 스크립트 -->
	<script>
                    // 유저 계정 정지 모달 열기
					function blockUser(uid) {
						document.getElementById('blockUserId').value = uid;
						document.getElementById('blockReason').value = '';
						document.querySelector('input[name="blockDuration"][value="3"]').checked = true;
						new bootstrap.Modal(document.getElementById('blockUserModal')).show();
					}

					// 유저 계정 정지 제출
					function submitBlockUser() {
						const uid = document.getElementById('blockUserId').value;
						const duration = document.querySelector('input[name="blockDuration"]:checked').value;
						const reason = document.getElementById('blockReason').value;

						if (!reason) {
							alert('정지 사유를 입력해주세요.');
							return;
						}

						// AJAX로 정지 요청 보내기
						fetch('/admin/blockUser/' + uid, {
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
								alert('유저가 정지되었습니다.');
								location.reload();
							} else {
								alert('유저 정지에 실패했습니다.');
							}
						})
						.catch(error => {
							console.error('Error:', error);
							alert('처리 중 오류가 발생했습니다.');
						});
					}

					// 유저 계정 정지 해제
					function unblockUser(uid) {
						if (confirm('정말로 이 유저의 정지를 해제하겠습니까?')) {
							// AJAX로 정지 해제 요청 보내기
							fetch('/admin/unblockUser/' + uid, {
								method: 'POST',
								headers: {
									'Content-Type': 'application/json'
								}
							})
							.then(response => response.json())
							.then(data => {
								if (data.success) {
									alert('유저의 정지가 해제되었습니다.');
									location.reload();
								} else {
									alert('유저 정지 해제에 실패했습니다.');
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