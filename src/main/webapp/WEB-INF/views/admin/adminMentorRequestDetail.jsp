<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>유저 상세 정보 - 관리자 페이지</title>
</head>

<body id="page-top">

	<!-- 헤더 포함 (네비게이션바 + 사이드바 포함) -->
	<jsp:include page="adminheader.jsp"></jsp:include>

	<!-- 본문 내용 -->
	<div class="container-fluid">
		<h1 class="h3 mb-4 text-gray-800">유저 상세 정보</h1>

		<!-- 뒤로가기 버튼 -->
		<div class="mb-4">
					<a href="/admin/mentorRequestList" class="btn btn-secondary"> <i
						class="fas fa-arrow-left"></i> 목록으로 돌아가기
					</a>
		</div>
		<div>
			${item}
		</div>
	</div>

	<!-- 푸터 포함 -->
	<jsp:include page="adminfooter.jsp"></jsp:include>

	<!-- 페이지 로드 시 실행되는 스크립트 -->
	<script>
    </script>
</body>

</html>