<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
<table border="1">
        <tr>
            <th>번호</th>
            <th>회사명</th>
            <th>리뷰 유형</th>
            <th>작성자</th>
            <th>날짜</th>
            <th>조회수</th>
        </tr>

        <c:forEach var="reviewBoard" items="${blist}">
            <tr>
                <td>${reviewBoard.boardNo}</td>
                <td>${reviewBoard.companyName}</td>
                <td>${reviewBoard.reviewType}</td>
                <td>${reviewBoard.writer}</td>
                <td>${reviewBoard.postDate}</td>
                <td>${reviewBoard.views}</td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>