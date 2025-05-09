<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멘토 승급</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="/resources/assets/css/main.css">
<script>
    $(document).ready(function () {
        $('#fileInput').change(function () {
        const file = this.files[0];
        if (!file) return;

        // 파일 크기 제한: 10MB
        if (file.size > 10 * 1024 * 1024) {
            showAlertModal("파일 크기는 최대 10MB까지 가능합니다.");
            this.value = '';
            return;
        }

        // 파일 개수 제한: 기존 + 신규 1개 ≤ 3
        const existingCount = $("#previewArea .preview-item").length;
        if (existingCount >= 3) {
            showAlertModal("최대 3개의 파일만 업로드할 수 있습니다.");
            this.value = '';
            return;
        }

            const formData = new FormData();
            formData.append("file", file);

            $.ajax({
                url: "/advancement/file",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function (fileList) {
                    if (fileList && fileList.length > 0) {
                        const lastFile = fileList[fileList.length - 1];
                        const index = fileList.length - 1;

                        const fileId = `file-\${index}`;
                        let previewHtml = `
                            <div class="preview-item" id="\${fileId}">
                                <img class="preview-img" src="data:image/png;base64,\${lastFile.base64Image}" alt="썸네일">
                                <button type="button" class="delete-btn" data-index="\${index}">X</button>
                            </div>`;

                        $('#previewArea').append(previewHtml);
                    }
                },
                error: function (err) {
                    showAlertModal("파일 업로드 실패");
                    console.error(err);
                }
            });
        });

        // 동적 삭제 이벤트 위임
        $('#previewArea').on('click', '.delete-btn', function () {
            const index = $(this).data('index');
            $.ajax({
                url: '/advancement/deleteFile',
                type: 'POST',
                data: { index: index },
                success: function () {
                    $(`#file-\${index}`).remove();
                },
                error: function () {
                    showAlertModal("파일 삭제 실패");
                }
            });
        });
    });

    function showAlertModal(message) {
  $('#alertModalBody').text(message);
  const modal = new bootstrap.Modal(document.getElementById('alertModal'));
  modal.show();
}

</script>

<style>
    .preview-item {
        display: inline-block;
        position: relative;
        margin: 5px;
    }

    .preview-img {
        width: 100px;
        border-radius: 6px;
        box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
    }

    .delete-btn {
        position: absolute;
        top: 2px;
        right: 2px;
        background: rgba(255, 0, 0, 0.7);
        border: none;
        color: white;
        font-weight: bold;
        cursor: pointer;
        border-radius: 50%;
        width: 22px;
        height: 22px;
    }
    
    .submitBtn{
        margin-top: 20px;
        padding: 8px 20px;
        font-size: 16px;
        border-radius: 8px;
    }

    .form-actions {
        text-align: right;
        margin-top: 20px;
    }
    </style>
</head>
<body>
<jsp:include page="../header.jsp"></jsp:include>
<section id="blog-comment-form" class="blog-comment-form section">

    <div class="container" data-aos="fade-up" data-aos-delay="100">

<div class="container advancement-container">


    <form id="advancementForm" action="/advancement/modify" method="post" class="advancement-form">

        <div class="form-header categories-widget widget-item">
            <h3>멘토 승급</h3>
            <p>하단에 정보를 입력해주세요</p>
        </div>

        <div class="form-group">
            <label class="form-label">제목</label>
            <input type="text" name="title" class="form-control" required value="${advancement.title}">
        </div>

        <div class="form-group">
            <label class="form-label">작성자</label>
            <input type="text" name="writer" class="form-control" required value="${advancement.writer}" readonly = "true">
        </div>

        <input type="hidden" name="refUser" value="${advancement.refUser}">
        <input type="hidden" name="advancementNo" value="${advancement.advancementNo}">

        <div class="form-group">
            <label class="form-label">내용</label>
            <textarea name="content" class="form-control" rows="6" required>${advancement.content}</textarea>
        </div>

        <div class="form-group">
            <label class="form-label">첨부 파일</label>
            <div class="file-upload-area">
                <input type="file" id="fileInput" class="form-control" accept="image/*">
                <div id="previewArea" class="preview-area">
                    <c:if test="${not empty advancement.fileList}">
                        <c:forEach var="file" items="${advancement.fileList}" varStatus="status">
                            <div class="preview-item" id="file-${status.index}">
                                <img class="preview-img" src="${pageContext.request.contextPath}${file.thumbFileName}" alt="${file.originalFileName}">
                                <button type="button" class="delete-btn" data-index="${status.index}">X</button>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </div>
        

        <div class="form-actions">
            <button type="submit" class="btn btn-primary submitBtn">저장하기</button>
        </div>
    </form>
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
  
</section>

<jsp:include page="../footer.jsp"></jsp:include>


</body>
</html>