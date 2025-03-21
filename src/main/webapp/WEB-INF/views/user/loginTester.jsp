<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인터셉터 테스트 페이지</title>
<script>
    function fetchData(endpoint) {
        fetch(endpoint, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.status === 401) {
                return response.json().then(data => {
                    alert("인증 필요: " + (data.message || "로그인하세요."));
                    if (data.loginUrl) {
                        window.location.href = data.loginUrl;
                    }
                });
            } else if (response.status === 403) {
                alert("접근 권한이 없습니다.");
            } else if (response.ok) {
                return response.json();
            } else {
                alert("알 수 없는 오류 발생.");
            }
        })
        .then(data => {
            if (data) alert("성공: " + JSON.stringify(data));
        })
        .catch(error => console.error('Error:', error));
    }
</script>
</head>
<body>
	<h2>인터셉터 확인용 테스트 페이지</h2>

	<!-- 기존 GET 방식 (페이지 이동) -->
	<h3>페이지 이동 방식</h3>
	<a href="user/authtest/login">로그인 체크 (GET 방식)</a> <br><br>
	<a href="user/authtest/verify">본인 확인</a> <br><br>
	<a href="user/authtest/type?role=user">유저 타입 확인 (User)</a> <br>
	<a href="user/authtest/type?role=company">유저 타입 확인 (Company)</a> <br>
	<a href="user/authtest/type?role=admin">유저 타입 확인 (Admin)</a> <br><br>
	<a href="user/authtest/deletion-pending">삭제 대기 상태 확인</a> <br><br>
	<a href="user/authtest/suspended">정지 상태 확인</a> <br><br>

	<!-- REST 방식 (Ajax 요청) -->
	<h3>REST 방식 (Ajax 요청)</h3>
	<button onclick="fetchData('/api/user/authtest/login')">로그인 체크 (REST)</button> <br><br>
	<button onclick="fetchData('/api/user/authtest/verify')">본인 확인 (REST)</button> <br><br>
	<button onclick="fetchData('/api/user/authtest/type?role=user')">유저 타입 확인 (User, REST)</button> <br>
	<button onclick="fetchData('/api/user/authtest/type?role=company')">유저 타입 확인 (Company, REST)</button> <br>
	<button onclick="fetchData('/api/user/authtest/type?role=admin')">유저 타입 확인 (Admin, REST)</button> <br><br>
	<button onclick="fetchData('/api/user/authtest/deletion-pending')">삭제 대기 상태 확인 (REST)</button> <br><br>
	<button onclick="fetchData('/api/user/authtest/suspended')">정지 상태 확인 (REST)</button> <br><br>

</body>
</html>
