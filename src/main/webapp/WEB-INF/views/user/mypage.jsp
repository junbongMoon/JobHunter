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

<style>
  /* 모달 스타일 */
  .modal-overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 9998;
  }

  .modal-box.large {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 500px;
    max-width: 90vw;
    height: auto;
    max-height: 90vh;
    overflow-y: auto;
    background: white;
    padding: 40px;
    border-radius: 16px;
    box-shadow: 0px 0px 40px rgba(0, 0, 0, 0.25);
    z-index: 9999;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
  }

  .modal-content {
    display: flex;
    flex-direction: column;
    height: 100%;
    padding: 20px;
  }

  .modal-title {
    font-size: 20px;
    margin-bottom: 20px;
    font-weight: bold;
    color: #2c3e50;
  }

  .modal-body {
    font-size: 18px;
  }

  .modal-spacer {
    flex-grow: 1;
  }

  .modal-buttons {
    text-align: right;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #eee;
  }

  .btn-cancel,
  .btn-confirm {
    padding: 10px 20px;
    margin-left: 12px;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    cursor: pointer;
  }

  .btn-cancel {
    background: #f8f9fa;
    color: #666;
  }

  .btn-confirm {
    background: #47b2e4;
    color: white;
  }

  .btn-cancel:hover,
  .btn-confirm:hover {
    opacity: 0.9;
  }

  /* 마이페이지 스타일 */
  .main {
    padding: 60px 20px;
    background: #f8f9fa;
    min-height: calc(100vh - 200px);
  }

  .page-title {
    text-align: center;
    font-size: 36px;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 50px;
    position: relative;
    font-family: 'Poppins', sans-serif;
  }

  .page-title:after {
    content: '';
    display: block;
    width: 80px;
    height: 4px;
    background: #47b2e4;
    margin: 15px auto;
    border-radius: 2px;
  }

  #mypageContainer {
    padding: 40px 60px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
    max-width: 1400px;
    margin: 0 auto;
  }

  section {
    margin-bottom: 50px;
    padding: 30px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
    transition: all 0.3s ease;
    border: 1px solid rgba(0, 0, 0, 0.05);
  }

  section:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  }

  section h2 {
    font-size: 24px;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 25px;
    display: flex;
    align-items: center;
    gap: 12px;
    font-family: 'Poppins', sans-serif;
  }

  section h2:before {
    content: '';
    display: inline-block;
    width: 4px;
    height: 24px;
    background: #47b2e4;
    border-radius: 2px;
    margin-right: 10px;
  }

  .info-grid {
    display: grid;
    grid-template-columns: 150px 1fr;
    gap: 20px;
    font-size: 16px;
    color: #555;
    font-family: 'Open Sans', sans-serif;
  }

  .info-grid>div:first-child {
    color: #666;
    font-weight: 500;
    font-size: 15px;
  }

  .info-grid>div:last-child {
    color: #2c3e50;
    font-weight: 600;
  }

  .empty-state {
    text-align: center;
    padding: 40px 30px;
    color: #666;
    font-size: 16px;
    font-family: 'Open Sans', sans-serif;
  }

  .empty-state i {
    font-size: 48px;
    color: #47b2e4;
    margin-bottom: 20px;
    opacity: 0.7;
  }

  .section-icon {
    margin-right: 8px;
    color: #47b2e4;
    font-size: 22px;
  }

  /* 섹션 그리드 레이아웃 */
  .sections-grid {
    display: grid;
    grid-template-columns: 1.2fr 0.8fr;
    gap: 30px;
    margin-top: 30px;
  }

  .sections-grid section {
    margin-bottom: 0;
    height: 100%;
  }

  /* 기본 정보와 상세 정보 섹션은 첫 번째 행에 배치 */
  .sections-grid section:first-child,
  .sections-grid section:nth-child(2) {
    grid-column: span 1;
  }

  /* 나머지 섹션들은 두 번째 행부터 시작 */
  .sections-grid section:nth-child(3),
  .sections-grid section:nth-child(4),
  .sections-grid section:nth-child(5) {
    grid-column: 1 / -1;
  }

  .verification-warning {
    grid-column: 1 / -1;
    background: #fff3cd;
    color: #856404;
    padding: 12px 20px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 10px;
  }

  .verification-warning i {
    color: #ffc107;
    font-size: 18px;
  }

  .info-grid strong {
    color: #47b2e4;
  }

  .introduce-section {
    grid-column: 1 / -1;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #eee;
  }

  .introduce-content {
    margin-top: 10px;
    padding: 15px;
    background: #f8f9fa;
    border-radius: 8px;
    white-space: pre-wrap;
    line-height: 1.6;
    color: #2c3e50;
  }

  /* 마이페이지 레이아웃 */
  .mypage-layout {
    display: flex;
    gap: 30px;
    max-width: 1800px;
    margin: 0 auto;
    padding: 0 20px;
  }

  #mypageContainer {
    flex: 1;
    padding: 40px 60px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
  }

  .edit-buttons {
    grid-column: 1 / -1;
    display: flex;
    gap: 15px;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #eee;
  }

  .btn-edit {
    padding: 8px 16px;
    border: none;
    border-radius: 8px;
    background: #47b2e4;
    color: white;
    font-size: 14px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s ease;
  }

  .btn-edit:hover {
    background: #3a8fb8;
    transform: translateY(-2px);
  }

  .btn-edit i {
    font-size: 16px;
  }

  /* 모달 폼 스타일 */
  .form-group {
    margin-bottom: 20px;
  }

  .form-group label {
    display: block;
    margin-bottom: 8px;
    color: #666;
    font-size: 14px;
  }

  .form-group input {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 14px;
  }

  .form-group input:focus {
    border-color: #47b2e4;
    outline: none;
  }

  .verification-group {
    display: flex;
    gap: 10px;
    margin-top: 10px;
  }

  .verification-group input {
    flex: 1;
  }

  .verification-group button {
    padding: 10px 20px;
    background: #47b2e4;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
  }

  .verification-group button:hover {
    background: #3a8fb8;
  }

  .verification-option {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 15px;
    border: 1px solid #eee;
    border-radius: 8px;
    transition: all 0.3s ease;
  }

  .verification-option:hover {
    border-color: #47b2e4;
    background: #f8f9fa;
  }

  .verification-option .btn-edit {
    width: 100%;
    justify-content: center;
    padding: 12px;
  }

  .verification-option .btn-edit i {
    margin-right: 8px;
  }

  .contact-info {
    font-size: 14px;
    color: #666;
    padding: 8px 12px;
    background: #f8f9fa;
    border-radius: 4px;
    border: 1px solid #eee;
  }

  /* 반응형 디자인 */
  @media (max-width: 1400px) {
    #mypageContainer {
      max-width: 95%;
      padding: 40px;
    }
  }

  @media (max-width: 1200px) {
    .sections-grid {
      grid-template-columns: 1fr;
    }

    .sections-grid section {
      grid-column: 1 / -1;
    }
  }

  @media (max-width: 768px) {
    #mypageContainer {
      padding: 30px 20px;
    }

    .mypage-layout {
      padding: 0 15px;
    }

    .info-grid {
      grid-template-columns: 1fr;
      gap: 10px;
    }

    section {
      padding: 20px;
    }
  }
</style>

<main class="main" data-aos="fade-up">
  <h1 class="page-title">마이페이지</h1>

  <div id="mypageContainer">
    <div class="sections-grid">

      <!-- 기본 정보 -->
      <section data-aos="fade-up" data-aos-delay="100">
        <div class="section-title">
          <h2><i class="bi bi-person-circle section-icon"></i>기본 정보</h2>
        </div>
        <div class="info-grid" id="basicInfo">
          <div class="empty-state">
            <i class="bi bi-person-circle"></i>
            <p>기본 정보를 불러오는 중...</p>
          </div>
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

      <!-- 이력서 영역 -->
      <section data-aos="fade-up" data-aos-delay="200">
        <div class="section-title">
          <h2><i class="bi bi-file-earmark-text section-icon"></i>내 이력서</h2>
        </div>
        <div class="empty-state">
          <i class="bi bi-file-earmark-text"></i>
          <p>등록된 이력서가 없습니다.</p>
        </div>
      </section>

      <!-- 리뷰 영역 -->
      <section data-aos="fade-up" data-aos-delay="300">
        <div class="section-title">
          <h2><i class="bi bi-star section-icon"></i>내가 작성한 리뷰</h2>
        </div>
        <div class="empty-state">
          <i class="bi bi-star"></i>
          <p>작성한 리뷰가 없습니다.</p>
        </div>
      </section>

      <!-- 관심 공고 -->
      <section data-aos="fade-up" data-aos-delay="400">
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

  <!-- firebase캡챠 -->
  <div id="recaptcha-container"></div>
</main>

<script>
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
      '<div>최근 로그인</div><div>' + formatDateTime(userInfo.lastLoginDate) + '</div>' +
      '<div class="edit-buttons">' +
      '<button id="openContactModalBtn" class="btn-edit"><i class="bi bi-pencil-square"></i> 연락처 수정</button>' +
      '<button id="openPasswordModalBtn" class="btn-edit"><i class="bi bi-key"></i> 비밀번호 변경</button>' +
      '</div>';
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
    if (userInfo.militaryService === 'COMPLETED') {
      militaryServiceText = '군필';
    } else if (userInfo.militaryService === 'EXEMPTED') {
      militaryServiceText = '면제';
    } else if (!userInfo.militaryService) {
      genderText = '미입력';
    }

    let nationalityText = '외국인';
    if (userInfo.nationality === 'KOREAN') {
      nationalityText = '한국인';
    } else if (!userInfo.nationality) {
      genderText = '미입력';
    }

    let payText = '미입력';
    if (userInfo.pay) {
      payText = userInfo.payType + ' ' + userInfo.pay + '원';
    }

    let introduceSection = '자기소개가 아직 없습니다.';
    if (userInfo.introduce) {
      introduceSection = userInfo.introduce;
    }

    userDetailInfo.innerHTML =
      '<div>주소</div><div>' + (userInfo.addr || '등록된 주소 없음') + '</div>' +
      '<div>성별</div><div>' + genderText + '</div>' +
      '<div>나이</div><div>' + (userInfo.age || '미입력') + '</div>' +
      '<div>병역사항</div><div>' + militaryServiceText + '</div>' +
      '<div>국적</div><div>' + nationalityText + '</div>' +
      '<div>희망급여</div><div>' + payText + '</div>' +
      `<div class="introduce-section"><div>자기소개</div><div class="introduce-content">` + introduceSection + `</div></div>` + 
      '<div class="edit-buttons">' +
      '<button id="chanegeDetailInfoBtn" class="btn-edit"><i class="bi bi-pencil-square"></i> 상세정보 수정</button>' +
      '</div>';
  }

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
  //캡챠기능 파이어베이스 기본 제공 (1회용이라 초기화)
  function firebaseCaptcha() {
      // firebase에서 해줌
      if (window.recaptchaVerifier) {
        window.recaptchaVerifier.clear(); // 기존 캡차 해제
        delete window.recaptchaVerifier;
      }
      // 캡챠기능 파이어베이스 기본 제공
      if (!window.recaptchaVerifier) {
        window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier('recaptcha-container', {
            size: 'invisible',
            callback: () => {}
          });
      }
  }
  
  $(()=>{
    getInfo()
  
    $(document).on('click', '#passwordBtn', ()=>{
      checkPassword()
    });
    
    $(document).on('click', '#startMobileVerifiBtn', ()=>{
      startVerifiPhonePwd()
    });
    $(document).on('click', '#startEmailVerifiBtn', ()=>{
      startVerifiEmailPwd()
    });
    $(document).on('click', '#endVerifiPwdToPhoneBtn', ()=>{
      endVerifiPwdMobile()
    });
    $(document).on('click', '#endVerifiPwdToEmailBtn', ()=>{
      endVerifiPwdEmail()
    });
    $(document).on('click', '#changeMobileStartVerifiBtn', ()=>{
      startVerifiPhonePne()
    });
    $(document).on('click', '#changeEmailStartVerifiBtn', ()=>{
      startVerifiEmailPne()
    });
    $(document).on('click', '#changeMobileEndVerifiBtn', ()=>{
      endVerifiPneMobile()
    });
    $(document).on('click', '#changeEmailEndVerifiBtn', ()=>{
      endVerifiPneEmail()
    });
    $(document).on('click', '#chanegeDetailInfoBtn', ()=>{
      // 상세정보 출력란 수정가능하게 바꾸는 함수
    });
    $(document).on('click', '#openContactModalBtn', ()=>{
      // 연락처 수정 버튼
      openContactModal();
    });
    $(document).on('click', '#openPasswordModalBtn', ()=>{
      // 비밀번호 수정 버튼
      openPasswordModal();
    });
  })

  
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
          <button id="passwordBtn" class="btn-confirm">확인</button>
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
          updateBasicInfo(result);
          updateUserDetailInfo(result);
        },
        error: (xhr) => alert("실패")
    });
  }
  function checkPassword() {
    const uid = "${sessionScope.account.uid}"
    const nowPassword = document.getElementById('nowPassword').value


    if (!nowPassword) {
      alert('현재 비밀번호를 입력해주세요.');
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
        alert("비밀번호가 틀렸습니다.");
        }
      },
      error: (xhr) => {
        alert("비밀번호 확인 중 오류 발생");
      }
    });
  }

  async function startVerifiPhonePwd() {
    const rawPhone = "${sessionScope.account.mobile}";
    if (!rawPhone) {
      alert('새 전화번호를 입력해주세요.');
      return;
    }
    // firebase 국제번호형식으로 받아서 바꾸는용도
    const phoneNumber = formatPhoneNumberForFirebase(rawPhone);
  
    firebaseCaptcha()
    try {
        confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
          alert("인증 코드가 전송되었습니다.");
          showEndVerifiPwdMobileModal()
      } catch (error) {
          console.error("전화번호 인증 실패:", error);
          alert("전화번호 인증 중 오류 발생.");
      }
  }
  async function endVerifiPwdMobile() {
      const mobileCode = document.getElementById('pwdToPhoneCode').value
  
    try {
         await confirmationResult.confirm(mobileCode);
         showNewPasswordForm(); // 성공 후 콜백 실행
     } catch (error) {
          failedVerifiModal()
     }
  }
  async function startVerifiEmailPwd() {
    const email = "${sessionScope.account.email}"
    if (!email) {
      alert('새 이메일을 입력해주세요.');
      return;
    }
      $.ajax({
        url: "/account/auth/email",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({email}),
        async: false,
        success: (res) => {showEndVerifiPwdEmailModal()},
        error: (xhr) => {alert("메일 전송 중 오류 발생: " + xhr.responseText)}
      });
  }
  async function endVerifiPwdEmail() {
    const emailCode = document.getElementById('pwdToEmailCode').value
    $.ajax({
        url: `/account/auth/email/${emailCode}`,
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ email: "${sessionScope.account.email}" }),
        async: false,
        success: () => {showNewPasswordForm()},
        error: (xhr) =>{alert("이메일 인증 실패: " + xhr.responseText)}
      });
  }
  
  function changePassword() {
    const changePassword =document.getElementById('changePassword').value
    const checkPassword = document.getElementById('checkPassword').value
    if (changePassword !== checkPassword) {
      alert("비밀번호가 일치하지 않습니다.");
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
      alert("비밀번호 변경 중 오류가 발생했습니다.");
      console.error(xhr.responseText);
      }
    });
  }

  function showEndVerifiPwdEmailModal() {
      const modalBody = document.querySelector('.modal-body');
      modalBody.innerHTML = `
        <div class="form-group">
            <label>이메일 인증</label>
            <div class="contact-info" style="margin-bottom: 15px;">${sessionScope.account.email}</div>
            <div class="verification-group">
                <input type="text" id="pwdToEmailCode" placeholder="인증번호 입력">
                <button id="endVerifiPwdToEmailBtn" class="btn-confirm">인증완료</button>
            </div>
        </div>
      `;
  }

  function showEndVerifiPwdMobileModal() {
      const modalBody = document.querySelector('.modal-body');
      modalBody.innerHTML = `
        <div class="form-group">
            <label>전화번호 인증</label>
            <div class="contact-info" style="margin-bottom: 15px;">${sessionScope.account.mobile}</div>
            <div class="verification-group">
                <input type="text" id="pwdToPhoneCode" placeholder="인증번호 입력">
                <button id="endVerifiPwdToPhoneBtn" class="btn-confirm">인증완료</button>
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
    const mobile = "${sessionScope.account.mobile}";
    const email = "${sessionScope.account.email}";

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
            : `<button id="startMobileVerifiBtn" class="btn-edit"><i class="bi bi-telephone"></i> 전화번호 인증</button>`;

      bodyText += `<i class="bi bi-telephone"></i> 전화번호 인증`+
                  `</button>`+
                  `<div class="contact-info">\${mobileText}</div>`+
              `</div>`+

              `<div class="verification-option">`;

      bodyText += email === "" 
            ? `<button class="btn-cancel" disabled><i class="bi bi-envelope"></i> 이메일 인증 불가</button>`
            : `<button id="startEmailVerifiBtn" class="btn-edit"><i class="bi bi-envelope"></i> 이메일 인증</button>`;


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

  function openContactModal() {
    const modal = document.getElementById('basicModal');
    const modalTitle = modal.querySelector('.modal-title');
    const modalBody = modal.querySelector('.modal-body');
    const modalButtons = modal.querySelector('.modal-buttons');

    const mobile = "${sessionScope.account.mobile}";
    const email = "${sessionScope.account.email}";

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
                <div style="display: flex; align-items: center; gap: 10px;">
                  <input type="text" id="changeMobile" placeholder="변경할 전화번호를 입력해 주세요" style="flex: 1;">
                  <button id="changeMobileStartVerifiBtn" class="btn-confirm">확인</button>
                </div>
              </div>
            </div>

            <div id="phoneVerificationGroup" style="display: none;">
              <div class="verification-option">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <input type="text" id="pneToPhoneCode" placeholder="인증번호를 입력해 주세요" style="flex: 1;">
                  <button id="changeMobileEndVerifiBtn" class="btn-confirm">인증완료</button>
                </div>
              </div>
            </div>

            <div id="emailInputGroup">
              <div class="verification-option">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <input type="text" id="changeEmail" placeholder="변경할 이메일을 입력해 주세요" style="flex: 1;">
                  <button id="changeEmailStartVerifiBtn" class="btn-confirm">확인</button>
                </div>
              </div>
            </div>

            <div id="emailVerificationGroup" style="display: none;">
              <div class="verification-option">
                <div style="display: flex; align-items: center; gap: 10px;">
                  <input type="text" id="pneToEmailCode" placeholder="인증번호를 입력해 주세요" style="flex: 1;">
                  <button id="changeEmailEndVerifiBtn" class="btn-confirm">인증완료</button>
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
    console.log("전화번호");
    const rawPhone = document.getElementById('changeMobile').value;
    if (!rawPhone) {
      alert('새 전화번호를 입력해주세요.');
      return;
    }
    // firebase 국제번호형식으로 받아서 바꾸는용도
    const phoneNumber = formatPhoneNumberForFirebase(rawPhone);
  
    firebaseCaptcha()
    try {
        confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
          alert("인증 코드가 전송되었습니다.");
          document.getElementById('phoneInputGroup').style.display = 'none';
          document.getElementById('phoneVerificationGroup').style.display = 'block';
      } catch (error) {
          console.error("전화번호 인증 실패:", error);
          alert("전화번호 인증 중 오류 발생.");
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
        alert("메일 전송 성공: " + res)
        document.getElementById('emailInputGroup').style.display = 'none';
        document.getElementById('emailVerificationGroup').style.display = 'block';
      },
      error: (xhr) => {alert("메일 전송 중 오류 발생: " + xhr.responseText)}
    });

  }
  async function endVerifiPneMobile() {
    const mobileCode = document.getElementById('pneToPhoneCode').value

    console.log(mobileCode);
    try {
      await confirmationResult.confirm(mobileCode); // 코드 틀렸으면 여기서  catch로 넘어감감
  
      const uid = "${sessionScope.account.uid}";
      const mobile = document.getElementById("changeMobile").value;
  
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
        alert("인증 처리 중 오류가 발생했습니다.");
        console.error(xhr.responseText);
        }
      });
  
    } catch (error) {
      console.error("코드 인증 실패:", error);
      alert("잘못된 인증 코드입니다.");
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
            alert("인증 처리 중 오류가 발생했습니다.");
            console.error(xhr.responseText);
            }
          });
        },
        error: (xhr) =>{alert("이메일 인증 실패: " + xhr.responseText)}
      });
    
}

  </script>
<!-- 풋터 -->
<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>