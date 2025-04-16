<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>면접 후기 상세보기</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/assets/css/main.css">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.section-title {
	font-size: 28px;
	font-weight: bold;
	margin-bottom: 20px;
	color: #003366;
}

.btn-getstarted {
	background-color: #47b2e4;
	color: #ffffff;
	padding: 6px 20px;
	font-size: 14px;
	font-weight: 500;
	border: none;
	border-radius: 50px;
	transition: 0.3s;
	font-family: var(- -default-font);
}

.btn-getstarted:hover {
	background-color: color-mix(in srgb, #47b2e4, black 10%);
	color: #ffffff;
}

.btn-rounded {
	background-color: #47b2e4; color : #ffffff;
	padding: 6px 20px;
	font-size: 14px;
	font-weight: 500;
	border: none;
	border-radius: 50px;
	transition: 0.3s;
	font-family: var(- -default-font);
	color: #ffffff;
}

.table th {
	background-color: #f8f9fa;
	width: 20%;
	vertical-align: middle;
	padding: 10px;
	font-weight: bold;
	font-size: 15px;
}

.table td {
	vertical-align: middle;
	padding: 10px;
	font-size: 15px;
}

.table td.review-content {
	vertical-align: top;
	white-space: pre-line;
	line-height: 1.5;
}
</style>


</head>
<body class="bg-light">

	<jsp:include page="../header.jsp" />

	<div class="container mt-5 mb-5">
		<h2 class="section-title text-center">면접 후기 상세보기</h2>

		<!-- 기업 정보 -->
		<h5 class="mb-3 text-primary fw-bold">기업 정보</h5>
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>회사명</th>
					<td>${detail.companyName}</td>
				</tr>
				<tr>
					<th>공고 상세</th>
					<td>${detail.detail}</td>
				</tr>
				<tr>
					<th>근무 형태</th>
					<td>${detail.workType}</td>
				</tr>
				<tr>
					<th>근무 기간</th>
					<td>${detail.period}</td>
				</tr>
				<tr>
					<th>급여 형태</th>
					<td>${detail.payType}</td>
				</tr>
				<tr>
					<th>경력 사항</th>
					<td>${detail.personalHistory}</td>
				</tr>
			</tbody>
		</table>

		<!-- 지원자 정보 -->
		<h5 class="mb-3 text-primary fw-bold">지원자 정보</h5>
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>작성자 ID</th>
					<td>${detail.userId}</td>
				</tr>
				<tr>
					<th>이력서 제목</th>
					<td>${detail.title}</td>
				</tr>
			</tbody>
		</table>

		<!-- 면접 후기 -->
		<h5 class="mb-3 text-primary fw-bold">면접 후기</h5>
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>면접 유형</th>
					<td><c:choose>
							<c:when test="${detail.reviewType eq 'FACE_TO_FACE'}">대면면접</c:when>
							<c:when test="${detail.reviewType eq 'VIDEO'}">비대면</c:when>
							<c:when test="${detail.reviewType eq 'PHONE'}">전화면접</c:when>
							<c:when test="${detail.reviewType eq 'OTHER'}">
				        기타
				        <c:if test="${not empty detail.typeOtherText}">
				          (<span>${detail.typeOtherText}</span>)
				        </c:if>
							</c:when>
							<c:otherwise>미선택</c:otherwise>
						</c:choose></td>
				</tr>
				<tr>
					<th>면접 난이도</th>
					<td><c:forEach begin="1" end="${detail.reviewLevel}">⭐</c:forEach>
						(${detail.reviewLevel}/5)</td>
				</tr>
				<tr>
					<th>조회수</th>
					<td><span id="viewCount">👁️ ${detail.views}회</span></td>
				</tr>
				<tr>
					<th>후기 내용</th>
					<td class="review-content">${detail.content}</td>
				</tr>
			</tbody>
		</table>


		<!-- 버튼 영역 -->
		<!-- 추천 영역 -->

		<button id="likeBtn" class="btn-getstarted btn-sm">👍 추천</button>
		<button id="unlikeBtn" class="btn-getstarted btn-sm">👎 추천 취소</button>

		<!-- 수정 버튼 -->
		<a
			href="${pageContext.request.contextPath}/reviewBoard/modify?boardNo=${detail.boardNo}"
			class="btn-getstarted btn-sm">✏️ 수정</a>

		<!-- 삭제 버튼 -->
		<form action="${pageContext.request.contextPath}/reviewBoard/delete"
			method="post" style="display: inline;">
			<input type="hidden" name="boardNo" value="${detail.boardNo}" />
			<button type="button" class="btn-getstarted btn-sm delete-btn" data-boardno="${detail.boardNo}">🗑 삭제
				</button>
		</form>


		<!-- 목록으로 -->
		<a
			href="/reviewBoard/allBoard?page=${pageRequestDTO.page}&searchType=${pageRequestDTO.searchType}&keyword=${pageRequestDTO.keyword}"
			class="btn btn-secondary btn-sm btn-rounded">목록으로 돌아가기</a>


	</div>

	<input type="hidden" id="boardNo" value="${detail.boardNo}" />
	<input type="hidden" id="userId" value="${sessionScope.account.uid}" />

	<!-- 좋아요 알림 모달 -->
	<div class="modal fade" id="likeModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content text-center">
				<div class="modal-header">
					<h5 class="modal-title" id="likeModalLabel">알림</h5>
				</div>
				<div class="modal-body" id="likeModalMessage"></div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary"
						data-bs-dismiss="modal">확인</button>
				</div>
			</div>
		</div>
	</div>
	</div>

	<script>
	document.addEventListener("formData", () => {
		  const form = document.getElementById("reviewForm");

		  if (form === null) {
		    console.warn("리뷰 폼이 존재하지 않아 유효성 검사를 생략합니다.");
		    return;
		  }

		  const reviewTypeSelect = document.getElementById("reviewType");
		  const typeOtherTextInput = document.getElementById("typeOtherText");

		  form.addEventListener("submit", (e) => {
		    const selectedType = reviewTypeSelect?.value;
		    const otherText = typeOtherTextInput?.value?.trim();

		    if (selectedType === "OTHER") {
		      if (!otherText) {
		        alert("기타 사유를 입력해주세요.");
		        typeOtherTextInput?.focus();
		        e.preventDefault();
		        return;
		      }

		      if (otherText.length > 100) {
		        alert("기타 사유는 100자 이내로 입력해주세요.");
		        e.preventDefault();
		        return;
		      }
		    }
		  });
		});



$(function () {
  $('#likeBtn').on('click', function () {
    const boardNo = $('#boardNo').val();
    const userId = $('#userId').val();

    $.ajax({
      url: '${pageContext.request.contextPath}/reviewBoard/like',
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ boardNo: boardNo, userId: userId }),
      success: function (message) {
        alert(message);
        location.reload();
      },
      error: function (xhr) {
        if (xhr.status === 401) {
          alert("로그인이 필요합니다.");
          window.location.href = '${pageContext.request.contextPath}/account/login';
        } else if (xhr.status === 400) {
          alert(xhr.responseText);
        } else {
          alert("서버 오류가 발생했습니다.");
        }
      }
    });
  });

  $('#unlikeBtn').on('click', function () {
    const boardNo = $('#boardNo').val();
    const userId = $('#userId').val();

    $.ajax({
      url: '${pageContext.request.contextPath}/reviewBoard/unlike',
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ userId: userId, boardNo: boardNo }),
      success: function (message) {
        $('#likeModalMessage').text(message);
        $('#likeModal').modal('show');
        setTimeout(() => location.reload(), 1000);
      },
      error: function (xhr) {
        const msg = xhr.status === 400 ? xhr.responseText : "에러 발생";
        $('#likeModalMessage').text(msg);
        $('#likeModal').modal('show');
      }
    });
  });
});


$(document).ready(function () {
	  $(".delete-btn").click(function () {
	    const boardNo = $(this).data("boardno");

	    if (confirm("정말 삭제하시겠습니까?")) {
	      $.ajax({
	        url: "${pageContext.request.contextPath}/reviewBoard/delete", // 컨텍스트 반영
	        type: "POST",
	        data: { boardNo: boardNo },
	        success: function (res) {
	          alert(res.message);
	          if (res.success) {
	            // 삭제 후 목록으로 이동
	            window.location.href = "${pageContext.request.contextPath}/reviewBoard/allBoard";
	          }
	        },
	        error: function (xhr, status, error) {
	          console.error("삭제 실패:", error);
	          alert("삭제 중 오류가 발생했습니다.");
	        }
	      });
	    }
	  });
	});
</script>
</body>
</html>
