<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 게시판</title>
<style>
/* 전체 배경 및 기본 글꼴 설정 */
body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f9f9f9;
	margin: 0;
	padding: 20px;
}
/* 제목 스타일 */
h2 {
	text-align: center;
	margin-bottom: 30px;
	color: #333;
}

.btn-write {
	display: block;
	width: 120px;
	margin: 0 auto 30px;
	padding: 10px 20px;
	background-color: #007BFF;
	color: white;
	text-align: center;
	text-decoration: none;
	border-radius: 6px;
	font-weight: bold;
}

.btn-write:hover {
	background-color: #0056b3;
}

table {
	width: 90%;
	margin: auto;
	border-collapse: collapse;
	background-color: white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

th, td {
	padding: 14px 16px;
	border-bottom: 1px solid #ddd;
	text-align: center;
}

th {
	background-color: #007BFF;
	color: white;
}

tr:hover {
	background-color: #f1f1f1;
}

.writer {
	color: #555;
}
</style>
</head>
<body>

	<jsp:include page="../header.jsp" />

	<h2>리뷰 게시판 목록</h2>

	<!-- 글쓰기 버튼 -->
	<button onclick="location.href='/reviewBoard/write'" class="btn-write">글 작성</button>

	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>회사명</th>
				<th>리뷰 유형</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="reviewBoard" items="${board}">
				<tr>
					<td>${reviewBoard.boardNo}</td>
					<td><a href="/review/detail?boardNo=${reviewBoard.boardNo}">
							${reviewBoard.companyName} </a></td>
					<td>${reviewBoard.reviewType}</td>
					<td class="writer">${reviewBoard.writer}</td>
					<td><fmt:formatDate value="${reviewBoard.postDate}"
							pattern="yyyy-MM-dd" /></td>
					<td>${reviewBoard.views}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>

</body>
</html>
