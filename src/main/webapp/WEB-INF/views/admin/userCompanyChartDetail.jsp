<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<jsp:include page="adminheader.jsp"></jsp:include>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

$(function() {
    getMonth();

$("#monthSelect").on("change", function () {
const selectedMonth = $(this).val();
if (selectedMonth !== "-1") {
    $.ajax({
        url: "/status/rest/ym/data",
        type: "POST",
        data: { ym: selectedMonth },
        contentType: "application/x-www-form-urlencoded",
        success: function (data) {
            console.log("선택 월 통계 데이터:", data);
            const statusList = data.statusList;
            const totalList = data.totalStatusList;

            // 차트 다시 그리기
            drawUserCompanyChartByData(statusList);
            drawRecruitSubmitReviewChartByData(statusList);
            drawTotalComboChartByData(totalList);
            if (totalList.length > 0) {
                const latest = totalList[totalList.length - 1];
                drawPieChartByLatest(latest);
            }
        },
        error: function (xhr) {
            console.error("에러 응답:", xhr.responseText);
            alert("통계 데이터를 불러오는 데 실패했습니다.");
        }
    });
}
});
});

function drawUserCompanyChartByData(statusList) {
    const data = new google.visualization.DataTable();
    data.addColumn('string', '날짜');
    data.addColumn('number', '신규 유저');
    data.addColumn('number', '신규 기업');

    statusList.forEach(item => {
        const dateStr = `\${item.statusDate[0]}-\${String(item.statusDate[1]).padStart(2, '0')}-\${String(item.statusDate[2]).padStart(2, '0')}`;
        data.addRow([dateStr, item.newUsers, item.newCompanies]);
    });

    const options = {
        title: '신규 유저/기업 통계',
        curveType: 'function',
        legend: { position: 'bottom' },
        width: '100%',
        height: 330
    };

    const chart = new google.visualization.LineChart(document.getElementById('curve_chart_top'));
    chart.draw(data, options);
}

function drawRecruitSubmitReviewChartByData(statusList) {
    const data = new google.visualization.DataTable();
    data.addColumn('string', '날짜');
    data.addColumn('number', '공고 등록 수');
    data.addColumn('number', '이력서 제출 수');
    data.addColumn('number', '리뷰 수');

    statusList.forEach(item => {
        const dateStr = `\${item.statusDate[0]}-\${String(item.statusDate[1]).padStart(2, '0')}-\${String(item.statusDate[2]).padStart(2, '0')}`;
        data.addRow([dateStr, item.newRecruitmentNoticeCnt, item.newRegistration, item.newReviewBoard]);
    });

    const options = {
        title: '공고/제출/리뷰 통계',
        curveType: 'function',
        legend: { position: 'bottom' },
        width: '100%',
        height: 330
    };

    const chart = new google.visualization.LineChart(document.getElementById('curve_chart_bottom'));
    chart.draw(data, options);
}

function drawTotalComboChartByData(totalList) {
    const data = new google.visualization.DataTable();
    data.addColumn('string', '날짜');
    data.addColumn('number', '총 유저');
    data.addColumn('number', '총 기업');
    data.addColumn('number', '총 공고');
    data.addColumn('number', '총 제출');
    data.addColumn('number', '총 리뷰');

    totalList.forEach(item => {
        const dateStr = `\${item.statusDate[0]}-\${String(item.statusDate[1]).padStart(2, '0')}-\${String(item.statusDate[2]).padStart(2, '0')}`;
        data.addRow([
            dateStr,
            item.totalUsers,
            item.totalCompanies,
            item.totalRecruitmentNoticeCnt,
            item.totalRegistration,
            item.totalReviewBoard
        ]);
    });

    const options = {
        title: '일별 누적 통계 변화',
        vAxis: { title: '합계' },
        hAxis: { title: '날짜' },
        seriesType: 'bars',
        series: { 4: { type: 'line' } },
        width: '100%',
        height: 330
    };

    const chart = new google.visualization.ComboChart(document.getElementById('combo_chart_total'));
    chart.draw(data, options);
}

function getMonth() {
    $.ajax({
        url: "/status/rest/ym/",
        type: "GET",
        success: function (data) {
            console.log("월 리스트 원본:", data);
            console.log("타입 확인:", typeof data);

            let resultArray = [];

            // ✅ 객체인 경우 처리
            if (Array.isArray(data)) {
                resultArray = data;
            } else if (typeof data === "object" && data !== null) {
                const values = Object.values(data);  // 💡 핵심
                resultArray = values;
            } else {
                resultArray = [data];
            }

            const $select = $("#monthSelect");
            $select.empty();
            $select.append(`<option value="-1">출력할 연/월을 선택 하세요</option>`);
            resultArray.forEach(function (month) {
                console.log(month);
                $select.append(`<option value="\${month}">\${month}</option>`);
            });

            console.log("최종 select 내용:", $select.html());
        },
        error: function () {
            alert("월 리스트를 불러오는 데 실패했습니다.");
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
        <select id="EndYear" class="form-control">
            <option value="-1">끝 연도를 선택 하세요</option>
        </select>
        <select id="EndMonth" class="form-control">
            <option value="-1">끝 월을 선택 하세요</option>
        </select>
        <select id="EndDate" class="form-control">
            <option value="-1">끝 일을 선택 하세요</option>
        </select>
      </div>

    <!-- ===== 차트가 포함될 콘텐츠 영역 ===== -->
    <div class="row">

        <!-- 📌 영역 차트 (Area Chart) -->
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <!-- 차트 제목 -->
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">유저/기업 통계</h6>
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

        <!-- 📌 원형 차트 (Pie Chart) -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <!-- 차트 제목 -->
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">수익 출처 (Revenue Sources)</h6>
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
                        <div id="donut_total_chart" style="width: 100%; height: 320px;"></div>
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
                <h6 class="m-0 font-weight-bold text-primary">공고/제출/리뷰 통계</h6>
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

    <div class="col-xl-4 col-lg-5">
        <div class="card shadow mb-4">
            <!-- 차트 제목 -->
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">전체 통계 추이</h6>
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
                    <div id="combo_chart_total" style="width: 100%; height: 330px;"></div>
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
