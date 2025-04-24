<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<jsp:include page="adminheader.jsp"></jsp:include>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">
    google.charts.load('current', { packages: ['corechart'] });
    google.charts.setOnLoadCallback(drawCharts);

    function drawCharts() {
        drawUserCompanyChart();
        drawRecruitSubmitReviewChart();
        drawUserCompanyDonutChart();     // 기존 위치
        drawPostStatsDonutChart();
    }




//  유저 / 기업 통계 → 막대그래프
function drawUserCompanyChart() {
    var data = new google.visualization.DataTable();
    data.addColumn('string', '날짜');
    data.addColumn('number', '신규 유저');
    data.addColumn('number', '신규 기업');

    data.addRows([
        <c:forEach var="dto" items="${daliyCharts}" varStatus="status">
            ['${dto.statusDate.toLocalDate()}', ${dto.newUsers}, ${dto.newCompanies}]<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ]);

    var options = {
        title: '신규 유저/기업 통계',
        legend: { position: 'bottom' },
        width: '100%',
        height: 330,
        bar: { groupWidth: "60%" }
    };

    var chart = new google.visualization.ColumnChart(document.getElementById('curve_chart_top'));
    chart.draw(data, options);
}

function drawUserCompanyDonutChart() {
    var data = google.visualization.arrayToDataTable([
        ['항목', '수치'],
        ['총 유저 수', ${latestTotal.totalUsers}],
        ['총 기업 수', ${latestTotal.totalCompanies}]
    ]);

    var options = {
        title: '유저/기업 비율',
        pieHole: 0.4,
        width: '100%',
        height: 320
    };

    var chart = new google.visualization.PieChart(document.getElementById('donut_user_company_chart'));
    chart.draw(data, options);
}

function drawPostStatsDonutChart() {
    var data = google.visualization.arrayToDataTable([
        ['항목', '수치'],
        ['총 공고 수', ${latestTotal.totalRecruitmentNoticeCnt}],
        ['총 제출 수', ${latestTotal.totalRegistration}],
        ['총 리뷰 수', ${latestTotal.totalReviewBoard}]
    ]);

    var options = {
        title: '공고/제출/리뷰 비율',
        pieHole: 0.4,
        width: '100%',
        height: 320
    };

    var chart = new google.visualization.PieChart(document.getElementById('donut_post_stats_chart'));
    chart.draw(data, options);
}

//  공고 / 제출 / 리뷰 통계 → 막대그래프
function drawRecruitSubmitReviewChart() {
    var data = new google.visualization.DataTable();
    data.addColumn('string', '날짜');
    data.addColumn('number', '공고 등록 수');
    data.addColumn('number', '이력서 제출 수');
    data.addColumn('number', '리뷰 수');

    data.addRows([
        <c:forEach var="dto" items="${daliyCharts}" varStatus="status">
            ['${dto.statusDate.toLocalDate()}', ${dto.newRecruitmentNoticeCnt}, ${dto.newRegistration}, ${dto.newReviewBoard}]<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ]);

    var options = {
        title: '일일 공고/제출/리뷰 통계',
        legend: { position: 'bottom' },
        width: '100%',
        height: 330,
        bar: { groupWidth: "60%" }
    };

    var chart = new google.visualization.ColumnChart(document.getElementById('curve_chart_bottom'));
    chart.draw(data, options);
}
</script>

<body>
<div class="container-fluid">
    
    <div class="row">
        <div class="col-xl-8 col-lg-7" style="cursor: pointer;" onclick="location.href='/admin/adminChartDetail'">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">유저/기업 통계</h6>
                </div>
                <div class="card-body">
                    <div id="curve_chart_top" style="width: 100%; height: 320px;"></div>
                </div>
            </div>
        </div>

        <!-- 유저/기업 파이 -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">유저/기업 비율</h6>
                </div>
                <div class="card-body">
                    <div id="donut_user_company_chart" style="width: 100%; height: 320px;"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- ✅ 공고/제출/리뷰 통계 -->
    <div class="row">
        <div class="col-xl-8 col-lg-7" style="cursor: pointer;" onclick="location.href='/admin/adminChartDetail'">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">공고/제출/리뷰 통계</h6>
                </div>
                <div class="card-body">
                    <div id="curve_chart_bottom" style="width: 100%; height: 320px;"></div>
                </div>
            </div>
        </div>

        <!-- 공고/제출/리뷰 파이 -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">공고/제출/리뷰 비율</h6>
                </div>
                <div class="card-body">
                    <div id="donut_post_stats_chart" style="width: 100%; height: 320px;"></div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<jsp:include page="adminfooter.jsp"></jsp:include>
