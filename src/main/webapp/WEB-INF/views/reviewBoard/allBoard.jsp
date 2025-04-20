<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
	background-color: #2c3e50;
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
	background-color: #0d6efd;
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
}

.btn-write:hover {
	background-color: #0b5ed7;
}
</style>
</head>
<body>

	<jsp:include page="../header.jsp" />

	<h2>면접 후기 목록</h2>

	<form method="get"
		action="${pageContext.request.contextPath}/reviewBoard/allBoard"
		class="row g-2 align-items-center mb-4">

		<!-- 정렬 기준 -->
		<div class="col-auto">
			<label class="form-label">정렬</label> <select name="sortType"
				class="form-select">
				<option value="">-- 정렬 기준 --</option>
				<option value="likes" ${param.sortType == 'likes' ? 'selected' : ''}>추천순</option>
				<option value="views" ${param.sortType == 'views' ? 'selected' : ''}>조회순</option>
			</select>
		</div>

		<!-- 합격 여부 -->
		<div class="col-auto">
			<label class="form-label">합격 여부</label> <select name="resultFilter"
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

		<!-- 회사 필터 -->
		<div class="col-auto">
			<label class="form-label">회사명</label> <select name="companyFilter"
				class="form-select">
				<option value="">-- 회사 선택 --</option>
				<c:forEach var="com" items="${companyList}">
					<option value="${com}"
						${param.companyFilter == com ? 'selected' : ''}>${com}</option>
				</c:forEach>
			</select>
		</div>

		<!-- 검색 버튼 -->
		<div class="col-auto mt-4">
			<button type="submit" class="btn btn-primary">검색</button>
		</div>

		<div class="col-auto mt-4">
			<button type="button" class="btn btn-secondary"
				onclick="window.location.href='${pageContext.request.contextPath}/reviewBoard/allBoard'">
				초기화</button>
		</div>
	</form>



	<c:forEach var="i" begin="${pageResult.startPage}"
		end="${pageResult.endPage}">
		<a
			href="?page=${i}&sortType=${param.sortType}&resultFilter=${param.resultFilter}&companyFilter=${param.companyFilter}">
			${i} </a>
	</c:forEach>

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

				<td class="postDate()" data-created="${board.postDate}">${board.postDate}</td>

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

	function postDate(createdAt) {
		  const now = new Date();
		  const postTime = new Date(createdAt.split('.')[0]); 
		  const milli = now - postTime;
		  const sec = Math.floor(milli / 1000);

		  if (sec < 60) return `${sec}초 전`;
		  const min = Math.floor(sec / 60);
		  if (min < 60) return `${min}분 전`;
		  const hr = Math.floor(min / 60);
		  if (hr < 24) return `${hr}시간 전`;
		  const day = Math.floor(hr / 24);
		  if (day < 7) return `${day}일 전`;

		  // 오래된 글은 직접 포맷해서 반환
		  return formatDateWithoutMillis(createdAt.split('.')[0]);
		}
	
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
