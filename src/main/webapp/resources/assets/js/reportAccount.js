let reporterAccountUid;
let reporterAccountType;

const reportCategory = {
  SPAM: "스팸/광고성 메시지",                     // 무차별 메시지, 홍보
  HARASSMENT: "욕설/괴롭힘",                      // 협박, 불쾌한 메시지
  FALSE_INFO: "허위 정보",                        // 거짓된 프로필, 거짓 연락처
  ILLEGAL_ACTIVITY: "불법 행위",                  // 불법 구인/알바, 리쿠르팅 등
  INAPPROPRIATE_CONTENT: "부적절한 프로필/사진",  // 선정성, 도배 등
  MISCONDUCT: "부적절한 행동/요구",               // 금전, 외설 등
  ETC: "기타 사유"                                // 사용자 정의
};

const reportCategoryList = Object.entries(reportCategory).map(([key, value]) => ({
  code: key,
  label: value
}));

window.onload = () => {
  reporterAccountUid = window.publicSessionUid;
  reporterAccountType = window.publicSessionAccType;

  if (reporterAccountUid) {
    setReportBtn()
  }
}

function setReportBtn() {
  let selectHtml = `<select id="reportReason" style="padding: 5px; flex-shrink: 0; max-width: 200px; margin-bottom:12px;">`;
  selectHtml += `<option disabled value="0" selected>신고 사유를 선택하세요</option>`;

  reportCategoryList.forEach(item => {
    selectHtml += `<option value="${item.code}">${item.label}</option>`;
  });

  selectHtml += `</select>`;


  document.querySelectorAll('.flagAccBtn').forEach(e => {
    e.innerHTML = `<i class="bi bi-exclamation-circle" style="color:red; margin:0px 0.3em"></i>`;
    
    e.setAttribute('title', '해당 사용자를 신고하시겠습니까?');
    
    new bootstrap.Tooltip(e);
    
    e.addEventListener('click', function () {

      const uid = this.dataset.uid;
      const type = this.dataset.type.toUpperCase();

      const content = `
        <div style="display: flex; justify-content: space-between; align-items: center; width: 400px; box-sizing: border-box;">
          <h2 style="margin: 0;">신고하기</h2>
          ${selectHtml}
        </div>
        <textarea id="reportDetail"
          maxlength="100"
          rows="7"
          placeholder="상세 사유를 입력하세요 (100자 이내)"
          style="width: 100%; padding: 10px; box-sizing: border-box; font-size: 14px; resize: none;"></textarea>
        <div style="text-align: right; font-size: 12px; color: #666; margin-top: 4px;">
          <span id="charCount">0</span>/100자
        </div>
      `;
    
      window.publicModals.show(content,{
      	confirmText:"신고접수",
        cancelText:"취소",
        onConfirm:()=>{sendReport(uid, type)},
        size_x:"500px",
        size_y:"350px"
      });
      
      const textarea = document.getElementById("reportDetail");
      const counter = document.getElementById("charCount");

      textarea.addEventListener("input", () => {
        if (textarea && counter) {
          counter.textContent = textarea.value.length;
        }
      });

      // select 값이 변경되었을 때 전송버튼 활성화
      const select = document.getElementById("reportReason");
      const submitBtn = document.querySelector(".public-modal-button.confirm");

      if (submitBtn) {
        // 초기 상태: 버튼 비활성화 + 툴팁 추가
        submitBtn.disabled = true;
        submitBtn.setAttribute("title", "신고 사유를 선택해주세요");
        const tooltip = new bootstrap.Tooltip(submitBtn);

        // select 값이 바뀌면 버튼 활성화 + 툴팁 제거
        select.addEventListener("change", () => {
          if (select.value) {
            submitBtn.disabled = false;

            // 툴팁 제거
            tooltip.dispose();
            submitBtn.removeAttribute("title");
          }
        });
      }

    });
  });
}

function sendReport(targetAccountUid, targetAccountType) {
  const reportReason = document.getElementById("reportReason").value;
  const reportDetail = document.getElementById("reportDetail").value;

  const dto = {
    reportCategory: reportReason,                     // enum ReportCategory (e.g. "SPAM")
    reportMessage: reportDetail,                      // 상세 사유
    targetAccountUid: targetAccountUid,               // 신고 대상 UID
    targetAccountType: targetAccountType,             // "USER" or "COMPANY"
    reporterAccountUid: window.publicSessionUid,      // 현재 유저 UID
    reporterAccountType: window.publicSessionAccType  // 현재 유저 타입
  };

  console.log("신고 데이터 DTO:", dto);

  // fetch("/report/account", {
  //   method: "POST",
  //   headers: {
  //     "Content-Type": "application/json"
  //   },
  //   body: JSON.stringify(dto)
  // })
  //   .then(response => {
  //     if (response.ok) {
  //       window.publicModals.show("신고가 접수되었습니다.");
  //     } else {
  //       window.publicModals.show("신고 접수 중 오류가 발생했습니다.");
  //     }
  //   })
  //   .catch(err => {
  //     window.publicModals.show("신고 요청에 실패했습니다.");
  //   });
}