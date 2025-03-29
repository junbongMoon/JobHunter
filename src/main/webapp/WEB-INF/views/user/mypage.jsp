<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!-- 헤더 -->
      <jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <!-- Firebase UMD 방식 -->
      <script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-app-compat.js"></script>
      <script src="https://www.gstatic.com/firebasejs/11.5.0/firebase-auth-compat.js"></script>
      <style>
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
          width: 50vw;
          height: 50vh;
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
        }

        .modal-title {
          font-size: 24px;
          margin-bottom: 20px;
          font-weight: bold;
        }

        .modal-body {
          font-size: 18px;
        }

        .modal-spacer {
          flex-grow: 1;
        }

        .modal-buttons {
          text-align: right;
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
          background: #ccc;
          color: #333;
        }

        .btn-confirm {
          background: #47b2e4;
          color: white;
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
          .sections-grid {
            grid-template-columns: 1fr;
          }

          .sections-grid section:first-child {
            grid-column: auto;
          }

          #mypageContainer {
            padding: 30px 20px;
          }
        }

        /* 섹션 그리드 레이아웃 */
        .sections-grid {
          display: grid;
          grid-template-columns: 1.2fr 0.8fr;
          /* 기본 정보를 더 넓게, 상세 정보를 더 좁게 */
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

        /* 네비게이터 스타일 */
        .page-navigator {
          position: sticky;
          top: 100px;
          width: 250px;
          height: fit-content;
          padding: 25px;
          background: white;
          border-radius: 20px;
          box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }

        .page-navigator h3 {
          font-size: 18px;
          font-weight: 600;
          color: #2c3e50;
          margin-bottom: 20px;
          padding-bottom: 10px;
          border-bottom: 2px solid #47b2e4;
        }

        .page-navigator ul {
          list-style: none;
          padding: 0;
          margin: 0;
        }

        .page-navigator li {
          margin-bottom: 12px;
        }

        .page-navigator a {
          display: block;
          padding: 8px 12px;
          color: #666;
          text-decoration: none;
          border-radius: 8px;
          transition: all 0.3s ease;
          font-size: 14px;
        }

        .page-navigator a:hover {
          background: #f8f9fa;
          color: #47b2e4;
        }

        .page-navigator a.active {
          background: #47b2e4;
          color: white;
        }

        /* 반응형 디자인 */
        @media (max-width: 1400px) {
          .mypage-layout {
            flex-direction: column;
          }

          .page-navigator {
            position: static;
            width: 100%;
            margin-top: 30px;
          }
        }

        @media (max-width: 768px) {
          .mypage-layout {
            padding: 0 15px;
          }

          #mypageContainer {
            padding: 30px 20px;
          }
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

        /* 모달 스타일 수정 */
        .modal-box.large {
          width: 500px;
          max-width: 90vw;
          height: auto;
          max-height: 90vh;
          overflow-y: auto;
        }

        .modal-content {
          padding: 20px;
        }

        .modal-title {
          font-size: 20px;
          margin-bottom: 20px;
          color: #2c3e50;
        }

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

        .modal-buttons {
          margin-top: 20px;
          padding-top: 20px;
          border-top: 1px solid #eee;
          text-align: right;
        }

        .btn-cancel,
        .btn-confirm {
          padding: 10px 20px;
          margin-left: 10px;
          border: none;
          border-radius: 8px;
          cursor: pointer;
          font-size: 14px;
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
      </style>

      <main class="main" data-aos="fade-up">
        <h1 class="page-title">마이페이지</h1>

        <div id="mypageContainer">
          <div class="sections-grid">
            <!-- 👤 기본 정보 -->
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

            <!-- 📄 이력서 영역 -->
            <section data-aos="fade-up" data-aos-delay="200">
              <div class="section-title">
                <h2><i class="bi bi-file-earmark-text section-icon"></i>내 이력서</h2>
              </div>
              <div class="empty-state">
                <i class="bi bi-file-earmark-text"></i>
                <p>등록된 이력서가 없습니다.</p>
              </div>
            </section>

            <!-- 📝 리뷰 영역 -->
            <section data-aos="fade-up" data-aos-delay="300">
              <div class="section-title">
                <h2><i class="bi bi-star section-icon"></i>내가 작성한 리뷰</h2>
              </div>
              <div class="empty-state">
                <i class="bi bi-star"></i>
                <p>작성한 리뷰가 없습니다.</p>
              </div>
            </section>

            <!-- ❤️ 관심 공고 -->
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
          document.getElementById('basicModal').style.display = 'none';
          document.getElementById('basicModalOverlay').style.display = 'none';
        }

        function confirmModalAction() {
          alert('확인되었습니다.');
          closeModal();
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
              callback: () => { }
            });
          }
        }

        $(() => {
          getInfo()

          $(document).on('click', '#passwordBtn', () => {
            checkPassword()
          });

          $(document).on('click', '#startMobileVerifiBtn', () => {
            startVerifiPhonePwd()
          });
          $(document).on('click', '#startEmailVerifiBtn', () => {
            startVerifiEmailPwd()
          });
          $(document).on('click', '#endVerifiPwdToPhoneBtn', () => {
            endVerifiPwdMobile()
          });
          $(document).on('click', '#endVerifiPwdToEmailBtn', () => {
            endVerifiPwdEmail()
          });
          $(document).on('click', '#changeMobileStartVerifiBtn', () => {
            startVerifiPhonePne()
          });
          $(document).on('click', '#changeEmailStartVerifiBtn', () => {
            startVerifiEmailPne()
          });
          $(document).on('click', '#changeMobileEndVerifiBtn', () => {
            endVerifiPneMobile()
          });
          $(document).on('click', '#changeEmailEndVerifiBtn', () => {
            endVerifiPneEmail()
          });
        })

        function getInfo() {
          $.ajax({
            url: "/user/info/${sessionScope.account.uid}",
            method: "GET",
            success: (result) => {
              // 기본 정보와 상세 정보 업데이트
              updateBasicInfo(result);
              updateUserDetailInfo(result);
            },
            error: (xhr) => {
              console.error("사용자 정보 조회 실패:", xhr);
              alert("사용자 정보를 불러오는데 실패했습니다.");
            }
          });
        }

        function updateBasicInfo(userInfo) {
          const basicInfo = document.getElementById('basicInfo');

          let isSocialText = '아니오';
          if (userInfo.isSocial === 'Y') {
            isSocialText = '예';
          }

          let verificationWarning = '';
          if (userInfo.requiresVerification === 'Y') {
            verificationWarning = '<div class="verification-warning">' +
              '<i class="bi bi-exclamation-triangle-fill"></i>' +
              '<span>이메일/전화번호 인증이 필요합니다.</span>' +
              '</div>';
          }

          basicInfo.innerHTML =
            '<div>이름</div><div><strong>' + userInfo.userName + '</strong></div>' +
            '<div>전화번호</div><div id="nowMobile">' + (userInfo.mobile || '등록된 전화번호 없음') + '</div>' +
            '<div>이메일</div><div id="nowEmail">' + (userInfo.email || '등록된 이메일 없음') + '</div>' +
            '<div>소셜 로그인</div><div>' + isSocialText + '</div>' +
            '<div>가입일</div><div>' + formatDate(userInfo.regDate) + '</div>' +
            '<div>최근 로그인</div><div>' + formatDateTime(userInfo.lastLoginDate) + '</div>' +
            verificationWarning +
            '<div class="edit-buttons">' +
            '<button onclick="openContactModal()" class="btn-edit"><i class="bi bi-pencil-square"></i> 연락처 수정</button>' +
            '<button onclick="openPasswordModal()" class="btn-edit"><i class="bi bi-key"></i> 비밀번호 변경</button>' +
            '</div>';
        }

        function updateUserDetailInfo(userInfo) {
          const userDetailInfo = document.getElementById('userDetailInfo');

          let genderText = '여성';
          if (userInfo.gender === 'MALE') {
            genderText = '남성';
          }

          let militaryServiceText = '미필';
          if (userInfo.militaryService === 'COMPLETED') {
            militaryServiceText = '군필';
          } else if (userInfo.militaryService === 'EXEMPTED') {
            militaryServiceText = '면제';
          }

          let nationalityText = '외국인';
          if (userInfo.nationality === 'KOREAN') {
            nationalityText = '한국인';
          }

          let payText = '미입력';
          if (userInfo.pay) {
            payText = userInfo.payType + ' ' + userInfo.pay + '만원';
          }

          let introduceSection = '';
          if (userInfo.introduce) {
            introduceSection = '<div class="introduce-section">' +
              '<div>자기소개</div>' +
              '<div class="introduce-content">' + userInfo.introduce + '</div>' +
              '</div>';
          }

          userDetailInfo.innerHTML =
            '<div>주소</div><div>' + (userInfo.addr || '등록된 주소 없음') + '</div>' +
            '<div>성별</div><div>' + genderText + '</div>' +
            '<div>나이</div><div>' + (userInfo.age || '미입력') + '</div>' +
            '<div>병역사항</div><div>' + militaryServiceText + '</div>' +
            '<div>국적</div><div>' + nationalityText + '</div>' +
            '<div>희망급여</div><div>' + payText + '</div>' +
            introduceSection;
        }

        function formatDate(dateString) {
          if (!dateString) return '미입력';
          const date = new Date(dateString);
          return date.toLocaleDateString('ko-KR', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
          });
        }

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

        function checkPassword() {
          uid = "${sessionScope.account.uid}"
          nowPassword = document.getElementById('nowPassword').value

          $.ajax({
            url: "/user/password",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({ uid, password: nowPassword }),
            success: (result) => {
              if (result === true) {
                // 비밀번호 변경 2차 인증(전화, 이메일)창 띄우기기
                alert("비밀번호 확인 완료. 인증을 진행해주세요.");
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
          // firebase 국제번호형식으로 받아서 바꾸는용도
          const phoneNumber = formatPhoneNumberForFirebase(rawPhone);

          firebaseCaptcha()
          try {
            confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
            alert("인증 코드가 전송되었습니다.");
          } catch (error) {
            console.error("전화번호 인증 실패:", error);
            alert("전화번호 인증 중 오류 발생.");
          }
        }
        async function endVerifiPwdMobile() {
          const mobileCode = document.getElementById('pwdToPhoneCode').value

          try {
            await confirmationResult.confirm(mobileCode);
            viewChangePassword(); // 성공 후 콜백 실행
          } catch (error) {
            console.error("코드 인증 실패:", error);
            alert("잘못된 인증 코드입니다.");
          }
        }

        async function startVerifiPhonePne() {
          const rawPhone = document.getElementById('changeMobile').value;

          document.getElementById('authMobile').value = rawPhone;

          // firebase 국제번호형식으로 받아서 바꾸는용도
          const phoneNumber = formatPhoneNumberForFirebase(rawPhone);

          firebaseCaptcha()
          try {
            confirmationResult = await auth.signInWithPhoneNumber(phoneNumber, window.recaptchaVerifier);
            alert("인증 코드가 전송되었습니다.");
          } catch (error) {
            console.error("전화번호 인증 실패:", error);
            alert("전화번호 인증 중 오류 발생.");
          }
        }
        async function endVerifiPneMobile() {
          const mobileCode = document.getElementById('pneToPhoneCode').value
          try {
            await confirmationResult.confirm(mobileCode); // 코드 틀렸으면 여기서  catch로 넘어감감

            const uid = document.getElementById("uid").value;
            const intlPhone = document.getElementById("authMobile").value;
            const value = formatToKoreanPhoneNumber(intlPhone);

            const dto = {
              type: "mobile",
              value,
              uid
            };

            $.ajax({
              url: "/user/contact",
              method: "patch",
              contentType: "application/json",
              data: JSON.stringify(dto),
              success: (val) => {
                alert("전화번호가 변경되었습니다.");
                document.getElementById("nowMobile").innerText = `\${val}`;
                document.getElementById("changeMobile").value = "";
                document.getElementById("pneToPhoneCode").value = "";
                document.getElementById("authMobile").value = "";
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

        async function startVerifiEmailPwd() {
          const email = "${sessionScope.account.email}"
          $.ajax({
            url: "/account/auth/email",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({ email }),
            async: false,
            success: (res) => { alert("메일 전송 성공: " + res) },
            error: (xhr) => { alert("메일 전송 중 오류 발생: " + xhr.responseText) }
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
            success: () => { viewChangePassword() },
            error: (xhr) => { alert("이메일 인증 실패: " + xhr.responseText) }
          });
        }

        async function startVerifiEmailPne() {

          const email = document.getElementById('changeEmail').value;

          document.getElementById('authEmail').value = email;

          $.ajax({
            url: "/account/auth/email",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({ email }),
            async: false,
            success: (res) => { alert("메일 전송 성공: " + res) },
            error: (xhr) => { alert("메일 전송 중 오류 발생: " + xhr.responseText) }
          });

        }

        async function endVerifiPneEmail() {
          const email = document.getElementById("authEmail").value;

          const emailCode = document.getElementById('pneToEmailCode').value

          $.ajax({
            url: `/account/auth/email/${emailCode}`,
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({ email: email }),
            async: false,
            success: () => {
              const uid = document.getElementById("uid").value;

              const dto = {
                type: "email",
                email,
                uid
              };

              $.ajax({
                url: "/user/contact",
                method: "patch",
                contentType: "application/json",
                data: JSON.stringify(dto),
                success: (val) => {
                  alert("이메일이 변경되었습니다.");
                  document.getElementById("nowEmail").innerText = `\${val}`;
                  document.getElementById("changeEmail").value = "";
                  document.getElementById("pneToEmailCode").value = "";
                  document.getElementById("authEmail").value = "";
                },
                error: (xhr) => {
                  alert("인증 처리 중 오류가 발생했습니다.");
                  console.error(xhr.responseText);
                }
              });
            },
            error: (xhr) => { alert("이메일 인증 실패: " + xhr.responseText) }
          });

        }

        function changePassword() {
          const changePassword = document.getElementById('changePassword').value
          const checkPassword = document.getElementById('checkPassword').value
          if (changePassword !== checkPassword) {
            alert("비밀번호가 일치하지 않습니다.");
            return;
          }

          const uid = document.getElementById('uid').value;

          $.ajax({
            url: "/user/password",
            method: "patch",
            contentType: "application/json",
            data: JSON.stringify({ uid, password: changePassword }),
            success: () => {
              alert("비밀번호가 성공적으로 변경되었습니다.");
              // 입력 필드 초기화
              document.getElementById('changePassword').value = "";
              document.getElementById('checkPassword').value = "";
              document.getElementById('nowPassword').value = "";
              document.getElementById('changePwdTap').style.display = "none";
            },
            error: (xhr) => {
              alert("비밀번호 변경 중 오류가 발생했습니다.");
              console.error(xhr.responseText);
            }
          });
        }

        function viewChangePassword() {
          document.getElementById("changePwdTap").style.display = "block";
        }

        // 스크롤 시 네비게이터 활성화
        $(document).ready(function () {
          // 초기 활성화 상태 설정
          updateActiveSection();

          // 스크롤 이벤트에 디바운스 적용
          let scrollTimeout;
          $(window).scroll(function () {
            clearTimeout(scrollTimeout);
            scrollTimeout = setTimeout(updateActiveSection, 100);
          });
        });

        function updateActiveSection() {
          var scrollPosition = $(window).scrollTop() + 100; // 오프셋 조정

          $('.page-navigator a').each(function () {
            var targetId = $(this).attr('href');
            var targetSection = $(targetId);

            if (targetSection.length) {
              var sectionTop = targetSection.offset().top - 100;
              var sectionBottom = sectionTop + targetSection.height();

              if (scrollPosition >= sectionTop && scrollPosition < sectionBottom) {
                $('.page-navigator a').removeClass('active');
                $(this).addClass('active');
              }
            }
          });
        }

        // 네비게이터 클릭 시 부드러운 스크롤
        $('.page-navigator a').on('click', function (e) {
          e.preventDefault();
          var targetId = $(this).attr('href');
          var targetSection = $(targetId);

          if (targetSection.length) {
            $('html, body').animate({
              scrollTop: targetSection.offset().top - 100
            }, 500);
          }
        });

        function openContactModal() {
          const modal = document.getElementById('basicModal');
          const modalTitle = modal.querySelector('.modal-title');
          const modalBody = modal.querySelector('.modal-body');
          const modalButtons = modal.querySelector('.modal-buttons');

          modalTitle.textContent = '연락처 수정';
          modalBody.innerHTML = `
        <div class="form-group">
            <label>현재 전화번호</label>
            <input type="text" id="nowMobile" value="${sessionScope.account.mobile}" readonly>
        </div>
        <div class="form-group">
            <label>새 전화번호</label>
            <input type="text" id="changeMobile" placeholder="새 전화번호를 입력하세요">
        </div>
        <div class="verification-group">
            <input type="text" id="pneToPhoneCode" placeholder="인증번호 입력">
            <button onclick="startVerifiPhonePne()">인증번호 받기</button>
        </div>
        <div class="form-group">
            <label>현재 이메일</label>
            <input type="email" id="nowEmail" value="${sessionScope.account.email}" readonly>
        </div>
        <div class="form-group">
            <label>새 이메일</label>
            <input type="email" id="changeEmail" placeholder="새 이메일을 입력하세요">
        </div>
        <div class="verification-group">
            <input type="text" id="pneToEmailCode" placeholder="인증번호 입력">
            <button onclick="startVerifiEmailPne()">인증번호 받기</button>
        </div>
        <input type="hidden" id="uid" value="${sessionScope.account.uid}">
        <input type="hidden" id="authMobile" value="">
        <input type="hidden" id="authEmail" value="">
    `;

          modalButtons.innerHTML = `
        <button onclick="closeModal()" class="btn-cancel">취소</button>
        <button onclick="confirmContactChange()" class="btn-confirm">확인</button>
    `;

          document.getElementById('basicModal').style.display = 'flex';
          document.getElementById('basicModalOverlay').style.display = 'block';
        }

        function openPasswordModal() {
          const modal = document.getElementById('basicModal');
          const modalTitle = modal.querySelector('.modal-title');
          const modalBody = modal.querySelector('.modal-body');
          const modalButtons = modal.querySelector('.modal-buttons');

          modalTitle.textContent = '비밀번호 변경';
          modalBody.innerHTML = `
        <div class="form-group">
            <label>현재 비밀번호</label>
            <input type="password" id="nowPassword" placeholder="현재 비밀번호를 입력하세요">
        </div>
        <div class="form-group">
            <label>새 비밀번호</label>
            <input type="password" id="changePassword" placeholder="새 비밀번호를 입력하세요">
        </div>
        <div class="form-group">
            <label>새 비밀번호 확인</label>
            <input type="password" id="checkPassword" placeholder="새 비밀번호를 다시 입력하세요">
        </div>
        <input type="hidden" id="uid" value="${sessionScope.account.uid}">
    `;

          modalButtons.innerHTML = `
        <button onclick="closeModal()" class="btn-cancel">취소</button>
        <button onclick="confirmPasswordChange()" class="btn-confirm">확인</button>
    `;

          document.getElementById('basicModal').style.display = 'flex';
          document.getElementById('basicModalOverlay').style.display = 'block';
        }

        function confirmContactChange() {
          // 연락처 변경 확인 로직
          closeModal();
        }

        function confirmPasswordChange() {
          const nowPassword = document.getElementById('nowPassword').value;
          const changePassword = document.getElementById('changePassword').value;
          const checkPassword = document.getElementById('checkPassword').value;

          if (!nowPassword || !changePassword || !checkPassword) {
            alert('모든 필드를 입력해주세요.');
            return;
          }

          if (changePassword !== checkPassword) {
            alert('새 비밀번호가 일치하지 않습니다.');
            return;
          }

          // 비밀번호 변경 인증 모달 표시
          const modal = document.getElementById('basicModal');
          const modalTitle = modal.querySelector('.modal-title');
          const modalBody = modal.querySelector('.modal-body');
          const modalButtons = modal.querySelector('.modal-buttons');

          modalTitle.textContent = '비밀번호 변경 인증';
          modalBody.innerHTML = `
        <div class="form-group">
            <label>인증 방법 선택</label>
            <div style="display: flex; gap: 10px;">
                <button onclick="startVerifiPhonePwd()" class="btn-edit">전화번호 인증</button>
                <button onclick="startVerifiEmailPwd()" class="btn-edit">이메일 인증</button>
            </div>
        </div>
        <div id="verificationInputs" style="display: none;">
            <div class="verification-group">
                <input type="text" id="verificationCode" placeholder="인증번호 입력">
                <button onclick="confirmVerification()" class="btn-confirm">확인</button>
            </div>
        </div>
    `;

          modalButtons.innerHTML = `
        <button onclick="closeModal()" class="btn-cancel">취소</button>
    `;
        }

        function confirmVerification() {
          const code = document.getElementById('verificationCode').value;
          if (!code) {
            alert('인증번호를 입력해주세요.');
            return;
          }

          // 인증 확인 후 비밀번호 변경 진행
          changePassword();
          closeModal();
        }
      </script>

      <!-- 풋터 -->
      <jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>