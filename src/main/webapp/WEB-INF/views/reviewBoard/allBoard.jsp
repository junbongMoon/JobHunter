<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>면접 후 게시판</title>
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



	<table class="table-container">
		<tr>
			<th>번호</th>
			<th>작성자</th>
			<th>회사</th>
			<th>면접 결과</th>
			<th>좋아요</th>
			<th>조회수</th>
			<th>등록날짜<th>
		</tr>
		<c:forEach var="board" items="${pageResult.boardList}">
			<tr>
				<td>${board.boardNo}</td>
				<td>${board.writer}</td>
				<td><a href="/reviewBoard/detail?boardNo=${board.boardNo}">
						${board.companyName}</a></td>
						  <td>
						  <c:choose>
						    <c:when test="${board.reviewResult eq 'PASSED'}">합격</c:when>
						    <c:when test="${board.reviewResult eq 'FAILED'}">불합격</c:when>
						    <c:when test="${board.reviewResult eq 'PENDING'}">진행중</c:when>
						    <c:otherwise>미선택</c:otherwise>
						  </c:choose>
									</td>
				<td>${board.likes}</td>
				<td>${board.views}</td>
				<td class="postDate()">${board.postDate}</td>
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

    <!-- 이전 페이지 블록 -->
    <c:if test="${hasPrev}">
      <li class="page-item">
        <a class="page-link" href="?page=${startPage - 1}&size=${size}" aria-label="Previous">
          &laquo;
        </a>
      </li>
    </c:if>

    <!-- 페이지 번호 -->
    <c:forEach var="i" begin="${startPage}" end="${endPage}">
      <li class="page-item ${i == page ? 'active' : ''}">
        <a class="page-link" href="?page=${i}&size=${size}">${i}</a>
      </li>
    </c:forEach>

    <!-- 다음 페이지 블록 -->
    <c:if test="${hasNext}">
      <li class="page-item">
        <a class="page-link" href="?page=${endPage + 1}&size=${size}" aria-label="Next">
          &raquo;
        </a>
      </li>
    </c:if>

  </ul>
</nav>

	<!-- 글쓰기 버튼 -->
	<button onclick="location.href='/reviewBoard/write'" class="btn-write">글
		작성</button>

	<script>
	
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

		
</script>
</body>
</html>
