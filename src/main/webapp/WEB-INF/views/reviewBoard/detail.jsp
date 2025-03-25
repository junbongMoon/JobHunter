<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 상세 페이지</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f4f6f8;
	margin: 0;
	padding: 40px;
}

.container {
	max-width: 700px;
	margin: auto;
	background: white;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
}

h1 {
	text-align: center;
	color: #007BFF;
	margin-bottom: 30px;
}

.mb-3 {
	margin-bottom: 18px;
}

label {
	font-weight: bold;
	display: block;
	margin-bottom: 6px;
	color: #333;
}

input[type="text"] {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 6px;
	background-color: #f9f9f9;
}

.content-box {
	border: 1px solid #ccc;
	border-radius: 6px;
	background-color: #fdfdfd;
	padding: 15px;
	line-height: 1.6;
	color: #444;
}

.btns {
	text-align: center;
	margin-top: 30px;
}

.btns button {
	padding: 10px 20px;
	margin: 0 10px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-weight: bold;
	font-size: 14px;
}

.btns button:nth-child(1) {
	background-color: #6c757d;
	color: white;
}

.btns button:nth-child(2) {
	background-color: #ffc107;
	color: black;
}

.btns button:nth-child(3) {
	background-color: #dc3545;
	color: white;
}

#myModal {
	display: none;
	position: fixed;
	top: 30%;
	left: 50%;
	transform: translateX(-50%);
	background: white;
	border: 1px solid #ccc;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}
</style>
<script>
	$(function() {
		let status = '${param.status}';
		if (status === 'notallowed') {
			$('.modal-body').html('본인이 작성한 글만 수정/삭제 가능합니다.');
			$('#myModal').show(500);
		}

		$('.modalClose').click(function() {
			$('#myModal').hide();
		});
	});
</script>
</head>
<body>

	<jsp:include page="../header.jsp" />

	<div class="container">
		<h1>리뷰 상세 보기</h1>

		<div class="board">
			<div class="mb-3">
				<label>글 번호:</label><input type="text" value="${board.boardNo}"
					readonly />
			</div>
			<div class="mb-3">
				<label>작성자:</label><input type="text" value="${board.writer}"
					readonly />
			</div>
			<div class="mb-3">
				<label>회사명:</label><input type="text" value="${board.companyName}"
					readonly />
			</div>
			<div class="mb-3">
				<label>면접 유형:</label><input type="text" value="${board.reviewType}"
					readonly />
			</div>
			<div class="mb-3">
				<label>결과:</label><input type="text" value="${board.reviewResult}"
					readonly />
			</div>
			<div class="mb-3">
				<label>난이도:</label><input type="text" value="${board.reviewLevel}"
					readonly />
			</div>
			<div class="mb-3">
				<label>카테고리:</label><input type="text" value="${board.category}"
					readonly />
			</div>
			<div class="mb-3">
				<label>직무 유형:</label><input type="text" value="${board.jobType}"
					readonly />
			</div>
			<div class="mb-3">
				<label>작성일:</label><input type="text" value="${board.postDate}"
					readonly />
			</div>
			<div class="mb-3">
				<label>조회수:</label><input type="text" value="${board.views}"
					readonly />
			</div>
			<div class="mb-3">
				<label>내용:</label>
				<div class="content-box">${board.content}</div>
			</div>
		</div>

		<div class="btns">
			<button onclick="location.href='/reviewBoard/allBoard'">목록으로</button>
			<button
				onclick="location.href='/reviewBoard/modify?boardNo=${board.boardNo}'">수정</button>
			<button
				onclick="location.href='/reviewBoard/delete?boardNo=${board.boardNo}'">삭제</button>
		</div>
	</div>

	<!-- 모달 -->
	<div id="myModal">
		<div class="modal-body">내용</div>
		<button class="modalClose">닫기</button>
	</div>

</body>
</html>
