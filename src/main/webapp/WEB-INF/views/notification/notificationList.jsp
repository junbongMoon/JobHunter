<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림</title>
</head>
<body>
	<h2>알림 페이지</h2>
	<p>알림 내용 예정</p>
</body>
</html>
<script>
        // 팝업 창 크기와 위치를 설정
        window.onload = function () {
            const width = 500;
            const height = 600;

            const screenX = window.screenX !== undefined ? window.screenX : window.screenLeft;
            const screenY = window.screenY !== undefined ? window.screenY : window.screenTop;

            const availWidth = screen.availWidth;
            const availHeight = screen.availHeight;

            const left = (availWidth - width) / 2;
            const top = (availHeight - height) / 2;

            // 창 크기와 위치 강제 설정
            window.resizeTo(width, height);
            window.moveTo(left, top);
        }
    </script>