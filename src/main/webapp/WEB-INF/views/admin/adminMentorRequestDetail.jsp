<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>멘토 권한 신청 상세 - 관리자 페이지</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<!-- Font Awesome -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
	rel="stylesheet" />
<!-- SB Admin 2 CSS -->
<link href="/resources/adminpagematerials/css/sb-admin-2.css" rel="stylesheet" />

<style>
/* 최소한의 커스텀 스타일만 추가 */
.mentor-content {
    background-color: #f8f9fc;
    border: 1px solid #e3e6f0;
    border-radius: 0.35rem;
    padding: 1.25rem;
    margin-bottom: 1.5rem;
    white-space: pre-wrap;
}

.reject-message {
    background-color: #f8d7da;
    border: 1px solid #f5c6cb;
    border-radius: 0.35rem;
    padding: 1.25rem;
    margin-bottom: 1.5rem;
    color: #721c24;
}

.file-section {
    margin-bottom: 1.5rem;
}

.file-toggle-btn {
    background-color: #4e73df;
    color: white;
    border: none;
    border-radius: 0.35rem;
    padding: 0.5rem 1rem;
    cursor: pointer;
    transition: all 0.3s;
}

.file-toggle-btn:hover {
    background-color: #2e59d9;
}

.file-card {
    background-color: #f8f9fc;
    border: 1px solid #e3e6f0;
    border-radius: 0.35rem;
    padding: 1rem;
    margin-bottom: 1rem;
    cursor: pointer;
    transition: all 0.3s;
}

.file-card:hover {
    box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
}

.file-thumbnail {
    margin-top: 1rem;
    text-align: center;
}

.file-thumbnail img {
    max-width: 200px;
    border-radius: 0.35rem;
    border: 1px solid #e3e6f0;
}

.date-info {
    text-align: right;
    color: #858796;
    font-size: 0.85rem;
}

/* 자격증 진위확인 버튼 스타일 */
.qnet-btn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    background-color: #4e73df;
    color: white;
    border: none;
    border-radius: 0.35rem;
    padding: 0.75rem 1.5rem;
    font-weight: 600;
    box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
    z-index: 1000;
    transition: all 0.3s;
}

.qnet-btn:hover {
    background-color: #2e59d9;
    transform: translateY(-3px);
    box-shadow: 0 0.5rem 2rem 0 rgba(58, 59, 69, 0.25);
}
</style>
</head>

<body id="page-top">
	<!-- 헤더 포함 (네비게이션바 + 사이드바 포함) -->
	<jsp:include page="adminheader.jsp"></jsp:include>

	<!-- 본문 내용 -->
	<div class="container-fluid">
		<h1 class="h3 mb-4 text-gray-800">멘토 권한 신청 상세</h1>
		
		<!-- 상세 정보 카드 -->
		<div class="card shadow mb-4">
			<div class="card-header py-3">
				<h6 class="m-0 font-weight-bold text-primary">신청 정보</h6>
			</div>
			<div class="card-body">
				<div class="mentor-request-detail">
					<h2 class="h2 mb-3">${item.title}</h2>
					<div class="row mb-3">
						<div class="col-md-6">
							<p><strong>작성자:</strong> ${item.writer}</p>
						</div>
						<div class="col-md-6">
							<p class="date-info"><strong>작성일:</strong> <span class="formatted-date" data-date="${item.postDate}">${item.postDate}</span></p>
						</div>
					</div>
					<p><strong>내용:</strong></p>
					<div class="mentor-content">${item.content}</div>
				
					<c:if test="${not empty item.rejectMessage}">
						<div class="reject-message">
							<strong>반려 사유:</strong> ${item.rejectMessage}
						</div>
					</c:if>
				</div>
				
				<!-- 첨부파일 섹션 -->
				<c:if test="${not empty item.upfiles}">
					<div class="file-section">
						<button type="button" onclick="toggleFileList()" class="file-toggle-btn">
							<i class="fas fa-paperclip mr-2"></i> 첨부파일 보기 ▼
						</button>
						<div id="fileList" style="display:none; margin-top: 1rem;">
							<c:forEach var="file" items="${item.upfiles}">
								<div class="file-card" onclick="downloadFile('${file.newFileName}', '${file.originalFileName}')">
									<div class="row">
										<div class="col-md-6">
											<p><strong>파일명:</strong> ${file.originalFileName}</p>
										</div>
										<div class="col-md-6">
											<p><strong>파일 크기:</strong> ${file.size} bytes</p>
										</div>
									</div>
									<c:if test="${not empty file.base64Image}">
										<div class="file-thumbnail">
											<img src="data:${file.fileType};base64,${file.base64Image}" alt="썸네일">
										</div>
									</c:if>
								</div>
							</c:forEach>
						</div>
					</div>
				</c:if>
			</div>
			
			<!-- 상태 표시 -->
			<div class="card shadow mb-4">
				<div class="card-header py-3">
					<h6 class="m-0 font-weight-bold text-primary">처리 상태</h6>
				</div>
				<div class="card-body">
					<div id="mentorRequestStatusArea">
						<c:choose>
							<c:when test="${item.status == 'PASS'}">
								<div class="alert alert-success d-flex justify-content-between align-items-center">
									<div>
										<i class="fas fa-check-circle mr-2"></i> 승인 완료됨
									</div>
									<button type="button" class="btn btn-warning btn-sm" onclick="showActionButtons()">
										<i class="fas fa-edit mr-1"></i> 정정하기
									</button>
								</div>
							</c:when>
							<c:when test="${item.status == 'FAILURE'}">
								<div class="alert alert-danger d-flex justify-content-between align-items-center">
									<div>
										<i class="fas fa-times-circle mr-2"></i> 승인 거절됨
									</div>
									<button type="button" class="btn btn-warning btn-sm" onclick="showActionButtons()">
										<i class="fas fa-edit mr-1"></i> 정정하기
									</button>
								</div>
							</c:when>
							<c:otherwise>
								<!-- CHECKED나 WAITING은 바로 버튼 보여줌 -->
								<div id="actionButtons" class="d-flex justify-content-center">
									<button type="button" class="btn btn-success mr-2" onclick="passMentorRequest('${item.advancementNo}')">
										<i class="fas fa-check mr-1"></i> 승인하기
									</button>
									<button type="button" class="btn btn-danger" onclick="failureMentorRequest('${item.advancementNo}')">
										<i class="fas fa-times mr-1"></i> 거부하기
									</button>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					
					<!-- PASS나 FAILURE일 때는 버튼 숨겨놓음 -->
					<div id="hiddenActionButtons" class="d-flex justify-content-center" style="display: none !important;">
						<button type="button" class="btn btn-success mr-2" onclick="passMentorRequest('${item.advancementNo}')">
							<i class="fas fa-check mr-1"></i> 승인하기
						</button>
						<button type="button" class="btn btn-danger" onclick="failureMentorRequest('${item.advancementNo}')">
							<i class="fas fa-times mr-1"></i> 거부하기
						</button>
					</div>
				</div>
			</div>
			
		</div>
		
		<!-- 뒤로가기 버튼 -->
		<div class="mb-4">
			<a href="/admin/mentorRequestList" class="btn btn-secondary">
				<i class="fas fa-arrow-left"></i> 목록으로 돌아가기
			</a>
		</div>

	</div>

	<!-- 푸터 포함 -->
	<jsp:include page="adminfooter.jsp"></jsp:include>
	
	<!-- 거절 사유 입력 모달 -->
	<div class="modal fade" id="rejectReasonModal" tabindex="-1" aria-labelledby="rejectReasonModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	
	      <!-- 모달 헤더 -->
	      <div class="modal-header">
	        <h5 class="modal-title" id="rejectReasonModalLabel">거부 사유 입력</h5>
	        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	
	      <!-- 모달 바디 -->
	      <div class="modal-body">
	        <div class="form-group">
	          <label for="rejectReasonInput">거부 사유</label>
	          <textarea class="form-control" id="rejectReasonInput" rows="3" placeholder="거부 사유를 입력하세요"></textarea>
	        </div>
	      </div>
	
	      <!-- 모달 푸터 (버튼들) -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	        <button type="button" class="btn btn-danger" onclick="submitRejectReason()">거부 확정</button>
	      </div>
	
	    </div>
	  </div>
	</div>
	
	<!-- 자격증 진위확인 버튼 -->
	<button type="button" onclick="openQnetVerification()" class="qnet-btn">
		<i class="fas fa-certificate mr-2"></i> 자격증 확인하기
	</button>

	<!-- Bootstrap Bundle with Popper -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

	<!-- 페이지 로드 시 실행되는 스크립트 -->
	<script>
	function showActionButtons() {
	    const hiddenButtons = document.getElementById('hiddenActionButtons');
	    if (hiddenButtons) {
	        hiddenButtons.style.display = 'flex';
	        console.log('버튼 표시됨');
	    } else {
	        console.error('hiddenActionButtons 요소를 찾을 수 없습니다.');
	    }
	}
	
	// 멘토 신청 승인
	function passMentorRequest(requestNo) {
	    if (confirm('정말 승인하시겠습니까?')) {
	        location.href = '/mentor/mentorRequest/pass/' + requestNo;
	    }
	}
	
	let selectedRequestNo = null;

	// 거부 버튼 눌렀을 때
	function failureMentorRequest(requestNo) {
	    selectedRequestNo = requestNo;
	    $('#rejectReasonModal').modal('show');
	}

	// 모달 내 "거부 확정" 버튼 눌렀을 때
	function submitRejectReason() {
	    const reason = document.getElementById('rejectReasonInput').value.trim();
	    
	    if (reason === '') {
	        alert('거부 사유를 입력해주세요.');
	        return;
	    }
	    
	    fetch('/mentor/mentorRequest/failure', {
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/json'
	        },
	        body: JSON.stringify({
	            requestNo: selectedRequestNo,
	            rejectMessage: reason
	        })
	    })
	    .then(async (response) => {
	        if (response.ok) {
	            location.href = '/admin/mentorRequestList';
	        } else {
	            const errorText = await response.text();
	            alert('거부 실패: ' + errorText);
	        }
	    })
	    .catch(error => {
	        console.error('Error:', error);
	        alert('서버 통신 오류');
	    });

	    $('#rejectReasonModal').modal('hide');
	}

	
	// 한국 날짜/시간 포맷팅 함수
	function formatKoreanDateTime(dateString) {
		if (!dateString) return "-";
		
		console.log("원본 날짜 문자열:", dateString);
		
		// Java Date 객체의 문자열 형식 (예: "Fri Apr 25 12:49:35 KST 2025")
		// 이 형식을 파싱하여 한국 날짜/시간 형식으로 변환
		try {
			// 날짜 문자열에서 월, 일, 시간, 분, 년도 추출
			const dateParts = dateString.split(' ');
			
			// 월 이름을 숫자로 변환
			const monthMap = {
				'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
				'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
			};
			
			// 날짜 부분이 충분한지 확인
			if (dateParts.length >= 5) {
				const month = monthMap[dateParts[1]] || '01';
				const day = dateParts[2].padStart(2, '0');
				const timeParts = dateParts[3].split(':');
				const hours = timeParts[0].padStart(2, '0');
				const minutes = timeParts[1].padStart(2, '0');
				const year = dateParts[5];
				
				// 한국 날짜/시간 형식으로 반환 (yyyy년 mm월 dd일 n시 nn분)
				return `\${year}년 \${month}월 \${day}일 \${hours}시 \${minutes}분`;
			}
		} catch (error) {
			console.error("날짜 파싱 오류:", error);
		}
		
		// 파싱 실패 시 원본 반환
		return dateString;
	}
	
	// 페이지 로드 시 모든 날짜 포맷팅 적용
	document.addEventListener('DOMContentLoaded', function() {
		console.log("메인 페이지 로드 완료");
		// 모든 formatted-date 클래스를 가진 요소에 포맷팅 적용
		const dateElements = document.querySelectorAll('.formatted-date');
		console.log("dateElements:", dateElements);
		dateElements.forEach(function(element) {
			const dateString = element.getAttribute('data-date');
			console.log("dateString:", dateString);
			element.textContent = formatKoreanDateTime(dateString);
			console.log("element.textContent:", element.textContent);
		});
	});
	
	function toggleFileList() {
	    const fileList = document.getElementById('fileList');
	    const button = document.querySelector('.file-toggle-btn');
	    if (fileList.style.display === 'none') {
	        fileList.style.display = 'block';
	        button.innerHTML = '<i class="fas fa-paperclip mr-2"></i> 첨부파일 숨기기 ▲';
	    } else {
	        fileList.style.display = 'none';
	        button.innerHTML = '<i class="fas fa-paperclip mr-2"></i> 첨부파일 보기 ▼';
	    }
	}

	function downloadFile(newFileName, originalFileName) {
	    const link = document.createElement('a');
	    link.href = newFileName;
	    link.download = originalFileName;
	    link.click();
	}
	
	// 자격증 진위 확인 사이트
	function openQnetVerification() {
	    window.open('https://www.q-net.or.kr/qlf006.do?id=qlf00601&gSite=Q&gId=', '_blank');
	}
    </script>
</body>

</html>