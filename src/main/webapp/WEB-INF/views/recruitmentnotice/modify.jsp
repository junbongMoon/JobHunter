<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
	let uid = '${RecruitmentDetailInfo.uid}';
	let companyUid = '${sessionScope.account.uid}';
	let applications;

	

	$(function() {

		console.log("작성한 회사 uid : " + companyUid);
		const today = new Date();
		today.setHours(0,0,0,0); // 오늘 자정으로 설정
    const nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 1);

    // yyyy-MM-dd 포맷으로 변환
    function formatDate(date) {
        const yyyy = date.getFullYear(); // ex : 2025
        const mm = String(date.getMonth() + 1).padStart(2, '0'); // ex : 04
        const dd = String(date.getDate()).padStart(2, '0'); // ex : 03
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
		
		// 기존 공고값 세팅
		setTimeout(() => {
      const title = '${RecruitmentDetailInfo.title}';
      const workType = '${RecruitmentDetailInfo.workType}';
      const payType = '${RecruitmentDetailInfo.payType}';
      const pay = '${RecruitmentDetailInfo.pay}';
      const period = '${RecruitmentDetailInfo.period}';
      const personalHistory = '${RecruitmentDetailInfo.personalHistory}';
      const militaryService = '${RecruitmentDetailInfo.militaryService}';
      const detail = `<c:out value='${RecruitmentDetailInfo.detail}' escapeXml='false'/>`;
      const manager = '${RecruitmentDetailInfo.manager}';
      const dueDate = '<fmt:formatDate value="${RecruitmentDetailInfo.dueDate}" pattern="yyyy-MM-dd"/>';
      const regionNo = '${RecruitmentDetailInfo.region.regionNo}';
      const sigunguNo = '${RecruitmentDetailInfo.sigungu.sigunguNo}';
      const majorcategoryNo = '${RecruitmentDetailInfo.majorCategory.majorcategoryNo}';
      const subcategoryNo = '${RecruitmentDetailInfo.subcategory.subcategoryNo}';

	  // workType이 PART_TIME이면 PHONE, TEXT DOM 추가
if (workType === "PART_TIME") {
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
  $("#application-methods").append(phoneAndTextHtml);


}

	  console.log("선택한 시군구, 직업군 : " + sigunguNo, subcategoryNo);

      // 제목, 담당자, 날짜 등 텍스트 필드 세팅
      $('#title').val(title);
      $('#pay').val(Number(pay).toLocaleString());
      $('#manager').val(manager);
      $('#date').val(dueDate);

      // summernote 내용 세팅
      $('#summernote').summernote('code', detail);

      // 라디오 세팅
      $(`input[name="workType"][value="${workType}"]`).prop("checked", true).trigger("change");
      $(`input[name="payType"][value="${payType}"]`).prop("checked", true);
      $(`input[name="personalHistory"][value="${personalHistory}"]`).prop("checked", true);
      $(`input[name="militaryService"][value="${militaryService}"]`).prop("checked", true);


	  
	  const jsonStr = '<c:out value="${applicationsJson}" escapeXml="false" />';
	  
  try {
    
    if (jsonStr && jsonStr.trim().length > 0) {
      applications = JSON.parse(jsonStr);
	  console.log(jsonStr);
    }
  } catch (e) {
    console.error("applicationsJson 파싱 오류:", e);
  }


console.log("applicationsJson raw:", jsonStr);
console.log("parsed applications:", applications);
      // 셀렉트 필드 세팅 (선택 후 로딩 기다림)
      setTimeout(() => {
  $(".Region").val(regionNo).trigger("change");
  setTimeout(() => {
    getSigungu(regionNo);
    setTimeout(() => {
      $(".Sigungu").val(sigunguNo).trigger("change");
    }, 400);
  }, 200);

      setTimeout(() => {
        $(".MajorCategory").val(majorcategoryNo).trigger("change");
        setTimeout(() => {
    getSubCategory(majorcategoryNo);
    setTimeout(() => {
      $(".SubCategory").val(subcategoryNo).trigger("change");

	  setTimeout(() => {
    renderApplicationMethods(applications);
  }, 500);


    }, 1000);
 	 }, 200);
	}, 300);



      // 근무 시간 분해
      const timeRegex = /^(\d{2}:\d{2})~(\d{2}:\d{2})(?: \((.+)\))?$/;
      const match = period.match(timeRegex);
      if (match) {
        const [, startTime, endTime, detailType] = match;
        $('#startTime').val(startTime);
        $('#endTime').val(endTime);
        if (detailType) $('#workDetailType').val(detailType);
      }
    }, 300);

	

    // 이벤트 위임으로 동적 삭제 처리
    $(document).on("click", ".advantage-item .btn-outline-danger", function () {
      const $item = $(this).closest(".advantage-item");
      const advantageType = $item.find("input[type='hidden']").val();
      if (!advantageType) return;

      $.ajax({
        url: "/recruitmentnotice/advantage/" + advantageType,
        type: "DELETE",
        success: function () {
          console.log("삭제 성공: ", advantageType);
          $item.remove();
        },
        error: function () {
          console.error("삭제 실패: ", advantageType);
        }
      });
    });

    // 우대조건 추가 처리
    $(".addAdvantageBtn").on("click", function () {
      const val = $("#advantage").val().trim();
      if (!val) return alert("우대조건을 입력해주세요");

      $.ajax({
        url: "/recruitmentnotice/advantage",
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify({ advantageType: val }),
        success: function () {
          const html = `
            <div class="d-flex align-items-center mb-2 advantage-item">
              <input type="hidden" value="${val}">
              <span class="me-2">${val}</span>
              <button type="button" class="btn btn-sm btn-outline-danger">X</button>
            </div>
          `;
          $(".advantageArea").append(html);
          $("#advantage").val("");
        },
        error: function () { alert("우대조건 저장 실패"); }
      });
    });
		

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
  location.href = "./listAll";
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

  if (selectedWorkType === "PART_TIME") {
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
						$("#regionNo").val(selectedRegion);
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
				$("#sigunguNo").val(selectedSigungu);
			}
		});
		
		// class = "MajorCategory" 값이 바뀌면.. 
		$(document).on(
				"change",
				".MajorCategory",
				function() {
					let selectedMajorNo = $(this).val();
					console.log("선택한 산업군:", selectedMajorNo);

					if (selectedMajorNo !== "-1") {
						$("#majorcategoryNo").val(selectedMajorNo); 
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
				$("#subcategoryNo").val(selectedSubCategory);
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
	
	instalRecruitment();

	}, 500);

});


// 수정 페이지에 들어왔을 때 공고의 정보를 입력해주는 함수
function instalRecruitment() {
	const title = '${RecruitmentDetailInfo.title}';
	const workType = '${RecruitmentDetailInfo.workType}';
	const payType = '${RecruitmentDetailInfo.payType}';
	const pay = '${RecruitmentDetailInfo.pay}';
	const period = '${RecruitmentDetailInfo.period}';
	const personalHistory = '${RecruitmentDetailInfo.personalHistory}';
	const militaryService = '${RecruitmentDetailInfo.militaryService}';
	const detail = '${RecruitmentDetailInfo.detail}';
	const manager = '${RecruitmentDetailInfo.manager}';
	const dueDate = '<fmt:formatDate value="${RecruitmentDetailInfo.dueDate}" pattern="yyyy-MM-dd"/>'; // JSTL 형식 유지
	const regionNo = '${RecruitmentDetailInfo.region.regionNo}';
	const sigunguNo = '${RecruitmentDetailInfo.sigungu.sigunguNo}';
	const majorcategoryNo = '${RecruitmentDetailInfo.majorCategory.majorcategoryNo}'
	const subcategoryNo = '${RecruitmentDetailInfo.subcategory.subcategoryNo}'

	// 입력 값 세팅
	$('#title').val(title);
	$(`input[name="workType"][value="\${workType}"]`).prop("checked", true).trigger("change");
	$(`input[name="payType"][value="\${payType}"]`).prop("checked", true);
	$('#pay').val(pay.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 쉼표 추가
	$(`input[name="personalHistory"][value="\${personalHistory}"]`).prop("checked", true);
	$(`input[name="militaryService"][value="\${militaryService}"]`).prop("checked", true);
	$('#summernote').summernote('code', detail);
	$('#manager').val(manager);
	$('#date').val(dueDate);
	$('#regionNo').val(regionNo);
	$('#sigunguNo').val(sigunguNo);
	$('#majorcategoryNo').val(majorcategoryNo);
	$('#subcategoryNo').val(subcategoryNo);

	// 근무 시간 분해 (예: "08:00~17:00 (주 5일제)")
	const timeRegex = /^(\d{2}:\d{2})~(\d{2}:\d{2})(?: \((.+)\))?$/;
	const match = period.match(timeRegex);

	if (match) {
		const [, startTime, endTime, detailType] = match;
		$('#startTime').val(startTime);
		$('#endTime').val(endTime);
		if (detailType) {
			$('#workDetailType').val(detailType);
		}
	}
}
	

// 파일 업로드 + 썸네일 표시
function uploadFileAndShowPreview(file) {
    const formData = new FormData();
    formData.append("file", file);

    $.ajax({
        url: "/recruitmentnotice/file",
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
        url: "/recruitmentnotice/file",
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

// 면접 타입 로드
function renderApplicationMethods(applications) {
  applications.forEach(app => {
    const method = app.method;
    const detail = app.detail;

    const checkbox = $(`.application-checkbox[value="\${method}"]`);
    const detailInput = $(`.method-detail[data-method="\${method}"]`);
    const saveBtn = $(`.save-method-btn[data-method="\${method}"]`);

    if (checkbox.length) {
      checkbox.prop("checked", true);
      detailInput.show().val(detail || '');
      saveBtn.show();
    } else {
      console.warn(`체크박스 없음: \${method}`);
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
      url: "/recruitmentnotice/application",
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
      url: "/recruitmentnotice/application",
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
						{sigunguSelect.append(`<option value="\${sigungu.sigunguNo}">\${sigungu.name}</option>`);});
					},
			error : function(err) {
				console.error("시군구 데이터 불러오기 실패", err);
					}
			});
	}



	function removeAdvantage(deleteBtn) {
    let advantageType = $(deleteBtn).siblings("input[type='hidden']").val();

    $.ajax({
        url: "/recruitmentnotice/advantage/" + advantageType,
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
        url: "/recruitmentnotice/advantage",
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
  	const workDetailType = $("#workDetailType").val();

  	const startTime = $("#startTime").val();
  	const endTime = $("#endTime").val();
  	const personalHistory = $("input[name='personalHistory']:checked").val();
 	const manager = $("#manager").val();
  	const refCompany = $("#refCompany").val();
	  let period = startTime + "~" + endTime;
if (workDetailType) {
  period += " (" + workDetailType + ")";
}

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
	// period 히든에 넣어주자
	mjrno = $("#majorcategoryNo").val();

	console.log(mjrno);
	$("#period").val(period);

	return result;
	}
return result;
}

function instalSelectOptions(){

	// 셀렉트 리스트 들
	let majorCategoryList = $('#MajorCategory');
	let subCategoryList = $('#SubCategory');
	let regionList = $('#regionList');
	let sigunguList = $('#sigunguList');

	// 셀렉트 리스트에 넣을 변수
	const regionNo = '${RecruitmentDetailInfo.region.regionNo}';
	const sigunguNo = '${RecruitmentDetailInfo.sigungu.sigunguNo}';
	const majorcategoryNo = '${RecruitmentDetailInfo.majorCategory.majorcategoryNo}'
	const subcategoryNo = '${RecruitmentDetailInfo.subcategory.subcategoryNo}'

	


}



</script>

<style>
form {
    max-width: 700px;
    margin: 0 auto;
  }

label {
    display: block;
    font-weight: 500;
    margin-bottom: 0.5rem;
    color: #37517e;
  }

  .custom-select-wrapper {
  display: flex;
  flex-direction: column;
  margin-bottom: 1.5rem;
}

/* 라벨 간격 조절 (상단 마진 추가) */
.custom-select-wrapper label {
  margin-bottom: 0.6rem;
  margin-top: 1rem;  
  font-size: 1rem;
  font-weight: 600;
  color: #37517e;
}

/* 박스형 셀렉트 */
.form-select {
  appearance: none;
  background-color: #fff;
  border: 1px solid #cfd8dc;
  padding: 0.9rem 1rem;
  font-size: 1rem;
  border-radius: 1rem;
  background-image: url('data:image/svg+xml;utf8,<svg fill="%23444" height="24" viewBox="0 0 24 24" width="24"><path d="M7 10l5 5 5-5z"/></svg>');
  background-repeat: no-repeat;
  background-position: right 1rem center;
  background-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
  max-width: 100%;
  width: 100%;
}

  .form-control, .form-select {
    width: 100%;
    max-width: 100%;
    border-radius: 0.75rem;
    padding: 0.6rem 1rem;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    background-color: #fff;
    border: 1px solid #ced4da;
  }

  .form-select:focus, .form-control:focus {
    border-color: #4e73df;
    box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
	outline: none;
  }

  .form-section {
    max-width: 600px;
    margin: 0 auto;
  }

  label.form-check-label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #37517e;
  }

  .input-group {
    margin-bottom: 1.5rem;
  }

  .addAdvantageBtn, #write {
  background-color: var(--accent-color);
  color: white;
  border: none;
  border-radius: 0.75rem;
  padding: 0.5rem 1.2rem;
  font-weight: 500;
  transition: background-color 0.3s ease;
  float: right;
  margin-top: 0.5rem;
}

.addAdvantageBtn:hover, #write {
  background-color: #298ce7; /* 진한 하늘색 hover 효과 */
}
</style>

<body>
	<!-- 헤더 -->
	<jsp:include page="../header.jsp"></jsp:include>

	<!-- 입력받을 form 태그 -->
	<!-- Blog Comment Form Section -->
	<section id="blog-comment-form" class="blog-comment-form section">

		<div class="container" data-aos="fade-up" data-aos-delay="100">
			
			<form method="post" role="form" action="/recruitmentnotice/modify?uid=${RecruitmentDetailInfo.uid}">

				<div class="form-header categories-widget widget-item">
					<h3>채용 공고</h3>
					<p>하단에 정보를 입력해주세요</p>
				</div>
				<input type="hidden" id="refCompany" name="refCompany" value="1"><!-- 내일 근우씨한테 물어봐서 회사 uid 값 넣기 -->
				<div class="row gy-3">
					<div class="col-md-6">
						<div class="input-group">
							<label for="name" class="form-check-label">회사명</label> <input
								type="text" id="Companyname" placeholder="Enter your full name"
								required="" readonly="true"
								value="${sessionScope.account.accountName}">

						</div>
					</div>

					<div class="col-md-6">
						<div class="input-group">
							<label for="email" class="form-check-label">작성자</label> <input
								type="email" id="writer" placeholder="Enter your email address"
								required="" readonly="true"
								value="${sessionScope.account.accountId}">

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


					<div class="form-section">
						<div class="custom-select-wrapper">
							<label for="MajorCategory">산업군</label>
							<select class="MajorCategory form-select" id="MajorCategory">
							  
							</select>
						  </div>
						  <input type="hidden" id="majorcategoryNo" name="majorcategoryNo">
						
						  <div class="custom-select-wrapper">
							<label for="subCategory">직종</label>
							<select class="SubCategory form-select" id="SubCategory">
							  
							</select>
						  </div>
						  <input type="hidden" id="subcategoryNo" name="subcategoryNo">
							
								<div class="custom-select-wrapper">
									<label for="region" class="form-check-label">도시</label> 
									<select class="Region form-select" id="regionList">

									</select>
								</div>
								<input type="hidden" id="regionNo" name="regionNo" >
								
								<div class="custom-select-wrapper">
									<label for="sigungu" class="form-check-label">시군구</label> 
									<select	class="Sigungu form-select" id="sigunguList">

									</select>
								</div>
							<input type="hidden" id="sigunguNo" name="sigunguNo">
					</div>
									

									<div class="col-12">
										<label for="workType1" class="form-check-label mb-2"
											style="color: #37517e;">근무형태</label>
										<div class="d-flex flex-wrap gap-3">
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType1" value="FULL_TIME"> <label
													class="form-check-label mb-2" for="workType1">정규직</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType2" value="CONTRACT">
												<label class="form-check-label mb-2" for="workType2">계약직</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType3" value="COMMISSION"> <label
													class="form-check-label mb-2" for="workType3">위촉직</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType4" value="PART_TIME"> <label
													class="form-check-label mb-2" for="workType4">아르바이트</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType5" value="FREELANCE">
												<label class="form-check-label mb-2" for="workType5">프리랜서</label>
											</div>
											<div class="form-check">
												<input class="form-check-input workType" type="radio"
													name="workType" id="workType6" value="DISPATCH">
												<label class="form-check-label mb-2" for="workType5">파견직</label>
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

									<div class="col-md-12">
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

									<div class="col-md-6">
										<div class="custom-select-wrapper">
											<label for="workDetailType">근무시간 상세</label> 
											<select class="form-select" id="workDetailType">
												<option value="주 5일제">주 5일제</option>
												<option value="2교대">2교대</option>
												<option value="3교대">3교대</option>
												<option value="격일근무">격일 근무</option>
												<option value="격주근무">격주 근무</option>
												<option value="야간근무">야간 근무</option>
												<option value="주말근무">주말 근무</option>
											</select>
										</div>
									</div>
									<input type="hidden" id="period" name="period">

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
											
										</div>
										<div class="text-end mb-3">
											<button type="button" class="addAdvantageBtn" onclick="addAdvantage()">저장하기</button>
										  </div>
										<div class="advantageArea">
											<c:forEach var="adv" items="${RecruitmentDetailInfo.advantage}">
    										<div class="d-flex align-items-center mb-2 advantage-item">
      										<input type="hidden" value="${adv.advantageType}">
      										<span class="me-2">${adv.advantageType}</span>
      										<button type="button" class="btn btn-sm btn-outline-danger">X</button>
    										</div>
  											</c:forEach>
											</div>
										</div>

									<div class="col-md-6 dueDate">
										<div class="input-group">
											<label for="date" class="form-check-label mb-2">마감 기한</label>
											<input type="date" id="date" name="dueDateForString">
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
												type="text" id="manager" name="manager" placeholder="담당자를 입력해주세요">

										</div>
									</div>

									<label for="files">추가로 올릴 자료가 있으면 하단의 박스에 드래그드롭 하세요.</label>
									<div class="col-12">
										<div class="input-group fileUploadArea" id="files"
											style="width: 100%; height: 80px; background-color: #eee; border-radius: 10px;">


										</div>
									</div>
									<div class="col-12 text-center">
										<table class="preview mt-3">
											<c:forEach var="file" items="${RecruitmentDetailInfo.fileList}">
   												<tr id="thumb_${file.originalFileName}">
      												<td><img src="/resources/recruitmentFiles/${file.newFileName}" width="60" /></td>
      												<td>${file.originalFileName}</td>
      												<td>
        											<button type="button" class="btn btn-sm btn-danger"
          											onclick="removeFile('${file.originalFileName}')">X</button>
      												</td>
    											</tr>
  											</c:forEach>
										</table>
									</div>


									<div class="col-12 text-center">

										<button type="submit" id="write"
											onclick="return isValidRecruitmentForm()">작성</button>
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

			


		</div>

	</section>
	<!-- /Blog Comment Form Section -->

	<!-- 풋터 -->
	<jsp:include page="../footer.jsp"></jsp:include>
	</div>
</body>
</html>