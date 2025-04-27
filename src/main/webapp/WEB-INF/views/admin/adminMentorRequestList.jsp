<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>관리자 페이지</title>
    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Font Awesome -->
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
      rel="stylesheet"
    />
    <!-- SB Admin 2 CSS -->
    <link
      href="/resources/adminpagematerials/css/sb-admin-2.css"
      rel="stylesheet"
    />

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
      /* 최소한의 커스텀 스타일만 추가 */
      .mentor-card {
        border: 1px solid #e3e6f0;
        border-radius: 0.35rem;
        margin-bottom: 1rem;
        transition: all 0.3s;
      }

      .mentor-card:hover {
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
      }

      .mentor-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 1.25rem;
        background-color: #f8f9fc;
        border-bottom: 1px solid #e3e6f0;
      }

      .mentor-card-body {
        padding: 1.25rem;
      }

      .mentor-title {
        font-size: 1rem;
        font-weight: 700;
        margin: 0;
        color: #5a5c69;
      }

      .mentor-status {
        display: flex;
        align-items: center;
      }

      .search-container {
        margin-bottom: 1.5rem;
      }

      .search-types {
        margin-bottom: 0.5rem;
      }

      .search-types label {
        margin-right: 1rem;
      }

      .sort-buttons {
        margin-left: 1rem;
      }

      .sort-option {
        background: none;
        border: none;
        color: #5a5c69;
        cursor: pointer;
        padding: 0.25rem 0.5rem;
        margin-right: 0.5rem;
      }

      .sort-option.active {
        color: #4e73df;
        font-weight: bold;
      }

      #searchTap {
        background-color: #f8f9fc;
        padding: 1rem;
        border-radius: 0.35rem;
        margin-bottom: 1rem;
        border: 1px solid #e3e6f0;
      }

      #customDateInputs {
        margin-top: 0.5rem;
      }

      #customDateInputs input {
        margin-right: 0.5rem;
      }

      .no-results {
        text-align: center;
        padding: 2rem;
        color: #858796;
        font-style: italic;
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
      <div class="card shadow mb-4">
        <div
          class="card-header py-3 d-flex flex-row align-items-center justify-content-between"
        >
          <h6 class="m-0 font-weight-bold text-primary">검색 옵션</h6>
          <button
            type="button"
            class="btn btn-primary btn-sm"
            onclick="openSearchTap()"
          >
            <i class="fas fa-search fa-sm"></i> 검색
          </button>
        </div>
        <div class="card-body">
          <!-- 검색 -->
          <div id="searchTap" style="display: none">
            <!-- 검색 타입 체크박스 -->
            <div class="search-types">
              <div class="form-check form-check-inline">
                <input
                  class="form-check-input"
                  type="checkbox"
                  name="searchTypes"
                  value="TITLE"
                  checked
                />
                <label class="form-check-label">제목</label>
              </div>
              <div class="form-check form-check-inline">
                <input
                  class="form-check-input"
                  type="checkbox"
                  name="searchTypes"
                  value="WRITER"
                />
                <label class="form-check-label">작성자</label>
              </div>
              <div class="form-check form-check-inline">
                <input
                  class="form-check-input"
                  type="checkbox"
                  name="searchTypes"
                  value="CONTENT"
                />
                <label class="form-check-label">내용</label>
              </div>
              <div class="form-check form-check-inline">
                <input
                  class="form-check-input"
                  type="checkbox"
                  name="searchTypes"
                  value="REJECT"
                />
                <label class="form-check-label">반려사유</label>
              </div>
            </div>
            <!-- 검색어 입력창 -->
            <div class="form-group">
              <input
                type="text"
                id="searchWord"
                class="form-control"
                placeholder="검색어를 입력하세요"
              />
            </div>
            <button
              type="button"
              id="clearSearchTypes"
              class="btn btn-secondary btn-sm"
            >
              <i class="fas fa-undo fa-sm"></i> 전체 초기화
            </button>
          </div>

          <div class="row mt-3">
            <div class="col-md-3">
              <!-- 페이지당 표시 수 -->
              <div class="form-group">
                <label for="rowCntPerPage">페이지당 표시 수</label>
                <select id="rowCntPerPage" class="form-control">
                  <option value="5">5개씩 보기</option>
                  <option value="10" selected>10개씩 보기</option>
                  <option value="20">20개씩 보기</option>
                  <option value="50">50개씩 보기</option>
                </select>
              </div>
            </div>
            <div class="col-md-3">
              <!-- 검색 범위 -->
              <div class="form-group">
                <label for="dateRange">검색 기간</label>
                <select id="dateRange" class="form-control">
                  <option value="ALLTIME">전체 기간</option>
                  <option value="1HOUR">최근 1시간</option>
                  <option value="1DAY">최근 1일</option>
                  <option value="3DAY">최근 3일</option>
                  <option value="1MONTH">최근 1달</option>
                  <option value="CUSTOM">직접 입력</option>
                </select>
              </div>
            </div>
            <div class="col-md-3">
              <!-- 직접 입력용 날짜 선택 -->
              <div id="customDateInputs" style="display: none">
                <div class="form-group">
                  <label for="searchStartDate">시작일</label>
                  <input
                    type="datetime-local"
                    id="searchStartDate"
                    class="form-control"
                  />
                </div>
                <div class="form-group">
                  <label for="searchEndDate">종료일</label>
                  <input
                    type="datetime-local"
                    id="searchEndDate"
                    class="form-control"
                  />
                </div>
              </div>
            </div>
            <div class="col-md-3">
              <!-- 상태 선택 -->
              <div class="form-group">
                <label for="status">상태</label>
                <select id="status" class="form-control">
                  <option value="UNCOMPLETE" data-color="gray">
                    ⏳ 처리 대기 중
                  </option>
                  <option value="WAITING" data-color="gray">
                    🕒 미확인 요청
                  </option>
                  <option value="CHECKED" data-color="blue">
                    🔍 확인 진행 중
                  </option>
                  <option value="PASS" data-color="green">✅ 승인 완료</option>
                  <option value="FAILURE" data-color="red">❌ 승인 거절</option>
                  <option value="COMPLETE" data-color="blue">
                    📦 처리 완료
                  </option>
                  <option value="ALL" data-color="black">🌐 전체 보기</option>
                </select>
              </div>
            </div>
          </div>

          <!-- 정렬 옵션 버튼 -->
          <div class="mt-3">
            <span class="sort-buttons">
              <button
                type="button"
                id="sortPostDate"
                class="sort-option active"
              >
                신청일 <span id="arrowPostDate">▼</span>
              </button>
              <button type="button" id="sortConfirmDate" class="sort-option">
                처리일 <span id="arrowConfirmDate">▼</span>
              </button>
            </span>
          </div>
        </div>
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
                <div class="mentor-status">
                  <span class="badge badge-secondary">미확인 요청</span>
                </div>
              </div>
              <div class="mentor-card-body">
                <p><strong>작성자:</strong> 없음</p>
                <p><strong>작성일:</strong> 2025-04-25</p>
              </div>
            </div>
          </div>

          <!-- 페이징 -->
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center" id="pagination"></ul>
          </nav>
        </div>
      </div>
    </div>

    <!-- 푸터 포함 -->
    <jsp:include page="adminfooter.jsp"></jsp:include>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

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
            renderMentorRequestCards(res.items);
            renderPagination(res);
          },
          error: function (xhr) {
            console.error("Failed to fetch mentor requests", xhr);
          },
        });
      }

      function renderMentorRequestCards(items) {
        const $container = $("#mentorRequestCards");
        $container.empty();

        if (!items || items.length === 0) {
          $container.append(
            '<div class="no-results">검색 결과가 없습니다.</div>'
          );
          return;
        }

        items.forEach((item) => {
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
          case "PASS":
            return `<span class="badge badge-success">승인 완료</span>`;
          case "FAILURE":
            return `<span class="badge badge-danger">승인 거절</span>`;
          case "CHECKED":
            return `<span class="badge badge-warning">확인 진행 중</span>`;
          case "WAITING":
            return `<span class="badge badge-secondary">미확인 요청</span>`;
          default:
            return `<span class="badge badge-secondary">알수없음</span>`;
        }
      }

      // 날짜 포맷 (yyyy-MM-dd)
      function formatDateForDisplay(dateStr) {
        if (!dateStr) return "-";
        const date = new Date(dateStr);
        return date.toISOString().split("T")[0];
      }

      function renderPagination(pagingData) {
        const $pagination = $("#pagination");
        $pagination.empty(); // 기존 페이징 삭제

        // 이전 블록
        if (pagingData.hasPrevBlock) {
          $pagination.append(
            `<li class="page-item"><a class="page-link" href=""javascript:void(0);" aria-label="Previous" onclick="goToPage(\${pagingData.startPage - 1})"> <span aria-hidden="true">&laquo;</span></a></li>`
          );
        }

        // 페이지 리스트
        pagingData.pageList.forEach((pageNum) => {
          const activeClass = pageNum === pagingData.page ? "active" : "";
          $pagination.append(
            `<li class="page-item"><a class="page-link \${activeClass}" href="javascript:void(0);" onclick="goToPage(\${pageNum})">\${pageNum}</a></li>`
          );
        });

        // 다음 블록
        if (pagingData.hasNextBlock) {
          $pagination.append(
            `<li class="page-item"><a class="page-link" href="javascript:void(0);" aria-label="Next" onclick="goToPage(\${pagingData.endPage + 1})"> <span aria-hidden="true">&raquo;</span></a></li>`
          );
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
