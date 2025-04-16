<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="adminheader.jsp"></jsp:include>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawCharts);
  
    function drawCharts() {
      drawUserCompanyChart();
      drawRecruitSubmitReviewChart();
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
                    <div class="chart-pie pt-4 pb-2">
                        <canvas id="myPieChart"></canvas> <!-- 🎨 수익 출처 차트 -->
                    </div>
                    <div class="mt-4 text-center small">
                        <span class="mr-2">
                            <i class="fas fa-circle text-primary"></i> 직접 방문 (Direct)
                        </span>
                        <span class="mr-2">
                            <i class="fas fa-circle text-success"></i> 소셜 미디어 (Social)
                        </span>
                        <span class="mr-2">
                            <i class="fas fa-circle text-info"></i> 추천 (Referral)
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
    

    <!-- ===== 차트 관련 JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/resources/adminpagematerials/vendor/chart.js/Chart.min.js"></script>

    <!-- 🎯 영역 차트 데이터 수정 -->
    <script>
        var ctx = document.getElementById("myAreaChart");
        var myAreaChart = new Chart(ctx, {
            type: 'line', // 차트 타입 (선 그래프)
            data: {
                labels: ["1월", "2월", "3월", "4월", "5월", "6월", "7월"], // 📌 X축 레이블 (월별)
                datasets: [{
                    label: "월별 수익", // 📌 데이터 제목
                    lineTension: 0.3,
                    backgroundColor: "rgba(78, 115, 223, 0.05)",
                    borderColor: "rgba(78, 115, 223, 1)",
                    pointRadius: 3,
                    pointBackgroundColor: "rgba(78, 115, 223, 1)",
                    pointBorderColor: "rgba(78, 115, 223, 1)",
                    pointHoverRadius: 3,
                    pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
                    pointHoverBorderColor: "rgba(78, 115, 223, 1)",
                    pointHitRadius: 10,
                    pointBorderWidth: 2,
                    data: [10000, 15000, 12000, 17000, 18000, 20000, 22000], // 📌 Y축 데이터 (수익 값)
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false // ✨ 이 옵션 추가
            }
        });
    </script>

    <!-- 🎯 원형 차트 데이터 수정 -->
    <script>
        var ctx = document.getElementById("myPieChart");
        var myPieChart = new Chart(ctx, {
            type: 'doughnut', // 차트 타입 (도넛형 차트)
            data: {
                labels: ["직접 방문", "소셜 미디어", "추천"], // 📌 데이터 종류
                datasets: [{
                    data: [50, 30, 20], // 📌 각 데이터 값 (퍼센트)
                    backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc'],
                    hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf'],
                    hoverBorderColor: "rgba(234, 236, 244, 1)",
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false // ✨ 이 옵션 추가
            }
        });
    </script>

</div>
</body>
<jsp:include page="adminfooter.jsp"></jsp:include>
