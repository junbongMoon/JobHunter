<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>이력서 작성</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="container my-5">
		<h2 class="mb-4">이력서 작성</h2>

		<form id="resumeForm" method="post" enctype="multipart/form-data">

			<!-- 이력서 제목 -->
			<div class="mb-4">
				<label for="title" class="form-label fw-bold">이력서 제목</label> <input
					type="text" class="form-control" id="title" name="title"
					placeholder="예: 자바 개발자 지원" required />
			</div>

			<!-- 기본 정보 (users 테이블에서 가져올 예정) -->
			<div class="card mb-4">
				<div class="card-header">기본 정보</div>
				<div class="card-body">
					<div class="row g-3">
						<div class="col-md-4">
							<label class="form-label">이름</label> <input type="text"
								class="form-control" value="임시 사용자" readonly />
						</div>
						<div class="col-md-4">
							<label class="form-label">이메일</label> <input type="email"
								class="form-control" value="test@example.com" readonly />
						</div>
						<div class="col-md-4">
							<label class="form-label">연락처</label> <input type="tel"
								class="form-control" value="010-0000-0000" readonly />
						</div>
					</div>
				</div>
			</div>

			<!-- 고용 형태 -->
			<div class="card mb-4">
				<div class="card-header jobTypeBox">고용 형태</div>
				<div class="card-body">
					<div class="row g-3">
						<div class="col-md-12">
							<div class="d-flex flex-wrap">
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="checkbox" name="jobForm"
										value="FULL_TIME" id="fullTime"> <label
										class="form-check-label" for="fullTime">정규직</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="checkbox" name="jobForm"
										value="CONTRACT" id="contract"> <label
										class="form-check-label" for="contract">계약직</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="checkbox" name="jobForm"
										value="DISPATCH" id="dispatch"> <label
										class="form-check-label" for="dispatch">파견직</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="checkbox" name="jobForm"
										value="PART_TIME" id="partTime"> <label
										class="form-check-label" for="partTime">아르바이트</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="checkbox" name="jobForm"
										value="COMMISSION" id="commission"> <label
										class="form-check-label" for="commission">위촉직</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="checkbox" name="jobForm"
										value="FREELANCE" id="freelance"> <label
										class="form-check-label" for="freelance">프리랜서</label>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- 희망 급여 -->
			<div class="card mb-4">
				<div class="card-header">희망 급여</div>
				<div class="card-body">
					<div class="row g-3 align-items-center">
						<div class="col-md-8">
							<div class="d-flex align-items-center">
								<label class="form-label me-3">급여 방식</label>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="payType"
										value="시급" id="hourly"> <label
										class="form-check-label" for="hourly">시급</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="payType"
										value="일급" id="daily"> <label class="form-check-label"
										for="daily">일급</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="payType"
										value="월급" id="monthly"> <label
										class="form-check-label" for="monthly">월급</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="payType"
										value="연봉" id="yearly"> <label
										class="form-check-label" for="yearly">연봉</label>
								</div>
								<div class="form-check form-check-inline">
									<input class="form-check-input" type="radio" name="payType"
										value="협의 후 결정" id="negotiable" checked> <label
										class="form-check-label" for="negotiable">협의 후 결정</label>
								</div>
							</div>
						</div>
						<div class="col-md-4 d-flex align-items-center">
							<input type="number" class="form-control text-end" id="payAmount"
								name="pay" placeholder="금액 입력" disabled> <span
								class="ms-2">원</span>
						</div>
					</div>
					<small class="text-muted">* 시급, 일급, 월급, 연봉의 경우 금액을 입력해 주세요.</small>
				</div>
			</div>

			<!-- 근무 지역 선택 -->
			<div class="card mb-4">
				<div class="card-header wishRegionBox" id="wishRegion">희망 근무
					지역</div>
				<div class="card-body">
					<div class="row">
						<!-- 시/도 목록 -->
						<div class="col-md-4">
							<div class="region-list-container"
								style="height: 300px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.25rem;">
								<ul class="list-group" id="regionList">
									<c:forEach var="region" items="${regionList}">
										<li class="list-group-item region-item"
											data-region="${region.regionNo}">${region.name}▶</li>
									</c:forEach>
								</ul>
							</div>
						</div>

						<!-- 시/군/구 목록 -->
						<div class="col-md-4">
							<div class="sigungu-list-container"
								style="height: 300px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.25rem;">
								<ul class="list-group" id="sigunguList">
									<li class="list-group-item text-muted">시/도를 선택하세요</li>
								</ul>
							</div>
						</div>

						<!-- 선택한 지역 표시 영역 -->
						<div class="col-md-4">
							<label class="form-label">선택한 지역</label>
							<div id="selectedRegions" class="mt-2"></div>
						</div>
					</div>
				</div>
			</div>

			<!-- 희망 업직종 -->
			<div class="card mb-4">
				<div class="card-header" id="wishJobBox">희망 업직종</div>
				<div class="card-body">
					<div class="row">
						<!-- 대분류 목록 -->
						<div class="col-md-4">
							<div class="major-list-container"
								style="height: 300px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.25rem;">
								<ul class="list-group" id="majorCategoryList">
									<c:forEach var="major" items="${majorList}">
										<li class="list-group-item major-item"
											data-major="${major.majorcategoryNo}">${major.jobName}▶</li>
									</c:forEach>
								</ul>
							</div>
						</div>

						<!-- 소분류 목록 -->
						<div class="col-md-4">
							<div class="sub-list-container"
								style="height: 300px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.25rem;">
								<ul class="list-group" id="subCategoryList">
									<li class="list-group-item text-muted">대분류를 선택하세요</li>
								</ul>
							</div>
						</div>

						<!-- 선택한 업직종 표시 영역 -->
						<div class="col-md-4">
							<label class="form-label">선택한 업직종</label>
							<div id="selectedJobTypes" class="mt-2"></div>
						</div>
					</div>
				</div>
			</div>

			<!-- 성격 및 강점 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<span id=myMerits>성격 및 강점</span>
					<button type="button" class="btn btn-primary btn-sm"
						data-bs-toggle="modal" data-bs-target="#meritModal">추가하기
					</button>
				</div>
				<div class="card-body">
					<div id="selectedMerits" class="mt-2"></div>
					<small class="text-muted">* 나의 성격 및 강점을 선택해 주세요(최대 5개)</small>
				</div>
			</div>

			<!-- 성격 및 강점 선택 모달 -->
			<div class="modal fade" id="meritModal" tabindex="-1"
				aria-labelledby="meritModalLabel" aria-hidden="true"
				data-bs-backdrop="static">
				<div class="modal-dialog modal-lg">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="meritModalLabel">성격 및 강점 선택</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close"></button>
						</div>
						<div class="modal-body">
							<div class="row g-2" role="group" aria-label="성격 및 강점 선택">
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="성실함" type="button">성실함</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="책임감" type="button">책임감</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="리더십" type="button">리더십</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="창의성" type="button">창의성</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="의사소통" type="button">의사소통</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="문제해결" type="button">문제해결</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="팀워크" type="button">팀워크</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="적극성" type="button">적극성</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="인내심" type="button">인내심</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="정확성" type="button">정확성</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="분석력" type="button">분석력</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="계획성" type="button">계획성</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="협동심" type="button">협동심</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="주도성" type="button">주도성</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="유연성" type="button">유연성</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="꼼꼼함" type="button">꼼꼼함</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="도전정신" type="button">도전정신</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="긍정성" type="button">긍정성</button>
								</div>
								<div class="col-md-3">
									<button class="btn btn-outline-primary w-100 merit-btn"
										data-merit="배려심" type="button">배려심</button>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">닫기</button>
						</div>
					</div>
				</div>
			</div>

			<!-- 학력사항 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center"
					id="myEducationBox">
					<span>학력사항</span>
					<button type="button" class="btn btn-primary btn-sm"
						id="addEducationBtn">추가하기</button>
				</div>
				<div class="card-body">
					<div id="educationContainer">
						<!-- 학력 항목 -->
					</div>
					<small class="text-muted">* 원하는 학력만 선택하여 작성이 가능해요.</small>
				</div>
			</div>

			<!-- 학력사항 템플릿 (추가 버튼 눌러야 나옴) -->
			<template id="educationTemplate">
				<div class="education-item border rounded p-3 mb-3 position-relative">
					<!-- 삭제 버튼 (X) -->
					<button type="button" class="btn-close position-absolute top-0 end-0 m-3 remove-education" 
						aria-label="삭제"></button>
					<div class="row g-3">
						<!-- 학력 구분 -->
						<div class="col-md-3">
							<label class="form-label">학력 구분</label> <select
								class="form-select education-level" name="educationLevel">
								<option value="">선택하세요</option>
								<option value="HIGH_SCHOOL">고등학교</option>
								<option value="JUNIOR_COLLEGE">전문대학</option>
								<option value="UNIVERSITY">대학교</option>
								<option value="GRADUATE">대학원</option>
							</select>
						</div>

						<!-- 졸업 상태 -->
						<div class="col-md-3">
							<label class="form-label">졸업 상태</label> <select
								class="form-select education-status" name="educationStatus">
								<option value="">선택하세요</option>
								<option value="GRADUATED">졸업</option>
								<option value="ENROLLED">재학중</option>
								<option value="ON_LEAVE">휴학중</option>
								<option value="DROPPED_OUT">중퇴</option>
							</select>
						</div>

						<!-- 학교명 입력 -->
						<div class="col-md-4">
							<label class="form-label">학교명</label> <input type="text"
								class="form-control custom-input" name="customInput"
								placeholder="학교명을 입력하세요">
						</div>
					</div>
				</div>
			</template>

			<!-- 경력사항 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center"
					id="myHistoryBox">
					<span>경력사항</span>
					<button type="button" class="btn btn-primary btn-sm"
						id="addHistoryBtn">추가하기</button>
				</div>
				<div class="card-body">
					<div id="historyContainer">
						<!-- 경력 항목 -->
					</div>
					<small class="text-muted">* 경력사항이 있는 경우에만 작성해 주세요.</small>
				</div>
			</div>

			<!-- 경력사항 템플릿 (추가 버튼 눌러야 나옴) -->
			<template id="historyTemplate">
				<div class="history-item border rounded p-3 mb-3 position-relative">
					<!-- 삭제 버튼 (X) -->
					<button type="button" class="btn-close position-absolute top-0 end-0 m-3 remove-history" 
						aria-label="삭제"></button>
					<div class="row g-3">
						<!-- 회사명 입력 -->
						<div class="col-md-6">
							<label class="form-label">회사명</label>
							<input type="text" class="form-control company-name" 
								name="companyName" placeholder="회사명을 입력하세요" maxlength="20">
						</div>

						<!-- 근무기간 -->
						<div class="col-md-4">
							<label class="form-label">근무기간</label>
							<div class="row g-2">
								<div class="col-md-4">
									<input type="date" class="form-control start-date" name="startDate">
								</div>
								<div class="col-md-1 text-center d-flex align-items-center justify-content-center">
									<span>~</span>
								</div>
								<div class="col-md-4">
									<input type="date" class="form-control end-date" name="endDate">
								</div>
							</div>
							<div class="form-check mt-2">
								<input type="checkbox" class="form-check-input currently-employed" id="currentlyEmployed">
								<label class="form-check-label" for="currentlyEmployed">재직중</label>
							</div>
						</div>

						<!-- 담당업무 입력 -->
						<div class="col-md-12">
							<label class="form-label">담당업무</label>
							<input type="text" class="form-control job-description" 
								name="jobDescription" placeholder="담당업무를 입력하세요" maxlength="100">
						</div>
					</div>
				</div>
			</template>

			<!-- 보유 자격증 -->
			<!-- 자기소개란 -->
			<!-- 파일 첨부 -->

			<!-- 임시 저장 버튼 -->
			<button type="button" class="btn btn-secondary" id="tempSaveBtn">임시
				저장</button>

			<!-- 완전 저장 버튼 -->
			<button type="button" class="btn btn-primary" id="finalSaveBtn">완전
				저장</button>

			<button type="button" class="btn btn-secondary" id="testBtn">코드
				테스트용 버튼</button>
		</form>

		<!-- 재사용 공용 경고 모달창 -->
		<div class="modal fade" id="validationModal" tabindex="-1"
			aria-labelledby="validationModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content text-center">
					<div class="modal-body">
						<p id="validationMessage" class="mb-3">알림 메시지</p>
						<button type="button" class="btn btn-primary"
							id="validationCheckBtn" data-bs-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>


	</div>
	<!-- 풋터 -->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</body>

</html>

<style>
/* 스크롤바 스타일링 - 모든 리스트 컨테이너에 적용 */
.region-list-container::-webkit-scrollbar, .sigungu-list-container::-webkit-scrollbar,
	.major-list-container::-webkit-scrollbar, .sub-list-container::-webkit-scrollbar
	{
	width: 8px;
	/* 스크롤바 너비 */
}

/* 스크롤바 트랙 스타일링 */
.region-list-container::-webkit-scrollbar-track, .sigungu-list-container::-webkit-scrollbar-track,
	.major-list-container::-webkit-scrollbar-track, .sub-list-container::-webkit-scrollbar-track
	{
	background: #f1f1f1;
	/* 트랙 배경색 */
	border-radius: 4px;
	/* 모서리 둥글게 */
}

/* 스크롤바 썸 스타일링 */
.region-list-container::-webkit-scrollbar-thumb, .sigungu-list-container::-webkit-scrollbar-thumb,
	.major-list-container::-webkit-scrollbar-thumb, .sub-list-container::-webkit-scrollbar-thumb
	{
	background: #888;
	/* 썸 배경색 */
	border-radius: 4px;
	/* 모서리 둥글게 */
}

/* 스크롤바 썸 호버 효과 */
.region-list-container::-webkit-scrollbar-thumb:hover,
	.sigungu-list-container::-webkit-scrollbar-thumb:hover,
	.major-list-container::-webkit-scrollbar-thumb:hover,
	.sub-list-container::-webkit-scrollbar-thumb:hover {
	background: #555;
	/* 호버 시 배경색 */
}

/* 리스트 아이템 스타일링 */
.list-group-item {
	cursor: pointer;
	/* 마우스 커서 포인터로 변경 */
	transition: background-color 0.2s;
	/* 배경색 변경 애니메이션 */
}

/* 리스트 아이템 호버 효과 */
.list-group-item:hover {
	background-color: #f8f9fa;
}

/* 선택된 시/도, 대분류 아이템 스타일링 */
.region-item.selected, .major-item.selected {
	background-color: #e9ecef;
	font-weight: bold;
}

/* 선택된 항목(뱃지) 스타일링 */
#selectedRegions .badge, #selectedJobTypes .badge {
	margin-bottom: 0.5rem;
	/* 뱃지 간격 */
	display: inline-block;
	/* 인라인 블록으로 표시 */
	padding: 0.5rem 0.75rem;
	/* 뱃지 내부 여백 */
}
</style>

<script>
			//---------------------------------------------------------------------------------------------------------------------------------
			$(document).ready(function () {
				// 시/도 클릭하면...
				$(".region-item").on("click", function () {
					// 기존에 누른 시/도 해제 및 현재 시/도 선택
					$(".region-item").removeClass("selected");
					$(this).addClass("selected");

					// 선택된 시/도의 번호와 시/군/구 목록 가져오기
					let regionNo = $(this).data("region");
					let $sigunguList = $("#sigunguList");

					// AJAX 요청으로 시/군/구 목록 가져오기
					$.ajax({
						url: "/resume/getSigungu",
						type: "GET",
						data: { regionNo: regionNo },
						dataType: "json",
						success: function (response) {
							if (response.error) {
								$sigunguList.html('<li class="list-group-item text-danger">' + response.error + '</li>');
								return;
							}

							$sigunguList.empty(); // 목록 초기화

							// 시/군/구 목록 동적 생성
							$.each(response, function (index, sigungu) {
								// 리스트 생성
								let $li = $("<li>").addClass("list-group-item sigungu-item");

								// 체크박스 생성
								let $checkbox = $("<input>")
									.attr({
										type: "checkbox",
										class: "form-check-input me-2",
										value: sigungu.sigunguNo,
										id: "sigungu_" + sigungu.sigunguNo,
										"data-name": sigungu.name,
										"data-region": regionNo // 시/도 번호 저장
									});

								// 라벨 생성
								let $label = $("<label>")
									.attr({
										class: "form-check-label",
										for: "sigungu_" + sigungu.sigunguNo
									})
									.text(sigungu.name);

								// 체크박스와 라벨을 리스트에 추가
								$li.append($checkbox).append($label);

								// 체크박스 상태 변경 이벤트
								$checkbox.on("change", function () {
									let selectedRegions = $("#selectedRegions");
									let sigunguNo = $(this).val();
									let sigunguName = $(this).data("name");
									let currentRegion = $(this).data("region");

									// 현재 선택된 시/도의 체크박스만 처리
									if (currentRegion === regionNo) {
										if ($(this).prop("checked")) {
											// 체크박스가 체크되면 선택된 지역 목록에 추가
											let $badge = $("<span>")
												.addClass("badge bg-primary me-2")
												.text(sigunguName)
												.attr("data-region", regionNo); // 시/도 정보 저장

											// 삭제 버튼 생성 및 삭제 기능
											let $removeBtn = $("<button>")
												.addClass("btn-close ms-2")
												.on("click", function () {
													$badge.remove();
													$("#sigungu_" + sigunguNo).prop("checked", false);
												});

											$badge.append($removeBtn);
											selectedRegions.append($badge);
										} else {
											// 체크박스가 해제되면 선택된 지역 목록에서 제거
											selectedRegions.find(".badge").each(function () {
												if ($(this).text().trim() === sigunguName && $(this).data("region") === regionNo) {
													$(this).remove();
												}
											});
										}
									} else {
										// 다른 시/도의 체크박스는 체크 해제
										$(this).prop("checked", false);
									}
								});

								// 이미 선택된 시/군/구인 경우 체크박스 체크
								$("#selectedRegions").find(".badge").each(function () {
									if ($(this).text().trim() === sigungu.name && $(this).data("region") === regionNo) {
										$checkbox.prop("checked", true);
										return false; // each 중단
									}
								});

								$sigunguList.append($li);
							});
						},
						error: function (xhr, status, error) {
							console.error("Error:", error);
							$sigunguList.html('<li class="list-group-item text-danger">불러오기 실패</li>');
						}
					});
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 대분류 클릭
				$(".major-item").on("click", function () {
					// 이전 선택 해제 및 현재 항목 선택 표시
					$(".major-item").removeClass("selected");
					$(this).addClass("selected");

					// 선택된 대분류의 번호와 소분류 목록 가져오기
					let majorNo = $(this).data("major");
					let $subCategoryList = $("#subCategoryList");

					// AJAX 요청으로 소분류 목록 가져오기
					$.ajax({
						url: "/resume/getSubCategory",
						type: "GET",
						data: { majorNo: majorNo },
						dataType: "json",
						success: function (response) {
							if (response.error) {
								$subCategoryList.html('<li class="list-group-item text-danger">' + response.error + '</li>');
								return;
							}

							$subCategoryList.empty(); // 목록 초기화

							// 소분류 목록 동적 생성
							$.each(response, function (index, sub) {
								// 리스트 생성
								let $li = $("<li>").addClass("list-group-item sub-item");

								// 체크박스 생성
								let $checkbox = $("<input>")
									.attr({
										type: "checkbox",
										class: "form-check-input me-2",
										value: sub.subcategoryNo,
										id: "sub_" + sub.subcategoryNo,
										"data-name": sub.jobName,
										"data-major": majorNo // 대분류 번호 저장
									});

								// 라벨 생성
								let $label = $("<label>")
									.attr({
										class: "form-check-label",
										for: "sub_" + sub.subcategoryNo
									})
									.text(sub.jobName);

								// 체크박스와 라벨을 리스트에 추가
								$li.append($checkbox).append($label);

								// 체크박스 상태 변경
								$checkbox.on("change", function () {
									let selectedJobTypes = $("#selectedJobTypes");
									let subNo = $(this).val();
									let subName = $(this).data("name");
									let currentMajor = $(this).data("major");

									// 현재 선택된 대분류의 체크박스만 처리
									if (currentMajor === majorNo) {
										if ($(this).prop("checked")) {
											// 체크박스가 체크되면 선택된 업직종 목록에 추가
											let $badge = $("<span>")
												.addClass("badge bg-primary me-2")
												.text(subName)
												.attr("data-major", majorNo); // 대분류 정보 저장

											// 삭제 버튼 생성 및 삭제 기능
											let $removeBtn = $("<button>")
												.addClass("btn-close ms-2")
												.on("click", function () {
													$badge.remove();
													$("#sub_" + subNo).prop("checked", false);
												});

											$badge.append($removeBtn);
											selectedJobTypes.append($badge);
										} else {
											// 체크박스가 해제되면 선택된 업직종 목록에서 제거
											selectedJobTypes.find(".badge").each(function () {
												if ($(this).text().trim() === subName && $(this).data("major") === majorNo) {
													$(this).remove();
												}
											});
										}
									} else {
										// 다른 대분류의 체크박스는 체크 해제
										$(this).prop("checked", false);
									}
								});

								// 이미 선택된 소분류인 경우 체크박스 체크
								$("#selectedJobTypes").find(".badge").each(function () {
									if ($(this).text().trim() === sub.jobName && $(this).data("major") === majorNo) {
										$checkbox.prop("checked", true);
										return false; // each 중단
									}
								});

								$subCategoryList.append($li);
							});
						},
						error: function (xhr, status, error) {
							console.error("Error:", error);
							$subCategoryList.html('<li class="list-group-item text-danger">불러오기 실패</li>');
						}
					});
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 급여 입력 활성화 / 비활성화	
				document.querySelectorAll('input[name="payType"]').forEach(radio => {
					radio.addEventListener('change', function () {
						const payInput = document.getElementById("payAmount");
						if (this.value === "협의 후 결정") {
							payInput.value = "";
							payInput.disabled = true;
						} else {
							payInput.disabled = false;
						}
					});
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 코드 테스트용 버튼 클릭 이벤트
				$('#testBtn').on('click', function () {
					// 유효성 검사
					const title = $('#title').val().trim();
					const titleLength = $('#title').val().length;
					if (!title) {
						showValidationModal("이력서 제목을 입력해주세요.", "#title");
						return;
					}

					if (titleLength > 30) {
						showValidationModal("이력서 제목은 30자 이내로 작성해주세요.", "#title");
						return;
					}

					const jobFormCount = $('input[name="jobForm"]:checked').length;
					if (jobFormCount === 0) {
						showValidationModal("희망 고용형태를 하나 이상 선택해주세요.", "#fullTime");
						return;
					}

					const payType = $('input[name="payType"]:checked').val();
					const payAmount = $('#payAmount').val().trim();
					if (payType !== '협의 후 결정' && (!payAmount || payAmount <= 0)) {
						showValidationModal("희망 금액을 입력해주세요", "#payAmount");
						return;
					}

					const regionCount = $('#selectedRegions .badge').length;
					if (regionCount === 0) {
						showValidationModal("희망 근무지를 선택해 주세요");
						$("#wishRegion").attr("tabindex", -1).focus();
						return;
					}

					const jobTypeCount = $('#selectedJobTypes .badge').length;
					if (jobTypeCount === 0) {
						showValidationModal("희망 업직종을 선택해 주세요");
						$("#wishJobBox").attr("tabindex", -1).focus();
						return;
					}

					const meritCount = $('#selectedMerits .badge').length;
					if (meritCount === 0) {
						showValidationModal("성격 및 강점을 선택해 주세요");
						$("#myMerits").attr("tabindex", -1).focus();
						return;
					}

					// 학력을 추가하였는가 확인하고 추가하였다면 값을 입력하지 않았을 시 학력사항에 입력사항이 누락되었음을 알리고 입력을 하도록 유도
					const educationItems = $('.education-item');
					if (educationItems.length > 0) {
						let isValid = true;

						educationItems.each(function () {
							const educationLevel = $(this).find('.education-level').val();
							const educationStatus = $(this).find('.education-status').val();
							const customInput = $(this).find('.custom-input').val().trim();

							if (!educationLevel || !educationStatus || !customInput) {
								isValid = false;
								return false; // each 중단
							}
						});

						if (!isValid) {
							showValidationModal("학력사항에 입력사항이 누락되었습니다.");
							$("#myEducationBox").attr("tabindex", -1).focus();
							return;
						}
					}

					// 경력사항 유효성 검사 -> 학력과 유사한 형식
					const historyItems = $('.history-item');
					if (historyItems.length > 0) {
						let isValid = true;

						historyItems.each(function () {
							const companyName = $(this).find('.company-name').val().trim();
							const jobDescription = $(this).find('.job-description').val().trim();
							const startDate = $(this).find('.start-date').val();
							const isCurrentlyEmployed = $(this).find('.currently-employed').is(':checked');
							const endDate = $(this).find('.end-date').val();

							if (!companyName || !jobDescription || !startDate) {
								isValid = false;
								focusElement = $(this).find(':input[value=""]:first');
								return false; // each 중단
							}

							// 재직중이 아닌 경우에만 종료일 체크
							if (!isCurrentlyEmployed && !endDate) {
								isValid = false;
								return false;
							}
						});

						if (!isValid) {
							showValidationModal("경력사항에 입력사항이 누락되었습니다.");
							$("#myHistoryBox").attr("tabindex", -1).focus();
							return;
						}
					}

					console.log("유효성 검사 통과");

					// 폼 데이터 수집
					const formData = {
						title: $('#title').val(),
						payType: $('input[name="payType"]:checked').val(),
						pay: $('#payAmount').val(),
						jobForms: $('input[name="jobForm"]:checked').map(function () {
							return {
								form: $(this).val()
							};
						}).get(),
						sigunguNos: $('#selectedRegions').find('.badge').map(function () {
							let sigunguName = $(this).text().trim();
							return $('input[data-name="' + sigunguName + '"]').val();
						}).get(),
						subcategoryNos: $('#selectedJobTypes').find('.badge').map(function () {
							let subName = $(this).text().trim();
							return $('input[data-name="' + subName + '"]').val();
						}).get(),
						merits: $('#selectedMerits').find('.badge').map(function () {
							return {
								meritContent: $(this).data('merit')
							};
						}).get(),
						educations: $('.education-item').map(function () {
							return {
								educationLevel: $(this).find('.education-level').val(),
								educationStatus: $(this).find('.education-status').val(),
								customInput: $(this).find('.custom-input').val()
							};
						}).get(),
						histories: $('.history-item').map(function () {
							const $endDate = $(this).find('.end-date');
							const isCurrentlyEmployed = $(this).find('.currently-employed').is(':checked');
							return {
								companyName: $(this).find('.company-name').val(),
								jobDescription: $(this).find('.job-description').val(),
								startDate: $(this).find('.start-date').val(),
								endDate: isCurrentlyEmployed ? null : $endDate.val()
							};
						}).get()
					};

					console.log('저장할 데이터:', formData);
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// Temp 저장 버튼 클릭 이벤트
				$('#tempSaveBtn').on('click', function () {
					// 폼 데이터 수집
					const formData = {
						title: $('#title').val(),
						payType: $('input[name="payType"]:checked').val(),
						pay: $('#payAmount').val(),
						jobForms: $('input[name="jobForm"]:checked').map(function () {
							return {
								form: $(this).val()
							};
						}).get(),
						sigunguNos: $('#selectedRegions').find('.badge').map(function () {
							let sigunguName = $(this).text().trim();
							return $('input[data-name="' + sigunguName + '"]').val();
						}).get(),
						subcategoryNos: $('#selectedJobTypes').find('.badge').map(function () {
							let subName = $(this).text().trim();
							return $('input[data-name="' + subName + '"]').val();
						}).get(),
						merits: $('#selectedMerits').find('.badge').map(function () {
							return {
								meritContent: $(this).data('merit')
							};
						}).get(),
						educations: $('.education-item').map(function () {
							return {
								educationLevel: $(this).find('.education-level').val(),
								educationStatus: $(this).find('.education-status').val(),
								customInput: $(this).find('.custom-input').val()
							};
						}).get(),
						histories: $('.history-item').map(function () {
							const $endDate = $(this).find('.end-date');
							const isCurrentlyEmployed = $(this).find('.currently-employed').is(':checked');
							return {
								companyName: $(this).find('.company-name').val(),
								jobDescription: $(this).find('.job-description').val(),
								startDate: $(this).find('.start-date').val(),
								endDate: isCurrentlyEmployed ? null : $endDate.val()
							};
						}).get()
					};

					console.log('저장할 데이터:', formData);

					$.ajax({
						url: '/resume/submit-temp',
						type: 'POST',
						data: JSON.stringify(formData),
						contentType: 'application/json',
						success: function (response) {
							if (response.success) {
								window.location.href = response.redirectUrl;
							} else {
								alert(response.message);
							}
						},
						error: function (xhr, status, error) {
							console.error('Error details:', {
								status: status,
								error: error,
								response: xhr.responseText
							});
							alert('저장 중 오류가 발생했습니다. 콘솔을 확인해주세요.');
						}
					});
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 최종 저장 버튼 클릭 이벤트
				$('#finalSaveBtn').on('click', function () {
					// 폼 데이터 수집
					const formData = {
						title: $('#title').val(),
						payType: $('input[name="payType"]:checked').val(),
						pay: $('#payAmount').val(),
						jobForms: $('input[name="jobForm"]:checked').map(function () {
							return {
								form: $(this).val()
							};
						}).get(),
						sigunguNos: $('#selectedRegions').find('.badge').map(function () {
							let sigunguName = $(this).text().trim();
							return $('input[data-name="' + sigunguName + '"]').val();
						}).get(),
						subcategoryNos: $('#selectedJobTypes').find('.badge').map(function () {
							let subName = $(this).text().trim();
							return $('input[data-name="' + subName + '"]').val();
						}).get(),
						merits: $('#selectedMerits').find('.badge').map(function () {
							return {
								meritContent: $(this).data('merit')
							};
						}).get(),
						educations: $('.education-item').map(function () {
							return {
								educationLevel: $(this).find('.education-level').val(),
								educationStatus: $(this).find('.education-status').val(),
								customInput: $(this).find('.custom-input').val()
							};
						}).get(),
						histories: $('.history-item').map(function () {
							const $endDate = $(this).find('.end-date');
							const isCurrentlyEmployed = $(this).find('.currently-employed').is(':checked');
							return {
								companyName: $(this).find('.company-name').val(),
								jobDescription: $(this).find('.job-description').val(),
								startDate: $(this).find('.start-date').val(),
								endDate: isCurrentlyEmployed ? null : $endDate.val()
							};
						}).get()
					};

					console.log('저장할 데이터:', formData);

					$.ajax({
						url: '/resume/submit-final',
						type: 'POST',
						data: JSON.stringify(formData),
						contentType: 'application/json',
						success: function (response) {
							if (response.success) {
								window.location.href = response.redirectUrl;
							} else {
								alert(response.message);
							}
						},
						error: function (xhr, status, error) {
							console.error('Error details:', {
								status: status,
								error: error,
								response: xhr.responseText
							});
							alert('저장 중 오류가 발생했습니다. 콘솔을 확인해주세요.');
						}
					});
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 유효성 검사 모달
				function showValidationModal(message, focusSelector) {
					$('#validationMessage').text(message); // 메시지 설정
					$('#validationModal').modal('show');   // 모달 띄우기

					// 모달이 닫히면 해당 요소로 포커스 이동
					$('#validationCheckBtn').off('click').on('click', function () {
						if (focusSelector) {
							$(focusSelector).focus();
						}
					});
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 성격 및 강점 버튼 클릭 이벤트
				$('.merit-btn').on('click', function () {
					const merit = $(this).data('merit');
					const selectedMerits = $('#selectedMerits');

					// 이미 선택된 성격인지 확인 (텍스트 내용으로 비교)
					let isDuplicate = false;
					let $existingBadge = null;
					selectedMerits.find('.badge').each(function () {
						if ($(this).text().trim() === merit) {
							isDuplicate = true;
							$existingBadge = $(this);
							return false; // each 루프 중단
						}
					});

					if (isDuplicate) {
						// 이미 선택된 항목이면 제거
						$existingBadge.remove();
						// 버튼 스타일 초기화
						$(this).removeClass('btn-primary').addClass('btn-outline-primary');
					} else {
						// 현재 선택된 항목 수 확인
						const currentCount = selectedMerits.find('.badge').length;
						if (currentCount >= 5) {

							return;
						}

						// 새로운 뱃지 생성
						const $badge = $('<span>')
							.addClass('badge bg-primary me-2 mb-2')
							.text(merit)
							.attr('data-merit', merit);

						// 삭제 버튼 추가
						const $removeBtn = $('<button>')
							.addClass('btn-close ms-2')
							.attr('aria-label', merit + ' 삭제')
							.on('click', function () {
								$badge.remove();
								// 삭제 시 버튼 스타일 초기화
								$(`.merit-btn[data-merit="${merit}"]`).removeClass('btn-primary').addClass('btn-outline-primary');
							});

						$badge.append($removeBtn);
						selectedMerits.append($badge);

						// 버튼 스타일 변경
						$(this).removeClass('btn-outline-primary').addClass('btn-primary');
					}
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 성격 및 강점 선택 모달이 열릴 때 포커스 관리
				$('#meritModal').on('shown.bs.modal', function () {
					// 모달이 열릴 때 첫 번째 버튼에 포커스
					$(this).find('.merit-btn').first().focus();
				});

				//---------------------------------------------------------------------------------------------------------------------------------
				// 학력 추가 버튼 클릭 이벤트
				$('#addEducationBtn').on('click', function () {
					const template = document.querySelector('#educationTemplate');
					const clone = template.content.cloneNode(true);
					$('#educationContainer').append(clone);
				});

				// 학력 삭제 버튼 클릭 이벤트
				$(document).on('click', '.remove-education', function () {
					$(this).closest('.education-item').remove();
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 경력 추가 버튼 클릭 이벤트
				$('#addHistoryBtn').on('click', function () {
					const template = document.querySelector('#historyTemplate');
					const clone = template.content.cloneNode(true);
					$('#historyContainer').append(clone);
				});

				// 경력 삭제 버튼 클릭 이벤트
				$(document).on('click', '.remove-history', function () {
					$(this).closest('.history-item').remove();
				});

				// 재직중 체크박스 이벤트
				$(document).on('change', '.currently-employed', function() {
					const $endDate = $(this).closest('.history-item').find('.end-date');
					if ($(this).is(':checked')) {
						$endDate.val('').prop('disabled', true);
					} else {
						$endDate.prop('disabled', false);
					}
				});
				//---------------------------------------------------------------------------------------------------------------------------------


			});

		</script>