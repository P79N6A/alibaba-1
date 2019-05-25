<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>


<div class="join-list info-list" id="userMessageIndexLoad">

    <c:if test="${empty messageList}">
        <div class="null_info">
            <h3>您还没有消息哦</h3>
        </div>
    </c:if>

        <ul>
            <c:forEach items="${messageList}" var="ms">
                <li>
                    <div class="tit">${ms.userMessageType}</div>
                    <input type="hidden"  name="id" value="${ms.userMessageId}" />
                    <div class="des">
                        <div>
                            <p>${ms.userMessageContent}</p>
                        </div>
                    </div>
                    <a href="javascript:;" class="btn btn-red btn-delete-info" onclick="delMessage('${ms.userMessageId}')">删除</a>
                    <a href="javascript:;" class="btn btn-system-info">展开<i></i></a>
                </li>
            </c:forEach>
        </ul>

    <c:if test="${fn:length(messageList) gt 0}">
       <div id="kkpager" width:750px;margin:10 auto;></div>
        <input type="hidden" id="pages" value="${page.page}">
    </c:if>

  <input type="hidden" id="countpage" value="${page.countPage}">
  <input type="hidden" id="total" value="${page.total}">
</div>


