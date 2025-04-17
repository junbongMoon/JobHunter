<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 헤더 -->
<head>
    <!-- 🔗 기본 URL 설정 (JSP 페이지에서 경로를 쉽게 관리하기 위해 사용) -->
    <base href="${pageContext.request.contextPath}/">

    <!-- ✅ 아이콘 폰트 (FontAwesome) 불러오기 -->
    <link href="resources/adminpagematerials/vendor/fontawesome-free/css/all.min.css" rel="stylesheet">

    <!-- ✅ 관리자 페이지 스타일 적용 (SB Admin 2) -->
    <link href="resources/adminpagematerials/css/sb-admin-2.min.css" rel="stylesheet">
</head>

<!-- 🌎 페이지 전체를 감싸는 Wrapper -->
<div id="wrapper">

    <!-- =================== [📌 사이드바 시작] =================== -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

        <!-- 🔹 대시보드 (메인 페이지로 이동) -->
        <li class="nav-item">
            <a class="nav-link" href="/admin">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>대시보드</span>
            </a>
        </li>

        <!-- 🚧 구분선 -->
        <hr class="sidebar-divider">

        <!-- 🔹 유틸리티 섹션 -->
        <div class="sidebar-heading">유틸리티</div>
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities"
                aria-expanded="true" aria-controls="collapseUtilities">
                <i class="fas fa-fw fa-wrench"></i>
                <span>기능 도구</span>
            </a>
            <div id="collapseUtilities" class="collapse" aria-labelledby="headingUtilities"
                data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">추가 기능:</h6>
                    <a class="collapse-item" href="utilities-color.jsp">색상</a>
                    <a class="collapse-item" href="utilities-border.jsp">테두리</a>
                    <a class="collapse-item" href="utilities-animation.jsp">애니메이션</a>
                    <a class="collapse-item" href="utilities-other.jsp">기타</a>
                </div>
            </div>
        </li>

        <!-- 🔹 페이지 관리 섹션 -->
        <div class="sidebar-heading">페이지 관리</div>
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapsePages"
                aria-expanded="true" aria-controls="collapsePages">
                <i class="fas fa-fw fa-folder"></i>
                <span>페이지 관리</span>
            </a>
            <div id="collapsePages" class="collapse" aria-labelledby="headingPages"
                data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">로그인 관련:</h6>
                    <a class="collapse-item" href="login.jsp">로그인</a>
                    <a class="collapse-item" href="register.jsp">회원가입</a>
                    <a class="collapse-item" href="forgot-password.jsp">비밀번호 찾기</a>
                    <div class="collapse-divider"></div>
                    <h6 class="collapse-header">기타 페이지:</h6>
                    <a class="collapse-item" href="404.jsp">404 오류 페이지</a>
                    <a class="collapse-item" href="blank.jsp">빈 페이지</a>
                </div>
            </div>
        </li>

        <!-- 🔹 차트 페이지 -->
        <li class="nav-item">
            <a class="nav-link" href="charts.jsp">
                <i class="fas fa-fw fa-chart-area"></i>
                <span>차트</span>
            </a>
        </li>

        <!-- 🔹 테이블 페이지 -->
        <li class="nav-item">
            <a class="nav-link" href="tables.jsp">
                <i class="fas fa-fw fa-table"></i>
                <span>테이블</span>
            </a>
        </li>

        <!-- 🔹 유저 관리 섹션 -->
        <div class="sidebar-heading">유저 관리</div>
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUser"
                aria-expanded="true" aria-controls="collapseUser">
                <i class="fas fa-fw fa-folder"></i>
                <span>유저 관리</span>
            </a>
            <div id="collapseUser" class="collapse" aria-labelledby="headingUser"
                data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">유저 관련:</h6>
                    <a class="collapse-item" href="/admin/userList">일반 유저 목록</a>
                    <a class="collapse-item" href="/admin/companyList">기업 유저 목록</a>
                </div>
            </div>
        </li>

        <!-- 🔹 사이드바 토글 버튼 -->
        <div class="text-center d-none d-md-inline">
            <button class="rounded-circle border-0" id="sidebarToggle"></button>
        </div>
    </ul>
    <!-- =================== [📌 사이드바 끝] =================== -->

    <!-- =================== [📌 콘텐츠 Wrapper 시작] =================== -->
    <div id="content-wrapper" class="d-flex flex-column">

        <!-- 🌎 메인 콘텐츠 영역 -->
        <div id="content">

            <!-- =================== [📌 헤더(네비게이션 바) 시작] =================== -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
                <!-- 잡헌터 홈으로 가기 -->
                <a class="nav-link" href="/">
                    <i class="fas fa-home"></i>
                    <span>홈페이지로...</span>
                </a>
                <!-- 📌 사이드바 토글 버튼 (모바일) -->
                <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                    <i class="fa fa-bars"></i>
                </button>

                <!-- 🔹 네비게이션 바 -->
                <ul class="navbar-nav ml-auto">

                    <!-- 🔔 알림(Notification) 
                    <li class="nav-item dropdown no-arrow mx-1">
                        <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button"
                            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-bell fa-fw"></i>
                            <span class="badge badge-danger badge-counter">3+</span>
                        </a>
                        <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                            aria-labelledby="alertsDropdown">
                            <h6 class="dropdown-header">알림 센터</h6>
                            <a class="dropdown-item d-flex align-items-center" href="#">
                                <div class="mr-3">
                                    <div class="icon-circle bg-primary">
                                        <i class="fas fa-file-alt text-white"></i>
                                    </div>
                                </div>
                                <div>
                                    <div class="small text-gray-500">2024년 12월 12일</div>
                                    <span class="font-weight-bold">새로운 보고서가 준비되었습니다!</span>
                                </div>
                            </a>
                        </div>
                    </li> -->

                    <!-- ✉ 메시지(Messages) 
                    <li class="nav-item dropdown no-arrow mx-1">
                        <a class="nav-link dropdown-toggle" href="#" id="messagesDropdown" role="button"
                            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-envelope fa-fw"></i>
                            <span class="badge badge-danger badge-counter">7</span>
                        </a>
                    </li>

                    <div class="topbar-divider d-none d-sm-block"></div> -->

                    <!-- 👤 사용자 정보 -->
                    <li class="nav-item dropdown no-arrow">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="mr-2 d-none d-lg-inline text-gray-600 small">${sessionScope.account.accountName}</span>
                            <img class="img-profile rounded-circle" 
                                src="${pageContext.request.contextPath}/resources/adminpagematerials/img/undraw_profile.svg">
                        </a>
                    </li>
                </ul>
            </nav>
            <!-- =================== [📌 헤더(네비게이션 바) 끝] =================== -->
