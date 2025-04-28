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
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js"
	integrity="sha384-dok87au0gKqJdxs7msEdBPNnKSRT+/mhTVzq+qOhcL464zXwvcrpjeWvyj1kCdq6"
	crossorigin="anonymous"></script>

<link href="/resources/css/mypage.css" rel="stylesheet">

<!-- 이미지자르기 Cropper.js -->
<link rel="stylesheet" href="https://unpkg.com/cropperjs@1.5.13/dist/cropper.min.css">
<script src="https://unpkg.com/cropperjs@1.5.13/dist/cropper.min.js"></script>


<main class="main" data-aos="fade-up">
  <h1 class="page-title">마이페이지</h1>

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
          <div>이름</div><div><span id="userName">로딩중...</span><i class="nameChangeBtn" onclick="changeNameModal()">변경</i></div>
          <div>전화번호</div><div id="nowMobile">로딩중...</div>
          <div>이메일</div><div id="nowEmail">로딩중...</div>
          <div>가입일</div><div id="regDate">로딩중...</div>
          <div>최근 로그인</div><div id="lastLoginDate">로딩중...</div>
          <div>포인트</div><div><span id="userPoint">0</span>포인트 · <i class="nameChangeBtn" onclick="purchasePoints()">충전하기</i></div>
          <div id="accountDeleteDateTitle" style="color: var(--bs-red); font-size: 0.8em;"></div>
          <div id="accountDeleteDateBlock" style="color: var(--bs-red); font-size: 0.8em;"></div>

          <c:if test="${sessionScope.account.isSocial == 'N'}">
            <hr><hr>
            <h4 style="margin-top:7px;">카카오 연동 :</h4>
            <div class="btn-kakao" onclick="linkToKakaoBtn()">
              <img src="/resources/forKakao/kakao_login_medium_narrow.png"
                alt="kakao">
            </div>
          </c:if>

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
            <div>주소</div><div>로딩중...</div>
            <div>상세주소</div><div>로딩중...</div>
            <div>성별</div><div>로딩중...</div>
            <div>나이</div><div>로딩중...</div>
            <div>병역사항</div><div>로딩중...</div>
            <div>국적</div><div>로딩중...</div>
            <div>희망급여</div><div>로딩중...</div>
            <div>장애여부</div><div>로딩중...</div>
            <div class="introduce-section"><div class="introduce-title">자기소개</div><div class="introduce-content">로딩중...</div></div>
            <div class="edit-buttons">
            <button class="btn-edit" onclick="modyfiInfoTapOpen()"><i class="bi bi-pencil-square"></i> 상세정보 수정</button>

            <button id="accountDeleteBtn" class="btn-edit btn-delete" style="background-color:#dc3545; margin-left: auto;" onclick="deleteAccount()"> 계정 삭제 신청</button>
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
                  <input type="text" class="form-control" id="addressDetail" placeholder="상세주소를 입력하세요" style="display: none;">
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
                  <option value="DOMESTIC">내국인</option>
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
          <h2 onclick="toggleResumeSectionItems()" style="cursor: pointer;"><i class="bi bi-heart section-icon"></i>신청한 이력서<span style="font-size:0.7em"> ▼ </span></h2>
          <span class="resumeSectionItems" style="display:none;"><button class="btn-edit" onclick="resumeReadOnly()" id="resumeReadOnlyBtn">조회된 신청서만 검색</button></span>
          <span class="resumeSectionItems" style="display:none; float:right"><button class="btn-edit" onclick="resumeSortOption()" id="resumeSortOptionBtn">최신순으로 정렬</button></span>
          
        </div>
        <div id="resumeSection" class="resumeSectionItems" style="display:none;"></div>
      </section>

      <!-- 리뷰 영역 -->
      <section data-aos="fade-up" data-aos-delay="400">
        <div class="section-title">
          <h2 onclick="toggleReviewSectionItems()" style="cursor: pointer;"><i class="bi bi-heart section-icon"></i>작성한 리뷰<span style="font-size:0.7em"> ▼ </span></h2>
          <button class="btn-edit reviewSectionItems" style="display:none;" onclick="openReviewSearchModal()">리뷰 검색 옵션</button>
        </div>
        <div id="reviewSection" class="reviewSectionItems" style="display:none;"></div>
      </section>

      <!-- 첨삭답변 -->
      <section data-aos="fade-up" data-aos-delay="400">
        <div class="section-title">
          <h2 onclick="toggleResumeAdviceSectionItems()" style="cursor: pointer;"><i class="bi bi-heart section-icon"></i>답변받은 이력서 첨삭<span style="font-size:0.7em"> ▼ </span></h2>
        </div>
        <div id="resumeAdviceSection" class="resumeAdviceSectionItems" style="display:none;"></div>
      </section>

	<c:if test="${account.isMentor == 'Y'}">
      <!-- 멘토등록글 -->
      <section data-aos="fade-up" data-aos-delay="400">
        <div class="section-title">
          <h2 onclick="togglePrboardSectionItems()" style="cursor: pointer;"><i class="bi bi-heart section-icon"></i>등록한 멘토pr글<span style="font-size:0.7em"> ▼ </span></h2>
        </div>
        <div id="prboardSection" class="prboardSectionItems" style="display:none;"></div>
      </section>
	</c:if>
      <!-- 첨삭신청 -->
      <section data-aos="fade-up" data-aos-delay="400">
        <div class="section-title">
          <h2 onclick="toggleRegistrationAdviceSectionItems()" style="cursor: pointer;"><i class="bi bi-heart section-icon"></i>첨삭 요청<span style="font-size:0.7em"> ▼ </span></h2>
          <div class="registrationAdviceSelectBox registrationAdviceSectionItems" style="display:none;">
          	<c:if test="${account.isMentor == 'Y'}">
            <select id="typeSelect" class="form-select" onchange="handleTypeChange()">
              <option value="mentor">내가 받은 첨삭요청</option>
              <option value="mentee">내가 신청한 첨삭요청</option>
            </select>
            </c:if>
            <select id="statusSelect" class="form-select" onchange="handleStatusChange()">
              <option value="LIVE">*처리 대기 중*</option>
              <option value="WAITING">미확인</option>
              <option value="CHECKING">검토 중</option>
              <option value="COMPLETE" style="color: #8d8d8d;">완료한 신청 보기</option>
              <option value="CANCEL" style="color: #8d8d8d;">취소된 신청 보기</option>
              <option value="">--전체 내역 보기--</option>
            </select>
          </div>
        </div>
        <div id="registrationAdviceSection" class="registrationAdviceSectionItems" style="display:none;"></div>
      </section>
      
    </div>
  </div>

  <!-- firebase캡챠 -->
  <div id="recaptcha-container"></div>
</main>

<script>
// #region 카톡
function purchasePoints() {
	    fetch("/kakao/pay/ready", {
	      method: "POST",
	      headers: { "Content-Type": "application/json" },
	      body: JSON.stringify({
	        item_name: "5000포인트 충전",
	        total_amount: 5000
	      })
	    })
	    .then(res => res.json())
	    .then(data => {
	      if (data.next_redirect_pc_url) {
	        window.location.href = data.next_redirect_pc_url;
	      } else {
	        alert("결제 URL 생성 실패");
	      }
	    });
	}
	
function linkToKakaoBtn() {
  window.publicModals.show("<div>연동한 카카오 계정의 이메일로 고정되며,</div><br><div>동일한 이메일을 다른 계정이 사용중이면</div><div>카카오 계정 연동에 실패할 수 있습니다.</div><br><div>카카오 계정에 연동하시겠습니까?</div>", 
  {
    onConfirm: linkToKakao,
    confirmText: "연동하기",
    size_x: "400px",
  })
}

Kakao.init('b50a2700ff109d1ab2de2eca4e07fa23');
Kakao.isInitialized();

	function linkToKakao() {
		// JSP에서 contextPath 동적으로 주입
		let contextPath = '${pageContext.request.contextPath}';
		if (contextPath) {
			contextPath = '/' + contextPath;
		}
		const redirectUri = `\${location.protocol}//\${location.host}\${contextPath}/user/kakao/link`;

		Kakao.Auth.authorize({
		redirectUri: redirectUri,
		scope: 'profile_nickname, account_email'
		});
	}
// #endregion 카톡

// #region 본인 작성 글 리스트들 출력
function renderPagination(res, pageFunc, container) {
  const { pageList, currentPage, hasPrevBlock, hasNextBlock, startPage, endPage } = res;

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
    html += `<button class="btn-edit" onclick="\${pageFunc}(\${startPage - 1})">« 이전</button>`;
  }

  pageList.forEach(p => {
    html += `<button class="btn-edit \${p === currentPage ? 'active' : ''}" onclick="\${pageFunc}(\${p})" style="\${p === currentPage ? 'background:#3a8fb8;' : ''}">\${p}</button>`;
  });

  if (hasNextBlock) {
    html += `<button class="btn-edit" onclick="\${pageFunc}(\${endPage + 1})">다음 »</button>`;
  }

  html += '</div>';
  container.append(html);
}

function renderResumeAdvice(res) {
  const items = res.items;
	  const container = $('#resumeAdviceSection');
	  container.empty();

	  if (!items || items.length === 0) {
	    container.html(`
	      <div class="empty-state">
	        <i class="fas fa-folder-open"></i><br>
	        검색된 신청글이 없습니다.
	      </div>
	    `);
	    return;
	  }

	  let html = '<div class="recruit-card-list" style="display: flex; flex-direction: column; gap: 12px;">';

	  items.forEach(item => {
	    html += `
        <div class="recruit-card-wrapper">
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
            cursor: pointer;"
            onclick="viewResumeAdvice(\${item.resumeNo}, \${item.menteeUid})">
            
            <div style="flex: 1;">
              <div><strong>\${item.title}\${item.menteeUid}</strong></div>
              <div style="font-size: 13px; color: #666;">
                <div>\${item.mentorName}</div>
                \${formatDate(item.regDate)}작성
              </div>
            </div>

          </div>
        </div>
      `;
	  });

	  html += '</div>';
	  container.html(html);

    renderPagination(res, "goToResumeAdvice", container)
}
function viewResumeAdvice(resumeNo, menteeUid) {
  location.href=`/resume/checkAdvice/\${resumeNo}?uid=\${menteeUid}`
}

function goToResumeAdvice(pageNum) {
  resumeAdvicePage = pageNum;
	getMyResumeAdvice();
}

let resumeAdvicePage = 1
function getMyResumeAdvice() {
  $.ajax({
    url: `/resume/myResumeAdvice/\${resumeAdvicePage}`,
    method: 'POST',
    contentType: 'application/json',
    success: function(res) {
      console.log(res);
      renderResumeAdvice(res)
    },
    error: function(xhr) {
      console.log("error : " + xhr);
    }
  });
}
function renderSendRegistrationAdvice(res) {
  const items = res.items;
	  const container = $('#registrationAdviceSection');
	  container.empty();

	  if (!items || items.length === 0) {
	    container.html(`
	      <div class="empty-state">
	        <i class="fas fa-folder-open"></i><br>
	        검색된 신청글이 없습니다.
	      </div>
	    `);
	    return;
	  }

	  let html = '<div class="recruit-card-list" style="display: flex; flex-direction: column; gap: 12px;">';

	  items.forEach(item => {
      const status = {
        COMPLETE: "<span style='color:var(--bs-teal)'>첨삭완료</span>",
        CANCEL: "<span style='color:var(--bs-red)'>거절됨</span>",
        WAITING: "<span style='color:var(--bs-gray-400)'>대기중</span>",
        CHECKING: "<span style='color:var(--accent-color)'>첨삭진행중</span>",
      }

      const statusText = status[item.status];

	    html += `
        <div class="recruit-card-wrapper">
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
            align-items: center;>
            
            <div style="flex: 1;">
              <div><strong>\${item.title}</strong>\${statusText}</div>
              <div style="font-size: 13px; color: #666;">
                \${formatDate(item.regDate)} 신청
              </div>
            </div>
          </div>
        </div>
      `;
	  });

	  html += '</div>';
	  container.html(html);

    renderPagination(res, "goToRegistrationAdvice", container)
}

function renderRegistrationAdvice(res) {
  const items = res.items;
	  const container = $('#registrationAdviceSection');
	  container.empty();

	  if (!items || items.length === 0) {
	    container.html(`
	      <div class="empty-state">
	        <i class="fas fa-folder-open"></i><br>
	        검색된 신청글이 없습니다.
	      </div>
	    `);
	    return;
	  }

	  let html = '<div class="recruit-card-list" style="display: flex; flex-direction: column; gap: 12px;">';

	  items.forEach(item => {

      const confirmBtn = `
        <button class='btn-edit' onclick="acceptAdviceModal(\${item.resumeNo}, \${item.menteeUid})">승인</button>
        <button class='btn-edit' onclick="rejectAdviceModal(\${item.resumeNo}, \${item.menteeUid})" style='background:var(--bs-gray-300); color:var(--default-color)'>거절</button>`;

      const status = {
        COMPLETE: "<span style='color:var(--bs-teal);'>첨삭완료</span>",
        CANCEL: "<span style='color:var(--bs-red)'>취소</span>",
        WAITING: confirmBtn,
        CHECKING: `<button class='btn-edit' onclick="location.href='/resume/checkAdvice/\${item.resumeNo}?uid=\${item.menteeUid}'">조회 및 수정</button>`,
      }

      const statusText = status[item.status];

	    html += `
        <div class="recruit-card-wrapper">
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
            align-items: center;>
            
              <div style="flex: 1;">
                <div>
                <div><strong>\${item.title}\${item.menteeUid}</strong></div>
                <div style="font-size: 13px; color: #666;">
                  \${formatDate(item.regDate)} 신청
                </div></div>

                <div style='display: flex; align-items: center; gap: 8px'>
                  \${statusText}
                </div>

              </div>
          </div>
        </div>
      `;
	  });

	  html += '</div>';
	  container.html(html);

    renderPagination(res, "goToRegistrationAdvice", container)
}

function goToRegistrationAdvice(pageNum) {
  registrationAdviceData.page = pageNum;
	getMyRegistrationAdvice();
}

function handleStatusChange() {
  const selected = document.getElementById('statusSelect').value;
  registrationAdviceData.status = selected || registrationAdviceStatus.NONE;

  getMyRegistrationAdvice();
}
function handleTypeChange() {
  registrationAdviceData.type = document.getElementById('typeSelect').value;
  getMyRegistrationAdvice();
}
const registrationAdviceStatus = {
  NONE: null,
  COMPLETE: 'COMPLETE',
  CANCEL: 'CANCEL',
  WAITING: 'WAITING',
  CHECKING: 'CHECKING',
  LIVE: "LIVE"
};
const registrationAdviceData = {
  page: 1,
  status: registrationAdviceStatus.LIVE,
  type: "mentor"
};
function getMyRegistrationAdvice() {
  const type = registrationAdviceData.type;
  $.ajax({
    url: `/resume/myRegistrationAdvice`,
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({
      page: registrationAdviceData.page,
      status: registrationAdviceData.status
    }),
    success: function(res) {
      console.log(res);
      if (type == 'mentor') {
        renderRegistrationAdvice(res)
      } else {
        renderSendRegistrationAdvice(res)
      }
    },
    error: function(xhr) {
      console.log("error : " + xhr);
    }
  });
}

let prboardPage = 1
function getMyPrboard() {
  const url = `/prboard/myPr/\${uid}/\${prboardPage}`
  $.ajax({
    url: url,
    method: 'POST',
    contentType: 'application/json',
    success: function(res) {
      renderPrboard(res)
    },
    error: function(xhr) {
      console.log("error : " + xhr);
    }
  });
}

function renderPrboard(res) {
  const items = res.items;
	  const container = $('#prboardSection');
	  container.empty();

	  if (!items || items.length === 0) {
	    container.html(`
	      <div class="empty-state">
	        <i class="fas fa-folder-open"></i><br>
	        등록된 멘토 첨삭 지원 프로필이 없습니다.
	      </div>
	    `);
	    return;
	  }

	  let html = '<div class="recruit-card-list" style="display: flex; flex-direction: column; gap: 12px;">';

	  items.forEach(item => {
	    html += `
        <div class="recruit-card-wrapper">
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
            cursor: pointer;"
            onclick="viewPrboard(\${item.prBoardNo})">
            
            <div style="flex: 1;">
              <div><strong>\${item.title}</strong></div>
              <div style="font-size: 13px; color: #666;">
                \${formatDate(item.postDate)} 신청
              </div>
            </div>
          </div>
        </div>
      `;
	  });

	  html += '</div>';
	  container.html(html);

    renderPagination(res, "goToPrboardPage", container)
}
function viewPrboard(prBoardNo) {
  // pr보드 글 상세조회 페이지로 보내기
  location.href = `/prboard/detail?prBoardNo=\${prBoardNo}`;
}
function goToPrboardPage(pageNum) {
  prboardPage = pageNum;
	getMyPrboard();
}

function viewRecruitDetail(uid) {
  location.href = `/recruitmentnotice/detail?uid=\${uid}`;
}

function resumeReadOnly() {
  requestResumeData.onlyUnread = !requestResumeData.onlyUnread;
  requestResumeData.page = 1;
  const text = requestResumeData.onlyUnread? "모든 신청서 조회" : "조회된 신청서만 검색"
  $('#resumeReadOnlyBtn').text(text);
  getMyResumes()
}

function resumeSortOption() {
  requestResumeData.prioritizeUnread = !requestResumeData.prioritizeUnread;
  requestResumeData.page = 1;
  const text = requestResumeData.prioritizeUnread? "최신순으로 정렬" : "조회된 신청서 우선검색";
  $('#resumeSortOptionBtn').text(text);
  getMyResumes()
}

const requestResumeData = {
    page: 1,
    onlyUnread: false,
    prioritizeUnread: true
  };


function getMyResumes() {
  const listContainer = $('#resumeSection')

  $.ajax({
    url: '/submit/withUser',
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({
      uid: uid,
      page: requestResumeData.page,
      onlyUnread: requestResumeData.onlyUnread,
      prioritizeUnread: requestResumeData.prioritizeUnread
    }),
    success: function(res) {
      renderResumeList(res.items)
      renderPagination(res, "goToResumePage", $('#resumeSection'))
    },
    error: function(xhr) {
      console.log("error : " + xhr);
    }
  });
}


function renderResumeList(items) {
	  const container = $('#resumeSection');
	  container.empty();

	  if (!items || items.length === 0) {
	    container.html(`
	      <div class="empty-state">
	        <i class="fas fa-folder-open"></i><br>
	        검색된 신청서가 없습니다.
	      </div>
	    `);
	    return;
	  }

	  let html = '<div class="recruit-card-list" style="display: flex; flex-direction: column; gap: 12px;">';

	  items.forEach(item => {
	    html += `
        <div class="recruit-card-wrapper">
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
            align-items: center;">
            
            <div style="flex: 1;">
              <div><strong>\${item.recruitTitle}</strong></div>
              <div style="font-size: 13px; color: #666;">
                <div>\${item.resumeTitle}</div>
                \${formatDate(item.regDate)} 신청 · 상태 : \${item.statusDisplayName}
              </div>
            </div>

            <button class="btn-edit" onclick="event.stopPropagation(); viewRecruitDetail(\${item.recruitNo})">
              대상 공고 보기
            </button>
          </div>
        </div>
      `;
	  });

	  html += '</div>';
	  container.html(html);
}

function goToResumePage(pageNum) {
  requestResumeData.page = pageNum;
	getMyResumes();
}

const reviewSortType = {
  LIKES: "likes",
  VIEWS: "views",
  POSTDATE: "postDate"
}

const reviewFilter = {
  IS: "isReply",
  NOT: "notReply"
}

const requestReviewData = {
    page: 1,
    sortType: reviewSortType.POSTDATE,
    resultFilter: reviewFilter.NOT
  };

function getMyReview() {
  const data = {
    page: requestReviewData.page,
    size: 5,
    sortType: requestReviewData.sortType,
    resultFilter: requestReviewData.resultFilter,
    writer: uid
  };

  $.ajax({
    url: '/reviewBoard/myReview',
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(data),
    success: function(res) {
      renderReviewList(res.items)
      renderPagination(res, "goToReviewPage", $('#reviewSection'))
    },
    error: function(xhr) {
      console.log("에러 발생", xhr);
    }
  });
}

function openReviewSearchModal() {
  const text = `
  <h2>검색 조건</h2>
  <select id="sortTypeSelect">
    <option value="postDate">최신순</option>
    <option value="likes">좋아요순</option>
    <option value="views">조회수순</option>
  </select>

  <select id="resultFilterSelect">
    <option value="notReply">전체</option>
    <option value="isReply">댓글 있는 것만</option>
  </select>
  `
  window.publicModals.show(text, {cancelText:'취소', onConfirm:()=>{
    requestReviewData.page = 1;
    requestReviewData.resultFilter = $('#resultFilterSelect').val();
    requestReviewData.sortType = $('#sortTypeSelect').val();
    getMyReview();
  }})
}

function goToReviewPage(pageNum) {
  requestReviewData.page = pageNum;
	getMyReview();
}

function renderReviewList(items) {
	  const container = $('#reviewSection');
	  container.empty();

	  if (!items || items.length === 0) {
	    container.html(`
	      <div class="empty-state">
	        <i class="fas fa-folder-open"></i><br>
	        검색된 리뷰가 없습니다.
	      </div>
	    `);
	    return;
	  }

	  let html = '<div class="recruit-card-list" style="display: flex; flex-direction: column; gap: 12px;">';

	  items.forEach(item => {
	    html += `
        <div class="recruit-card-wrapper">
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
            cursor: pointer;"
            onclick="viewReviewDetail(\${item.boardNo})">
            
            <div style="flex: 1;">
              <div><strong>\${item.companyName}</strong></div>
              <div style="font-size: 13px; color: #666;">
                <div>\${item.content}</div>
                \${formatDate(item.postDate)}작성 · 댓글 \${item.replyCnt}건 · 
                <span style="color: #999;">\${item.views} <i class="bi bi-eye"></i> · \${item.likes} <i class="bi bi-hand-thumbs-up"></i></span>
              </div>
            </div>
            
          </div>
        </div>
      `;
	  });

	  html += '</div>';
	  container.html(html);
}

function renderPaginationReview(res) {
  const { pageList, currentPage, hasPrevBlock, hasNextBlock, startPage, endPage } = res;
  const container = $('#reviewSection');

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
    html += `<button class="btn-edit" onclick="goToReviewPage(\${startPage - 1})">« 이전</button>`;
  }

  pageList.forEach(p => {
    html += `<button class="btn-edit \${p === currentPage ? 'active' : ''}" onclick="goToReviewPage(\${p})" style="\${p === currentPage ? 'background:#3a8fb8;' : ''}">\${p}</button>`;
  });

  if (hasNextBlock) {
    html += `<button class="btn-edit" onclick="goToReviewPage(\${endPage + 1})">다음 »</button>`;
  }

  html += '</div>';
  container.append(html);
}

function viewReviewDetail(boardNo) {
  // 상세 페이지 이동
  location.href = `/reviewBoard/detail?boardNo=\${boardNo}&page=1`;
}

// #endregion

// #region 전역 변수 및 초기화
const uid = "${sessionScope.account.uid}"
let sessionMobile = "${sessionScope.account.mobile}";
let sessionEmail = "${sessionScope.account.email}";
let isSocial = ("${sessionScope.account.email}" == "Y");

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
    url: "/user/password",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({ uid, password: nowPassword }),
    success: (result) => {
      if (result === true) {
        window.publicModals.show("<div>정말로 삭제하시겠습니까?</div><div style='font-size:0.7em; color:var(--bs-gray-600)'>계정은 3일 뒤 삭제되며 포인트가 소멸할 수 있습니다.</div>", {
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
      url: "/user/info/${sessionScope.account.uid}",
      method: "GET",
      success: (result) => {
        isSocial = result.isSocial == 'Y';
        sessionMobile = result.mobile;
  		  sessionEmail = result.email;
        console.log(result.blockDeadline);
        console.log(result.deleteDeadline);
        updateDeleteAccountInfo(result.deleteDeadline, result.blockDeadline)
        resetUserModifyForm();
        updateBasicInfo(result);
        updateUserDetailInfo(result);
        updateUserModifyInfo(result);
      },
      error: (xhr) => {
        console.log('xhr.code: ', xhr)
        window.publicModals.show(
          "정보 로딩에 실패하였습니다. 잠시후 새로고침해 주세요."
        )
      }
  });
}

// 기본정보 로딩
function updateBasicInfo(userInfo) {
  $('#profileImg').html(`<img src="\${userInfo.userImg}" style="width:100%; height:100%; object-fit:cover;">`);
  $('#userName').text( userInfo.userName || '미입력')
  $('#nowMobile').text( userInfo.mobile || '등록된 전화번호 없음')
  $('#nowEmail').text( userInfo.email || '등록된 이메일 없음')
  $('#regDate').text( formatDate(userInfo.regDate))
  $('#lastLoginDate').text( formatDateTime(userInfo.lastLoginDate))
  $('#userPoint').text( userInfo.point || 0)
}

// 상세정보 로딩
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
      } else {
        payText = '회사 내규에 따름';
      }
    }

    let introduceSection = '자기소개가 아직 없습니다.';
    if (userInfo.introduce) {
      introduceSection = userInfo.introduce;
    }

    let disabilityText;

    if (!userInfo.disability) {
      disabilityText = '미입력';
    } else if (userInfo.disability == 'NONE') {
      disabilityText = '비대상';
    } else {
      disabilityText = userInfo.disability;
    }

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

    const values = [
    userInfo.addr || '등록된 주소 없음',
    userInfo.detailAddr || '등록된 상세주소 없음',
    genderText,
    (userInfo.age ? userInfo.age + ' 세' : '미입력'),
    militaryServiceText,
    nationalityText,
    payText,
    disabilityText
  ];

  const divs = userDetailInfo.querySelectorAll(':scope > div:not(.introduce-section):not(.edit-buttons)');

  // 앞에서부터 짝수 인덱스는 label, 홀수 인덱스가 값
  for (let i = 0, valIdx = 0; i < divs.length; i++) {
    if (i % 2 === 1) {
      divs[i].textContent = values[valIdx++];
    }
  }

  // 자기소개
  const introduceDiv = userDetailInfo.querySelector('.introduce-content');
  introduceDiv.textContent = userInfo.introduce || '자기소개가 아직 없습니다.';
  }

// 수정창 내용 초기화
function resetUserModifyForm() {
  // 주소 초기화
  $('#addressSearch').val('');
  $('#selectedAddress').val('').hide();
  $('#addressDetail').val('').hide();
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

// 수정창 갱신
function updateUserModifyInfo(result) {
  const address = result.addr;

  if (result.addr) {
    // 초기화용 주소 저장
    document.getElementById('addressBackup').value = result.addr;
    document.getElementById('selectedAddress').value = result.addr || '';
    document.getElementById('selectedAddress').style.display = 'block'; // 표시
    document.getElementById('addressDetail').style.display = 'block'; // 표시
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

  if (result.payType == '연봉' || result.payType == '월급') {
    document.getElementById('payTitleDiv').style.display = 'block';
    document.getElementById('payDiv').style.display = 'block';
  } else {
    document.getElementById('payTitleDiv').style.display = 'none';
    document.getElementById('payDiv').style.display = 'none';
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

// #endregion 정보 서버에있는걸로 갱신

$(()=>{
  getInfo();
  getMyResumes();
  getMyReview();
  getMyRegistrationAdvice();
  getMyPrboard();
  getMyResumeAdvice();
})

// #region 상세정보 수정 관련
// 상세정보 수정 창 열기
function modyfiInfoTapOpen () {
  bindPayTypeChangeEvent()

  const section = document.getElementById('modifySection');

  // 먼저 display를 block으로 설정
  section.style.display = "block";

  // 잠깐 기다렸다가 클래스를 추가해야 트랜지션이 작동함
  setTimeout(() => {
    section.classList.add("show");
  }, 10);

  section.scrollIntoView({ behavior: 'smooth' });
}

// 연봉타입 변경에 따른 연봉입력란 동적 변화 이벤트 추가
function bindPayTypeChangeEvent() {
  document.getElementById('payType').addEventListener('change', function() {
    document.getElementById('pay').placeholder = '연봉을 입력해주세요';
  
    switch (this.value) {
      case -1:
      case '회사 내규에 따름':
        document.getElementById('payDiv').style.display = 'none';
        document.getElementById('payTitleDiv').style.display = 'none';
        break;
      case '월급':
        document.getElementById('pay').placeholder = '월급을 입력해주세요';
      default:
        document.getElementById('payDiv').style.display = 'block';
        document.getElementById('payTitleDiv').style.display = 'block';
    }
  });
}

// 수정완료
function confirmModify() {
  const nullIfInvalid = (v) => (v === '-1' || v == null || v === '') ? null : v;
  const parseValidNumber = (v) => {
    const n = parseInt(removeComma(v), 10);
    return (isNaN(n) || n < 0) ? null : n;
  };

  // 선택된 값이 -1이면 null로 변환
  let gender = nullIfInvalid($('#gender').val());
  let military = nullIfInvalid($('#military').val());
  let nationality = nullIfInvalid($('#nationality').val());
  let payType = nullIfInvalid($('#payType').val());
  let disability = nullIfInvalid($('#disability').val());
  let addr = nullIfInvalid($('#selectedAddress').val().trim());
  let detailAddr = nullIfInvalid($('#addressDetail').val().trim());
  let introduce = nullIfInvalid($('#introduce').val().trim());
  let age = parseValidNumber($('#age').val());
  let pay = parseValidNumber($('#pay').val());

  const data = {
    addr,
    detailAddr,
    gender,
    age,
    militaryService: military,
    nationality,
    payType,
    pay,
    introduce,
    disability
  };

  $.ajax({
    url: '/user/info/${sessionScope.account.uid}',
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
    url: "/user/password",
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
  <input id="changePassword" type="password" style="min-width: 300px;" placeholder="변경할 비밀번호를 입력하세요.">
  <input id="checkPassword" type="password" style="min-width: 300px;" placeholder="비밀번호를 다시 한번 입력해주세요.">
  `

  const failedText = modalText + text;

  window.publicModals.show(failedText,{
    onConfirm: () => {changePassword(); return false;},
    confirmText:'변경완료',
    cancelText:'취소',
    size_x:'350px'
  })
}

function changePassword() {
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
    url: "/user/password",
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

function deleteMobileModal() {
  $.ajax({
    url: '/user/contact',
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
      getInfo()
    },
    error: function (xhr) {
      window.publicModals.show("삭제에 실패했습니다. 다시 시도해주세요.");
    }
  });
}

function deleteEmailModal() {
  $.ajax({
    url: '/user/contact',
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
      getInfo()
    },
    error: function (xhr) {
      window.publicModals.show("삭제에 실패했습니다. 다시 시도해주세요.");
    }
  });
}

function deleteContactModal() {
  let modalText = `<h2>연락처 삭제</h2>`
  modalText +=
    `<button style="width: 160px;" class="btn-search" onclick="
      window.publicModals.show('정말로 삭제하시겠습니까?',
        {confirmText:'예', cancelText:'아니오', onConfirm:deleteMobileModal}
      )">
    전화번호 삭제</button>`

    if (isSocial) {
      modalText +=
      `<button style="width: 160px;" class="btn-search" onclick="window.publicModals.show('소셜계정은 이메일 삭제가 불가능합니다.')">
      이메일 삭제</button>`
    } else {
      modalText +=
      `<button style="width: 160px;" class="btn-search" onclick="
        window.publicModals.show('정말로 삭제하시겠습니까?',
          {confirmText:'예', cancelText:'아니오', onConfirm:deleteEmailModal}
        )">
      이메일 삭제</button>`
    }
  modalText +=
    `<div style="color:red; margin-top: 10px; text-size:0.8em"><i class="bi bi-exclamation-circle"></i>반드시 하나의 연락처는 남아있어야합니다.</div>`

  window.publicModals.show(modalText,{confirmText:'취소', size_x:'400px'})
  return false;
}

// 연락처 수정 모달
function openContactModal() {

  const headText = `<h2>연락처 수정 및 변경</h2>`;
  
  const mobileText = `<div>변경할 전화번호를 입력해주세요.</div>` + getPhoneInputHTML() + `
      <button style="width: 130px;" class="btn-search" onclick="verifiToNewMobile()">전화인증</button>
  `;

  let emailText = `
	  <div>변경할 이메일을 입력해주세요.</div>
      <input type="text" id="newEmail" style="min-width: 400px; font-size:1.1em; padding:7px 20px" placeholder="변경할 이메일을 입력해주세요.">
        <button style="width: 130px;" class="btn-search" onclick="verifiToNewEmail()">이메일인증</button>
    `

  if (isSocial) {
    emailText = `
	  <div>카카오톡 로그인 계정입니다.</div>
      <input type="text" style="min-width: 530px; font-size:1.1em; padding:7px 20px" value="소셜 계정은 이메일을 변경할 수 없습니다." readonly>
    `
  }

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
        accountType: "USER"
      })
    });

    const message = await res.text(); // 메시지 확인용
    if (res.ok) {
      return false; // 중복 아님
    } else {
      return true; // 중복됨
    }

  } catch (e) {
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
    window.publicModals.show("인증번호 전송중 오류가 발생했습니다. fireBase 사용횟수 초과등의 가능성이 있으니 강제진행을 원하신다면 백도어 버튼을 눌러주세요.", {
      onConfirm: ()=>{backdoor(formattedNumber); return false;},
      confirmText: "백도어",
      cancelText: "닫기"
    });
  }
}

function backdoor(formattedNumber) {
  const dto = {
      type: "mobile",
      value: formattedNumber,
      uid
    };
  
    $.ajax({
      url: "/user/contact",
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
}

async function changeMobile(formattedNumber) {
  const code = $('#verifiCode').val()

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
      url: "/user/contact",
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
    window.publicModals.show("인증에 실패하였습니다. 잠시 후 다시 시도해주세요.")
  }
}

function verifiToNewEmail() {
  const emailInputs = $('#newEmail').val();
  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  if (!emailInputs || !emailRegex.test(emailInputs)) {
    window.publicModals.show('올바른 이메일을 입력해주세요.', {onConfirm:()=>{openContactModal(); return false;}});
    return;
  }

  $.ajax({
    url: "/account/auth/email",
    method: "POST",
    contentType: "application/json",
    data: JSON.stringify({ 
      email: emailInputs,
      checkDuplicate: true,
      accountType: "USER"
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
    url: "/user/contact",
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
    document.getElementById('addressDetail').style.display = 'none';
  }

  function resetAddress() {
    deleteAddress();
    beforeAddress = document.getElementById('addressBackup').value;
    beforeDetailAddress = document.getElementById('detailAddressBackup').value;
    if (beforeAddress && beforeAddress !== '') {
      document.getElementById('selectedAddress').value = beforeAddress;
      document.getElementById('selectedAddress').style.display = 'block';
      document.getElementById('addressDetail').style.display = 'block';
      if (beforeDetailAddress) {
        document.getElementById('addressDetail').value = beforeDetailAddress;
      }
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
            
            $("#addressDetail").show();

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

document.getElementById('pay').addEventListener('input', function(e) {
    // 숫자 이외의 문자 제거
    let value = e.target.value.replace(/[^\d]/g, '');
    
    // 숫자를 3자리마다 콤마로 구분
    value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    
    // 변환된 값을 다시 입력란에 설정
    e.target.value = value;
});

// pay와 age 입력란 모두에 숫자만 입력되도록 이벤트 리스너 추가
document.getElementById('pay').addEventListener('input', formatNumber);
document.getElementById('age').addEventListener('input', function(e) {
    // 숫자 이외의 문자 제거
    let value = e.target.value.replace(/[^\d]/g, '');
    e.target.value = value;
});


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
      url: "/user/profileImg",
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
      url: "/user/profileImg",
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

function changeNameModal() {
  const changeNameText = `
  <h4>이름 변경</h4>
  <input type="text" id="changeNameModal" placeholder="변경할 이름을 입력해 주세요."></input>
  <div style="font-size:0.7em">해당 성함은 이력서에도 입력될 내용이니 되도록 실명을 추천드립니다.</div>
  `

  window.publicModals.show(changeNameText,{
    confirmText:'변경', cancleText:'취소', onConfirm:changeName
  })
}

function changeName() {
  const newName = $('#changeNameModal').val();

  console.log(newName);

  if (!newName || newName.trim() === '') {
    window.publicModals.show("이름은 비워둘 수 없습니다.");
    return;
  }

  $.ajax({
    url: '/user/name',
    method: 'PATCH',
    contentType: 'application/json',
    data: JSON.stringify({ name: newName.trim() }),
    success: function (res) {
      window.publicModals.show("이름이 성공적으로 변경되었습니다.");
      $('#userName').text(res.message); // 화면에 이름 반영
    },
    error: function (xhr) {
      window.publicModals.show("이름 변경 중 오류 발생");
    }
  });
}

//---------------------------------------------------------------------------------------------------------------------------------
function acceptAdviceModal(resumeNo, menteeUid) {
  window.publicModals.show("첨삭을 승인하시겠습니까?", {cancelText:"취소", onConfirm:()=>{
    $.ajax({
      url: `/resume/acceptAdvice/\${resumeNo}`,
      type: "GET",
      success: function (response) {
        location.href=`/resume/checkAdvice/\${resumeNo}?uid=\${menteeUid}`
      },
      error: function () {
        window.publicModals.show("첨삭 승인 처리 중 오류가 발생했습니다.");
      }
    });
  }});
}
function rejectAdviceModal(resumeNo, userUid) {
  window.publicModals.show("첨삭을 거절하시겠습니까?", {cancelText:"취소", onConfirm:()=>{
    $.ajax({
      url: `/resume/rejectAdvice/\${resumeNo}?ownerUid=\${userUid}`,
      type: "GET",
      success: function (response) {
        window.publicModals.show(response.message);
        getMyRegistrationAdvice()
      },
      error: function () {
        window.publicModals.show("첨삭 거절 처리 중 오류가 발생했습니다.");
      }
    });
  }});
}

//---------------------------------------------------------------------------------------------------------------------------------
// #endregion 섹션들 드롭다운느낌 처리용 함수들
// 이력서 영역 토글
let isResumeSectionVisible = false;  // 처음엔 숨김 상태

function toggleResumeSectionItems() {
  if (isResumeSectionVisible) {
    $('.resumeSectionItems').hide();
  } else {
    $('.resumeSectionItems').show();
  }
  isResumeSectionVisible = !isResumeSectionVisible;
}

// reviewSectionItems 토글
let isReviewSectionVisible = false;
function toggleReviewSectionItems() {
  if (isReviewSectionVisible) {
    $('.reviewSectionItems').hide();
  } else {
    $('.reviewSectionItems').show();
  }
  isReviewSectionVisible = !isReviewSectionVisible;
}

// resumeAdviceSectionItems 토글
let isResumeAdviceSectionVisible = false;
function toggleResumeAdviceSectionItems() {
  if (isResumeAdviceSectionVisible) {
    $('.resumeAdviceSectionItems').hide();
  } else {
    $('.resumeAdviceSectionItems').show();
  }
  isResumeAdviceSectionVisible = !isResumeAdviceSectionVisible;
}

// prboardSectionItems 토글
let isPrboardSectionVisible = false;
function togglePrboardSectionItems() {
  if (isPrboardSectionVisible) {
    $('.prboardSectionItems').hide();
  } else {
    $('.prboardSectionItems').show();
  }
  isPrboardSectionVisible = !isPrboardSectionVisible;
}

// registrationAdviceSectionItems 토글
let isRegistrationAdviceSectionVisible = false;
function toggleRegistrationAdviceSectionItems() {
  if (isRegistrationAdviceSectionVisible) {
    $('.registrationAdviceSectionItems').hide();
  } else {
    $('.registrationAdviceSectionItems').show();
  }
  isRegistrationAdviceSectionVisible = !isRegistrationAdviceSectionVisible;
}

// #region 섹션들 드롭다운느낌 처리용 함수들
</script>
<!-- 풋터 -->
<jsp:include page="/WEB-INF/views/footer.jsp"></jsp:include>