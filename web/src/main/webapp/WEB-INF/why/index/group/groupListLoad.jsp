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
<c:if test="${empty list}">
    <div class="sort-box search-result">
        <div class="no-result">
            <h2><span id="searchNoGroup">抱歉，没有找到符合“<span class="red" id="noGroup"></span>”的结果</span><span id="searchGroup">抱歉，没有找到符合条件的结果</span></h2>
            <h4>您可以修改搜索条件重新尝试</h4>
        </div>
    </div>
</c:if>
<c:if test="${not empty list}">
    <div class="sort-box" id="sortDiv" style="display: none">
        <div class="sort-l fl">
            <span class="txt">排序：</span>
            <a class="item icon-asc">默认</a>
            <a class="item">热度<i></i></a>
            <a class="item">发布时间<i></i></a>
        </div>
        <div class="sort-r fr">共找到<span class="red">${page.total}</span>条<span id="pageSpan">与 <span class="red" id="nameSpan"></span> 相关的</span>结果</div>
    </div>
    <div class="group-list">
        <ul id="data-ul">
            <c:forEach items="${list}" var="user">
                <li data-li-url="${user.tuserPicture}">
                    <h3><a href="${path}/frontTeamUser/groupDetail.do?tuserId=${user.tuserId}">${user.tuserName}</a></h3>
                    <p>所在：
                            ${fn:substringAfter(user.tuserCounty,',')}
                    </p>
                    <a class="img" href="${path}/frontTeamUser/groupDetail.do?tuserId=${user.tuserId}"><img onload="fixImage(this, 235, 235)"/></a>
                    <div class="icon">
            <span class="heart"><i></i>
              <c:choose>
                  <c:when test="${not empty user.yearCollectCount}">
                      ${user.yearCollectCount}
                  </c:when>
                  <c:otherwise>
                      0
                  </c:otherwise>
              </c:choose>
            </span>
            <span class="look"><i></i>
              <c:choose>
                  <c:when test="${not empty user.yearBrowseCount}">
                      ${user.yearBrowseCount}
                  </c:when>
                  <c:otherwise>
                      0
                  </c:otherwise>
              </c:choose>
            </span>
                    </div>
                </li>
            </c:forEach>
        </ul>
        <%--动态取值分页--%>
        <div id="kkpager" width:750px;margin:10 auto;></div>
        <input type="hidden" id="pages" value="${page.page}">
        <input type="hidden" id="countpage" value="${page.countPage}">
        <input type="hidden" id="total" value="${page.total}">
    </div>
</c:if>

