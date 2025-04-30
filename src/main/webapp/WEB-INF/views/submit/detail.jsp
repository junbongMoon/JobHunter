<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>이력서 조회</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
	<jsp:include page="/WEB-INF/views/header.jsp" />
	<!-- 헤더 -->
	<div class="container my-5">
		<h2 class="mb-4">${submit.title}</h2>
		<form onsubmit="return false;">

			<!-- 기본 정보 (users 테이블에서 가져올 예정) -->
			<div class="card mb-4">
				<div class="card-header">기본 정보</div>
				<div class="card-body">
					<div class="row g-3">
						<!-- 증명사진 업로드 -->
						<div class="col-md-2">
							<div
								class="d-flex justify-content-center align-items-center border rounded position-relative photoUploadBox"
								style="height: 200px; background-color: #f8f9fa;">
								<c:choose>
									<c:when test="${not empty submit.profileBase64}">
										<img id="photoPreview" src="${submit.profileBase64}"
											alt="사진 미리보기" style="max-height: 100%; max-width: 100%;">
									</c:when>
									<c:otherwise>
										<span>증명사진 없음</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="col-md-9 pContent">
							<div class="row g-3">
								<div class="col-md-4">
									<label class="form-label">이름</label> <input type="text"
										class="form-control" value="${submit.userName}" readonly>
								</div>
								<div class="col-md-4">
									<label class="form-label">나이</label>
									<c:choose>
										<c:when test="${not empty submit.age}">
											<input type="text" class="form-control" value="${submit.age}"
												readonly>
										</c:when>
										<c:otherwise>
											<input type="text" class="form-control" value="나이 미공개"
												readonly>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="col-md-4">
									<label class="form-label">성별</label>
									<c:choose>
										<c:when test="${not empty submit.gender}">
											<input type="text" class="form-control"
												value="${submit.gender eq 'MALE' ? '남성':'여성'}" readonly>
										</c:when>
										<c:otherwise>
											<input type="text" class="form-control" value="비공개" readonly>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="col-md-4">
									<label class="form-label">이메일</label>
									<c:choose>
										<c:when test="${not empty submit.email}">
											<input type="email" class="form-control"
												value="${submit.email}" readonly>
										</c:when>
										<c:otherwise>
											<input type="email" class="form-control" value="등록된 이메일 없음"
												readonly>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="col-md-4">
									<label class="form-label">연락처</label>
									<c:choose>
										<c:when test="${not empty submit.mobile}">
											<input type="tel" class="form-control"
												value="${submit.mobile}" readonly>
										</c:when>
										<c:otherwise>
											<input type="tel" class="form-control" value="등록된 전화번호 없음"
												readonly>
										</c:otherwise>
									</c:choose>
								</div>
								<div class="col-md-4">
									<label class="form-label">거주지</label>
									<c:choose>
										<c:when test="${not empty submit.addr}">
											<input type="text" class="form-control"
												value="${submit.addr}" readonly>
										</c:when>
										<c:otherwise>
											<input type="text" class="form-control" value="등록된 거주지 없음"
												readonly>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<!-- 고용 형태 -->
			<div class="card mb-4">
				<div class="card-header jobTypeBox">희망 고용 형태</div>
				<div class="card-body">
					<div class="row g-3">
						<div class="col-md-12">
							<div class="d-flex flex-wrap">
								<c:forEach var="jobForm" items="${submit.jobForms}">
									<div class="form-check form-check-inline">
										<span class="badge bg-primary me-2">
											${jobForm.form.displayName} </span>
									</div>
								</c:forEach>
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
								<label class="form-label me-3">급여 방식 : ${submit.payType}</label>
							</div>
						</div>
						<div class="col-md-4 d-flex align-items-center">
							<input type="text" class="form-control text-end"
								value="${submit.pay}"> <span class="ms-2">원</span>
						</div>
					</div>
				</div>
			</div>

			<!-- 근무 지역 선택 -->
			<div class="card mb-4">
				<div class="card-header wishRegionBox" id="wishRegion">희망 근무
					지역</div>
				<div class="card-body">
					<div class="row">
						<!-- 선택한 지역 표시 영역 -->
						<div class="col-md-4">
							<c:forEach var="sigungu" items="${submit.sigunguList}">
								<span class="badge bg-primary me-2"> ${sigungu.name} </span>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>

			<!-- 희망 업직종 -->
			<div class="card mb-4">
				<div class="card-header" id="wishJobBox">희망 업직종</div>
				<div class="card-body">
					<div class="col-md-4">
						<c:forEach var="subcategory" items="${submit.subcategoryList}">
							<span class="badge bg-primary me-2">
								${subcategory.jobName} </span>
						</c:forEach>
					</div>
				</div>
			</div>

			<!-- 성격 및 강점 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<span id="myMerits">성격 및 강점</span>
				</div>
				<div class="card-body">
					<div class="col-md-4">
						<c:forEach var="merit" items="${submit.merits}">
							<span class="badge bg-primary me-2"> ${merit.meritContent}
							</span>
						</c:forEach>
					</div>
				</div>
			</div>

			<!-- 학력사항 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center"
					id="myEducationBox">
					<span>학력사항</span>
				</div>

				<div class="card-body">
					<div id="educationContainer">
						<!-- 학력 항목 -->

						<c:forEach var="education" items="${submit.educations}">

							<div
								class="education-item border rounded p-3 mb-3 position-relative">
								<div class="row g-3">
									<!-- 학력 레벨 선택 -->
									<div class="col-md-4">
										<label class="form-label">학력 구분</label> <select
											class="form-select education-level">
											<option>${education.educationLevel.displayName}</option>
										</select>
									</div>

									<!-- 학력 상태 선택 -->
									<div class="col-md-4">
										<label class="form-label">학력 상태</label> <select
											class="form-select education-status">
											<option>${education.educationStatus.displayName}</option>
										</select>
									</div>

									<!-- 졸업 날짜 -->
									<div class="col-md-4">
										<label class="form-label">졸업일자</label> <input type="text"
											class="form-control custom-input"
											value="${education.formattedGraduationDate}" readonly>
									</div>

									<!-- 학교명 입력 -->
									<div class="col-md-4">
										<label class="form-label">학교명</label> <input type="text"
											class="form-control custom-input"
											value="${education.customInput}" readonly>
									</div>
								</div>
							</div>

						</c:forEach>

					</div>
				</div>
			</div>

			<!-- 경력사항 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center"
					id="myHistoryBox">
					<span>경력사항</span>
				</div>
				<div class="card-body">
					<div id="historyContainer">
						<!-- 경력 항목 -->
						<c:forEach var="historie" items="${submit.histories}">

							<div
								class="history-item border rounded p-3 mb-3 position-relative">
								<div class="row g-3">
									<!-- 회사명 입력 -->
									<div class="col-md-6">
										<label class="form-label">회사명</label> <input type="text"
											class="form-control company-name"
											value="${historie.companyName}" readonly>
									</div>

									<!-- 직위 입력 -->
									<div class="col-md-6">
										<label class="form-label">직위</label> <input type="text"
											class="form-control position" value="${historie.position}"
											readonly>
									</div>

									<!-- 근무기간 -->
									<div class="col-md-6">
										<label class="form-label">근무기간</label>
										<div class="row g-3">
											<div class="col-md-5">
												<input type="text" class="form-control position"
													value="${historie.startDate}" readonly>
											</div>
											<div
												class="col-md-2 text-center d-flex align-items-center justify-content-center textflow">
												<span>~</span>
											</div>
											<div class="col-md-5">
												<input type="text" class="form-control position"
													value="${historie.endDate}" readonly>
											</div>
										</div>

									</div>

									<!-- 담당업무 입력 -->
									<div class="col-md-12">
										<label class="form-label">담당업무</label> <input type="text"
											class="form-control job-description"
											value="${historie.jobDescription}" readonly>
									</div>
								</div>
							</div>

						</c:forEach>
					</div>
				</div>
			</div>

			<!-- 보유 자격증 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center"
					id="myLicenseBox">
					<span>자격증</span>
				</div>
				<div class="card-body">
					<div id="licenseContainer">
						<!-- 자격증 항목 -->

						<c:forEach var="license" items="${submit.licenses}">

							<div
								class="license-item border rounded p-3 mb-3 position-relative">

								<div class="row g-3">
									<!-- 자격증명 입력 -->
									<div class="col-md-6">
										<label class="form-label">자격증명</label> <input type="text"
											class="form-control license-name"
											value="${license.licenseName}" readonly>
									</div>
									<!-- 발급기관 입력 -->
									<div class="col-md-6">
										<label class="form-label">발급기관</label> <input type="text"
											class="form-control institution"
											value="${license.institution}" readonly>
									</div>
									<!-- 취득날짜 -->
									<div class="col-md-4">
										<label class="form-label">취득날짜</label> <input type="text"
											class="form-control institution"
											value="${license.formattedAcquisitionDate}" readonly>
									</div>

								</div>
							</div>
						</c:forEach>

					</div>
				</div>
			</div>

			<!-- 자기소개란 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<span>자기소개</span>
				</div>
				<div class="card-body">
					<textarea class="form-control" id="selfIntroTextarea" rows="8"
						readonly>
								${submit.introduce}
							</textarea>
				</div>
			</div>


			<!-- 파일 첨부 -->
			<div class="card mb-4">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<span>첨부파일</span>

				</div>
				<div class="card-body">
					<div id="fileContainer" class="border rounded p-3">
						<div id="previewContainer" class="mt-3">
						</div>
					</div>
				</div>
			</div>

			<button type="button" class="btn btn-secondary" onclick="passedBtn()">합격</button>
			<button type="button" class="btn btn-secondary" onclick="failedBtn()">불합격</button>
			<button type="button" class="btn btn-secondary" id="returnBtn">목록으로</button>
	</div>
	</form>
	<!-- 풋터 -->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</body>

</html>

<script>

function changeStatusByregistration(status) {
	console.log(`/submit/status/\${status}/${submit.resumeNo}/${submit.recruitmentNoticePk}`);
	$.ajax({
		url: `/submit/status/\${status}/${submit.resumeNo}/${submit.recruitmentNoticePk}`,
		type: 'PUT',
		success: function (response) {
		console.log("상태 변경 성공:", response);
		window.publicModals.show("완료");
		},
		error: function (xhr, status, error) {
		console.error("상태 변경 실패:", error);
		window.publicModals.show("상태 변경 중 오류가 발생했습니다.");
		}
	});
}

	function failedBtn() {
		window.publicModals.show("정말로 불합격 처리 하시겠습니까?", {
			cancelText:"취소",
			onConfirm:()=>{
				changeStatusByregistration('FAILURE');
			}
		});
	}
	function passedBtn() {
		window.publicModals.show("정말로 합격 처리 하시겠습니까?", {
			cancelText:"취소",
			onConfirm:()=>{
				changeStatusByregistration('PASS');
			}
		});
	}

	$(()=>{
		$.ajax({
              url: `/submit/files/${submit.registrationNo}`,
              method: 'POST',
              contentType: 'application/json',
              success: function (res) {
				let text = '';
                res.forEach(file => {
					const textdiv = `
								<a href="/resources/resumeUpfiles\${file.newFileName}" download="\${file.originalFileName}">
									<div class="file-preview d-flex justify-content-between align-items-center p-2 mb-2 bg-light rounded">
										<div class="d-flex align-items-center">
											<i class="bi bi-file-earmark me-2"></i>
											<div>
												<div style="word-break: break-all;">\${file.originalFileName}</div>
												<small class="text-muted">\${file.size} byte</small>
											</div>
										</div>
									</div>
								</a>
					`
					text += textdiv;
				});
				$('#previewContainer').html(text)
              },
              error: function (xhr) {
                console.log("error : " + xhr);
              }
            });
	})
</script>

<style>
/* 전체 컨테이너 스타일 */
.container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 2rem;
}

/* 날짜 선택 필드 스타일 */
input[type="date"] {
	width: 100%;
	min-width: 150px;
	padding: 0.75rem 1rem;
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	transition: all 0.3s ease;
}

input[type="date"]:focus {
	border-color: var(- -accent-color);
	box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.25);
}

/* 제목 스타일 */
h2 {
	color: var(- -heading-color);
	font-family: var(- -heading-font);
	font-weight: 600;
	margin-bottom: 2rem;
	position: relative;
	padding-bottom: 1rem;
}

h2:after {
	content: '';
	position: absolute;
	left: 0;
	bottom: 0;
	width: 50px;
	height: 3px;
	background: var(- -accent-color);
}

/* 카드 스타일 */
.card {
	border: none;
	box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
	margin-bottom: 2rem;
	transition: all 0.3s ease;
}

.card:hover {
	transform: translateY(-5px);
	box-shadow: 0 5px 25px rgba(0, 0, 0, 0.15);
}

/* 카드 헤더 스타일 */
.card-header {
	background: var(- -heading-color);
	color: white;
	font-weight: 600;
	padding: 0.75rem 1rem;
	border-radius: 8px 8px 0 0 !important;
	min-height: 45px;
	display: inline-block;
	align-items: center;
	justify-content: space-between;
}

.card-header-advice {
	background: #47B2E4;
	color: white;
	font-weight: 600;
	padding: 0.75rem 1rem;
	border-radius: 8px 8px 0 0 !important;
	min-height: 45px;
	display: inline-block;
	align-items: center;
	justify-content: space-between;
}

.card-body {
	padding: 1.5rem;
}

/* 폼 요소 스타일 */
.form-control, .form-select {
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	padding: 0.75rem 1rem;
	transition: all 0.3s ease;
}

.form-control:focus, .form-select:focus {
	border-color: var(- -accent-color);
	box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.25);
}

/* 버튼 스타일 */
.btn {
	padding: 0.5rem 1rem;
	border-radius: 6px;
	font-weight: 500;
	transition: all 0.3s ease;
	font-size: 0.9rem;
}

.btn-sm {
	padding: 0.25rem 0.75rem;
	font-size: 0.85rem;
}

.btn-primary {
	background: var(- -accent-color);
	border: none;
}

.btn-primary:hover {
	background: color-mix(in srgb, var(- -accent-color), transparent 15%);
	transform: translateY(-2px);
}

.advice-file-input {
	background: #37517E;
	color: white;
}

.advice-file-input:hover {
	background: color-mix(in srgb, #37517E, transparent 15%);
	transform: translateY(-2px);
}

.btn-secondary {
	background: #6c757d;
	border: none;
}

.btn-secondary:hover {
	background: #5a6268;
	transform: translateY(-2px);
}

/* 필수 입력 항목 스타일 */
.essentialPoint {
	color: #dc3545;
	font-weight: bold;
	margin-left: 0;
	font-size: 0.9rem;
	display: inline;
}

/* 파일 업로드 영역 스타일 */
#fileContainer {
	border: 2px dashed var(- -accent-color);
	border-radius: 12px;
	padding: 2rem;
	text-align: center;
	transition: all 0.3s ease;
	background: rgba(71, 178, 228, 0.05);
}

#fileContainer:hover {
	background: rgba(71, 178, 228, 0.1);
}

.fileText {
	font-size: 1.1rem;
	color: #666;
	margin: 0;
}

/* 파일 미리보기 스타일 */
.file-preview {
	background: white;
	border-radius: 8px;
	padding: 1rem;
	margin-bottom: 1rem;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	transition: all 0.3s ease;
}

.file-preview:hover {
	transform: translateX(5px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 리스트 컨테이너 스타일 */
.region-list-container, .sigungu-list-container, .major-list-container,
	.sub-list-container {
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	background: white;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

/* 리스트 아이템 스타일 */
.list-group-item {
	border: none;
	padding: 0.75rem 1rem;
	transition: all 0.2s ease;
}

.list-group-item:hover {
	background: rgba(71, 178, 228, 0.1);
}

.list-group-item.selected {
	background: var(- -accent-color);
	color: white;
}

/* 뱃지 스타일 */
.badge {
	padding: 0.5rem 1rem;
	font-weight: 500;
	margin: 0.25rem;
	border-radius: 20px;
	display: inline-flex;
	align-items: center;
}

/* 모달 스타일 */
.modal-content {
	border: none;
	border-radius: 12px;
	box-shadow: 0 5px 25px rgba(0, 0, 0, 0.2);
}

.modal-header {
	background: var(- -heading-color);
	color: white;
	border-radius: 12px 12px 0 0;
	padding: 1.5rem;
}

.modal-body {
	padding: 2rem;
}

/* 성격 및 강점 버튼 스타일 */
.merit-btn {
	margin: 0.5rem;
	border-radius: 20px;
	padding: 0.5rem 1.5rem;
	transition: all 0.3s ease;
}

.merit-btn:hover {
	transform: translateY(-2px);
}

/* 스크롤바 스타일 */
::-webkit-scrollbar {
	width: 8px;
}

::-webkit-scrollbar-track {
	background: #f1f1f1;
	border-radius: 4px;
}

::-webkit-scrollbar-thumb {
	background: var(- -accent-color);
	border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
	background: color-mix(in srgb, var(- -accent-color), transparent 15%);
}

/* 반응형 스타일 */
@media ( max-width : 768px) {
	.container {
		padding: 1rem;
	}
	.card-header {
		padding: 0.75rem 1rem;
	}
	.card-body {
		padding: 1rem;
	}
	.btn {
		padding: 0.5rem 1rem;
	}
	#fileContainer {
		padding: 1rem;
	}
}

.textflow {
	margin-left: -10px;
	margin-right: -10px;
}

/* 이력서 제목 입력 스타일 */
#title {
	font-size: 1.1rem;
	padding: 0.8rem 1rem;
	border: 1px solid #e0e0e0;
	transition: all 0.3s ease;
}

#title:focus {
	border-color: var(- -accent-color);
	box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.25);
}

.input-group-text {
	border: 1px solid #e0e0e0;
	border-right: none;
	padding: 0.8rem 1rem;
}

.input-group-text i {
	font-size: 1.2rem;
	color: var(- -accent-color);
}

.pContent {
	margin-left: 40px;
	margin-top: 30px;
}

/* CSS 변수 정의 */
:root { -
	-accent-color: #47B2E4; -
	-heading-color: #37517E; -
	-heading-font: 'Poppins', sans-serif;
}
</style>
