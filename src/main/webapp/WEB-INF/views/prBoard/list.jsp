<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멘토PR 게시판</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<style>
	a.btn-detail {
	background-color: #3d4d6a !important;
	color: white !important;
	border: 2px solid #3d4d6a !important;
	border-radius: 6px !important;
	padding: 5px 12px !important;
	transition: all 0.3s ease !important;
	}

	a.btn-detail:hover {
	background-color: #2a344a !important;
	border-color: #2a344a !important;
	transform: translateY(-2px) !important;
	color: white !important;
	}

	a.btn-write {
	background-color: #3d4d6a !important;
	color: white !important;
	border: 2px solid #3d4d6a !important;
	border-radius: 6px !important;
	padding: 6px 14px !important;
	transition: all 0.3s ease !important;
	}

	a.btn-write:hover {
	background-color: #2a344a !important;
	border-color: #2a344a !important;
	transform: translateY(-2px) !important;
	color: white !important;
	}

  article.entry {
    border: 1px solid #ddd;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
  }

  article.entry:hover {
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    transform: translateY(-2px);
  }
</style>
</head>

<body>
<jsp:include page="../header.jsp"></jsp:include>

<main id="main">
  <section id="blog" class="blog">
    <div class="container" data-aos="fade-up">
      <div class="row">
        <div class="col-lg-12 d-flex justify-content-center">
           <div class="blog-posts" style="width: 90%;">
			    <c:forEach var="pr" items="${pageResponseDTO.boardList}">
			      <article class="entry shadow-sm bg-white rounded d-flex flex-column justify-content-between"
			               style="height: 200px; padding: 20px; margin-bottom: 30px;">
			
			        <!-- 상단: 작성자 / 시간 -->
					<div class="entry-meta mb-2" style="color: #37517e;">
					  <ul class="list-inline mb-0">
					    <li class="list-inline-item me-3">
					      <i class="bi bi-person"></i> ${pr.writer}
					    </li>
					    <li class="list-inline-item">
					      <i class="bi bi-clock"></i>
					      <time>${pr.formattedPostDate}</time>
					    </li>
					  </ul>
					</div>
			
			        <!-- 중간: 제목 -->
					<h3 class="entry-title text-center my-2">
					  <a href="/prboard/detail?prBoardNo=${pr.prBoardNo}" style="color: #37517e;" class="fw-bold fs-4">
					    ${pr.title}
					  </a>
					</h3>
			
			        <!-- 하단: 자세히 보기 -->
			        <div class="d-flex justify-content-end mt-auto">
						<a href="/prboard/detail?prBoardNo=${pr.prBoardNo}" class="btn btn-detail btn-sm">
							자세히 보기
						  </a>
			        </div>
			
			      </article>
			    </c:forEach>


                <div class="d-flex justify-content-end mb-3">
					<a href="/prboard/write" class="btn btn-write">
						<i class="fas fa-pen"></i> 글 작성
					  </a>
                  </div>
            <!-- Pagination -->
			<div class="blog-pagination">
			        <ul class="pagination justify-content-center mt-4">
			        <c:if test="${pageResponseDTO.startPageNumPerBlock > 1}">
			          <li class="page-item">
			            <a class="page-link" href="/prBoard/list?page=${pageResponseDTO.startPageNumPerBlock - 1}">이전</a>
			          </li>
			        </c:if>
			
			        <c:forEach begin="${pageResponseDTO.startPageNumPerBlock}" end="${pageResponseDTO.endPageNumPerBlock}" var="num">
			          <li class="page-item ${pageResponseDTO.pageNo == num ? 'active' : ''}">
			            <a class="page-link" href="/prBoard/list?page=${num}">${num}</a>
			          </li>
			        </c:forEach>
			
			        <c:if test="${pageResponseDTO.endPageNumPerBlock < pageResponseDTO.totalPageCnt}">
			          <li class="page-item">
			            <a class="page-link" href="/prBoard/list?page=${pageResponseDTO.endPageNumPerBlock + 1}">다음</a>
			          </li>
			        </c:if>
			      </ul>
			</div>
          </div>
        </div>



          </div>
        </div>
      </div>
    </div>
  </section>
</main>

<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>