<%--<%@ page language="java"  pageEncoding="UTF-8"%>

<div id="header-con">
  <div class="header-con">
    <div class="logo fl"><a href="#"><img src="${path}/STATIC/image/logo.png" alt="" width="146" height="45"/></a></div>
    <div class="nav fl">
      <a href="${path}/frontActivity/frontActivityIndex.do" id="indexLabel">首页</a>
      <a href="${path}/frontActivity/frontActivityList.do" id="activityListLabel">活动</a>
      <a href="${path}/frontVenue/venueList.do" id="venueListLabel">场馆</a>
      <a href="${path}/frontTeamUser/teamUserList.do" id="groupListLabel">团体</a>
    </div>
    <div class="header-right fr">
      <form class="in-hot-search fl">
        <input type="text" value="请输入关键词" data-val="请输入关键词" class="input-text" id="keyword">
      </form>
      <div class="user-info-top fr" id="userImage">
        <a href="User-activity.html" class="photo"><img src="${path}/STATIC/image/user-in-photo.png" alt="" width="50" height="50"/></a>
        <div class="menu">
          <ul>
            <li><a href="#">我的主页</a></li>
            <li><a href="${path}/userActivity/userActivity.do">我的活动</a><span></span></li>
            <li><a href="User-venues.html">我的场馆</a><span>+3</span></li>
            <c:if test="${sessionScope.terminalUser.userType == 1}">
              <li><a href="${path}/frontTeamUser/userGroupJoin.do">我的团体</a><span></span></li>
            </c:if>
            <c:if test="${sessionScope.terminalUser.userType == 2}">
              <li><a href="${path}/frontTeamUser/userGroupIndex.do">我的团体</a><span></span></li>
            </c:if>
            <li><a href="${path}/frontCollect/collectActivity.do">我的收藏</a></li>
            <li><a href="User-information.html">我的消息</a><span>+1599</span></li>
            <li><a href="User-setting.html">账号设置</a></li>
            <li><a href="javascript:;">退出登录</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
  $(function(){
    // 小图片
    var imgUrl= '${sessionScope.terminalUser.userHeadImgUrl}';

    if(imgUrl!=""&&imgUrl.indexOf("http")==-1){
      $("#userImage").find("img").attr("src", getImgUrl(imgUrl));
    }else if(imgUrl.indexOf("http")!=-1){
      $("#userImage").find("img").attr("src", imgUrl);
    }else{
      $("#userImage").find("img").attr("src", "../STATIC/image/user-in-photo.png");
    }

  });
</script>--%>

<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%--<%@include file="../thirdLogin.jsp"%>--%>
<div id="webPage">
<div id="header-con">
  <div class="header-con header-con-list">
    <div class="logo fl"><a href="${path}/frontIndex/index.do"><img src="${path}/STATIC/image/logo-white.png" alt="" width="149" height="39"/></a></div>
    <div class="nav fl">
      <a class="activity" href="${path}/frontActivity/frontActivityIndex.do" id="activityListLabel" data-url="frontActivityIndex.do"><i></i>活动</a>
      <a class="venues" href="${path}/frontVenue/venueIndex.do" id="venueListLabel"   data-url="venueIndex.do" ><i></i>场馆</a>
      <%--<a class="group" href="${path}/frontTeamUser/groupIndex.do" id="groupListLabel" data-url="groupIndex.do"><i></i>团体</a>--%>
      <%--<a class="culture" href="${path}/frontCulture/cultureIndex.do" id="cultureLabel" data-url="cultureIndex.do"><i></i>非遗</a>--%>
    </div>

    <div class="header-right fr">
<%--      <form action="#" class="in-hot-search fl">
        <input type="text" value="请输入关键词" data-val="请输入关键词" class="input-text" id="keyword">
      </form>--%>
      <div class="user-info-top fr">

        <c:choose>

          <c:when test="${empty sessionScope.terminalUser}">
            <div class="txt">
              <div class="txt-login" id="txt-login">
                <a class="txt-login-btn" href="${path}/frontTerminalUser/userLogin.do">登录</a>
                <div class="txt-menu">
                  <a class="cloud" href="${path}/frontTerminalUser/userLogin.do"><i></i><span>文化云登录</span></a>
                  <a class="qq" href="${path}/qq/login.do"><i></i><span>QQ登录</span></a>
                  <a class="sina" href="${path}/sina/login.do"><i></i><span>新浪微博登录</span></a>
                  <a class="weixin" href="${path}/wechat/login.do"><i></i><span>微信登录</span></a>
                </div>
              </div>
              <a class="txt-register-btn" href="${path}/frontTerminalUser/userRegister.do">注册</a>
            </div>
          </c:when>

          <c:otherwise>
            <a href="#" class="photo"><img  id="headImg" alt="" width="50" height="50"/></a>
            <div class="menu">
              <ul>
                <li><a href="${path}/userActivity/userActivity.do">我的主页</a></li>
                <li><a href="${path}/userActivity/userActivity.do" >我的活动</a><span></span></li>
                <li><a href="${path}/roomOrder/queryRoomOrder.do" >我的场馆</a><span></span></li>

                  <%--2015.10.20 niu注释--%>
<%--                <c:if test="${sessionScope.terminalUser.userType == 1}">
                  <li><a href="${path}/frontTeamUser/userGroupJoin.do">我的团体</a><span></span></li>
                </c:if>
                <c:if test="${sessionScope.terminalUser.userType == 2}">
                  <li><a href="${path}/frontTeamUser/userGroupIndex.do">我的团体</a><span></span></li>
                </c:if>--%>

                <li><a href="${path}/frontCollect/collectActivity.do">我的收藏</a></li>
                <li><a href="${path}/userMessage/userMessageIndex.do">我的消息</a><span></span></li>
                <li><a href="${path}/frontTerminalUser/userInfo.do">账号设置</a></li>
                <li><a href="javascript:;" onclick="outLogin()">退出登录</a></li>
                <li style="display: none"><button  id="logout"></button></li>
              </ul>
            </div>
          </c:otherwise>

        </c:choose>
      </div>
    </div>
  </div>
</div>
</div>
<div id="appPage">

  <div id="header-con">
    <div class="header-con header-con-list">
      <div class="logo fl"><img src="${path}/STATIC/image/logo-white.png" alt="" width="149" height="39"/></div>
      <div class="nav fl">
        <a class="activity" href="${path}/frontActivity/venueBookIndex.do" id="activityListLabel" data-url="frontActivityIndex.do"><i></i>活动</a>
        <a class="venues" href="${path}/frontVenue/venueList.do" id="venueListLabel"   data-url="venueIndex.do" ><i></i>场馆</a>
      </div>
      <div class="header-right fr">
        <div class="user-info-top fr">

          <%--<input type="text" style="display: none">--%>
          <c:choose>

            <c:when test="${empty sessionScope.terminalUser}">

              <div class="txt">
                <div class="txt-login" id="txt-login">
                  <a class="txt-login-btn" href="${path}/userTicket/userLogin.do">登录</a>
<%--                  <div class="txt-menu">
                      &lt;%&ndash; <a class="cloud" href="${path}/userTicket/userLogin.do"><i></i><span>文化云登录</span></a>&ndash;%&gt;
                      &lt;%&ndash;                                        <a class="qq" href="${path}/qq/login.do"   title="QQ"><i></i><span>QQ登录</span></a>
                                                              <a class="sina" href="${path}/sina/login.do"  title="新浪微博" ><i></i><span>新浪微博登录</span></a>
                                                              <a class="weixin" href="${path}/wechat/login.do"  title="微信"><i></i><span>微信登录</span></a>&ndash;%&gt;

                  </div>--%>
                    <a class="txt-register-btn" href="${path}/userTicket/userRegister.do">注册</a>
                </div>

              </div>

            </c:when>

            <c:otherwise>
              <a href="#" class="photo"><img  id="headImg" alt="" width="50" height="50"/></a>
              <div class="menu">
                <ul>
                  <li><a href="${path}/userActivity/userActivity.do?fromTicket=Y">我的主页</a></li>
                  <li><a href="${path}/userActivity/userActivity.do?fromTicket=Y" >我的活动</a><span></span></li>
                  <li><a href="${path}/roomOrder/queryRoomOrder.do?fromTicket=Y" >我的场馆</a><span></span></li>
                    <%--2015.10.20 niu注释--%>
                    <%--                   <c:if test="${sessionScope.terminalUser.userType == 1}">
                                         <li><a href="${path}/frontTeamUser/userGroupJoin.do">我的团体</a><span></span></li>
                                       </c:if>
                                       <c:if test="${sessionScope.terminalUser.userType == 2}">
                                         <li><a href="${path}/frontTeamUser/userGroupIndex.do">我的团体</a><span></span></li>
                                       </c:if>--%>

                    <%--                                    <li><a href="${path}/frontCollect/collectActivity.do">我的收藏</a></li>
                                                        <li><a href="${path}/userMessage/userMessageIndex.do">我的消息</a><span></span></li>
                                                        <li><a href="${path}/frontTerminalUser/userInfo.do">账号设置</a></li>--%>
                  <li><a href="javascript:;" onclick="outTicketLogin()">退出登录</a></li>
                  <li style="display: none"><button  id="logout"></button></li>
                </ul>
              </div>
            </c:otherwise>

          </c:choose>

        </div>
      </div>
    </div>
  </div>


</div>


<script type="text/javascript">

  var localUrl = top.location.href;
  var webPage = document.getElementById("webPage");
  var appPage = document.getElementById("appPage");

  if(localUrl.indexOf("collect_info.jsp") == -1){
    appPage.innerHTML = "";
    appPage.style.display = "none";

  }else{
    webPage.innerHTML = "";
    webPage.style.display = "none";

  }


  var headImg = '${sessionScope.terminalUser.userHeadImgUrl}';
  if(headImg!=""&&headImg.indexOf("http")==-1){
    $("#headImg").attr("src",getIndexImgUrl(getImgUrl(headImg),"_300_300"));
  }else if(headImg.indexOf("http")!=-1){
    $("#headImg").attr("src",headImg);
  }else{
    var this_sex = '${sessionScope.terminalUser.userSex}';
    if(this_sex==1){
      $("#headImg").attr("src","../STATIC/image/face_boy.png");
    }else if(this_sex==2){
      $("#headImg").attr("src","../STATIC/image/face_girl.png");
    }else{
        $("#headImg").attr("src","../STATIC/image/face_boy.png");
    }
  }
  
</script>



<script>

  function outTicketLogin(){var a="${sessionScope.terminalUser}";if(a){$.post("${path}/userTicket/outLogin.do?asm="+new Date().getTime(),function(b){location.href='${path}/frontActivity/frontActivityList.do'})}else{window.location.reload(true)}};

  $(function () {
    //获得浏览器浏览地址 判断是否显示搜索按钮
    var url=document.location.href;
    if (url.indexOf("frontActivityList")>=0 || url.indexOf("frontActivityList")>=0 || url.indexOf("venueList")>=0) {
      $(".crumbs").hide();
    } else {
      $(".crumbs").show();
    }
  });
</script>