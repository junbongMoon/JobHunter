<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../header.jsp" />
<style>
  mark {
      color: blue;
      background: none;
  }
  code{
    color: black;
  }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<section style="padding: 30px; background-color: #f8f9fa; border-radius: 12px;">
  <h2 style="color: #2c3e50; font-family: 'Poppins', sans-serif;">🔐 유저 신고기능 사용 설명서</h2>
  <hr>

  <h3>✅ 1. 기본 호출 <small>유저 이름앞에 저거 복사해서 사용</small></h3>
  <p><strong>uid :</strong> data-uid="3" 여기에 신고당할 유저 uid 넣어서 사용</p>
  <p><strong>type :</strong>  data-type="user" 여기에 user 혹은 company 넣어서 사용(대소문자 구분 없음)</p>
  <p><strong>참고:</strong> 알아서 세션에 로그인했는지 체크해서 버튼 나오거나 안나오게 만듬.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (기본출력)</strong><br>
      <pre><code>
          &lt;i class="flagAccBtn" data-uid="3" data-type="user"&gt;&lt;/i&gt;
      </code></pre>
  </div>
  <br/>

</section>

 <hr> <hr> <hr> <hr>

<section style="padding: 30px; background-color: #f8f9fa; border-radius: 12px;">
  <i class="flagAccBtn" data-uid="3" data-type="user"></i>
  <h2 style="color: #2c3e50; font-family: 'Poppins', sans-serif;">🔐 공용모달 사용 설명서</h2>
  <hr>

  <h3>📌 기본 변수 선언</h3>
  <p><strong>설명 :</strong> 원하는값 넣어서 사용. 필요한 요소만 쓰고 기본 문자만 출력할때는 사용안해도 무관합니다.</p>
  <pre style="background: #eee; padding: 10px; border-radius: 8px;"><code>
  <mark>{
      confirmText : 확인버튼에 쓸 문구,
      cancelText : 취소버튼에 쓸 문구,
      onConfirm : 확인버튼 누르면 실행될 함수,
      onCancel : 취소버튼 누르면 실행될 함수,
      size_x : 모달창 좌우크기_ex. 10px,
      size_y : 모달창 좌우크기_ex. 30px
  };</mark>
  </code></pre>

  <hr>

  <h3>✅ 1. 기본 호출 <small>(따로 기능 없음)</small></h3>
  <p><strong>설명 :</strong> 그냥 문자만 출력하는 용도</p>
  <p><strong>사용 :</strong> window.publicModals.show("원하는 문자 메시지")</p>
  <p><strong>🚨 주의:</strong> 기본적으로 확인 버튼 하나만 같이 붙어나오고 확인 누르면 모달창 닫힘.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (기본출력)</strong><br>
      <pre><code>
          window.publicModals.show("여기에 원하는 메시지를 적어주세요");
          
          let message = "&lt;span&gt;HTML태그도 정상 동작합니다.&lt;/span&gt;"
          
          window.publicModals.show(message);
      </code></pre>
  </div>
  <br/>

  <hr>

  <h3>✅ 2. 속성 변경 방법</h3>

  <p><strong>속성 변경:</strong> <code>show(a, b)에 2번째 매개변수(b)에다 객체로해서 이름맞춰서 사용</code></p>
  <p><strong>참고:</strong> <code>순서 상관없이 key 이름만 맞으면 됩니다.</code></p>
  <p><strong>참고:</strong> <code>여러개 쓸때는 [ , ]로 구분해서 사용.</code></p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (확인버튼 변경)</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
          	window.publicModals.show ( message, {confirmText:"이것은 확인버튼입니다."} );
          	
          	window.publicModals.show ( message, {
          	                                       confirmText:"이것은 확인버튼입니다.",
          	                                       onCancel:"취소버튼도 같이 사용 가능"
          	                                    }
          	                          );
      </code></pre>
  </div>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (객체 만들어서 사용)</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
      		
      		const attr = {
      			confirmText: "이것은 확인버튼입니다.",
      			cancelText: "이것은 취소버튼입니다.",
      			size_x: "50px"
      		}
      		
      		
          	window.publicModals.show ( message, attr );
          
      </code></pre>
  </div>

  <br>
  
  <hr>

  <h3>✅ 3. 속성들</h3>

  <p><strong>confirmText :</strong> <code>확인버튼에 들어가는 문구</code></p>
  <p><strong>참고 : </strong>따로 안넣으면 그냥 "확인"이라고 나옵니다.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
      
          	window.publicModals.show ( message, { confirmText: "확인하기" } );
      </code></pre>
  </div>

  <br>
  <br>
  <hr>
  <p><strong>cancelText :</strong> <code>취소버튼에 들어가는 문구</code></p>
  <p><strong>참고 : </strong>이거 따로 안넣으면 취소버튼 없습니다. 이걸로 글자 넣어야 생겨요.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
      
          	window.publicModals.show ( message, { cancelText: "취소!!!" } );
      </code></pre>
  </div>

  <br>
  <br>
  <hr>
  <p><strong>size_x :</strong> <code>모달창 좌우 크기</code></p>
  <p><strong>참고 : </strong>css의 width에 넣는 크기단위(px, cm, %, em, v2, ...) 아무거나 넣어도 됩니다.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
      
          	window.publicModals.show ( message, { size_x: "50px" } );
      </code></pre>
  </div>
  
  <br>
  <br>
  <hr>
  <p><strong>size_y :</strong> <code>모달창 상하 크기</code></p>
  <p><strong>참고 : </strong>css의 height에 넣는 크기단위(px, cm, %, em, v2, ...) 아무거나 넣어도 됩니다.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
      
          	window.publicModals.show ( message, { size_y: "15em" } );
      </code></pre>
  </div>
  
  <br>
  <br>
  <hr>
  <p><strong>onConfirm :</strong> <code>확인버튼 눌렀을때 실행될 함수</code></p>
  <p><strong>참고 : </strong>()괄호 빼고 함수 이름만 넣어주세요. 괄호 넣으면 확인버튼없이 바로 실행됩니다.</p>
  <p><strong>참고 : </strong>기본적으로 모달창 닫히는거까지 같이 있으니까 넣어둔 함수에서 return false하면 창 안닫힙니다.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
      		
      		function okBtn() { console.log("확인버튼 눌림!") }
      
          	window.publicModals.show ( message, { onConfirm: okBtn } );
          	
          	=============================================================================
          	
          	function okBtn_noClose() { 
          		console.log("확인버튼 눌렀는데도 창이 안닫혀요");
          		return false;
          	}
      
          	window.publicModals.show ( message, { onConfirm: okBtn_noClose } );
      </code></pre>
  </div>
    
  <br>
  <br>
  <hr>
  <p><strong>onCancel :</strong> <code>취소버튼 눌렀을때 실행될 함수</code></p>
  <p><strong>참고 : </strong>()괄호 빼고 함수 이름만 넣어주세요. 괄호 넣으면 확인버튼없이 바로 실행됩니다.</p>
  <p><strong>참고 : </strong>cancelText로 취소버튼에 글자 달아줘야 취소버튼이 생겨서 이것도 넣을수있어요.</p>
  <p><strong>참고 : </strong>취소버튼은 무조건 모달창 닫기도 같이 실행됩니다.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
      		let message = `잡다한 내용.`
      		
      		function cancleBtn() { console.log("취소버튼 눌림!") }
      
          	window.publicModals.show ( message, { 
          											cancelText: "이건 취소버튼이다."
          											onConfirm: cancleBtn
          										} );
      </code></pre>
  </div>
  
  <hr>

  <h3>✅ 4. 함수사용</h3>

  <p><strong>기본 :</strong> <code>함수 이름만 넣어서 사용</code></p>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
          let message = `잡다한 내용.`
      		
      		function okBtn() { console.log("확인버튼 눌림!") }
      
          	window.publicModals.show ( message, { onConfirm: okBtn } );
      </code></pre>
  </div>
  <br>
  <br>
  <hr>
  
  <p><strong>함수에 다른함수넣기 :</strong> <code>함수 여러개 쓰고싶을경우 사용</code></p>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
          let message = `잡다한 내용.`
          
      		function okConsole() { 
      			console.log("확인버튼 눌림!") 
      		}
      		
      		function okAlert() { 
      			alert("확인버튼 눌림!") 
      		}
      		
      		
      		function okBtn() { 
      			okConsole();
      			okAlert();
      		}
      
          	window.publicModals.show ( message, { 
          											onConfirm: okBtn 
          										} );
      </code></pre>
  </div>
  <br>
  <br>
  <hr>
  
  <p><strong>익명함수로 사용 :</strong> <code>() => {} 간단한 함수 사용하기 좋음</code></p>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시</strong><br>
      <pre><code>
          let message = `잡다한 내용.`
          
      		function okConsole() { 
      			console.log("확인버튼 눌림!") 
      		}
      		
      		function okAlert() { 
      			alert("확인버튼 눌림!") 
      		}
      		
      
          	window.publicModals.show ( message, { 
          											onConfirm: () => {
          												okConsole();
          												okAlert();
          											} 
          										} 
          							 );
      </code></pre>
  </div>
  <br>
  <br>
  <hr>
  
  <p><strong>매개변수 필요한 함수 :</strong> <code>익명함수 응용</code></p>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
           let message = `잡다한 내용.`
          
      		function okConsole(okMessage) { 
      			console.log(okMessage) 
      		}
      
          	window.publicModals.show ( message, { 
          											onConfirm: () => {
          												okConsole("확인버튼 눌림!");
          											} 
          										} 
          							 );
      </code></pre>
  </div>
  <br>
  <br>
  <hr>
  
  <p><strong>모달창 안닫고 함수만 실행하기 :</strong> <code>함수 내부에서 return이 가장 좋지만 다른곳에도 사용할 함수라 return안되면 익명함수 응용으로 편하게</code></p>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
          let message = `잡다한 내용.`
          
      		function okConsole() { 
      			console.log("모달창 안닫기!") 
      		}
      
          	window.publicModals.show ( message, { 
          											onConfirm: () => {
          												okConsole();
          												return false;
          											} 
          										} 
          							 );
      </code></pre>
  </div>
  <br>
  <br>
  <hr>
</section>

 <hr> <hr> <hr> <hr>

<section style="padding: 30px; background-color: #f8f9fa; border-radius: 12px;">
  <h2 style="color: #2c3e50; font-family: 'Poppins', sans-serif;">🔐 권한 체크기 사용 설명서</h2>
  <hr>

  <h3>📌 기본 변수 선언</h3>
  <p><strong>설명 :</strong> ACCOUNTTYPE을 복사해가서 해당 방식으로 Enum타입과 같이 사용하거나, 문자열로 동일한 값을 입력하시면 됩니다. (단, 문자열 입력시 오타 주의)</p>
  <pre style="background: #eee; padding: 10px; border-radius: 8px;"><code>
      <mark>const ACCOUNTTYPE = {
          USER: "USER",
          COMPANY: "COMPANY"
          ADMIN: "ADMIN"
      };</mark>
      
      const uid = 1;
      const type = ACCOUNTTYPE.USER;
  </code></pre>

  <hr>

  <h3>⚙️ 체크 방식 안내</h3>
  <ul style="line-height: 1.8;">
    <li><strong>✅ 예시의 파란 부분을 복사해서 사용하기를 추천드립니다.</li>
    <li><strong>✅ 로그인 여부</strong>는 인터셉터로 통일되어있습니다.</li>
    <li><strong>✅ 나머지 체커들 (정지/삭제/본인/권한)</strong>은 :
      <ul>
        <li>① <strong>비동기 Ajax 방식</strong> : 예제의 함수들 사용</li>
        <li>② <strong>페이지 이동 시 인터셉터 기반 검사</strong> : <strong>쿼리스트링</strong>으로 UID 및 타입 전송 가능</li>
        <li><strong> - 인터셉터 : ( JobHunter\src\main\webapp\WEB-INF\spring\appServlet/servlet-context ) 에서 필요한 인터셉터 매핑</strong></li>
      </ul>
    </li>
  </ul>

  <hr>

  <h3>✅ 1. 로그인 여부 확인 <small>(Ajax 전용)</small></h3>
  <p><strong>설명 :</strong> 로그인 상태 확인</p>
  <p><strong>사용 :</strong> [authLoginInterceptor] 인터셉터에 원하는 주소 매핑</p>
  <p><strong>🚨 주의:</strong> [autoLoginInterceptor] 인터셉터와 유사하므로 주의해주세요.</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
          &lt;interceptor&gt;
              <mark>&lt;mapping path=&quot;/account/testLoginAjax&quot; /&gt;</mark>
              &lt;beans:ref bean=&quot;authLoginInterceptor&quot; /&gt;
          &lt;/interceptor&gt;
      </code></pre>
  </div>
  <br/>
  <p><strong>주의 :</strong> ajax등의 비동기방식은 인터셉터에서 직접 전송이 안되기에 응답으로 직접 전송이 필요합니다.</p>
  <p><strong>&nbsp;&nbsp;&nbsp;&nbsp;-></strong> 해당 방식으로 로그인 페이지로 보내진 후 로그인 성공 시 현제 페이지로 돌아오나, 사용자가 입력한 값 등은 저장되지 않습니다.</p>
  <p><strong>사용 :</strong> error시 호출되는 함수에 아래 예제와 같이 error.status === 449 체크해서 /account/login/return 으로 전송</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (ajax에서의 사용)</strong><br>
      <pre><code>
          function testLoginInterceptor() {
              $.ajax({
                url: `/account/testLoginAjax`,
                method: "GET",
                success: setResult,
                error: (error) => {
                  <mark>if (error.status === 449) {
                    location.href = "/account/login/return";
                  }</mark>
                }
              });
            }
      </code></pre>
  </div>

  <hr>

  <h3>✅ 2. 정지 여부 확인</h3>

  <p><strong>이동:</strong> <code>[AccountStatInterceptor] 인터셉터에 원하는 주소 매핑 (정지+삭제 함께 체크)</code></p>
  <p><strong>선택사항 : </strong>정지상태만 체크를 원할 시 쿼리스트링으로 [checkStatType=BLOCK]을 넘겨주세요</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
          &lt;interceptor&gt;
              <mark>&lt;mapping path=&quot;/account/testGetBlocked&quot; /&gt;</mark>
              &lt;beans:ref bean=&quot;AccountStatInterceptor&quot; /&gt;
          &lt;/interceptor&gt;
      </code></pre>
  </div>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (쿼리스트링 옵션)</strong><br>
      <pre><code>
          /account/testGetBlocked<mark>?checkStatType=BLOCK</mark>
      </code></pre>
  </div>

  <br>
  <br>

  <p><strong>Ajax:</strong> <code>아래 함수를 필요한 페이지의 js에 붙여넣은 후 예제와 같이 호출해 사용</code></p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>✅ 체킹 함수 (복사용)</strong><br>
      <pre><code>
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
      </code></pre>
  </div>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (함수 사용법)</strong><br>
      <pre><code>
          async function checkBlocked() {
              if (<mark>await isBlocked()</mark>) {
                  // 현재 로그인한 계정이 멀쩡한 상태면 여기 작동
                  setResult("정지안당함")
              } else {
                  setResult("정지중")
              }
          }
      </code></pre>
  </div>
  
  <hr>

  <h3>✅ 3. 삭제 여부 확인</h3>

  <p><strong>이동 :</strong> <code>[AccountStatInterceptor] 인터셉터에 원하는 주소 매핑 (정지+삭제 함께 체크)</code></p>
  <p><strong>선택사항 : </strong>정지상태만 체크를 원할 시 쿼리스트링으로 [checkStatType=DELETE]을 넘겨주세요</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
          &lt;interceptor&gt;
              <mark>&lt;mapping path=&quot;/account/testGetBlocked&quot; /&gt;</mark>
              &lt;beans:ref bean=&quot;AccountStatInterceptor&quot; /&gt;
          &lt;/interceptor&gt;
      </code></pre>
  </div>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (쿼리스트링 옵션)</strong><br>
      <pre><code>
          /account/testGetBlocked<mark>?checkStatType=DELETE</mark>
      </code></pre>
  </div>

  <br>
  <br>

  <p><strong>Ajax:</strong> <code>아래 함수를 필요한 페이지의 js에 붙여넣은 후 예제와 같이 호출해 사용</code></p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>✅ 체킹 함수 (복사용)</strong><br>
      <pre><code>
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
      </code></pre>
  </div>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (함수 사용법)</strong><br>
      <pre><code>
          async function checkDeleted() {
              if (<mark>await isDeleted()</mark>) {
                  // 현재 로그인한 계정이 멀쩡한 상태면 여기 작동
                  setResult("삭제아님")
              } else {
                  setResult("삭제대기중")
              }
          }
      </code></pre>
  </div>

  <hr>

  <h3>✅ 4. 본인 여부 확인</h3>

  <p><strong>이동 :</strong> <code>[OwnerInterceptor] 인터셉터에 원하는 주소 매핑</code></p>
  <p><strong>필수사항 : </strong>체크를 원하는 UID와 계정타입을 쿼리스트링으로 넘겨주세요. [uid={대상uid}], [accountType={대상타입}] <- 대상타입은 ACCOUNTTYPE 참조</p>
  <p><strong>선택사항 : </strong>본인과 함께 관리자도 통과시키고싶다면 쿼리스트링으로 [allowAdmin=true]을 넘겨주세요</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
          &lt;interceptor&gt;
              <mark>&lt;mapping path=&quot;/account/testGetOwner&quot; /&gt;</mark>
              &lt;beans:ref bean=&quot;OwnerInterceptor&quot; /&gt;
          &lt;/interceptor&gt;
      </code></pre>
  </div>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (쿼리스트링)</strong><br>
      <pre><code>
          /account/testGetOwner<mark>?uid=1&accountType=USER&allowAdmin=true</mark>
      </code></pre>
  </div>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (쿼리스트링_변수로 사용)</strong><br>
      <pre><code>
          <mark>const uid = 1</mark>
          <mark>const type = ACCOUNTTYPE.USER</mark>

          `/account/testGetOwner<mark>?uid=${uid}&accountType=${type}</mark>`
      </code></pre>
  </div>

  <br>
  <br>

  <p><strong>Ajax :</strong> <code>아래 함수를 필요한 페이지의 js에 붙여넣은 후 예제와 같이 호출해 사용</code></p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>✅ 체킹 함수 (복사용)</strong><br>
      <pre><code>
          // uid, type넘기면 세션에 로그인된 계정이 해당 uid, accountType이 맞는지 체크(맞다면 true반환)
          async function isOwner(uid, type) {
              try {
                  const res = await fetch(`/account/owner/\${type}/\${uid}`);
                  return await res.json(); // true or false
              } catch (e) {
                  console.error('본인 여부 확인 실패', e);
                  return false;
              }
          }
      </code></pre>
  </div>
  <p><strong>매개변수 :</strong> <code>uid(int)와 type(ACCOUNTTYPE) 매개변수가 필요합니다.</code></p>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (함수 사용법)</strong><br>
      <pre><code>
          async function checkOwner() {
              <mark>const uid = 1</mark>
              <mark>const type = ACCOUNTTYPE.USER</mark>
          
              if (<mark>await isOwner(uid, type)</mark>) {
                  // 여기 써놓은 uid랑 본인(로그인된 계정) uid, type 동일하면 이거 작동
                  setResult("본인맞음")
              } else {
                  setResult("본인아님")
              }
          }
      </code></pre>
  </div>

  <hr>

  <h3>✅ 5. 권한 여부 확인</h3>
  <p><strong>이동:</strong> <code>[RoleCheckInterceptor] 인터셉터에 원하는 주소 매핑</code></p>
  <p><strong>필수사항 : </strong>체크를 원하는 계정타입을 쿼리스트링으로 넘겨주세요. [accountType={대상타입}] <- 대상타입은 ACCOUNTTYPE 참조</p>
  <p><strong>선택사항 : </strong>관리자도 통과시키고싶다면 쿼리스트링으로 [allowAdmin=true]을 넘겨주세요</p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (인터셉터 매핑)</strong><br>
      <pre><code>
          &lt;interceptor&gt;
              <mark>&lt;mapping path=&quot;/account/testGetRole&quot; /&gt;</mark>
              &lt;beans:ref bean=&quot;RoleCheckInterceptor&quot; /&gt;
          &lt;/interceptor&gt;
      </code></pre>
  </div>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (쿼리스트링)</strong><br>
      <pre><code>
          /account/testGetRole<mark>?accountType=USER&allowAdmin=true</mark>
      </code></pre>
  </div>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (쿼리스트링_변수로 사용)</strong><br>
      <pre><code>
          <mark>const type = ACCOUNTTYPE.USER</mark>

          `/account/testGetRole<mark>?accountType=${type}</mark>`
      </code></pre>
  </div>

  <br>
  <br>

  <p><strong>Ajax :</strong> <code>아래 함수를 필요한 페이지의 js에 붙여넣은 후 예제와 같이 호출해 사용</code></p>

  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>✅ 체킹 함수 (복사용)</strong><br>
      <pre><code>
          // type 넘기면 세션에 로그인된 계정이 해당 accountType이 맞는지 체크(맞다면 true반환)
          async function hasRole(type) {
              try {
                  const res = await fetch(`/account/role/\${type}`);
                  return await res.json(); // true or false
              } catch (e) {
                  console.error('권한 확인 실패', e);
                  return false;
              }
          }
      </code></pre>
  </div>
  <p><strong>매개변수 :</strong> <code>type(ACCOUNTTYPE) 매개변수가 필요합니다.</code></p>
  <div style="background: #fffbe6; padding: 15px; border: 1px solid #ffe58f; border-radius: 8px; margin-bottom: 20px;">
      <strong>💡 예시 (함수 사용법)</strong><br>
      <pre><code>
          async function checkRoleUser() {
              <mark>const role = ACCOUNTTYPE.USER;</mark>
              
              if (<mark>await hasRole(role)</mark>) {
                  // 써놓은 권한이랑 본인 권한 맞으면 여기 작동
                  setResult("역할맞음")
              } else {
                  setResult("역할 안맞음")
              }
          }
      </code></pre>
  </div>

  <hr>
</section>

<main class="main">
  <div class="container">
    <h2>권한 체커 테스트 페이지</h2>

    <div style="margin-top: 20px;">
      <button onclick="checkOwner()">본인 여부 확인</button>
      <button onclick="checkRoleUser()">개인 회원+관리자 확인</button>
      <button onclick="checkRoleCompany()">기업 회원 확인</button>
      <button onclick="checkBlocked()">정지 여부 확인</button>
      <button onclick="checkDeleted()">삭제 여부 확인</button>
      <button onclick="testLoginInterceptor()">로그인 여부 확인</button>
      
      <!-- 로그인 테스트 -->
      <a href="/account/testGetLogin" class="btn">로그인 get테스트</a>

	  <!-- 본인확인 테스트 -->
      <a href="/account/testGetOwner?uid=1&accountType=USER" class="btn">본인 get테스트</a>
      
      <!-- 개인회원 테스트 -->
      <a href="/account/testGetRole?accountType=USER&allowAdmin=true" class="btn">개인회원 get테스트</a>
      <!-- 기업회원 테스트 -->
      <a href="/account/testGetRole?accountType=COMPANY" class="btn">기업회원 get테스트</a>

      <!-- 기본 (정지 우선) -->
      <a href="/account/testGetBlocked" class="btn">정지/삭제 get테스트</a>

      <!-- 정지만 따로 테스트 -->
      <a href="/account/testGetBlocked?checkStatType=BLOCK" class="btn">정지만 체크</a>

      <!-- 삭제만 따로 테스트 -->
      <a href="/account/testGetBlocked?checkStatType=DELETE" class="btn">삭제만 체크</a>
    </div>

    <div style="margin-top: 30px;">
      <h4>결과</h4>
      <pre id="result" style="background-color: #f5f5f5; padding: 10px;"></pre>
    </div>
  </div>
</main>

<script>

  function setResult(data) {
    $("#result").text(JSON.stringify(data, null, 2));
  }

  async function checkOwner() {
    const uid = 1
    const type = ACCOUNTTYPE.USER

    if (await isOwner(uid, type)) {
    // 여기 써놓은 uid랑 본인(로그인된 계정) uid, type 동일하면 이거 작동
    setResult("본인맞음")
    } else {
      setResult("본인아님")
    }
  }

  async function checkRoleUser() {
	  const role = ACCOUNTTYPE.USER;
	  const admin = ACCOUNTTYPE.ADMIN;
	  
	  if (await hasRole(role) || await hasRole(admin)) {
		    // 써놓은 권한이랑 본인 권한 맞으면 여기 작동
		    // admin도 같이 작동시키고싶다 하면 위와같이 or연산자같은걸로 붙이면 됩니다
        setResult("역할맞음")
		  } else {
        setResult("역할 안맞음")
    }
  }

  async function checkRoleCompany() {
	  const role = ACCOUNTTYPE.COMPANY;
	  
	  if (await hasRole(role)) {
		    // 써놓은 권한이랑 본인 권한 맞으면 여기 작동
        setResult("역할맞음")
		  } else {
        setResult("역할 안맞음")
    }
  }

  async function checkBlocked() {
	  if (await isBlocked()) {
      // 현재 로그인한 계정이 멀쩡한 상태면 여기 작동
      setResult("정지안당함")
    } else {
      setResult("정지중")
    }
  }

  async function checkDeleted() {
	  if (await isDeleted()) {
      // 현재 로그인한 계정이 멀쩡한 상태면 여기 작동
      setResult("삭제아님")
    } else {
      setResult("삭제대기중")
    }
  }

  function testLoginInterceptor() {
    $.ajax({
      url: `/account/testLoginAjax`,
      method: "GET",
      success: setResult,
      error: (error) => {
        if (error.status === 449) {
          location.href = "/account/login/return";
        }
      }
    });
  }

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
    const res = await fetch(`/account/owner/\${type}/\${uid}`);
    return await res.json(); // true or false
  } catch (e) {
    console.error('본인 여부 확인 실패', e);
    return false;
  }
}

// type 넘기면 세션에 로그인된 계정이 해당 accountType이 맞는지 체크(맞다면 true반환)
async function hasRole(type) {
  try {
    const res = await fetch(`/account/role/\${type}`);
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
</script>

<jsp:include page="../footer.jsp" />
