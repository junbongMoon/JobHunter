<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>승급 신청 상세보기</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<script>
  $(function() {
  // 삭제 버튼 클릭 시 모달 열기
  $("#deleteBtn").click(function() {
    $("#deleteModal").fadeIn();
  });

  // 취소 버튼 클릭 시 모달 닫기
  $("#cancelDelete").click(function() {
    $("#deleteModal").fadeOut();
  });

  // 삭제 확인
  $("#confirmDelete").click(function() {
    if ($("#confirmInput").val().trim() === "삭제하겠습니다") {
      // 진짜 삭제 요청
      $.ajax({
        url: "/advancement/delete", 
        type: "POST",
        data: { advancementNo: "${advancement.advancementNo}" },
        success: function() {
          showAlertModal("삭제가 완료되었습니다.");
          location.href = "/advancement/list?uid=${sessionScope.account.uid}";
        },
        error: function() {
          showAlertModal("삭제 실패. 다시 시도해주세요.");
        }
      });
    } else {
      showAlertModal("정확히 '삭제하겠습니다'를 입력해야 합니다.");
    }
  });
});

function showAlertModal(message) {
  $('#alertModalBody').text(message);
  const modal = new bootstrap.Modal(document.getElementById('alertModal'));
  modal.show();
}
</script>
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
  .pr-content {
    background: #f3f5fa;
    padding: 1.5rem;
    border-radius: 10px;
    margin-top: 1rem;
    margin-bottom: 2rem;
    color: #444444;
    line-height: 1.6;
  }
  .preview-area {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 10px;
    margin-bottom: 2rem;
  }
  .preview-item img {
    width: 120px;
    height: 120px;
    object-fit: cover;
    border-radius: 10px;
    box-shadow: 0 0 5px rgba(0,0,0,0.2);
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
</style>
</head>
<body>

<jsp:include page="../header.jsp"></jsp:include>

<div class="pr-detail-container">
  <h2 class="pr-title">${advancement.title}</h2>

  <div class="pr-info">
    <p><strong>작성자:</strong> ${advancement.writer}</p>
    <p><strong>작성일:</strong> ${advancement.formattedPostDate}</p>
    <p><strong>상태:</strong> ${advancement.status}</p>
  </div>

  <div class="pr-content">
    ${advancement.content}
  </div>

  <div style="margin-bottom: 2rem;">
    <strong>첨부 파일:</strong>
    <c:choose>
      <c:when test="${not empty advancement.fileList}">
        <div class="preview-area">
          <c:forEach var="file" items="${advancement.fileList}">
            <div class="preview-item">
              <img src="${pageContext.request.contextPath}${file.thumbFileName}" alt="${file.originalFileName}">
              <div style="text-align: center; margin-top: 5px;">
                <a href="${pageContext.request.contextPath}${file.newFileName}" download="${file.originalFileName}">
                  ${file.originalFileName}
                </a>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <p style="margin-top: 10px; color: #888;">첨부파일 없음</p>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="button-group">
    <a href="/advancement/list?uid=${sessionScope.account.uid}" class="btn btn-list">
      <i class="fas fa-list"></i> 목록으로
    </a>

    <c:if test="${sessionScope.account.uid == advancement.refUser and sessionScope.account.accountType == 'USER'}">
      <a href="/advancement/modify?id=${advancement.advancementNo}" class="btn btn-modify">
        <i class="fas fa-edit"></i> 수정
      </a>
      <button type="button" class="btn btn-delete" id="deleteBtn">
        <i class="fas fa-trash"></i> 삭제
      </button>
    </c:if>
  </div>

  <div id="deleteModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000;">
    <div style="background:white; padding:2rem; border-radius:10px; width:300px; text-align:center; position:relative; top:100px; margin:0 auto;">
      <h3 style="margin-bottom:1rem;">삭제 확인</h3>
      <p style="margin-bottom:1rem;">"삭제하겠습니다"를 입력하세요.</p>
      <input type="text" id="confirmInput" placeholder="삭제하겠습니다" style="width:100%; padding:0.5rem; margin-bottom:1rem;">
      <div style="display:flex; justify-content:space-between; gap:10px;">
        <button id="confirmDelete" style="flex:1; padding:0.5rem; background:#e74c3c; color:white; border:none; border-radius:5px;">삭제</button>
        <button id="cancelDelete" style="flex:1; padding:0.5rem; background:#ccc; border:none; border-radius:5px;">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- 공통 알림 모달 -->
<div class="modal fade" id="alertModal" tabindex="-1" aria-labelledby="alertModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="alertModalLabel">알림</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body" id="alertModalBody">
        <!-- 알림 내용 -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
      </div>
    </div>
  </div>
</div>


<jsp:include page="../footer.jsp"></jsp:include>

</body>
</html>
