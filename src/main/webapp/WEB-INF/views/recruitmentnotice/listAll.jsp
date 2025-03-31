<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	

</script>
<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>
	<main class="main">
	<!-- Blog Posts Section -->
	<section id="blog-posts" class="blog-posts section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">

			<div class="row gy-4">
				<div>${boardList} </div>
				
				<div class="col-lg-6">
					<!--col-lg-6 가 카드 하나 -->
					<article>

						<!--  	
                    <div class="post-img">
                      <img src="assets/img/blog/blog-post-1.webp" alt="" class="img-fluid">
                    </div>
						-->
						<h2 class="title">
							<a href="blog-details.html">제목</a>
						</h2>

						<div class="meta-top">
							<ul>
								<li class="d-flex align-items-center"><i
									class="bi bi-person writer"></i> <a href="blog-details.html">작성자
										</a></li>
								<li class="d-flex align-items-center"><i
									class="bi bi-clock"></i> <a href="blog-details.html"><time
											datetime="2022-01-01">년-월-일 </time></a></li>
								
							</ul>
						</div>

						<div class="content">
							<p class="rectext">여기서 우대조건, 면접타입</p>

							<div class="read-more">
								<a href="blog-details.html">바로 가기</a>
							</div>
						</div>

					</article>
				</div>
					

				
				<!-- End post list item -->

			</div>
			<!-- End blog posts list -->

		</div>

	</section>


	</main>
	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>
	
</body>
</html>