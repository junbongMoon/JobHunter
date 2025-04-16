<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="adminheader.jsp"></jsp:include>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawCharts);
  
    function drawCharts() {
      drawUserCompanyChart();
      drawRecruitSubmitReviewChart();
      drawTotalPieChart();   
      drawTotalComboChart();    
    }

    google.charts.setOnLoadCallback(drawTotalPieChart);

    function drawTotalPieChart() {
    var data = google.visualization.arrayToDataTable([
        ['항목', '수치'],
        ['총 유저 수', ${latestTotal.totalUsers}],
        ['총 기업 수', ${latestTotal.totalCompanies}],
        ['총 공고 수', ${latestTotal.totalRecruitmentNoticeCnt}],
        ['총 제출 수', ${latestTotal.totalRegistration}],
        ['총 리뷰 수', ${latestTotal.totalReviewBoard}]
    ]);

    var options = {
        title: '최신 누적 통계 비율',
        pieHole: 0.4,
        width: '100%',
        height: 320
    };

    var chart = new google.visualization.PieChart(document.getElementById('donut_total_chart'));
    chart.draw(data, options);
    }

    google.charts.setOnLoadCallback(drawTotalComboChart);

    function drawTotalComboChart() {
    var data = new google.visualization.DataTable();
    data.addColumn('string', '날짜');
    data.addColumn('number', '총 유저');
    data.addColumn('number', '총 기업');
    data.addColumn('number', '총 공고');
    data.addColumn('number', '총 제출');
    data.addColumn('number', '총 리뷰');

    data.addRows([
    <c:forEach var="dto" items="${totalCharts}" varStatus="status">
        ['${dto.formattedDate}', 
        ${dto.totalUsers}, 
        ${dto.totalCompanies}, 
        ${dto.totalRecruitmentNoticeCnt}, 
        ${dto.totalRegistration}, 
        ${dto.totalReviewBoard}]<c:if test="${!status.last}">,</c:if>
    </c:forEach>
    ]);

    var options = {
        title: '일별 누적 통계 변화',
        vAxis: {title: '합계'},
        hAxis: {title: '날짜'},
        seriesType: 'bars',
        series: {4: {type: 'line'}}, // 마지막 데이터(리뷰 수)를 선 그래프로
        width: '100%',
        height: 330
    };

    var chart = new google.visualization.ComboChart(document.getElementById('combo_chart_total'));
    chart.draw(data, options);
    }
    
    // 🔹 유저 / 기업 차트
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
        curveType: 'function',
        legend: { position: 'bottom' },
        width: '100%',
        height: 330
    };

    var chart = new google.visualization.LineChart(document.getElementById('curve_chart_top'));
    chart.draw(data, options);
    }
  
    // 🔹 공고 / 제출 / 리뷰 차트
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
        title: '공고/제출/리뷰 통계',
        curveType: 'function',
        legend: { position: 'bottom' },
        width: '100%',
        height: 330
      };
  
      var chart = new google.visualization.LineChart(document.getElementById('curve_chart_bottom'));
      chart.draw(data, options);
    }
  </script>
<body>
<!-- 차트 콘텐츠 -->
<div class="container-fluid">

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
