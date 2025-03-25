<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background-color: #f7f7f7;
        }

        .container {
            max-width: 700px;
            margin: auto;
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 6px;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            padding: 10px 20px;
            margin-right: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .btn-primary { background-color: #007bff; color: white; }
        .btn-warning { background-color: #ffc107; color: black; }
    </style>
</head>
<body>

<jsp:include page="../header.jsp" />

<div class="container">
    <h1>게시글 작성</h1>

    <form action="/reviewBoard/write" method="post">
        <div class="form-group">
            <label for="writer">작성자 ID</label>
            <input type="text" class="form-control" id="writer" name="writer" required>
        </div>

        <div class="form-group">
            <label for="companyName">회사명</label>
            <input type="text" id="companyName" name="companyName" required>
        </div>

        <div class="form-group">
            <label for="reviewResult">면접 결과</label>
            <select id="reviewResult" name="reviewResult" required>
                <option value="PASSED">합격</option>
                <option value="FAILED">불합격</option>
                <option value="PENDING">보류</option>
            </select>
        </div>

        <div class="form-group">
            <label for="reviewType">면접 유형</label>
            <select id="reviewType" name="reviewType" required>
                <option value="FACE_TO_FACE">대면</option>
                <option value="VIDEO">화상통화</option>
                <option value="PHONE">통화</option>
                <option value="OTHER">기타</option> 
            </select>
        </div>

        <div class="form-group">
            <label for="reviewLevel">난이도 (1~5)</label>
            <input type="number" id="reviewLevel" name="reviewLevel" min="1" max="5" required>
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" rows="5" required></textarea>
        </div>

        <div class="form-group">
            <label for="jobType">직무 고용형태</label>
            <select id="jobType" name="jobType" required>
                <option value="FULL_TIME">정규직</option>
                <option value="CONTRACT">계약직</option>
                <option value="INTERN">인턴</option>
                <option value="FREELANCER">프리랜서</option>
            </select>
        </div>

        <div class="form-group">
            <label for="category">카테고리</label>
            <input type="text" id="category" name="category" required>
        </div>


        <button type="submit" class="btn-primary">저장</button>
        <button type="button" class="btn-warning" onclick="location.href='/reviewBoard/allBoard'">취소</button>
    </form>
</div>

</body>
</html>
