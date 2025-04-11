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
			<th>좋아요</th>
			<th>조회수</th>
			<th>등록날짜<th>
		</tr>
		<c:forEach var="board" items="${blist}">
			<tr>
				<td>${board.boardNo}</td>
				<td>${board.writer}</td>
				<td><a href="/reviewBoard/detail?boardNo=${board.boardNo}">
				${board.companyName}</a></td>
				<td>${board.likes}</td>
				<td>${board.views}</td>
				<td class="postDate()">${board.postDate}</td>
			</tr>
		</c:forEach>
	</table>
	
	
	
		<!-- 글쓰기 버튼 -->
	<button onclick="location.href='/reviewBoard/write'" class="btn-write">글
		작성</button>
		
		<script >
		function postDate() {
			  const now = new Date();  // 현재 시간
			  const postTime = new Date(createdAt);  // 글 작성 시간
			  const milli = now - postTime;  // 밀리초 차이
			  const sec = Math.floor(milli / 1000);  // 초로 변환

			  if (sec < 60) return sec;

			  const min = Math.floor(sec / 60);  // 분
			  if (min < 60) return min;

			  const hr = Math.floor(min / 60);  // 시간
			  if (hr < 24) return hr;

			  const day = Math.floor(hr / 24);  // 일
			  if (day < 7) return day;

			  // 오래된 글은 날짜 출력
			  return postTime.toLocaleString();
			}
		
		</script>
</body>
</html>
