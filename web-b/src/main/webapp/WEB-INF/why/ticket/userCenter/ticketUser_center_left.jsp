<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java"  pageEncoding="UTF-8"%>

<div class="user-left">
  <div class="user-info">
    <div class="user-photo" id="userHeadImgUrl">
      <a><img width="120" height="120"/></a>
    </div>
      <div class="info">
  <h3><%
        if(session.getAttribute("terminalUser") != null){
          CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
      %>
   ${sessionScope.terminalUser.userName}
    </h3>
  <%--  <h4>
      <%if(terminalUser.getUserType() == 1){%>
      普通用户
      <%}else if(terminalUser.getUserType() == 2){%>
      团体用户
      <%}%>
    </h4>--%>
    <%
      }
    %>
      </div>
    <%--<h4>&lt;%&ndash;${fn:substringAfter(sessionScope.terminalUser.userCity, ',')} /&ndash;%&gt; &lt;%&ndash;<span id="user"></span>&ndash;%&gt;</h4>--%>
  </div>
  <div class="user-menu" >
    <a href="${path}/ticketUserActivity/ticketUserActivity.do" id="userActivityId">我的活动</a>
    <a href="${path}/ticketRoomOrder/queryRoomOrder.do" id="roomOrder">我的场馆</a>
  </div>
</div>

<script type="text/javascript">
  $(function(){
    // TOP 标签选中
    $('#ticketUserCenterId').addClass('cur').siblings().removeClass('cur');
    if(${empty sessionScope.terminalUser}){
      //修改父窗口的 登录状态
      $("#btnLogin", window.parent.document).attr("class","btn2 btn-login");
      $("#btnLogin", window.parent.document).attr("title","登录");
      $("#btnLogin", window.parent.document).attr("href","javascript:ticketLogin();");
      window.location.href="${path}/ticketUser/preTicketUserLogin.do";
    }
    // 大图片
    var imgUrl= '${sessionScope.terminalUser.userHeadImgUrl}';

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