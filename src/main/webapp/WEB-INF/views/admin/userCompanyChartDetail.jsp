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
                alert("연도 정보를 불러오는 데 실패했습니다.");
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
            alert("월 정보를 불러오는 데 실패했습니다.");
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
            alert("일 정보를 불러오는 데 실패했습니다.");
        }
    });
}

function drawUserChart(dataList) {
    const data = new google.visualization.DataTable();
    data.addColumn('string', '날짜');
    data.addColumn('number', '신규 유저');
    data.addColumn('number', '신규 기업');

    dataList.forEach(item => {
    // 날짜 문자열로 안전하게 변환
    const rawDate = item.statusDate;
    let dateStr = '';

        if (typeof rawDate === 'string') {
            // 이미 문자열인 경우
            dateStr = rawDate.split("T")[0];
        } else if (rawDate instanceof Object && rawDate.year) {
            // 예: { year: 2025, month: 3, day: 10, hour: 0, minute: 0, second: 0 } 형태
            const y = rawDate.year;
            const m = String(rawDate.month).padStart(2, '0');
            const d = String(rawDate.day).padStart(2, '0');
            dateStr = `${y}-${m}-${d}`;
        } else {
            // 마지막 수단: 그냥 문자열로 변환해서 처리
            dateStr = String(rawDate).split("T")[0];
        }

        data.addRow([dateStr, item.newUsers, item.newCompanies]);
    });

    const options = {
        title: '유저/기업 일일 통계',
        legend: { position: 'bottom' },
        width: '100%',
        height: 320,
        bar: { groupWidth: "60%" }
    };

    const chart = new google.visualization.ColumnChart(document.getElementById('curve_chart_top'));
    chart.draw(data, options);
}

function getDailyStatusByymd() {
    const startYear = $("#startYear").val();
    const startMonth = $("#startMonth").val();
    const startDate = $("#startDate").val();
    const endYear = $("#endYear").val();
    const endMonth = $("#endMonth").val();
    const endDate = $("#endDate").val();

    // 유효성 검사
    if (
        !startYear || !startMonth || !startDate ||
        !endYear || !endMonth || !endDate
    ) {
        alert("시작과 끝 날짜를 모두 선택해주세요.");
        return;
    }

    // 날짜 문자열 조합
    const start = `\${startYear}-\${String(startMonth).padStart(2, '0')}-\${String(startDate).padStart(2, '0')}T00:00:00`;
    const end = `\${endYear}-\${String(endMonth).padStart(2, '0')}-\${String(endDate).padStart(2, '0')}T23:59:59`;

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
            drawUserChart(data);  // 유저/기업 차트 함수 호출
        },
        error: function () {
            alert("데이터를 불러오지 못했습니다.");
        }
    });
}


  </script>
<style>
    .selectMonth {
      margin-bottom: 20px;
    }
</style>
<body>
<!-- 차트 콘텐츠 -->
<div class="container-fluid">
    <div class="row">
    <div class="selectStartDatetime">
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
      
        <div class="selectEndDatetime">
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
      <button type="button" id="getDailyStatusBtn" onclick="getDailyStatusByymd()">조회</button>
    </div>

    <!-- ===== 차트가 포함될 콘텐츠 영역 ===== -->
    <div class="row">

        <!-- 📌 영역 차트 (Area Chart) -->
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <!-- 차트 제목 -->
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">유저 일일 통계</h6>
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
                <div class="card-body">
                    <div class="chart-area">
                        <div id="curve_chart_top" style="width: 100%; height: 320px"></div>
                      </div>
                </div>
            </div>
        </div>

    </div>

    <div class="row">
    <div class="col-xl-8 col-lg-7">
        <div class="card shadow mb-4">
            <!-- 차트 제목 -->
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">기업 일일 통계</h6>
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
            <div class="card-body">
                <div class="chart-area">
                    <div id="curve_chart_bottom" style="width: 100%; height: 320px"></div>
                  </div>
            </div>
        </div>
    </div>

</div>

    <!-- ===== 차트 관련 JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/resources/adminpagematerials/vendor/chart.js/Chart.min.js"></script>



</div>
</body>
<jsp:include page="adminfooter.jsp"></jsp:include>
