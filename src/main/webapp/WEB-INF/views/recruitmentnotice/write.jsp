<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공고 등록</title>
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
    $(function(){
        console.log("자바 스크립트");
        getRegion();
    });

    function getRegion(){
        $.ajax({
            url: '/region/list',
            type: 'get',
            dataType: 'json',
            async: false,
            success: function (data) {
                console.log("도시 데이터:", data);
                let regionSelect = $(".Region");
                regionSelect.empty();

                regionSelect.append('<option value="-1">도시 선택</option>');

                $.each(data, function(index, region) {
                    regionSelect.append('<option value="' + region.regionNo + '">' + region.name + '</option>');
                });
            },
            error: function (err) {
                console.error("도시 데이터 불러오기 실패", err);
            }
        });
    }

    // 도시 선택 시 시군구 리스트 불러오기
    $(document).on("change", ".Region", function() {
        let selectedRegion = $(this).val();
        console.log("선택한 도시:", selectedRegion);

        if (selectedRegion !== "-1") {
            getSigungu(selectedRegion);
        } else {
            $(".Sigungu").empty();
            $(".Sigungu").append('<option value="-1">시군구 선택</option>');
        }
    });

    function getSigungu(regionNo){
        $.ajax({
            url: '/region/sigungu/' + regionNo,
            type: 'get',
            dataType: 'json',
            async: false,
            success: function (data) {
                console.log("시군구 데이터:", data);
                let sigunguSelect = $(".Sigungu");
                sigunguSelect.empty();

                sigunguSelect.append('<option value="-1">시군구 선택</option>');

                $.each(data, function(index, sigungu) {
                    sigunguSelect.append('<option value="' + sigungu.sigunguNo + '">' + sigungu.name + '</option>');
                });
            },
            error: function (err) {
                console.error("시군구 데이터 불러오기 실패", err);
            }
        });
    }
</script>
</head>
<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>

	<!-- 입력받을 form 태그 -->
	<!-- Blog Comment Form Section -->
	<section id="blog-comment-form" class="blog-comment-form section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">

			<form method="post" role="form">

				<div class="form-header">
					<h3>채용 공고</h3>
					<p>Your email address will not be published. Required fields
						are marked *</p>
				</div>

				<div class="row gy-3">
					<div class="col-md-6">
						<div class="input-group">
							<label for="name">회사명</label> <input type="text" id="Companyname"
								placeholder="Enter your full name" required="" readonly="true">

						</div>
					</div>

					<div class="col-md-6">
						<div class="input-group">
							<label for="email">작성자*</label> <input type="email" id="writer"
								placeholder="Enter your email address" required="" readonly="true">

						</div>
					</div>

					<div class="col-12">
						<div class="input-group">
							<label for="website">공고 제목</label> <input type="text"
								name="title" id="title" placeholder="게시글 제목을 입력해 주세요">
						</div>
					</div>
										
					
					<div class="col-12">
						<div class="input-group">
						<label for="website">산업군</label>
							<select class="majorCategory" id="majorCategory">
								
							</select>
								</div>
								
								<div class="col-12">
						<div class="input-group">
						<label for="website">직종</label>
							<select class="SubCategory" id="SubCategory">
								
							</select>
								</div>
								
								<div class="col-12">
						<div class="input-group">
						<label for="website">도시</label>
							<select class="Region" id ="regionList">
								
							</select>
								</div>
								<input type="hidden" id ="region">
								<div class="col-12">
						<div class="input-group">
						<label for="website">시군구</label>
							<select class="Sigungu" id ="sigunguList">
								
							</select>
								</div>
								<input type="hidden" id ="sigungu">

					<div class="col-12">
						<div class="input-group">
							<label for="website">직종</label> <input type="text"
								name="workType" id="workType" placeholder="정규, 비정규, 프리랜서 등등">
						</div>
					</div>

					<div class="col-12">
						<div class="input-group">
							<label for="website">급여</label> <input type="text" name="payType"
								id="payType" placeholder="급여방식을 입력해 주세요 radio로 바꾸자">
						</div>
					</div>

					<div class="col-md-6">
						<div class="input-group">
							<label for="email">급여 액수</label> <input type="text" name="email"
								id="email" placeholder="금액을 입력해주세요.." required="">

						</div>
					</div>

					<div class="col-12">
						<div class="input-group">
							<label for="email"><div>병역 사항</div></label> 
							<div class="container militaryService">
							<span>미필 이상</span><input type="radio"
								name="militaryService" value="NOT_SERVED"> <span>군필 이상</span><input
								type="radio" name="militaryService" value="SERVED"><span>면제 이상</span><input
								type="radio" name="militaryService" value="EXEMPTED">
								</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="input-group">
							<label for="date">마감 기한</label> <input type="date" id="date"
								max="2077-06-20" min="2077-06-05" value="2077-06-15">

						</div>
					</div>

					<div class="col-12">
						<div class="input-group">
							<label for="comment">상세 내용</label>
							<textarea name="detail" id="detail" rows="5"
								placeholder="상세 내용을 적어주세요..." required=""></textarea>
							<span class="error-text">Please enter your comment</span>
						</div>
					</div>
					
					

					<div class="col-12 text-center">
						<button type="submit" id ="writeTemplate">템플릿 저장</button>
						<button type="submit" id ="write">작성</button>
					</div>
				</div>

			</form>

		</div>

	</section>
	<!-- /Blog Comment Form Section -->

	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>