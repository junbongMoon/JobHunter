<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>결제 실패</title>
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
<h2>❌ 결제에 실패했습니다.</h2>
<p>${error}</p>
<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>