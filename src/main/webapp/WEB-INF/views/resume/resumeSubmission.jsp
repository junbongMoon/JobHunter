<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>이력서 제출</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="/resources/css/mypage.css">

</head>

<body>
	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="main">
		<div class="container">
			<h1 class="page-title">이력서 제출</h1>

			<!-- 공고 정보 표시 -->
			<c:if test="${not empty recruitmentNotice}">
				<div class="notice-info">
					<div class="notice-title">${recruitmentNotice.title}</div>
					<div class="notice-company">
						<i class="fas fa-solid fa-building "></i>&nbsp;${recruitmentNotice.companyName}
					</div>
					<div class="notice-details">
						<div class="notice-detail-item" data-bs-toggle="tooltip"
							data-bs-placement="top" title="근무 지역">
							<i class="fas fa-map-marker-alt"></i> <span> <c:if
									test="${not empty recruitmentNotice.region}">
											${recruitmentNotice.region.name}</c:if> <c:if
									test="${not empty recruitmentNotice.sigungu}">
											${recruitmentNotice.sigungu.name}</c:if>
							</span>
						</div>
						<div class="notice-detail-item" data-bs-toggle="tooltip"
							data-bs-placement="top" title="근무 형태">
							<i class="fas fa-briefcase"></i> <span>${recruitmentNotice.workType}</span>
						</div>
						<div class="notice-detail-item" data-bs-toggle="tooltip"
							data-bs-placement="top" title="조건 사항">
							<i class="fas fa-solid fa-list-check"></i> <span>${recruitmentNotice.personalHistory}</span>
						</div>
						<div class="notice-detail-item" data-bs-toggle="tooltip"
							data-bs-placement="top" title="급여 정보">
							<i class="fas fa-money-bill-wave"></i> <span> <c:choose>
									<c:when test="${recruitmentNotice.payType eq 'HOUR'}">시급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'DATE'}">일급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'WEEK'}">주급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'MONTH'}">월급</c:when>
									<c:when test="${recruitmentNotice.payType eq 'YEAR'}">연봉</c:when>
									<c:otherwise>기타</c:otherwise>
								</c:choose> <span id="payAmount">${recruitmentNotice.pay}</span>원
							</span>
						</div>
						<div class="notice-detail-item" data-bs-toggle="tooltip"
							data-bs-placement="top" title="공고 마감일">
							<i class="fas fa-calendar-alt"></i> <span id="dueDate">${recruitmentNotice.dueDate}</span>
						</div>
					</div>
				</div>
			</c:if>

			<!-- 이력서 선택 섹션 -->
			<div class="resume-selection">
				<div class="d-flex justify-content-between align-items-center mb-4">
					<h2>
						<i class="fas fa-file-alt section-icon"></i>제출할 이력서 선택
					</h2>
					<a href="/resume/form?uid=${recruitmentNotice.uid}"
						class="btn newResumeBtn btn-primary"> <i class="fas fa-plus"></i>
						새 이력서 작성하기
					</a>
				</div>
				<div class="resume-list">
					<c:choose>
						<c:when test="${not empty resumeList}">
							<c:forEach items="${resumeList}" var="resume">
								<div class="resume-item" data-resume-id="${resume.resumeNo}">
									<div class="resume-info">
										<div class="resume-title">
											<!-- <i class="fas fa-file-alt"></i> -->
											${resume.title}
										</div>

										<div class="resume-tags">
											<c:if test="${not empty resume.sigunguList}">
												<span class="tag"> <i class="fas fa-map-marker-alt"></i>
													<c:forEach items="${resume.sigunguList}" var="sigungu"
														varStatus="status">
														<c:if test="${status.index < 2}">
															<span>
																${sigungu.regionName}&nbsp;${sigungu.name}&nbsp; <c:if
																	test="${status.index < 1}">
																	<span>&</span>
																</c:if>
															</span>
														</c:if>
													</c:forEach>
												</span>
											</c:if>
											<c:if test="${not empty resume.subcategoryList}">
												<span class="tag"> <i class="fas fa-briefcase"></i> <c:forEach
														items="${resume.subcategoryList}" var="subcategory"
														varStatus="status">
														<c:if test="${status.index < 2}">
															<span>${subcategory.jobName}&nbsp;<c:if
																	test="${status.index < 1}">
																	<span>&</span>
																</c:if></span>
														</c:if>
													</c:forEach>
												</span>
											</c:if>
										</div>
										<small class="text-muted">최종수정일 :
											${resume.regDate.substring(0,4)}년
											${resume.regDate.substring(5,7)}월
											${resume.regDate.substring(8,10)}일</small>
									</div>
									<div class="resume-actions">
										<a
											href="/resume/edit/${resume.resumeNo}?uid=${recruitmentNotice.uid}"
											class="btn btn-outline-primary edit-resume"> <i
											class="fas fa-edit"></i> 수정 및 상세보기
										</a>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="alert alert-info">
								<i class="fas fa-info-circle"></i> 등록된 이력서가 없습니다. <a
									href="/resume/form" class="alert-link">이력서 작성하기</a>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- 개인정보 제3자 제공 동의 -->
			<div class="privacy-consent card">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<div>
						<input type="checkbox" id="privacyConsentCheckbox"> <label
							for="privacyConsentCheckbox">[필수] 개인정보 제3자 제공 동의</label>
					</div>
					<button class="btn btn-link" data-bs-toggle="collapse"
						data-bs-target="#consentDetails" aria-expanded="false"
						aria-controls="consentDetails" id="toggleButton">
						<span id="toggleText">자세히..</span> <i class="fas fa-chevron-down"></i>
					</button>
				</div>
				<div id="consentDetails" class="collapse">
					<div class="card-body">
						<ol>
							<li>개인정보를 제공받는 자: ${recruitmentNotice.companyName}</li>
							<li>개인정보를 제공받는 자의 개인정보 이용 목적: 입사지원 및 채용절차 진행</li>
							<li>제공하는 개인정보 항목: 입사지원 시 작성한 이력서 정보(이름, 생년월일, 성별, 휴대폰 번호,
								이메일, 거주지역, 희망 근무지, 희망 업직종, 희망 근무형태, 희망급여, 성적 및 강점, 학력사항, 상세
								학력사항, 경력사항, 상세 경력사항, 보유 자격증, 병역사항, 국적여부, 자기소개서)</li>
						</ol>
					</div>
				</div>
			</div>

			<!-- 페이징 처리 -->
			<c:if test="${totalPages > 1}">
				<div class="submit-button-container text-center mb-4">
					<button type="button" id="submitResumeBtn"
						class="btn btn-primary btn-lg" disabled>
						<i class="fas fa-paper-plane"></i> 이력서 제출하기
					</button>
				</div>
				<div class="pagination-container">
					<nav aria-label="Page navigation">
						<ul class="pagination justify-content-center">

							<!-- 이전 페이지 버튼 -->
							<li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
								<a class="page-link"
								href="/submission/check?uid=${recruitmentNotice.uid}&page=${currentPage - 1}&pageSize=${pageSize}"
								aria-label="Previous"> <i class="fas fa-chevron-left"></i>
							</a>
							</li>

							<!-- 페이지 번호 -->
							<c:set var="startPage" value="${((currentPage - 1) / 5) * 5 + 1}" />
							<c:set var="endPage"
								value="${startPage + 4 > totalPages ? totalPages : startPage + 4}" />

							<c:forEach begin="${startPage}" end="${endPage}" var="i">
								<li class="page-item ${currentPage == i ? 'active' : ''}">
									<a class="page-link"
									href="/submission/check?uid=${recruitmentNotice.uid}&page=${i}&pageSize=${pageSize}">${i}</a>
								</li>
							</c:forEach>

							<!-- 다음 페이지 버튼 -->
							<li
								class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
								<a class="page-link"
								href="/submission/check?uid=${recruitmentNotice.uid}&page=${currentPage + 1}&pageSize=${pageSize}"
								aria-label="Next"> <i class="fas fa-chevron-right"></i>
							</a>
							</li>
						</ul>
					</nav>
				</div>
			</c:if>
		</div>
	</div>

	<div>
		<!-- 재사용 공용 경고 모달창 -->
		<div class="modal fade" id="validationModal" tabindex="-1"
			aria-labelledby="validationModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content text-center">
					<div class="modal-body">
						<p id="validationMessage" class="mb-3">알림 메시지</p>
						<button type="button" class="btn btn-primary"
							id="validationCheckBtn" data-bs-dismiss="modal">확인</button>
						<button type="button" class="btn btn-secondary"
							id="validationOutBtn" data-bs-dismiss="modal">취소</button>
					</div>
				</div>
			</div>
		</div>


	</div>

	<!-- 풋터 -->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</body>

</html>

<style>
.notice-info {
	background-color: #f8f9fa;
	border-radius: 10px;
	padding: 20px;
	margin-bottom: 30px;
	box-shadow: 0 5px 15px rgba(55, 81, 126, 0.1);
	border-left: 5px solid #47b2e4;
}

.notice-title {
	font-size: 24px;
	font-weight: bold;
	color: #37517e;
	margin-bottom: 15px;
}

.notice-company {
	font-size: 18px;
	color: #37517e;
	margin-bottom: 10px;
	font-weight: bold;
}

.notice-details {
	display: flex;
	flex-wrap: wrap;
	gap: 20px;
	margin-top: 15px;
}

.notice-detail-item {
	display: flex;
	align-items: center;
	gap: 8px;
}

.notice-detail-item i {
	color: #37517e;
}

.error-message {
	background-color: #fff3f3;
	color: #dc3545;
	padding: 15px;
	margin: 20px 0;
	border-radius: 5px;
	text-align: center;
}

.back-button {
	display: inline-block;
	padding: 10px 20px;
	background-color: #6c757d;
	color: white;
	text-decoration: none;
	border-radius: 5px;
	margin-top: 10px;
}

.back-button:hover {
	background-color: #5a6268;
}

.resume-list {
	margin-top: 20px;
}

.resume-item {
	background-color: #fff;
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	padding: 20px;
	margin-bottom: 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	transition: all 0.3s ease;
	cursor: pointer;
}

.resume-item:hover {
	border-color: #37517e;
	box-shadow: 0 5px 15px rgba(55, 81, 126, 0.1);
}

.resume-item.selected {
	border: 3px solid #47b2e4;
	background-color: #f8f9fa;
	box-shadow: 0 5px 15px rgba(71, 178, 228, 0.15);
}

.resume-title {
	font-size: 18px;
	font-weight: 600;
	color: #37517e;
	margin-bottom: 8px;
}

.resume-title i {
	color: #37517e;
	margin-right: 8px;
}

.resume-date {
	font-size: 14px;
	color: #666;
	margin-bottom: 8px;
}

.resume-tags {
	display: flex;
	gap: 10px;
	flex-wrap: wrap;
	margin-bottom: 5px;
}

.tag {
	background-color: #f5f7fa;
	color: #37517e;
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 14px;
	display: inline-flex;
	align-items: center;
	gap: 5px;
}

.tag i {
	font-size: 12px;
}

.resume-actions {
	display: flex;
	gap: 10px;
}

.select-resume {
	padding: 8px 20px;
	background-color: #47b2e4;
	border: none;
	border-radius: 5px;
	color: white;
	font-weight: 500;
	transition: all 0.1s ease;
}

.select-resume:hover {
	background-color: #3592c4;
}

.edit-resume {
	padding: 8px 20px;
	border: 1px solid #47b2e4;
	border-radius: 5px;
	color: #47b2e4;
	font-weight: 500;
	transition: all 0.3s ease;
	display: inline-flex;
	align-items: center;
	gap: 5px;
}

.edit-resume:hover {
	background-color: #47b2e4;
	color: white;
}

.alert-link {
	color: #37517e;
	text-decoration: none;
	font-weight: 600;
}

.alert-link:hover {
	text-decoration: underline;
}

/* 페이징 스타일 */
.pagination-container {
	margin-top: 30px;
	margin-bottom: 30px;
}

.pagination {
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
	color: #37517e;
	border-color: #37517e;
	transform: translateY(-2px);
}

.pagination .page-item.active .page-link {
	background-color: #37517e;
	color: #fff;
	border-color: #37517e;
}

.pagination .page-item:first-child .page-link, .pagination .page-item:last-child .page-link
	{
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

.newResumeBtn {
	background-color: #47b2e4;
	color: white;
	height: 40px;
	font-weight: 500;
	transition: all 0.3s ease;
	border-radius: 5px;
	border: none;
}

.newResumeBtn:hover {
	background-color: #3592c4;
}

.submit-button-container {
	margin-top: 30px;
}

#submitResumeBtn {
	background-color: #47b2e4;
	border: none;
	padding: 12px 30px;
	font-size: 18px;
	transition: all 0.3s ease;
}

#submitResumeBtn:disabled {
	background-color: #adb5bd;
	cursor: not-allowed;
}

#submitResumeBtn:not(:disabled):hover {
	background-color: #3592c4;
	transform: translateY(-2px);
}

.section-icon {
	color: #37517e;
}
</style>

<script>
	// 페이지 로드 시 실행
	$(document).ready(
			function() {
				// Bootstrap 툴팁 초기화
				var tooltipTriggerList = [].slice.call(document
						.querySelectorAll('[data-bs-toggle="tooltip"]'))
				var tooltipList = tooltipTriggerList.map(function(
						tooltipTriggerEl) {
					return new bootstrap.Tooltip(tooltipTriggerEl)
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// Collapse 이벤트 펼치면 사라지게
				$('#consentDetails').on('show.bs.collapse', function() {
					$('#toggleText').text('');
					$('#toggleButton i').removeClass('fa-chevron-down')
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 급여 금액에 콤마 추가
				var payAmount = $('#payAmount').text();
				if (payAmount) {
					$('#payAmount').text(Number(payAmount).toLocaleString());
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 날짜 형식 변환
				var dueDate = $('#dueDate').text();
				if (dueDate) {
					// 날짜 형식 변환 (YYYY-MM-DD)
					var date = new Date(dueDate);
					var formattedDate = date.getFullYear() + '-'
							+ (String(date.getMonth() + 1).padStart(2, '0'))
							+ '-' + (String(date.getDate()).padStart(2, '0'));
					$('#dueDate').text(formattedDate);
				}

				let selectedResumeId = null;
				//---------------------------------------------------------------------------------------------------------------------------------
				// 이력서 항목 클릭 이벤트
				$('.resume-item').click(function() {
					// 이전 선택 제거
					$('.resume-item').removeClass('selected');

					// 현재 항목 선택
					$(this).addClass('selected');
					selectedResumeId = $(this).data('resume-id');

					// 제출 버튼 활성화 여부 확인
					toggleSubmitButton();
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 개인정보 동의 체크박스 변경 이벤트
				$('#privacyConsentCheckbox').change(function() {
					// 제출 버튼 활성화 여부 확인
					toggleSubmitButton();
				});

				// 제출 버튼 활성화 여부 확인 함수
				function toggleSubmitButton() {
					if (selectedResumeId
							&& $('#privacyConsentCheckbox').is(':checked')) {
						$('#submitResumeBtn').prop('disabled', false);
					} else {
						$('#submitResumeBtn').prop('disabled', true);
					}
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 제출하기 버튼 클릭 이벤트
				$('#submitResumeBtn').click(
						function() {
							if (!selectedResumeId) {
								alert('이력서를 선택해주세요.');
								return;
							}

							const recruitmentId = new URLSearchParams(
									window.location.search).get('uid');
							if (!recruitmentId) {
								alert('공고 정보가 없습니다.');
								return;
							}

							// 이력서 제출 처리
							$.ajax({
								url : '/submission/submit',
								type : 'POST',
								data : {
									resumeNo : selectedResumeId,
									recruitmentNo : recruitmentId
								},
								success : function(response) {
									alert('이력서가 성공적으로 제출되었습니다.');
									// 제출 후 목록 페이지로 이동
									window.location.href = '/submission/list';
								},
								error : function(xhr, status, error) {
									alert('이력서 제출 중 오류가 발생했습니다: ' + error);
								}
							});
						});
			});
</script>