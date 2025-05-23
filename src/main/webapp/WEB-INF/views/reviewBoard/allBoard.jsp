<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>면접 후 게시판</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
h2 {
	text-align: center;
	margin-top: 40px;
	font-size: 28px;
	font-weight: bold;
	color: #2c3e50;
}

.table-container {
	width: 100%;
	max-width: 900px;
	margin: 0 auto;
	border-collapse: collapse;
	font-size: 15px;
	background-color: white;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}

.table-container th, .table-container td {
	padding: 12px 16px;
	text-align: center;
	border-bottom: 1px solid #dee2e6;
}

.table-container th {
	background-color: #3d4d6a;
	color: white;
	font-weight: bold;
}

.table-container td a {
	color: #0d6efd;
	text-decoration: none;
}

.table-container td a:hover {
	text-decoration: underline;
}

.table-container tr:hover {
	background-color: #f8f9fa;
}

.postDate {
	white-space: nowrap;
}

.btn-write {
	display: block;
	margin: 30px auto;
	padding: 10px 30px;
	background-color: #47b2e4;
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
}

.btn-write:hover {
	background-color: #3aa8da;
}

.search-form-wrapper {
	max-width: 900px;
	margin: 0 auto 20px auto;
}

.btn-primary {
	background-color: #47b2e4 !important;
	border-color: #47b2e4 !important;
	color: white !important;
}

.btn-primary:hover {
	background-color: #3aa8da !important;
	border-color: #3aa8da !important;
}
</style>
</head>
<body>

	<jsp:include page="../header.jsp" />

	<h2>면접 후기 목록</h2>


	<div class="search-form-wrapper">
		<form method="get"
			action="${pageContext.request.contextPath}/reviewBoard/allBoard"
			class="row align-items-end gx-3 mb-4"
			style="max-width: 900px; margin: 0 auto;">

			<!-- 정렬 기준 -->
			<div class="col-md-3">
				<label class="form-label"></label> <select name="sortType"
					class="form-select">
					<option value="">-- 정렬 기준 --</option>
					<option value="likes"
						${param.sortType == 'likes' ? 'selected' : ''}>추천순</option>
					<option value="views"
						${param.sortType == 'views' ? 'selected' : ''}>조회순</option>
				</select>
			</div>

			<!-- 합격 여부 -->
			<div class="col-md-3">
				<label class="form-label"></label> <select name="resultFilter"
					class="form-select">
					<option value="">-- 합격 여부 --</option>
					<option value="PASSED"
						${param.resultFilter == 'PASSED' ? 'selected' : ''}>합격</option>
					<option value="FAILED"
						${param.resultFilter == 'FAILED' ? 'selected' : ''}>불합격</option>
					<option value="PENDING"
						${param.resultFilter == 'PENDING' ? 'selected' : ''}>진행중</option>
				</select>
			</div>

			<!-- 회사 필터: input 텍스트 방식으로 변경 -->
			<div class="col-md-3">
				<label class="form-label" for="companyFilter">회사명</label> <input
					type="text" name="companyFilter" class="form-control"
					placeholder="회사명을 입력하세요"
					value="${param.companyFilter != null ? param.companyFilter : ''}" />
			</div>

			<!-- 검색 버튼 -->
			<div class="col-md-3 d-flex gap-2">
				<button type="submit" class="btn btn-primary">검색</button>



				<button type="button" class="btn btn-secondary"
					onclick="window.location.href='${pageContext.request.contextPath}/reviewBoard/allBoard'">
					초기화</button>
			</div>
		</form>
	</div>


	<table class="table-container">
		<tr>
			<th>번호</th>
			<th>작성자</th>
			<th>회사</th>
			<th>면접 결과</th>
			<th>좋아요</th>
			<th>조회수</th>
			<th>등록날짜
			<th>
		</tr>
		<c:forEach var="board" items="${pageResult.boardList}">
			<tr
				onclick="location.href='${pageContext.request.contextPath}/reviewBoard/detail?boardNo=${board.boardNo}&page=${pageResult.page}'"
				style="cursor: pointer;">

				<td>${board.boardNo}</td>
				<td>${board.writer}</td>
				<td>${board.companyName}</td>
				<td><c:choose>
						<c:when test="${board.reviewResult eq 'PASSED'}">합격</c:when>
						<c:when test="${board.reviewResult eq 'FAILED'}">불합격</c:when>
						<c:when test="${board.reviewResult eq 'PENDING'}">진행중</c:when>
						<c:otherwise>미선택</c:otherwise>
					</c:choose></td>
				<td>${board.likes}</td>
				<td class="views-cell" data-board-no="${board.boardNo}">${board.views}</td>

				<td class="postDate()" data-created="${board.postDate}"><fmt:formatDate
						value="${board.postDate}" pattern="yyyy년 MM월 dd일 HH:mm:ss" /></td>

			</tr>
		</c:forEach>
	</table>


	<!-- 페이징 영역 -->
	<c:set var="page" value="${pageResult.page}" />
	<c:set var="size" value="${pageResult.size}" />
	<c:set var="startPage" value="${pageResult.startPage}" />
	<c:set var="endPage" value="${pageResult.endPage}" />
	<c:set var="hasPrev" value="${pageResult.hasPrev}" />
	<c:set var="hasNext" value="${pageResult.hasNext}" />

	<nav aria-label="Page navigation">
		<ul class="pagination justify-content-center">

			<!-- 이전 블록 -->
			<c:if test="${pageResult.hasPrev}">
				<li class="page-item"><a class="page-link"
					href="?page=${pageResult.startPage - 1}&sortType=${param.sortType}&resultFilter=${param.resultFilter}&companyFilter=${param.companyFilter}">
						&laquo; </a></li>
			</c:if>

			<c:forEach var="i" begin="${pageResult.startPage}"
				end="${pageResult.endPage}">
				<li class="page-item ${i == pageResult.page ? 'active' : ''}">
					<a class="page-link"
					href="?page=${i}&sortType=${param.sortType}&resultFilter=${param.resultFilter}&companyFilter=${param.companyFilter}">
						${i} </a>
				</li>
			</c:forEach>



			<!-- 다음 -->
			<c:if test="${pageResult.hasNext}">
				<li class="page-item"><a class="page-link"
					href="?page=${pageResult.endPage + 1}&sortType=${param.sortType}&resultFilter=${param.resultFilter}&companyFilter=${param.companyFilter}">
						&raquo; </a></li>
			</c:if>

		</ul>
	</nav>
	<!-- 글쓰기 버튼 -->
	<button onclick="location.href='/reviewBoard/write'" class="btn-write">글
		작성</button>

	<script>
	
	$('select').change(function () {
		  $(this).closest('form').submit();
		});
	document.querySelectorAll('.postDate').forEach(cell => {
		  const created = cell.dataset.created;
		  if (created) {
		    cell.textContent = postDate(created); // 함수 호출해서 변환된 시간 출력
		  }
		});

	
	document.addEventListener("detail", function () {
		const rows = document.querySelectorAll(".clickDetail");
		rows.forEach(row => {
			row.addEventListener("click", function () {
				const url = this.getAttribute("data-href");
				if (url) {
					window.location.href = url;
				}
			});
		});
	});
	
	document.querySelectorAll(".views-cell").forEach(cell => {
		  const boardNo = cell.dataset.boardNo;

		  if (!boardNo) return; // 값이 없으면 패스

		  $.ajax({
		    url: '/reviewBoard/viewCount?boardNo=' + boardNo,
		    method: 'GET',
		    data: { boardNo: boardNo },
		    success: function(res) {
		      if (res.success) {
		        $(cell).text(res.message);
		      }
		    }
		  });
		});

	


</script>

</body>
</html>
