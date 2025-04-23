<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4230440978d7fc8b259ff34d707166f2&autoload=false&libraries=services"></script>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>
	$(function() {

		showDetailInfo();

		kakao.maps.load(function () {
			const addr = '${RecruitmentDetailInfo.companyAddr}';

			if (!addr || addr.trim() === "") {
			console.warn("주소 정보가 없습니다.");
			return;
		}
		
			const mapContainer = document.getElementById('map');
			const mapOption = {
			center: new kakao.maps.LatLng(37.566826, 126.9786567),
			level: 3
			};
			const map = new kakao.maps.Map(mapContainer, mapOption);
			const geocoder = new kakao.maps.services.Geocoder();

			geocoder.addressSearch(addr, function (result, status) {
			if (status === kakao.maps.services.Status.OK) {
				const coords = new kakao.maps.LatLng(result[0].y, result[0].x);

				const marker = new kakao.maps.Marker({
				map: map,
				position: coords
				});

				const infowindow = new kakao.maps.InfoWindow({
				content: `<div style="padding:5px;font-size:14px;">회사 위치</div>`
				});
				infowindow.open(map, marker);
				map.setCenter(coords);
			} else {
				console.warn("주소로 좌표를 찾을 수 없습니다.");
			}
			});
		});

	});
	
	// 데이터를 출력 하는 함수
	function showDetailInfo() {
		const uid = '${RecruitmentDetailInfo.uid}';
		const application = '${RecruitmentDetailInfo.application}';
		const workType = '${RecruitmentDetailInfo.workType}';
		const militaryService = '${RecruitmentDetailInfo.militaryService}';
		const manager = '${RecruitmentDetailInfo.manager}';
		const period = '${RecruitmentDetailInfo.period}';
		const pay = '${RecruitmentDetailInfo.pay}';
		const payType = '${RecruitmentDetailInfo.payType}';
		const personalHistory = '${RecruitmentDetailInfo.personalHistory}';
		const detail = '${RecruitmentDetailInfo.detail}';
		const dueDateRaw = '${RecruitmentDetailInfo.dueDate}';
		const dueDate = new Date(dueDateRaw);
		const regDateRaw = '${RecruitmentDetailInfo.regDate}';
		const regDate = new Date(regDateRaw)
		const fileList = '${RecruitmentDetailInfo.fileList}';
		const count = '${RecruitmentDetailInfo.count}';

		// 마감일 출력
		
		if (!isNaN(dueDate.getTime())) { // dueDateRaw가 날짜형식이 아니면 Invalid Date객체 생성, .getTime()이 NaN을 반환
			const formatted = dueDate.toLocaleDateString('ko-KR', {
				year : 'numeric', // 숫자
				month : 'long', // n월
				day : '2-digit' // 2자리
			});
			$('#dueDateSpan').text(formatted);
		} else {
			$('#dueDateSpan').text('유효하지 않은 날짜');
		}

		// 작성일 출력
		if (!isNaN(regDate.getTime())) {
			const formattedRegDate = regDate.toLocaleDateString('ko-KR', {
				year: 'numeric',
				month: 'long',
				day: '2-digit'
			});
			$('#regDateSpan').text(formattedRegDate);
			} else {
			$('#regDateSpan').text('유효하지 않은 날짜');
			}

		$('#detail').html(detail);

	}
	
	// 모달 띄우기
	function openContactModal(method, detail) {
		const message = detail && detail.trim() !== '' ? detail
				: `${method} 방식으로 접수 가능합니다.`;

		$('#contactModalBody').text(message);
		const modal = new bootstrap.Modal(document
		.getElementById('contactModal'));
		modal.show();
	}

	function deleteRecruitment(uid) {
    $('#contactModalLabel').text("공고 삭제 확인");
    $('#contactModalBody').html("정말로 이 공고를 삭제하시겠습니까?<br><br><strong>삭제하면 되돌릴 수 없습니다.</strong>");

    const footer = $('#contactModal .modal-footer');
    footer.find('#deleteConfirmBtn').remove(); // 중복 제거

    const deleteBtn = $('<button>')
        .attr('type', 'button')
        .attr('id', 'deleteConfirmBtn')
        .addClass('btn btn-danger')
        .text('삭제하기')
        .on('click', function () {
            $.ajax({
                url: '/recruitmentnotice/remove/' + uid,
                type: 'DELETE',
                success: function () {
                    // 모달 닫기
                    const modal = bootstrap.Modal.getInstance(document.getElementById('contactModal'));
                    modal.hide();

                    // 삭제 완료 후 페이지 이동
                    setTimeout(() => {
                        window.location.href = '/recruitmentnotice/listAll';
                    }, 500);
                },
                error: function (xhr, status, error) {
                    console.error('삭제 실패:', error);
                    alert('삭제에 실패했습니다.');
                }
            });
        });

    footer.prepend(deleteBtn);

    const modal = new bootstrap.Modal(document.getElementById('contactModal'));
    modal.show();
}

function saveLike(userId, boardNo) {
    $.ajax({
        url: '/like/save',
        method: 'POST',
        data: { userId: userId, boardNo: boardNo },
        success: function (res) {
            if (res) {
                alert("좋아요 완료!");
                location.reload(); // 상태 갱신
            } else {
                alert("이미 좋아요를 눌렀습니다.");
            }
        },
        error: function () {
            alert("좋아요 처리 중 오류 발생!");
        }
    });
}

function deleteLike(userId, boardNo) {
    $.ajax({
        url: '/like/delete?userId=' + userId + '&boardNo=' + boardNo,
        method: 'DELETE',
        success: function (res) {
            if (res) {
                alert("좋아요 취소 완료!");
                location.reload();
            } else {
                alert("좋아요 취소 실패!");
            }
        },
        error: function () {
            alert("좋아요 취소 중 오류 발생!");
        }
    });
}

function reportBoard() {
  const modal = new bootstrap.Modal(document.getElementById('reportModal'));
  modal.show();
}

function submitReport() {
  const userId = document.getElementById('loginUserUid').value;
  const uid = document.getElementById('reportUid').value;
  const category = document.getElementById('reportCategory').value;
  const message = document.getElementById('reportMessage').value;

  if (!category) {
    alert("신고 사유를 선택해주세요.");
    return;
  }

  const reportData = {
    boardNo: parseInt(uid),
    reporterAccountUid: parseInt(userId),
    reportCategory: category,
    reportMessage: message,
    reportType: "RECRUITMENT",
    reportTargetURL: `/recruitmentnotice/detail?uid=${uid}`
  };

  $.ajax({
    url: '/report/board',
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(reportData),
    success: function () {
      alert("신고가 접수되었습니다.");
      bootstrap.Modal.getInstance(document.getElementById('reportModal')).hide();
    },
    error: function (xhr) {
      alert("신고 처리 중 오류가 발생했습니다: " + xhr.responseText);
    }
  });
}

function drawRecruitmentStats() {
		const stats = {
		maleCount: parseInt('${RecruitmentDetailInfo.stats.maleCount}', 10) || 0,
		femaleCount: parseInt('${RecruitmentDetailInfo.stats.femaleCount}', 10) || 0,
		unknownAgeCount: parseInt('${RecruitmentDetailInfo.stats.unknownAgeCount}', 10) || 0,
		teens: parseInt('${RecruitmentDetailInfo.stats.teens}', 10) || 0,
		twenties: parseInt('${RecruitmentDetailInfo.stats.twenties}', 10) || 0,
		thirties: parseInt('${RecruitmentDetailInfo.stats.thirties}', 10) || 0,
		forties: parseInt('${RecruitmentDetailInfo.stats.forties}', 10) || 0,
		fiftiesOrAbove: parseInt('${RecruitmentDetailInfo.stats.fiftiesOrAbove}', 10) || 0
	};

	const total =
		stats.maleCount + stats.femaleCount +
		stats.teens + stats.twenties + stats.thirties + stats.forties + stats.fiftiesOrAbove;

	if (total === 0) {
		document.getElementById("recruitmentnoticeStat").style.display = "none";
		$('.recStat').html("지원된 공고가 없습니다.");
		return;
	}

	// 성별 비율
	const genderData = google.visualization.arrayToDataTable([
		['성별', '인원수'],
		['남성', stats.maleCount],
		['여성', stats.femaleCount]
	]);

	const genderOptions = {
		title: '성별 비율',
		pieHole: 0.4,
		width: 400,
		height: 300
	};

	// 연령대 비율
	const ageData = google.visualization.arrayToDataTable([
		['연령대', '인원수'],
		['10대 미만', stats.teens],
		['20대', stats.twenties],
		['30대', stats.thirties],
		['40대', stats.forties],
		['50대 이상', stats.fiftiesOrAbove],
		['나이 정보 없음', stats.unknownAgeCount]
	]);

	const ageOptions = {
		title: '연령대 비율',
		pieHole: 0.4,
		width: 400,
		height: 300
	};

	// 그리기
	const genderChart = new google.visualization.PieChart(document.getElementById('genderChart'));
	const ageChart = new google.visualization.PieChart(document.getElementById('ageChart'));

	genderChart.draw(genderData, genderOptions);
	ageChart.draw(ageData, ageOptions);
}

google.charts.load('current', { packages: ['corechart'] });
google.charts.setOnLoadCallback(drawRecruitmentStats);

</script>
<style>
.badge {
	margin-right: 5px;
	font-size: 2.5em;
}

h3 {
	font-weight: bold;
}

.card {
	border-radius: 12px;
	background-color: #f9f9f9;
	transition: all 0.2s ease-in-out;
}

.card:hover {
	background-color: #f1f8ff;
	transform: scale(1.01);
}

.trend-list {
	list-style-type: none;
	padding-left: 0;
}

.trend-list li:hover {
	background-color: #f1f8ff;
	transform: scale(1.01);
}

#fileList .badge {
	margin-right: 6px;
	margin-bottom: 4px;
	font-size: 0.9rem;
}

.detail-box {
  width: 100%;
  min-height: 300px;
  background: #f4f8fb;
  padding: 1rem;
  border-radius: 12px;

  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05); 
}

.detail-box img {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 1rem auto;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  object-fit: contain;
}

.singleFile {
  transition: all 0.3s ease;
  display: inline-block;
}

.singleFile:hover {
  background-color: #1a237e; /* 진한 남색 */
  color: white;
  transform: translateY(-2px); /* 살짝 위로 튀어나오게 */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
  cursor: pointer;
}

.badge-custom {
  display: inline-block;
  padding: 0.5rem 1rem;
  font-size: 1rem; /* 크기 조절 가능 */
  font-weight: 600;
  color: #3d4d6a;
  background-color: white;
  border: 2px solid #3d4d6a;
  border-radius: 10px;
  margin: 0.25rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

.badge-custom i {
  margin-right: 0.4rem;
  color: #3d4d6a;
  font-size: 1.1em;
}

.attachment-badge {
  position: relative;
  cursor: pointer;
  text-decoration: none;
}

.attachment-badge:hover {
  background-color: #e9ecef; /* 밝은 회색 */
  color: #1a237e;
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
}

/* 목록으로 버튼 스타일 */
button.btn-list {
  background-color: #3d4d6a !important;
  color: white !important;
  border: none !important;
  padding: 0.5rem 1rem;
  border-radius: 7px; /* ⬅ 여기를 12px로 조정 */
  transition: all 0.3s ease;
}


.btn-list:hover {
  background-color: #2a344a;
  transform: translateY(-2px);
}

/* 이력서 제출 버튼 스타일 */
button.btn-resume {
  background-color: #47b2e4 !important;
  color: white !important;
  border: none !important;
  padding: 0.5rem 1rem;
  border-radius: 7px; /* ⬅ 여기도 동일하게 */
  transition: all 0.3s ease;
}

.btn-resume:hover {
  background-color: #349fcc;
  transform: translateY(-2px);
}

.post-navigation-card-style {
  width: 80%;
  margin: 0 auto;
  background-color: #fff;
  border: 1px solid #dee2e6;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.post-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #eee;
}

.post-row:last-child {
  border-bottom: none;
}

.post-row .label {
  font-weight: bold;
  color: #47b2e4;
  width: 80px;
  flex-shrink: 0;
}

.post-row .title {
  flex-grow: 1;
  text-align: left;
  padding: 0 1rem;
  font-weight: 600;
  color: #3d4d6a;
}

.post-row .title a {
  color: #3d4d6a;
  text-decoration: none;
}

.post-row .title a:hover {
  color: #47b2e4;
  text-decoration: underline;
}

.post-row .date {
  font-size: 0.95rem;
  color: #888;
  flex-shrink: 0;
}

.post-row.current {
  background-color: white !important; 
  border: 2px solid #47b2e4; 
  border-radius: 8px;
  color: #3d4d6a;
  font-weight: bold;
}

.share-section .social-links .d-flex {
  justify-content: flex-end !important;
}

.info-inline-box {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 2rem;
  margin-top: 1rem;
}

.info-inline-box .info-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.info-inline-box .info-item img {
  width: 20px;  /* 기존 40px → 절반 */
  height: 20px;
  margin-bottom: 0.25rem;
  object-fit: contain;
}

.info-inline-box .info-item span {
  font-size: 1rem;
  color: #3d4d6a;
  font-weight: 600;
}

.search-widget.widget-item {
  padding: 0.5rem 1rem;
  background-color: #f9f9f9;
  border-radius: 12px;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: auto; /* 높이 제한 제거 */
  height: auto;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.search-widget.widget-item img {
  transition: all 0.3s ease;
  cursor: pointer;
}

.search-widget.widget-item img:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.info-item {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 0.5rem 0;
}

.icon-row {
  display: flex;
  align-items: center;
  gap: 0.6rem; /* 아이콘과 숫자 사이 간격 */
}

.icon-row img {
  width: 30px;
  height: 30px;
  object-fit: contain;
  transition: transform 0.3s ease;
  cursor: pointer;
}

.count-number {
  font-size: 1rem;
  font-weight: 600;
  color: #3d4d6a;
}
</style>
<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>
	<main class="main">


		<div class="container">
			<div class="row">

				<div class="col-lg-8">

					<!-- Blog Details Section -->
					<section id="blog-details" class="blog-details section">
						<div class="container" data-aos="fade-up">

							<article class="article">

								<div class="article-content" data-aos="fade-up"
									data-aos-delay="100">
									<div class="content-header">
										<h1 class="title">${RecruitmentDetailInfo.title}</h1>

										<div class="author-info">
											<div class="author-details">
												<!-- 이미지 있으면 이미지 넣을 것 -->
												<div class="info">
													<h4>${RecruitmentDetailInfo.companyName}</h4>
													<span class="role">${RecruitmentDetailInfo.subcategory.jobName}</span>
												</div>
											</div>
											<div class="post-meta">
												<span class="dueDate"><i class="bi bi-calendar3"></i>마감
													<span id="dueDateSpan"></span></span> <span class="divider">•</span>
													<span class="regDateArea"><i class="bi bi-calendar3"></i> 작성일 <span id="regDateSpan"></span></span>
											</div>
										</div>
									</div>

									<div class="content">

										<c:if test="${not empty RecruitmentDetailInfo.stats}">
											<div class="categories-widget widget-item card">
												<h3 class="widget-title recStat">공고 지원 비율</h3>
												<div id="recruitmentnoticeStat" style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: center;">
												<div id="genderChart"></div>
												<div id="ageChart"></div>
												</div>
											</div>
										</c:if>

										<div class="categories-widget widget-item card">
											<h3 class="widget-title">지역</h3>
											<p id="region">
												<span class="badge-custom"><i class="fa-solid fa-building"></i>${RecruitmentDetailInfo.region.name}</span>
												<span class="badge-custom"><i class="fa-regular fa-building"></i>${RecruitmentDetailInfo.sigungu.name}</span>
											  
											
											</p>

											<h3 class="widget-title">직업</h3>
											<p id="jobType">
												<span class="badge-custom"><i class="fa-solid fa-helmet-safety"></i>${RecruitmentDetailInfo.majorCategory.jobName}</span>
												<span class="badge-custom"><i class="fa-solid fa-suitcase"></i>${RecruitmentDetailInfo.subcategory.jobName}</span>
											  
											</p>

											<h5 class="widget-title">근무 형태</h5>
											<p class="mb-1 fw-semibold" id="workType">
												<c:choose>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'FULL_TIME'}">정규직</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'CONTRACT'}">계약직</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'COMMISSION'}">위촉직</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'PART_TIME'}">아르바이트</c:when>
													<c:when
														test="${RecruitmentDetailInfo.workType eq 'FREELANCE'}">프리랜서</c:when>
														<c:when
														test="${RecruitmentDetailInfo.workType eq 'DISPATCH'}">파견직</c:when>
													<c:otherwise>기타</c:otherwise>
												</c:choose>
											</p>
											<p class="text-muted" id="period">${RecruitmentDetailInfo.period}</p>

											<h5 class="widget-title">급여</h5>
											<p class="mb-1 fw-semibold" id="payType">
												<c:choose>
													<c:when test="${RecruitmentDetailInfo.payType eq 'HOUR'}">시급</c:when>
													<c:when test="${RecruitmentDetailInfo.payType eq 'DATE'}">일급</c:when>
													<c:when test="${RecruitmentDetailInfo.payType eq 'WEEK'}">주급</c:when>
													<c:when test="${RecruitmentDetailInfo.payType eq 'MONTH'}">월급</c:when>
													<c:when test="${RecruitmentDetailInfo.payType eq 'YEAR'}">연봉</c:when>
													<c:otherwise>기타</c:otherwise>
												</c:choose>
											</p>

											<p class="fs-5 fw-bold text-success" id="pay">
												<fmt:formatNumber value="${RecruitmentDetailInfo.pay}"
													type="number" groupingUsed="true" />
												원
											</p>

											<h3 class="widget-title">조건</h3>
											<p id="personalHistory">
												<span class="badge-custom"><i class="fa-solid fa-clipboard"></i>${RecruitmentDetailInfo.personalHistory}</span>
												<span class="badge-custom"><i class="fa-solid fa-person-rifle"></i>  <c:choose>
													<c:when test="${RecruitmentDetailInfo.militaryService eq 'SERVED'}">군필 이상</c:when>
													<c:when test="${RecruitmentDetailInfo.militaryService eq 'NOT_SERVED'}">미필 이상</c:when>
													<c:when test="${RecruitmentDetailInfo.militaryService eq 'EXEMPTED'}">면제 이상</c:when>
													<c:otherwise>기타</c:otherwise>
												  </c:choose></span>
												<c:forEach var="item"
													items="${RecruitmentDetailInfo.advantage}">
													<span class="badge-custom"><i class="fa-solid fa-user-plus"></i>${item.advantageType}</span>
												</c:forEach>
											</p>

											
										</div>


										<div class="categories-widget widget-item card">
											<h2 class="widget-title">상세 정보</h2>
											<div class="highlight-box">

												<div id="detail" class="detail-box"></div>
											</div>
										</div>

										<div class="categories-widget widget-item card">
											<h2 class="widget-title">오시는 길</h2>
											<div class="highlight-box">
												<div id="map" style="width:100%;height:400px;border-radius:12px;"></div>
											
											</div>
										</div>
										


										<h3>첨부 파일</h3>
										<p id="fileList">
										  <c:if test="${not empty RecruitmentDetailInfo.fileList}">
											<c:forEach var="file" items="${RecruitmentDetailInfo.fileList}">
											  <a href="${file.newFileName}" 
												 download="${file.originalFileName}"
												 class="badge-custom attachment-badge"
												 title="Download">
												 <i class="fa-solid fa-download"></i> ${file.originalFileName}
											  </a>
											</c:forEach>
										  </c:if>
										</p>
									</div>

									<div class="meta-bottom">
										<div class="tags-section">
											<h4>면접 방법</h4>
											<div class="tags">
												<ul class="trend-list">
													<c:forEach var="app"
														items="${RecruitmentDetailInfo.application}">
														<c:choose>
															<c:when test="${app.method eq 'ONLINE'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/internet100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>온라인
																		접수 안내</span></li>
															</c:when>
															<c:when test="${app.method eq 'EMAIL'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/mail100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>이메일
																		접수 안내</span></li>
															</c:when>
															<c:when test="${app.method eq 'PHONE'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/phone100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>전화
																		접수 안내</span></li>
															</c:when>
															<c:when test="${app.method eq 'TEXT'}">
																<li
																	onclick="openContactModal('${app.method}', '${app.detail}')"><img
																	src="/resources/images_mjb/mobile100.png" width="24"
																	height="24" style="cursor: pointer;" /> <span>문자
																		접수 안내</span></li>
															</c:when>
														</c:choose>
													</c:forEach>
												</ul>
											</div>
										</div>

										<div class="post-navigation-card-style mt-5">
											<!-- 이전 글 -->
											<c:if test="${not empty prevPost}">
											  <div class="post-row">
												<div class="label">이전 글</div>
												<div class="title"><a href="/recruitmentnotice/detail?uid=${prevPost.uid}">${prevPost.title}</a></div>
												<div class="date"><fmt:formatDate value="${prevPost.regDate}" pattern="yyyy-MM-dd" /></div>
											  </div>
											</c:if>
										  
											<!-- 현재 글 -->
											<div class="post-row current">
											  <div class="label">현재 글</div>
											  <div class="title">${RecruitmentDetailInfo.title}</div>
											  <div class="date"><fmt:formatDate value="${RecruitmentDetailInfo.regDate}" pattern="yyyy-MM-dd" /></div>
											</div>
										  
											<!-- 다음 글 -->
											<c:if test="${not empty nextPost}">
											  <div class="post-row">
												<div class="label">다음 글</div>
												<div class="title"><a href="/recruitmentnotice/detail?uid=${nextPost.uid}">${nextPost.title}</a></div>
												<div class="date"><fmt:formatDate value="${nextPost.regDate}" pattern="yyyy-MM-dd" /></div>
											  </div>
											</c:if>
										  </div>

										<div class="share-section ">
											<h4>More</h4>
											<div class="social-links mt-2 w-100">
												<div class="d-flex gap-2 justify-content-end w-100">
													<button type="button" class="btn-list"
													onclick="location.href='/recruitmentnotice/listAll'">목록으로</button>
													<c:choose>
														<c:when test="${sessionScope.account.accountType == 'COMPANY'}">
													<button type="button" class="btn btn-primary"
														onclick="location.href='/recruitmentnotice/modify?uid=${RecruitmentDetailInfo.uid}'">수정</button>
													<button type="button" class="btn btn-danger"
														onclick="deleteRecruitment('${RecruitmentDetailInfo.uid}')">삭제</button>
													</c:when>
													<c:when test="${sessionScope.account.accountType == 'USER'}">
														<button type="button" class="btn-resume" id="submitResumeBtn"
														onclick="location.href='/submission/check?uid=${RecruitmentDetailInfo.uid}'">
														이력서 제출
													</button>
														<button type="button" class="btn btn-report" id="reportBtn" onclick="reportBoard()">신고하기</button>
												</c:when>
												</c:choose>
												</div>
											</div>
										</div>
									</div>

									

									<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
										<div class="modal-dialog">
										  <div class="modal-content">
										  
											<div class="modal-header">
											  <h5 class="modal-title" id="reportModalLabel">공고 신고</h5>
											  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
											</div>
									  
											<div class="modal-body">
											  <input type="hidden" id="loginUserUid" value="${sessionScope.account.uid}" />
											  <input type="hidden" id="reportUid" value="${RecruitmentDetailInfo.uid}" />
									  
											  <label for="reportCategory" class="form-label">신고 사유</label>
											  <select id="reportCategory" class="form-select" required>
												<option value="" disabled selected>-- 신고 사유 선택 --</option>
												<option value="SPAM">스팸/광고</option>
												<option value="FALSE_INFO">허위 정보</option>
												<option value="ILLEGAL_ACTIVITY">불법 행위</option>
												<option value="INAPPROPRIATE_CONTENT">부적절한 내용</option>
												<option value="ETC">기타</option>
											  </select>
									  
											  <label for="reportMessage" class="form-label mt-3">상세 내용</label>
											  <textarea id="reportMessage" class="form-control" rows="4" placeholder="신고 내용을 입력해주세요."></textarea>
											</div>
									  
											<div class="modal-footer">
											  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
											  <button type="button" class="btn btn-danger" onclick="submitReport()">제출</button>
											</div>
									  
										  </div>
										</div>
									  </div>


								</div>

								
							</article>
						</div>
					</section>
					<!-- /Blog Details Section -->


				</div>

				<div class="col-lg-4 sidebar">

					<div class="widgets-container" data-aos="fade-up"
						data-aos-delay="200">
												<!-- Search Widget -->
											<c:if test="${sessionScope.account.uid > 0}">
												<div class="search-widget widget-item">

													<h3 class="widget-title"></h3>
													<c:choose>
														<c:when test="${hasLiked}">
														  <img src="/resources/images_mjb/bad100.png" onclick="deleteLike('${sessionScope.account.uid}', '${RecruitmentDetailInfo.uid}')" alt="좋아요 취소" />
														</c:when>
														<c:otherwise>
														  <img src="/resources/images_mjb/like100.png"  onclick="saveLike('${sessionScope.account.uid}', '${RecruitmentDetailInfo.uid}')" alt="좋아요" />
														</c:otherwise>
													  </c:choose>
												</div>
											</c:if>
												<!--/Search Widget -->

						<!-- Categories Widget -->
						<div class="categories-widget widget-item">

							<h3 class="widget-title">Info</h3>

								<div class="info-stat-box">
									<div class="info-item">
										<div class="icon-row">
										  <img src="/resources/images_mjb/good100.png" alt="좋아요 수" />
										  <span class="count-number">${likeCnt}</span>
										</div>
									  </div>
									  
									  <div class="info-item">
										<div class="icon-row">
										  <img src="/resources/images_mjb/eye100.png" alt="조회수" />
										  <span class="count-number">${RecruitmentDetailInfo.count}</span>
										</div>
									  </div>
								</div>


						</div>
						<!--/Categories Widget -->



					</div>

				</div>

			</div>
		</div>
		<!-- 풋터 -->
		<jsp:include page="../footer.jsp"></jsp:include>

	</main>


	<!-- Scroll Top -->
	<a href="#" id="scroll-top"
		class="scroll-top d-flex align-items-center justify-content-center"><i
		class="bi bi-arrow-up-short"></i></a>


	<!-- 접수 방법 모달 -->
	<div class="modal fade" id="contactModal" tabindex="-1"
		aria-labelledby="contactModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="contactModalLabel">접수 방법</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>
				<div class="modal-body" id="contactModalBody">
					<!-- 여기에 내용이 동적으로 삽입됩니다 -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
