<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:forEach var="rec" items="${boardList}">
  <div class="col-lg-6 recruitment">
    <article>
      <h2 class="title">
        <a href="/recruitmentnotice/detail?uid=${rec.uid}">${rec.title}</a>
      </h2>

      <div class="meta-top">
        <ul>
          <li class="d-flex align-items-center">
            <i class="bi bi-person writer"></i> <a href="#">${rec.companyName}</a>
          </li>
          <li class="d-flex align-items-center">
            <i class="bi bi-clock"></i> 
            <a href="#"><time><fmt:formatDate value="${rec.regDate}" pattern="yyyy-MM-dd" /></time></a>
          </li>
        </ul>
      </div>

      <div class="content recruitmentList">
        <p class="rectext">
          <span class="badge-custom">${rec.region.name}</span>
          <span class="badge-custom">${rec.sigungu.name}</span>
          <span class="badge-custom">${rec.majorCategory.jobName}</span>
          <span class="badge-custom">${rec.subcategory.jobName}</span>
          <c:forEach var="adv" items="${rec.advantage}" varStatus="status">
            <c:if test="${status.index < 2}">
              <span class="badge-custom">${adv.advantageType}</span>
            </c:if>
          </c:forEach>
          <c:forEach var="app" items="${rec.application}" varStatus="status">
            <c:if test="${status.index < 2}">
              <span class="badge-custom">${app.method}</span>
            </c:if>
          </c:forEach>
        </p>
        <div class="read-more">
          <a href="/recruitmentnotice/detail?uid=${rec.uid}">조회하기</a>
        </div>
      </div>
    </article>
  </div>
</c:forEach>