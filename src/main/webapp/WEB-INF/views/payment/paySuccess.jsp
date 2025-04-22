<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제성공</title>
<script>
  window.onload = function() {
    const el = document.getElementById("someElement"); // ← 이 부분 확인
    if (el) {
      el.style.display = "block"; // ✔️ null 체크 후 스타일 적용
    }
  };
</script>
</head>
<body>
    <jsp:include page="../header.jsp"></jsp:include>
    <jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>