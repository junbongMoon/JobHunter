<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>면접 후기 상세보기</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.section-title {
	font-size: 28px;
	font-weight: bold;
	margin-bottom: 20px;
	color: #003366;
}

.table th {
	background-color: #f5f5f5;
	width: 20%;
}

.table th {
	background-color: #f8f9fa;
	width: 20%;
	vertical-align: middle;
	padding: 10px;
	font-weight: bold;
	font-size: 15px;
}

.table td {
	vertical-align: middle;
	padding: 10px;
	font-size: 15px;
}

.table td.review-content {
	vertical-align: top;
	white-space: pre-line;
	line-height: 1.5;
}
</style>
</head>
<body class="bg-light">

	<jsp:include page="../header.jsp" />

	<div class="container mt-5 mb-5">
		<h2 class="section-title text-center">면접 후기 상세보기</h2>

		<!-- 기업 정보 -->
		<h5 class="mb-3 text-primary fw-bold">기업 정보</h5>
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>회사명</th>
					<td>${detail.companyName}</td>
				</tr>
				<tr>
					<th>공고 상세</th>
					<td>${detail.detail}</td>
				</tr>
				<tr>
					<th>근무 형태</th>
					<td>${detail.workType}</td>
				</tr>
				<tr>
					<th>근무 기간</th>
					<td>${detail.period}</td>
				</tr>
				<tr>
					<th>급여 형태</th>
					<td>${detail.payType}</td>
				</tr>
				<tr>
					<th>경력 사항</th>
					<td>${detail.personalHistory}</td>
				</tr>
			</tbody>
		</table>

		<!-- 지원자 정보 -->
		<h5 class="mb-3 text-primary fw-bold">지원자 정보</h5>
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>작성자 ID</th>
					<td>${detail.userId}</td>
				</tr>
				<tr>
					<th>이력서 제목</th>
					<td>${detail.title}</td>
				</tr>
			</tbody>
		</table>

		<!-- 면접 후기 -->
		<h5 class="mb-3 text-primary fw-bold">면접 후기</h5>
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>면접 유형</th>
					<td><c:choose>
							<c:when test="${detail.reviewType eq 'FACE_TO_FACE'}">대면</c:when>
							<c:when test="${detail.reviewType eq 'VIDEO'}">비대면</c:when>
							<c:when test="${detail.reviewType eq 'PHONE'}">전화면접</c:when>
							<c:when test="${detail.reviewType eq 'OTHER'}">기타</c:when>
							<c:otherwise>알 수 없음</c:otherwise>
						</c:choose></td>
				</tr>
				<tr>
					<th>면접 결과</th>
					<td><c:choose>
							<c:when test="${detail.reviewResult eq 'PASSED'}">합격</c:when>
							<c:when test="${detail.reviewResult eq 'FAILED'}">불합격</c:when>
							<c:when test="${detail.reviewResult eq 'PENDING'}">진행중</c:when>
							<c:otherwise>미제공</c:otherwise>
						</c:choose></td>
				</tr>
				<tr>
					<th>난이도</th>
					<td><c:forEach begin="1" end="${detail.reviewLevel}">⭐</c:forEach>
						(${detail.reviewLevel}/5)</td>
				</tr>
				<tr>
					<th>조회수</th>
					<td>${detail.views}</td>
				</tr>
				<tr>
					<th>후기 내용</th>
					<td>${detail.content}</td>
				</tr>
			</tbody>
		</table>


		
		<!-- 좋아요 버튼 영역 -->
		<div class="d-flex justify-content-between align-items-center mt-4">
			<div class="text-muted">
				👍 <span id="likeCount">${detail.likes}</span> &nbsp;&nbsp;&nbsp;
				👁️ ${detail.views}
			</div>
			<!-- 좋아요 버튼 -->
			<button id="likeBtn" class="btn btn-danger btn-sm">❤️ 좋아요</button>
			<a href="${pageContext.request.contextPath}/reviewBoard/allBoard"
				class="btn btn-outline-secondary">← 목록으로</a>
		</div>
	</div>
	<!-- 게시글 번호 hidden으로 전달 -->

		<input type="hidden" id="boardNo" value="${detail.boardNo}" /> 
		<input type="hidden" id="userId" value="${sessionScope.account.uid}" />
	<script>
	$('#likeBtn').on('click', function () {
		  const boardNo = $('#boardNo').val();
		  const userId = $('#userId').val(); 

		  $.ajax({
		    url: '${pageContext.request.contextPath}/reviewBoard/like',
		    method: 'POST',
		    contentType: 'application/json',
		    data: JSON.stringify({ boardNo: boardNo, userId: userId }),  // 둘 다 전송
		    success: function (message) {
		      alert("좋아요가 추가 되었습니다");
		      location.reload(); // 새로고침으로 좋아요 수 반영
		    },
		    error: function (xhr) {
		      if (xhr.status === 401) {
		        alert("로그인이 필요합니다.");
		        window.location.href = '${pageContext.request.contextPath}/account/login';
		      } else {
		        alert(xhr.responseText);
		      }
		    }
		  });
		});
	</script>


</body>
</html>
