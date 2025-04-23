<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
	background-color: #47b2e4;
	color: #ffffff;
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

#likeCountText {
	display: inline !important;
	visibility: visible !important;
	color: inherit !important;
}

#reportCategory {
	color: #000 !important;
}

#reportCategory option {
	color: #000 !important;
}

.list-group-item {
	color: black !important;
	font-size: 16px !important;
	background-color: #fdfdfd !important;
	display: block !important;
}

#replyList {
	padding-left: 0;
}

#replyList .list-group-item {
	background-color: #ffffff;
	border: 1px solid #ddd;
	border-radius: 10px;
	margin-bottom: 15px;
	padding: 15px 20px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
	position: relative;
}

#replyList .list-group-item strong {
	font-weight: 600;
	color: #0056b3;
}

#replyList .list-group-item small {
	color: #999;
	font-size: 13px;
	margin-left: 5px;
}

#replyList .reply-content {
	margin-top: 8px;
	margin-bottom: 10px;
	white-space: pre-line;
	line-height: 1.5;
	padding: 10px;
	background-color: #f9f9f9;
	border-left: 4px solid #47b2e4;
	border-radius: 6px;
}

#replyList .edit-reply-btn, #replyList .delete-reply-btn {
	font-size: 13px;
	padding: 4px 10px;
	border-radius: 20px;
	margin-right: 6px;
}

#replyList .edit-reply-btn {
	background-color: #e8f4fc;
	color: #007bff;
	border: 1px solid #cce5ff;
}

#replyList .delete-reply-btn {
	background-color: #fce8e8;
	color: #dc3545;
	border: 1px solid #f5c6cb;
}

@media screen and (max-width: 576px) {
	#replyList .reply-content {
		font-size: 14px;
	}
	#replyList .edit-reply-btn, #replyList .delete-reply-btn {
		font-size: 12px;
		padding: 3px 8px;
	}
}

.btn-common-shape {
	border: none;
	padding: 8px 16px;
	font-size: 0.9rem;
	font-weight: 500;
	border-radius: 6px;
	text-decoration: none;
	display: inline-block;
	transition: background-color 0.2s ease, transform 0.2s ease;
}

.btn-common-shape:hover {
	transform: translateY(-1px);
	text-decoration: none;
}

.btn-common-shape:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(71, 178, 228, 0.4);
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
					<td><span id="likeCount">👁️ ${detail.views}회</span></td>
				</tr>
				<tr>
					<th>후기 내용</th>
					<td class="review-content">${detail.content}</td>
				</tr>
			</tbody>



			<!-- 버튼 영역 -->
			<!-- 추천 영역 -->
			<tr>
				<th>추천 수</th>
				<td><span id="likeCountText"> <span id="likeCountNum">${detail.likes != null ? detail.likes : 0}</span>명
				</span></td>
			</tr>
			<!-- 추천 버튼 -->
		</table>

		<!-- 좋아요 버튼 -->

		<button id="likeBtn" class="btn btn-outline-primary btn-common-shape">👍
			좋아요</button>
		<button id="unlikeBtn" class="btn btn-outline-danger btn-common-shape"
			style="display: none;">❌ 취소</button>


		<!-- 수정 버튼 -->
		<c:if test="${sessionScope.account.uid eq detail.writerUid}">
			<!-- 수정 버튼 -->
			<a
				href="${pageContext.request.contextPath}/reviewBoard/modify?boardNo=${detail.boardNo}"
				class="btn-getstarted btn-sm btn-common-shape">✏️ 수정</a>

			<!-- 삭제 버튼 -->
			<form action="${pageContext.request.contextPath}/reviewBoard/delete"
				method="post" style="display: inline;">
				<input type="hidden" name="boardNo" value="${detail.boardNo}" />
				<button type="button"
					class="btn-getstarted btn-sm delete-btn btn-common-shape"
					data-boardno="${detail.boardNo}">🗑 삭제</button>
					
			</form>
		</c:if>

		<!-- 목록으로 -->
		<a
			href="/reviewBoard/allBoard?page=${pageRequestDTO.page}&searchType=${pageRequestDTO.searchType}&keyword=${pageRequestDTO.keyword}"
			class="btn btn-secondary btn-sm btn-rounded">목록으로 돌아가기</a>

		<c:if test="${loginUserId ne detail.userId}">
			<!-- 본인 게시물이 아닌 경우만 신고 버튼 출력 -->
			<button type="button" class="btn btn-sm btn-danger"
				data-bs-toggle="modal" data-bs-target="#reportModal">🚨 신고</button>
		</c:if>
	</div>

		<p>writerUid: ${detail.writerUid}</p>
<p>session UID: ${sessionScope.account.uid}</p>

	<input type="hidden" id="userId" value="${sessionScope.account.uid}" />
	<input type="hidden" id="isLiked" value="${isLiked}" />


	<!-- 댓글 목록 출력 영역 -->
	<ul id="replyList" class="list-group"></ul>

	<!--  댓글 작성 영역 추가 -->
	<div class="mt-4">
		<textarea id="replyContent" class="form-control" rows="3"
			placeholder="댓글을 입력해주세요"></textarea>
		<button id="submitReplyBtn" class="btn btn-primary mt-2">등록</button>
	</div>

	<!-- 댓글 페이징 부분 -->
	<nav>
		<ul class="pagination justify-content-center mt-3"
			id="replyPagination"></ul>
	</nav>

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

	<!-- 신고 버튼 모달  -->
	<div class="modal fade" id="reportModal" tabindex="-1"
		aria-labelledby="reportModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">

				<div class="modal-header">
					<h5 class="modal-title" id="reportModalLabel">신고하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>

				<div class="modal-body">

					<input type="hidden" id="loginUserUid" value="${loginUser.uid}">

					<label for="reportCategory" class="form-label">신고 사유</label> <select
						name="reportCategory" id="reportCategory" class="form-select"
						required>
						<option value="" disabled selected>-- 신고 사유 선택 --</option>
						<option value="SPAM">스팸/광고성 메시지</option>
						<option value="HARASSMENT">욕설/괴롭힘</option>
						<option value="FALSE_INFO">허위 정보</option>
						<option value="ILLEGAL_ACTIVITY">불법 행위</option>
						<option value="INAPPROPRIATE_CONTENT">부적절한 프로필/사진</option>
						<option value="MISCONDUCT">부적절한 행동/요구</option>
						<option value="ETC">기타 사유</option>
					</select> <label for="reportMessage" class="form-label mt-3">신고 내용</label>
					<textarea class="form-control" id="reportMessage" rows="4"
						placeholder="자세한 내용을 입력해주세요"></textarea>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
					<button type="button" id="submitReportBtn" class="btn btn-danger">제출</button>
				</div>

			</div>
		</div>
	</div>
	<input type="hidden" id="loginUserUid"
		value="${sessionScope.account.uid}">
	<input type="hidden" id="boardNo" value="${detail.boardNo}" />
	<input type="hidden" id="postWriterUid" value="${detail.userId}">
	<input type="hidden" id="loginUserId" value="${loginUser.userId}" />
</body>
<script>

	$(document).ready(function() {
		const isLiked = $('#isLiked').val() === 'true';

		if (isLiked) {
			$('#likeBtn').hide();
			$('#unlikeBtn').show();
		} else {
			$('#likeBtn').show();
			$('#unlikeBtn').hide();
		}
	});

	// 좋아요 등록
	$('#likeBtn').click(function() {
		let currentLikes = parseInt($('#likeCountNum').text()) || 0;
		$('#likeCountNum').text(currentLikes + 1);
		$('#likeBtn').hide();
		$('#unlikeBtn').show();

		$('#likeModalMessage').text("좋아요가 등록되었습니다!");
		likeModal.show();

		$.ajax({
			url : '/reviewBoard/like',
			type : 'POST',
			contentType : 'application/json',
			data : JSON.stringify({
				userId : userId,
				boardNo : boardNo
			}),
			error : function() {
				$('#likeCountNum').text(currentLikes);
				$('#likeBtn').show();
				$('#unlikeBtn').hide();
				$('#likeModalMessage').text("좋아요 등록 중 오류가 발생했습니다.");
				likeModal.show();
			}
		});
	});

	// 좋아요 취소
	$('#unlikeBtn').click(function() {
		let currentLikes = parseInt($('#likeCountNum').text()) || 0;
		$('#likeCountNum').text(currentLikes - 1);
		$('#unlikeBtn').hide();
		$('#likeBtn').show();

		$('#likeModalMessage').text("좋아요가 취소되었습니다.");
		likeModal.show();

		$.ajax({
			url : '/reviewBoard/unlike',
			type : 'POST',
			contentType : 'application/json',
			data : JSON.stringify({
				userId : userId,
				boardNo : boardNo
			}),
			error : function() {
				$('#likeCountNum').text(currentLikes);
				$('#unlikeBtn').show();
				$('#likeBtn').hide();
				$('#likeModalMessage').text("좋아요 취소 중 오류가 발생했습니다.");
				likeModal.show();
			}
		});
	});

	//게시물삭제 
	$(document).ready(function () {
  		$(".delete-btn").click(function () {
    		let boardNo = $(this).data("boardno");

			    if (confirm("정말 삭제하시겠습니까?")) {
			      $.ajax({
			        url: "${pageContext.request.contextPath}/reviewBoard/delete",
			        type: "POST",
			        data: {
			          boardNo: boardNo
			        },
			        success: function (res) {
			          alert(res.message);
			          if (res.success) {
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


	//게시물 신고	  
		$(document).ready(function() {
			$('#submitReportBtn').on('click', function() {
				const loginUserUid = parseInt($('#loginUserUid').val());    // 로그인한 사용자 UID
			    const writerId = parseInt($('#postWriterUid').val());      // 게시글 작성자 UID
			    const reportCategory = $('#reportCategory').val();
			    const reportMessage = $('#reportMessage').val();
			    const boardNo = parseInt($('#boardNo').val());

					// 본인 게시글 신고 방지
					if (loginUserId === writerId) {
					    alert("본인의 게시물은 신고할 수 없습니다.");
					    return;
					}
					if (!reportCategory) {
						alert("신고 사유를 선택해주세요.");
						return;
					}
		const reportData = {
				boardNo: parseInt(boardNo),
	            reporterAccountUid: parseInt(reporterAccountUid),
	            reportCategory: reportCategory,
	            reportMessage: reportMessage,
	            reportType: "BOARD",
	            reportTargetURL: `/reviewBoard/detail?boardNo=${boardNo}`
		};
		$.ajax({
			type: 'POST',
			url: '/report/board',
			contentType: 'application/json',
			data: JSON.stringify(reportData),
			success: function() {
				alert('신고가 접수되었습니다.');
				$('#reportModal').modal('hide');
			},
			error: function(xhr) {
				alert('신고 처리 중 오류가 발생했습니다: ' + xhr.responseText);
			}
		});
	});
});


	//댓글 등록 

const boardNo = parseInt($('#boardNo').val());
const loginUserUid = $('#userId').val();

function loadReplies(page = 1) {
  $.ajax({
    url: '/reply/page',
    type: 'GET',
    data: {
      boardNo: boardNo,
      page: page,
      size: 5
    },
    success: function (response) {
      console.log("👀 서버 응답:", response);

      const replies = response.boardList;
      const totalPages = response.totalPage ?? Math.ceil(response.totalCount / response.size);
      const currentPage = response.page;

      const $replyList = $('#replyList');
      const $pagination = $('#replyPagination');
      $replyList.empty();
      $pagination.empty();

      // 댓글 출력
      if (!replies || replies.length === 0) {
        $replyList.append('<li class="list-group-item text-muted">등록된 댓글이 없습니다.</li>');
      } else {
        replies.forEach(reply => {
          const replyNo = reply.replyNo;
          const replyContent = (reply.content ?? '').replace(/"/g, '&quot;');
          const date = (reply.postDate ?? '').substring(0, 10);
          const writer = reply.writerId ?? '익명';

          const html = '<li class="list-group-item">' +
            '<strong>' + writer + '</strong> (' + date + ')<br>' +
            '<div class="reply-content">' + reply.content + '</div>' +
            (reply.userId.toString() === loginUserUid.toString()
              ? '<button class="btn btn-sm btn-outline-secondary me-1 edit-reply-btn" data-replyno="' + replyNo + '" data-content="' + replyContent + '">수정</button>' +
                '<button class="btn btn-sm btn-outline-danger delete-reply-btn" data-replyno="' + replyNo + '">삭제</button>'
              : '') +
            '</li>';
          $replyList.append(html);
        });
      }

      // 페이징 출력
      if (response.totalPage > 1) {
        // 이전
        if (response.hasPrev) {
          $pagination.append(`
            <li class="page-item">
              <a class="page-link" href="#" data-page="${response.startPage - 1}">&laquo;</a>
            </li>
          `);
        }

        // 숫자 버튼
        for (let i = response.startPage; i <= response.endPage; i++) {
          const isActive = (i === response.page) ? 'active' : '';
          console.log("📌 페이지 생성 i =", i); 
          $pagination.append('<li class="page-item ' + isActive + '"><a class="page-link" href="#" data-page="' + i + '">' + i + '</a></li>');
        }

        // 다음
        if (response.hasNext) {
          $pagination.append(`
            <li class="page-item">
              <a class="page-link" href="#" data-page="${response.endPage + 1}">&raquo;</a>
            </li>
          `);
        }
      }
    },
    error: function () {
      alert('댓글 로딩 중 오류 발생');
    }
  });
}

$(document).ready(function () {
  // 초기 로딩
  loadReplies(1);

  // 댓글 등록
  $('#submitReplyBtn').click(function () {
    const content = $('#replyContent').val().trim();
    if (!content) {
      alert('댓글 내용을 입력해주세요.');
      return;
    }

    $.ajax({
      url: '/reply/add',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({
        boardNo: boardNo,
        content: content
      }),
      success: function () {
        $('#replyContent').val('');
        loadReplies(1); // 첫 페이지로 갱신
      },
      error: function () {
        alert('댓글 등록 중 오류가 발생했습니다.');
      }
    });
  });

  // 댓글 삭제
  $(document).on('click', '.delete-reply-btn', function () {
    const replyNo = $(this).data('replyno');
    if (isNaN(replyNo)) {
      alert("댓글 번호가 유효하지 않습니다.");
      return;
    }

    if (confirm('댓글을 삭제하시겠습니까?')) {
      $.ajax({
        url: '/reply/delete',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ replyNo: replyNo }),
        success: function () {
          alert('댓글이 삭제되었습니다.');
          loadReplies(); // 현재 페이지 유지
        },
        error: function () {
          alert('댓글 삭제 중 오류가 발생했습니다.');
        }
      });
    }
  });

  // 댓글 수정
  $(document).on('click', '.edit-reply-btn', function () {
    const replyNo = $(this).data('replyno');
    const currentContent = $(this).data('content');

    if (isNaN(replyNo)) {
      alert("댓글 번호가 유효하지 않습니다.");
      return;
    }

    const newContent = prompt('댓글을 수정하세요:', currentContent);
    if (newContent !== null && newContent.trim() !== '') {
      $.ajax({
        url: '/reply/update',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
          replyNo: parseInt(replyNo),
          userId: parseInt(loginUserUid),
          content: newContent.trim()
        }),
        success: function () {
          alert('댓글이 수정되었습니다.');
          loadReplies(); // 현재 페이지 유지
        },
        error: function () {
          alert('댓글 수정 중 오류가 발생했습니다.');
        }
      });
    }
  });

		  // 페이지 클릭 이벤트 위임 (중복 방지)
		  $(document).on('click', '#replyPagination a', function (e) {
		    e.preventDefault();
		    const selectedPage = $(this).data('page');
		    console.log("👉 선택된 페이지:", selectedPage);
		    if (!selectedPage || isNaN(selectedPage)) {
		      alert("유효하지 않은 페이지입니다.");
		      return;
		    }
		    loadReplies(parseInt(selectedPage));
		  });
		});

</script>
</html>
