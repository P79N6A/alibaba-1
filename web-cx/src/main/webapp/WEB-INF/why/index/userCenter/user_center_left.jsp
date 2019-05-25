<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java"  pageEncoding="UTF-8"%>

<div class="user-left fl">
  <div class="user-info">
    <div class="user-photo" id="userHeadImgUrl">
      <a><img width="120" height="120"/></a>
    </div>
      <div class="info">
  <h3 style="overflow: hidden" title="${sessionScope.terminalUser.userName}"><%
        if(session.getAttribute("terminalUser") != null){
          CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
      %>
   ${sessionScope.terminalUser.userName}
    </h3>
    <h4>
      <%if(terminalUser.getUserType() !=null && terminalUser.getUserType() == 1){%>
      普通用户
      <%}else if(terminalUser.getUserType() !=null && terminalUser.getUserType() == 2){%>
      团体用户
      <%}%>
    </h4>
    <%
      }
    %> 
      </div>
    <%--<h4>&lt;%&ndash;${fn:substringAfter(sessionScope.terminalUser.userCity, ',')} /&ndash;%&gt; &lt;%&ndash;<span id="user"></span>&ndash;%&gt;</h4>--%>
  </div>
  <div class="user-menu" id="webUserLeft">
    <a href="${path}/userActivity/userActivity.do" id="userActivityId">我的活动</a>
    <a href="${path}/roomOrder/queryRoomOrder.do" id="roomOrder">我的场馆</a>
    <%-- <a href="${path}/train/queryCourseOrder.do" id="userCourseOrderId">我的报名</a> --%>
    <%--<a href="${path}/userActivity/prePublicActivityList.do" id="publicActivityList">发起活动</a>--%>
<%--    <c:if test="${sessionScope.terminalUser.userType == 1}">
      <li><a href="${path}/frontTeamUser/userGroupJoin.do" id="group">我的团体</a><span></span></li>
    </c:if>
    <c:if test="${sessionScope.terminalUser.userType == 2}">
      <li><a href="${path}/frontTeamUser/userGroupIndex.do" id="group">我的团体</a><span></span></li>
    </c:if>
    --%>
    <a href="${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=1" id="culturalOrderOrder">我的点单</a>
    <a href="${path}/frontCollect/collectActivity.do" id="collect">我的收藏</a>
    <a href="${path}/userMessage/userMessageIndex.do" id="message">我的消息</a>
    <a href="${path}/frontTerminalUser/userInfo.do" class="setting" id="userInfo">账号设置</a>
    <c:if test="${not empty sessionScope.terminalUser.userMobileNo}">
        <a href="${path}/frontTerminalUser/userModifyPwd.do" class="setting" id="userPwd">修改密码</a>
    </c:if>
  </div>
    <div class="user-menu" id="appUserLeft">
        <a href="${path}/userActivity/userActivity.do?fromTicket=Y" id="userActivityId">我的活动</a>
        <a href="${path}/roomOrder/queryRoomOrder.do?fromTicket=Y" id="roomOrder">我的场馆</a>
    </div>
</div>

<script type="text/javascript">
    var localUrl = top.location.href;
    var appUserLeft = document.getElementById("appUserLeft");
    var webUserLeft = document.getElementById("webUserLeft");
    if(localUrl.indexOf("collect_info.jsp") == -1){
        appUserLeft.innerHTML = "";
        appUserLeft.style.display = "none";
    }else{
        webUserLeft.innerHTML = "";
        webUserLeft.style.display = "none";
    }

  $(function(){

    if(""=='${sessionScope.terminalUser}'||"null"=='${sessionScope.terminalUser}'){
      window.location.href="${path}/frontTerminalUser/userLogin.do"
    }
    // 大图片
    var imgUrl= '${sessionScope.terminalUser.userHeadImgUrl}';
    var sourceCode = '${sessionScope.terminalUser.sourceCode}';
    //$("#userHeadImgUrl").find("img").attr("src", imgUrl);

    if(imgUrl!=""&&imgUrl.indexOf("http")==-1){
        $("#userHeadImgUrl").find("img").attr("src",getIndexImgUrl(getImgUrl(imgUrl),"_300_300"));
    }else if(imgUrl.indexOf("http")!=-1){
      $("#userHeadImgUrl").find("img").attr("src", imgUrl);
    }else{

      var this_sex = '${sessionScope.terminalUser.userSex}';
      if(this_sex==1){
        $("#userHeadImgUrl").find("img").attr("src","../STATIC/image/face_boy.png");
      }else if(this_sex==2){
        $("#userHeadImgUrl").find("img").attr("src","../STATIC/image/face_girl.png");
      }else{
        $("#userHeadImgUrl").find("img").attr("src","../STATIC/image/face_boy.png");
      }

      //$("#userHeadImgUrl").find("img").attr("src", "../STATIC/image/user-in-photo.png");
    }



    /*$.post("../frontTeamUser/getTeamUserCount.do",null,function(count){
      if(count > 0){
        $("#user").html("团体用户");
      }else{
        $("#user").html("普通用户");
      }
    });*/
  });
</script>