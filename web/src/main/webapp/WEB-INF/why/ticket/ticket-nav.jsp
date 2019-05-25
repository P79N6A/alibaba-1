<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="ticket-nav" id="ticket-nav">
    <ul>
        <%--<li class="small"><a href="javascript:history.go(-1);">&lt;&lt;返回</a></li>--%>
        <li class="big" id="ticketActivityListId"><a href="${path}/ticketActivity/ticketActivityList.do">活动</a></li>
        <%--<li class="big" id="ticketVenueListId"><a href="${path}/ticketVenue/venueList.do">场馆</a></li>--%>
            <%--<li class="big" ><a>欢迎光临</a></li>--%>
        <%--<% if(session.getAttribute("terminalUser") != null) { %>--%>
                <%--<li class="big" id="ticketUserCenterId"><a href="${path}/ticketUserActivity/ticketUserActivity.do">个人中心</a></li>--%>
          <%--<% } else{ %>--%>
                <%--<li class="big" id="ticketUserCenterId"><a href="${path}/ticketUser/preTicketUserLogin.do">个人中心</a></li>--%>
            <%--<%}%>--%>
        <li class="big" id="ticketMobileId"><a href="${path}/ticketActivity/ticketMobile.do">手机端</a></li>
    </ul>
</div>