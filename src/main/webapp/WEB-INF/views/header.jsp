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

			<style>
				.mypage-profile-card {
					display: none;
					position: absolute;
					top: 100%;
					right: 0;
					width: 280px;
					background: white;
					border: 1px solid #e0e0e0;
					padding: 20px;
					z-index: 100;
					border-radius: 15px;
					box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
				}

				.profile-img-container {
					position: relative;
					width: fit-content;
					margin: 0 auto 15px auto;
					text-align: center;
				}

				.profile-img {
					width: 80px;
					height: 80px;
					border-radius: 50%;
					background-color: #f5f5f5;
					border: 1px solid #e0e0e0;
				}

				.speech-bubble {
					width: 35px;
					height: 35px;
					border: 1px solid #0088cc;
					position: absolute;
					right: -15px;
					top: -5px;
					border-radius: 50%;
					background: white;
					display: flex;
					align-items: center;
					justify-content: center;
					cursor: pointer;
					transition: all 0.2s ease;
				}

				.speech-bubble:hover {
					background-color: #f8f9fa;
					transform: scale(1.1);
				}

				.speech-bubble::after {
					content: "💬";
					font-size: 18px;
				}

				.notification-home {
					position: absolute;
					top: 10px;
					right: -20px;
					background-color: #ff4444;
					color: white;
					border-radius: 50%;
					width: 20px;
					height: 20px;
					font-size: 10px;
					display: flex;
					align-items: center;
					justify-content: center;
					border: 1px solid white;
					padding-left: 1px;
					padding-top: 1px;
				}

				.notification-count {
					position: absolute;
					top: -5px;
					right: -5px;
					background-color: #ff4444;
					color: white;
					border-radius: 50%;
					width: 20px;
					height: 20px;
					font-size: 12px;
					display: flex;
					align-items: center;
					justify-content: center;
					font-weight: bold;
					border: 2px solid white;
				}

				.mypage-hover-area:hover .mypage-profile-card {
					display: block;
				}

				.hover-effect {
					transition: all 0.3s ease;
					border-radius: 10px;
				}

				.hover-effect:hover {
					background-color: #f8f9fa;
					transform: translateY(-2px);
				}

				.mypage-profile-card h6 {
					text-align: center;
					margin-bottom: 20px;
					color: #333;
				}

				.mypage-profile-card a {
					margin-bottom: 10px;
					padding: 12px 15px;
					border: 1px solid #e0e0e0;
					transition: all 0.3s ease;
				}

				.mypage-profile-card a:last-child {
					margin-bottom: 0;
				}
			</style>

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
									<li><a href="#">공공기관 제공 채용정보</a></li>
								</ul>
							</li>
							<li><a href="/reviewBoard/allBoard">면접후기</a></li>
							<li>
								<c:if test="${not empty sessionScope.account}">
							<li class="nav-item dropdown position-relative mypage-hover-area">
								<c:choose>
									<c:when test="${sessionScope.account.isAdmin.toString() == 'Y'}">
										<a class="nav-link dropdown-toggle" href="/admin" id="mypageDropdown"
											role="button">👑Admin Page</a>
										<!-- 메시지가 있을 때 띄울예정 -->
										<div class="notification-home">💬</div>
									</c:when>
									<c:when test="${sessionScope.account.accountType == 'COMPANY'}">
										<a class="nav-link dropdown-toggle"
											href="/company/companyHome?uid=${sessionScope.account.uid}&accountType=company"
											id="mypageDropdown" role="button">
											My Page
										</a>
										<!-- 메시지가 있을 때 띄울예정 -->
										<div class="notification-home">💬</div>
									</c:when>
									<c:otherwise>
										<a class="nav-link dropdown-toggle"
											href="/user/mypage?uid=${sessionScope.account.uid}&accountType=user"
											id="mypageDropdown" role="button">
											My Page
										</a>
										<!-- 메시지가 있을 때 띄울예정 -->
										<div class="notification-home">💬</div>
									</c:otherwise>
								</c:choose>

								<!-- 마우스 호버 시 뜨는 프로필 카드 -->
								<div class="mypage-profile-card">
									<div class="profile-img-container">
										<div class="profile-img"></div>
										<div class="speech-bubble" onclick="openNotifications()">
											<!-- 메시지 카운트 들어오게 -->
											<div class="notification-count">0</div>
										</div>
									</div>
									<h6 class="mt-2 fw-bold">${sessionScope.account.accountName}님</h6>

									<!-- accountType에 따라 처리 -->
									<c:choose>
										<c:when test="${sessionScope.account.isAdmin.toString() == 'Y'}">
											<a href="/admin"
												class="d-block border p-2 mb-2 text-decoration-none text-dark rounded hover-effect">
												⚙️ 관리자 대시보드
											</a>
										</c:when>
										<c:when test="${sessionScope.account.accountType == 'USER'}">
											<a href="/resume/form"
												class="d-block border p-2 mb-2 text-decoration-none text-dark rounded hover-effect">
												📄 이력서 쓰기
											</a>
											<a href="/resume/list"
												class="d-block border p-2 text-decoration-none text-dark rounded hover-effect">
												📑 이력서 조회
											</a>
										</c:when>
										<c:when test="${sessionScope.account.accountType == 'COMPANY'}">
											<a href="/recruitmentnotice/write"
												class="d-block border p-2 mb-2 text-decoration-none text-dark rounded hover-effect">
												📝 공고 쓰기
											</a>
											<a href="/recruitmentnotice/listAll"
												class="d-block border p-2 text-decoration-none text-dark rounded hover-effect">
												📋 공고 조회
											</a>
										</c:when>
									</c:choose>
								</div>
							</li>
							</c:if>
							</li>

						</ul>
						<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
					</nav>


					<c:if test="${not empty sessionScope.account}">

						<a class="btn-getstarted" href="/account/logout">로그아웃</a>
					</c:if>
					<c:if test="${empty sessionScope.account}">
						<a class="btn-getstarted" href="${pageContext.request.contextPath}/account/login/return">로그인</a>
					</c:if>

				</div>
				<!-- Scroll Top -->
				<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i
						class="bi bi-arrow-up-short"></i></a>
			</header>
			</body>

		</html>

		<script>
			function openNotifications() {
				const popup = window.open('/notification/list', 'notifications',
					`width=${width},height=${height},top=${top},left=${left},scrollbars=yes,resizable=yes`);

				if (popup) popup.focus();
				else alert("팝업 차단됨. 브라우저 설정 확인해주세요.");
			}


			// 알림 개수 업데이트 함수 (추후 서버에서 받아온 데이터로 업데이트)
			function updateNotificationCount(count) {
				const countElement = document.querySelector('.notification-count');
				if (countElement) {
					countElement.textContent = count;
					countElement.style.display = count > 0 ? 'flex' : 'none';
				}
			}
		</script>