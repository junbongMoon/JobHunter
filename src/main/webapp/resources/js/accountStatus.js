/*
  ===============================================================================================
              @@@설명서@@@
  1. 함수 주석보고 필요한거 복사해서 필요한 페이지 javascript에 넣어주세요
  2. 매개변수 확인하고 uid, type 필요한거 체크하고 있다면 함수쓸때 넣어주세요
  3. 체크 필요한 부분에 함수 호출만 하면 boolean 반환
  4. 사용 편하도록 일반적으로 정상 상태일경우 true반환으로 제작되었습니다
  5. 백엔드 서버오류 콘솔 이외의 후처리는 따로 없기에 필요할경우 false시 엑션은 직접 제작 필요
  
  ===============================================================================================
  
  ===변수 예제_1번 개인회원의 마이페이지일 경우우===
  let uid = 1; // 요구하는 uid (이걸로 호출 시 세션에 로그인한 유저가 1번유저인가?를 체크크)
  let type = ACCOUNTTYPE.COMPANY; // 요구하는 계정타입 (const ACCOUNTTYPE 복사해가야 사용 가능_복사안할거면 "USER","COMPANY","ADMIN" 직접 입력) 
  ===변수 예제===

  ===사용예제===
  if (await isLoggedIn()) {
    // 로그인했으면 여기 작동
  }

  if (await isBlocked()) {
    // 정지 안된유저면 여기 작동
  }

  if (await isDeleted()) {
    // 삭제예정 아니면 여기 작동
  }

  if (await isOwner(uid, type)) {
    // 여기 써놓은 uid랑 본인(로그인된 계정) uid, type 동일하면 이거 작동
  }

  if (await hasRole(type)) {
    // 써놓은 권한이랑 본인 권한 맞으면 여기 작동
    // admin도 같이 작동시키고싶다 하면 or연산자같은걸로 붙이면 됩니다
  }
  ===사용예제===
*/

// js식 enum타입_서버에 넘겨서 에러 나오고 나서야 오타찾지않도록 코드 작성중에 바로 빨간줄 보이게 하려고 사용
// 매번 DB가서 복사안해와도 되는 장점도 있습니다다
const ACCOUNTTYPE = {
  USER: "USER",
  COMPANY: "COMPANY",
  ADMIN: "ADMIN"
};

// 로그인했는지 체크(로그인했으면 true반환)
async function isLoggedIn() {
  try {
    const res = await fetch('/account/logged-in');
    return await res.json(); // true or false
  } catch (e) {
    console.error('로그인 상태 확인 실패', e);
    return false;
  }
}

// uid, type넘기면 세션에 로그인된 계정이 해당 uid, accountType이 맞는지 체크(맞다면 true반환)
async function isOwner(uid, type) {
  try {
    const res = await fetch(`/account/owner/${type}/${uid}`);
    return await res.json(); // true or false
  } catch (e) {
    console.error('본인 여부 확인 실패', e);
    return false;
  }
}

// type 넘기면 세션에 로그인된 계정이 해당 accountType이 맞는지 체크(맞다면 true반환)
async function hasRole(type) {
  try {
    const res = await fetch(`/account/role/${type}`);
    return await res.json(); // true or false
  } catch (e) {
    console.error('권한 확인 실패', e);
    return false;
  }
}

// 현제 세션에 로그인된 계정이 정지당하지 않았는지 체크(정지상태가 아니면 true반환)
async function isBlocked() {
  try {
    const res = await fetch('/account/blocked');
    return await res.json(); // true or false
  } catch (e) {
    console.error('정지 상태 확인 실패', e);
    return false;
  }
}

// 현제 세션에 로그인된 계정이 삭제대기중인지 체크(삭제대기상태가 아니면 true반환)
async function isDeleted() {
  try {
    const res = await fetch('/account/deleted');
    return await res.json(); // true or false
  } catch (e) {
    console.error('삭제 상태 확인 실패', e);
    return false;
  }
}