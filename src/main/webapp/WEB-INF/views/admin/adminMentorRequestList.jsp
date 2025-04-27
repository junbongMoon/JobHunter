<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>관리자 페이지</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<!-- Font Awesome -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
	rel="stylesheet" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.search-container {
	margin-bottom: 20px;
}

.pagination {
	margin-top: 20px;
	justify-content: center;
}
</style>
</head>

<body id="page-top">
	<!-- 헤더 포함 (네비게이션바 + 사이드바 포함) -->
	<jsp:include page="adminheader.jsp"></jsp:include>

	<!-- 본문 내용 -->
	<div class="container-fluid">
		<h1 class="h3 mb-4 text-gray-800">멘토 권한 신청 목록</h1>

		<!-- 검색 영역 -->
		<div class="mentor-search-controls">
		
		<div>

			<button type="button" onclick="openSearchTap()">검색</button>

			<!-- 검색 -->
			<div id="searchTap" style="display: none">
				<!-- 검색 타입 체크박스 -->
				<div class="search-types">
					<label><input type="checkbox"
						name="searchTypes" value="TITLE" checked /> 제목</label> <label><input
						type="checkbox" name="searchTypes" value="WRITER" /> 작성자</label> <label><input
						type="checkbox" name="searchTypes" value="CONTENT" /> 내용</label> <label><input
						type="checkbox" name="searchTypes" value="REJECT" /> 반려사유</label>
				</div>
				<!-- 검색어 입력창 -->
				<input type="text" id="searchWord" placeholder="검색어를 입력하세요" />
				<button type="button" id="clearSearchTypes">전체 초기화</button>
			</div>
			
			</div>
			
			<!-- 페이지당 표시 수 -->
			<select id="rowCntPerPage">
				<option value="5">5개씩 보기</option>
				<option value="10" selected>10개씩 보기</option>
				<option value="20">20개씩 보기</option>
				<option value="50">50개씩 보기</option>
			</select>

			<!-- 검색 범위 -->
			<select id="dateRange">
				<option value="ALLTIME">전체 기간</option>
				<option value="1HOUR">최근 1시간</option>
				<option value="1DAY">최근 1일</option>
				<option value="3DAY">최근 3일</option>
				<option value="1MONTH">최근 1달</option>
				<option value="CUSTOM">직접 입력</option>
			</select>

			<!-- 직접 입력용 날짜 선택 -->
			<div id="customDateInputs" style="display: none">
				<input type="datetime-local" id="searchStartDate" /> <input
					type="datetime-local" id="searchEndDate" />
			</div>

			<!-- 상태 선택 -->
			<select id="status" class="status-select">
				<option value="UNCOMPLETE" data-color="gray">⏳ 처리 대기 중</option>
				<option value="WAITING" data-color="gray">🕒 미확인 요청</option>
				<option value="CHECKED" data-color="blue">🔍 확인 진행 중</option>
				<option value="PASS" data-color="green">✅ 승인 완료</option>
				<option value="FAILURE" data-color="red">❌ 승인 거절</option>
				<option value="COMPLETE" data-color="blue">📦 처리 완료</option>
				<option value="ALL" data-color="black">🌐 전체 보기</option>
			</select>

			<!-- 정렬 옵션 버튼 -->
			<span class="sort-buttons">
				<button type="button" id="sortPostDate" class="sort-option active">
					신청일 <span id="arrowPostDate">▼</span>
				</button>
				<button type="button" id="sortConfirmDate" class="sort-option">
					처리일 <span id="arrowConfirmDate">▼</span>
				</button>
			</span>
		</div>

		<!-- 신청 출력 영역 -->
		<div class="card shadow mb-4">
			<div class="card-header py-3">
				<h6 class="m-0 font-weight-bold text-primary">신청 목록</h6>
			</div>
			<div class="card-body">
			
        <!-- 신청 목록 카드 -->
					<div id="mentorRequestCards" class="card-container">
						<div class="mentor-card">
		                    <div class="mentor-card-header">
		                        <h3 class="mentor-title">검색 결과가 없습니다.</h3>
		                        <div class="mentor-status"><span class="badge badge-secondary">미확인 요청</span></div>
		                    </div>
		                    <div class="mentor-card-body">
		                        <p><strong>작성자:</strong> 없음</p>
		                        <p><strong>작성일:</strong> 2025-04-25</p>
		                    </div>
		                </div>
					</div>

				<!-- 페이징 -->
				<nav aria-label="Page navigation">
					<ul class="pagination" id="pagination"></ul>
				</nav>

			</div>
		</div>
	</div>

	<!-- 푸터 포함 -->
	<jsp:include page="adminfooter.jsp"></jsp:include>

	<!-- Bootstrap Bundle with Popper -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

	<script>
      let sortOption = "POSTDATE"; // 초기값
      let sortDirection = "DESC"; // 초기값
      let page = 1;

      $(() => {
        fetchMentorRequests();
      });

      // 전체 초기화 버튼
      $("#clearSearchTypes").on("click", function () {
        $('input[name="searchTypes"]').prop("checked", false);
        $('input[name="searchTypes"][value="TITLE"]').prop("checked", true);
        $("#searchWord").val("");
      });

      // 검색범위 선택시
      $("#dateRange").on("change", function () {
        const value = $(this).val();
        if (value === "CUSTOM") {
          $("#customDateInputs").show();
        } else {
          $("#customDateInputs").hide();
        }
      });

      // 검색 함수
      function fetchMentorRequests() {
        const rowCntPerPage = parseInt($("#rowCntPerPage").val(), 10);
        let searchWord = null;
        let selectedSearchTypes = [];

        if ($("#searchTap").is(":visible")) {
          searchWord = $("#searchWord").val();
          selectedSearchTypes = [];
          $('input[name="searchTypes"]:checked').each(function () {
            selectedSearchTypes.push($(this).val());
          });
        }

        const status = $("#status").val();
        const dateRange = $("#dateRange").val();

        let searchStartDate = null;
        let searchEndDate = null;
        const now = new Date();

        if (dateRange === "1HOUR") {
          searchStartDate = new Date(now.getTime() - 1 * 60 * 60 * 1000);
        } else if (dateRange === "1DAY") {
          searchStartDate = new Date(now.getTime() - 24 * 60 * 60 * 1000);
        } else if (dateRange === "3DAY") {
          searchStartDate = new Date(now.getTime() - 3 * 24 * 60 * 60 * 1000);
        } else if (dateRange === "1MONTH") {
          searchStartDate = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
        } else if (dateRange === "ALLTIME") {
          searchStartDate = null;
          searchEndDate = null;
        } else if (dateRange === "CUSTOM") {
          searchStartDate = $("#searchStartDate").val();
          searchEndDate = $("#searchEndDate").val();
        }

        function formatDate(d) {
          if (!d) return null;
          const date = new Date(d);
          return date.toISOString().slice(0, 19); // 'yyyy-MM-ddTHH:mm:ss'
        }

        $.ajax({
          url: "/mentor/request-list",
          method: "POST",
          contentType: "application/json",
          data: JSON.stringify({
            page: page,
            rowCntPerPage: rowCntPerPage,
            searchWord: searchWord,
            searchTypes: selectedSearchTypes,
            searchStartDate: formatDate(searchStartDate),
            searchEndDate: formatDate(searchEndDate),
            status: status,
            sortOption: sortOption,
            sortDirection: sortDirection,
          }),
          success: function (res) {
            console.log("Mentor Requests:", res);
            renderMentorRequestCards(res.items)
            renderPagination(res)
          },
          error: function (xhr) {
            console.error("Failed to fetch mentor requests", xhr);
          },
        });
      }

      function renderMentorRequestCards(items) {
        const $container = $('#mentorRequestCards');
        $container.empty();

        if (!items || items.length === 0) {
            $container.append('<div class="no-results">검색 결과가 없습니다.</div>');
            return;
        }

        items.forEach(item => {
            const statusBadge = getStatusBadge(item.status);

            const cardHtml = `
                <div class="mentor-card">
                    <div class="mentor-card-header">
                        <h3 class="mentor-title">\${item.title}</h3>
                        <div class="mentor-status">\${statusBadge}</div>
                    </div>
                    <div class="mentor-card-body">
                        <p><strong>작성자:</strong> \${item.writer}</p>
                        <p><strong>작성일:</strong> \${formatDateForDisplay(item.postDate)}</p>
                        \${item.rejectMessage ? '<p><strong>반려 사유:</strong> \${item.rejectMessage}</p>' : ''}
                    </div>
                </div>
            `;

            $container.append(cardHtml);
        });
    }

    // 상태 뱃지 색깔/문구
    function getStatusBadge(status) {
        switch (status) {
            case 'PASS': return `<span class="badge badge-success">승인 완료</span>`;
            case 'FAILURE': return `<span class="badge badge-danger">승인 거절</span>`;
            case 'CHECKED': return `<span class="badge badge-warning">확인 진행 중</span>`;
            case 'WAITING': return `<span class="badge badge-secondary">미확인 요청</span>`;
            default: return `<span class="badge badge-secondary">알수없음</span>`;
        }
    }

    // 날짜 포맷 (yyyy-MM-dd)
    function formatDateForDisplay(dateStr) {
        if (!dateStr) return '-';
        const date = new Date(dateStr);
        return date.toISOString().split('T')[0];
    }

    


      function renderPagination(pagingData) {
    	    const $pagination = $('#pagination');
    	    $pagination.empty(); // 기존 페이징 삭제

    	    // 이전 블록
    	    if (pagingData.hasPrevBlock) {
    	        $pagination.append(`<li class="page-item"><a class="page-link" href=""javascript:void(0);" aria-label="Previous" onclick="goToPage(\${pagingData.startPage - 1})"> <span aria-hidden="true">&laquo;</span></a></li>`);
    	    }

    	    // 페이지 리스트
    	    pagingData.pageList.forEach(pageNum => {
    	        const activeClass = (pageNum === pagingData.page) ? 'active' : '';
    	        $pagination.append(`<li class="page-item"><a class="page-link \${activeClass}" href="javascript:void(0);" onclick="goToPage(\${pageNum})">\${pageNum}</a></li>`);
    	    });

    	    // 다음 블록
    	    if (pagingData.hasNextBlock) {
    	        $pagination.append(`<li class="page-item"><a class="page-link" href="javascript:void(0);" aria-label="Next" onclick="goToPage(\${pagingData.endPage + 1})"> <span aria-hidden="true">&raquo;</span></a></li>`);
    	    }
    	}

      // 페이지 버튼 클릭시
      function goToPage(page) {
        fetchMentorRequests(page); // 선택한 페이지로 검색
      }

      function openSearchTap() {
        if ($("#searchTap").is(":visible")) {
          $("#searchTap").hide();
        } else {
          $("#searchTap").show();
        }
      }

      $("#rowCntPerPage").on("change", function () {
        fetchMentorRequests();
      });

      $("#dateRange").on("change", function () {
        fetchMentorRequests();
      });

      $("#status").on("change", function () {
        fetchMentorRequests();
      });

      $("#clearSearchTypes").on("click", function () {
        fetchMentorRequests();
      });

      $("#searchWord").on("keyup", function () {
        fetchMentorRequests();
      });

      // 정렬 버튼 클릭시
      $(".sort-option").on("click", function () {
        const clickedOption =
          $(this).attr("id") === "sortPostDate" ? "POSTDATE" : "CONFIRMDATE";

        if (sortOption === clickedOption) {
          // 같은 버튼을 다시 누르면 방향 반전
          sortDirection = sortDirection === "ASC" ? "DESC" : "ASC";
        } else {
          // 다른 버튼 클릭하면 sortOption만 변경, 방향은 그대로
          sortDirection = "DESC";
          sortOption = clickedOption;
        }

        // 버튼 색상
        $(".sort-option").removeClass("active");
        $(this).addClass("active");

        // 화살표 업데이트
        $("#arrowPostDate").text(
          sortOption === "POSTDATE" && sortDirection === "ASC" ? "▲" : "▼"
        );
        $("#arrowConfirmDate").text(
          sortOption === "CONFIRMDATE" && sortDirection === "ASC" ? "▲" : "▼"
        );

        // 검색 함수 호출
        fetchMentorRequests();
      });
    </script>
</body>
</html>
