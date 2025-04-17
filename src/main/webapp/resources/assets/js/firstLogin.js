const urlParams = new URLSearchParams(window.location.search);
const firstLogin = urlParams.get('firstLogin');
if (firstLogin == "user") {
	window.publicModals.show("환영합니다! 상세 정보를 입력 하실 수 있는 마이페이지로 이동하시겠습니까?", {onConfirm: redirectMyPage,cancelText:"취소"})
} else if (firstLogin == "company") {
    window.publicModals.show("환영합니다! 상세 정보를 입력 하실 수 있는 기업정보 페이지로 이동하시겠습니까?", {onConfirm: redirectCompanyInfo,cancelText:"취소"})
}

function redirectMyPage() {
    location.href = "/user/mypage";
}

function redirectCompanyInfo() {
    location.href = "/company/companyInfo";
}