<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function() {
		
		getRegion();
		getMajorCategory();

		$('.method-detail, .save-method-btn').hide();

		$(document).on(
				"change",
				".Region",
				function() {
					let selectedRegion = $(this).val();
					console.log("선택한 지역:", selectedRegion);

					if (selectedRegion !== "-1") {
						saveRegion(selectedRegion);
						getSigungu(selectedRegion);
					} else {
						$(".Sigungu").empty().append(
								'<option value="-1">시군구 선택</option>');
					}
				});

		$(document).on("change", ".Sigungu", function() {
			let selectedSigungu = $(this).val();
			console.log("선택한 시군구:", selectedSigungu);

			if (selectedSigungu !== "-1") {
				saveSigungu(selectedSigungu);
			}
		});

		$(document).on(
				"change",
				".MajorCategory",
				function() {
					let selectedMajorNo = $(this).val();
					console.log("선택한 지역:", selectedMajorNo);

					if (selectedMajorNo !== "-1") {
						saveMajorCategory(selectedMajorNo); 
						getSubCategory(selectedMajorNo);
					} else {
						$(".MajorCategory").empty().append(
								'<option value="-1">산업군 선택</option>');
					}
				});

		$(document).on("change", ".SubCategory", function() {
			let selectedSubCategory = $(this).val();
			console.log("선택한 직업:", selectedSubCategory);

			if (selectedSubCategory !== "-1") {
				saveSubCategory(selectedSubCategory);
			}
		});

		$(document).on("change", ".application-checkbox", function () {
  const method = $(this).val();
  const checked = $(this).is(":checked");

  if (checked) {
    $(".method-detail[data-method='" + method + "']").show();
    $(".save-method-btn[data-method='" + method + "']").show();
  } else {
    $(".method-detail[data-method='" + method + "']").hide().val('');
    $(".save-method-btn[data-method='" + method + "']").hide();
    deleteApplication(method);
  }
});

$(document).on("click", ".save-method-btn", function () {
  const method = $(this).data("method");
  const detail = $(".method-detail[data-method='" + method + "']").val();

  // 상세 정보는 입력하지 않아도 된다.

  saveApplication(method, detail);
});
		


	});

	// 면접타입 저장 함수
	function saveApplication(method, detail) {
    $.ajax({
      url: "/recruitmentnotice/rest/application",
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        method: method,
        detail: detail,
        recruitmentNoticeUid: -1
      }),
      success: function (data) {
        console.log(data)
      },
      error: function () {
        alert(`${method} 방식 저장 실패`);
      }
    });
  }

		 // 면접 타입 삭제 함수
		 function deleteApplication(method) {
    $.ajax({
      url: "/recruitmentnotice/rest/application",
      type: "DELETE",
      contentType: "application/json",
      data: JSON.stringify({ method: method }),
      success: function () {
        console.log(`${method} 방식 삭제 완료`);
      },
      error: function () {
        console.error(`${method} 방식 삭제 실패`);
      }
    });
  }


	function getMajorCategory() {
		$.ajax({
			url : '/Category/major',
			type : 'get',
			dataType : 'json',
			async : false,
			success : function(data) {
				console.log("산업군 :", data);
				let majorSelect = $(".MajorCategory");
				majorSelect.empty();

				majorSelect.append('<option value="-1">산업군 선택</option>');

				$.each(data, function(index, majorCategory) {
					majorSelect
							.append('<option value="' + majorCategory.majorcategoryNo + '">'
									+ majorCategory.jobName + '</option>');
				});
			},
			error : function(err) {
				console.error("산업군 데이터 불러오기 실패", err);
			}
		});
	}

	function getSubCategory(majorNo) {
		$.ajax({
			url : '/Category/sub/' + majorNo,
			type : 'get',
			dataType : 'json',
			async : false,
			success : function(data) {
				console.log("산업군 :", data);
				let subSelect = $(".SubCategory");
				subSelect.empty();

				subSelect.append('<option value="-1">산업군 선택</option>');

				$.each(data, function(index, subCategory) {
					subSelect
							.append('<option value="' + subCategory.subcategoryNo + '">'
									+ subCategory.jobName + '</option>');
				});
			},
			error : function(err) {
				console.error("직업 데이터 불러오기 실패", err);
			}
		});
	}

	function getRegion() {
		$.ajax({
			url : '/region/list',
			type : 'get',
			dataType : 'json',
			async : false,
			success : function(data) {
				console.log("도시 데이터:", data);
				let regionSelect = $(".Region");
				regionSelect.empty();

				regionSelect.append('<option value="-1">도시 선택</option>');

				$.each(data, function(index, region) {
					regionSelect
							.append('<option value="' + region.regionNo + '">'
									+ region.name + '</option>');
				});
			},
			error : function(err) {
				console.error("도시 데이터 불러오기 실패", err);
			}
		});
	}

	function getSigungu(regionNo) {
		$
				.ajax({
					url : '/region/sigungu/' + regionNo,
					type : 'get',
					dataType : 'json',
					async : false,
					success : function(data) {
						console.log("시군구 데이터:", data);
						let sigunguSelect = $(".Sigungu");
						sigunguSelect.empty();

						sigunguSelect
								.append('<option value="-1">시군구 선택</option>');

						$
								.each(
										data,
										function(index, sigungu) {
											sigunguSelect
													.append('<option value="' + sigungu.sigunguNo + '">'
															+ sigungu.name
															+ '</option>');
										});
					},
					error : function(err) {
						console.error("시군구 데이터 불러오기 실패", err);
					}
				});
	}

	// 지역 컨트롤러 필드에
	function saveRegion(regionCode) {
		$.ajax({
			url : "/recruitmentnotice/rest/region/" + regionCode,
			type : "POST",
			dataType : "json",
			success : function(response) {
				console.log("지역 저장 성공:", response);
			},
			error : function(err) {
				console.error("지역 저장 실패", err);
			}
		});
	}

	// 시군구 컨트롤러 필드에
	function saveSigungu(sigunguCode) {
		$.ajax({
			url : "/recruitmentnotice/rest/sigungu/" + sigunguCode,
			type : "POST",
			dataType : "json",
			success : function(response) {
				console.log("시군구 저장 성공:", response);
			},
			error : function(err) {
				console.error("시군구 저장 실패", err);
			}
		});
	}

	// 산업군 컨트롤러 필드에

	function saveMajorCategory(majorCategoryNo){
		$.ajax({
			url : "/recruitmentnotice/rest/major/" + majorCategoryNo,
			type : "POST",
			dataType : "json",
			success : function(response) {
				console.log("산업군 저장 성공:", response);
			},
			error : function(err) {
				console.error("산업군 저장 실패", err);
			}
		});
	}

	// 직업 컨트롤러 필드에 
	function saveSubCategory(subCategoryNo){
		$.ajax({
			url : "/recruitmentnotice/rest/sub/" + subCategoryNo,
			type : "POST",
			dataType : "json",
			success : function(response) {
				console.log("직업 저장 성공:", response);
			},
			error : function(err) {
				console.error("직업 저장 실패", err);
			}
		});
	}

	

	function removeAdvantage(deleteBtn) {
    let advantageType = $(deleteBtn).siblings("input[type='hidden']").val();

    $.ajax({
        url: "/recruitmentnotice/rest/advantage/" + advantageType,
        type: "DELETE",
        success: function (response) {
            console.log("삭제 성공", response);
            $(deleteBtn).closest(".advantage-item").remove();
        },
        error: function (err) {
            console.error("삭제 실패", err);
        }
    });
}

	function addAdvantage() {
		
		let advVal = $("#advantage").val();
    let advantageValue = $("#advantage").val();

    if (!advantageValue) {
        alert("우대조건을 입력하세요");
		// 알럿 대신 모달창으로 바꾸자..
        return;
    }

    $.ajax({
        url: "/recruitmentnotice/rest/advantage",
        type: "POST",
        data: JSON.stringify({ advantageType: advantageValue }),
        contentType: "application/json",
        success: function (response) {
            console.log("우대조건 저장 성공", response);
            $("#advantage").val("");

            // DOM에 추가할 HTML 구성
            let output = `
                <div class="d-flex align-items-center mb-2 advantage-item">
                    <input type="hidden" value="\${advantageValue}">
                    <span class="me-2">\${advantageValue}</span>
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeAdvantage(this)">X</button>
                </div>
            `;
            $(".advantageArea").append(output);
        },
        error: function (err) {
            console.error("우대조건 저장 실패", err);
        }
    });

	// append 시키자
	output += ``

}

</script>


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
								placeholder="Enter your email address" required=""
								readonly="true">

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
							<label for="website">산업군</label> <select class="MajorCategory"
								id="MajorCategory">

							</select>
						</div>

						<div class="col-12">
							<div class="input-group">
								<label for="website">직종</label> <select class="SubCategory"
									id="SubCategory">

								</select>
							</div>

							<div class="col-12">
								<div class="input-group">
									<label for="website">도시</label> <select class="Region"
										id="regionList">

									</select>
								</div>
								<input type="hidden" id="region">
								<div class="col-12">
									<div class="input-group">
										<label for="website">시군구</label> <select class="Sigungu"
											id="sigunguList">

										</select>
									</div>
									<input type="hidden" id="sigungu">

									<div class="col-12">
										<div class="input-group">
											<label for="website">직종</label> <input type="text"
												name="workType" id="workType" placeholder="정규, 비정규, 프리랜서 등등">
										</div>
									</div>
									

									<div class="col-12">
										<div class="input-group">
											<label for="website">급여</label> 
												<span>시급</span><input type="radio" name="payType"
												value="HOUR">
												<span>일급</span><input type="radio" name="payType"
												value="DATE">
												<span>주급</span><input type="radio" name="payType"
												value="WEEK">
												<span>월급</span><input type="radio" name="payType"
												value="MONTH">
												<span>연봉</span><input type="radio" name="payType"
												value="YEAR">
										</div>
									</div>

									<div class="col-md-6">
										<div class="input-group">
											<label for="email">급여 액수</label> <input type="text"
												name="email" id="email" placeholder="금액을 입력해주세요.."
												required="">

										</div>
									</div>

									<div class="col-12">
										<div class="input-group">
											<label for="email"><div>병역 사항</div></label>
											<div class="container militaryService">
												<span>미필 이상</span><input type="radio" name="militaryService"
													value="NOT_SERVED"> <span>군필 이상</span><input
													type="radio" name="militaryService" value="SERVED"><span>면제
													이상</span><input type="radio" name="militaryService"
													value="EXEMPTED">
											</div>
										</div>
									</div>

									<div class="col-12">
										<div class="input-group">
											<label class="form-label w-100 mb-3">접수 방법</label>
											
											<div class="row">
												<!-- ONLINE -->
												<div class="col-12 mb-3">
													<div class="d-flex align-items-center">
														<div class="form-check me-3 d-flex align-items-center">
															<input class="form-check-input application-checkbox" type="checkbox" value="ONLINE" id="ONLINE">
															<label class="form-check-label ms-2" for="applyOnline">온라인</label>
														</div>
														<div class="flex-grow-1">
															<div class="input-group">
																<input type="text" class="form-control method-detail" placeholder="상세 정보를 입력해주세요..." data-method="ONLINE" style="display: none;">
																<button type="button" class="btn btn-primary save-method-btn" data-method="ONLINE" style="display: none;">저장</button>
															</div>
														</div>
													</div>
												</div>

												<!-- EMAIL -->  
												<div class="col-12 mb-3">
													<div class="d-flex align-items-center">
														<div class="form-check me-3 d-flex align-items-center">
															<input class="form-check-input application-checkbox" type="checkbox" value="EMAIL" id="EMAIL">
															<label class="form-check-label ms-2" for="applyEmail">이메일</label>
														</div>
														<div class="flex-grow-1">
															<div class="input-group">
																<input type="email" class="form-control method-detail" placeholder="상세 정보를 입력해주세요..." data-method="EMAIL" style="display: none;">
																<button type="button" class="btn btn-primary save-method-btn" data-method="EMAIL" style="display: none;">저장</button>
															</div>
														</div>
													</div>
												</div>

												<!-- PHONE -->
												<div class="col-12 mb-3">
													<div class="d-flex align-items-center">
														<div class="form-check me-3 d-flex align-items-center">
															<input class="form-check-input application-checkbox" type="checkbox" value="PHONE" id="PHONE">
															<label class="form-check-label ms-2" for="applyPhone">전화</label>
														</div>
														<div class="flex-grow-1">
															<div class="input-group">
																<input type="text" class="form-control method-detail" placeholder="상세 정보를 입력해주세요..." data-method="PHONE" style="display: none;">
																<button type="button" class="btn btn-primary save-method-btn" data-method="PHONE" style="display: none;">저장</button>
															</div>
														</div>
													</div>
												</div>

												<!-- TEXT -->
												<div class="col-12 mb-3">
													<div class="d-flex align-items-center">
														<div class="form-check me-3 d-flex align-items-center">
															<input class="form-check-input application-checkbox" type="checkbox" value="TEXT" id="TEXT">
															<label class="form-check-label ms-2" for="applyText">문자</label>
														</div>
														<div class="flex-grow-1">
															<div class="input-group">
																<input type="text" class="form-control method-detail" placeholder="상세 정보를 입력해주세요..." data-method="TEXT" style="display: none;">
																<button type="button" class="btn btn-primary save-method-btn" data-method="TEXT" style="display: none;">저장</button>
															</div>
														</div>
													</div>
												</div>
											</div>

										</div>
									</div>
									

									<div class="col-12">
										<div class="input-group">
											<label for="advantage">우대조건</label> <input type="text"
												id="advantage" placeholder="우대조건을 입력하고 저장 버튼을 눌러주세요..">
												<button type="button" class="addAdvantageBtn" onclick="addAdvantage()">저장하기</button>
										</div>
										<div class="advantageArea"></div>
									</div>

									<div class="col-md-6">
										<div class="input-group">
											<label for="date">마감 기한</label> <input type="date" id="date"
												max="2025-12-30" min="2025-03-30" value="2025-03-27">

										</div>
									</div>

									<div class="col-12">
										<div class="input-group">
											<label for="detail">상세 내용</label>
											<textarea name="detail" id="detail" rows="5"
												placeholder="상세 내용을 적어주세요..." required=""></textarea>
											
										</div>
									</div>

									<div class="col-12">
										<div class="input-group fileArea" style="width: 50px; height: 20px; background-color: #eee;">
											<label for="file">파일</label>
											
										</div>
									</div>



									<div class="col-12 text-center">
										<button type="submit" id="writeTemplate">템플릿 저장</button>
										<button type="submit" id="write">작성</button>
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