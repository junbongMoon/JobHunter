/*
import 는 쓸것만 가져가기
이 아래쪽 자기 javascript영역에 붙여놓고 자유롭게 사용하면 됩니다

import {
  isLoggedIn,
  isOwner,
  hasRole,
  isBlocked,
  isDeleted,

  ACCOUNTTYPE
} from '/resources/js/accountStatus.js';

  let uid = 1;
  let type = ACCOUNTTYPE.COMPANY;

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
*/

export const ACCOUNTTYPE = {
  USER: "USER",
  COMPANY: "COMPANY",
  ADMIN: "ADMIN"
};

export async function isLoggedIn() {
  try {
    const res = await fetch('/account/logged-in');
    return await res.json(); // true or false
  } catch (e) {
    console.error('로그인 상태 확인 실패', e);
    return false;
  }
}

export async function isOwner(uid, type) {
  try {
    const res = await fetch(`/account/owner/${type}/${uid}`);
    return await res.json();
  } catch (e) {
    console.error('본인 여부 확인 실패', e);
    return false;
  }
}

export async function hasRole(type) {
  try {
    const res = await fetch(`/account/role/${type}`);
    return await res.json();
  } catch (e) {
    console.error('권한 확인 실패', e);
    return false;
  }
}

export async function isBlocked() {
  try {
    const res = await fetch('/account/blocked');
    return await res.json();
  } catch (e) {
    console.error('정지 상태 확인 실패', e);
    return false;
  }
}

export async function isDeleted() {
  try {
    const res = await fetch('/account/deleted');
    return await res.json();
  } catch (e) {
    console.error('삭제 상태 확인 실패', e);
    return false;
  }
}