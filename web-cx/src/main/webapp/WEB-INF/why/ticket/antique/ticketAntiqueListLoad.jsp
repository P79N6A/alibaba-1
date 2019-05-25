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

<c:if test="${empty antiqueList }">
    <div class="sort-box search-result">
        <div class="no-result">
            <h2>抱歉，没有找到符合条件的结果</h2>
            <h4>您可以修改搜索条件重新尝试</h4>
        </div>
    </div>
</c:if>


<c:if test="${not empty antiqueList}">
    <ul id="antique-list-ul" class="collection_ul">
        <c:forEach items="${antiqueList}" varStatus="s" var="c">
            <li data-id="${c.antiqueImgUrl}">
                <div><a href="javascript:;" class="img" onclick="antiqueDetail('${c.antiqueId}')"><img src="${path}/STATIC/image/collection-img1.jpg" alt="" width="196" height="144"/></a></div>
                <h3><a href="javascript:;" onclick="antiqueDetail('${c.antiqueId}')" title="${c.antiqueName}">${c.antiqueName}</a></h3>
            </li>
        </c:forEach>
    </ul>

    <form action="${path}/ticketAntique/antiqueDetail.do" id="antiqueDetailForm" method="post">
        <input type="hidden" id="antiqueId" name="antiqueId"/>
    </form>

    <div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
</c:if>