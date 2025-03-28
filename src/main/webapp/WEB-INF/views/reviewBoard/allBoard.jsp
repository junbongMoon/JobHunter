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
  font-family: 'Segoe UI', sans-serif; /* 기본 글꼴 */
  background-color: #f4f4f4;            /* 페이지 배경색 */
  margin: 0;
  padding: 0;
}

/* 페이지 제목 스타일 */
h2 {
  text-align: center;      /* 가운데 정렬 */
  margin-top: 40px;        /* 위쪽 여백 */
  color: #333;             /* 글자색 (어두운 회색) */
}

/* 글쓰기 버튼 스타일 */
.btn-write {
  display: block;               /* 블록 요소로 설정 */
  width: 120px;                 /* 버튼 너비 */
  margin: 20px auto;            /* 위아래 여백 + 가운데 정렬 */
  padding: 10px 20px;           /* 내부 여백 */
  background-color: #007BFF;    /* 배경 파란색 */
  color: white;                 /* 글자색 흰색 */
  text-align: center;           /* 텍스트 가운데 정렬 */
  text-decoration: none;        /* 밑줄 제거 */
  border: none;                 /* 테두리 제거 */
  border-radius: 6px;           /* 버튼 모서리 둥글게 */
  font-weight: bold;            /* 글자 굵게 */
  cursor: pointer;              /* 마우스 올리면 손모양 커서 */
}

/* 글쓰기 버튼 마우스 오버 시 색상 변경 */
.btn-write:hover {
  background-color: #0056b3;    /* 더 진한 파란색 */
}

/* 테이블을 감싸는 부모 영역 */
.table-container {
  width: 100%;                  /* 가로폭 100% */
  max-width: 1000px;            /* 최대 너비 제한 */
  margin: auto;                 /* 가운데 정렬 */
  /* overflow-x: auto; ← 이 부분 제거하면 가로 스크롤 없음 */
}

/* 테이블 기본 스타일 */
table {
  width: 100%;                  /* 테이블 전체 너비 */
  table-layout: fixed;          /* 열 너비 고정 (비율에 따라 정렬됨) */
  border-collapse: collapse;    /* 셀 테두리 겹치기 */
  background-color: white;      /* 배경 흰색 */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
}

/* 테이블 헤더 및 데이터 셀 스타일 */
th, td {
 padding: 12px 8px;               /* 셀 안 여백 */
  border-bottom: 1px solid #ddd;
  text-align: center;              /* 가로 가운데 정렬 */
  vertical-align: middle;          /* 세로 가운데 정렬 */
  word-wrap: break-word;        /* 긴 텍스트 줄바꿈 허용 */
}

/* 테이블 헤더 배경 및 글자색 */
th {
  background-color: #007BFF;    /* 파란 배경 */
  color: white;                 /* 흰색 글자 */
}


</style>
</head>
<body>

	<jsp:include page="../header.jsp" />

	<h2>면접 후기 목록</h2>

	<!-- 글쓰기 버튼 -->
	<button onclick="location.href='/reviewBoard/write'" class="btn-write">글
		작성</button>


	<table class="table-container">
		<tr>
			<th>번호</th>
			<th>작성자</th>
			<th>회사</th>
			<th>좋아요</th>
			<th>조회수</th>
		</tr>
		<c:forEach var="board" items="${board}">
			<tr>
				<td>${board.boardNo}</td>
				<td>${board.writer}</td>
				<td><a href="/reviewBoard/detail?boardNo=${reviewBoard.boardNo}">
				${board.companyName}</a></td>
				<td>${board.likes}</td>
				<td>${board.views}</td>
			</tr>
		</c:forEach>
	</table>

</body>
</html>
