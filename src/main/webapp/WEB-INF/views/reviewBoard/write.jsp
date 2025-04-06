<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>면접 후기 작성</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<style>
:root { -
	-heading-color: #1e2a45; -
	-nav-dropdown-hover-color: #80cfff; -
	-background-color: #ffffff;
}

body {
	background-color: var(- -background-color);
	font-size: var(- -bs-body-font-size);
}

h2 {
	font-size: 32px;
	color: var(- -heading-color);
	font-weight: bold;
}

label.form-label {
	font-size: 18px;
	font-weight: bold;
	color: var(- -heading-color);
}

.form-text {
	font-size: 14px;
}

.form-check-label, .form-select, .form-control, option {
	font-size: var(- -bs-body-font-size);
}

.gonggo-detail {
	background-color: #f8f9fa;
}

.btn-primary {
	background-color: var(- -heading-color);
	border-color: var(- -heading-color);
}

.btn-primary:hover {
	background-color: var(- -nav-dropdown-hover-color);
	border-color: var(- -nav-dropdown-hover-color);
}

.btn-secondary {
	font-size: 16px;
	font-weight: bold;
}
</style>
<script>
        function showGonggoDetails() {
            const select = document.getElementById("gonggoSelect");
            const selectedValue = select.value;

            const details = document.querySelectorAll(".gonggo-detail");
            details.forEach(div => div.style.display = "none");

            const target = document.getElementById("gonggoDetail-" + selectedValue);
            if (target) target.style.display = "block";

            const companyName = select.options[select.selectedIndex].getAttribute("data-company");
            document.getElementById('companyNameInput').value = companyName;
        }

        function toggleOtherTypeInput() {
            const otherInput = document.getElementById("otherTypeInput");
            const isOtherChecked = document.getElementById("reviewTypeOther").checked;
            otherInput.style.display = isOtherChecked ? "block" : "none";
        }
    </script>
</head>
<body>
	<div class="container mt-5">
		<h2 class="mb-4">면접 후기 작성</h2>

		<c:if test="${not empty sessionScope.account}">
			<form action="${pageContext.request.contextPath}/reviewBoard/write"
				method="post">
				<div class="mb-3">
					<label class="form-label">이력서 선택<span class="text-danger">*</span></label>
					<select class="form-select" id="gonggoSelect" name="gonggoUid"
						required onchange="showGonggoDetails()">
						<option value="" selected disabled>이력서를 선택하세요</option>
						<c:forEach var="gonggo" items="${gonggoList}">
							<option value="${gonggo.recruitmentnoticeNo}"
								data-company="${gonggo.companyName}">
								${gonggo.resumeTitle}</option>
						</c:forEach>
					</select>
				</div>

				<c:forEach var="gonggo" items="${gonggoList}">
					<div id="gonggoDetail-${gonggo.recruitmentnoticeNo}"
						class="gonggo-detail mb-3 p-3 border rounded"
						style="display: none">
						<p class="mb-1">
							<strong>회사명:</strong> ${gonggo.companyName}
						</p>
						<p class="mb-1">
							<strong>공고 제목:</strong> ${gonggo.recruitmentTitle}
						</p>
						<p class="mb-1">
							<strong>근무 형태:</strong> ${gonggo.workType}
						</p>
						<p class="mb-1">
							<strong>경력 사항:</strong> ${gonggo.personalHistory}
						</p>
						<p class="mb-1">
							<strong>급여 형태:</strong> ${gonggo.payType}
						</p>
						<p class="mb-1">
							<strong>근무 기간:</strong> ${gonggo.period}
						</p>
						
					</div>
				</c:forEach>

				<input type="hidden" name="companyName" id="companyNameInput" />

				<div class="mb-3">
					<label class="form-label">면접 유형<span class="text-danger">*</span></label><br>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio" name="reviewType"
							value="FACE_TO_FACE" required onclick="toggleOtherTypeInput()">
						<label class="form-check-label">대면</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio" name="reviewType"
							value="VIDEO" onclick="toggleOtherTypeInput()"> <label
							class="form-check-label">비대면</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio" name="reviewType"
							value="PHONE" onclick="toggleOtherTypeInput()"> <label
							class="form-check-label">전화면접</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="radio" id="reviewTypeOther"
							name="reviewType" value="OTHER" onclick="toggleOtherTypeInput()">
						<label class="form-check-label">기타</label>
					</div>
				</div>

				<div class="mb-3" id="otherTypeInput" style="display: none">
					<label class="form-label">기타 면접 유형 입력</label> <input type="text"
						class="form-control" name="reviewTypeOtherText"
						placeholder="면접 유형을 입력하세요">
				</div>

				<div class="mb-3">
					<label class="form-label">면접 난이도<span class="text-danger">*</span></label>
					<select class="form-select" name="reviewLevel" required>
						<option value="" selected disabled>난이도를 선택하세요</option>
						<option value="1">⭐️</option>
						<option value="2">⭐️⭐️</option>
						<option value="3">⭐️⭐️⭐️</option>
						<option value="4">⭐️⭐️⭐️⭐️</option>
						<option value="5">⭐️⭐️⭐️⭐️⭐️</option>
					</select>
				</div>

				<div class="mb-3">
					<label class="form-label">면접 결과<span class="text-danger">*</span></label>
					<select class="form-select" name="reviewResult" required>
						<option value="" selected disabled>결과를 선택하세요</option>
						<option value="PASSED">합격</option>
						<option value="FAILED">불합격</option>
						<option value="PENDING">진행중</option>
					</select>
				</div>

				<div class="mb-3">
					<label class="form-label">리뷰 내용<span class="text-danger">*</span></label>
					<textarea class="form-control" name="content" rows="6"
						placeholder="면접 질문, 분위기 등을 자유롭게 작성해주세요." required></textarea>
				</div>

				<input type="hidden" name="writer"
					value="${sessionScope.account.uid}" />

				<div class="d-flex gap-2">
					<button type="submit" class="btn btn-primary">후기 등록</button>
					<a href="${pageContext.request.contextPath}/reviewBoard/allBoard"
						class="btn btn-secondary">취소</a>
				</div>
			</form>
		</c:if>

		<c:if test="${empty sessionScope.account}">
			<div class="alert alert-warning mt-4" role="alert">
				로그인 후 이용 가능한 기능입니다. <a
					href="${pageContext.request.contextPath}/account/login"
					class="alert-link">로그인하러 가기</a>
			</div>
		</c:if>
	</div>
</body>
</html>
