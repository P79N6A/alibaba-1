<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<c:if test="${empty dataList}">
    <div class="sort-box search-result" id="indexLoad">
        <div class="no-result">
            <h2>抱歉，没有找到符合条件的结果</h2>
            <h4>您可以修改搜索条件重新尝试</h4>
        </div>
    </div>
</c:if>

<c:if test="${not empty dataList}">

 <div class="group-list" id="indexLoad">
    <ul id="venue-list-ul">

      <c:forEach items="${dataList}"  var="c">
        <li data-id="${c.cultureImgurl}">

          <h3><a href="${path}/frontCulture/cultureDetail.do?cultureId=${c.cultureId}" >${c.cultureName}</a></h3>
          <p>类型：${c.cultureTypeName}</p>

          <a href="${path}/frontCulture/cultureDetail.do?cultureId=${c.cultureId}" class="img" >
            <img  src="${path}/STATIC/image/defaultImg.png"   onload="fixImage(this,235,235)"  />
          </a>

          <div class="icon">
              <span class="look"><i></i>
                <c:choose>
                      <c:when test="${not empty c.yearBrowseCount}">${c.yearBrowseCount}</c:when>
                      <c:otherwise>0</c:otherwise>
                </c:choose>
              </span>
          </div>

        </li>
      </c:forEach>


    </ul>

    <div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
  </div>
</c:if>
