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

			<!-- Font Awesome -->
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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

				/* 알림 모달 스타일 */
				.notification-modal {
					display: none;
					position: fixed;
					z-index: 1050;
					left: 0;
					top: 0;
					width: 100%;
					height: 100%;
					overflow: auto;
					background-color: rgba(0, 0, 0, 0.4);
				}

				.notification-modal-content {
					background-color: #fefefe;
					margin: 5% auto;
					padding: 0;
					border-radius: 8px;
					width: 80%;
					max-width: 600px;
					max-height: 80vh;
					overflow-y: auto;
					box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
				}

				.notification-header {
					background-color: #4a6bdf;
					color: white;
					padding: 15px;
					border-radius: 8px 8px 0 0;
					margin-bottom: 0;
					display: flex;
					justify-content: space-between;
					align-items: center;
				}

				.notification-item {
					border-bottom: 1px solid #e9ecef;
					padding: 15px;
					transition: background-color 0.2s;
					position: relative;
					cursor: pointer;
				}

				.notification-item:hover {
					background-color: #f1f3f9;
				}

				.notification-item.unread {
					background-color: #e8f0fe;
				}

				.notification-item.read {
					background-color: #ffffff;
				}

				.notification-title {
					font-weight: 600;
					margin-bottom: 5px;
				}

				.notification-content {
					color: #6c757d;
					font-size: 0.9rem;
				}

				.notification-time {
					font-size: 0.8rem;
					color: #adb5bd;
				}

				.notification-badge {
					background-color: #dc3545;
					color: white;
					border-radius: 50%;
					padding: 2px 6px;
					font-size: 0.7rem;
					position: absolute;
					top: 5px;
					right: 5px;
				}

				.empty-notification {
					text-align: center;
					padding: 30px;
					color: #6c757d;
				}

				.notification-icon {
					width: 40px;
					height: 40px;
					border-radius: 50%;
					display: flex;
					align-items: center;
					justify-content: center;
					margin-right: 15px;
				}

				.user-icon {
					background-color: #4a6bdf;
					color: white;
				}

				.company-icon {
					background-color: #28a745;
					color: white;
				}

				.admin-icon {
					background-color: #dc3545;
					color: white;
				}

				.delete-icon {
					position: absolute;
					bottom: 10px;
					right: 10px;
					color: #dc3545;
					cursor: pointer;
					opacity: 0.7;
					transition: opacity 0.2s;
				}

				.delete-icon:hover {
					opacity: 1;
				}

				.mark-all-read-btn {
					background-color: transparent;
					border: 1px solid white;
					color: white;
					padding: 5px 10px;
					border-radius: 4px;
					font-size: 0.8rem;
					cursor: pointer;
					transition: all 0.2s;
				}

				.mark-all-read-btn:hover {
					background-color: rgba(255, 255, 255, 0.2);
				}

				.close-notification {
					color: white;
					font-size: 1.5rem;
					cursor: pointer;
					margin-left: 10px;
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

		<!-- 알림 모달 -->
		<div id="notificationModal" class="notification-modal">
			<div class="notification-modal-content">
				<div class="notification-header">
					<div>
						<i class="fas fa-bell me-2"></i>알림 목록
					</div>
					<div>
						<button id="markAllReadBtn" class="mark-all-read-btn">
							<i class="fas fa-check-double me-1"></i>모두 읽음
						</button>
						<span class="close-notification" id="closeNotificationModal">&times;</span>
					</div>
				</div>
				<div id="notificationList" class="list-group">
					<!-- 알림 목록이 여기에 동적으로 추가됩니다 -->
				</div>
			</div>
		</div>
		<!-- 알림 모달 -->

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
							<li><a href="/" class="active">Home</a></li>
							<li class="dropdown"><a href="#"><span>채용정보</span> <i
										class="bi bi-chevron-down toggle-dropdown"></i></a>
								<ul>
									<li><a href="/recruitmentnotice/listAll">전체 채용정보</a></li>
									<li><a href="/employment/list">공공기관 제공 채용정보</a></li>
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
										<!-- 메시지가 있을 때-->
										<div class="notification-home" style="display: none;">💬</div>
									</c:when>
									<c:when test="${sessionScope.account.accountType == 'COMPANY'}">
										<a class="nav-link dropdown-toggle"
											href="/company/companyInfo?uid=${sessionScope.account.uid}&accountType=company"
											id="mypageDropdown" role="button">
											My Page
										</a>
										<!-- 메시지가 있을 때-->
										<div class="notification-home" style="display: none;">💬</div>
									</c:when>
									<c:otherwise>
										<a class="nav-link dropdown-toggle"
											href="/user/mypage?uid=${sessionScope.account.uid}&accountType=user"
											id="mypageDropdown" role="button">
											My Page
										</a>
										<!-- 메시지가 있을 때-->
										<div class="notification-home" style="display: none;">💬</div>
									</c:otherwise>
								</c:choose>

								<!-- 마우스 호버 시 뜨는 프로필 카드 -->
								<div class="mypage-profile-card">
									<div class="profile-img-container">
										<div class="profile-img"><img src="${sessionScope.account.profileImg}" style="width:100%; height:100%; object-fit:cover; border-radius:50%;"></div>
										<div class="speech-bubble"
											onclick="openNotifications('${sessionScope.account.uid}', '${sessionScope.account.accountType}')">
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

		<!-- 로그인 상태를 저장할 숨겨진 요소 추가 uid로 확인 -->
		<div id="loginStatus" style="display: none;" data-uid="${sessionScope.account.uid}"></div>
		<div id="accountType" style="display: none;" data-accountType="${sessionScope.account.accountType}"></div>

		<script>


			window.publicSessionUid = "${sessionScope.account.uid}";
			window.publicSessionAccType = "${sessionScope.account.accountType}";

			// 알림 모달 열기 함수
			function openNotifications(uid, accountType) {
				// 모달 표시
				document.getElementById('notificationModal').style.display = 'block';
				
				// 알림 목록 가져오기
				fetchNotifications(uid, accountType);
			}

			// 알림 목록 가져오기 함수
			function fetchNotifications(uid, accountType) {
				fetch('/notification/list?uid=' + uid + '&accountType=' + accountType)
					.then(response => response.text())
					.then(html => {
						// 알림 목록 컨테이너 가져오기
						const notificationList = document.getElementById('notificationList');
						
						// 임시 DOM 요소 생성
						const tempDiv = document.createElement('div');
						tempDiv.innerHTML = html;
						
						// 알림 목록 추출
						const listGroup = tempDiv.querySelector('.list-group');
						
						if (listGroup) {
							// 알림 목록이 있는 경우
							notificationList.innerHTML = listGroup.innerHTML;
							
							// 이벤트 리스너 추가
							addNotificationEventListeners(uid, accountType);
						} else {
							// 알림이 없는 경우
							notificationList.innerHTML = `
								<div class="empty-notification">
									<i class="fas fa-bell-slash fa-3x mb-3"></i>
									<p>새로운 알림이 없습니다.</p>
								</div>
							`;
						}
					})
					.catch(error => {
						console.error('알림 목록 가져오기 실패:', error);
						document.getElementById('notificationList').innerHTML = `
							<div class="empty-notification">
								<i class="fas fa-exclamation-circle fa-3x mb-3"></i>
								<p>알림을 불러오는 중 오류가 발생했습니다.</p>
							</div>
						`;
					});
			}

			// 알림 이벤트 리스너 추가 함수
			function addNotificationEventListeners(uid, accountType) {
				// 알림 항목 클릭 이벤트
				const notificationItems = document.querySelectorAll('.notification-item');
				notificationItems.forEach(item => {
					item.addEventListener('click', function() {
						const messageNo = this.getAttribute('data-message-no');
						markAsRead(messageNo, accountType, uid);
					});
				});

				// 삭제 아이콘 클릭 이벤트
				const deleteIcons = document.querySelectorAll('.delete-icon');
				deleteIcons.forEach(icon => {
					icon.addEventListener('click', function(event) {
						event.stopPropagation();
						const messageNo = this.closest('.notification-item').getAttribute('data-message-no');
						deleteNotification(messageNo);
					});
				});

				// 모두 읽음 버튼 클릭 이벤트
				document.getElementById('markAllReadBtn').addEventListener('click', function() {
					markAllAsRead(accountType, uid);
				});
			}

			// 알림을 읽음 상태로 변경하는 함수
			function markAsRead(messageNo, accountType, uid) {
				fetch('/notification/markAsRead', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded',
					},
					body: 'messageNo=' + messageNo + '&accountType=' + accountType + '&uid=' + uid
				})
				.then(response => {
					if (response.ok) {
						// 알림 항목의 클래스 변경
						const notificationItem = document.querySelector('[data-message-no="' + messageNo + '"]');
						if (notificationItem) {
							notificationItem.classList.remove('unread');
							notificationItem.classList.add('read');
							
							// 배지 제거
							const badge = notificationItem.querySelector('.notification-badge');
							if (badge) {
								badge.remove();
							}
						}
					}
				})
				.catch(error => {
					console.error('Error:', error);
				});
			}

			// 모든 알림을 읽음 상태로 변경하는 함수
			function markAllAsRead(accountType, uid) {
				fetch('/notification/markAllAsRead', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded',
					},
					body: 'accountType=' + accountType + '&uid=' + uid
				})
				.then(response => {
					if (response.ok) {
						// 모든 알림 항목의 클래스 변경
						const unreadItems = document.querySelectorAll('.notification-item.unread');
						unreadItems.forEach(item => {
							item.classList.remove('unread');
							item.classList.add('read');
						});
						
						// 모든 배지 제거
						const badges = document.querySelectorAll('.notification-badge');
						badges.forEach(badge => {
							badge.remove();
						});
					}
				})
				.catch(error => {
					console.error('Error:', error);
				});
			}

			// 알림 삭제 함수
			function deleteNotification(messageNo) {
				fetch('/notification/delete', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify({ messageNo: messageNo })
				})
				.then(response => {
					if (response.ok) {
						// 알림 항목 제거
						const notificationItem = document.querySelector('[data-message-no="' + messageNo + '"]');
						if (notificationItem) {
							notificationItem.remove();
							
							// 모든 알림이 삭제되었는지 확인
							const remainingItems = document.querySelectorAll('.notification-item');
							if (remainingItems.length === 0) {
								// 알림이 없으면 빈 메시지 표시
								document.getElementById('notificationList').innerHTML = `
									<div class="empty-notification">
										<i class="fas fa-bell-slash fa-3x mb-3"></i>
										<p>새로운 알림이 없습니다.</p>
									</div>
								`;
							}
						}
					}
				})
				.catch(error => {
					console.error('Error:', error);
				});
			}

			// 모달 닫기 이벤트 리스너
			document.getElementById('closeNotificationModal').addEventListener('click', function() {
				document.getElementById('notificationModal').style.display = 'none';
			});

			// 모달 외부 클릭 시 닫기
			window.addEventListener('click', function(event) {
				const modal = document.getElementById('notificationModal');
				if (event.target === modal) {
					modal.style.display = 'none';
				}
			});

			// 알림 개수 업데이트 함수
			function updateNotificationCount(count) {
				console.log("알림 개수 업데이트:", count);

				// 모든 알림 아이콘 요소 가져오기
				const notificationHomes = document.querySelector('.notification-home');
				// 모든 알림 개수 요소 가져오기
				const countElements = document.querySelector('.notification-count');

				if (count > 0) {
					notificationHomes.style.display = 'flex';
					countElements.style.display = 'flex';
				} else {
					notificationHomes.style.display = 'none';
					countElements.style.display = 'none';
				}

				countElements.textContent = count;
			}

			// 페이지 로드 시 읽지 않은 알림 개수 가져오기
			window.onload = function () {
				console.log("페이지 로드 완료");

				// 초기에는 모든 알림 요소를 숨김
				document.querySelector('.notification-count').style.display = 'none';
				document.querySelector('.notification-home').style.display = 'none';

				const uid = document.getElementById('loginStatus').getAttribute('data-uid');
				const accountType = document.getElementById('accountType').getAttribute('data-accountType');

				// 로그인한 사용자인 경우에만 알림 개수 가져오기
				if (uid) {
					console.log("로그인 사용자 감지, 알림 개수 요청");
					fetch('/notification/unreadCount?uid=' + uid + '&accountType=' + accountType)
						.then(response => response.json())
						.then(data => {
							console.log("알림 개수 응답:", data);
							if (data && data.count !== undefined) {
								updateNotificationCount(data.count);
							}
						})
						.catch(error => {
							console.error('알림 개수 가져오기 실패:', error);
						});
				} else {
					console.log("로그인 사용자 아님");
				}
			};
		</script>