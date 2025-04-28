<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>

<script src="/resources/js/imgCompress.js"></script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>

<!-- Summernote CSS/JS (Bootstrap 4 기준) -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-lite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/lang/summernote-ko-KR.min.js"></script>

<!-- 이미지자르기 Cropper.js -->
<link rel="stylesheet" href="https://unpkg.com/cropperjs@1.5.13/dist/cropper.min.css">
<script src="https://unpkg.com/cropperjs@1.5.13/dist/cropper.min.js"></script>

<link href="/resources/css/companyInfo.css" rel="stylesheet">

<main class="main" data-aos="fade-up">
  <h1 class="page-title">회사 정보</h1>

  <div id="mypageContainer">
    <div class="sections-grid">

      <!-- 기본 정보 -->
      <section data-aos="fade-up" data-aos-delay="100" class="spacerContainer">
        <div class="section-title">
          <h2><i class="bi bi-person-circle section-icon"></i>기본 정보</h2>
        </div>
        <div style="cursor: pointer; border:1px solid var(--bs-gray-300); width: 240px; height: 240px; display: flex; justify-content: center; align-items: center; text-align: center;" onclick="cropImgModalOpen()" id="profileImgContainer"><span id="profileImg">이미지 로딩중...</span></div>
        <i style="margin:10px; color:var(--accent-color); cursor: pointer; max-width:90px;" onclick="deleteImgModal()">이미지 삭제</i><hr>
        <div class="info-grid" id="basicInfo">
          <div>회사명</div><div><strong id="companyName">로딩중...</strong></div>
          <div>대표자</div><div id="representative">로딩중...</div>
          <div>전화번호</div><div id="nowMobile">로딩중...</div>
          <div>이메일</div><div id="nowEmail">로딩중...</div>
          <div>가입일</div><div id="regDate">로딩중...</div>
          <div>최근 로그인</div><div id="lastLoginDate">로딩중...</div>
          <div id="accountDeleteDateTitle" style="color: var(--bs-red); font-size: 0.8em;"></div>
          <div id="accountDeleteDateBlock" style="color: var(--bs-red); font-size: 0.8em;"></div>
        </div>

        <div class="spacer">
        </div>
      
        <div class="edit-buttons">
        <button class="btn-edit" onclick="openContactModal()"><i class="bi bi-pencil-square"></i> 연락처 수정</button>
        <button class="btn-edit" onclick="openPasswordModal()"><i class="bi bi-key"></i> 비밀번호 변경</button>
        </div>
      </section>

      <!-- CompanyVO 상세 정보 섹션 -->
      <section data-aos="fade-up" data-aos-delay="150" class="spacerContainer">
        <div class="section-title">
          <h2><i class="bi bi-person-vcard section-icon"></i>상세 정보</h2>
        </div>
        <div class="info-grid" id="companyDetailInfo">
            <div>주소</div><div>로딩중...</div>
            <div>상세주소</div><div>로딩중...</div>
            <div>회사규모</div><div>로딩중...</div>
            <div>회사 홈페이지</div><div>로딩중...</div>
        </div>
            <div class="spacer">
        	</div>
            <div class="edit-buttons">
            <button class="btn-edit" onclick="modyfiInfoTapOpen(this)"><i class="bi bi-pencil-square"></i> 상세정보 수정</button>
            <button id="accountDeleteBtn" class="btn-edit btn-delete" style="background-color:#dc3545; margin-left: auto;" onclick="deleteAccount()"> 계정 삭제 신청</button>
            </div>
      </section>

      <!-- 공고 영역 -->
      <section data-aos="fade-up" data-aos-delay="300">
        <div class="section-title">
          <h2><i class="bi bi-file-earmark-text section-icon"></i>회사 소개</h2>
        </div>
        <div class="empty-state">
          <div class="introduce-section"><div id="introduce-content">로딩중...</div></div>
        </div>
      </section>
      
      <!-- CompanyVO 상세 정보 수정 섹션 -->
      <section data-aos="fade-up" data-aos-delay="200" style="display: none;" id="modifySection">
        <div class="section-title">
          <h2><i class="bi bi-person-vcard section-icon"></i>정보수정</h2>
        </div>
        <div id="userModifyTab">
          <div class="info-section">
            <h3 class="section-subtitle">기본 정보</h3>
            <div class="info-grid">

              <div>주소</div>
              <div>
                <div class="address-search-group">
                  <input type="text" class="form-control" id="addressSearch" placeholder="주소를 검색하세요">
                  <button class="btn-search" id="searchAddressBtn" onclick="searchAddress()">검색</button>
                </div>
                <div class="address-dropdown">
                  <ul id="addressSelect" class="address-dropdown-list">
                    <li class="address-dropdown-item" data-value="">주소를 선택하세요</li>
                  </ul>
                </div>
                <input type="text" class="form-control" id="selectedAddress" style="display: none;" readonly>
                  <input type="text" class="form-control" id="addressDetail" placeholder="상세주소를 입력하세요" style="display: none;" maxlength="190">
                  <div class="edit-buttons">
                    <button class="btn-search" id="resetAddressBtn" onclick="resetAddress()">초기화</button>
                    <button class="btn-cancel" id="deleteAddressBtn" onclick="deleteAddress()">주소 삭제</button>
                  </div>
                  <input type="hidden" id="addressBackup">
                  <input type="hidden" id="detailAddressBackup">
              </div>
              
              <div>회사규모</div>
              <div>
                <select class="form-control" id="scale">
                  <option value="-1" style="display: none;">선택하세요</option>
                  <option value="중소기업">중소기업</option>
                  <option value="중견기업">중견기업</option>
                  <option value="대기업">대기업</option>
                </select>
              </div>
              
              <div>회사 홈페이지</div>
              <div><input type="text" class="form-control" id="homePage" placeholder="홈페이지 링크를 입력하세요" maxlength="190"></div>
              
              <h3 class="section-subtitle">회사소개</h3>
              <div class="introduce-section">
                <textarea id="introduce" placeholder="회사소개를 입력해주세요"></textarea>
              </div>
            </div>
          </div>

          <div class="edit-buttons">
            <button onclick="cancleModify()" class="btn-cancel">취소</button>
            <button onclick="confirmModify(this)" class="btn-confirm">변경 확인</button>
          </div>
        </div>
      </section>

      <!-- 아무튼 카드 -->
      <section data-aos="fade-up" data-aos-delay="400">
        <div class="section-title">
          <h2><i class="bi bi-heart section-icon"></i>작성한 공고</h2>
          <button class="btn-edit" onclick="recruitSearchModal()">공고 검색 옵션</button>
        </div>
        <div id="recruitSection"></div>
      </section>

    </div>
  </div>

  <!-- firebase캡챠 -->
  <div id="recaptcha-container"></div>
</main>

<script>
// #region 본인 작성 글 리스트들 출력
function recruitSearchModal() {
	const text = `
	<div id="recruitSearchBox">
	    <h2>공고 검색</h2>
		<div>
	      <label style="width:150px"><input type="checkbox" id="noRead"> 신규 신청</label>
		  <label style="width:150px"><input type="checkbox" id="notClosing"> 모집중</label>
		  <label style="width:150px"><input type="checkbox" id="applyViaSite"> 사이트 신청</label>
	  	</div>
	  	<hr>
	  	<div>
	  	<span>
	  	<label style="width:200px">검색조건 : 
		  <select id="searchKeywordType">
		    <option value="title">제목검색</option>
		    <option value="manager">담당자</option>
		  </select>
		</label>
		</span><span>
		<label style="width:200px">정렬 : 
		  <select id="sortBy">
		    <option value="DUE_SOON">마감임박</option>
		    <option value="LATEST">최신순</option>
		    <option value="REG_COUNT">신청서수</option>
		  </select>
		</label>
		</span>
		</div>
		
		<div>
		  <input type="text" id="searchKeyword" placeholder="검색어를 입력하세요" style="width:450px"/>
		</div>
	</div>
	`
	
	// 모달 열고 나서 input 값 채워넣기
  window.publicModals.show(text, {
    cancelText: "취소",
    onConfirm: () => {
      // 모달 값 → 전역 변수에 반영
      noRead = $('#noRead').is(':checked');
      notClosing = $('#notClosing').is(':checked');
      applyViaSite = $('#applyViaSite').is(':checked');
      searchKeyword = $('#searchKeyword').val();
      searchKeywordType = $('#searchKeywordType').val();
      sortBy = $('#sortBy').val();

      page = 1; // 검색 새로 할 때는 1페이지부터 시작

      getMyRecruit(); // 검색 실행
    },
    size_x: "600px"
  });

  $('#noRead').prop('checked', noRead);
  $('#notClosing').prop('checked', notClosing);
  $('#applyViaSite').prop('checked', applyViaSite);
  $('#searchKeyword').val(searchKeyword);
  $('#searchKeywordType').val(searchKeywordType);
  $('#sortBy').val(sortBy);

}

function getMyRecruit() {
  const data = {
    uid: uid,
    page: page,
    searchKeyword: searchKeyword,
    searchKeywordType: searchKeywordType,
    sortBy: sortBy,
    noRead: noRead,
    notClosing: notClosing,
    applyViaSite: applyViaSite
  };

  $.ajax({
    url: '/recruitmentnotice/rest/withResume',
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(data),
    success: function(res) {
      console.log("공고 결과:", res);
      renderRecruitList(res.items)
      renderPagination(res)
    },
    error: function(xhr) {
      console.log("에러 발생", xhr);
    }
  });
}

function goToPage(pageNum) {
	  page = pageNum;
	  getMyRecruit();
	}

function renderRecruitList(items) {
	  const container = $('#recruitSection');
	  container.empty();

	  if (!items || items.length === 0) {
	    container.html(`
	      <div class="empty-state">
	        <i class="fas fa-folder-open"></i><br>
	        검색된 공고가 없습니다.
	      </div>
	    `);
	    return;
	  }

	  let html = '<div class="recruit-card-list" style="display: flex; flex-direction: column; gap: 12px;">';

	  items.forEach(item => {
	    html += `
        <div class="recruit-card-wrapper" data-uid="\${item.uid}">
          <div class="recruit-card" style="
            background: #fff;
            border: 1px solid #eee;
            border-radius: 12px;
            padding: 15px 20px;
            font-size: 14px;
            line-height: 1.5;
            color: #2c3e50;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
          " onclick="toggleResumeDropdown(\${item.uid})">
            
            <div style="flex: 1;">
              <div><strong>\${item.title}</strong> <span style="color: #888;">(\${item.manager})</span></div>
              <div style="font-size: 13px; color: #666;">
                \${formatDate(item.dueDate)} 마감 · 신청서 \${item.registrationCount}건
                \${item.hasUnreadApplications ? '<span style="color: #e74c3c;"> · 🔔 미확인 있음</span>' : ''}
                \${item.applyViaSite ? '<span style="color: #47b2e4;"> · 📥 사이트신청</span>' : ''}
              </div>
            </div>

            <button class="btn-edit" onclick="event.stopPropagation(); viewRecruitDetail(\${item.uid})">
              상세조회
            </button>
          </div>

          <div class="resume-dropdown" id="dropdown-\${item.uid}" style="
            display: none;
            background: #f8f9fa;
            padding: 20px 25px;
            border-radius: 12px;
            border: 1px solid #e9ecef;
            margin-top: 10px;
            font-size: 14px;
            line-height: 1.6;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
          ">
            <div style="margin-bottom: 15px;">
              <label style="font-size: 14px; color: #555;">
                <input type="checkbox" onchange="fetchResumes(\${item.uid}, this.checked)">
                <span style="margin-left: 6px;">읽지 않은 신청서만 보기</span>
              </label>
            </div>

            <div id="resumeList-\${item.uid}" style="margin-bottom: 15px;">
              <em>이력서 불러오는 중...</em>
            </div>

            <div id="resumePagination-\${item.uid}" style="
              display: flex;
              justify-content: center;
              flex-wrap: wrap;
              gap: 8px;
            "></div>
          </div>

        </div>
      `;

	  });

	  html += '</div>';
	  container.html(html);
}

function viewRecruitDetail(uid) {
  // 예시: 상세 페이지 이동
  location.href = `/recruitmentnotice/detail?uid=\${uid}`;
}

const submitDto = {
  recruitmentUid:0,
  page:1,
  onlyUnread:false,
  prioritizeUnread:true
}

function toggleResumeDropdown(uid) {
	  $('.resume-dropdown').slideUp(); // 모든 드롭다운 닫기
	  const $target = $(`#dropdown-\${uid}`);

	  if ($target.is(':visible')) {
	    $target.slideUp();
	    return;
	  }

	  $target.slideDown();
	  fetchResumes(uid, false); // 기본은 전체 보기
}

function fetchResumes(uid, onlyUnread, page = 1) {
	  const listContainer = $(`#resumeList-\${uid}`);
	  const pageContainer = $(`#resumePagination-\${uid}`);

	  const loader = $('<div class="resume-loading-spinner">불러오는 중...</div>');
	  listContainer.append(loader);
	  pageContainer.empty();

	  $.ajax({
	    url: '/submit/withResume',
	    method: 'POST',
	    contentType: 'application/json',
	    data: JSON.stringify({
	      recruitmentUid: uid,
	      page: page,
	      onlyUnread: onlyUnread,
	      prioritizeUnread: true
	    }),
	    success: function(res) {
	      if (!res || res.items.length === 0) {
	    	listContainer.empty();
	        listContainer.html('<p style="color:#888;">표시할 이력서가 없습니다.</p>');
	        return;
	      }

	      // 이력서 렌더링
	      let html = '<ul style="padding-left: 0; list-style: none;">';
	        res.items.forEach(r => {
	          const statusLabel = r.status === 'WAITING' ? '미확인' : '';
	          html += `
	            <li onclick="viewSubmitDetail(\${r.registrationNo})" style="
	              background: #fff;
	              border: 1px solid #ddd;
	              border-radius: 10px;
	              padding: 12px 40px;
	              margin-bottom: 8px;
	        	  margin-left: 30px;
	              box-shadow: 0 1px 5px rgba(0,0,0,0.03);
	        	  cursor: pointer;
	            ">
	              <div><strong>\${r.userName}</strong> - \${r.title} <span style="color:var(--bs-red); font-size:0.7em; margin-left: 15px;">\${statusLabel}</span></div>
	              <div style="font-size: 13px; color: #666;">\${formatDate(r.regDate)}</div>
	            </li>
	          `;
	        });
	        html += '</ul>';
          listContainer.empty();
	      listContainer.html(html);

	      // 페이지 버튼 렌더링
	      renderResumePagination(uid, onlyUnread, res);
	    },
	    error: function() {
	      listContainer.empty();
	      listContainer.html('<p style="color:red;">이력서 로딩 실패</p>');
	    }
	  });
	}
	
function viewSubmitDetail(registrationNo) {
	  location.href = `/submit/detail/\${registrationNo}`;
	}
	
function renderResumePagination(uid, onlyUnread, res) {
	  const container = $(`#resumePagination-\${uid}`);
	  const { currentPage, pageList, hasPrevBlock, hasNextBlock, startPage, endPage } = res;

	  let html = `<div style="margin-top: 10px; display: flex; justify-content: center; gap: 5px; flex-wrap: wrap;">`;

	  if (hasPrevBlock) {
	    html += `<button class="btn-edit" onclick="fetchResumes(\${uid}, \${onlyUnread}, \${startPage - 1})">«</button>`;
	  }

	  pageList.forEach(p => {
	    html += `<button class="btn-edit \${p === currentPage ? 'active' : ''}" 
	      style="\${p === currentPage ? 'background:#3a8fb8;color:white;' : ''}" 
	      onclick="fetchResumes(\${uid}, \${onlyUnread}, \${p})">\${p}</button>`;
	  });

	  if (hasNextBlock) {
	    html += `<button class="btn-edit" onclick="fetchResumes(\${uid}, \${onlyUnread}, \${endPage + 1})">»</button>`;
	  }

	  html += '</div>';
	  container.html(html);
	}

  function renderPagination(res) {
  const { pageList, currentPage, hasPrevBlock, hasNextBlock, startPage, endPage } = res;
  const container = $('#recruitSection');

  let html = `
    <div class="pagination" style="
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 8px;
      margin-top: 25px;
      flex-wrap: wrap;
    ">
  `;

  if (hasPrevBlock) {
    html += `<button class="btn-edit" onclick="goToPage(\${startPage - 1})">« 이전</button>`;
  }

  pageList.forEach(p => {
    html += `<button class="btn-edit \${p === currentPage ? 'active' : ''}" onclick="goToPage(\${p})" style="\${p === currentPage ? 'background:#3a8fb8;' : ''}">\${p}</button>`;
  });

  if (hasNextBlock) {
    html += `<button class="btn-edit" onclick="goToPage(\${endPage + 1})">다음 »</button>`;
  }

  html += '</div>';
  container.append(html);
}
// #endregion

// #region 전역 변수 및 초기화
const uid = "${sessionScope.account.uid}"
let sessionMobile = "${sessionScope.account.mobile}";
let sessionEmail = "${sessionScope.account.email}";
let page = 1;
let searchKeyword = '';
let searchKeywordType = "title";
let sortBy = "DUE_SOON";
let noRead = false;
let notClosing = false;
let applyViaSite = false;

const METHOD = {
  EMAIL: "email",
  PHONE: "phone"
};
// 파이어베이스
let confirmationResult = null;
const firebaseConfig = {
  apiKey: "AIzaSyDh4lq9q7JJMuDFTus-sehJvwyHhACKoyA",
  authDomain: "jobhunter-672dd.firebaseapp.com",
  projectId: "jobhunter-672dd",
  storageBucket: "jobhunter-672dd.appspot.com",
  messagingSenderId: "686284302067",
  appId: "1:686284302067:web:30c6bc60e91aeea963b986",
  measurementId: "G-RHVS9BGBQ7"
};
firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
function firebaseCaptcha() {
    if (!window.recaptchaVerifier) {
      window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier('recaptcha-container', {
          size: 'invisible',
          callback: () => {}
        });
    }
}
// #endregion

// #region 포메팅 관련 함수
// 국제번호로 변환 (Firebase 용)
function formatPhoneNumberForFirebase(koreanNumber) {
  const cleaned = koreanNumber.replace(/-/g, '');
  return cleaned.startsWith('0') ? '+82' + cleaned.substring(1) : cleaned;
}
// 국제번호를 한국 형식으로 되돌림 (서버 전송용)
function formatToKoreanPhoneNumber(internationalNumber) {
  return internationalNumber.startsWith("+82")
    ? internationalNumber.replace("+82", "0").replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3")
    : internationalNumber;
}
// 날짜형식 변환용
function formatDate(dateString) {
  if (!dateString) return '미입력';
  const date = new Date(dateString);
  return date.toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}
// 날짜시간형식 변환용
function formatDateTime(dateString) {
  if (!dateString) return '미입력';
  const date = new Date(dateString);
  return date.toLocaleString('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
}
// 전화번호 입력 처리 함수
function handlePhoneInput(input, nextInput) {
  input.value = input.value.replace(/[^0-9]/g, '');
  if (input.value.length >= 3 && nextInput) {
    nextInput.focus();
  }
}

// 전화번호 포맷팅 함수
function formatPhoneNumber(input1, input2, input3) {
  const num1 = input1.value;
  const num2 = input2.value;
  const num3 = input3.value;
  
  if (num1.length === 3 && num2.length === 4 && num3.length === 4) {
    return `\${num1}-\${num2}-\${num3}`;
  }
  return null;
}

// 폼 제출 시 콤마 제거하는 함수 (필요한 경우)
function removeComma(str) {
    return str.replace(/,/g, '');
}

// 숫자 포맷팅 함수 (콤마 추가)
function formatNumber(e) {
    // 숫자 이외의 문자 제거
    let value = e.target.value.replace(/[^\d]/g, '');
    // 3자리마다 콤마 추가
    value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    e.target.value = value;
}
// #endregion

// #region 계정삭제 관련
function updateDeleteAccountInfo(deleteDeadline, blockDeadline) {
  if (deleteDeadline) {
    $('#accountDeleteDateTitle').text('삭제 대기중...')
    if (deleteDeadline < blockDeadline) {
      $('#accountDeleteDateBlock').text(formatDate(blockDeadline) + " 이후 삭제 예정 / 정지기간중에는 계정 삭제가 불가능합니다.")
    } else {
      $('#accountDeleteDateBlock').text(formatDate(deleteDeadline) + " 이후 삭제 예정")
    }
    $('#accountDeleteBtn').text("계정 삭제 취소")
    $('#accountDeleteBtn').off('click').on('click', deleteCancleAccount);
  } else {
    $('#accountDeleteDateTitle').text('')
    $('#accountDeleteDateBlock').text('')
    $('#accountDeleteBtn').text("계정 삭제 신청")
    $('#accountDeleteBtn').off('click').on('click', deleteAccount);
  }
}

// 계정 삭제 신청 전 본인인증(기존 비밀번호)
function deleteAccount() {
  window.publicModals.show(`<input type="password" id="nowPassword" placeholder="현재 비밀번호를 입력하세요" style="min-width: 300px;">`, {
    onConfirm: checkPasswordToDeleteAccount,
    cancelText: "취소",
    size_x: "350px",
  })
}

function checkPasswordToDeleteAccount() {
  const failedDTO = {
      onConfirm: deleteAccount,
      cancelText: "취소"
    }

  const nowPassword = document.getElementById('nowPassword').value

  if (!nowPassword) {
    window.publicModals.show('현재 비밀번호를 입력해주세요.', failedDTO);
    return false; // 공용모달 안닫음
  }

  $.ajax({
    url: "/company/password",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({ uid, password: nowPassword }),
    success: (result) => {
      if (result === true) {
        window.publicModals.show("<div>정말로 삭제하시겠습니까?</div><div style='font-size:0.7em; color:var(--bs-gray-600)'>계정은 3일 뒤 삭제됩니다.</div>", {
          cancelText : '취소',
          onConfirm : checkedDeleteAccount
        })
      } else {
        window.publicModals.show("비밀번호가 틀렸습니다.", failedDTO);
      }
    },
    error: (xhr) => {
      window.publicModals.show("비밀번호 확인 중 오류 발생", failedDTO);
    }
  });
  return false;
}

  function checkedDeleteAccount() {
    $.ajax({
      url: `/user/info/${sessionScope.account.uid}`,
      method: "DELETE",
      contentType: "application/json",
      success: (res) => {
        window.publicModals.show("계정은 3일 뒤 삭제됩니다.")
        updateDeleteAccountInfo(res.message)
      },
      error: (xhr) => {window.publicModals.show("연결 실패! 새로고침 후 다시 시도해주세요")}
    });
  }

  function deleteCancleAccount() {
	    window.publicModals.show("<div>계정 삭제를 취소하시겠습니까?</div>", {
      cancelText : '취소',
      onConfirm : checkedDeleteCancleAccount
    })
  }

  function checkedDeleteCancleAccount() {
    $.ajax({
      url: `/user/info/${sessionScope.account.uid}/cancelDelete`,
      method: "DELETE",
      contentType: "application/json",
      success: (res) => {
        window.publicModals.show("계정삭제가 취소되었습니다.")
        updateDeleteAccountInfo(res.message)
      },
      error: (xhr) => {window.publicModals.show("연결 실패! 새로고침 후 다시 시도해주세요")}
    });
  }
// #endregion

// #region 정보 서버에있는걸로 갱신
function getInfo() {
  $.ajax({
      url: "/company/info/${sessionScope.account.uid}",
      method: "GET",
      success: (result) => {
        sessionMobile = result.mobile;
  		  sessionEmail = result.email;
        updateDeleteAccountInfo(result.deleteDeadline, result.blockDeadline)
        resetUserModifyForm();
        updateBasicInfo(result);
        updateCompanyDetailInfo(result);
        updateCompanyModifyInfo(result);
        
      },
      error: (xhr) => {
        if (xhr.status == 404) {
        	window.publicModals.show("장시간 대기로 로그인이 해제되었습니다.<br>새로고침 후 다시 시도해주세요.",{size_x:"350px"})
        }
        window.publicModals.show("서버와의 연결이 불안정하여<br>정보 로딩에 실패하였습니다.<br>잠시 후 다시 시도해주세요.")
      }
  });
}

// 기본정보 로딩
function updateBasicInfo(companyInfo) {
  $('#profileImg').html(`<img src="\${companyInfo.companyImg}" style="width:100%; height:100%; object-fit:cover;">`);
  $('#companyName').text( companyInfo.companyName || '미입력')
  $('#representative').text( companyInfo.representative || '대표자명 미등록')
  $('#nowMobile').text( companyInfo.mobile || '등록된 전화번호 없음')
  $('#nowEmail').text( companyInfo.email || '등록된 이메일 없음')
  $('#regDate').text( formatDate(companyInfo.regDate))
  $('#lastLoginDate').text( formatDateTime(companyInfo.lastLoginDate))
}

// 상세정보 로딩
function updateCompanyDetailInfo(companyInfo) {
  const companyDetailInfo = document.getElementById('companyDetailInfo');

  const values = [
    companyInfo.addr || '등록된 주소 없음',
    companyInfo.detailAddr || '등록된 상세주소 없음',
    companyInfo.scale || '기업규모 비공개',
    companyInfo.homePage || '홈페이지 미등록'
  ];

  const divs = companyDetailInfo.querySelectorAll(':scope > div:not(.introduce-section):not(.edit-buttons)');

  // 앞에서부터 짝수 인덱스는 label, 홀수 인덱스가 값
  for (let i = 0, valIdx = 0; i < divs.length; i++) {
    if (i % 2 === 1) {
      divs[i].textContent = values[valIdx++];
    }
  }

  // 자기소개
  $('#introduce-content').html(companyInfo.introduce || '회사소개가 아직 없습니다.');
}

// 수정창 내용 초기화
function resetUserModifyForm() {
  // 주소 초기화
  $('#addressSearch').val('');
  $('#selectedAddress').val('').hide();
  $('#addressDetail').val('').hide();
  $('#addressSelect').empty().append('<li class="address-dropdown-item" data-value="">주소를 선택하세요</li>');

  $('#scale').val('-1');
  $('#homePage').val('');

  // 자기소개 초기화
  $('#introduce').val('');
}

// 수정창 갱신
function updateCompanyModifyInfo(result) {
  const address = result.addr;

  if (result.addr) {
    // 초기화용 주소 저장
    $('#addressBackup').val(result.addr);
    $('#selectedAddress').val(result.addr || '');
    $('#selectedAddress').show()
    $('#addressDetail').show()
  }
  if (result.detailAddr) {
    $('#detailAddressBackup').val(result.detailAddr);
    $('#addressDetail').val(result.detailAddr || '');
  }

  // 기업규모
  if (result.scale) {
    $('#scale').val(result.scale);
  }

  // 홈페이지
  if (result.homePage) {
    $('#homePage').val(result.homePage);
  }

  // 자기소개
  if (result.introduce) {
    $('#introduce').summernote('code', result.introduce);
  } else {
    $('#introduce').summernote('code', '');
  }
}

// #endregion 정보 서버에있는걸로 갱신

$(()=>{
  getInfo();
  getMyRecruit();
})

// #region 상세정보 수정 관련
// 상세정보 수정 창 열기
function modyfiInfoTapOpen () {

  const section = document.getElementById('modifySection');

  // 먼저 display를 block으로 설정
  section.style.display = "block";

  // 잠깐 기다렸다가 클래스를 추가해야 트랜지션이 작동함
  setTimeout(() => {
    section.classList.add("show");
  }, 10);

  section.scrollIntoView({ behavior: 'smooth' });
}

// 수정완료
function confirmModify(btn) {

  console.log(btn);

  const nullIfInvalid = (v) => (v === '-1' || v == null || v === '') ? null : v;
  const parseValidNumber = (v) => {
    const n = parseInt(removeComma(v), 10);
    return (isNaN(n) || n < 0) ? null : n;
  };

  // 선택된 값이 -1이면 null로 변환

  let homePage = nullIfInvalid($('#homePage').val().trim());

  let scale = nullIfInvalid($('#scale').val());

  let addr = nullIfInvalid($('#selectedAddress').val().trim());
  let detailAddr = nullIfInvalid($('#addressDetail').val().trim());
  let introduce = nullIfInvalid($('#introduce').val().trim());

  const data = {
    addr,
    detailAddr,
    homePage,
    scale,
    introduce
  };

  $.ajax({
    url: '/company/info/${sessionScope.account.uid}',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(data),
    success: function (response) {
      window.publicModals.show('정보가 성공적으로 수정되었습니다.');
      cancleModify();
    },
    error: function (xhr) {
      if (xhr.status == 404) {
        window.publicModals.show("장시간 대기로 로그인이 해제되었습니다.<br>새로고침 후 다시 시도해주세요.",{size_x:"350px"})
      } else if (xhr.status == 507) {
    	window.publicModals.show("cafe24 요금제 제한등으로 인하여<br>업로드에 실패했습니다.<br>파일갯수등을 줄이고<br>다시 시도해주세요.(6개이하 추천)",{size_x:"350px"})
      }
      window.publicModals.show("서버와의 연결이 불안정하여<br>정보 로딩에 실패하였습니다.<br>잠시 후 다시 시도해주세요.")
    }
  });
}
// #endregion

function showCodeModal(confirmFunc, isfailed) {
  let modalText = `<input type="text" id="verifiCode" placeholder="인증번호를 입력하세요" style="min-width: 300px;">`

  if (isfailed) {
    modalText += `<div style="color:red; margin-top: 10px; font-size:0.8em">잘못된 인증번호입니다.</div>`
  }

  window.publicModals.show(modalText, {
    onConfirm: ()=>{confirmFunc();return false},
    cancelText: "취소",
    size_x: "350px"
  })
}

// #region 비번변경
// 비밀번호 변경 전 1차 본인인증(기존 비밀번호)
function openPasswordModal() {

  const modalText = `
        <input type="password" id="nowPassword" placeholder="현재 비밀번호를 입력하세요" style="min-width: 300px;">
  `;

  window.publicModals.show(modalText, {
    onConfirm: checkPassword,
    cancelText: "취소",
    size_x: "350px",
  })
}
  
// 비밀번호 변경 전 1차 본인인증(기존 비밀번호)
function checkPassword() {

  const failedDTO = {
      onConfirm: openPasswordModal,
      cancelText: "취소"
    }

  const nowPassword = document.getElementById('nowPassword').value
  if (!nowPassword) {
    window.publicModals.show('현재 비밀번호를 입력해주세요.', failedDTO);
    return false; // 공용모달 안닫음
  }

  $.ajax({
    url: "/company/password",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({ uid, password: nowPassword }),
    success: (result) => {
      if (result == true) {
        showVerificationOptions();
      } else {
        window.publicModals.show("비밀번호가 틀렸습니다.", failedDTO);
      }
    },
    error: (xhr) => {
      window.publicModals.show("서버가 불안정합니다. 잠시후 다시 시도해주세요.", failedDTO);
    }
  });

  return false;
}

function showVerificationOptions() {
  let mobileText = `<input type="text" style="min-width: 535px;" value="연결된 전화번호가 없습니다." readonly>`;
  if (sessionMobile && sessionMobile != 'null') {
    mobileText = `
      <input type="text" style="min-width: 400px; font-size:1.1em;padding:7px 12px" value="전화번호 : \${sessionMobile}" readonly>
        <button style="width: 130px;" class="btn-search" id="pwdToMobileBtn" onclick="pwdToMobile()">전화인증</button>
    `;
  }

  let emailText = `<input type="text" style="min-width: 535px;" value="연결된 이메일이 없습니다." readonly>`;
  if (sessionEmail && sessionEmail != 'null') {
    emailText = `
      <input type="text" style="min-width: 400px; font-size:1.1em;padding:7px 12px" value="이메일 : \${sessionEmail}" readonly>
        <button style="width: 130px;" class="btn-search" id="pwdToEmailBtn" onclick="pwdToEmail()">이메일인증</button>
    `;
  }

  const modalText = mobileText + emailText + `<hr>`

  window.publicModals.show(modalText,{confirmText:'닫기', size_x:'700px'})
}

async function pwdToMobile() {
  const rawPhone = sessionMobile;
  const phoneNumber = formatPhoneNumberForFirebase(rawPhone);

  firebaseCaptcha()
  try {
    confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
    showCodeModal(checkCodePwdToMobile)
  } catch (error) {
    window.publicModals.show("인증번호 전송중 오류가 발생했습니다. fireBase 사용횟수 초과등의 가능성이 있으니 강제진행을 원하신다면 백도어 버튼을 눌러주세요.", {
    onConfirm: () => {
        showNewPwdModal('')
        return false;
      },
    confirmText: "백도어",
    cancelText: "닫기"
  });
  }
}

async function checkCodePwdToMobile() {
  const code = $('#verifiCode').val()
  
  if (code.length != 6) {
    showCodeModal(checkCodePwdToEmail, true);
    return;
  }

  try {
    await confirmationResult.confirm(code);
    showNewPwdModal('');
  } catch (error) {
    window.publicModals.show("인증에 실패하였습니다. 잠시 후 다시 시도해주세요.")
  }
}

function pwdToEmail() {

  $.ajax({
    url: "/account/auth/email",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({email: sessionEmail}),
    async: false,
    success: (res) => {showCodeModal(checkCodePwdToEmail); return false},
    error: (xhr) => {
      window.publicModals.show("인증번호 전송중 오류가 발생했습니다.", {
        onConfirm: () => {showVerificationOptions(); return false},
        confirmText: "재시도",
        cancelText: "닫기"
      })
    }
  });
}

async function checkCodePwdToEmail() {
  const code = $('#verifiCode').val()

  if (!code || code.length != 6) {
    showCodeModal(checkCodePwdToEmail, true);
    return
  }

  $.ajax({
      url: `/account/auth/email/verify/\${code}`,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ email: sessionEmail }),
      async: false,
      success: () => {
        showNewPwdModal('')
      },
      error: (xhr) => {
        showCodeModal(checkCodePwdToEmail, true);
      }
  });
}

function showNewPwdModal (text) {

  const modalText = `
  <input id="changePassword" type="text" style="min-width: 300px;" placeholder="변경할 비밀번호를 입력하세요.">
  <input id="checkPassword" type="text" style="min-width: 300px;" placeholder="비밀번호를 다시 한번 입력해주세요.">
  `

  const failedText = modalText + text;

  window.publicModals.show(failedText,{
    onConfirm: () => {changePassword(modalText); return false;},
    confirmText:'변경완료',
    cancelText:'취소',
    size_x:'350px'
  })
}

function changePassword(modalText) {
  const changePassword = $('#changePassword').val();
  const checkPassword = $('#checkPassword').val();
  const pwdRegex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])[a-zA-Z\d!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]{6,20}$/;

  if (!pwdRegex.test(changePassword)) {
    const failedText = `<div style="color:red; margin-top: 10px; font-size:0.8em">비밀번호는 영어와 숫자, 특수문자를 전부 포함한 6~20자여야 합니다.</div>`
    showNewPwdModal(failedText)
    return;
  }

  if (changePassword !== checkPassword) {
    const failedText = `<div style="color:red; margin-top: 10px; text-size:0.8em">비밀번호 재입력란을 다시 한번 확인해주세요.</div>`
    showNewPwdModal(failedText)
    return;
  }

  $.ajax({
    url: "/company/password",
    method: "patch",
    contentType: "application/json",
    data: JSON.stringify({ uid, password: changePassword }),
    success: () => {
      window.publicModals.show("비밀번호 변경이 완료되었습니다.");
    },
    error: (xhr) => {
      if (xhr.status == 404) {
        window.publicModals.show("접속이 오래되어 로그인이 해제됐거나 잘못된 접근방식입니다. 새로고침 후 다시 시도해주세요.");
      }
      const failedText = `<div style="color:red; margin-top: 10px; text-size:0.8em">비밀번호 변경중 오류가 발생했습니다. 잠시후 다시 시도해 주세요.</div>`
      showNewPwdModal(failedText)
      return;
    }
  });
}
// #endregion
// #region 연락처변경
// 전화번호 입력 HTML 템플릿
function getPhoneInputHTML() {
  return `
    <span class="phone-input-group">
      <input type="text" maxlength="3" placeholder="000" oninput="handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
      <span>-</span>
      <input type="text" maxlength="4" placeholder="0000" oninput="if(this.value.length >= 4) handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
      <span>-</span>
      <input type="text" maxlength="4" placeholder="0000" oninput="handlePhoneInput(this, null)">
    </span>
  `;
}



function deleteMobileModal() {
  $.ajax({
    url: '/company/contact',
    type: 'DELETE',
    contentType: 'application/json',
    data: JSON.stringify({
      uid: uid,
      type: 'mobile'
    }),
    success: function () {
      window.publicModals.show("연락처가 성공적으로 삭제되었습니다.");
      sessionMobile = null;
      $('#nowMobile').html('등록된 전화번호 없음')
    },
    error: function (xhr) {
      if (xhr.status == 404) {
        window.publicModals.show("접속이 오래되어 로그인이 해제됐거나 잘못된 접근방식입니다. 새로고침 후 다시 시도해주세요.");
      }
      window.publicModals.show("삭제에 실패했습니다. 다시 시도해주세요.");
    }
  });
}

function deleteEmailModal() {
  $.ajax({
    url: '/company/contact',
    type: 'DELETE',
    contentType: 'application/json',
    data: JSON.stringify({
      uid: uid,
      type: 'email'
    }),
    success: function () {
      window.publicModals.show("연락처가 성공적으로 삭제되었습니다.");
      sessionEmail = null;
      $('#nowEmail').html('등록된 이메일 없음')
    },
    error: function (xhr) {
      window.publicModals.show("삭제에 실패했습니다. 다시 시도해주세요.");
    }
  });
}

function deleteContactModal() {
  const modalText = `<h2>연락처 삭제</h2>

    <button style="width: 160px;" class="btn-search" onclick="
      window.publicModals.show('정말로 삭제하시겠습니까?',
        {confirmText:'예', cancelText:'아니오', onConfirm:deleteMobileModal}
      )">
    전화번호 삭제</button>

    <button style="width: 160px;" class="btn-search" onclick="
      window.publicModals.show('정말로 삭제하시겠습니까?',
        {confirmText:'예', cancelText:'아니오', onConfirm:deleteEmailModal}
      )">
    이메일 삭제</button>

    <div style="color:red; margin-top: 10px; text-size:0.8em"><i class="bi bi-exclamation-circle"></i>반드시 하나의 연락처는 남아있어야합니다.</div>`

  window.publicModals.show(modalText,{confirmText:'취소', size_x:'400px'})
  return false;
}


// 연락처 수정 모달
function openContactModal() {

  const headText = `<h2>연락처 수정 및 변경</h2>`;
  
  const mobileText = `<div>변경할 전화번호를 입력해주세요.</div>` + getPhoneInputHTML() + `
      <button style="width: 130px;" class="btn-search" onclick="verifiToNewMobile()">전화인증</button>
  `;

  const emailText = `
	  <div>변경할 이메일을 입력해주세요.</div>
      <input type="text" id="newEmail" style="min-width: 400px; font-size:1.1em; padding:7px 20px" placeholder="변경할 이메일을 입력해주세요.">
        <button style="width: 130px;" class="btn-search" onclick="verifiToNewEmail()">이메일인증</button>
    `

  const modalText = headText + `<hr>` + mobileText + `<hr>` + emailText + `<hr>`

  if (sessionMobile && sessionEmail) {
    window.publicModals.show(modalText,{cancelText:'취소', size_x:'700px', confirmText:"연락처 삭제", onConfirm:deleteContactModal})
  } else {
    window.publicModals.show(modalText,{confirmText:'취소', size_x:'700px'})
  }

  $('.public-modal-button.confirm').css('background-color', 'var(--bs-red)');
}

// 전화번호 중복 체크
async function checkDuplicateMobile(formattedNumber) {
  try {
    const res = await fetch('/account/check/mobile', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        mobile: formattedNumber,
        accountType: "COMPANY"
      })
    });

    const message = await res.text(); // 메시지 확인용
    if (res.ok) {
      return false; // 중복 아님
    } else {
      return true; // 중복됨
    }

  } catch (e) {
    console.log(e);
    window.publicModals.show('서버와의 연결이 불안정합니다. 잠시 후 다시 시도해주세요.', {onConfirm:()=>{openContactModal(); return false;}});
    return true; // 실패 시 중복된 걸로 취급
  }
}

async function verifiToNewMobile() {
  const phoneInputs = document.querySelectorAll('.phone-input-group input');
  console.log(phoneInputs);
  const formattedNumber = formatPhoneNumber(phoneInputs[0], phoneInputs[1], phoneInputs[2]);
  console.log(formattedNumber);

  if (!formattedNumber) {
    window.publicModals.show('올바른 전화번호를 입력해주세요.', {onConfirm:()=>{openContactModal(); return false;}});
    return;
  }

  if (await checkDuplicateMobile(formattedNumber)) {
    window.publicModals.show('이미 사용중인 연락처입니다.', {onConfirm:()=>{openContactModal(); return false;}});
		return;
	}

  const phoneNumber = formatPhoneNumberForFirebase(formattedNumber);

  firebaseCaptcha();
  try {
    confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
    showCodeModal(()=>{changeMobile(formattedNumber)});
  } catch (error) {
    window.publicModals.show("인증번호 전송중 오류가 발생했습니다. fireBase 사용횟수 초과등의 가능성이 높으니 나중에 다시 시도해주세요.", {onConfirm:()=>{openContactModal(); return false;}});
  }
}

async function changeMobile(formattedNumber) {
  const code = $('#verifiCode').val()

  console.log(code);

  if (!code || code.length != 6) {
    showCodeModal(()=>{changeMobile(formattedNumber)}, true);
    return
  }

  try {
    await confirmationResult.confirm(code); // 코드 틀렸으면 여기서  catch로 넘어감

    const dto = {
      type: "mobile",
      value: formattedNumber,
      uid
    };
  
    $.ajax({
      url: "/company/contact",
      method: "patch",
      contentType: "application/json",
      data: JSON.stringify(dto),
      success: (val) => {
        sessionMobile = formattedNumber;
        $('#nowMobile').text( sessionMobile || '등록된 전화번호 없음')
        window.publicModals.show("전화번호가 성공적으로 변경되었습니다.");
      },
      error: (xhr) => {
        window.publicModals.show("서버가 불안정합니다. 잠시 후 다시 시도해주세요.");
      }
    });
  } catch (error) {
    showCodeModal(()=>{changeMobile(formattedNumber)}, true);
  }
}

function verifiToNewEmail() {
  const emailInputs = $('#newEmail').val();
  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

  if (!emailInputs || !emailRegex.test(emailInputs)) {
    window.publicModals.show('올바른 이메일을 입력해주세요.', {onConfirm:()=>{openContactModal(); return false;}});
    return;
  }

  // todo : 이메일 중복체크

  $.ajax({
    url: "/account/auth/email",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({ 
      email: emailInputs,
      checkDuplicate: true,
      accountType: "COMPANY"
		}),
    async: false,
    success: (res) => {
      showCodeModal(()=>{confirmEmail(emailInputs)});
    },
    error: (xhr) => {
      if (xhr.responseText == "이미 가입된 이메일입니다.") {
        window.publicModals.show(xhr.responseText)
      } else {
        window.publicModals.show("메일 전송 중 오류 발생")
      }
      console.log(xhr);
    }
  });
}

async function confirmEmail(changeEmail) {
  const code = $('#verifiCode').val()

  if (!code || code.length != 6) {
    showCodeModal(()=>{confirmEmail(changeEmail)}, true);
    return
  }

  $.ajax({
    url: `/account/auth/email/verify/\${code}`,
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({ email: changeEmail }),
    async: false,
    success: () => {
      changeEmailFunc(changeEmail)
    },
    error: (xhr) => {
      showCodeModal(()=>{confirmEmail(changeEmail)}, true);
    }
  });
}

function changeEmailFunc(changeEmail) {
  const dto = {
    type: "email",
    value: changeEmail,
    uid
  };

  $.ajax({
    url: "/company/contact",
    method: "patch",
    contentType: "application/json",
    data: JSON.stringify(dto),
    success: (val) => {
      sessionEmail = changeEmail;
      $('#nowEmail').text( sessionEmail || '등록된 이메일 없음')
      window.publicModals.show("이메일이 성공적으로 변경되었습니다.");
    },
    error: (xhr) => {
      window.publicModals.show("서버가 불안정합니다. 잠시 후 다시 시도해주세요.");
    }
  });
}
// #endregion

  function cancleModify() {
    document.getElementById('modifySection').style.display = 'none';
    getInfo();
  }

  function deleteAddress() {
    document.getElementById('addressBackup').value = '';
    document.getElementById('detailAddressBackup').value = '';
    document.getElementById('selectedAddress').value = '';
    document.getElementById('addressDetail').value = '';
    document.getElementById('addressSelect').innerHTML = '';
    $('#selectedAddress').hide();
    $('#addressDetail').hide();
  }

  function resetAddress() {
    deleteAddress();
    beforeAddress = document.getElementById('addressBackup').value;
    beforeDetailAddress = document.getElementById('detailAddressBackup').value;
    if (beforeAddress && beforeAddress !== '') {
      document.getElementById('selectedAddress').value = beforeAddress;
      document.getElementById('selectedAddress').style.display = 'block';
      document.getElementById('addressDetail').style.display = 'block';
    }
    if (beforeDetailAddress) {
      document.getElementById('addressDetail').value = beforeDetailAddress;
    }
  }

  function setSearchAddressOption(jsonStr) {
    const addressSelect = document.getElementById('addressSelect');
    const addressSearch = document.getElementById('selectedAddress');
    // 첫 검색시에만 기본 옵션 추가
    if (addrCurrentPage === 1) {
      if (jsonStr.results.juso.length <= 0) {
        addressSelect.innerHTML = '<li class="address-dropdown-item" data-value="">검색 결과가 없습니다</li>';
      } else {
        addressSelect.innerHTML = '<li class="address-dropdown-item" data-value="">주소를 선택하세요</li>';
      }
    } else {
      document.getElementById('lodingLi')?.remove();
    }
    
    // 드롭다운 표시
    addressSelect.classList.add('show');
    
    // 검색 결과를 드롭다운에 추가 (누적)
    jsonStr.results.juso.forEach(item => {
        const fullAddress = item.roadAddr + ", 우편번호 : [" + item.zipNo + "]";
        
        const li = document.createElement('li');
        li.className = 'address-dropdown-item';
        li.dataset.value = fullAddress;
        li.textContent = fullAddress;
        
        // 클릭 이벤트 추가
        li.addEventListener('click', function() {
            // 이전 선택 항목의 선택 상태 제거
            const prevSelected = addressSelect.querySelector('.selected');
            if (prevSelected) {
                prevSelected.classList.remove('selected');
            }
            
            // 현재 항목 선택 상태로 변경
            this.classList.add('selected');
            
            // 검색창에 선택된 주소 표시
            document.getElementById('selectedAddress').value = this.dataset.value;

            // 드롭다운 숨김
            addressSelect.classList.remove('show');

            $('#selectedAddress').show();
            $('#addressDetail').show()
        });
        addressSelect.appendChild(li);
    });

    // 로딩중 표시
    const lodingLi = document.createElement('li');
        lodingLi.id = 'lodingLi'
        lodingLi.className = 'address-dropdown-item';
        lodingLi.dataset.value = '';
        lodingLi.textContent = '다음 내역을 로딩중입니다. 잠시만 기다려 주세요.';
        addressSelect.appendChild(lodingLi);
    // 검색창 클릭시 드롭다운 표시
    addressSearch.addEventListener('click', () => {
        addressSelect.classList.add('show');
    });
    
    // 문서 클릭시 드롭다운 숨김 (이벤트 중복 방지를 위해 한 번만 등록)
    if (addrCurrentPage === 1) {
        document.addEventListener('click', (e) => {
            if (!addressSearch.contains(e.target) && !addressSelect.contains(e.target)) {
                addressSelect.classList.remove('show');
            }
        });
    }
  }

  
  
// #region 주소검색API용 함수들
let addrCurrentPage = 0;
const addressSelect = document.getElementById("addressSelect");
// 무한스크롤용 스크롤 체커
function onAddressScroll() {
  const top = addressSelect.scrollTop;
  const height = addressSelect.clientHeight;
  const full = addressSelect.scrollHeight;

  if (top + height >= full - 1) {
    console.log("맨 아래 도착");
    searchAddress();
  }
}

function disableAddressScroll() {
  addressSelect.removeEventListener("scroll", onAddressScroll);
}

function enableAddressScroll() {
  addressSelect.addEventListener("scroll", onAddressScroll);
}

  function makeListJson(jsonStr){
    let lastPage = Math.ceil(jsonStr.results.common.totalCount / 10)
    if (lastPage == jsonStr.results.common.currentPage) {
      // 마지막 페이지면 이벤트 비활성화
      document.getElementById('lodingLi')?.remove();
      disableAddressScroll();
    } else {
      setSearchAddressOption(jsonStr);
    }
  }

  function searchAddress() {
    enableAddressScroll();
    const keyword = document.getElementById('addressSearch');
    
    // 새로운 검색어인 경우 페이지 초기화
    if (keyword.value !== keyword.lastSearchValue) {
        isAddrNextPage = true;
        addrCurrentPage = 0;
        const addressSelect = document.getElementById('addressSelect');
        addressSelect.innerHTML = ''; // 새로운 검색어면 결과 초기화
    }
    
    const currentPage = ++addrCurrentPage;
    keyword.lastSearchValue = keyword.value; // 마지막 검색어 저장

    // 적용예 (api 호출 전에 검색어 체크) 	
    if (!checkSearchedWord(keyword)) {
        return;
    }

    const dto = {
        currentPage: currentPage,
        keyword: keyword.value
    };

    $.ajax({
        url: "/region/getAddrApi",
        type: "post",
        contentType: "application/json",
        data: JSON.stringify(dto),
        dataType: "json",
        success: function(jsonStr) {
            var errCode = jsonStr.results.common.errorCode;
            var errDesc = jsonStr.results.common.errorMessage;
            if(errCode != "0"){
              window.publicModals.show(errCode+"="+errDesc);
            }else{
                if(jsonStr != null){
                  makeListJson(jsonStr);
                }
            }
        },
        error: function(xhr,status, error){
          window.publicModals.show("에러발생");
        }
    });
  }

  function checkSearchedWord(obj){
	if(obj.value.length >0){
		//특수문자 제거
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			window.publicModals.show("특수문자를 입력 할수 없습니다.") ;
			obj.value = obj.value.split(expText).join(""); 
			return false;
		}
		
		//특정문자열(sql예약어의 앞뒤공백포함) 제거
		var sqlArray = new Array(
			//sql 예약어
			"OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP", "EXEC",
             		 "UNION",  "FETCH", "DECLARE", "TRUNCATE" 
		);
		
		var regex;
		for(var i=0; i<sqlArray.length; i++){
			regex = new RegExp( sqlArray[i] ,"gi") ;
			
			if (regex.test(obj.value) ) {
        window.publicModals.show("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "");
				return false;
			}
		}
	}
	return true ;
}
// #endregion

// #region 썸머노트
$('#introduce').summernote({
  height: 300,
  placeholder: '회사소개를 입력해주세요',
  callbacks: {
    onImageUpload: function(files) {
      const maxSize = 1024 * 300; // 300kB (압축대상 크기)
      summerNoteImgSizeCheck(files, maxSize)
    }
  }
});

// #endregion

// #region 프로필 이미지 자르기
function cropImgModalOpen() {
	const copperTap=`
    <h2>프로필 이미지 수정</h2>
		<input type="file" id="imageInput" accept="image/*">
		<div>
		  <img id="cropTarget" style="max-width:100%; display:none;">
		</div>
	`
	
	window.publicModals.show(copperTap,{
    onConfirm:copperConfirm,
    confirmText: "자르기",
    cancelText: "취소"
  });
}

let cropper;

$(document).on('change', '#imageInput', (e) => {
  const file = e.target.files[0];
  const reader = new FileReader();

  reader.onload = () => {
    const img = document.getElementById('cropTarget');
    img.src = reader.result;
    img.style.display = 'block';

    if (cropper) cropper.destroy(); // 이전 인스턴스 제거
    cropper = new Cropper(img, {
      aspectRatio: 1,
      viewMode: 1,
      movable: true,
      zoomable: true,
      scalable: true,
      cropBoxResizable: true
    });
  };

	reader.readAsDataURL(file);
});
	
function copperConfirm() {
  const profileImg = document.getElementById('profileImgContainer');

  // 클릭 비활성화
  profileImg.onclick = null;
  profileImg.style.pointerEvents = 'none'; // 추가로 마우스 차단
  profileImg.style.opacity = '0.6';        // 시각적으로도 비활성 느낌

  const croppedCanvas = cropper.getCroppedCanvas({
    width: 400,   // 원하는 사이즈 지정 가능
    height: 400,
    imageSmoothingQuality: 'row'
  });

  const croppedDataUrl = croppedCanvas.toDataURL('image/jpeg');
  
  croppedCanvas.toBlob(blob => {
    const formData = new FormData();
    formData.append('file', blob, 'cropped.jpg');
    
    $.ajax({
      url: "/company/profileImg",
      type: "POST",
      data: formData,
      contentType: false,
      processData: false,
      success: function (response) {
        window.publicModals.show("변경 완료!");
        document.getElementById('profileImg').innerHTML = `<img src="\${response}" style="width:100%; height:100%; object-fit:cover;">`;
      },
      error: function (xhr, status, error) {
        window.publicModals.show("변경에 실패하였습니다. 서버 혹은 업로드한 이미지를 확인 후 다시 시도해주세요.");
      },
      complete: () => {
        // 다시 클릭 가능하게 복원
        profileImg.onclick = cropImgModalOpen;
        profileImg.style.pointerEvents = 'auto';
        profileImg.style.opacity = '1';
      }
    });
  }, 'image/jpeg');
}

// #endregion 

// #region 프로필 이미지삭제
function deleteImgModal() {
    window.publicModals.show(`정말로 삭제하시겠습니까?`,{
      confirmText:'예', cancleText:'아니오', onConfirm:deleteImg
    })
  }

function deleteImg() {
  $.ajax({
      url: "/company/profileImg",
      type: "DELETE",
      success: function (response) {
        window.publicModals.show("변경 완료!");
        document.getElementById('profileImg').innerHTML = `<img src="\${response}" style="width:100%; height:100%; object-fit:cover;">`;
      },
      error: function (xhr, status, error) {
        window.publicModals.show("변경에 실패하였습니다. 잠시 후 다시 시도해주세요.");
      }
    });
}
// #endregion 
</script>
<!-- 풋터 -->
<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>