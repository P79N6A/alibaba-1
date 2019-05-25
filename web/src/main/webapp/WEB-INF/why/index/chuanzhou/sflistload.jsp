<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style type="text/css">
    .hl_list .fire {
        float: right;
        position: relative;
        padding-right: 18px;
        margin-right: 10px;
    }
    .hl_list .fire span {
        display: block;
        float: left;
        width: 20px;
        height: 28px;
        background: url(${path}/STATIC/wechat/image/fire.png) no-repeat center;
        background-size: 12px auto;
    }
    .hl_list .fire:before {
        content: '';
        display: block;
        width: 1px;
        height: 14px;
        background-color: #a3a3a3;
        position: absolute;
        right: 0;
        top: 50%;
        margin-top: -7px;
    }
    .hl_list .zan {
        float: right;
        font-size: 14px;
        color: #c99228;
        line-height: 28px;
        height: 28px;
        overflow: hidden;
        padding: 0 5px 0 25px;
        background: url(${path}/STATIC/wechat/image/zan-fen.png) no-repeat;
        background-size: 50px auto;
        background-position: -14px -62px;
    }

    li{
        float:left;
        list-style:none;
        width:230px;
        height:230px;
        margin:10px;
    }
    img{
        width: 230px;
        height:230px;
    }


</style>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<c:if test="${empty infoList}">
    <div class="sort-box search-result">
        <div class="no-result">
            <h2 id="tip1">抱歉，没有找到符合条件的结果</h2>
            <h2 id="tip2">抱歉，没有找到符合“<span class="red" id="searchTip"></span>”的结果</h2>
            <h4>您可以修改搜索条件重新尝试</h4>
        </div>
    </div>
</c:if>

<c:if test="${not empty infoList}">
    <ul id="venue-list-ul" class="zx_list clearfix">
        <c:forEach items="${infoList}" var="c">
            <li data-id="${c.informationId}">
                <div class="info img">
                    <a href="${c.toOtherUrl}" class="img" target="_blank">
                        <img src="${c.informationIconUrl}">
                    </a>
                </div>
            </li>
        </c:forEach>
    </ul>

    <div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
    <input id="reqPage" type="hidden" value=""/>
</c:if>
