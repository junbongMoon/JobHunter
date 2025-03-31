<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- include summernote css/js -->
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.js"></script>

<script>
	let errorMessage = "";
	let focusElement = null;
	let upfiles = [];
	

	$(function() {

		const today = new Date();
		today.setHours(0,0,0,0); // 오늘 자정으로 설정
    const nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 1);

    // yyyy-MM-dd 포맷으로 변환
    function formatDate(date) {
        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
        return `${yyyy}-${mm}-${dd}`;
    }

    const minDate = formatDate(today);
    const maxDate = formatDate(nextMonth);

    // 오늘 날짜를 기본값으로 설정하고 min 속성 적용
    const dateInput = $("#date");
    dateInput.attr("min", minDate);
    dateInput.attr("max", maxDate);
    dateInput.val(minDate);
    
    // 과거 날짜 선택 방지
    dateInput.on('change', function() {
        const selectedDate = new Date(this.value);
        if(selectedDate < today) {
            $(".modal-body").text("오늘 이전 날짜는 선택할 수 없습니다.");
            $("#MyModal").modal("show");
            $(this).val(minDate);
        }
    });
		
		$('#summernote').summernote();

		getRegion();
		getMajorCategory();

		$('.method-detail, .save-method-btn').hide();

		$(".fileUploadArea").on("dragover", function (e) {
    e.preventDefault();
    $(this).css("background-color", "#ccc");
});

$(".fileUploadArea").on("dragleave", function (e) {
    e.preventDefault();
    $(this).css("background-color", "#eee");
});

$(".fileUploadArea").on("drop", function (e) {
    e.preventDefault();
    $(this).css("background-color", "#eee");

    let files = e.originalEvent.dataTransfer.files;
    for (let i = 0; i < files.length; i++) {
        let file = files[i];
        uploadFileAndShowPreview(file);
    }
});

$(document).on("click", "#goToListBtn", function () {
  location.href = "./list";
});

		

		$(document).on("change", "input[name='workType']", function () {
  const selectedWorkType = $("input[name='workType']:checked").val();
  const phoneAndTextHtml = `
    
    <div class="col-12 mb-2 parttime-only" id="phoneOption">
      <div class="d-flex align-items-center">
        <div class="form-check me-3 d-flex align-items-center">
          <input class="form-check-input application-checkbox" type="checkbox" id="PHONE" value="PHONE">
          <label class="form-check-label ms-2" for="PHONE">전화</label>
        </div>
        <div class="flex-grow-1">
          <div class="input-group">
            <input type="text" class="form-control method-detail" placeholder="전화 면접에 대한 추가내용이 있다면 작성하세요..." data-method="PHONE" style="display: none;">
            <button type="button" class="btn btn-primary save-method-btn" data-method="PHONE" style="display: none;">저장</button>
          </div>
        </div>
      </div>
    </div>

    
    <div class="col-12 mb-2 parttime-only" id="textOption">
      <div class="d-flex align-items-center">
        <div class="form-check me-3 d-flex align-items-center">
          <input class="form-check-input application-checkbox" type="checkbox" id="TEXT" value="TEXT">
          <label class="form-check-label ms-2" for="TEXT">문자</label>
        </div>
        <div class="flex-grow-1">
          <div class="input-group">
            <input type="text" class="form-control method-detail" placeholder="" data-method="TEXT" style="display: none;">
            <button type="button" class="btn btn-primary save-method-btn" data-method="TEXT" style="display: none;">저장</button>
          </div>
        </div>
      </div>
    </div>
  `;

  if (selectedWorkType === "PARTTIME") {
    if ($("#phoneOption").length === 0 && $("#textOption").length === 0) {
      $("#application-methods").append(phoneAndTextHtml);
    }
  } else {
    $(".parttime-only").remove();
  }
});

		
		
		// class = "Region" 값이 바뀌면.. 
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
		
		// class = "MajorCategory" 값이 바뀌면.. 
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
		
		// class = "SubCategory" 값이 바뀌면.. 
		$(document).on("change", ".SubCategory", function() {
			let selectedSubCategory = $(this).val();
			console.log("선택한 직업:", selectedSubCategory);

			if (selectedSubCategory !== "-1") {
				saveSubCategory(selectedSubCategory);
			}
		});
		
		// class = ".application-checkbox" 값이 바뀌면.. 
		$(document).on("change", ".application-checkbox", function () {
  let method = $(this).val();
  let checked = $(this).is(":checked");

  if (checked) {
    $(`.method-detail[data-method='\${method}']`).show();
    $(`.save-method-btn[data-method='\${method}']`).show();
  } else {
    $(`.method-detail[data-method='\${method}']`).hide().val('');
    $(`.save-method-btn[data-method='\${method}']`).hide();
    deleteApplication(method);
  }
});
// 저장버튼을 누르면
$(document).on("click", ".save-method-btn", function () {
  const method = $(this).data("method");
  const detail = $(`.method-detail[data-method='\${method}']`).val() || "";

  // 상세 정보는 입력하지 않아도 된다.

  saveApplication(method, detail);
 

});

//모달이 닫힐 때 focus 처리
$("#MyModal").on("hidden.bs.modal", function () {
  if (focusElement) {
    setTimeout(() => {
      focusElement.focus();
    }, 100); // 살짝 delay 주는 게 안정적입니다.
  }
});

// 모달 닫기 버튼들 이벤트 연결 (이미 부트스트랩의 data-bs-dismiss가 있지만 focus 처리를 위해 명시적으로 선언)
$(".returnList, .btn-close, .btn-secondary").on("click", function () {
  // 닫기 전에 외부 포커스로 옮기기
  if (focusElement) {
    focusElement.focus();
  }

  $("#MyModal").modal("hide");
});
		
	$(document).on("blur", "#title", function() {
		const titleLength = $(this).val().length;
		if(titleLength <= 0 || titleLength >= 190) {
			$(this).focus();
		}
	});

	$(document).on("blur", ".MajorCategory", function() {
		if($(this).val() == -1) {
			$(this).focus();
		}
	});

	$(document).on("blur", ".SubCategory", function() {
		if($(this).val() == -1) {
			$(this).focus();
		}
	});

	$(document).on("blur", ".Region", function() {
		if($(this).val() == -1) {
			$(this).focus();
		}
	});	

	$(document).on("blur", ".Sigungu", function() {
		if($(this).val() == -1) {
			$(this).focus();
		}
	});	

	$(document).on("blur", "#pay", function() {
		if($(this).val() <= 0) {
			$(this).focus();
		}
	});
	
	});

// 파일 업로드 + 썸네일 표시
function uploadFileAndShowPreview(file) {
    const formData = new FormData();
    formData.append("file", file);

    $.ajax({
        url: "/recruitmentnotice/rest/file",
        type: "POST",
        data: formData,
        contentType: false,
        processData: false,
        success: function(response) {
            console.log("업로드 성공", response);
            showThumbnail(file);
        },
        error: function() {
            alert("파일 업로드 실패");
        }
    });
}

// 썸네일 출력 함수
function showThumbnail(file) {
    const reader = new FileReader();
    reader.onload = function(e) {
        const isImage = file.type.startsWith("image/");
        const base64 = e.target.result;

        const safeId = file.name.replace(/[^a-zA-Z0-9]/g, "_");

        let html = `
            <tr id="thumb_\${safeId}">
                <td><img src="\${isImage ? base64 : '/resources/images/noimage.png'}" width="60" /></td>
                <td\>${file.name}</td>
                <td>
                    <button type="button" class="btn btn-sm btn-danger" onclick="removeFile('\${file.name}')">X</button>
                </td>
            </tr>
        `;
        $(".preview").append(html);
    };
    reader.readAsDataURL(file);
}

// 파일 삭제 함수
function removeFile(fileName) {
    $.ajax({
        url: "/recruitmentnotice/rest/file",
        type: "DELETE",
        data: { removeFileName: fileName },
        success: function(response) {
            console.log("삭제 성공", response);
            const safeId = fileName.replace(/[^a-zA-Z0-9]/g, "_");
            $(`#thumb_${safeId}`).remove();
        },
        error: function() {
            alert("파일 삭제 실패");
        }
    });
}

function markUploadSuccess(fileName) {
    const safeId = CSS.escape(fileName);
    document.querySelector(`#\${safeId}`).insertAdjacentHTML(
      "beforeend",
      "<td><img src='/resources/images/success.png' width='20'></td>"
    );
}


	// 면접타입 유효성 검사
	function isValidApplication() {
  let checked = $(".application-checkbox:checked").length;
  if (checked === 0) {
    alert("면접방식을 최소 하나 이상 선택해주세요.");
    return false;
  }
  return true;
}

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
							.append(`<option value="\${majorCategory.majorcategoryNo}">
									\${majorCategory.jobName} </option>`);
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
							.append(`<option value="\${subCategory.subcategoryNo}">
									\${subCategory.jobName}</option>`);
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
		$.ajax({
			url : '/region/sigungu/' + regionNo,
			type : 'get',
			dataType : 'json',
			async : false,
			success : function(data) {
				console.log("시군구 데이터:", data);
				let sigunguSelect = $(".Sigungu");
				sigunguSelect.empty();
				sigunguSelect.append('<option value="-1">시군구 선택</option>');
						$.each(data, function(index, sigungu) 
						{sigunguSelect.append(`<option value="\${sigungu.sigunguNo} ">\${sigungu.name} </option>`);});
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



}

function submitRecruitmentNotice(title, workType, payType, pay, period, militaryService, dueDate, detail, personalHistory, manager, refCompany) {
	$.ajax({
      url: "/recruitmentnotice/rest/" + refCompany, // 일단 대충 1 나중에 input hidden에 sessionScope.loginmember.uid 
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify({
        "title" : title,
		"workType" : workType,
		"payType" : payType,
		"pay" : pay,
		"period" : period,
		"personalHistory" : personalHistory,
		"militaryService" : militaryService,
		"detail" : detail,
		"manager" : manager,
		"dueDate" : dueDate,
		
		
      }),
      success: function (data) {
        console.log(data)

		$("#successModal").modal("show");
      },
      error: function () {
        alert(`${method} 방식 저장 실패`);
      }

 
 });
}

function formatPay(input) {
    // 숫자만 추출
    let value = input.value.replace(/[^0-9]/g, '');
    
    // 최대 2,000,000,000 제한
    if (parseInt(value) > 2000000000) {
      value = "2000000000";
    }

    // 쉼표 추가
    input.value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

  // 숫자 데이터 전송을 위해 쉼표 제거 함수 (폼 제출 시 사용)
  function getRawPay() {
    return document.getElementById("pay").value.replaceAll(",", "");
  }

function isValidRecruitmentForm() {
	let result = true;

 	 const title = $("#title").val();
 	 const workType = $("input[name='workType']:checked").val();
 	 const payType = $("input[name='payType']:checked").val();
 	 const pay = getRawPay();
 	 const militaryService = $("input[name='militaryService']:checked").val();
  	const dueDate = $("#date").val();
  	const detail = $("#summernote").val();
  	const sigungu = $(".Sigungu").val();
  	const subCategory = $(".SubCategory").val();
  	const majorCategory = $(".MajorCategory").val();
  	const region = $(".Region").val();
  	const period = $("#startTime").val() + "~" + $("#endTime").val();
  	const startTime = $("#startTime").val();
  	const endTime = $("#endTime").val();
  	const personalHistory = $("input[name='personalHistory']:checked").val();
 	const manager = $("#manager").val();
  	const refCompany = $("#refCompany").val();
 

  console.log(period);

  

  if (!title || title.length > 190) { // 완
    errorMessage = "공고 제목을 입력해주세요.";
    focusElement = $("#title");
	result = false;
  } else if (!majorCategory || majorCategory === "-1") { // 완
    errorMessage = "산업군을 선택해주세요.";
    focusElement = $(".MajorCategory");
	result = false;
  } else if (!subCategory || subCategory === "-1") { // 완
    errorMessage = "직업(세부직종)을 선택해주세요.";
    focusElement = $(".SubCategory");
	result = false;
  } else if (!region || region === "-1") { // 완
    errorMessage = "도시를 선택해주세요.";
    focusElement = $(".Region");
	result = false;
  } else if (!sigungu || sigungu === "-1") { // 완
    errorMessage = "시군구를 선택해주세요.";
    focusElement = $(".Sigungu");
	result = false;
  } else if (!$("input[name='workType']:checked").length) {
    errorMessage = "근무형태를 선택해주세요.";
    focusElement = $("input[name='workType']").first();
    result = false;
  } else if (!$("input[name='payType']:checked").length) {
    errorMessage = "급여 유형을 선택해주세요.";
    focusElement = $("input[name='payType']").first();
    result = false;
  } else if (!pay || pay <= 0) { // 완
    errorMessage = "급여 금액을 입력해주세요.";
    focusElement = $("#email");
	result = false;
  } else if (!startTime || !endTime) {  // 완
    errorMessage = "근무시간을 입력해주세요.";
    if(!startTime) {	
		focusElement = $("#startTime");
	} else {
		focusElement = $("#endTime");
	}
	result = false;
  } else if (!personalHistory) { // 완
	errorMessage = "경력사항을 입력해주세요.";
    focusElement = $("#personalHistory");
	result = false;
  } else if (!militaryService) { // 완
    errorMessage = "병역 사항을 선택해주세요.";
	result = false;
  } else if (!dueDate) { // 알아서 된다...
    errorMessage = "마감 기한을 선택해주세요.";
    focusElement = $("#date");
	result = false;
  } else if (!manager || manager.length > 10) { // 완
    errorMessage = "담당자를 입력해주세요.";
    focusElement = $("#manager");
	result = false;
  } else if(!isValidApplication()) {
	errorMessage = "면접방식을 선택해주세요."; 
    focusElement = $(".SubCategory");
	result = false;
  } 

  if (errorMessage) {
  $(".modal-body").text(errorMessage);

  // 모달이 다 보여진 후에 focus 실행
  $("#MyModal").on("shown.bs.modal", function () {
    if (focusElement) {
      focusElement.focus();
    }
  });
  result = false;
  $("#MyModal").modal("show");
}

  // 면접 방식 유효성 검사도 포함
  
  if(result){
	submitRecruitmentNotice(title, workType, payType, pay, period, militaryService, dueDate, detail, personalHistory, manager, refCompany);
}

}




</script>

<style>
.form-check-input {
	width: 18px;
	height: 18px;
	margin-top: 0 !important;
	margin-bottom: 0 !important;
}

.form-check-label {
	margin-bottom: 0 !important;
	line-height: 1.5;
}
</style>

<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>

	<!-- 입력받을 form 태그 -->
	<!-- Blog Comment Form Section -->
	<section id="blog-comment-form" class="blog-comment-form section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<!-- 일단 /recruitmentnotice/rest/ 뒤의 값을 1번으로 해둠 나중 되면 el표현식으로 sessionScope.loginmember.uid로 바꾸자.. -->
			<form method="post" role="form">

				<div class="form-header">
					<h3>채용 공고</h3>
					<p>Your email address will not be published. Required fields
						are marked *</p>
				</div>

				<div class="row gy-3">
					<div class="col-md-6">
						<div class="input-group">
							<label for="name" class="form-check-label">회사명</label> <input
								type="text" id="Companyname" placeholder="Enter your full name"
								required="" readonly="true" value="${sessionScope.account.accountName}">

						</div>
					</div>

					<div class="col-md-6">
						<div class="input-group">
							<label for="email" class="form-check-label">작성자*</label> <input
								type="email" id="writer" placeholder="Enter your email address"
								required="" readonly="true" value="${sessionScope.account.accountId}"> 

						</div>
					</div>
					<input type="hidden" id="refCompany" value="1">
					<div class="col-12">
						<div class="input-group">
							<label for="website" class="form-check-label">공고 제목</label> <input
								type="text" name="title" id="title"
								placeholder="게시글 제목을 입력해 주세요">
						</div>
					</div>


					<div class="col-12">
						<div class="input-group">
							<label for="majorCategory" class="form-check-label">산업군</label> <select
								class="MajorCategory form-select" id="MajorCategory">

							</select>
						</div>

						<div class="col-12">
							<div class="input-group">
								<label for="subCategory" class="form-check-label">직종</label> <select
									class="SubCategory form-select" id="SubCategory">

								</select>
							</div>

							<div class="col-12">
								<div class="input-group">
									<label for="region" class="form-check-label">도시</label> <select
										class="Region form-select" id="regionList">

									</select>
								</div>
								<input type="hidden" id="region">
								<div class="col-12">
									<div class="input-group">
										<label for="sigungu" class="form-check-label">시군구</label> <select
											class="Sigungu form-select" id="sigunguList">

										</select>
									</div>
									<input type="hidden" id="sigungu">

									<div class="col-12">
										<label for="workType1" class="form-check-label mb-2"
											style="color: #37517e;">근무형태</label>
										<div class="d-flex flex-wrap gap-3">
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType1" value="FULLTIME"> <label
													class="form-check-label mb-2" for="workType1">정규직</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType2" value="NONREGULAR">
												<label class="form-check-label mb-2" for="workType2">비정규직</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType3" value="APPOINT"> <label
													class="form-check-label mb-2" for="workType3">위촉직</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType4" value="PARTTIME"> <label
													class="form-check-label mb-2" for="workType4">아르바이트</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType5" value="FREELANCER">
												<label class="form-check-label mb-2" for="workType5">프리랜서</label>
											</div>
										</div>
									</div>




									<div class="col-12">
										<label for="payType1" class="form-check-label mb-2"
											style="color: #37517e;">급여형태</label>
										<div class="d-flex flex-wrap gap-3 payType">
											<div class="form-check">
												<input class="form-check-input" type="radio" name="payType"
													id="payType1" value="HOUR"> <label
													class="form-check-label mb-2" for="payType1">시급</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio" name="payType"
													id="payType2" value="DATE"> <label
													class="form-check-label mb-2" for="payType2">일급</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio" name="payType"
													id="payType3" value="WEEK"> <label
													class="form-check-label mb-2" for="payType3">주급</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio" name="payType"
													id="payType4" value="MONTH"> <label
													class="form-check-label mb-2" for="payType4">월급</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio" name="payType"
													id="payType5" value="YEAR"> <label
													class="form-check-label mb-2" for="payType5">연봉</label>
											</div>
										</div>
									</div>

									<div class="col-md-6">
										<div class="input-group">
											<label for="pay" class="form-check-label mb-2">급여 액수</label>
											<input type="text" id="pay" maxlength="15"
												placeholder="숫자만 입력할 수 있습니다." oninput="formatPay(this)">
										</div>
									</div>

									<div class="col-md-6">
										<div class="input-group">

											<label for="endTime" class="form-check-label mb-2">근무시간</label>
											<input type="time" id="startTime"> <input type="time"
												id="endTime">
											<!-- 해야할 것 : 격일, 격주, 2교대 등 근무 시간에 대한 상세 내용 -->
										</div>
									</div>


									<div class="col-12">
										<label for="military1" class="form-check-label mb-2"
											style="color: #37517e;">병역 사항</label>
										<div class="d-flex flex-wrap gap-3" id="militaryService">
											<div class="form-check">
												<input class="form-check-input" type="radio"
													name="militaryService" id="military1" value="NOT_COMPLETED">
												<label class="form-check-label mb-2" for="military1">미필
													이상</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio"
													name="militaryService" id="military2" value="COMPLETED">
												<label class="form-check-label mb-2" for="military2">군필
													이상</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio"
													name="militaryService" id="military3" value="EXEMPTED">
												<label class="form-check-label mb-2" for="military3">면제
													이상</label>
											</div>
										</div>
									</div>

									<div class="col-12 mb-3">
										<label class="form-label w-100 mb-3" style="color: #37517e;">접수
											방법</label>
										<div class="row" id="application-methods">


											<div class="col-12 mb-2">
												<div class="d-flex align-items-center">
													<div class="form-check me-3 d-flex align-items-center">
														<input class="form-check-input application-checkbox"
															type="checkbox" id="ONLINE" value="ONLINE"> <label
															class="form-check-label ms-2" for="ONLINE">온라인</label>
													</div>
													<div class="flex-grow-1">
														<div class="input-group">
															<input type="text" class="form-control method-detail"
																placeholder="온라인 면접에 대한 추가내용이 있다면 작성하세요..."
																data-method="ONLINE" style="display: none;">
															<button type="button"
																class="btn btn-primary save-method-btn"
																data-method="ONLINE" style="display: none;">저장</button>
														</div>
													</div>
												</div>
											</div>

											<!-- 2. 이메일 -->
											<div class="col-12 mb-2">
												<div class="d-flex align-items-center">
													<div class="form-check me-3 d-flex align-items-center">
														<input class="form-check-input application-checkbox"
															type="checkbox" id="EMAIL" value="EMAIL"> <label
															class="form-check-label ms-2" for="EMAIL">이메일</label>
													</div>
													<div class="flex-grow-1">
														<div class="input-group">
															<input type="email" class="form-control method-detail"
																placeholder="이메일 면접에 대한 추가내용이 있다면 작성하세요..."
																data-method="EMAIL" style="display: none;">
															<button type="button"
																class="btn btn-primary save-method-btn"
																data-method="EMAIL" style="display: none;">저장</button>
														</div>
													</div>
												</div>
											</div>


										</div>
									</div>

									<div class="col-12">
										<label class="form-check-label mb-2" style="color: #37517e;">경력사항</label>
										<div class="d-flex flex-wrap gap-3" id="personalHistory">
											<div class="form-check">
												<input class="form-check-input" type="radio"
													name="personalHistory" id="newbie" value="신입"> <label
													class="form-check-label mb-2" for="newbie">신입</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio"
													name="personalHistory" id="year3" value="3년차"> <label
													class="form-check-label mb-2" for="year3">3년차</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio"
													name="personalHistory" id="year5" value="5년차"> <label
													class="form-check-label mb-2" for="year5">5년차</label>
											</div>
											<div class="form-check">
												<input class="form-check-input" type="radio"
													name="personalHistory" id="year7plus" value="7년차 이상">
												<label class="form-check-label mb-2" for="year7plus">7년차
													이상</label>
											</div>
										</div>
									</div>


									<div class="col-12">
										<div class="input-group">
											<label for="advantage" class="form-check-label mb-2">우대조건</label>
											<input type="text" id="advantage"
												placeholder="우대조건을 입력하고 저장 버튼을 눌러주세요..">
											<button type="button" class="addAdvantageBtn"
												onclick="addAdvantage()">저장하기</button>
										</div>
										<div class="advantageArea"></div>
									</div>

									<div class="col-md-6 dueDate">
										<div class="input-group">
											<label for="date" class="form-check-label mb-2">마감 기한</label>
											<input type="date" id="date">
										  </div>
									</div>

									<div class="col-12">
										<div class="input-group flex-column">
											<label for="summernote" class="form-check-label mb-2">상세
												내용</label>
											<textarea id="summernote" name="detail"></textarea>
										</div>
									</div>

									<div class="col-md-6">
										<div class="input-group">
											<label for="manager" class="form-check-label">담당자</label> <input
												type="text" id="manager" placeholder="담당자를 입력해주세요">

										</div>
									</div>

									<label for="files">추가로 올릴 자료가 있으면 하단의 박스에 드래그드롭 하세요.</label>
									<div class="col-12">
										<div class="input-group fileUploadArea" id="files"
											style="width: 800px; height: 80px; background-color: #eee; border-radius: 10px;">


										</div>
									</div>
									<div class="col-12 text-center">
										<table class="preview mt-3"></table>
									</div>


									<div class="col-12 text-center">

										<button type="button" id="write"
											onclick="isValidRecruitmentForm()">작성</button>
									</div>
								</div>
			</form>

			<!-- Modal -->
			<div class="modal fade" id="MyModal" tabindex="-1"
				aria-labelledby="MyModal" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="recruitmentModalLabel"></h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close"></button>
						</div>
						<div class="modal-body"></div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-primary returnList"
								data-bs-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>

			<!-- 작성 완료 모달 -->
			<div class="modal fade" id="successModal" tabindex="-1"
				aria-labelledby="successModalLabel" aria-hidden="true">
				<div class="modal-dialog modal-dialog-centered">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="successModalLabel">작성 완료</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="닫기"></button>
						</div>
						<div class="modal-body">채용 공고가 성공적으로 작성되었습니다.</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-primary" id="goToListBtn">확인</button>
						</div>
					</div>
				</div>
			</div>


		</div>

	</section>
	<!-- /Blog Comment Form Section -->

	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>