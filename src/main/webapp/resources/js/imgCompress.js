let controller = new AbortController(); // 전역 컨트롤러

function summerNoteImgSizeCheck(files, maxSize) {
  let RequiredCompress = false;

  for (const file of files) {
    if (file.size > maxSize) {
      RequiredCompress = true;
    }
  }

  if (RequiredCompress) {
    imgCompressModal(files, '#introduce', maxSize); // 모달로 압축 물어봄
  } else {
    for (const file of files) {
      if (file.size > maxSize) {
        insertSmartImageToSummernote(file, '#introduce'); // 바로 삽입
      }
    }
  }
}

// 이미지 압축 질문
function imgCompressModal(files, targetEditorSelector, maxSize) {
  window.publicModals.show("1개 이상의 이미지가 너무 큽니다.<br><br>해당 사이트는 요금제에 따라<br>트래픽 제한등의 이유로 큰 용량의<br>파일 업로드가 제한되어있습니다.<br>사진을 압축하여 업로드하시겠습니까?",
  {
    cancelText:"아니오",
      confirmText:"예",
      onConfirm: ()=>{
        insertSmartImageToSummernote(files, targetEditorSelector, maxSize)
        return false;
      }
    }
  )
}


// 썸머노트 이미지 강제압축 함수
function insertSmartImageToSummernote(files, targetEditorSelector, maxSize) {
  controller = new AbortController();
  let completed = 0; // 완료된 파일 수
  const total = files.length;

  // 1. 모달 표시 (여러 개의 로딩 바 담을 컨테이너)
  window.publicModals.show(`
    <div style="text-align: center;">
      <div style="margin-bottom: 10px;">
        <strong>이미지 압축 중...</strong><br>
        <span id="completeCount">0</span> / ${total} 완료됨
      </div>
      <div id="progressContainer" style="display: flex; flex-direction: column; gap: 10px;"></div>
      <div style="font-size: 0.5em;">※ 사실 진행률은 가짜입니다. 기다리기 지루할까봐 보여드려요.</div>
    </div>
  `, {
    confirmText: "취소",
    onConfirm: () => {
      controller?.abort();
      window.publicModals.hide?.();
    }
  });

  // 순차적으로 처리하기 위한 async 즉시 실행 함수
  (async () => {
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const progressId = `progress_${i}`;
      const percentId = `percent_${i}`;

      // 2. 로딩 바 추가
      const container = document.getElementById('progressContainer');
      const wrapper = document.createElement('div');
      wrapper.innerHTML = `
        <div><strong>이미지 ${i + 1} 압축 중... <i id="${percentId}">0%</i></strong></div>
        <div class="progress" style="height: 10px;">
          <div id="${progressId}" class="progress-bar" style="width: 0%;"></div>
        </div>
      `;
      container.appendChild(wrapper);

      // 3. 가짜 퍼센트 애니메이션
      let percent = 0;
      const interval = setInterval(() => {
        if (percent < 90) {
          percent = Math.min(percent + Math.random() * 8, 90);
        } else if (percent < 95) {
          percent = Math.min(percent + Math.random() * 0.5, 95);
        } else if (percent < 99) {
          percent = Math.min(percent + Math.random() * 0.05, 99);
        }
        document.getElementById(progressId).style.width = percent + '%';
        document.getElementById(percentId).innerText = Math.floor(percent) + '%';
      }, 200);

      try {
        const formData = new FormData();
        formData.append("file", file);
        formData.append("maxSize", maxSize);

        const res = await fetch("/util/compressImg", {
          method: "POST",
          body: formData,
          signal: controller.signal
        });

        if (!res.ok) throw new Error("압축 실패");

        const blob = await res.blob();
        const reader = new FileReader();

        reader.onloadend = () => {
          $(targetEditorSelector).summernote('insertImage', reader.result);

          clearInterval(interval);
          document.getElementById(progressId).style.width = '99%';
          document.getElementById(percentId).innerText = '99%';

          setTimeout(() => {
            document.getElementById(progressId).style.width = '100%';
            document.getElementById(percentId).innerText = '100%';
            
            // 완료 갯수 증가 표시
            completed++;
            document.getElementById('completeCount').innerText = completed;

            // 마지막이면 닫기
            if (completed === total) {
              setTimeout(() => window.publicModals.hide?.(), 800);
            }
          }, 300);
        };

        reader.readAsDataURL(blob);

        // 마지막 파일이면 0.5초 후 모달 닫기
        if (i === files.length - 1) {
          setTimeout(() => {
            window.publicModals.hide?.();
          }, 1000);
        }

      } catch (err) {
        clearInterval(interval);
        console.error(`이미지 ${i + 1} 압축 실패`, err);
        window.publicModals.show(`이미지 ${i + 1} 압축 중 오류가 발생했습니다.`);
        window.publicModals.hide?.();
        break;
      }
    }
  })();
}

function cancleImgCompress() {
  controller?.abort(); // 요청 취소
  window.publicModals.hide?.(); // 모달도 닫기
}