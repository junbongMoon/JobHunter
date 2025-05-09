<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script>
  // 작성자의 pk
  let companyUid = '${sessionScope.account.uid}';
  // 조회된 공고의 pk
  let recruitmentNoticePk = '-1';
  // 조회된 이력서의 pk
  let selectedResumeNo = '-1';
  // 출력한 이력서의 상태
  let registrationStatusByResume;


$(function() {
  console.log("companyUid:", companyUid);
  loadRecruitmentList(1, 10); // 페이지 로딩 시 자동 호출
  

  // 공고 리스트의 값이 바뀌었을 때
  $('#recruitmentnoticeList').on('change', function () {
  const selectedRecruitmentNo = $(this).val();

  clearResumeDetailForm();

  if (selectedRecruitmentNo === '-1') {
    // 이력서 셀렉트 초기화
    $('#resumeList').empty().append(`<option value="-1">이력서를 선택하세요</option>`);
    $('#resumePagination').empty();

    // 상세 공고 정보 영역 초기화
    $('.recruitDetailInfo').html('<p style="text-align:center; color:gray;">공고를 선택하면 상세정보가 표시됩니다.</p>');

    // 이력서 상세 폼 초기화
    clearResumeDetailForm();
    return;
  }

  if (selectedRecruitmentNo !== '-1') {
    loadSubmittedResumes(selectedRecruitmentNo); // 기본 1페이지 호출
    loadRecruitmentDetail();
  } else {
    $('#resumeList').empty().append(`<option value="-1">이력서를 선택하세요</option>`);
  }
});

  // 불합격 버튼이 클릭 되었을 때
  $('#failedBtn').on('click', function (e) {
    e.preventDefault(); // 폼 기본 제출 동작 방지
    changeStatusByregistration('FAILURE', selectedResumeNo, recruitmentNoticePk);
  });

    // 합격 버튼이 클릭 되었을 때
    $('#passedBtn').on('click', function (e) {
    e.preventDefault(); // 폼 기본 제출 동작 방지
    changeStatusByregistration('PASS', selectedResumeNo, recruitmentNoticePk);
  });

  // 이력서 리스트의 값이 바뀌었을 때
  $('#resumeList').on('change', function () {
  selectedResumeNo = parseInt($(this).val());
  const selectedRecruitmentNo = $('#recruitmentnoticeList').val();
  recruitmentNoticePk = selectedRecruitmentNo;

  if (selectedResumeNo === -1) {
    clearResumeDetailForm();
    return;
  }

  if (selectedResumeNo !== -1) {
    // 저장한 데이터 불러오기
    const selectedData = window.latestResumeList?.find(item => item.resumeNo === selectedResumeNo);

    if (selectedData) {
      
      $('#detailTitle').val(selectedData.title);
      $('#detailPayType').val(selectedData.payType);
      $('#detailPay').val(selectedData.pay);
      $('#detailIntroduce').val(selectedData.introduce);
      
      // 배열을 한글로 바꿔서 ,로 연결된 문자열로 만들기
      // ?. 는 Optional Chaining 문법입니다.
      // jobForms가 존재하지 않으면(null이나 undefined) 오류를 내지 않고 undefined 반환!
      const jobForms = selectedData.jobForms?.map(j => translateJobFormCode(j.form)).join(', ') || '';
      $('#detailJobForms').val(jobForms);

      const merits = selectedData.merits?.map(m => m.meritContent).join(', ') || '';
      $('#detailMerits').val(merits);

      const sigunguList = selectedData.sigunguList?.map(s => s.name).join(', ') || '';
      $('#detailSigungu').val(sigunguList);

      const subcategoryList = selectedData.subcategoryList?.map(s => s.jobName).join(', ') || '';
      $('#detailSubcategory').val(subcategoryList);

      $('#detailFileList').empty();
      const files = selectedData.files;

      const registrationStatusByResume = selectedData.registrationVO.status;
      console.log("상태 (enum):", registrationStatusByResume);

      const translatedStatus = translateStatusEnum(registrationStatusByResume);
      $('#registrationStatus').val(translatedStatus);

      if (files && files.length > 0) {
        files.forEach(file => {
          $('#detailFileList').append(
            `<a href="\${file.newFileName}" 
												 download="\${file.originalFileName}"
												 class="badge-custom attachment-badge"
												 title="Download">
												 <i class="fa-solid fa-download"></i> \${file.originalFileName}
											  </a>`
          );
        });
      } else {
        $('#detailFileList').append('<li style="color: gray;">첨부된 파일이 없습니다.</li>');
      }
      
      if(registrationStatusByResume == "WAITING"){
        console.log("변경 전 상태 값 : " + registrationStatusByResume);
        changeStatusByregistration("CHECKED", selectedResumeNo, recruitmentNoticePk);
        console.log("변경 후 상태 값 : " + registrationStatusByResume);
      }

      
    }
  }
});
  
});

function showAlertModal(message) {
  $('#alertModalBody').text(message);
  const modal = new bootstrap.Modal(document.getElementById('alertModal'));
  modal.show();
}


function translateStatusEnum(status) {
  const statusMap = {
    PASS: '합격',
    FAILURE: '불합격',
    EXPIRED: '만료됨',
    CHECKED: '조회됨',
    WAITING: '조회되지 않음'
  };

  return statusMap[status] || '알 수 없음';
}

function changeStatusByregistration(status, resumePk, recruitmentNoticePk) {
  if(!$('#detailTitle').val()){ // 출력된 값이 없을 때 호출 되면..
      // 출력된 이력서가 없을 때 모달 표시
      $('#recruitmentModalLabel').text("알림");
      $('.modal-body').text("출력된 이력서가 없습니다.");
      $('#MyModal').modal('show'); // Bootstrap 모달 띄우기

    }else{

    $.ajax({
      url: `/submit/status/\${status}/\${resumePk}/\${recruitmentNoticePk}`,
      type: 'PUT',
      success: function (response) {
      console.log("상태 변경 성공:", response);
      // 성공 후 사용자에게 알림 또는 상태 갱신 로직 등 추가 가능
        // 리스트 초기화
        $('#resumeList').val('-1');
        $('#resumeDetailForm input').val('');
        $('#resumeDetailForm textarea').val('');

        // 최신 상태 반영 위해 이력서 리스트 다시 로딩
        loadSubmittedResumes(recruitmentNoticePk);
        
      },
      error: function (xhr, status, error) {
      console.error("상태 변경 실패:", error);
      showAlertModal("상태 변경 중 오류가 발생했습니다.");
      }

  });

 }

}


function loadSubmittedResumes(recruitmentNo, pageNo = 1, rowCntPerPage = 10) {
  $.ajax({
    url: `/submit/submitList/` + recruitmentNo,
    type: 'GET',
    data: { pageNo, rowCntPerPage },
    success: function (data) {
      console.log("제출된 이력서 리스트:", data);

      // 결과 출력 처리 예시
      $('#resumeList').empty();
      $('#resumeList').append(`<option value="-1">이력서를 선택하세요</option>`);

      if (data && data.boardList && data.boardList.length > 0) {
        data.boardList.forEach(function (resume) {
          const option = `<option value="\${resume.resumeNo}">\${resume.title}</option>`;
          $('#resumeList').append(option);
        });
      } else {
        $('#resumeList').append(`<option disabled>제출된 이력서가 없습니다</option>`);
      }
      // 데이터 저장
      window.latestResumeList = data.boardList;
      // 페이징 처리
      renderResumePagination(data);
    },
    error: function (xhr, status, error) {
      console.error("이력서 조회 실패:", error);
    }
  });
}

function renderResumePagination(data) {
  let paginationHtml = '';

  const startPage = data.startPageNumPerBlock;
  const endPage = data.endPageNumPerBlock;
  const currentPage = data.pageNo;
  const rowCntPerPage = data.rowCntPerPage;

  // 이전 페이지 버튼
  if (startPage > 1) {
    paginationHtml += `<button type="button" class="btn btn-outline-primary btn-sm mx-1 resume-page-btn" data-page="\${startPage - 1}">«</button>`;
  }

  // 페이지 번호 버튼
  for (let i = startPage; i <= endPage; i++) {
  const isActive = i === currentPage ? 'active' : '';
  paginationHtml += `<button type="button" class="btn btn-outline-primary btn-sm mx-1 resume-page-btn \${isActive}" data-page="\${i}">\${i}</button>`;
}

  // 다음 페이지 버튼
  if (endPage < data.totalPageCnt) {
    paginationHtml += `<button type="button" class="btn btn-outline-primary btn-sm mx-1 resume-page-btn" data-page="\${endPage + 1}">»</button>`;
  }

  // 출력할 위치: resume 전용 pagination 영역이 필요합니다
  $('#resumePagination').html(paginationHtml);

  // 클릭 이벤트 바인딩
  $('.resume-page-btn').on('click', function () {
    const pageNo = parseInt($(this).data('page'));
    const selectedRecruitmentNo = $('#recruitmentnoticeList').val();

    if (selectedRecruitmentNo && selectedRecruitmentNo !== '-1') {
      loadSubmittedResumes(selectedRecruitmentNo, pageNo, rowCntPerPage);
    }
  });
}

function loadRecruitmentList(pageNo, rowCntPerPage) {
    $.ajax({
      url: `/recruitmentnotice/rest/list/\${companyUid}`,
      type: "GET",
      data: { pageNo, rowCntPerPage },
      success: function (data) {
        console.log("받은 공고 리스트:", data);

        $('#recruitmentnoticeList').empty();
        $('#recruitmentnoticeList').append(`<option value="-1">공고를 선택하세요</option>`);

        data.boardList.forEach(function (notice) {
          const option = `<option value="\${notice.uid}">\${notice.title}</option>`;
          $('#recruitmentnoticeList').append(option);
        });

        loadRecruitmentDetail();

        // 페이징 영역 업데이트
        renderPagination(data);
      },
      error: function (xhr, status, error) {
        console.error("공고 리스트 불러오기 실패:", error);
      }
    });
  }

  // 공고를 출력하는 함수
  function loadRecruitmentDetail() {
  const selectedRecruitmentNo = $('#recruitmentnoticeList').val();
  if (selectedRecruitmentNo === '-1') {
    $('.recruitDetailInfo').html('<p style="text-align:center; color:gray;">공고를 선택하면 상세정보가 표시됩니다.</p>');
    return;
  }

  $.ajax({
    url: `/recruitmentnotice/rest/detail/\${selectedRecruitmentNo}`,
    type: "GET",
    success: function (data) {
      console.log("공고 상세정보:", data);

      const html = `
        <div class="form-section">
          <label>공고 제목</label>
          <input type="text" class="form-control" value="\${data.title}" readonly>

          <label>근무 형태</label>
          <input type="text" class="form-control" value="\${translateJobFormCode(data.workType)}" readonly>

          <label>급여 유형</label>
          <input type="text" class="form-control" value="\${translatePayType(data.payType)}" readonly>

          <label>급여</label>
          <input type="text" class="form-control" value="\${data.pay}" readonly>

          <label>근무 기간</label>
          <input type="text" class="form-control" value="\${data.period}" readonly>
           <div class="text-end mt-3">
          <button type='button' class="dueDateExpireBtn btn-navy" onclick = "dueDateExpired(\${data.uid})">공고 마감</button>
          </div>
        </div>
      `;

      $('.recruitDetailInfo').html(html);
    },
    error: function (xhr, status, error) {
      console.error("공고 상세 불러오기 실패:", error);
      $('.recruitDetailInfo').html('<p style="color: red;">공고 정보를 불러오는 중 오류가 발생했습니다.</p>');
    }
  });
}
  function dueDateExpired(uid){
    const selectedRecruitmentNo = uid;

    $.ajax({
    url: `/recruitmentnotice/rest/detail/\${selectedRecruitmentNo}`,
    type: "GET",
    success: function (data) {
      console.log("공고 마감 완료:", data);

      // 공고 상세 초기화
      $('.recruitDetailInfo').html('<p style="text-align:center; color:gray;">공고를 선택하면 상세정보가 표시됩니다.</p>');

      // 이력서 셀렉트 초기화
      $('#resumeList').empty().append(`<option value="-1">이력서를 선택하세요</option>`);
      $('#resumePagination').empty();

      // 이력서 상세 폼 초기화
      clearResumeDetailForm();

    },
    error: function (xhr, status, error) {
      console.error("공고 마감 실패:", error);
      
    }
  });
  }

  // 공통 이력서 폼 초기화 함수
function clearResumeDetailForm() {
  $('#resumeDetailForm input').val('');
  $('#resumeDetailForm textarea').val('');
  $('#detailFileList').empty().append('<li style="color: gray;">첨부된 파일이 없습니다.</li>');
}


  // 페이징 하는 함수
  function renderPagination(data) {
  let paginationHtml = ''; // 버튼 HTML 문자열 누적

  const startPage = data.startPageNumPerBlock;
  const endPage = data.endPageNumPerBlock;
  const currentPage = data.pageNo;

  // 이전 버튼
  if (startPage > 1) {
    paginationHtml += `<button type="button" class="btn btn-outline-primary btn-sm mx-1 page-btn" data-page="\${startPage - 1}">«</button>`;
  }

  // 페이지 번호 버튼
  for (let i = startPage; i <= endPage; i++) {
  const isActive = i === currentPage ? 'active' : '';
  paginationHtml += `<button type="button" class="btn btn-outline-primary btn-sm mx-1 page-btn \${isActive}" data-page="\${i}">\${i}</button>`;
}

  // 다음 버튼
  if (endPage < data.totalPageCnt) {
    paginationHtml += `<button type="button" class="btn btn-outline-primary btn-sm mx-1 page-btn" data-page="\${endPage + 1}">»</button>`;
  }

  // HTML 출력
  $('#pagination').html(paginationHtml);

  // 클릭 이벤트 바인딩
  $('#pagination .page-btn').on('click', function () {
    const pageNo = parseInt($(this).data('page'));
    loadRecruitmentList(pageNo, data.rowCntPerPage);
  });
}

function translatePayType(code){
  const map = {
    HOUR: '시급',
    DATE: '일급',
    WEEK: '주급',
    MONTH: '월급',
    YEAR: '연봉'
  };
  return map[code] || code; // 혹시 없는 코드면 그대로 출력
}

function translateJobFormCode(code) {
  const map = {
    FULL_TIME: '정규직',
    CONTRACT: '계약직',
    COMMISSION: '위촉직',
    PART_TIME: '아르바이트',
    FREELANCE: '프리랜서',
    DISPATCH: '파견직'
  };
  return map[code] || code; // 혹시 없는 코드면 그대로 출력
}

</script>

<style>
form {
    max-width: 700px;
    margin: 0 auto;
  }

label {
    display: block;
    font-weight: 500;
    margin-bottom: 0.5rem;
    color: #37517e;
  }

  .custom-select-wrapper {
  display: flex;
  flex-direction: column;
  margin-bottom: 1.5rem;
}

/* 라벨 간격 조절 (상단 마진 추가) */
.custom-select-wrapper label {
  margin-bottom: 0.6rem;
  margin-top: 1rem;  
  font-size: 1rem;
  font-weight: 600;
  color: #37517e;
}

/* 박스형 셀렉트 */
.form-select {
  appearance: none;
  background-color: #fff;
  border: 1px solid #cfd8dc;
  padding: 0.9rem 1rem;
  font-size: 1rem;
  border-radius: 1rem;
  background-image: url('data:image/svg+xml;utf8,<svg fill="%23444" height="24" viewBox="0 0 24 24" width="24"><path d="M7 10l5 5 5-5z"/></svg>');
  background-repeat: no-repeat;
  background-position: right 1rem center;
  background-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
  max-width: 100%;
  width: 100%;
}

  .form-control, .form-select {
    width: 100%;
    max-width: 100%;
    border-radius: 0.75rem;
    padding: 0.6rem 1rem;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    background-color: #fff;
    border: 1px solid #ced4da;
  }

  .form-select:focus, .form-control:focus {
    border-color: #4e73df;
    box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
	outline: none;
  }

  .form-section {
    max-width: 600px;
    margin: 0 auto;
  }

  label.form-check-label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #37517e;
  }

  .input-group {
    margin-bottom: 1.5rem;
  }

  .addAdvantageBtn, #write {
  background-color: var(--accent-color);
  color: white;
  border: none;
  border-radius: 0.75rem;
  padding: 0.5rem 1.2rem;
  font-weight: 500;
  transition: background-color 0.3s ease;
  float: right;
  margin-top: 0.5rem;
}

.addAdvantageBtn:hover, #write {
  background-color: #298ce7; /* 진한 하늘색 hover 효과 */
}

#resumeDetailForm .form-section {
  background-color: var(--surface-color);
  border-radius: 16px;
  padding: 2rem;
  box-shadow: 0px 5px 20px rgba(0, 0, 0, 0.05);
}

#resumeDetailForm label {
  margin-top: 1.2rem;
  font-weight: 600;
  color: var(--heading-color);
}

#resumeDetailForm input.form-control,
#resumeDetailForm reatexta.form-control {
  margin-top: 0.4rem;
  padding: 0.75rem 1rem;
  background-color: color-mix(in srgb, var(--surface-color), transparent 10%);
  border: 1px solid color-mix(in srgb, var(--default-color), transparent 85%);
  border-radius: 8px;
  font-size: 0.95rem;
  color: var(--default-color);
}

#resumeDetailForm input[readonly],
#resumeDetailForm textarea[readonly] {
  background-color: color-mix(in srgb, var(--surface-color), transparent 5%);
  cursor: default;
}

#resumeDetailForm #detailFileList {
  margin-top: 0.5rem;
  padding: 0.5rem 1rem;
  background-color: color-mix(in srgb, var(--surface-color), transparent 8%);
  border: 1px solid color-mix(in srgb, var(--default-color), transparent 85%);
  border-radius: 8px;
}

#resumeDetailForm #detailFileList li {
  margin-bottom: 0.4rem;
}

#resumeDetailForm #detailFileList a {
  color: var(--accent-color);
  font-weight: 500;
  text-decoration: underline;
}

.fixed-width-btn {
  padding: 0;
  font-size: 1rem;
  text-align: center;
  display: flex;
  align-items: center;     /* 세로 가운데 정렬 */
  justify-content: center; /* 가로 가운데 정렬 */
  white-space: nowrap;
}

.badge-custom {
  display: inline-block;
  padding: 0.5rem 1rem;
  font-size: 1rem; /* 크기 조절 가능 */
  font-weight: 600;
  color: #3d4d6a;
  background-color: white;
  border: 2px solid #3d4d6a;
  border-radius: 10px;
  margin: 0.25rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

.attachment-badge {
  position: relative;
  cursor: pointer;
  text-decoration: none;
}

.attachment-badge:hover {
  background-color: #e9ecef; /* 밝은 회색 */
  color: #1a237e;
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
}

.recruitmentByselectedArea{
  margin-top: 20px;
}

.btn-navy {
  background-color: #3d4d6a; /* 진한 남색 */
  color: #fff;
  padding: 0.5rem 1.2rem;
  border: none;
  border-radius: 0.75rem;
  font-weight: 600;
  font-size: 1rem;
  transition: background-color 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.btn-navy:hover {
  background-color: #1a252f; /* 더 진한 남색 hover */
  color: #ffffff;
  transform: translateY(-1px);
}
</style>

<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>

	<!-- 입력받을 form 태그 -->
	<!-- Blog Comment Form Section -->
	<section id="blog-comment-form" class="blog-comment-form section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">
			
			<form role="form">

				<div class="form-header categories-widget widget-item">
					
					<div class="form-section">
						<div class="custom-select-wrapper">
							<label for="recruitmentnoticeList">내가 작성한 공고</label>
							<select class="recruitmentnoticeList form-select" id="recruitmentnoticeList">
							  
							</select>              
						</div>
            <div id="pagination" class="pagination-container text-center mt-4" style="text-align: center; margin-top: 20px;"></div>

            <div class="custom-select-wrapper">
							<label for="resumeList">공고에 제출 된 이력서</label>
							<select class="resumeList form-select" id="resumeList">
							  
							</select>
						  </div>
              <div id="resumePagination" class="pagination-container text-center mt-4" style="text-align: center; margin-top: 20px;"></div>
					</div>
				</div>
			</form>

      <form class="recruitmentByselectedArea">
      <div class="form-section recruitDetailInfo">
        <!-- 여기서 그냥 recruitment 출력하자 -->


      </div>
    </form>

      <form id="resumeDetailForm" style="margin-top: 2rem;">
        <div class="form-section">
          <label>제목</label>
          <input type="text" class="form-control" id="detailTitle" readonly>
      
          <label>희망 급여형태</label>
          <input type="text" class="form-control" id="detailPayType" readonly>
      
          <label>희망 금액</label>
          <input type="text" class="form-control" id="detailPay" readonly>
      
          <label>자기소개</label>
          <textarea class="form-control" id="detailIntroduce" rows="4" readonly></textarea>
      
          <label>희망 고용형태</label>
          <input type="text" class="form-control" id="detailJobForms" readonly>
      
          <label>강점</label>
          <input type="text" class="form-control" id="detailMerits" readonly>
      
          <label>희망 근무지역</label>
          <input type="text" class="form-control" id="detailSigungu" readonly>
      
          <label>희망 직업군</label>
          <input type="text" class="form-control" id="detailSubcategory" readonly>

          <label>첨부파일</label>
          <div id="detailFileList" class="form-control" style="list-style: none; padding-left: 0;">

          </div>

          <label>상태</label>
          <input type="text" class="form-control" id="registrationStatus" readonly>

          <div class="d-flex justify-content-end gap-2 mt-3">
            <button type="button" id="passedBtn" class="btn btn-success btn-sm fixed-width-btn" style="width: 20%;">합격</button>
            <button type="button" id="failedBtn" class="btn btn-danger btn-sm fixed-width-btn" style="width: 20%;">불합격</button>
          </div>
        </div>
      </form>

			<!-- Modal -->
			<div class="modal fade" id="MyModal" tabindex="-1"
				aria-labelledby="MyModal" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="recruitmentModalLabel"></h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close"></button>
						</div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-primary returnList"
								data-bs-dismiss="modal">확인</button>
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



		</div>

	</section>
	<!-- /Blog Comment Form Section -->

	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>