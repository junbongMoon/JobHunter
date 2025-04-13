<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>면접 후기 수정 페이지</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <style>
    h2 {
      font-size: 32px;
      color: #1e2a45;
      font-weight: bold;
    }
    label.form-label {
      font-size: 18px;
      font-weight: bold;
      color: #1e2a45;
    }
    .gonggo-detail {
      background-color: #f8f9fa;
    }
  </style>
  <script>
    function toggleOtherTypeInput() {
      const isOther = document.getElementById("reviewType-OTHER").checked;
      document.getElementById("otherTypeWrapper").style.display = isOther ? 'block' : 'none';
    }

    document.addEventListener("DOMContentLoaded", () => {
      const boardNo = document.querySelector("input[name='boardNo']").value;
      const reviewType = "${writeBoardDTO.reviewType}";

      if (reviewType === "OTHER") {
        document.getElementById("reviewType-OTHER").checked = true;
        toggleOtherTypeInput();
        const saved = localStorage.getItem(`reviewTypeOtherText-${boardNo}`);
        if (saved) {
          document.getElementById("otherTypeText").value = saved;
        }
      }

      // 기타 선택 시 토글 연결
      document.querySelectorAll("input[name='reviewType']").forEach(r => {
        r.addEventListener("change", toggleOtherTypeInput);
      });

      // submit 시 기타 텍스트 저장
      document.querySelector("form").addEventListener("submit", function () {
        const boardNo = document.querySelector("input[name='boardNo']").value;
        const reviewType = document.querySelector("input[name='reviewType']:checked").value;

        if (reviewType === 'OTHER') {
          const otherText = document.getElementById("otherTypeText").value.trim();
          if (otherText) {
            localStorage.setItem(`reviewTypeOtherText-${boardNo}`, otherText);
          }
        }
      });
    });

    function showGonggoDetails() {
      const selectedValue = document.getElementById("gonggoSelect").value;
      document.querySelectorAll(".gonggo-detail").forEach(div => div.style.display = "none");
      const target = document.getElementById("gonggoDetail-" + selectedValue);
      if (target) target.style.display = "block";

      const companyName = document.querySelector(`#gonggoSelect option[value='${selectedValue}']`).dataset.company;
      document.getElementById('companyNameInput').value = companyName;
    }

    function validateForm() {
      const resultConsent = document.getElementById("resultConsent");
      const reviewResult = document.getElementById("reviewResultSelect");

      if (!resultConsent.checked || !reviewResult.value) {
        alert("면접 결과 등록을 위해 동의하고 결과를 선택해주세요.");
        return false;
      }
      return true;
    }
  </script>
</head>
<body>
<jsp:include page="../header.jsp" />

<div class="container mt-5">
  <h2 class="mb-4 text-center">면접 후기 수정</h2>

  <div class="row">
    <div class="col-md-8 offset-md-2">
      <form action="${pageContext.request.contextPath}/reviewBoard/modify" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="boardNo" value="${writeBoardDTO.boardNo}" />
        <input type="hidden" name="companyName" id="companyNameInput" value="${writeBoardDTO.companyName}" />

        <!-- 이력서 선택 -->
        <div class="mb-3">
          <label class="form-label">이력서 선택</label>
          <select class="form-select" id="gonggoSelect" name="gonggoUid" required onchange="showGonggoDetails()">
            <option value="" disabled>이력서를 선택하세요</option>
            <c:forEach var="gonggo" items="${gonggoList}">
              <option value="${gonggo.recruitmentnoticeNo}" data-company="${gonggo.companyName}"
                ${gonggo.recruitmentnoticeNo == writeBoardDTO.gonggoUid ? 'selected' : ''}>
                ${gonggo.resumeTitle}
              </option>
            </c:forEach>
          </select>
        </div>

        <!-- 공고 상세 -->
        <c:forEach var="gonggo" items="${gonggoList}">
          <div id="gonggoDetail-${gonggo.recruitmentnoticeNo}" class="gonggo-detail mb-3 p-3 border rounded"
               style="display: ${gonggo.recruitmentnoticeNo == writeBoardDTO.gonggoUid ? 'block' : 'none'}">
            <p><strong>회사명:</strong> ${gonggo.companyName}</p>
            <p><strong>공고 제목:</strong> ${gonggo.recruitmentTitle}</p>
            <p><strong>근무 형태:</strong> ${gonggo.workType}</p>
            <p><strong>경력 사항:</strong> ${gonggo.personalHistory}</p>
            <p><strong>급여 형태:</strong> ${gonggo.payType}</p>
            <p><strong>근무 기간:</strong> ${gonggo.period}</p>
          </div>
        </c:forEach>

        <!-- 면접 유형 -->
<div class="mb-3">
  <label class="form-label">면접 유형</label><br />

  <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="reviewType" id="reviewType-FACE" value="FACE_TO_FACE"
           onclick="toggleOtherTypeInput()" ${writeBoardDTO.reviewType == 'FACE_TO_FACE' ? 'checked' : ''}>
    <label class="form-check-label" for="reviewType-FACE">대면</label>
  </div>

  <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="reviewType" id="reviewType-VIDEO" value="VIDEO"
           onclick="toggleOtherTypeInput()" ${writeBoardDTO.reviewType == 'VIDEO' ? 'checked' : ''}>
    <label class="form-check-label" for="reviewType-VIDEO">비대면</label>
  </div>

  <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="reviewType" id="reviewType-PHONE" value="PHONE"
           onclick="toggleOtherTypeInput()" ${writeBoardDTO.reviewType == 'PHONE' ? 'checked' : ''}>
    <label class="form-check-label" for="reviewType-PHONE">전화면접</label>
  </div>

  <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="reviewType" id="reviewType-OTHER" value="OTHER"
           onclick="toggleOtherTypeInput()" ${writeBoardDTO.reviewType == 'OTHER' ? 'checked' : ''}>
    <label class="form-check-label" for="reviewType-OTHER">기타</label>
  </div>

  <div class="mt-2" id="otherTypeWrapper"
       style="display: ${writeBoardDTO.reviewType == 'OTHER' ? 'block' : 'none'};">
    <input type="text" class="form-control"
           id="otherTypeText"
           name="typeOtherText"
           placeholder="기타 면접 유형을 입력해주세요"
           value="${writeBoardDTO.typeOtherText}">
  </div>
</div>


        <!-- 면접 난이도 -->
        <div class="mb-3">
          <label class="form-label">면접 난이도</label>
          <select class="form-select" name="reviewLevel" required>
            <c:forEach var="i" begin="1" end="5">
              <option value="${i}" ${i == writeBoardDTO.reviewLevel ? 'selected' : ''}>
                <c:forEach begin="1" end="${i}">⭐️</c:forEach>
              </option>
            </c:forEach>
          </select>
        </div>

        <!-- 면접 결과 -->
        <div class="mb-3">
          <label class="form-label">면접 결과</label>
          <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" id="resultConsent" checked
                   onchange="document.getElementById('reviewResultSelect').disabled = !this.checked">
            <label class="form-check-label">결과에 대한 진실 작성에 동의합니다.</label>
          </div>
          <select class="form-select" name="reviewResult" id="reviewResultSelect" required>
            <option value="" disabled>선택</option>
            <option value="PASSED" ${writeBoardDTO.reviewResult == 'PASSED' ? 'selected' : ''}>합격</option>
            <option value="FAILED" ${writeBoardDTO.reviewResult == 'FAILED' ? 'selected' : ''}>불합격</option>
            <option value="PENDING" ${writeBoardDTO.reviewResult == 'PENDING' ? 'selected' : ''}>진행중</option>
          </select>
        </div>

        <!-- 후기 내용 -->
        <div class="mb-3">
          <label class="form-label">리뷰 내용</label>
          <textarea class="form-control" name="content" rows="6" required>${writeBoardDTO.content}</textarea>
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-end gap-2 mt-4">
  <button type="submit" class="btn btn-primary">후기 수정</button>
   <a href="${pageContext.request.contextPath}/reviewBoard/detail?boardNo=${writeBoardDTO.boardNo}" class="btn btn-secondary">취소</a>
</div>
      </form>
    </div>
  </div>
</div>
</body>
</html>
