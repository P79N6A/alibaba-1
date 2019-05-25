<%@ page language="java"  pageEncoding="UTF-8"%>
<!--top start-->
<div class="top_method clearfix">
  <ul class="fr">
    <c:if test="${not empty sessionScope.terminalUser}">
      <li><a href="${path}/frontTerminalUser/userInfo.do" class="a_one">个人中心</a></li>
      <li><a href="${path}/userActivity/userActivity.do" class="a_two">我的订单</a></li>
    </c:if>

    <li class="weixin">
      <a class="a_three">手机版</a>
      <div class="ewm_mobile ewm_code clearfix">
        <div><img src="${path}/STATIC/image/code-mobile.png" width="95" height="95" /></div>
      </div>
    </li>
    <li class="weixin">
      <a class="a_four">文化云微信</a>
      <div id="number_code" class="ewm_code clearfix">
        <div><img src="${path}/STATIC/image/code-public.png" width="95" height="95" /><span>公众号</span></div>
        <%--<div><img src="${path}/STATIC/image/code.png" width="95" height="95" /><span>微网站</span></div>--%>
      </div>
    </li>
    <li >
      <a href="${path}/contact.jsp">联系我们</a>

    </li>
  </ul>
  <div class="login_reg fr">
    HI,
    <c:choose>
      <c:when test="${empty sessionScope.terminalUser}">
        <a href="${path}/frontTerminalUser/userLogin.do" class="blue">请登录</a>
        <a href="${path}/frontTerminalUser/userRegister.do">免费注册</a>
      </c:when>
      <c:otherwise>
       <a > ${sessionScope.terminalUser.userName}</a>
        <a href="javascript:;" onclick="outLogin()">退出</a>
      </c:otherwise>
    </c:choose>

  </div>
</div>
<!--top end-->
<!--nav start-->
<div class="hp_navbg">
  <div class="hp_nav clearfix">
    <div class="logo fl"><a  href="${path}/frontIndex/index.do"> <img src="${path}/STATIC/image/hp_logo.png"/></a></div>
    <ul class="fl">
      <li><a href="${path}/frontIndex/index.do" class="h_nav">活动</a></li>
      <li><a href="${path}/frontVenue/venueList.do">场馆</a></li>
    </ul>
  </div>
</div>
<!--nav end-->

<script type="javascript" >
  function outLogin(){
    $.post("${path}/frontTerminalUser/outLogin.do",function(result) {
      location.href= "../frontIndex/index.do";
//            if (result == "success") {
//
//            } else {
//
//            }
    });
  }
</script>