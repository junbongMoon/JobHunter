<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <footer id="footer" class="footer">

        <div class="container footer-top">
            <div class="row gy-4">
                <div class="col-lg-4 col-md-6 footer-about">
                    <a href="index.html" class="d-flex align-items-center">
                        <span class="sitename">JobHunter</span>
                    </a>
                    <div class="footer-contact pt-3">
                        <p>Republic of Korea</p>
                        <p>146, Teheran-ro, Gangnam-gu, Seoul</p>
                        <p class="mt-3"><strong>Phone:</strong> <span>+82 02 000 0000</span></p>
                        <p><strong>Email:</strong> <span>koreaite@koreaite.com</span></p>
                    </div>
                </div>

                <div class="col-lg-2 col-md-3 footer-links">
                    <h4>Project Member</h4>
                    <ul>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">문준봉</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">김성빈</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">유지원</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">육근우</a></li>
                    </ul>
                </div>

                <div class="col-lg-2 col-md-3 footer-links">
                    <h4>Email</h4>
                    <ul>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">moonjoon1234@naver.com</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">tjdqlzld555@naver.com</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">mondols98@naver.com</a></li>
                        <li><i class="bi bi-chevron-right"></i> <a href="#">dbrrmsdn51@naver.com</a></li>
                    </ul>
                </div>


                <div class="col-lg-4 col-md-12 footer-login-info" style="padding-left: 50px;">
                    <h4>Test Account</h4>
                    <p>아래 버튼을 클릭하시면 <br /> 테스트 계정을 확인 할 수 있습니다.</p>
                    <div class="login-info-buttons d-flex justify-content-start gap-3 mt-3">
                        <div class="login-info-button" onclick="showLoginInfo('admin')"
                            style="text-align: center; cursor: pointer;">
                            <div class="login-icon"
                                style="width: 50px; height: 50px; background-color: #dc3545; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto;">
                                <i class="fas fa-crown"></i>
                            </div>
                            <div style="margin-top: 5px; font-size: 12px;">관리자</div>
                        </div>
                        <div class="login-info-button" onclick="showLoginInfo('user')"
                            style="text-align: center; cursor: pointer;">
                            <div class="login-icon"
                                style="width: 50px; height: 50px; background-color: #4a6bdf; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto;">
                                <i class="fas fa-user"></i>
                            </div>
                            <div style="margin-top: 5px; font-size: 12px;">일반유저</div>
                        </div>
                        <div class="login-info-button" onclick="showLoginInfo('company')"
                            style="text-align: center; cursor: pointer;">
                            <div class="login-icon"
                                style="width: 50px; height: 50px; background-color: #28a745; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto;">
                                <i class="fas fa-building"></i>
                            </div>
                            <div style="margin-top: 5px; font-size: 12px;">기업유저</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <div class="container copyright text-center mt-4">
            <p>© <span>Copyright</span> <strong class="px-1 sitename">Arsha</strong> <span>All Rights Reserved</span>
            </p>
            <div class="credits">
                <!-- All the links in the footer should remain intact. -->
                <!-- You can delete the links only if you've purchased the pro version. -->
                <!-- Licensing information: https://bootstrapmade.com/license/ -->
                <!-- Purchase the pro version with working PHP/AJAX contact form: [buy-url] -->
                Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
            </div>
        </div>

    </footer>

    <!-- 로그인 정보 모달 -->
    <div id="loginInfoModal" class="modal fade" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">로그인 정보</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="loginInfoContent">
                    <!-- 로그인 정보가 여기에 동적으로 추가됩니다 -->
                </div>
            </div>
        </div>
    </div>
    <!-- 로그인 정보 모달 -->

    <script>
        // 로그인 정보 모달 관련 함수
        function showLoginInfo(type) {
            // 모달 표시
            const loginInfoModal = new bootstrap.Modal(document.getElementById('loginInfoModal'));

            // 로그인 정보 내용 설정
            const loginInfoContent = document.getElementById('loginInfoContent');

            let title, id, password;

            switch (type) {
                case 'admin':
                    title = '관리자 로그인 정보';
                    id = 'tester1234';
                    password = 'test1234!';
                    break;
                case 'user':
                    title = '일반 유저 로그인 정보';
                    id = 'tester123';
                    password = 'tester1234';
                    break;
                case 'company':
                    title = '기업 유저 로그인 정보';
                    id = 'koreaaisol1';
                    password = '1234';
                    break;
            }

            loginInfoContent.innerHTML = `
                <h5 class="mb-3">\${title}</h5>
                <div class="mb-3">
                    <label class="form-label">아이디</label>
                    <div class="input-group">
                        <input type="text" class="form-control" value="\${id}" readonly>
                        <button class="btn btn-outline-secondary" type="button" onclick="copyToClipboard('\${id}')">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">비밀번호</label>
                    <div class="input-group">
                        <input type="text" class="form-control" value="\${password}" readonly>
                        <button class="btn btn-outline-secondary" type="button" onclick="copyToClipboard('\${password}')">
                            <i class="fas fa-copy"></i>
                        </button>
                    </div>
                </div>
            `;

            loginInfoModal.show();
        }

        // 클립보드에 복사하는 함수
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text).then(() => {
                // 복사 성공 시 알림 표시
                alert('클립보드에 복사되었습니다.');
            }).catch(err => {
                console.error('클립보드 복사 실패:', err);
            });
        }
    </script>

    </html>
    <script src="/resources/assets/js/main.js"></script>