<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멘토PR 상세</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<style>
  .pr-detail-container {
    max-width: 800px;
    margin: 2rem auto;
    padding: 2rem;
    background: white;
    border-radius: 15px;
    box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
  }

  .pr-title {
    color: #3d4d6a;
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 2px solid #47b2e4;
  }

  .pr-info {
    margin-bottom: 2rem;
  }

  .pr-info p {
    color: #444444;
    font-size: 1.1rem;
    margin-bottom: 0.8rem;
    display: flex;
    align-items: center;
  }

  .pr-info p strong {
    color: #3d4d6a;
    margin-right: 0.5rem;
    min-width: 80px;
  }

  .pr-introduce {
    background: #f3f5fa;
    padding: 1.5rem;
    border-radius: 10px;
    margin-top: 1rem;
    margin-bottom: 2rem;
  }

  .pr-introduce strong {
    color: #3d4d6a;
    font-size: 1.2rem;
    margin-bottom: 1rem;
    display: block;
  }

  .pr-introduce p {
    color: #444444;
    line-height: 1.6;
    margin: 0;
  }

  .button-group {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    margin-top: 2rem;
  }

  .btn {
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
    border: none;
    cursor: pointer;
  }

  .btn-list {
    background-color: #3d4d6a;
    color: white;
  }

  .btn-list:hover {
    background-color: #2a344a;
    transform: translateY(-2px);
  }

  .btn-modify {
    background-color: #47b2e4;
    color: white;
  }

  .btn-modify:hover {
    background-color: #3a9fd1;
    transform: translateY(-2px);
  }

  .btn-delete {
    background-color: #dc3545;
    color: white;
  }

  .btn-delete:hover {
    background-color: #c82333;
    transform: translateY(-2px);
  }
</style>
</head>
<body>
<jsp:include page="../header.jsp"></jsp:include>

<div class="pr-detail-container">
  <h2 class="pr-title">${prBoard.title}</h2>
  
  <div class="pr-info">
    <p><strong>작성자:</strong> ${prBoard.writer}</p>
    <p><strong>아이디:</strong> ${prBoard.userId}</p>
    <p><strong>작성일:</strong> ${prBoard.formattedPostDate}</p>
  </div>

  <div class="pr-introduce">
    <strong>소개:</strong>
    <p>${prBoard.introduce}</p>
  </div>

  <div class="button-group">
    <a href="/prBoard/list" class="btn btn-list">
      <i class="fas fa-list"></i> 목록으로
    </a>
    
      <a href="/prBoard/modify?prBoardNo=${prBoard.prBoardNo}" class="btn btn-modify">
        <i class="fas fa-edit"></i> 수정
      </a>
      <button type="button" class="btn btn-delete" onclick="deletePrBoard(${prBoard.prBoardNo})">
        <i class="fas fa-trash"></i> 삭제
      </button>
    
  </div>
</div>

<script>
function deletePrBoard(prBoardNo) {
  if(confirm('정말로 이 게시물을 삭제하시겠습니까?')) {
    location.href = '/prBoard/remove?prBoardNo=' + prBoardNo;
  }
}
</script>

<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>