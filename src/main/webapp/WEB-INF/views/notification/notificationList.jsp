<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>알림</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <!-- jQuery -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <style>
                    body {
                        font-family: 'Noto Sans KR', sans-serif;
                        background-color: #f8f9fa;
                    }

                    .notification-container {
                        max-width: 100%;
                        margin: 0 auto;
                        padding: 15px;
                    }

                    .notification-header {
                        background-color: #4a6bdf;
                        color: white;
                        padding: 15px;
                        border-radius: 8px 8px 0 0;
                        margin-bottom: 0;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .notification-item {
                        border-bottom: 1px solid #e9ecef;
                        padding: 15px;
                        transition: background-color 0.2s;
                        position: relative;
                        cursor: pointer;
                    }

                    .notification-item:hover {
                        background-color: #f1f3f9;
                    }

                    .notification-item.unread {
                        background-color: #e8f0fe;
                    }

                    .notification-item.read {
                        background-color: #ffffff;
                    }

                    .notification-title {
                        font-weight: 600;
                        margin-bottom: 5px;
                    }

                    .notification-content {
                        color: #6c757d;
                        font-size: 0.9rem;
                    }

                    .notification-time {
                        font-size: 0.8rem;
                        color: #adb5bd;
                    }

                    .notification-badge {
                        background-color: #dc3545;
                        color: white;
                        border-radius: 50%;
                        padding: 2px 6px;
                        font-size: 0.7rem;
                        position: absolute;
                        top: 5px;
                        right: 5px;
                    }

                    .empty-notification {
                        text-align: center;
                        padding: 30px;
                        color: #6c757d;
                    }

                    .notification-icon {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 15px;
                    }

                    .user-icon {
                        background-color: #4a6bdf;
                        color: white;
                    }

                    .company-icon {
                        background-color: #28a745;
                        color: white;
                    }

                    .admin-icon {
                        background-color: #dc3545;
                        color: white;
                    }

                    .delete-icon {
                        position: absolute;
                        bottom: 10px;
                        right: 10px;
                        color: #dc3545;
                        cursor: pointer;
                        opacity: 0.7;
                        transition: opacity 0.2s;
                    }

                    .delete-icon:hover {
                        opacity: 1;
                    }

                    .mark-all-read-btn {
                        background-color: transparent;
                        border: 1px solid white;
                        color: white;
                        padding: 5px 10px;
                        border-radius: 4px;
                        font-size: 0.8rem;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .mark-all-read-btn:hover {
                        background-color: rgba(255, 255, 255, 0.2);
                    }
                </style>
            </head>

            <body>
                <div class="notification-container">
                    <h5 class="notification-header">
                        <div>
                            <i class="fas fa-bell me-2"></i>알림 목록
                        </div>
                        <button id="markAllReadBtn" class="mark-all-read-btn">
                            <i class="fas fa-check-double me-1"></i>모두 읽음
                        </button>
                    </h5>

                    <div class="list-group">
                        <c:choose>
                            <c:when test="${empty messages}">
                                <div class="empty-notification">
                                    <i class="fas fa-bell-slash fa-3x mb-3"></i>
                                    <p>새로운 알림이 없습니다.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${messages}" var="message">
                                    <div class="notification-item ${message.isRead eq 'N' ? 'unread' : 'read'}" 
                                         data-message-no="${message.messageNo}" 
                                         onclick="markAsRead(${message.messageNo})">
                                        <div class="d-flex">
                                            <c:choose>
                                                <c:when test="${message.fromUserType eq 'USER'}">
                                                    <c:set var="iconClass" value="user-icon" />
                                                    <c:set var="faClass" value="fa-user" />
                                                </c:when>
                                                <c:when test="${message.fromUserType eq 'COMPANY'}">
                                                    <c:set var="iconClass" value="company-icon" />
                                                    <c:set var="faClass" value="fa-building" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="iconClass" value="admin-icon" />
                                                    <c:set var="faClass" value="fa-user-shield" />
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="notification-icon ${iconClass}">
                                                <i class="fas ${faClass}"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="notification-title">${message.title}</div>
                                                <div class="notification-content">${message.content}</div>
                                                <div class="notification-time">
                                                    <fmt:formatDate value="${message.regDate}"
                                                        pattern="yyyy-MM-dd HH:mm" />
                                                </div>
                                            </div>
                                            <c:if test="${message.isRead eq 'N'}">
                                                <span class="notification-badge">N</span>
                                            </c:if>
                                        </div>
                                        <i class="fas fa-trash delete-icon" onclick="deleteNotification(event, ${message.messageNo})"></i>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // 팝업 창 크기와 위치를 설정
                    window.onload = function () {
                        const width = 600;
                        const height = 800;

                        const screenX = window.screenX !== undefined ? window.screenX : window.screenLeft;
                        const screenY = window.screenY !== undefined ? window.screenY : window.screenTop;

                        const availWidth = screen.availWidth;
                        const availHeight = screen.availHeight;

                        const left = (availWidth - width) / 2;
                        const top = (availHeight - height) / 2;

                        // 창 크기와 위치 강제 설정
                        window.resizeTo(width, height);
                        window.moveTo(left, top);
                    }

                    // 알림을 읽음 상태로 변경하는 함수
                    function markAsRead(messageNo) {
                        $.ajax({
                            url: '/notification/markAsRead',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({ messageNo: messageNo }),
                            success: function() {
                                // 알림 항목의 클래스 변경
                                const notificationItem = $('[data-message-no="' + messageNo + '"]');
                                notificationItem.removeClass('unread').addClass('read');
                                
                                // 배지 제거
                                notificationItem.find('.notification-badge').remove();
                            },
                            error: function(xhr, status, error) {
                                console.error('Error:', error);
                            }
                        });
                    }

                    // 모든 알림을 읽음 상태로 변경하는 함수
                    $(document).ready(function() {
                        $('#markAllReadBtn').on('click', function() {
                            $.ajax({
                                url: '/notification/markAllAsRead',
                                type: 'POST',
                                contentType: 'application/json',
                                success: function() {
                                    // 모든 알림 항목의 클래스 변경
                                    $('.notification-item.unread').removeClass('unread').addClass('read');
                                    
                                    // 모든 배지 제거
                                    $('.notification-badge').remove();
                                },
                                error: function(xhr, status, error) {
                                    console.error('Error:', error);
                                }
                            });
                        });
                    });

                    // 알림 삭제 함수
                    function deleteNotification(event, messageNo) {
                        // 이벤트 버블링 방지
                        event.stopPropagation();
                        
                        if (confirm('이 알림을 삭제하시겠습니까?')) {
                            $.ajax({
                                url: '/notification/delete',
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify({ messageNo: messageNo }),
                                success: function() {
                                    // 알림 항목 제거
                                    const notificationItem = $('[data-message-no="' + messageNo + '"]');
                                    notificationItem.remove();
                                    
                                    // 모든 알림이 삭제되었는지 확인
                                    if ($('.notification-item').length === 0) {
                                        // 알림이 없으면 빈 메시지 표시
                                        $('.list-group').html(`
                                            <div class="empty-notification">
                                                <i class="fas fa-bell-slash fa-3x mb-3"></i>
                                                <p>새로운 알림이 없습니다.</p>
                                            </div>
                                        `);
                                    }
                                },
                                error: function(xhr, status, error) {
                                    console.error('Error:', error);
                                }
                            });
                        }
                    }
                </script>
            </body>

            </html>