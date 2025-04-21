<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멘토PR 작성</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- include summernote css/js -->
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.js"></script>
<script>
	$(function(){
		$('#summernote').summernote();
	});
</script>

<style>
  .btn-primary {
    background-color: var(--primary-color);
    border-color: var(--primary-color);
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
  }

  .btn-primary:hover {
    background-color: #3a9fd1;
    border-color: #3a9fd1;
    transform: translateY(-2px);
  }

  .btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
    padding: 0.6rem 1.2rem;
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
  }

  .btn-danger:hover {
    background-color: #c82333;
    border-color: #bd2130;
    transform: translateY(-2px);
  }
  
	label[for="summernote"] {
	  display: block;
	  font-weight: 600;
	  color: var(--secondary-color);
	  margin-bottom: 0.5rem;
	}
</style>

</head>
<body>
	<jsp:include page="../header.jsp"></jsp:include>

	<section id="blog-comment-form" class="blog-comment-form section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">
			
			<form method="post" role="form" action="/prboard/write">
				<div class="form-header categories-widget widget-item">
					<h3>멘토 PR</h3>
				</div>
					<div class="row gy-3">
					<div class="col-md-6">
						<div class="input-group">
							<label for="email" class="form-check-label">아이디</label> <input
								type="text" id="writer" placeholder="Enter your email address"
								name="userId"
								required="" readonly="true"
								value="${sessionScope.account.accountId}">

						</div>
					</div>
					<input type="hidden" name="useruid" value="${sessionScope.account.uid}">
					<div class="col-md-6">
						<div class="input-group">
							<label for="email" class="form-check-label">작성자</label> <input
								type="text" id="writer" placeholder="Enter your email address"
								name="writer"
								required="" readonly="true"
								value="${sessionScope.account.accountName}">

						</div>
					</div>
					
					<div class="col-12">
						<div class="input-group">
							<label for="website" class="form-check-label">제목</label> <input
								type="text" name="title" id="title"
								placeholder="게시글 제목을 입력해 주세요">
						</div>
					</div>
					
					<div class="col-12">
					  <div class="input-group flex-column">
					    <label for="summernote" class="form-check-label mb-2">상세 내용</label>
					    <textarea id="summernote" name="introduce"></textarea>
					  </div>
					</div>
										
			<div class="col-12 text-center mt-4">
			  <button type="submit" id="write" class="btn btn-primary me-2" style="width: 120px; height: 52px;">작성</button>
			  <button type="button" id="cancel" class="btn btn-danger" style="width: 120px; height: 52px;">취소</button>
			</div>
										
				
			</div>
			</form>
			
		</div>
			
	</section>

	<jsp:include page="../footer.jsp"></jsp:include>

</body>
</html>