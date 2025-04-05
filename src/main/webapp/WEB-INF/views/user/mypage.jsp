<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 헤더 -->
<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Firebase UMD 방식 -->
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>

<link href="/resources/css/mypage.css" rel="stylesheet">

<main class="main" data-aos="fade-up">
  <h1 class="page-title">마이페이지</h1>

  <div id="mypageContainer">
    <div class="sections-grid">

      <!-- 기본 정보 -->
      <section data-aos="fade-up" data-aos-delay="100" class="spacerContainer">
        <div class="section-title">
          <h2><i class="bi bi-person-circle section-icon"></i>기본 정보</h2>
        </div>
        <div class="info-grid" id="basicInfo">
          <div class="empty-state">
            <i class="bi bi-person-circle"></i>
            <p>기본 정보를 불러오는 중...</p>
          </div>
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
        <div class="info-grid" id="userDetailInfo">
          <div class="empty-state">
            <i class="bi bi-person-vcard"></i>
            <p>상세 정보를 불러오는 중...</p>
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
              
              <div>성별</div>
              <div>
                <select class="form-control" id="gender">
                  <option value="-1" style="display: none;">선택하세요</option>
                  <option value="MALE">남성</option>
                  <option value="FEMALE">여성</option>
                </select>
              </div>
              
              <div>나이</div>
              <div><input type="text" class="form-control" id="age" placeholder="나이를 입력하세요"></div>
              
              <div>병역사항</div>
              <div>
                <select class="form-control" id="military">
                  <option value="-1" style="display: none;">선택하세요</option>
                  <option value="NOT_SERVED">미필</option>
                  <option value="SERVED">군필</option>
                  <option value="EXEMPTED">면제</option>
                </select>
              </div>
              
              <div>국적</div>
              <div>
                <select class="form-control" id="nationality">
                  <option value="-1" style="display: none;">선택하세요</option>
                  <option value="DOMESTIC">한국인</option>
                  <option value="FOREIGN">외국인</option>
                </select>
              </div>

              <div>장애 여부</div>
              <div>
                <select class="form-control" id="disability">
                  <option value="-1" style="display: none;">선택하세요</option>
                  <option value="NONE">비대상</option>
                  <option value="GRADE1">1급</option>
                  <option value="GRADE2">2급</option>
                  <option value="GRADE3">3급</option>
                  <option value="GRADE4">4급</option>
                  <option value="GRADE5">5급</option>
                  <option value="GRADE6">6급</option>
                </select>
              </div>
              
              <div>희망급여 방식</div>
              <div>
                <select class="form-control" id="payType">
                  <option value="-1" style="display: none;">선택하세요</option>
                  <option value="연봉">연봉</option>
                  <option value="월급">월급</option>
                  <option value="회사 내규에 따름">회사 내규에 따름</option>
                </select>
              </div>
              <div id="payTitleDiv" style="display: none;">희망급여</div>
              <div id="payDiv" style="display: none;"><input type="text" class="form-control" id="pay" placeholder="희망급여를 입력하세요"></div>
            </div>
          </div>
          <div class="introduce-section">
            <textarea id="introduce" placeholder="자기소개를 입력해주세요"></textarea>
          </div>
          <div class="edit-buttons">
            <button onclick="cancleModify()" class="btn-cancel">취소</button>
            <button onclick="confirmModify()" class="btn-confirm">변경 확인</button>
          </div>
        </div>
      </section>

      <!-- 이력서 영역 -->
      <section data-aos="fade-up" data-aos-delay="300">
        <div class="section-title">
          <h2><i class="bi bi-file-earmark-text section-icon"></i>내 이력서</h2>
        </div>
        <div class="empty-state">
          <i class="bi bi-file-earmark-text"></i>
          <p>등록된 이력서가 없습니다.</p>
        </div>
      </section>

      <!-- 리뷰 영역 -->
      <section data-aos="fade-up" data-aos-delay="400">
        <div class="section-title">
          <h2><i class="bi bi-star section-icon"></i>내가 작성한 리뷰</h2>
        </div>
        <div class="empty-state">
          <i class="bi bi-star"></i>
          <p>작성한 리뷰가 없습니다.</p>
        </div>
      </section>

      <!-- 관심 공고 -->
      <section data-aos="fade-up" data-aos-delay="500">
        <div class="section-title">
          <h2><i class="bi bi-heart section-icon"></i>관심 공고 목록</h2>
        </div>
        <div class="empty-state">
          <i class="bi bi-heart"></i>
          <p>관심 등록된 공고가 없습니다.</p>
        </div>
      </section>
    </div>
  </div>

  <!-- 모달 창 -->
  <!-- 모달 뒤쪽 어둡게해주는거 -->
  <div id="basicModalOverlay" class="modal-overlay" style="display: none;"></div>
  <!-- 모달 본체 -->
  <div id="basicModal" class="modal-box large" style="display: none;">
    <div class="modal-content">
      <h2 class="modal-title">제목</h2>
      <p class="modal-body">내용물</p>

      <!-- 버튼 아래로 밀기용 -->
      <div class="modal-spacer"></div>

      <div class="modal-buttons">
        <button onclick="closeModal()" class="btn-cancel">닫기</button>
        <button onclick="confirmModalAction()" class="btn-confirm">확인</button>
      </div>
    </div>
  </div>
  <!-- 모달 창 -->

  <!-- 알럿 모달 -->
  <div id="alertModalOverlay" class="alert-modal-overlay" style="display: none;"></div>
  <div id="alertModal" class="alert-modal-box" style="display: none;">
    <div class="alert-modal-content">
      <div class="alert-modal-message"></div>
      <div class="alert-modal-buttons"></div>
    </div>
  </div>

  <!-- firebase캡챠 -->
  <div id="recaptcha-container"></div>
</main>

<script>
let sessionMobile = "${sessionScope.account.mobile}";
let sessionEmail = "${sessionScope.account.email}";

  $(()=>{
      getInfo();
    })

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
  let confirmationResult = null;
  // JS에서 enum타입처럼 쓰는거 
  const METHOD = {
   EMAIL: "email",
   PHONE: "phone"
  };
  

  document.getElementById('payType').addEventListener('change', function() {
    if (this.value === '연봉') {
      document.getElementById('pay').placeholder = '연봉을 입력해주세요';
      document.getElementById('payDiv').style.display = 'block';
      document.getElementById('payTitleDiv').style.display = 'block';
    } else if (this.value === '월급') {
      document.getElementById('pay').placeholder = '월급을 입력해주세요';
      document.getElementById('payDiv').style.display = 'block';
      document.getElementById('payTitleDiv').style.display = 'block';
    } else if (this.value === '회사 내규에 따름') {
      document.getElementById('payDiv').style.display = 'none';
      document.getElementById('payTitleDiv').style.display = 'none';
    }

  });

function resetUserModifyForm() {
  // 주소 초기화
  $('#addressSearch').val('');
  $('#selectedAddress').val('').hide();
  $('#addressDetail').val('');
  $('#addressSelect').empty().append('<li class="address-dropdown-item" data-value="">주소를 선택하세요</li>');

  // select박스 초기화 (성별, 병역사항, 국적, 급여유형)
  $('#gender').val('-1');
  $('#military').val('-1');
  $('#nationality').val('-1');
  $('#payType').val('-1');
  $('#disability').val('-1');

  // 나이, 희망급여 입력창 초기화
  $('#age').val('');
  $('#pay').val('');

  // 자기소개 초기화
  $('#introduce').val('');

  // 희망급여 입력창 숨김
  $('#payDiv').hide();
  $('#payTitleDiv').hide();
}

function confirmModify() {
  
  const parseOrNull = (value) => {
    const num = parseInt(value, 10);
    return isNaN(num) ? null : num;
  };

  // 선택된 값이 -1이면 null로 변환
  let gender = $('#gender').val();
  let military = $('#military').val();
  let nationality = $('#nationality').val();
  let payType = $('#payType').val();
  let disability = $('#disability').val();
  let addr = $('#selectedAddress').val().trim();
  let detailAddr = $('#addressDetail').val().trim();
  let age = $('#age').val();
  let pay = $('#pay').val();
  let introduce = $('#introduce').val();

  if (gender === '-1' || gender === null) {
    gender = null;
  }
  if (military === '-1' || military === null) {
    military = null;
  }
  if (nationality === '-1' || nationality === null) {
    nationality = null;
  }
  if (payType === '-1' || payType === null) {
    payType = null;
  }
  if (disability === '-1' || disability === null) {
    disability = null;
  }
  if (age === '' || age === null || age < 0) {
    age = null;
  }
  if (pay === '' || pay === null || pay < 0) {
    pay = null;
  } else {
    pay = removeComma(pay);
  }
  if (introduce === '' || introduce === null) {
    introduce = null;
  }
  if (addr === '' || addr === null) {
	  addr = null;
	    }
  if (detailAddr === '' || detailAddr === null) {
	  detailAddr = null;
	  }

  const data = {
    addr: addr || null,
    detailAddr: detailAddr || null,
    gender: gender || null,
    age: age || null,
    militaryService: military || null,
    nationality: nationality || null,
    payType: payType || null,
    pay: pay || null,
    introduce: introduce || null,
    disability: disability || null
  };

  $.ajax({
    url: '/user/info/${sessionScope.account.uid}',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(data),
    success: function (response) {
      if (response.success) {
        alertUtils.show('정보가 성공적으로 수정되었습니다.');
        cancleModify();
      } else {
        alertUtils.show('정보 수정에 실패했습니다.');
      }
    },
    error: function (xhr, status, error) {
      console.error(error);
      alertUtils.show('서버 오류가 발생했습니다.');
    }
  });
}

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
  //캡챠기능 파이어베이스 기본 제공
  function firebaseCaptcha() {
      if (!window.recaptchaVerifier) {
        window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier('recaptcha-container', {
            size: 'invisible',
            callback: () => {}
          });
      }
  }
  
  
  function openModal() {
      document.getElementById('basicModal').style.display = 'flex';
      document.getElementById('basicModalOverlay').style.display = 'block';
    }
  
  function closeModal() {
        const modalBody = document.querySelector('.modal-body');
        const modalButtons = document.querySelector('.modal-buttons');
        modalBody.innerHTML = '';
        modalButtons.innerHTML = '';
      document.getElementById('basicModal').style.display = 'none';
      document.getElementById('basicModalOverlay').style.display = 'none';
    }
  
  function confirmModalAction() {
      closeModal();
    }
  function updateBasicInfo(userInfo) {
    const basicInfo = document.getElementById('basicInfo');

    let isSocial = false;
    if (userInfo.isSocial === 'Y') {
      isSocial = true;
    }

    

    basicInfo.innerHTML =
      '<div>이름</div><div><strong>' + userInfo.userName + '</strong></div>' +
      '<div>전화번호</div><div id="nowMobile">' + (userInfo.mobile || '등록된 전화번호 없음') + '</div>' +
      '<div>이메일</div><div id="nowEmail">' + (userInfo.email || '등록된 이메일 없음') + '</div>' +
      '<div>가입일</div><div>' + formatDate(userInfo.regDate) + '</div>' +
      '<div>최근 로그인</div><div>' + formatDateTime(userInfo.lastLoginDate) + '</div>';
  }
  function updateUserDetailInfo(userInfo) {
    const userDetailInfo = document.getElementById('userDetailInfo');

    let genderText = '여성';
    if (userInfo.gender === 'MALE') {
      genderText = '남성';
    } else if (!userInfo.gender) {
      genderText = '미입력';
    }

    let militaryServiceText = '미필';
    if (userInfo.militaryService === 'SERVED') {
      militaryServiceText = '군필';
    } else if (userInfo.militaryService === 'EXEMPTED') {
      militaryServiceText = '면제';
    } else if (!userInfo.militaryService) {
      genderText = '미입력';
    }

    let nationalityText = '외국인';
    if (userInfo.nationality === 'FOREIGN') {
      nationalityText = '한국인';
    } else if (!userInfo.nationality) {
      genderText = '미입력';
    }

    let payText = '미입력';
    let pay = userInfo.pay;
    if (pay) {
      pay = pay.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    if (userInfo.pay) {
      if (userInfo.payType != '회사 내규에 따름') {
        payText = userInfo.payType + ' : ' + pay + '원';
        document.getElementById('payTitleDiv').style.display = 'block';
        document.getElementById('payDiv').style.display = 'block';
      } else {
        payText = '회사 내규에 따름';
        document.getElementById('payTitleDiv').style.display = 'none';
        document.getElementById('payDiv').style.display = 'none';
      }
    }

    let introduceSection = '자기소개가 아직 없습니다.';
    if (userInfo.introduce) {
      introduceSection = userInfo.introduce;
    }

    let disabilityText = '미입력';
    switch (userInfo.disability) {
      case 'GRADE1':
        disabilityText = '1급';
        break;
      case 'GRADE2':
        disabilityText = '2급';
        break;
      case 'GRADE3':
        disabilityText = '3급';
        break;
      case 'GRADE4':
        disabilityText = '4급';
        break;
      case 'GRADE5':
        disabilityText = '5급';
        break;
      case 'GRADE6':
        disabilityText = '6급';
        break;
      case 'NONE':
        disabilityText = '비대상';
        break;
    }

    let addressText = '등록된 주소 없음';
    if (userInfo.addr) {
      addressText = userInfo.addr;
    }
    let addressDetailText = '등록된 주소 없음';
    if (userInfo.detailAddr) {
      addressDetailText = userInfo.detailAddr;
    }

    userDetailInfo.innerHTML =
      '<div>주소</div><div>' + addressText + '</div>' +
      '<div>상세주소</div><div>' + addressDetailText + '</div>' +
      '<div>성별</div><div>' + genderText + '</div>' +
      '<div>나이</div><div>' + (userInfo.age || '미입력') + ' 세</div>' +
      '<div>병역사항</div><div>' + militaryServiceText + '</div>' +
      '<div>국적</div><div>' + nationalityText + '</div>' +
      '<div>희망급여</div><div>' + payText + '</div>' +
      '<div>장애여부</div><div>' + disabilityText + '</div>' +
      '<div class="introduce-section"><div class="introduce-title">자기소개</div><div class="introduce-content">' + introduceSection + '</div></div>' +
      '<div class="edit-buttons">' +
      '<button class="btn-edit" onclick="chanegeDetailInfoBtn()"><i class="bi bi-pencil-square"></i> 상세정보 수정</button>' +
      '<button class="btn-edit btn-delete" style="background-color:#dc3545; margin-left: auto;" onclick="deleteAccount()"> 계정 삭제 신청</button>' +
      '</div>';
  }

  function deleteAccount() {
    alertUtils.show("정말로 삭제하시겠습니까?", {
      confirmText : '확인',
      cancelText : '취소',
      onConfirm : checkedDeleteAccount,
      onCancel : alertUtils.hide
    })
  }

  function checkedDeleteAccount() {
    $.ajax({
      url: `/user/delete/${sessionScope.account.uid}`,
      method: "DELETE",
      contentType: "application/json",
      success: () => {alertUtils.show("삭제 대기중...", {onConfirm : getInfo})},
      error: (xhr) => {alertUtils.show("연결 실패! 새로고침 후 다시 시도해주세요")}
    });
  }

  function chanegeDetailInfoBtn () {
    // 상세정보 출력란 수정가능하게 바꾸는 함수
    const section = document.getElementById('modifySection');

    // 먼저 display를 block으로 설정
    section.style.display = "block";

    // 잠깐 기다렸다가 클래스를 추가해야 트랜지션이 작동함
    setTimeout(() => {
      section.classList.add("show");
    }, 10);

    section.scrollIntoView({ behavior: 'smooth' });
  }
  
  function openPasswordModal() {
    const modal = document.getElementById('basicModal');
    const modalTitle = modal.querySelector('.modal-title');
    const modalBody = modal.querySelector('.modal-body');
    const modalButtons = modal.querySelector('.modal-buttons');
    
    modalTitle.textContent = '비밀번호 변경';
    modalBody.innerHTML = `
      <div class="form-group">
          <div style="display: flex; align-items: center; gap: 10px;">
          <input type="password" id="nowPassword" placeholder="현재 비밀번호를 입력하세요" style="flex: 1;">
          <button class="btn-confirm" onclick="checkPassword()">확인</button>
          </div>
      </div>
    `;
    
    modalButtons.innerHTML = `
      <button onclick="closeModal()" class="btn-cancel">취소</button>
      <button onclick="checkPassword()" class="btn-confirm">확인</button>
    `;
    
    document.getElementById('basicModal').style.display = 'flex';
    document.getElementById('basicModalOverlay').style.display = 'block';
  }
  
  function getInfo() {
    $.ajax({
        url: "/user/info/${sessionScope.account.uid}",
        method: "GET",
        success: (result) => {
          // 기본 정보와 상세 정보 업데이트
          sessionMobile = result.mobile;
    		  sessionEmail = result.email;
          resetUserModifyForm();
          updateBasicInfo(result);
          updateUserDetailInfo(result);
          updateUserModifyInfo(result);
        },
        error: (xhr) => alertUtils.show("실패")
    });
  }

  function updateUserModifyInfo(result) {

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

    // 성별
    if (result.gender) {
      document.getElementById('gender').value = result.gender;
    }

    // 나이
    if (result.age !== null && result.age !== undefined) {
      document.getElementById('age').value = result.age;
    }

    // 병역사항
    if (result.militaryService) {
      document.getElementById('military').value = result.militaryService;
    }

    // 국적
    if (result.nationality) {
      document.getElementById('nationality').value = result.nationality;
    }

    // 희망급여 방식
    if (result.payType) {
      document.getElementById('payType').value = result.payType;
    }

    // 희망급여
    if (result.pay !== null && result.pay !== undefined) {
      let pay = result.pay;
      if (pay) {
        pay = pay.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      }
      document.getElementById('pay').value = pay;
    }

    // 자기소개
    if (result.introduce) {
      document.getElementById('introduce').value = result.introduce;
    }

    // 장애여부
    if (result.disability) {
      document.getElementById('disability').value = result.disability;
    }
  }



  function checkPassword() {
    const uid = "${sessionScope.account.uid}"
    const nowPassword = document.getElementById('nowPassword').value

    if (!nowPassword) {
      alertUtils.show('현재 비밀번호를 입력해주세요.');
      return;
    }

    $.ajax({
      url: "/user/password",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ uid, password: nowPassword }),
      success: (result) => {
        if (result === true) {
          showVerificationOptions();
        } else {
          alertUtils.show("비밀번호가 틀렸습니다.");
        }
      },
      error: (xhr) => {
        alertUtils.show("비밀번호 확인 중 오류 발생");
      }
    });
  }

  async function startVerifiPhonePwd() {
    const rawPhone = sessionMobile;
    if (!rawPhone) {
      alertUtils.show('새 전화번호를 입력해주세요.');
      return;
    }
    const phoneNumber = formatPhoneNumberForFirebase(rawPhone);
  
    firebaseCaptcha()
    try {
      confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
      alertUtils.show("인증 코드가 전송되었습니다.");
      showEndVerifiPwdMobileModal()
    } catch (error) {
      console.error("전화번호 인증 실패:", error);
      alertUtils.show("전화번호 인증 중 오류 발생.");
    }
  }
  async function endVerifiPwdMobile() {
    const mobileCode = document.getElementById('pwdToPhoneCode').value
  
    try {
      await confirmationResult.confirm(mobileCode);
      showNewPasswordForm();
    } catch (error) {
      failedVerifiModal()
    }
  }
  async function startVerifiEmailPwd() {
    const email = sessionEmail;
    if (!email) {
      alertUtils.show('새 이메일을 입력해주세요.');
      return;
    }
    $.ajax({
      url: "/account/auth/email",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({email}),
      async: false,
      success: (res) => {showEndVerifiPwdEmailModal()},
      error: (xhr) => {alertUtils.show("메일 전송 중 오류 발생: " + xhr.responseText)}
    });
  }
  async function endVerifiPwdEmail() {
    const emailCode = document.getElementById('pwdToEmailCode').value
    $.ajax({
      url: `/account/auth/email/\${emailCode}`,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({ email: sessionEmail }),
      async: false,
      success: () => {showNewPasswordForm()},
      error: (xhr) => {alertUtils.show("이메일 인증 실패: " + xhr.responseText)}
    });
  }
  
  function changePassword() {
    const changePassword = document.getElementById('changePassword').value;
    const checkPassword = document.getElementById('checkPassword').value;
    
    if (changePassword !== checkPassword) {
      alertUtils.show("비밀번호가 일치하지 않습니다.");
      return;
    }

    const uid = "${sessionScope.account.uid}";
    $.ajax({
      url: "/user/password",
      method: "patch",
      contentType: "application/json",
      data: JSON.stringify({ uid, password: changePassword }),
      success: () => {
        successModal();
      },
      error: (xhr) => {
        alertUtils.show("비밀번호 변경 중 오류가 발생했습니다.");
        console.error(xhr.responseText);
      }
    });
  }

  function showEndVerifiPwdEmailModal() {
      const modalBody = document.querySelector('.modal-body');
      modalBody.innerHTML = `
        <div class="form-group">
            <label>이메일 인증</label>
            <div class="contact-info" style="margin-bottom: 15px;">email</div>
            <div class="verification-group">
                <input type="text" id="pwdToEmailCode" placeholder="인증번호 입력">
                <button class="btn-confirm" onclick="endVerifiPwdEmail()">인증완료</button>
            </div>
        </div>
      `;
  }

  function showEndVerifiPwdMobileModal() {
      const modalBody = document.querySelector('.modal-body');
      modalBody.innerHTML = `
        <div class="form-group">
            <label>전화번호 인증</label>
            <div class="contact-info" style="margin-bottom: 15px;">mobile</div>
            <div class="verification-group">
                <input type="text" id="pwdToPhoneCode" placeholder="인증번호 입력">
                <button class="btn-confirm" onclick="endVerifiPwdMobile()">인증완료</button>
            </div>
        </div>
      `;
  }

  function failedVerifiModal() {
    const modalBody = document.querySelector('.modal-body');
    const modalButtons = modal.querySelector('.modal-buttons');
      modalBody.innerHTML = `
        <h2>인증 실패! 다시 진행해주세요</h2>
      `;
      modalButtons.innerHTML = `
      <button onclick="closeModal()" class="btn-cancel">확인</button>
    `;
  }

  function successModal() {
    getInfo()
    const modalBody = document.querySelector('.modal-body');
    const modalButtons = document.querySelector('.modal-buttons');
      modalBody.innerHTML = `
        <h2>변경 완료!</h2>
      `;
      modalButtons.innerHTML = `
      <button onclick="closeModal()" class="btn-confirm">확인</button>
    `;
  }
  
  function showNewPasswordForm() {
    const modalBody = document.querySelector('.modal-body');
    const modalButtons = document.querySelector('.modal-buttons');
    
    modalBody.innerHTML = `
      <div class="form-group">
          <label>새 비밀번호</label>
          <input type="password" id="changePassword" placeholder="새 비밀번호를 입력하세요">
      </div>
      <div class="form-group">
          <label>새 비밀번호 확인</label>
          <input type="password" id="checkPassword" placeholder="새 비밀번호를 다시 입력하세요">
      </div>
    `;
    
    modalButtons.innerHTML = `
      <button onclick="closeModal()" class="btn-cancel">취소</button>
      <button onclick="changePassword()" class="btn-confirm">확인</button>
    `;
  }
  
  function showVerificationOptions() {
    const modalBody = document.querySelector('.modal-body');
    const modalButtons = document.querySelector('.modal-buttons');
    const mobile = sessionMobile;
    const email = sessionEmail;

    let mobileText = "연결된 연락처가 없습니다.";
    if (mobile) {
      mobileText = mobile;
    }
    
    let emailText = "연결된 연락처가 없습니다.";
    if (email) {
      emailText = email;
    }

    let bodyText =
      `<div class="form-group">`+
          `<label>인증 방법 선택</label>`+
          `<div style="display: flex; flex-direction: column; gap: 15px;">`+

              `<div class="verification-option">`;

      bodyText += mobile === ""
            ? `<button class="btn-cancel" disabled><i class="bi bi-telephone"></i> 전화번호 인증 불가</button>`
            : `<button class="btn-edit" onclick="startVerifiPhonePwd()"><i class="bi bi-telephone"></i> 전화번호 인증</button>`;

      bodyText += `<i class="bi bi-telephone"></i> 전화번호 인증`+
                  `</button>`+
                  `<div class="contact-info">\${mobileText}</div>`+
              `</div>`+

              `<div class="verification-option">`;

      bodyText += email === "" 
            ? `<button class="btn-cancel" disabled><i class="bi bi-envelope"></i> 이메일 인증 불가</button>`
            : `<button class="btn-edit" onclick="startVerifiEmailPwd()"><i class="bi bi-envelope"></i> 이메일 인증</button>`;


      bodyText += `<div class="contact-info">\${emailText}</div>`+
              `</div>`+

          `</div>`+
      `</div>`+
      `<div id="verificationContent" style="display: none;"></div>`;
    
    modalBody.innerHTML = bodyText
    modalButtons.innerHTML = `
      <button onclick="closeModal()" class="btn-cancel">취소</button>
    `;
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

  // 전화번호 입력 HTML 템플릿
  function getPhoneInputHTML() {
    return `
      <div class="phone-input-group">
        <input type="text" maxlength="3" placeholder="000" oninput="handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
        <span>-</span>
        <input type="text" maxlength="4" placeholder="0000" oninput="if(this.value.length >= 4) handlePhoneInput(this, this.nextElementSibling.nextElementSibling)">
        <span>-</span>
        <input type="text" maxlength="4" placeholder="0000" oninput="handlePhoneInput(this, null)">
      </div>
    `;
  }
  
  // 연락처 수정 모달 수정
  function openContactModal() {
    const modal = document.getElementById('basicModal');
    const modalTitle = modal.querySelector('.modal-title');
    const modalBody = modal.querySelector('.modal-body');
    const modalButtons = modal.querySelector('.modal-buttons');
    const mobile = sessionMobile;
    const email = sessionEmail;

    

    let mobileText = "연결된 연락처가 없습니다.";
    if (mobile) {
      mobileText = mobile;
    }
    
    let emailText = "연결된 연락처가 없습니다.";
    if (email) {
      emailText = email;
    }
    
    modalTitle.textContent = '연락처 수정';
    modalBody.innerHTML = `
      <div class="form-group">
          <label>수정할 연락처</label>
          <div style="display: flex; flex-direction: column; gap: 15px;">
            <div id="phoneInputGroup">
              <div class="verification-option">
                <div style="display: flex; flex-direction: column; gap: 10px;">
                  \${getPhoneInputHTML()}
                  <button class="btn-confirm" onclick="startVerifiPhonePne()">확인</button>
                </div>
              </div>
            </div>

            <div id="phoneVerificationGroup" style="display: none;">
              <div class="verification-option">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <input type="text" id="pneToPhoneCode" placeholder="인증번호를 입력해 주세요" style="flex: 1;">
                  <button class="btn-confirm" onclick="endVerifiPneMobile()">인증완료</button>
                </div>
              </div>
            </div>

            <div id="emailInputGroup">
              <div class="verification-option">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <input type="text" id="changeEmail" placeholder="변경할 이메일을 입력해 주세요" style="flex: 1;">
                  <button class="btn-confirm" onclick="startVerifiEmailPne()">확인</button>
                </div>
              </div>
            </div>

            <div id="emailVerificationGroup" style="display: none;">
              <div class="verification-option">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <input type="text" id="pneToEmailCode" placeholder="인증번호를 입력해 주세요" style="flex: 1;">
                  <button class="btn-confirm" onclick="endVerifiPneEmail()">인증완료</button>
                </div>
              </div>
            </div>
          </div>
      </div>
      <div id="verificationContent" style="display: none;"></div>
    `;
    
    modalButtons.innerHTML = `
      <button onclick="closeModal()" class="btn-cancel">취소</button>
    `;
    
    document.getElementById('basicModal').style.display = 'flex';
    document.getElementById('basicModalOverlay').style.display = 'block';
  }

  async function startVerifiPhonePne() {
    const phoneInputs = document.querySelectorAll('.phone-input-group input');
    console.log(phoneInputs);
    const formattedNumber = formatPhoneNumber(phoneInputs[0], phoneInputs[1], phoneInputs[2]);
    console.log(formattedNumber);


    if (!formattedNumber) {
      alertUtils.show('올바른 전화번호를 입력해주세요.');
      return;
    }

    const phoneNumber = formatPhoneNumberForFirebase(formattedNumber);
  
    firebaseCaptcha();
    try {
      confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
      alertUtils.show("인증 코드가 전송되었습니다.");
      document.getElementById('phoneInputGroup').style.display = 'none';
      document.getElementById('phoneVerificationGroup').style.display = 'block';
    } catch (error) {
      console.error("전화번호 인증 실패:", error);
      alertUtils.show("전화번호 인증 중 오류 발생.");
    }
  }
  async function startVerifiEmailPne() {
  
    const email = document.getElementById('changeEmail').value;

    $.ajax({
      url: "/account/auth/email",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify({email}),
      async: false,
      success: (res) => {
        alertUtils.show("메일 전송 성공: " + res)
        document.getElementById('emailInputGroup').style.display = 'none';
        document.getElementById('emailVerificationGroup').style.display = 'block';
      },
      error: (xhr) => {alertUtils.show("메일 전송 중 오류 발생: " + xhr.responseText)}
    });

  }
  async function endVerifiPneMobile() {
    const mobileCode = document.getElementById('pneToPhoneCode').value

    console.log(mobileCode);
    try {
      await confirmationResult.confirm(mobileCode); // 코드 틀렸으면 여기서  catch로 넘어감감
  
      const uid = "${sessionScope.account.uid}";
      const phoneInputs = document.querySelectorAll('.phone-input-group input');
      const mobile = formatPhoneNumber(phoneInputs[0], phoneInputs[1], phoneInputs[2]);
  
      const dto = {
        type: "mobile",
        value: mobile,
        uid
      };
  
      $.ajax({
        url: "/user/contact",
        method: "patch",
        contentType: "application/json",
        data: JSON.stringify(dto),
        success: (val) => {
          successModal();
        },
        error: (xhr) => {
        alertUtils.show("인증 처리 중 오류가 발생했습니다.");
        console.error(xhr.responseText);
        }
      });
  
    } catch (error) {
      console.error("코드 인증 실패:", error);
      alertUtils.show("잘못된 인증 코드입니다.");
    }
  
  }
  async function endVerifiPneEmail() {
    const email = document.getElementById('changeEmail').value;
    const emailCode = document.getElementById('pneToEmailCode').value
    const uid = "${sessionScope.account.uid}"
    $.ajax({
        url: `/account/auth/email/\${emailCode}`,
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ email: email }),
        async: false,
        success: () => {
          const dto = {
            type: "email",
            value: email,
            uid
          };

          $.ajax({
            url: "/user/contact",
            method: "patch",
            contentType: "application/json",
            data: JSON.stringify(dto),
            success: (val) => {
              successModal();
            },
            error: (xhr) => {
            alertUtils.show("인증 처리 중 오류가 발생했습니다.");
            console.error(xhr.responseText);
            }
          });
        },
        error: (xhr) =>{alertUtils.show("이메일 인증 실패: " + xhr.responseText)}
      });
    
}

  // 알럿 모달 유틸리티
  const alertUtils = {
    show: (message, options = {}) => {
      const {
        confirmText = '확인',
        cancelText = null,
        onConfirm = null,
        onCancel = null
      } = options;

      const overlay = document.getElementById('alertModalOverlay');
      const modal = document.getElementById('alertModal');
      const messageEl = modal.querySelector('.alert-modal-message');
      const buttonsEl = modal.querySelector('.alert-modal-buttons');

      messageEl.textContent = message;
      
      let buttonsHTML = '';
      if (cancelText) {
        buttonsHTML += `<button class="alert-modal-button cancel">\${cancelText}</button>`;
      }
      buttonsHTML += `<button class="alert-modal-button confirm">\${confirmText}</button>`;
      
      buttonsEl.innerHTML = buttonsHTML;

      overlay.style.display = 'block';
      modal.style.display = 'block';

      const confirmBtn = modal.querySelector('.alert-modal-button.confirm');
      const cancelBtn = modal.querySelector('.alert-modal-button.cancel');

      confirmBtn.onclick = () => {
        if (onConfirm) onConfirm();
        alertUtils.hide();
      };

      if (cancelBtn) {
        cancelBtn.onclick = () => {
          if (onCancel) onCancel();
          alertUtils.hide();
        };
      }
    },
    hide: () => {
      document.getElementById('alertModalOverlay').style.display = 'none';
      document.getElementById('alertModal').style.display = 'none';
    }
  };

  function cancleModify() {
    resetUserModifyForm();
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

  document.getElementById("addressSelect").addEventListener("scroll", () => {
    const top = dropdown.scrollTop;
    const height = dropdown.clientHeight;
    const full = dropdown.scrollHeight;

    if (top + height >= full) {
      console.log("맨 아래 도착");
      searchAddress();
    }
  });

  let addrCurrentPage = 0;
  // 주소검색API용 함수들
  function makeListJson(jsonStr){
    setSearchAddressOption(jsonStr);
  }

  function searchAddress() {
    const keyword = document.getElementById('addressSearch');
    
    // 새로운 검색어인 경우 페이지 초기화
    if (keyword.value !== keyword.lastSearchValue) {
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
                alertUtils.show(errCode+"="+errDesc);
            }else{
                if(jsonStr != null){
                    makeListJson(jsonStr);
                }
            }
        },
        error: function(xhr,status, error){
            alertUtils.show("에러발생");
        }
    });
  }

  function checkSearchedWord(obj){
	if(obj.value.length >0){
		//특수문자 제거
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			alertUtils.show("특수문자를 입력 할수 없습니다.") ;
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
        alertUtils.show("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "");
				return false;
			}
		}
	}
	return true ;
}

document.getElementById('pay').addEventListener('input', function(e) {
    // 숫자 이외의 문자 제거
    let value = e.target.value.replace(/[^\d]/g, '');
    
    // 숫자를 3자리마다 콤마로 구분
    value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    
    // 변환된 값을 다시 입력란에 설정
    e.target.value = value;
});

// 폼 제출 시 콤마 제거하는 함수 (필요한 경우)
function removeComma(str) {
    return str.replace(/,/g, '');
}

// pay와 age 입력란 모두에 숫자만 입력되도록 이벤트 리스너 추가
document.getElementById('pay').addEventListener('input', formatNumber);
document.getElementById('age').addEventListener('input', function(e) {
    // 숫자 이외의 문자 제거
    let value = e.target.value.replace(/[^\d]/g, '');
    e.target.value = value;
});

// 숫자 포맷팅 함수 (콤마 추가)
function formatNumber(e) {
    // 숫자 이외의 문자 제거
    let value = e.target.value.replace(/[^\d]/g, '');
    // 3자리마다 콤마 추가
    value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    e.target.value = value;
}

</script>
<!-- 풋터 -->
<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>