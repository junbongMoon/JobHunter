<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
			<!DOCTYPE html>
			<html>

			<head>
				<meta charset="UTF-8">
				<title>이력서 작성</title>
				<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
				<link rel="stylesheet"
					href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
				<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
			</head>

			<body>
				<!-- 헤더 -->
				<jsp:include page="/WEB-INF/views/header.jsp" />

				<!-- resume.userUid 남기기 -->
				<input type="hidden" id="userUid" value="${ resumeDetail.resume.userUid }">
				<!-- session.userUid 남기기 -->
				<input type="hidden" id="sessionUserUid" value="${ sessionScope.user.userUid }">

				<div class="container my-5">
					<c:if test="${mode == 'advice'}">
						<h2 class="mb-4">[${resumeDetail.resume.title}] 이력서 첨삭</h2>
					</c:if>
					<c:if test="${mode != 'advice'}">
						<h2 class="mb-4">이력서 작성</h2>
					</c:if>

					<form id="resumeForm" method="post" enctype="multipart/form-data">

						<!-- 이력서 제목 -->
						<div class="card mb-4">
							<div class="card-header">
								이력서 제목<span class="essentialPoint">*</span>
							</div>
							<div class="card-body">
								<div class="input-group">
									<span class="input-group-text bg-light"> <i class="bi bi-pencil-square"></i>
									</span>
									<c:if test="${mode == 'advice'}">
										<input type="text" class="form-control form-control-lg" id="title" name="title"
											placeholder="예: 자바 개발자 지원" maxlength="30"
											value="${resumeDetail.resume.title}" readonly>
									</c:if>
									<c:if test="${mode != 'advice'}">
										<input type="text" class="form-control form-control-lg" id="title" name="title"
											placeholder="예: 자바 개발자 지원" maxlength="30"
											value="${resumeDetail.resume.title}">
									</c:if>
								</div>
								<div class="d-flex justify-content-between mt-2">
									<small class="text-muted">* 이력서의 제목을 입력해 주세요.</small> <small
										class="text-muted"><span id="titleLength">0</span> / 30</small>
								</div>
							</div>
						</div>

						<!-- 기본 정보 (users 테이블에서 가져올 예정) -->
						<div class="card mb-4">
							<div class="card-header">
								기본 정보<span class="essentialPoint">*</span>
							</div>
							<div class="card-body">
								<div class="row g-3">
									<!-- 증명사진 업로드 -->
									<div class="col-md-2">
										<div class="d-flex justify-content-center align-items-center border rounded position-relative photoUploadBox"
											style="height: 200px; background-color: #f8f9fa;">
											<input type="file" id="photoUpload" style="display: none;" accept="image/*">
											<label for="photoUpload" class="text-center" style="cursor: pointer;">
												<c:if test="${mode != 'advice'}">
													<i class="bi bi-plus-circle"
														style="font-size: 2rem; color: #6c757d;"></i><br>
													증명 사진 등록<span class="essentialPoint">*</span>
												</c:if>
											</label>

											<img id="photoPreview" src="#" alt="사진 미리보기"
												style="display: none; max-height: 100%; max-width: 100%;" />
											<c:if test="${mode != 'advice'}">
												<button type="button"
													class="btn-close position-absolute top-0 end-0 m-2 pCloseBtn"
													id="removePhoto"
													style="display: none; background-color: #47B2E4; border-radius: 50%; padding: 8px; border: 1px solid #37517E; box-shadow: 0 2px 5px rgba(0,0,0,0.2);">
												</button>
											</c:if>
										</div>
									</div>
									<input type="hidden" id="profileBase64" name="profileBase64" />
									<div class="col-md-9 pContent">
										<div class="row g-3">
											<div class="col-md-4">
												<label class="form-label">이름</label>
												<input type="text" class="form-control" value="${account.accountName}"
													readonly />
											</div>
											<div class="col-md-4">
												<label class="form-label">나이</label>
												<input type="text" class="form-control" value="${user.age}" readonly />
											</div>
											<div class="col-md-4">
												<label class="form-label">성별</label>
												<input type="text" class="form-control"
													value="${user.gender == 'MALE' ? '남성' : '여성'}" readonly />
											</div>
											<div class="col-md-4">
												<label class="form-label">이메일</label>
												<input type="email" class="form-control" value="${account.email}"
													readonly />
											</div>
											<div class="col-md-4">
												<label class="form-label">연락처</label>
												<input type="tel" class="form-control" value="${account.mobile}"
													readonly />
											</div>
											<div class="col-md-4">
												<label class="form-label">거주지</label>
												<input type="text" class="form-control" value="${user.addr}" readonly />
											</div>
										</div>
									</div>
									<small class="text-muted">* 2.5MB 이하의 이미지 파일만 등록 가능합니다.</small>
									<!-- userUid -->
									<input type="hidden" id="userUid" name="userUid" value="${account.uid}" />
								</div>
							</div>
						</div>

						<!-- 고용 형태 -->
						<div class="card mb-4">
							<div class="card-header jobTypeBox">
								고용 형태<span class="essentialPoint">*</span>
							</div>
							<div class="card-body">
								<div class="row g-3">
									<div class="col-md-12">
										<div class="d-flex flex-wrap">
											<c:forEach var="jobForm" items="${jobFormList}">
												<div class="form-check form-check-inline">
													<c:set var="isChecked" value="false" />
													<c:forEach var="selectedJobForm" items="${resumeDetail.jobForms}">
														<c:if test="${selectedJobForm.form == jobForm}">
															<c:set var="isChecked" value="true" />
														</c:if>
													</c:forEach>
													<!-- 조건: mode가 'advice'이면 disabled 속성 추가 -->
													<input class="form-check-input" type="checkbox" name="jobForm"
														value="${jobForm.name()}" id="${jobForm.name()}" ${isChecked
														? 'checked' : '' } <c:if test="${mode == 'advice'}">disabled
													</c:if>
													/>
													<label class="form-check-label"
														for="${jobForm.name()}">${jobForm.displayName}</label>
												</div>
											</c:forEach>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- 희망 급여 -->
						<div class="card mb-4">
							<div class="card-header">
								희망 급여<span class="essentialPoint">*</span>
							</div>
							<div class="card-body">
								<div class="row g-3 align-items-center">
									<div class="col-md-8">
										<div class="d-flex align-items-center">
											<label class="form-label me-3">급여 방식</label>
											<div class="form-check form-check-inline">
												<input class="form-check-input" type="radio" name="payType" value="시급"
													id="hourly" ${resumeDetail.resume.payType=='시급' ? 'checked' : '' }
													<c:if test="${mode == 'advice'}">disabled</c:if> />
												<label class="form-check-label" for="hourly">시급</label>
											</div>
											<div class="form-check form-check-inline">
												<input class="form-check-input" type="radio" name="payType" value="일급"
													id="daily" ${resumeDetail.resume.payType=='일급' ? 'checked' : '' }
													<c:if test="${mode == 'advice'}">disabled</c:if> />
												<label class="form-check-label" for="daily">일급</label>
											</div>
											<div class="form-check form-check-inline">
												<input class="form-check-input" type="radio" name="payType" value="월급"
													id="monthly" ${resumeDetail.resume.payType=='월급' ? 'checked' : '' }
													<c:if test="${mode == 'advice'}">disabled</c:if> />
												<label class="form-check-label" for="monthly">월급</label>
											</div>
											<div class="form-check form-check-inline">
												<input class="form-check-input" type="radio" name="payType" value="연봉"
													id="yearly" ${resumeDetail.resume.payType=='연봉' ? 'checked' : '' }
													<c:if test="${mode == 'advice'}">disabled</c:if> />
												<label class="form-check-label" for="yearly">연봉</label>
											</div>
											<div class="form-check form-check-inline">
												<input class="form-check-input" type="radio" name="payType"
													value="협의 후 결정" id="negotiable"
													${resumeDetail.resume.payType=='협의 후 결정' ? 'checked' : '' } <c:if
													test="${mode == 'advice'}">disabled</c:if> />
												<label class="form-check-label" for="negotiable">협의 후
													결정</label>
											</div>
										</div>
									</div>
									<div class="col-md-4 d-flex align-items-center">
										<input type="text" class="form-control text-end" id="payAmount" name="pay"
											placeholder="금액 입력(숫자만 입력 가능해요)" maxlength="11"
											value="${resumeDetail.resume.pay}" ${resumeDetail.resume.payType=='협의 후 결정'
											? 'disabled' : '' } <c:if test="${mode == 'advice'}">disabled</c:if> />
										<span class="ms-2">원</span>
									</div>
								</div>
								<small class="text-muted">* 시급, 일급, 월급, 연봉의 경우 금액을 입력해 주세요.</small>
							</div>
						</div>

						<!-- 근무 지역 선택 -->
						<div class="card mb-4">
							<div class="card-header wishRegionBox" id="wishRegion">
								희망 근무 지역<span class="essentialPoint">*</span>
							</div>
							<div class="card-body">
								<div class="row">
									<!-- 시/도 목록 -->
									<c:if test="${mode != 'advice'}">
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
									</c:if>
									<!-- 시/군/구 목록 -->
									<c:if test="${mode != 'advice'}">
										<div class="col-md-4">
											<div class="sigungu-list-container"
												style="height: 300px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.25rem;">
												<ul class="list-group" id="sigunguList">
													<li class="list-group-item text-muted">시/도를 선택하세요</li>
												</ul>
											</div>
										</div>
									</c:if>

									<!-- 선택한 지역 표시 영역 -->
									<div class="col-md-4">
										<c:if test="${mode != 'advice'}">
											<label class="form-label">선택한 지역</label>
										</c:if>
										<div id="selectedRegions" class="mt-2">
											<c:forEach var="selectedRegion" items="${selectedSigungu}">
												<span class="badge bg-primary me-2"
													data-region="${selectedRegion.regionNo}"
													data-sigungu="${selectedRegion.sigunguNo}">
													${selectedRegion.regionName} ${selectedRegion.name}
													<c:if test="${mode != 'advice'}">
														<button class="btn-close ms-2" aria-label="삭제"></button>
													</c:if>
												</span>
											</c:forEach>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- 희망 업직종 -->
						<div class="card mb-4">
							<div class="card-header" id="wishJobBox">
								희망 업직종<span class="essentialPoint">*</span>
							</div>
							<div class="card-body">
								<div class="row">
									<!-- 대분류 목록 -->
									<c:if test="${mode != 'advice'}">
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
									</c:if>

									<!-- 소분류 목록 -->
									<c:if test="${mode != 'advice'}">
										<div class="col-md-4">
											<div class="sub-list-container"
												style="height: 300px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.25rem;">
												<ul class="list-group" id="subCategoryList">
													<li class="list-group-item text-muted">대분류를 선택하세요</li>
												</ul>
											</div>
										</div>
									</c:if>

									<!-- 선택한 업직종 표시 영역 -->
									<div class="col-md-4">
										<c:if test="${mode != 'advice'}">
											<label class="form-label">선택한 업직종</label>
										</c:if>
										<div id="selectedJobTypes" class="mt-2">
											<!-- 디버깅 -->
											<!-- <c:if test="${empty selectedSubCategory}">
									<script>
										console.log('selectedSubCategory가 없음;');
									</script>
								</c:if> -->
											<c:forEach var="selectedJob" items="${selectedSubCategory}">
												<span class="badge bg-primary me-2"
													data-major="${selectedJob.majorCategoryNo}"
													data-sub="${selectedJob.subcategoryNo}">
													${selectedJob.jobName}
													<c:if test="${mode != 'advice'}">
														<button class="btn-close ms-2" aria-label="삭제"></button>
													</c:if>
												</span>
											</c:forEach>
										</div>
									</div>
								</div>
							</div>
						</div>

						<!-- 성격 및 강점 -->
						<div class="card mb-4">
							<div class="card-header d-flex justify-content-between align-items-center">
								<span id=myMerits>성격 및 강점<span class="essentialPoint">*</span></span>
								<c:if test="${mode != 'advice'}">
									<button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal"
										data-bs-target="#meritModal">추가하기</button>
								</c:if>
							</div>
							<div class="card-body">
								<div id="selectedMerits" class="mt-2">
									<c:forEach var="merit" items="${resumeDetail.merits}">
										<span class="badge bg-primary me-2 mb-2" data-merit="${merit.meritContent}">
											${merit.meritContent}
											<c:if test="${mode != 'advice'}">
												<button class="btn-close ms-2" aria-label="삭제"></button>
											</c:if>
										</span>
									</c:forEach>
								</div>
								<small class="text-muted">* 나의 성격 및 강점을 선택해 주세요(최대 5개)</small>
							</div>
						</div>

						<!-- 성격 및 강점 선택 모달 -->
						<div class="modal fade" id="meritModal" tabindex="-1" aria-labelledby="meritModalLabel"
							aria-hidden="true" data-bs-backdrop="static">
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
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="성실함"
													type="button">성실함</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="책임감"
													type="button">책임감</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="리더십"
													type="button">리더십</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="창의성"
													type="button">창의성</button>
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
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="팀워크"
													type="button">팀워크</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="적극성"
													type="button">적극성</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="인내심"
													type="button">인내심</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="정확성"
													type="button">정확성</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="분석력"
													type="button">분석력</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="계획성"
													type="button">계획성</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="협동심"
													type="button">협동심</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="주도성"
													type="button">주도성</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="유연성"
													type="button">유연성</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="꼼꼼함"
													type="button">꼼꼼함</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn"
													data-merit="도전정신" type="button">도전정신</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="긍정성"
													type="button">긍정성</button>
											</div>
											<div class="col-md-3">
												<button class="btn btn-outline-primary w-100 merit-btn" data-merit="배려심"
													type="button">배려심</button>
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
							<div class="card-header d-flex justify-content-between align-items-center"
								id="myEducationBox">
								<span>학력사항</span>
								<c:if test="${mode != 'advice'}">
									<button type="button" class="btn btn-primary btn-sm"
										id="addEducationBtn">추가하기</button>
								</c:if>
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
								<c:if test="${mode != 'advice'}">
									<button type="button"
										class="btn-close position-absolute top-0 end-0 m-3 remove-education"
										aria-label="삭제"></button>
								</c:if>
								<div class="row g-3">
									<!-- 학력 레벨 선택 -->
									<div class="col-md-4">
										<label class="form-label">학력 구분<span class="essentialPoint">*</span></label>
										<select class="form-select education-level" name="educationLevel">
											<option value="">선택하세요</option>
											<c:forEach var="level" items="${educationLevelList}">
												<option value="${level.name()}">${level.displayName}</option>
											</c:forEach>
										</select>
									</div>

									<!-- 학력 상태 선택 -->
									<div class="col-md-4">
										<label class="form-label">학력 상태<span class="essentialPoint">*</span></label>
										<select class="form-select education-status" name="educationStatus">
											<option value="">선택하세요</option>
											<c:forEach var="status" items="${educationStatusList}">
												<option value="${status.name()}">${status.displayName}</option>
											</c:forEach>
										</select>
									</div>

									<!-- 졸업 날짜 -->
									<div class="col-md-4">
										<label class="form-label">졸업일자<span class="essentialPoint">*</span></label>
										<div class="row g-2">
											<div class="col-md-4">
												<input type="date" class="form-control graduation-date"
													name="graduationDate">
											</div>
										</div>
									</div>

									<!-- 학교명 입력 -->
									<div class="col-md-4">
										<label class="form-label">학교명<span class="essentialPoint">*</span></label>
										<input type="text" class="form-control custom-input" name="customInput"
											placeholder="학교명을 입력하세요" maxlength="190">
									</div>
								</div>
							</div>
						</template>

						<!-- 경력사항 -->
						<div class="card mb-4">
							<div class="card-header d-flex justify-content-between align-items-center"
								id="myHistoryBox">
								<span>경력사항</span>
								<c:if test="${mode != 'advice'}">
									<button type="button" class="btn btn-primary btn-sm"
										id="addHistoryBtn">추가하기</button>
								</c:if>
							</div>
							<div class="card-body">
								<div id="historyContainer">
									<!-- 경력 항목 -->
								</div>
								<div>
									<small class="text-muted">* 경력사항이 있는 경우에만 작성해 주세요.</small>
								</div>
								<div>
									<small class="text-muted">* 경력사항을 허위로 기재시 법적책임을 질 수 있습니다.</small>
								</div>
							</div>
						</div>

						<!-- 경력사항 템플릿 (추가 버튼 눌러야 나옴) -->
						<template id="historyTemplate">
							<div class="history-item border rounded p-3 mb-3 position-relative">
								<!-- 삭제 버튼 (X) -->
								<c:if test="${mode != 'advice'}">
									<button type="button"
										class="btn-close position-absolute top-0 end-0 m-3 remove-history"
										aria-label="삭제"></button>
								</c:if>
								<div class="row g-3">
									<!-- 회사명 입력 -->
									<div class="col-md-6">
										<label class="form-label">회사명<span class="essentialPoint">*</span></label>
										<input type="text" class="form-control company-name" name="companyName"
											placeholder="회사명을 입력하세요" maxlength="20">
									</div>

									<!-- 직위 입력 -->
									<div class="col-md-6">
										<label class="form-label">직위<span class="essentialPoint">*</span></label>
										<input type="text" class="form-control position" name="position"
											placeholder="직위를 입력하세요" maxlength="45">
									</div>

									<!-- 근무기간 -->
									<div class="col-md-6">
										<label class="form-label">근무기간<span class="essentialPoint">*</span></label>
										<div class="row g-3">
											<div class="col-md-5">
												<input type="date" class="form-control start-date" name="startDate"
													max="${today}">
											</div>
											<div
												class="col-md-2 text-center d-flex align-items-center justify-content-center textflow">
												<span>~</span>
											</div>
											<div class="col-md-5">
												<input type="date" class="form-control end-date" name="endDate"
													max="${today}">
											</div>
										</div>
										<div class="form-check mt-2">
											<input type="checkbox" class="form-check-input currently-employed"
												id="currentlyEmployed"> <label class="form-check-label"
												for="currentlyEmployed">재직중</label>
										</div>
									</div>

									<!-- 담당업무 입력 -->
									<div class="col-md-12">
										<label class="form-label">담당업무<span class="essentialPoint">*</span></label>
										<input type="text" class="form-control job-description" id="jobDescription"
											name="jobDescription" placeholder="담당업무를 입력하세요(최대 100자)" maxlength="100">
										<div class="text-end">
											<span id="jobDescriptionCount" class="text-muted">0 / 100</span>
										</div>
									</div>
								</div>
							</div>
						</template>

						<!-- 보유 자격증 -->
						<div class="card mb-4">
							<div class="card-header d-flex justify-content-between align-items-center"
								id="myLicenseBox">
								<span>자격증</span>
								<c:if test="${mode != 'advice'}">
									<button type="button" class="btn btn-primary btn-sm"
										id="addLicenseBtn">추가하기</button>
								</c:if>
							</div>
							<div class="card-body">
								<div id="licenseContainer">
									<!-- 자격증 항목 -->
								</div>
								<small class="text-muted">* 자격증은 최대 10개까지 저장 가능합니다.</small>
							</div>
						</div>

						<!-- 자격증 템플릿 (추가 버튼 눌러야 나옴) -->
						<template id="licenseTemplate">
							<div class="license-item border rounded p-3 mb-3 position-relative">
								<!-- 삭제 버튼 (X) -->
								<c:if test="${mode != 'advice'}">
									<button type="button"
										class="btn-close position-absolute top-0 end-0 m-3 remove-license"
										aria-label="삭제"></button>
								</c:if>
								<div class="row g-3">
									<!-- 자격증명 입력 -->
									<div class="col-md-6">
										<label class="form-label">자격증명<span class="essentialPoint">*</span></label>
										<input type="text" class="form-control license-name" name="licenseName"
											placeholder="자격증명을 입력하세요" maxlength="30">
									</div>
									<!-- 발급기관 입력 -->
									<div class="col-md-6">
										<label class="form-label">발급기관<span class="essentialPoint">*</span></label>
										<input type="text" class="form-control institution" name="institution"
											placeholder="발급기관을 입력하세요" maxlength="45">
									</div>
									<!-- 취득날짜 -->
									<div class="col-md-4">
										<label class="form-label">취득날짜<span class="essentialPoint">*</span></label>
										<div class="row g-2">
											<div class="col-md-4">
												<input type="date" class="form-control acquisition-date"
													name="acquisitionDate">
											</div>
										</div>
									</div>
								</div>
							</div>
						</template>


						<!-- 자기소개란 -->
						<div class="card mb-4">
							<div class="card-header d-flex justify-content-between align-items-center">
								<span>자기소개</span>
							</div>
							<div class="card-body">
								<textarea class="form-control" id="selfIntroTextarea" rows="8"
									placeholder="자기소개를 입력하세요(최대 1000자)" maxlength="1000" <c:if
									test="${mode == 'advice'}">readonly</c:if>></textarea>
								<div class="text-end">
									<span id="charCount" class="text-muted">0 / 1000</span>
								</div>
							</div>
						</div>


						<!-- 파일 첨부 -->
						<div class="card mb-4">
							<div class="card-header d-flex justify-content-between align-items-center">
								<span>첨부파일</span>
								<c:if test="${mode != 'advice'}">
									<label for="fileInput" class="btn btn-primary btn-sm mb-0">파일
										선택</label>
									<input type="file" id="fileInput" style="display: none;" multiple>
								</c:if>
							</div>
							<div class="card-body">
								<div id="fileContainer" class="border rounded p-3">
									<c:if test="${mode != 'advice'}">
										<div class="text-center text-muted fileText">
											여기에 파일을 드래그하거나 '파일 선택' 버튼을 클릭하세요.<br> (최대 10MB)
										</div>
									</c:if>
									<c:if test="${mode == 'advice'}">
										<div class="text-center text-muted fileText">
											첨부 된 파일이 없습니다.
										</div>
									</c:if>
									<div id="previewContainer" class="mt-3"></div>
								</div>
								<small class="text-muted">* 자격증명서, 졸업증명서 등 첨부 가능합니다.</small><br>
								<small class="text-muted">* 이미지 외 파일은 10MB 까지 업로드 가능합니다.</small><br>
								<small class="text-muted">* 이미지 파일은 2.5MB 이하로 압축 후 업로드 해주세요.</small>
							</div>
						</div>

						<!-- 첨삭 의견 입력란 -->
						<c:if test="${mode == 'advice' || mode == 'checkAdvice'}">
							<div class="card mb-4">
								<div class="card-header-advice d-flex justify-content-between align-items-center">
									<span>첨삭 의견</span>
								</div>
								<div class="card-body">
									<textarea class="form-control" id="adviceTextarea" rows="15"
										placeholder="이력서에 대한 첨삭 의견을 입력하세요(최대 3000자)"
										maxlength="3000">${advice.adviceContent}</textarea>
									<div class="text-end">
										<span id="adviceCharCount" class="text-muted">${fn:length(advice.adviceContent)}
											/ 3000</span>
									</div>
								</div>
								<!-- userUid 남기기 -->
								<input type="hidden" id="userUid" value="${ sessionScope.user.userUid }">
							</div>
						</c:if>

						<!-- 첨삭 전용 파일 첨부 -->
						<c:if test="${mode == 'advice' || mode == 'checkAdvice'}">
							<div class="card mb-4">
								<div class="card-header-advice d-flex justify-content-between align-items-center">
									<span>첨삭 전용 파일 첨부</span>
									<c:if test="${mode != 'checkAdvice'}">
										<label for="fileInput-advice" class="btn btn-sm mb-0 advice-file-input">파일
											선택</label>
										<input type="file" id="fileInput-advice" style="display: none;" multiple>
									</c:if>
								</div>
								<div class="card-body">
									<div id="fileContainer-advice" class="border rounded p-3">
										<c:if test="${empty adviceFiles}">
											<div class="text-center text-muted advice-file-text">
												여기에 파일을 드래그하거나 '파일 선택' 버튼을 클릭하세요.<br> (최대 10MB)
											</div>
										</c:if>
										<div id="previewContainer-advice" class="mt-3">
											<c:forEach var="file" items="${adviceFiles}">
												<div class="d-flex align-items-center mb-2 p-2 border rounded">
													<i class="bi bi-file-earmark me-2"></i>
													<span class="flex-grow-1">${file.adviceFileName}</span>
													<a href="/resources/resumeUpfiles/${file.adviceFileName}" download
														class="btn btn-sm btn-primary ms-2">
														<i class="bi bi-download"></i>
													</a>
												</div>
											</c:forEach>
										</div>
									</div>
									<small class="text-muted">* 이미지 외 파일은 10MB 까지 업로드 가능합니다.</small><br>
									<small class="text-muted">* 이미지 파일은 2.5MB 이하로 압축 후 업로드 해주세요.</small>
								</div>
							</div>
						</c:if>


						<!-- 저장 버튼 -->
						<c:if test="${mode != 'advice' && mode == 'checkAdvice'}">
							<button type="button" class="btn btn-primary" id="finalSaveBtn"><span
									class="btn-text">저장하기</span>
								<span class="spinner-border spinner-border-sm text-light d-none" role="status"
									aria-hidden="true"></span></button>
						</c:if>
						<c:if test="${mode == 'advice'}">
							<button type="button" class="btn btn-primary" id="adviceSaveBtn"><span class="btn-text">첨삭
									저장하기</span>
								<span class="spinner-border spinner-border-sm text-light d-none" role="status"
									aria-hidden="true"></span></button>
						</c:if>
						<!-- <button type="button" class="btn btn-secondary" id="testBtn">코드
						테스트용 버튼</button> -->
						<button type="button" class="btn btn-secondary" id="returnBtn">목록으로</button>
					</form>
					<div>
						<!-- 재사용 공용 경고 모달창 -->
						<div class="modal fade" id="validationModal" tabindex="-1"
							aria-labelledby="validationModalLabel" aria-hidden="true">
							<div class="modal-dialog modal-dialog-centered">
								<div class="modal-content text-center">
									<div class="modal-body">
										<p id="validationMessage" class="mb-3">알림 메시지</p>
										<button type="button" class="btn btn-primary" id="validationCheckBtn"
											data-bs-dismiss="modal">확인</button>
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
					border-color: var(--accent-color);
					box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.25);
				}

				/* 제목 스타일 */
				h2 {
					color: var(--heading-color);
					font-family: var(--heading-font);
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
					background: var(--accent-color);
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
					background: var(--heading-color);
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
				.form-control,
				.form-select {
					border: 1px solid #e0e0e0;
					border-radius: 8px;
					padding: 0.75rem 1rem;
					transition: all 0.3s ease;
				}

				.form-control:focus,
				.form-select:focus {
					border-color: var(--accent-color);
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
					background: var(--accent-color);
					border: none;
				}

				.btn-primary:hover {
					background: color-mix(in srgb, var(--accent-color), transparent 15%);
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
					border: 2px dashed var(--accent-color);
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
				.region-list-container,
				.sigungu-list-container,
				.major-list-container,
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
					background: var(--accent-color);
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
					background: var(--heading-color);
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
					background: var(--accent-color);
					border-radius: 4px;
				}

				::-webkit-scrollbar-thumb:hover {
					background: color-mix(in srgb, var(--accent-color), transparent 15%);
				}

				/* 반응형 스타일 */
				@media (max-width: 768px) {
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
					border-color: var(--accent-color);
					box-shadow: 0 0 0 0.2rem rgba(71, 178, 228, 0.25);
				}

				.input-group-text {
					border: 1px solid #e0e0e0;
					border-right: none;
					padding: 0.8rem 1rem;
				}

				.input-group-text i {
					font-size: 1.2rem;
					color: var(--accent-color);
				}

				.pContent {
					margin-left: 40px;
					margin-top: 30px;
				}

				/* CSS 변수 정의 */
				:root {
					--accent-color: #47B2E4;
					--heading-color: #37517E;
					--heading-font: 'Poppins', sans-serif;
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
											"data-region": regionNo,
											"data-sigungu": sigungu.sigunguNo // 시/군/구 번호 추가
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
										let sigunguNo = $(this).data("sigungu");
										let sigunguName = $(this).data("name");
										let currentRegion = $(this).data("region");
										let regionName = $(".region-item.selected").text().replace("▶", "").trim();

										// 현재 선택된 시/도의 체크박스만 처리
										if (currentRegion === regionNo) {
											if ($(this).prop("checked")) {
												// 체크박스가 체크되면 선택된 지역 목록에 추가
												let $badge = $("<span>")
													.addClass("badge bg-primary me-2")
													.text(regionName + " " + sigunguName)
													.attr("data-region", regionNo)
													.attr("data-sigungu", sigunguNo); // 시/군/구 번호 저장

												// 삭제 버튼 생성 및 삭제 기능
												let $removeBtn = $("<button>")
													.addClass("btn-close ms-2")
													.attr("type", "button")  // type="button" 추가
													.on("click", function (e) {
														e.preventDefault();
														e.stopPropagation();

														const $badge = $(this).parent();
														const sigunguNo = $badge.data("sigungu");
														const regionName = $badge.text().trim().split(' ')[1];

														$badge.remove();
														$(`input[data-sigungu="${sigunguNo}"]`).prop("checked", false);

														// 해당 텍스트와 일치하는 체크박스 찾아서 해제
														$('.sigungu-item input[type="checkbox"]').each(function () {
															if ($(this).data('name') === regionName) {
																$(this).prop('checked', false);
															}
														});
													});

												$badge.append($removeBtn);
												selectedRegions.append($badge);
											} else {
												// 체크박스가 해제되면 선택된 지역 목록에서 제거
												selectedRegions.find(".badge").each(function () {
													if ($(this).data("sigungu") === sigunguNo) {
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
										if ($(this).data("sigungu") === sigungu.sigunguNo) {
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
											"data-major": majorNo,
											"data-sub": sub.subcategoryNo // 소분류 번호 추가
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
										let subNo = $(this).data("sub");
										let subName = $(this).data("name");
										let currentMajor = $(this).data("major");

										// 현재 선택된 대분류의 체크박스만 처리
										if (currentMajor === majorNo) {
											if ($(this).prop("checked")) {
												// 체크박스가 체크되면 선택된 업직종 목록에 추가
												let $badge = $("<span>")
													.addClass("badge bg-primary me-2")
													.text(subName)
													.attr("data-major", majorNo)
													.attr("data-sub", subNo);

												// 삭제 버튼 생성 및 삭제 기능
												let $removeBtn = $("<button>")
													.addClass("btn-close ms-2")
													.attr("type", "button")
													.on("click", function (e) {
														e.preventDefault();
														e.stopPropagation();

														const $badge = $(this).parent();
														const jobName = $badge.text().trim();

														$badge.remove();

														// 해당 텍스트와 일치하는 체크박스 찾아서 해제
														$('.sub-item input[type="checkbox"]').each(function () {
															if ($(this).data('name') === jobName) {
																$(this).prop('checked', false);
															}
														});
													});

												$badge.append($removeBtn);
												selectedJobTypes.append($badge);
											} else {
												// 체크박스가 해제되면 선택된 업직종 목록에서 제거
												selectedJobTypes.find(".badge").each(function () {
													if ($(this).data("sub") === subNo) {
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
										if ($(this).data("sub") === sub.subcategoryNo) {
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

						if (!$('#profileBase64').val()) {
							showValidationModal("사진을 등록해 주세요.");
							$(".photoUploadBox").attr("tabindex", -1).focus();
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
						const educationItems = $('.education-item'); // each -> 
						if (educationItems.length > 0) {
							let isValid = true;

							educationItems.each(function () {
								const educationLevel = $(this).find('.education-level').val();
								const educationStatus = $(this).find('.education-status').val();
								const graduationDate = $(this).find('.graduation-date').val();
								const customInput = $(this).find('.custom-input').val().trim();

								if (!educationLevel || !educationStatus || !graduationDate || !customInput) {
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

						// 자격증 유효성 검사
						const licenseItems = $('.license-item');
						if (licenseItems.length > 0) {
							let isValid = true;

							licenseItems.each(function () {
								const licenseName = $(this).find('.license-name').val().trim();
								const acquisitionDate = $(this).find('.acquisition-date').val();
								const institution = $(this).find('.institution').val();

								if (!licenseName || !acquisitionDate || !institution) {
									isValid = false;
									return false; // each 중단
								}

								if (!isValid) {
									showValidationModal("자격증 정보가 누락되었습니다.");
									$("#myLicenseBox").attr("tabindex", -1).focus();
									return;
								}
							});
						}

						console.log("유효성 검사 통과");

						// 폼 데이터 수집
						const formData = {
							title: $('#title').val(),
							payType: $('input[name="payType"]:checked').val(),
							pay: $('#payAmount').val().replace(/,/g, ''),
							jobForms: $('input[name="jobForm"]:checked').map(function () {
								return {
									form: $(this).val()
								};
							}).get(),
							sigunguNos: $('#selectedRegions').find('.badge').map(function () {
								return $(this).data("sigungu");
							}).get(),
							subcategoryNos: $('#selectedJobTypes').find('.badge').map(function () {
								return $(this).data("sub");
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
									graduationDate: $(this).find('.graduation-date').val(),
									customInput: $(this).find('.custom-input').val()
								};
							}).get(),
							histories: $('.history-item').map(function () {
								const $endDate = $(this).find('.end-date');
								const isCurrentlyEmployed = $(this).find('.currently-employed').is(':checked');
								return {
									companyName: $(this).find('.company-name').val(),
									position: $(this).find('.position').val(),
									jobDescription: $(this).find('.job-description').val(),
									startDate: $(this).find('.start-date').val(),
									endDate: isCurrentlyEmployed ? null : $endDate.val()
								};
							}).get(),
							licenses: $('.license-item').map(function () {
								return {
									licenseName: $(this).find('.license-name').val(),
									acquisitionDate: $(this).find('.acquisition-date').val(),
									institution: $(this).find('.institution').val()
								};
							}).get(),
							introduce: $('#selfIntroTextarea').val(),
							files: uploadedFiles,
							userUid: $('#userUid').val(),
							profileBase64: $('#profileBase64').val()
						};

						// 이력서 번호가 있는 경우 추가
						const resumeNo = '${resumeDetail.resume.resumeNo}';
						if (resumeNo) {
							formData.resumeNo = resumeNo;
						}
						// URL에서 uid 파라미터 가져오기
						const urlParams = new URLSearchParams(window.location.search);
						const uid = urlParams.get('uid');
						console.log('uid:', uid);

						console.log('저장할 데이터:', formData);

					});
					//---------------------------------------------------------------------------------------------------------------------------------
					//---------------------------------------------------------------------------------------------------------------------------------
					let isSubmitting = false; // 중복 제출 방지용
					// 최종 저장 버튼 클릭 이벤트
					$('#finalSaveBtn').on('click', function () {
						if (isSubmitting) return; // 이미 제출 중이면 무시

						isSubmitting = true; // 제출 시작
						$('#finalSaveBtn').prop('disabled', true); // 버튼 비활성화

						// 버튼 안에 스피너 보여주기
						$('#finalSaveBtn .btn-text').addClass('d-none');
						$('#finalSaveBtn .spinner-border').removeClass('d-none');

						// 유효성 검사
						const title = $('#title').val().trim();
						const titleLength = $('#title').val().length;
						if (!title) {
							showValidationModal("이력서 제목을 입력해주세요.", "#title");
							resetSubmitButton();
							return;
						}

						if (titleLength > 30) {
							showValidationModal("이력서 제목은 30자 이내로 작성해주세요.", "#title");
							resetSubmitButton();
							return;
						}

						if (!$('#profileBase64').val()) {
							showValidationModal("사진을 등록해 주세요.");
							$(".photoUploadBox").attr("tabindex", -1).focus();
							resetSubmitButton();
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
						const educationItems = $('.education-item'); // each -> 
						if (educationItems.length > 0) {
							let isValid = true;

							educationItems.each(function () {
								const educationLevel = $(this).find('.education-level').val();
								const educationStatus = $(this).find('.education-status').val();
								const graduationDate = $(this).find('.graduation-date').val();
								const customInput = $(this).find('.custom-input').val().trim();

								if (!educationLevel || !educationStatus || !graduationDate || !customInput) {
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
									return false;
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

						// 자격증 유효성 검사
						const licenseItems = $('.license-item');
						if (licenseItems.length > 0) {
							let isValid = true;

							licenseItems.each(function () {
								const licenseName = $(this).find('.license-name').val().trim();
								const acquisitionDate = $(this).find('.acquisition-date').val();
								const institution = $(this).find('.institution').val().trim();

								if (!licenseName || !acquisitionDate || !institution) {
									isValid = false;
									return false; // each 중단
								}
							});

							if (!isValid) {
								showValidationModal("자격증 정보가 누락되었습니다.");
								$("#myLicenseBox").attr("tabindex", -1).focus();
								return;
							}
						}

						console.log("유효성 검사 통과");

						// 삭제된 파일이 있으면 서버에 삭제 요청
						if (deletedFiles.length > 0) {
							// 각 파일에 대해 개별적으로 삭제 요청
							let deletePromises = deletedFiles.map(function (fileName) {
								// 비동기 작업을 처리하기 위한 Promise 객체 생성
								return new Promise(function (resolve, reject) {
									$.ajax({
										url: "/resume/deleteFile",
										type: "POST",
										data: JSON.stringify({
											originalFileName: fileName,
											newFileName: fileName,
											ext: fileName.split('.').pop(),
											size: 0
										}),
										contentType: "application/json",
										success: function (result) {
											if (result.success) {
												resolve();
											} else {
												reject(result.message || "파일 삭제에 실패했습니다.");
											}
										},
										error: function () {
											reject("파일 삭제 중 오류가 발생했습니다.");
										}
									});
								});
							});

							// 모든 삭제 요청이 완료된 후 폼 데이터 수집 및 저장 진행
							Promise.all(deletePromises)
								.then(function () {
									console.log("모든 파일 삭제 성공");
									submitFormData();
								})
								.catch(function (error) {
									showValidationModal(error);
								});
						} else {
							// 삭제된 파일이 없으면 바로 폼 데이터 수집 및 저장 진행
							submitFormData();
						}
					});

					// 폼 데이터 수집 및 저장 함수
					function submitFormData() {
						// 대기 중인 파일들을 서버에 업로드
						if (pendingFiles.length > 0) {
							// 각 파일에 대해 업로드 Promise 생성
							const uploadPromises = pendingFiles.map(fileInfo => uploadFile(fileInfo));

							// 모든 파일 업로드가 완료된 후 폼 데이터 수집 및 저장 진행
							Promise.all(uploadPromises)
								.then(() => {
									console.log("모든 파일 업로드 성공");
									// 대기 중인 파일 목록 초기화
									pendingFiles = [];
									// 폼 데이터 수집 및 저장 진행
									saveFormData();
								})
								.catch(error => {
									showValidationModal(error);
								});
						} else {
							// 대기 중인 파일이 없으면 바로 폼 데이터 수집 및 저장 진행
							saveFormData();
						}
					}

					// 폼 데이터 수집 및 저장 함수
					function saveFormData() {
						// 폼 데이터 수집 .map() -> .get()으로 배열 변환해서 값 가져오기
						const formData = {
							title: $('#title').val(),
							payType: $('input[name="payType"]:checked').val(),
							pay: $('#payAmount').val().replace(/,/g, ''),
							jobForms: $('input[name="jobForm"]:checked').map(function () {
								return {
									form: $(this).val()
								};
							}).get(),
							sigunguNos: $('#selectedRegions').find('.badge').map(function () {
								return $(this).data("sigungu");
							}).get(),
							subcategoryNos: $('#selectedJobTypes').find('.badge').map(function () {
								return $(this).data("sub");
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
									graduationDate: $(this).find('.graduation-date').val(),
									customInput: $(this).find('.custom-input').val()
								};
							}).get(),
							histories: $('.history-item').map(function () {
								const $endDate = $(this).find('.end-date');
								const isCurrentlyEmployed = $(this).find('.currently-employed').is(':checked');
								return {
									companyName: $(this).find('.company-name').val(),
									position: $(this).find('.position').val(),
									jobDescription: $(this).find('.job-description').val(),
									startDate: $(this).find('.start-date').val(),
									endDate: isCurrentlyEmployed ? null : $endDate.val()
								};
							}).get(),
							licenses: $('.license-item').map(function () {
								return {
									licenseName: $(this).find('.license-name').val(),
									acquisitionDate: $(this).find('.acquisition-date').val(),
									institution: $(this).find('.institution').val()
								};
							}).get(),
							introduce: $('#selfIntroTextarea').val(),
							files: uploadedFiles,
							userUid: $('#userUid').val(),
							profileBase64: $('#profileBase64').val()
						};

						// 이력서 번호가 있는 경우 추가(수정기능)
						const resumeNo = '${resumeDetail.resume.resumeNo}';
						if (resumeNo) {
							formData.resumeNo = resumeNo;
						}

						console.log('저장할 데이터:', formData);

						// URL에서 uid(공고uid) 파라미터 가져오기
						const urlParams = new URLSearchParams(window.location.search);
						const uid = urlParams.get('uid');
						console.log('uid:', uid);

						// 저장 또는 수정 요청
						const url = resumeNo ? `/resume/update/${resumeNo}` : '/resume/submit-final';
						$.ajax({
							url: url,
							type: 'POST',
							data: JSON.stringify(formData),
							contentType: 'application/json',
							success: function (response) {
								if (response.success) {
									if (uid) {
										// uid가 있으면 이력서 제출 페이지로 이동
										window.location.href = `/submission/check?uid=` + uid;
									} else {
										window.location.href = response.redirectUrl;
									}
								} else {
									showValidationModal(response.message || "저장 중 오류가 발생했습니다.");
								}
							},
							error: function (xhr, status, error) {
								console.error('Error details:', {
									status: status,
									error: error,
									response: xhr.responseText
								});
								isSubmitting = false; // 중복 방지 플래그 해제
								$('#finalSaveBtn').prop('disabled', false); // 버튼 복원
								$('#finalSaveBtn .btn-text').removeClass('d-none');
								$('#finalSaveBtn .spinner-border').addClass('d-none');
								showValidationModal("저장 중 오류가 발생했습니다.");
							}
						});
					}
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
								showValidationModal("성격 및 강점은 최대 5개까지 선택 가능합니다.");
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
								.on('click', function (e) {
									e.preventDefault();
									e.stopPropagation();

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

					// 페이지 로드 시 기존 선택된 성격 및 강점에 대한 버튼 스타일 설정
					$('#selectedMerits .badge').each(function () {
						const merit = $(this).data('merit');
						$(`.merit-btn[data-merit="${merit}"]`).removeClass('btn-outline-primary').addClass('btn-primary');
					});

					// 기존 성격 및 강점 배지의 삭제 버튼 이벤트
					$('#selectedMerits').on('click', '.btn-close', function (e) {
						e.preventDefault();
						e.stopPropagation();

						const $badge = $(this).parent();
						const merit = $badge.data('merit');

						$badge.remove();
						// 삭제 시 버튼 스타일 초기화
						$(`.merit-btn[data-merit="${merit}"]`).removeClass('btn-primary').addClass('btn-outline-primary');
					});
					//---------------------------------------------------------------------------------------------------------------------------------
					// 성격 및 강점 선택 모달이 열리기 전에 버튼 스타일 설정
					$('#meritModal').on('show.bs.modal', function () {
						// 모든 버튼 초기화
						$('.merit-btn').removeClass('btn-primary').addClass('btn-outline-primary');

						// 현재 선택된 배지들의 텍스트 수집
						const selectedMerits = [];
						$('#selectedMerits .badge').each(function () {
							selectedMerits.push($(this).text().trim().replace('삭제', '').trim());
						});

						// 각 버튼을 순회하면서 선택된 배지의 텍스트와 비교
						$('.merit-btn').each(function () {
							const buttonText = $(this).text().trim();
							if (selectedMerits.includes(buttonText)) {
								$(this).removeClass('btn-outline-primary').addClass('btn-primary');
							}
						});
					});

					// 성격 및 강점 선택 모달이 열린 후 포커스 관리
					$('#meritModal').on('shown.bs.modal', function () {
						// 모달이 열릴 때 첫 번째 버튼에 포커스
						$(this).find('.merit-btn').first().focus();
					});

					// 모달이 닫힐 때 버튼 스타일 초기화
					$('#meritModal').on('hidden.bs.modal', function () {
						// 모든 버튼 초기화
						$('.merit-btn').removeClass('btn-primary').addClass('btn-outline-primary');

						// 선택된 항목들의 버튼 스타일 변경
						$('#selectedMerits .badge').each(function () {
							const merit = $(this).data('merit');
							$(`.merit-btn[data-merit="${merit}"]`).removeClass('btn-outline-primary').addClass('btn-primary');
						});
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
					// 페이지 로드 시 기존 학력사항 표시
					function initializeEducation() {
						const educationTemplate = document.querySelector('#educationTemplate');

						<c:forEach var="education" items="${resumeDetail.educations}" varStatus="status">
							const educationClone${status.index} = educationTemplate.content.cloneNode(true);

							// 기존 값 설정
							$(educationClone${status.index}).find('.education-level').val('${education.educationLevel}');
							$(educationClone${status.index}).find('.education-status').val('${education.educationStatus}');

							// 날짜 형식 변환 (yyyy-MM-dd)
							<c:if test="${not empty education.graduationDate}">
								const graduationDate${status.index} = new Date('${education.graduationDate}');
								const formattedDate${status.index} = graduationDate${status.index}.getFullYear() + '-' +
								String(graduationDate${status.index}.getMonth() + 1).padStart(2, '0') + '-' +
								String(graduationDate${status.index}.getDate()).padStart(2, '0');
								$(educationClone${status.index}).find('.graduation-date').val(formattedDate${status.index});
							</c:if>

							$(educationClone${status.index}).find('.custom-input').val('${education.customInput}');

							$('#educationContainer').append(educationClone${status.index});
						</c:forEach>
					}

					// 페이지 로드 시 학력사항 초기화
					initializeEducation();
					//---------------------------------------------------------------------------------------------------------------------------------
					// 경력 추가 버튼 클릭 이벤트
					let count = 0; // id 중복 방지 만들기 위한 count
					$('#addHistoryBtn').on('click', function () {
						const template = document.querySelector('#historyTemplate');
						const clone = template.content.cloneNode(true) // 깊은 복제 -> 자식 요소까지 복사

						count++;

						const newItemId = 'jobDescription' + count;
						const newCountId = 'jobDescriptionCount' + count;

						$(clone).find('.job-description').attr('id', newItemId);
						$(clone).find('#jobDescriptionCount').attr('id', newCountId);

						$(clone).find('.job-description').on('input', function () {
							const currentLength = $(this).val().length;
							const maxLength = 100;
							const remainingLength = maxLength - currentLength;
							$(this).closest('.history-item').find('#' + newCountId).text(currentLength + ' / ' + '100');
						});

						$('#historyContainer').append($(clone));
					});

					// 경력 삭제 버튼 클릭 이벤트
					$(document).on('click', '.remove-history', function () {
						$(this).closest('.history-item').remove();
					});

					// 재직중 체크박스 이벤트
					$(document).on('change', '.currently-employed', function () {
						const $endDate = $(this).closest('.history-item').find('.end-date');
						if ($(this).is(':checked')) {
							$endDate.val('').prop('disabled', true);
						} else {
							$endDate.prop('disabled', false);
						}
					});
					//---------------------------------------------------------------------------------------------------------------------------------
					// 페이지 로드 시 기존 경력사항 표시
					function initializeHistory() {
						const historyTemplate = document.querySelector('#historyTemplate');

						<c:forEach var="history" items="${resumeDetail.histories}" varStatus="status">
							const historyClone${status.index} = historyTemplate.content.cloneNode(true);

							// 기존 값 설정
							$(historyClone${status.index}).find('.company-name').val('${history.companyName}');
							$(historyClone${status.index}).find('.position').val('${history.position}');
							$(historyClone${status.index}).find('.job-description').val('${history.jobDescription}');

							// 시작일 설정
							<c:if test="${not empty history.startDate}">
								const startDate${status.index} = new Date('${history.startDate}');
								const formattedStartDate${status.index} = startDate${status.index}.getFullYear() + '-' +
								String(startDate${status.index}.getMonth() + 1).padStart(2, '0') + '-' +
								String(startDate${status.index}.getDate()).padStart(2, '0');
								$(historyClone${status.index}).find('.start-date').val(formattedStartDate${status.index});
							</c:if>

						// 종료일 설정 (재직중이 아닌 경우에만)
							<c:if test="${not empty history.endDate}">
								const endDate${status.index} = new Date('${history.endDate}');
								const formattedEndDate${status.index} = endDate${status.index}.getFullYear() + '-' +
								String(endDate${status.index}.getMonth() + 1).padStart(2, '0') + '-' +
								String(endDate${status.index}.getDate()).padStart(2, '0');
								$(historyClone${status.index}).find('.end-date').val(formattedEndDate${status.index});
							</c:if>

						// 재직중 체크박스 상태 설정
							<c:if test="${empty history.endDate}">
								$(historyClone${status.index}).find('.currently-employed').prop('checked', true);
								$(historyClone${status.index}).find('.end-date').prop('disabled', true);
							</c:if>

						// 담당업무 글자수 카운트 설정
							const jobDescriptionLength${status.index} = '${history.jobDescription}'.length;
							$(historyClone${status.index}).find('#jobDescriptionCount').text(jobDescriptionLength${status.index} + ' / 100');

							$('#historyContainer').append(historyClone${status.index});
						</c:forEach>
					}

					// 페이지 로드 시 경력사항 초기화
					initializeHistory();
					//---------------------------------------------------------------------------------------------------------------------------------
					// 자격증 추가 버튼 클릭 이벤트
					$('#addLicenseBtn').on('click', function () {
						const licenseBoxCount = $('.license-item').length;
						if (licenseBoxCount >= 10) {
							showValidationModal("자격증은 최대 10개까지 저장 가능합니다.");
							return;
						}
						const template = document.querySelector('#licenseTemplate');
						const clone = template.content.cloneNode(true);
						$('#licenseContainer').append(clone);
					});

					// 자격증 삭제 버튼 클릭 이벤트
					$(document).on('click', '.remove-license', function () {
						$(this).closest('.license-item').remove();
					});
					//---------------------------------------------------------------------------------------------------------------------------------
					// 페이지 로드 시 기존 자격증 표시
					function initializeLicense() {
						const licenseTemplate = document.querySelector('#licenseTemplate');

						<c:forEach var="license" items="${resumeDetail.licenses}" varStatus="status">
							const licenseClone${status.index} = licenseTemplate.content.cloneNode(true);

							// 기존 값 설정
							$(licenseClone${status.index}).find('.license-name').val('${license.licenseName}');
							$(licenseClone${status.index}).find('.institution').val('${license.institution}');

							// 취득일자 설정
							<c:if test="${not empty license.acquisitionDate}">
								const acquisitionDate${status.index} = new Date('${license.acquisitionDate}');
								const formattedAcquisitionDate${status.index} = acquisitionDate${status.index}.getFullYear() + '-' +
								String(acquisitionDate${status.index}.getMonth() + 1).padStart(2, '0') + '-' +
								String(acquisitionDate${status.index}.getDate()).padStart(2, '0');
								$(licenseClone${status.index}).find('.acquisition-date').val(formattedAcquisitionDate${status.index});
							</c:if>

							$('#licenseContainer').append(licenseClone${status.index});
						</c:forEach>
					}

					// 페이지 로드 시 자격증 초기화
					initializeLicense();
					//---------------------------------------------------------------------------------------------------------------------------------
					// 페이지 로드 시 기존 자기소개 표시
					function initializeSelfIntro() {
						<c:if test="${not empty resumeDetail.resume.introduce}">
							$('#selfIntroTextarea').val('${resumeDetail.resume.introduce}');
							$('#charCount').text('${resumeDetail.resume.introduce}'.length + ' / 1000');
						</c:if>
					}

					// 페이지 로드 시 자기소개 초기화
					initializeSelfIntro();
					//---------------------------------------------------------------------------------------------------------------------------------
					// 자기소개 입력란 몇글자 썻는지 알 수 있게 하기
					$('#selfIntroTextarea').on('input', function () {
						const currentLength = $(this).val().length;
						const maxLength = 1000;
						const remainingLength = maxLength - currentLength;
						$('#charCount').text(currentLength + ' / ' + '1000');
					});
					//---------------------------------------------------------------------------------------------------------------------------------
					// 금액 입력에 숫자외 다른 문자를 입력하면 입력 못하게 하고 모달띄우기 ','는 가능
					$('#payAmount').on('input', function () {
						let value = $(this).val();

						// 콤마 제거하고 숫자만 남긴 값 추출
						let payOnlyNumber = value.replace(/,/g, '');

						// 숫자만 입력되었는지 확인
						if (!/^\d*$/.test(payOnlyNumber) && value !== '') {
							showValidationModal("숫자만 입력 가능해요");
							$(this).val('');
							return;
						}

						// 숫자가 맞다면 3자리 콤마 형식으로 변경
						let result = Number(payOnlyNumber).toLocaleString();
						$(this).val(result);
					});
					//---------------------------------------------------------------------------------------------------------------------------------
					// 파일 업로드
					let uploadedFiles = [];
					const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
					const MAX_FILES = 10;
					// 삭제된 파일 목록 초기화
					let deletedFiles = [];
					// 임시 저장된 파일 목록 (서버에 아직 업로드되지 않은 파일)
					let pendingFiles = [];

					// 페이지 로드 시 기존 첨부파일 표시
					function initializeFiles() {
						<c:if test="${not empty resumeDetail.files}">
							<c:forEach var="file" items="${resumeDetail.files}">
								uploadedFiles.push({
									originalFileName: '${file.originalFileName}',
								newFileName: '${file.newFileName}',
								ext: '${file.ext}',
								size: ${file.size},
								base64Image: '${file.base64Image}'
							});
								showFilePreview({
									originalFileName: '${file.originalFileName}',
								newFileName: '${file.newFileName}',
								ext: '${file.ext}',
								size: ${file.size},
								base64Image: '${file.base64Image}'
							});
							</c:forEach>
							updateFileText();
						</c:if>
					}

					// 페이지 로드 시 첨부파일 초기화
					initializeFiles();

					// 파일 입력 이벤트
					$('#fileInput').on('change', function (e) {
						handleFiles(e.target.files);
					});

					// 드래그 앤 드롭 이벤트
					$('#fileContainer').on('dragenter dragover', function (e) {
						e.preventDefault(); // 브라우저가 기본적으로 파일을 열거나 다운로드하려는 동작을 막음
						e.stopPropagation(); // 이벤트가 부모 요소로 전달되지 않도록 함
						$(this).addClass('border-primary');
					});

					$('#fileContainer').on('dragleave', function (e) {
						e.preventDefault();
						e.stopPropagation();
						$(this).removeClass('border-primary');
					});

					$('#fileContainer').on('drop', function (e) {
						e.preventDefault();
						e.stopPropagation();
						$(this).removeClass('border-primary');
						if (${ mode != 'advice' }) {
						const files = e.originalEvent.dataTransfer.files;
						handleFiles(files);
					}
				});
				// 파일 처리 함수
				function handleFiles(files) {
					if (uploadedFiles.length + pendingFiles.length + files.length > MAX_FILES) {
						showValidationModal("최대 10개의 파일만 업로드할 수 있습니다.");
						return;
					}

					Array.from(files).forEach(file => {
						// 👉 이미지 파일이면 2.5MB 제한
						if (file.type.startsWith("image/") && file.size > 2.5 * 1024 * 1024) {
							showValidationModal('이미지의 크기가 2.5MB를 초과합니다.');
							return;
						}

						// 파일 크기 체크
						if (file.size > MAX_FILE_SIZE) {
							showValidationModal(`파일의 크기가 10MB를 초과합니다.`);
							return;
						}

						// 중복 체크 (업로드된 파일과 대기 중인 파일 모두 확인 some() -> 배열에 조건에 맞는 요소가 있는지 확인)
						if (uploadedFiles.some(f => f.originalFileName === file.name) ||
							pendingFiles.some(f => f.originalFileName === file.name)) {
							showValidationModal(`이미 업로드된 파일입니다.`);
							return;
						}


						// 파일 정보 생성
						const fileInfo = {
							file: file,
							originalFileName: file.name,
							ext: file.name.split('.').pop(),
							size: file.size
						};

						// 대기 중인 파일 목록에 추가
						pendingFiles.push(fileInfo);
						// 미리보기 표시
						showFilePreview(fileInfo);
						updateFileText();
					});
				}

				// 파일 업로드 함수 (Promise 기반)
				function uploadFile(fileInfo) {
					return new Promise((resolve, reject) => {
						const formData = new FormData();
						formData.append("file", fileInfo.file);

						$.ajax({
							url: "/resume/uploadFile",
							type: "POST",
							data: formData,
							processData: false,
							contentType: false,
							success: function (result) {
								if (result.success) {
									// 업로드된 파일 정보 저장
									const uploadedFile = {
										originalFileName: result.originalFileName,
										newFileName: result.newFileName,
										ext: result.ext,
										size: result.size,
										base64Image: result.base64Image
									};
									uploadedFiles.push(uploadedFile);
									resolve(uploadedFile);
								} else {
									reject(result.message || "파일 업로드에 실패했습니다.");
								}
							},
							error: function () {
								reject("파일 업로드 중 오류가 발생했습니다.");
							}
						});
					});
				}

				// 파일 미리보기 표시
				function showFilePreview(fileInfo) {
					const $previewContainer = $('#previewContainer');

					const $preview = $('<div>')
						.addClass('file-preview d-flex justify-content-between align-items-center p-2 mb-2 bg-light rounded')
						.attr('data-filename', fileInfo.originalFileName);

					// 파일 정보 표시
					const $fileInfo = $('<div>').addClass('d-flex align-items-center');

					// 파일 아이콘 (확장자에 따라 다르게 표시 가능)
					const $icon = $('<i>').addClass('bi bi-file-earmark me-2');

					// 파일명과 크기
					const $details = $('<div>');
					$details.append($('<div>').text(fileInfo.originalFileName).css('word-break', 'break-all'));
					$details.append($('<small>').addClass('text-muted').text(formatFileSize(fileInfo.size)));

					$fileInfo.append($icon).append($details);

					let $deleteBtn = null;
					let $downloadBtn = null;
					if (${ mode != 'advice' }) {
						$deleteBtn = $('<button>')
							.addClass('btn btn-sm btn-danger ms-2')
							.attr('type', 'button')
							.html('<i class="bi bi-trash"></i>')
							.on('click', function (e) {
								e.preventDefault();
								e.stopPropagation();
								deleteFile(fileInfo.originalFileName, $preview);
							});
					}

					// a태그로 정적으로 서버 하드에 저장된 파일 다운로드 버튼
					if (${ mode == 'advice' }) {
						$downloadBtn = $('<a>')
							.addClass('btn btn-sm btn-primary ms-2')
							.attr({
								'href': '/resources/resumeUpfiles/' + fileInfo.newFileName,
								'download': fileInfo.originalFileName
							})
							.html('<i class="bi bi-download"></i>');
					}
					$preview.append($fileInfo).append($deleteBtn).append($downloadBtn);
					$previewContainer.append($preview);
				}

				// 파일 삭제 함수
				function deleteFile(fileName, $preview) {
					const uploadedFile = uploadedFiles.find(function (f) {
						return f.originalFileName === fileName;
					});
					const pendingFile = pendingFiles.find(function (f) {
						return f.originalFileName === fileName;
					});

					if (uploadedFile) {
						// 업로드된 파일인 경우
						uploadedFiles = uploadedFiles.filter(function (f) {
							return f.originalFileName !== fileName;
						});
						$preview.remove();
						updateFileText();

						// 삭제된 파일 목록에 추가
						if (!deletedFiles.includes(uploadedFile.newFileName)) {
							deletedFiles.push(uploadedFile.newFileName);
						}
					} else if (pendingFile) {
						// 대기 중인 파일인 경우
						pendingFiles = pendingFiles.filter(f => f.originalFileName !== fileName);
						$preview.remove();
						updateFileText();
					}
				}

				// 파일 크기 포맷팅
				function formatFileSize(bytes) {
					if (bytes === 0) return '0 Bytes';
					const k = 1024;
					const sizes = ['Bytes', 'KB', 'MB'];
					const i = Math.floor(Math.log(bytes) / Math.log(k));
					return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
				}

				// 파일 텍스트 업데이트
				function updateFileText() {
					const $fileText = $('.fileText');
					if (uploadedFiles.length + pendingFiles.length > 0) {
						$fileText.hide();
					} else {
						$fileText.show();
					}
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 제목 입력 글자수 카운트
				$('#title').on('input', function () {
					const currentLength = $(this).val().length;
					$('#titleLength').text(currentLength);
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// -todoList-
				// 로컬스토리지에 임시저장 기능 추가
				//---------------------------------------------------------------------------------------------------------------------------------
				// 페이지 로드 시 지역 선택 실행
				initializeSelectedRegions();

				// 페이지 로드 시 선택된 지역에 대한 체크박스 처리
				function initializeSelectedRegions() {
					const $badges = $('#selectedRegions .badge');

					// 이미 선택된 지역이 없으면 중단
					if ($badges.length === 0) return;

					// 선택된 지역들의 데이터 수집
					const selectedRegions = new Map();
					$badges.each(function () {
						const regionNo = $(this).data('region');
						const sigunguNo = $(this).data('sigungu');
						if (!selectedRegions.has(regionNo)) {
							selectedRegions.set(regionNo, []);
						}
						selectedRegions.get(regionNo).push(sigunguNo);
					});

					// 각 시/도에 대해 한 번만 클릭 이벤트 발생
					selectedRegions.forEach(function (sigunguNos, regionNo) {
						const $regionItem = $(`.region-item[data-region="${regionNo}"]`);
						$regionItem.trigger('click');

						// Ajax 완료 후 해당 시군구들 체크
						$.ajax({
							url: "/resume/getSigungu",
							type: "GET",
							data: { regionNo: regionNo },
							success: function () {
								for (let i = 0; i < sigunguNos.length; i++) {
									$(`#sigungu_${sigunguNos[i]}`).prop('checked', true);
								}
							}
						});
					});

					// 삭제 버튼 이벤트 처리
					$('#selectedRegions').on('click', '.btn-close', function (e) {
						e.preventDefault();
						e.stopPropagation();

						const $badge = $(this).parent();
						const sigunguNo = $badge.data('sigungu');
						const regionName = $badge.text().trim().split(' ')[1]; // 띄어쓰기로 분리 (시/군/구 이름)

						$badge.remove();
						$(`#sigungu_${sigunguNo}`).prop('checked', false);

						// 해당 텍스트와 일치하는 체크박스 찾아서 해제
						$('.sigungu-item input[type="checkbox"]').each(function () {
							if ($(this).data('name') === regionName) {
								$(this).prop('checked', false);
							}
						});
					});
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 페이지 로드 시 업직종 선택 실행
				initializeSelectedJobTypes();

				// 페이지 로드 시 선택된 업직종에 대한 체크박스 처리
				function initializeSelectedJobTypes() {
					const $badges = $('#selectedJobTypes .badge');

					// 이미 선택된 업직종이 중단
					if ($badges.length === 0) return;

					// 선택된 업직종들의 데이터 수집
					const selectedJobTypes = new Map();
					$badges.each(function () {
						const majorNo = $(this).data('major');
						const subNo = $(this).data('sub');
						if (!selectedJobTypes.has(majorNo)) {
							selectedJobTypes.set(majorNo, []);
						}
						selectedJobTypes.get(majorNo).push(subNo);
					});

					// 각 대분류에 대해 한 번만 클릭 이벤트 발생
					selectedJobTypes.forEach(function (subNos, majorNo) {
						const $majorItem = $(`.major-item[data-major="${majorNo}"]`);
						$majorItem.trigger('click');

						// Ajax 완료 후 해당 소분류들 체크
						$.ajax({
							url: "/resume/getSubCategory",
							type: "GET",
							data: { majorNo: majorNo },

							success: function () {
								for (let i = 0; i < subNos.length; i++) {
									$(`#sub_${subNos[i]}`).prop('checked', true);
								}
							}
						});
					});

					// 삭제 버튼 이벤트 처리
					$('#selectedJobTypes').on('click', '.btn-close', function (e) {
						e.preventDefault();
						e.stopPropagation();

						const $badge = $(this).parent();
						const subNo = $badge.data('sub');
						const jobName = $badge.text().trim(); // 배지의 텍스트 가져오기

						$badge.remove();

						// 해당 텍스트와 일치하는 체크박스 찾아서 해제
						$('.sub-item input[type="checkbox"]').each(function () {
							if ($(this).data('name') === jobName) {
								$(this).prop('checked', false);
							}
						});
					});
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 사진 업로드 이벤트
				$('#photoUpload').on('change', function (event) {
					const file = event.target.files[0];
					if (file) {
						if (!file.type.startsWith('image/')) {
							showValidationModal('이미지 파일만 등록 가능합니다.');
							return;
						}
						if (file.size > 2.5 * 1024 * 1024) {
							showValidationModal('이미지의 크기가 2.5MB를 초과합니다.');
							return;
						}
						const reader = new FileReader();
						reader.onload = function (e) {
							$('#photoPreview').attr('src', e.target.result).show();
							$('#profileBase64').val(e.target.result);
							// 사진 등록 텍스트와 아이콘 숨기기
							$('label[for="photoUpload"]').hide();
							// X 버튼 보이기
							$('#removePhoto').show();
						}
						reader.readAsDataURL(file);
					}
				});

				// X 버튼 클릭 이벤트
				$('#removePhoto').on('click', function () {
					// 미리보기 이미지 숨기기
					$('#photoPreview').hide();
					// base64 값 초기화
					$('#profileBase64').val('');
					// 사진 등록 텍스트와 아이콘 다시 보이기
					$('label[for="photoUpload"]').show();
					// X 버튼 숨기기
					$(this).hide();
					// 파일 입력 초기화
					$('#photoUpload').val('');
				});
				//---------------------------------------------------------------------------------------------------------------------------------
				// 유효성 검사 실패 시 스피너 중지 및 버튼 복원 함수
				function resetSubmitButton() {
					isSubmitting = false; // 중복 방지 플래그 해제
					$('#finalSaveBtn').prop('disabled', false); // 버튼 복원
					$('#finalSaveBtn .btn-text').removeClass('d-none');
					$('#finalSaveBtn .spinner-border').addClass('d-none');
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 페이지 로드 시 프로필 이미지 초기화
				<c:if test="${not empty resumeDetail.resume.profileBase64}">
					$('#photoPreview').attr('src', '${resumeDetail.resume.profileBase64}').show();
					$('#profileBase64').val('${resumeDetail.resume.profileBase64}');
					$('label[for="photoUpload"]').hide();
					$('#removePhoto').show();
				</c:if>
				//---------------------------------------------------------------------------------------------------------------------------------
				// 돌아가기 버튼
				$('#returnBtn').on('click', function () {
					const urlParams = new URLSearchParams(window.location.search);
					const uid = urlParams.get('uid');
					if (uid) {
						window.location.href = '/submission/check?uid=' + uid;
					} else {
						window.location.href = '/resume/list';
					}
				});

				//---------------------------------------------------------------------------------------------------------------------------------
				// 첨삭 모드 첨부파일 기능
				// 첨삭 모드 파일 업로드 관련 변수
				let adviceFiles = [];
				const maxFileSize = 10 * 1024 * 1024; // 10MB
				const maxImageSize = 2.5 * 1024 * 1024; // 2.5MB

				// 파일 선택 버튼 클릭 이벤트
				$('#fileInput-advice').on('change', function (e) {
					handleAdviceFiles(e.target.files);
				});

				// 드래그 앤 드롭 이벤트
				$('#fileContainer-advice').on('dragover', function (e) {
					e.preventDefault();
					$(this).addClass('border-primary');
				}).on('dragleave', function (e) {
					e.preventDefault();
					$(this).removeClass('border-primary');
				}).on('drop', function (e) {
					e.preventDefault();
					$(this).removeClass('border-primary');
					handleAdviceFiles(e.originalEvent.dataTransfer.files);
				});

				// 파일 처리 함수
				function handleAdviceFiles(files) {
					Array.from(files).forEach(file => {
						// 파일 크기 체크
						if (file.size > maxFileSize) {
							alert('파일 크기는 10MB를 초과할 수 없습니다.');
							return;
						}

						// 이미지 파일인 경우 2.5MB 제한
						if (file.type.startsWith('image/') && file.size > maxImageSize) {
							alert('이미지 파일은 2.5MB를 초과할 수 없습니다.');
							return;
						}

						// 파일 추가
						adviceFiles.push(file);
						updateAdviceFilePreview();
					});
				}

				// 파일 미리보기 업데이트
				function updateAdviceFilePreview() {
					const container = $('#previewContainer-advice');
					container.empty();

					adviceFiles.forEach((file, index) => {
						const fileItem = $('<div>').addClass('d-flex align-items-center mb-2 p-2 border rounded');

						// 파일 아이콘 또는 이미지 미리보기
						$('<i>').addClass('bi bi-file-earmark me-2').appendTo(fileItem);

						// 파일명
						$('<span>').text(file.name).addClass('flex-grow-1').appendTo(fileItem);

						// 삭제 버튼
						$('<button>')
							.addClass('btn btn-sm btn-outline-danger ms-2')
							.html('<i class="bi bi-x"></i>')
							.on('click', function () {
								adviceFiles.splice(index, 1);
								updateAdviceFilePreview();
							})
							.appendTo(fileItem);

						container.append(fileItem);
					});

					// 파일이 없을 경우 안내 메시지 표시
					$('.advice-file-text').toggle(adviceFiles.length === 0);
				}
				//---------------------------------------------------------------------------------------------------------------------------------
				// 첨삭 모드 첨삭 의견 글자 수
				$('#adviceTextarea').on('input', function () {
					const currentLength = $(this).val().length;
					const maxLength = 3000;
					const remainingLength = maxLength - currentLength;
					$('#adviceCharCount').text(currentLength + ' / ' + maxLength);
				});

				//---------------------------------------------------------------------------------------------------------------------------------
				// 첨삭 모드 저장 버튼
				$('#adviceSaveBtn').on('click', async function () {
					const adviceContent = $('#adviceTextarea').val();
					const files = adviceFiles;

					// 첨삭 의견 유효성
					if (adviceContent.trim() === '') {
						alert('첨삭 의견을 입력해주세요.');
						return;
					}

					try {
						// 첨부파일 업로드
						const uploadPromises = files.map(file => {
							const formData = new FormData();
							formData.append("file", file);

							return $.ajax({
								url: '/resume/uploadFile',
								type: 'POST',
								data: formData,
								processData: false,
								contentType: false
							});
						});

						const uploadResults = await Promise.all(uploadPromises);

						// 첨삭 내용과 파일 정보 저장
						const adviceData = {
							mentorUid: $('#userUid').val(),
							resumeNo: ${ resumeDetail.resume.resumeNo },
							adviceContent: adviceContent,
							files: uploadResults.map(result => ({
								adviceFileName: result.newFileName
							}))
					};

					console.log(adviceData);

					// 첨삭 저장 요청
					$.ajax({
						url: '/resume/advice/save',
						type: 'POST',
						contentType: 'application/json',
						data: JSON.stringify(adviceData),
						success: function (response) {
							if (response.success) {
								alert('첨삭이 저장되었습니다.');
								window.location.href = '/resume/list';
							} else {
								alert('첨삭 저장에 실패했습니다.');
							}
						},
						error: function (error) {
							console.error('첨삭 저장 중 오류 발생:', error);
							alert('첨삭 저장 중 오류가 발생했습니다.');
						}
					});
				} catch (error) {
					console.error('파일 업로드 중 오류 발생:', error);
					alert('파일 업로드 중 오류가 발생했습니다.');
				}
				});

		});
			</script>