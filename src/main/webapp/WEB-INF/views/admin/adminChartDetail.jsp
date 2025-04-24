<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<jsp:include page="adminheader.jsp"></jsp:include>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
    google.charts.load('current', { packages: ['corechart'] });
    let googleChartsReady = false;
    google.charts.setOnLoadCallback(function () {
        googleChartsReady = true;
    });

    $(function() {
        loadYearOptions();

        $("#startYear").change(function () {
            const year = $(this).val();
            if (year) {
                loadMonthOptions(year, "#startMonth");
            }
        });

        $("#endYear").change(function () {
            const year = $(this).val();
            if (year) {
                loadMonthOptions(year, "#endMonth");
            }
        });

        // 월 선택 이벤트 - 일 불러오기
        $("#startMonth").change(function () {
            const year = $("#startYear").val();
            const month = $(this).val();
            if (year && month) {
                loadDayOptions(year, month, "#startDate");
            }
        });

        $("#endMonth").change(function () {
            const year = $("#endYear").val();
            const month = $(this).val();
            if (year && month) {
                loadDayOptions(year, month, "#endDate");
            }
        });



    });


    function loadYearOptions() {
            $.ajax({
                url: "/status/rest/years",
                method: "GET",
                success: function (data) {
                    const $startYear = $("#startYear");
                    const $endYear = $("#endYear");

                    // 초기화
                    $startYear.empty().append('<option value="">시작 연도를 선택 하세요</option>');
                    $endYear.empty().append('<option value="">끝 연도를 선택 하세요</option>');

                    // 옵션 채우기
                    data.forEach(function (year) {
                        const option = `<option value="\${year}">\${year}년</option>`;
                        $startYear.append(option);
                        $endYear.append(option);
                    });
                },
                error: function () {
                    showAlertModal("연도 정보를 불러오는 데 실패했습니다.");
                }
            });
        }


        function loadMonthOptions(year, targetSelector) {
        $.ajax({
            url: "/status/rest/months",
            method: "GET",
            data: { year: year },
            success: function (data) {
                const $target = $(targetSelector);
                $target.empty().append('<option value="">월을 선택 하세요</option>');
                data.forEach(function (month) {
                    const option = `<option value="\${month}">\${month}월</option>`;
                    $target.append(option);
                });

                // 일 정보 초기화
                if (targetSelector === "#startMonth") {
                    $("#startDate").empty().append('<option value="">일을 선택 하세요</option>');
                } else {
                    $("#endDate").empty().append('<option value="">일을 선택 하세요</option>');
                }
            },
            error: function () {
                showAlertModal("월 정보를 불러오는 데 실패했습니다.");
            }
        });
    }

    function loadDayOptions(year, month, targetSelector) {
        $.ajax({
            url: "/status/rest/days",
            method: "GET",
            data: { year: year, month: month },
            success: function (data) {
                const $target = $(targetSelector);
                $target.empty().append('<option value="">일을 선택 하세요</option>');
                data.forEach(function (day) {
                    const option = `<option value="\${day}">\${day}일</option>`;
                    $target.append(option);
                });
            },
            error: function () {
                showAlertModal("일 정보를 불러오는 데 실패했습니다.");
            }
        });
    }


    function drawDynamicChart(dataList) {
        const selected = $('.stat-check:checked').map(function () {
            return this.value;
        }).get();

        const data = new google.visualization.DataTable();
        data.addColumn('string', '날짜');

        if (selected.includes('user')) data.addColumn('number', '신규 유저');
        if (selected.includes('company')) data.addColumn('number', '신규 기업');
        if (selected.includes('recruit')) data.addColumn('number', '공고 등록 수');
        if (selected.includes('submit')) data.addColumn('number', '이력서 제출 수');
        

        dataList.forEach(item => {
            const dateStr = item.formattedDate || formatDateLabel(item.statusDate);  // formattedDate 우선 사용
            const row = [dateStr];

            if (selected.includes('user')) row.push(item.newUsers || 0);
            if (selected.includes('company')) row.push(item.newCompanies || 0);
            if (selected.includes('recruit')) row.push(item.newRecruitmentNoticeCnt || 0);
            if (selected.includes('submit')) row.push(item.newRegistration || 0);
            

            data.addRow(row);
        });

        const options = {
            title: '선택된 항목 통계',
            legend: { position: 'bottom' },
            width: '100%',
            height: 550,
            bar: { groupWidth: "60%" }
        };

        const chart = new google.visualization.ColumnChart(document.getElementById('chart_container'));
        chart.draw(data, options);
    }

    function showAlertModal(message) {
        $('#alertModalMessage').text(message);
        $('#alertModal').modal('show'); // Bootstrap 4 방식 (Bootstrap 5에서도 동작 가능)
    }


    function formatDateLabel(rawDate) {
        if (!rawDate) return '날짜 없음';

        // 문자열로 들어오는 경우 (ex: "2025-04-01T00:00:00")
        if (typeof rawDate === 'string') {
            if (rawDate.includes("T")) return rawDate.split("T")[0];
            return rawDate;
        }

        // 객체로 들어오는 경우 (ex: { year: 2025, month: 4, day: 1 })
        if (typeof rawDate === 'object' && rawDate.year !== undefined) {
            var y = rawDate.year;
            var m = String(rawDate.month).padStart(2, '0');
            var d = String(rawDate.day).padStart(2, '0');
            return y + '-' + m + '-' + d;  // 
        }

        // Date 타입일 경우
        try {
            var parsed = new Date(rawDate);
            if (isNaN(parsed)) return '날짜 오류';
            var y = parsed.getFullYear();
            var m = String(parsed.getMonth() + 1).padStart(2, '0');
            var d = String(parsed.getDate()).padStart(2, '0');
            return y + '-' + m + '-' + d;  // 
        } catch (e) {
            return '날짜 오류';
        }
    }

    function getDailyStatusByymd() {
        const startYear = $("#startYear").val();
        const startMonth = $("#startMonth").val();
        const startDate = $("#startDate").val();
        const endYear = $("#endYear").val();
        const endMonth = $("#endMonth").val();
        const endDate = $("#endDate").val();

        const selected = $('.stat-check:checked');
        
        if(selected.length < 1){
            showAlertModal("조회하실 항목을 선택해주세요.");
            return;
        }
        

        // 유효성 검사
        if (
            !startYear || !startMonth || !startDate ||
            !endYear || !endMonth || !endDate
        ) {
            showAlertModal("시작과 끝 날짜를 모두 선택해주세요.");
            return;
        }

        // 날짜 문자열 조합
        const start = startYear + '-' + String(startMonth).padStart(2, '0') + '-' + String(startDate).padStart(2, '0') + 'T00:00:00';
        const end = endYear + '-' + String(endMonth).padStart(2, '0') + '-' + String(endDate).padStart(2, '0') + 'T23:59:59';

        const startDateObj = new Date(`\${startYear}-\${startMonth}-\${startDate}`);
        const endDateObj = new Date(`\${endYear}-\${endMonth}-\${endDate}`);

        // 시작일이 종료일보다 이후면 에러
        if (startDateObj > endDateObj) {
            showAlertModal("시작 날짜는 끝 날짜보다 이전이어야 합니다.");
            return;
        }

        // Ajax 요청
        $.ajax({
            url: "/status/rest/range",
            method: "POST",
            contentType: "application/x-www-form-urlencoded",
            data: {
                start: start,
                end: end
            },
            success: function (data) {
                console.log(data);
                drawDynamicChart(data);
            },
            error: function () {
                showAlertModal("데이터를 불러오지 못했습니다.");
            }
        });
    }


  </script>
<style>
    .selectMonth {
      margin-bottom: 20px;
    }
    
  .form-control {
    min-width: 120px;
  }
  .gap-2 {
    gap: 0.5rem !important;
  }

  #getDailyStatusBtn {
    background-color: #3d4d6a !important;
	color: white !important;
	border: 2px solid #3d4d6a !important;
	border-radius: 6px !important;
	padding: 5px 12px !important;
	transition: all 0.3s ease !important;
  }

  #getDailyStatusBtn:hover{
    background-color: #2a344a !important;
	border-color: #2a344a !important;
	transform: translateY(-2px) !important;
	color: white !important;
  }
  
  .chartArea {
	  margin-top: 20px;
	}

</style>
<body>
<!-- 차트 콘텐츠 -->
<div class="container-fluid">
    <div class="row">
        <div class="col-12 d-flex flex-wrap align-items-end gap-2">
    <div class="selectStartDatetime d-flex flex-column flex-grow-1">
        <select id="startYear" class="form-control">
            <option value="-1">시작 연도를 선택 하세요</option>
        </select>
        <select id="startMonth" class="form-control">
            <option value="-1">시작 월을 선택 하세요</option>
        </select>
        <select id="startDate" class="form-control">
            <option value="-1">시작 일을 선택 하세요</option>
        </select>
      </div>
      
        <div class="selectEndDatetime d-flex flex-column flex-grow-1">
        <select id="endYear" class="form-control">
            <option value="-1">끝 연도를 선택 하세요</option>
        </select>
        <select id="endMonth" class="form-control">
            <option value="-1">끝 월을 선택 하세요</option>
        </select>
        <select id="endDate" class="form-control">
            <option value="-1">끝 일을 선택 하세요</option>
        </select>
      </div>

      <div class="form-group flex-grow-1">
        <label>표시할 통계 항목 선택:</label><br>
        <input type="checkbox" class="stat-check" value="user" checked> 유저
        <input type="checkbox" class="stat-check" value="company" checked> 기업
        <input type="checkbox" class="stat-check" value="recruit"> 공고
        <input type="checkbox" class="stat-check" value="submit"> 제출
    </div>
        <div>
        <button type="button" id="getDailyStatusBtn" onclick="getDailyStatusByymd()">조회</button>
        </div>
    </div>
    </div>

    

    <!-- ===== 차트가 포함될 콘텐츠 영역 ===== -->
    <div class="row chartArea">

        <!-- 📌 영역 차트 (Area Chart) -->
        <div class="col-12">
            <div class="card shadow mb-4">
                <!-- 차트 제목 -->
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">일일 통계</h6>
                    <div class="dropdown no-arrow">
                        <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink">
                            <div class="dropdown-header">옵션 선택</div>
                            <a class="dropdown-item" href="#">액션 1</a>
                            <a class="dropdown-item" href="#">액션 2</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="#">기타 옵션</a>
                        </div>
                    </div>
                </div>
                <!-- 차트 본문 -->
                <div class="card-body" style="height: 620px;">
                    <div class="chart-area">
                        <div id="chart_container" style="width: 100%; height: 580px;"></div>
                      </div>
                </div>
            </div>
        </div>

    </div>


    <!-- ===== 차트 관련 JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/resources/adminpagematerials/vendor/chart.js/Chart.min.js"></script>

	<!-- 모달 -->
    <div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="alertModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="alertModalLabel">알림</h5>
              <button type="button" class="btn-close" data-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body" id="alertModalMessage">메시지 내용</div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">확인</button>
            </div>
          </div>
        </div>
      </div>

</div>
</body>
<jsp:include page="adminfooter.jsp"></jsp:include>
