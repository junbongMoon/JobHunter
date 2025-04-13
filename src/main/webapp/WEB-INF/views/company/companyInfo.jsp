<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>

<link href="/resources/css/mypage.css" rel="stylesheet">

<main class="main" data-aos="fade-up">
  <h1 class="page-title">회사 정보</h1>

  <div id="mypageContainer">
    <div class="sections-grid">

      <!-- 기본 정보 -->
      <section data-aos="fade-up" data-aos-delay="100" class="spacerContainer">
        <div class="section-title">
          <h2><i class="bi bi-person-circle section-icon"></i>기본 정보</h2>
        </div>
        <div class="info-grid" id="basicInfo">
          <div>회사명</div><div><strong id="companyName">로딩중...</strong></div>
          <div>대표자</div><div id="representative">로딩중...</div>
          <div>전화번호</div><div id="nowMobile">로딩중...</div>
          <div>이메일</div><div id="nowEmail">로딩중...</div>
          <div>가입일</div><div id="regDate">로딩중...</div>
          <div>최근 로그인</div><div id="lastLoginDate">로딩중...</div>
        </div>

        <div class="spacer">
        </div>
      
        <div class="edit-buttons">
        <button class="btn-edit" onclick="openContactModal()"><i class="bi bi-pencil-square"></i> 연락처 수정</button>
        <button class="btn-edit" onclick="openPasswordModal()"><i class="bi bi-key"></i> 비밀번호 변경</button>
        </div>
      </section>

      <!-- UserVO 상세 정보 섹션 -->
      <section data-aos="fade-up" data-aos-delay="150">
        <div class="section-title">
          <h2><i class="bi bi-person-vcard section-icon"></i>상세 정보</h2>
        </div>
        <div class="info-grid" id="companyDetailInfo">
            <div>주소</div><div>로딩중...</div>
            <div>상세주소</div><div>로딩중...</div>
            <div>회사규모</div><div>로딩중...</div>
            <div>회사 홈페이지</div><div>로딩중...</div>
            <div class="introduce-section"><div class="introduce-title">회사소개</div><div class="introduce-content">로딩중...</div></div>
            <div class="edit-buttons">
            <button class="btn-edit" onclick="modyfiInfoTapOpen()"><i class="bi bi-pencil-square"></i> 상세정보 수정</button>
            <button class="btn-edit btn-delete" style="background-color:#dc3545; margin-left: auto;" onclick="deleteAccount()"> 계정 삭제 신청</button>
            </div>
        </div>
      </section>
      
      <!-- UserVO 상세 정보 섹션 -->
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
                  <input type="text" class="form-control" id="addressDetail" placeholder="상세주소를 입력하세요">
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
              <div><input type="text" class="form-control" id="homePage" placeholder="홈페이지 링크를 입력하세요"></div>
              
            </div>
          </div>

          <div class="introduce-section">
            <textarea id="introduce" placeholder="회사소개를 입력해주세요"></textarea>
          </div>
          
          <div class="edit-buttons">
            <button onclick="cancleModify()" class="btn-cancel">취소</button>
            <button onclick="confirmModify()" class="btn-confirm">변경 확인</button>
          </div>
        </div>
      </section>

      <!-- 공고 영역 -->
      <section data-aos="fade-up" data-aos-delay="300">
        <div class="section-title">
          <h2><i class="bi bi-file-earmark-text section-icon"></i>내 공고</h2>
        </div>
        <div class="empty-state">
          <i class="bi bi-file-earmark-text"></i>
          <p>등록된 이력서가 없습니다.</p>
        </div>
      </section>

      <!-- 아무튼 카드 -->
      <section data-aos="fade-up" data-aos-delay="400">
        <div class="section-title">
          <h2><i class="bi bi-heart section-icon"></i>카드 예제</h2>
        </div>
        <div class="empty-state">
          <i class="bi bi-heart"></i>
          <p>나중에 필요한거 담을 공간.</p>
        </div>
      </section>

    </div>
  </div>

  <!-- firebase캡챠 -->
  <div id="recaptcha-container"></div>
</main>

<script>
$(()=>{
  getInfo();
})
// #region 전역 변수 및 초기화
const uid = "${sessionScope.account.uid}"
let sessionMobile = "${sessionScope.account.mobile}";
let sessionEmail = "${sessionScope.account.email}";

console.log(uid);

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

// #region 정보 서버에있는걸로 갱신
function getInfo() {
  $.ajax({
      url: "/company/info/${sessionScope.account.uid}",
      method: "GET",
      success: (result) => {
        sessionMobile = result.mobile;
  		  sessionEmail = result.email;
        resetUserModifyForm();
        updateBasicInfo(result);
        updateCompanyDetailInfo(result);
        updateCompanyModifyInfo(result);
      },
      error: (xhr) => window.publicModals.show("정보 로딩에 실패하였습니다. 잠시후 새로고침해 주세요.")
  });
}

// 기본정보 로딩
function updateBasicInfo(companyInfo) {
  $('#companyName').text( companyInfo.companyName || '미입력')
  $('#representative').text( companyInfo.representative || '대표자명 미등록')
  $('#nowMobile').text( companyInfo.mobile || '등록된 전화번호 없음')
  $('#nowEmail').text( companyInfo.email || '등록된 이메일 없음')
  $('#regDate').text( formatDate(companyInfo.regDate))
  $('#lastLoginDate').text( formatDateTime(companyInfo.lastLoginDate))
}

// 상세정보 로딩
function updateCompanyDetailInfo(companyInfo) {
  console.log(companyInfo);

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
  const introduceDiv = companyDetailInfo.querySelector('.introduce-content');
  introduceDiv.textContent = companyInfo.introduce || '회사소개가 아직 없습니다.';
}

// 수정창 내용 초기화
function resetUserModifyForm() {
  // 주소 초기화
  $('#addressSearch').val('');
  $('#selectedAddress').val('').hide();
  $('#addressDetail').val('');
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
    document.getElementById('addressBackup').value = result.addr;
    document.getElementById('selectedAddress').value = result.addr || '';
    document.getElementById('selectedAddress').style.display = 'block'; // 표시
  }
  if (result.detailAddr) {
    document.getElementById('detailAddressBackup').value = result.detailAddr;
    document.getElementById('addressDetail').value = result.detailAddr || '';
  }

  // 기업규모
  if (result.scale) {
    document.getElementById('scale').value = result.scale;
  }

  // 홈페이지
  if (result.homePage) {
    document.getElementById('homePage').value = result.homePage;
  }

  // 자기소개
  if (result.introduce) {
    document.getElementById('introduce').value = result.introduce;
  }
}

// #endregion 정보 서버에있는걸로 갱신

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
function confirmModify() {
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

  console.log("${sessionScope.account.uid}");
  $.ajax({
    url: '/company/info/${sessionScope.account.uid}',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(data),
    success: function (response) {
      if (response.result == 'success') {
        window.publicModals.show('정보가 성공적으로 수정되었습니다.');
        cancleModify();
      } else {
        window.publicModals.show('정보 수정에 실패했습니다.');
      }
    },
    error: function (xhr, status, error) {
      console.error(error);
      window.publicModals.show('서버 오류가 발생했습니다.');
    }
  });
}
// #endregion

// #region 계정삭제 관련 (백엔드 미구현)
  function deleteAccount() {
	  window.publicModals.show("정말로 삭제하시겠습니까?", {
      cancelText : '취소',
      onConfirm : checkedDeleteAccount
    })
  }

  function checkedDeleteAccount() {
    $.ajax({
      url: `/company/delete/${sessionScope.account.uid}`,
      method: "DELETE",
      contentType: "application/json",
      success: () => {window.publicModals.show("삭제 대기중...", {onConfirm : getInfo})},
      error: (xhr) => {window.publicModals.show("연결 실패! 새로고침 후 다시 시도해주세요")}
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
      if (result === true) {
        showVerificationOptions();
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
  }

  try {
    await confirmationResult.confirm(code);
    showNewPwdModal('');
  } catch (error) {
    showCodeModal(checkCodePwdToEmail, true);
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
      url: `/account/auth/email/\${code}`,
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

  window.publicModals.show(modalText,{confirmText:'취소', size_x:'700px'})
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

  console.log("6자리는 넘어왔는데");

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
    url: `/account/auth/email/\${code}`,
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
    document.getElementById('selectedAddress').style.display = 'none';
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

            document.getElementById('selectedAddress').style.display = 'block';
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

</script>
<!-- 풋터 -->
<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>