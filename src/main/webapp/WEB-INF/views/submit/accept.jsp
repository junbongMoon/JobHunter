<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
  const companyUid = '${sessionScope.account.uid}';

$(function() {
  console.log("companyUid:", companyUid);
  loadRecruitmentList(1, 10); // 페이지 로딩 시 자동 호출

  
});

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

        // 페이징 영역 업데이트
        renderPagination(data);
      },
      error: function (xhr, status, error) {
        console.error("공고 리스트 불러오기 실패:", error);
      }
    });
  }

  function renderPagination(data) {
  let paginationHtml = ''; // 버튼 HTML 문자열 누적

  const startPage = data.startPageNumPerBlock;
  const endPage = data.endPageNumPerBlock;
  const currentPage = data.pageNo;

  // 이전 버튼
  if (startPage > 1) {
    paginationHtml += `<button class="page-btn" data-page="\${startPage - 1}">«</button>`;
  }

  // 페이지 번호 버튼
  for (let i = startPage; i <= endPage; i++) {
    const boldStyle = i === currentPage ? ' style="font-weight:bold;"' : '';
    paginationHtml += `<button class="page-btn" data-page="\${i}">\${i}</button>`;
  }

  // 다음 버튼
  if (endPage < data.totalPageCnt) {
    paginationHtml += `<button class="page-btn" data-page="\${endPage + 1}">»</button>`;
  }

  // HTML 출력
  $('#pagination').html(paginationHtml);

  // 클릭 이벤트 바인딩
  $('#pagination .page-btn').on('click', function () {
    const pageNo = parseInt($(this).data('page'));
    loadRecruitmentList(pageNo, data.rowCntPerPage);
  });
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
</style>

<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>

	<!-- 입력받을 form 태그 -->
	<!-- Blog Comment Form Section -->
	<section id="blog-comment-form" class="blog-comment-form section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">
			
			<form method="post" role="form">

				<div class="form-header categories-widget widget-item">
					
					<div class="form-section">
						<div class="custom-select-wrapper">
							<label for="recruitmentnoticeList">내가 작성한 공고</label>
							<select class="recruitmentnoticeList form-select" id="recruitmentnoticeList">
							  
							</select>              
						</div>
            <div id="pagination" class="pagination-container" style="text-align: center; margin-top: 20px;"></div>

            <div class="custom-select-wrapper">
							<label for="resumeList">공고에 제출 된 이력서</label>
							<select class="resumeList form-select" id="resumeList">
							  
							</select>
						  </div>
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

			


		</div>

	</section>
	<!-- /Blog Comment Form Section -->

	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>