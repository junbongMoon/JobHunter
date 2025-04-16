<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="utf-8">
			<meta content="width=device-width, initial-scale=1.0" name="viewport">
			<title>JobHunter</title>
			<meta name="description" content="">
			<meta name="keywords" content="">

			<!-- 공용 모달 -->
			<script src="/resources/assets/js/publicModal.js"></script>
			<script src="/resources/assets/js/reportAccount.js"></script>
			<link href="/resources/assets/css/publicModal.css" rel="stylesheet">

			<!-- Favicons -->
			<link href="/resources/assets/img/favicon.png" rel="icon">
			<link href="/resources/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

			<!-- Fonts -->
			<link href="https://fonts.googleapis.com" rel="preconnect">
			<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
			<link
				href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Jost:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap"
				rel="stylesheet">

			<!-- Vendor CSS Files -->
			<link href="/resources/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
			<link href="/resources/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
			<link href="/resources/assets/vendor/aos/aos.css" rel="stylesheet">
			<link href="/resources/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
			<link href="/resources/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

			<!-- Main CSS File -->
			<link href="/resources/assets/css/main.css" rel="stylesheet">

			<!-- Bootstrap -->
			<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

			<!-- AOS -->
			<script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>

			<!-- Swiper -->
			<script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>


			<!-- =======================================================
  * Template Name: Arsha
  * Template URL: https://bootstrapmade.com/arsha-free-bootstrap-html-template-corporate/
  * Updated: Feb 22 2025 with Bootstrap v5.3.3
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
    ======================================================== -->
		</head>
		<!-- 알럿 모달 -->
		<div id="publicModalOverlay" class="public-modal-overlay" style="display: none;"></div>
		<div id="publicModal" class="public-modal-box" style="display: none;">
		<div class="public-modal-content">
			<div class="public-modal-message"></div>
			<div class="public-modal-buttons"></div>
		</div>
		</div>
		<!-- 알럿 모달 -->
		 
		<div class="index-page">
			<header id="header" class="header d-flex align-items-center">
				<div class="container-fluid container-xl position-relative d-flex align-items-center header-background">

					<a href="/" class="logo d-flex align-items-center me-auto">
						<!-- Uncomment the line below if you also wish to use an image logo -->
						<!-- <img src="assets/img/logo.webp" alt=""> -->
						<h1 class="sitename">JobHunter</h1>
					</a>


					<nav id="navmenu" class="navmenu">
						<ul>
							<li><a href="#hero" class="active">Home</a></li>
							<li class="dropdown"><a href="#"><span>채용정보</span> <i
										class="bi bi-chevron-down toggle-dropdown"></i></a>
								<ul>
									<li><a href="/recruitmentnotice/listAll">전체 채용정보</a></li>
									<li><a href="#">지역별 채용정보</a></li>
									<li><a href="#">직업별 채용정보</a></li>
								</ul>
							</li>
							<li><a href="/reviewBoard/allBoard">면접후기</a></li>
							<li>
								<c:if test="${not empty sessionScope.account}">
									<c:choose>
										<c:when test="${sessionScope.account.accountType == 'ADMIN'}">
											<a href="#">My Page</a>
										</c:when>
										<c:when test="${sessionScope.account.accountType == 'COMPANY'}">
										<li class="dropdown">
											<a
												href="/company/companyHome?uid=${sessionScope.account.uid}&accountType=company"><span>My
												Page</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
												<ul>
									<li><a href="/recruitmentnotice/write">공고 쓰기</a></li>
									<li><a href="/recruitmentnotice/listAll">공고 조회</a></li>
								</ul>
										</c:when>
										<c:otherwise>
							<li class="dropdown"><a
									href="/user/mypage?uid=${sessionScope.account.uid}&accountType=user"><span>My
										Page</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
								<ul>
									<li><a href="/resume/form">이력서 쓰기</a></li>
									<li><a href="/resume/list">이력서 조회</a></li>
								</ul>
								</c:otherwise>
								</c:choose>
								</c:if>
							</li>

						</ul>
						<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
					</nav>


					<c:if test="${not empty sessionScope.account}">
						<c:choose>
							<c:when test="${sessionScope.account.accountType == 'ADMIN'}">
								<a class="accountName" style="margin-left: 20px;"
									href="#">${sessionScope.account.accountName}</a>
							</c:when>
							<c:when test="${sessionScope.account.accountType == 'COMPANY'}">
								<a class="accountName" style="margin-left: 20px;"
									href="/company/companyInfo?uid=${sessionScope.account.uid}&accountType=company">${sessionScope.account.accountName}</a>
							</c:when>
							<c:otherwise>
								<a class="accountName" style="margin-left: 20px;"
									href="/user/mypage?uid=${sessionScope.account.uid}&accountType=user">${sessionScope.account.accountName}</a>
							</c:otherwise>
						</c:choose>
						<a class="btn-getstarted" href="/account/logout">로그아웃</a>
					</c:if>
					<c:if test="${empty sessionScope.account}">
						<a class="btn-getstarted" href="${pageContext.request.contextPath}/account/login/return">로그인</a>
					</c:if>

				</div>
			</header>
			</body>

		</html>
