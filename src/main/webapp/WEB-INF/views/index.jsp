<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<body>
		<!-- 헤더 -->
		<jsp:include page="header.jsp"></jsp:include>

		<main class="main">


			<!-- Hero Section -->
			<section id="hero" class="hero section dark-background">

				<div class="container">
					<div class="row gy-4">
						<div class="col-lg-6 order-2 order-lg-1 d-flex flex-column justify-content-center"
							data-aos="zoom-out">
							<h1>JOBHUNTER는 여러분들의 <br>꿈과 희망을 응원합니다!</h1>
							<p>빛나는 꿈과 멋진 미래를 펼쳐보세요!</p>
							<div class="d-flex">
								<a href="/recruitmentnotice/listAll" class="btn-get-started">Get Started</a>
							</div>
						</div>
						<div class="col-lg-6 order-1 order-lg-2 hero-img" data-aos="zoom-out" data-aos-delay="200">
							<img src="resources/assets/img/main-image.png" class="img-fluid animated" alt="">
						</div>
					</div>
				</div>

			</section><!-- /Hero Section -->

		</main>
    
    <script>
		const urlParams = new URLSearchParams(window.location.search);
	  	const kakao = urlParams.get('kakao');
	  	if (kakao == "emailDuplicate") {
	  		window.publicModals.show("이미 등록된 이메일입니다.<br>로그인 후 카카오톡 연동을 진행해주세요.<br>계정찾기로 이동하시겠습니까?", {onConfirm: redirectSearchAccountPage,cancelText:"취소"})
	  	}
	  	function redirectSearchAccountPage() {
			location.href = "/account/find/id";
	  	}
		const firstLogin = urlParams.get('firstLogin');
		if (firstLogin == "company") {
	  		window.publicModals.show("회원가입을 환영합니다.<br>상세정보의 입력을 위하여<br>기업정보 페이지로 이동하시겠습니까?", {onConfirm: ()=>{location.href = "company/companyInfo/${sessionScope.account.uid}";},cancelText:"취소"})
	  	} else if (firstLogin == "user") {
	  		window.publicModals.show("회원가입을 환영합니다.<br>상세정보의 입력을 위하여<br>마이페이지로 이동하시겠습니까?", {onConfirm: ()=>{location.href = "user/mypage/${sessionScope.account.uid}";},cancelText:"취소"})
	  	}
	</script>
		<!-- 풋터 -->
		<jsp:include page="footer.jsp"></jsp:include>
		</div>
	</body>
	</html>

