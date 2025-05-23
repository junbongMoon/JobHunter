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
<script src="/resources/assets/js/publicModal.js"></script>
<link href="/resources/assets/css/publicModal.css" rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

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
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
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

/* 댓글 전체 영역을 감싸는 컨테이너 */
#replySection {
	width: 1300px;
	margin: 40px auto;
}

#replyContent {
	width: 100%;
	max-width: 100%;
	margin-top: 20px;
	resize: vertical;
}

#submitReplyBtn {
	background-color: #47b2e4;
	color: white;
	border: none;
	padding: 8px 16px;
	font-size: 0.9rem;
	font-weight: 500;
	border-radius: 6px;
	margin-top: 8px;
	transition: background-color 0.2s ease, transform 0.2s ease;
}

#submitReplyBtn:hover {
	background-color: #339fd0;
	transform: translateY(-1px);
}

#replyPagination {
	justify-content: center;
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

.container {
	max-width: 1000px;
	margin: 0 auto;
	padding: 0 20px;
}

.report-modal-body select, .report-modal-body textarea {
	font-size: 15px;
	padding: 10px;
	width: 100%;
	border-radius: 6px;
}

.report-modal-body textarea {
	width: 200px;
	resize: none;
	height: 300px;
}

.report-modal-body h2 {
	font-size: 22px;
	margin-bottom: 12px;
}

.reply-left {
	flex: 1;
}

/* 오른쪽: 좋아요 버튼, 좋아요 수 */
.reply-right {
	display: flex;
	flex-direction: column;
	align-items: flex-end;
	justify-content: flex-end;
	min-width: 60px;
}

.reply-like-section {
	text-align: center;
}

.btn-group-wrapper {
  display: flex;
  gap: 8px; /* 버튼 사이 간격 */
  flex-wrap: wrap; /* 줄 넘김 허용 */
  align-items: center;
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
				<c:if test="${detail.closed}">
					<span class="badge bg-danger">[공고마감]</span>
				</c:if>
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
					<td>${detail.userId}<i class="flagAccBtn" data-uid="${detail.writerUid}" data-type="user"></i></td>
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
			
		</table>

		<!-- 좋아요 버튼 -->
<div class="btn-group-wrapper">
		<c:if test="${!isCompanyAccount}">
			<button id="likeBtn" class="btn btn-outline-primary btn-common-shape">👍
				좋아요</button>
			<button id="unlikeBtn"
				class="btn btn-outline-danger btn-common-shape"
				style="display: none;">❌ 취소</button>
		</c:if>

		<c:if
			test="${not empty sessionScope.account 
		    and sessionScope.account.accountType ne 'COMPANY'
		    and sessionScope.account.uid eq detail.writerUid}">
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

		<!-- 신고버튼 -->
		<c:if test="${loginUserId ne detail.userId and not isCompanyAccount}">
			<div class="report-btn-wrapper">
				<button id="reportBtn" type="button" class="btn btn-sm btn-danger"
					data-bs-toggle="modal" data-bs-target="#reportModal">🚨 신고</button>
			</div>
		</c:if>
		</div>
	</div>


<div id="replySection">
	<!-- 로그인 사용자 UID -->
	<c:if test="${not empty sessionScope.account}">
			<input type="hidden" id="loginUserUid"
		value="${sessionScope.account.uid}">
	</c:if>

	<!-- 댓글 목록 출력 -->
	<ul id="replyList" class="list-group"></ul>

	<!-- 댓글 입력 영역 (회사 계정 제외) -->
	<c:if test="${not isCompanyAccount}">
		<div class="mt-4">
			<textarea id="replyContent" class="form-control" rows="3" placeholder="댓글을 입력해주세요"></textarea>
			<button id="submitReplyBtn" class="btn btn-primary mt-2">등록</button>
		</div>
	</c:if>
</div>

		<!-- 댓글 페이징 부분 -->
		<nav>
			<ul class="pagination justify-content-center mt-3"
				id="replyPagination"></ul>
		</nav>
	</div>


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
	
	<!-- 공용 모달 -->
<div class="modal fade" id="resultModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 id="resultModalTitle" class="modal-title">확인</h5>
      </div>
      <div class="modal-body">
        <p id="resultModalMessage">정말 삭제하시겠습니까?</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-danger" id="modalConfirmBtn">확인</button>
      </div>
    </div>
  </div>
</div>
	<input type="hidden" id="userId" value="${sessionScope.account.uid}" />
	<input type="hidden" id="isLiked" value="${isLiked}" />
	<input type="hidden" id="isCompanyAccount" value="${isCompanyAccount}" />
	<input type="hidden" id="loginUserUid"
		value="${sessionScope.account.uid}">
	<input type="hidden" id="boardNo" value="${detail.boardNo}" />
	<input type="hidden" id="loginUserId" value="${loginUser.userId}" />
	<input type="hidden" id="postWriterUid" value="${detail.writerUid}">





</body>



<script>
function showModal(title, message, callback) {
	  $('#resultModalTitle').text(title);
	  $('#resultModalMessage').text(message);

	  // 이전 이벤트 제거
	  $('#modalConfirmBtn').off('click');

	  if (callback) {
	    $('#modalConfirmBtn').on('click', function () {
	      $('#resultModal').modal('hide');
	      callback(); 
	    });
	  }

	  $('#resultModal').modal('show');
	}

$(document).ready(function () {
      
	$(".delete-btn").click(function () {
        let boardNo = $(this).data("boardno");

        showModal("⚠️ 확인", "정말 삭제하시겠습니까?", function () {
            $.ajax({
                url: "${pageContext.request.contextPath}/reviewBoard/delete",
                type: "POST",
                data: {
                    boardNo: boardNo
                },
                success: function (res) {
                	if (res.success) {
                	    showModal("삭제 완료", res.message, function () {
                	        window.location.href = "${pageContext.request.contextPath}/reviewBoard/allBoard";
                	    });
                	} else {
                	    showModal("⚠️ 삭제 실패", res.message);
                	}
                },
                error: function (xhr) {
                    console.error("삭제 실패:", xhr.responseText);
                    showModal("❌ 서버 오류", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
                }
            });
        });
    });
      
	 const likeModalElement = document.getElementById('likeModal');
	 const likeModal = new bootstrap.Modal(likeModalElement);
      
	 const isCompanyAccount = $('#isCompanyAccount').val() === 'true'; 
     const isLiked = $('#isLiked').val() === 'true'; // 좋아요 여부
      
      // 회사 계정이면 버튼을 숨기거나 비활성화
    if (isCompanyAccount) {
        $('#likeBtn').hide();
        $('#unlikeBtn').hide();
        return; // 회사 계정이면 이후 코드 실행 안 함
    }

    // 회사 계정이 아니면 좋아요 상태에 따라 버튼 토글
    if (isLiked) {
        $('#likeBtn').hide();
        $('#unlikeBtn').show();
    } else {
        $('#likeBtn').show();
        $('#unlikeBtn').hide();
    }

    // 좋아요 등록
    $('#likeBtn').click(function() {
        let currentLikes = parseInt($('#likeCountNum').text()) || 0;
        $('#likeCountNum').text(currentLikes + 1);
        $('#likeBtn').hide();
        $('#unlikeBtn').show();

        $('#likeModalMessage').text('좋아요가 추가되었습니다!');
        likeModal.show();

        $.ajax({
            url: '/reviewBoard/like',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                boardNo: parseInt(boardNo)
            }),
            error: function() {
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

        $('#likeModalMessage').text('좋아요가 취소되었습니다.');
        likeModal.show();

        $.ajax({
            url: '/reviewBoard/unlike',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                boardNo: parseInt(boardNo)
            }),
            error: function() {
                $('#likeCountNum').text(currentLikes);
                $('#unlikeBtn').show();
                $('#likeBtn').hide();
                $('#likeModalMessage').text("좋아요 취소 중 오류가 발생했습니다.");
                likeModal.show();
            }
        });
    });
		
		  const loginUserUid = parseInt($('#loginUserUid').val());    // 로그인한 사용자 UID
		  const boardNo = parseInt($('#boardNo').val());
		  const writerId = parseInt($('#postWriterUid').val(), 10);
		  const reportTargetPK = parseInt($('#boardNo').val(), 10)
		  
		  console.log("writerId:", writerId);
		  console.log("reportTargetPK:", reportTargetPK);

		  // 고유 키 생성: 신고자_uid_피신고자_uid_게시글번호
		  const reportKey = `report_${loginUserUid}_${writerId}_${boardNo}`;
		
		  $('#reportBtn').on('click', function () {
		    // 본인 글 신고 방지
		    if (loginUserUid === writerId) {
		      window.publicModals.show("본인의 게시물은 신고할 수 없습니다.");
		      return;
		    }
		
		    const isCompanyAccount = $('#isCompanyAccount').val() === 'true'; 
		    if (isCompanyAccount) {
		      $('#reportBtn').hide();
		    }
		    // 중복 신고 방지
		
		
		    // 모달 내용 구성
		    const content = `
		      <div class="report-modal-body">  
		        <h5>신고하기</h5>
		        <select id="reportReason" class="form-select mb-2">
		          <option value="">-- 신고 사유 선택 --</option>
		          <option value="SPAM">스팸/광고성 메시지</option>
		          <option value="HARASSMENT">욕설/괴롭힘</option>
		          <option value="FALSE_INFO">허위 정보</option>
		          <option value="ILLEGAL_ACTIVITY">불법 행위</option>
		          <option value="INAPPROPRIATE_CONTENT">부적절한 프로필/사진</option>
		          <option value="MISCONDUCT">부적절한 행동/요구</option>
		          <option value="ETC">기타 사유</option>
		        </select>
		        <textarea id="reportMessage" rows="4" placeholder="자세한 내용을 입력해주세요" class="form-control mb-2"></textarea>
		      </div>
		    `;
		
		    // 모달 출력
		    window.publicModals.show(content, {
		      confirmText: "제출",
		      cancelText: "취소",
		      size_x: "700px",
		      size_y: "550px",
		      onConfirm: function () {
		        const reportCategory = $('#reportReason').val();
		        const reportMessage = $('#reportMessage').val();
				
		        if (!reportCategory) {
		          window.publicModals.show("신고 사유를 선택해주세요.");
		          return false; // false → 모달 유지
		        }
		
		        const reportData = {
		          boardNo:boardNo,
		          targetAccountUid: writerId,
		          reportTargetPK: reportTargetPK,
		          targetAccountType: "USER",
		          reporterAccountUid: loginUserUid,
		          reportCategory: reportCategory,
		          reportMessage: reportMessage,
		          reportType: "BOARD",
		          reportTargetURL: `/reviewBoard/detail?boardNo=\${boardNo}`
		        };
		
		        // AJAX로 신고 전송
		        $.ajax({
		          type: 'POST',
		          url: '/report/board',
		          contentType: 'application/json',
		          data: JSON.stringify(reportData),
		          success: function () {
		        	  console.log('${detail.userId}');
		        	  
		        	  console.log($('#postWriterUid').val());
		        	  // 신고 성공 시 localStorage에 기록 저장
		            localStorage.setItem(reportKey, 'true');
		            window.publicModals.show("신고가 접수되었습니다.");
		          },
		          error: function (xhr) {
		            window.publicModals.show("신고 처리 중 오류가 발생했습니다: " + xhr.responseText);
		          }
		        });
		      }
		    });
		  });
		});




				
	//댓글 등록 

const boardNo = parseInt($('#boardNo').val());
const loginUserUid = $('#userId').val();
const isCompanyAccount = $('#isCompanyAccount').val() === 'true'; 
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
      console.log("서버 응답:", response);

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
		    const isReplyLike = reply.replyLike === true || reply.replyLike === 'true' || reply.replyLike === 1;

		   
		    console.log("댓글번호:", replyNo, "| isReplyLike 값:", reply.replyLike, "| 타입:", typeof reply.replyLike);

		    
		    let replyHtml = '<li class="list-group-item d-flex justify-content-between align-items-start">';
			
		    replyHtml += '<div class="reply-left" style="flex: 1;">';
		    replyHtml += '<strong>' + writer + `<i class="flagAccBtn" data-uid="\${reply.uid}" data-type="user"></i>` + '</strong> (' + date + ')<br>';
		    replyHtml += '<div class="reply-content mt-2 mb-2">' + reply.content + '</div>';

		    if ((reply.userId.toString() === loginUserUid.toString()) && (isCompanyAccount === false || isCompanyAccount === 'false')) {
		        replyHtml += '<div class="reply-actions mt-2">';
		        replyHtml += '<button class="btn btn-sm btn-outline-secondary me-1 edit-reply-btn" ' +
		                     'data-replyno="' + replyNo + '" data-content="' + replyContent + '">수정</button>';
		        replyHtml += '<button class="btn btn-sm btn-outline-danger delete-reply-btn" ' +
		                     'data-replyno="' + replyNo + '">삭제</button>';
		        replyHtml += '</div>';
		    }

		    replyHtml += '</div>';

		    if (isCompanyAccount === false || isCompanyAccount === 'false') {
		        replyHtml += '<div class="reply-right text-end ms-3" style="min-width: 80px;">';
		        replyHtml += '<div class="reply-like-section" data-replyno="' + replyNo + '">' +
		            '<button class="btn btn-outline-primary btn-sm like-reply-btn"' + (isReplyLike ? ' style="display:none;"' : '') + '>👍</button>' +
		            '<button class="btn btn-outline-danger btn-sm unlike-reply-btn"' + (isReplyLike ? '' : ' style="display:none;"') + '>❌</button>' +
		            '<br><span class="like-count small">' + (reply.likes ?? 0) + '</span>' +
		            '</div>';
		        replyHtml += '</div>';
		    }

		    replyHtml += '</li>';
		    $replyList.append(replyHtml);
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
      bindReplyLikeEvents(); 
	  setReportBtn()
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
          userId: loginUserUid,
          content: content
        }),
        success: function () {
          $('#replyContent').val('');
          loadReplies(1); // 첫 페이지로 갱신
        },
        error: function (xhr, status, error) {
          console.log("xhr.status:", xhr.status);
          console.log("error:", error);

          if (xhr.status === 401) {
            alert('로그인이 필요합니다.');
            setTimeout(function () {
              window.location.href = '/account/login';
            }, 300);
          } else {
            alert('댓글 등록 중 오류가 발생했습니다.');
          }
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
        type: 'DELETE',
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
    const $li = $(this).closest('li');
    const replyNo = $(this).data('replyno');
    const $replyContentDiv = $li.find('.reply-content');

    // 이미 수정모드면 저장 로직 실행
    if ($li.find('.edit-reply-textarea').length > 0) {
        const newContent = $li.find('.edit-reply-textarea').val().trim();

        if (!newContent) {
            alert("수정할 내용을 입력해주세요.");
            return;
        }

        // AJAX 수정 요청
        $.ajax({
            url: '/reply/update',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                replyNo: replyNo,
                content: newContent,
                userId: parseInt($('#userId').val()),  // 로그인 UID
                boardNo: parseInt($('#boardNo').val())
            }),
            success: function () {
                alert('댓글이 수정되었습니다.');
                loadReplies(); // 새로 고침
            },
            error: function () {
                alert('댓글 수정 중 오류가 발생했습니다.');
            }
        });

    } else {
        // 수정 textarea 폼이 없으면 → 생성
        $('.edit-reply-form').remove(); // 다른 폼 제거
        const originalContent = $(this).data('content') ?? $replyContentDiv.text().trim();
        const editForm = `
            <div class="edit-reply-form mt-2">
                <textarea class="form-control edit-reply-textarea" rows="3">${originalContent}</textarea>
            </div>
        `;
        $replyContentDiv.after(editForm);
        $li.find('.edit-reply-textarea').focus();
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
		
		
function bindReplyLikeEvents() {
	  // 중복 방지 위해 기존 이벤트 제거 후 재바인딩
	  $(document).off('click', '.like-reply-btn');
	  $(document).off('click', '.unlike-reply-btn');

	  $(document).on('click', '.like-reply-btn', function () {
	    const wrapper = $(this).closest('.reply-like-section');
	    const replyNo = parseInt(wrapper.data('replyno'));
	    const likeCountSpan = wrapper.find('.like-count');
	    let currentCount = parseInt(likeCountSpan.text());

	    if (isNaN(replyNo)) {
	      window.publicModals.show("댓글 번호가 유효하지 않습니다.");
	      return;
	    }

	    $.ajax({
	      url: '/reply/like',
	      type: 'POST',
	      contentType: 'application/json',
	      data: JSON.stringify({ replyNo: replyNo }),
	      success: function () {
	        likeCountSpan.text(currentCount + 1);
	        wrapper.find('.like-reply-btn').hide();
	        wrapper.find('.unlike-reply-btn').show();
	        window.publicModals.show("좋아요가 추가되었습니다.");
	      },
	      error: function (xhr) {
	        console.error("좋아요 실패:", xhr.responseText);
	        window.publicModals.show("좋아요 실패: " + xhr.responseText);
	      }
	    });
	  });

	  $(document).on('click', '.unlike-reply-btn', function () {
	    const wrapper = $(this).closest('.reply-like-section');
	    const replyNo = parseInt(wrapper.data('replyno'));
	    const likeCountSpan = wrapper.find('.like-count');
	    let currentCount = parseInt(likeCountSpan.text());

	    if (isNaN(replyNo)) {
	      window.publicModals.show("댓글 번호가 유효하지 않습니다.");
	      return;
	    }

	    $.ajax({
	      url: '/reply/unlike',
	      type: 'POST',
	      contentType: 'application/json',
	      data: JSON.stringify({ replyNo: replyNo }),
	      success: function () {
	        likeCountSpan.text(Math.max(currentCount - 1, 0));
	        wrapper.find('.unlike-reply-btn').hide();
	        wrapper.find('.like-reply-btn').show();
	        window.publicModals.show("좋아요가 취소되었습니다.");
	      },
	      error: function (xhr) {
	        console.error("좋아요 취소 실패:", xhr.responseText);
	        window.publicModals.show("좋아요 취소 실패: " + xhr.responseText);
	      }
	    });
	  });
	}





</script>
</html>
