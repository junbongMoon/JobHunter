<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이력서 목록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
	<!-- 헤더 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />

	<div class="container my-5">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2>이력서 목록</h2>
			<a href="/resume/form" class="btn btn-primary">새 이력서 작성</a>
		</div>

		<div class="card">
			<div class="card-body">
				<p class="text-center text-muted">아직 업데이트 안됨.</p>
			</div>
		</div>
	</div>

	<!-- 풋터 -->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</body>
</html>

<script>

</script>