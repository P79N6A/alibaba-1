<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ page language="java"  pageEncoding="UTF-8"%>

<input type="hidden" value="${path}" id="path"/>
<div id="header-con">
  <div class="header-con">
    <div class="logo fl"><a href="${path}/frontActivity/frontActivityIndex.do"><img src="${path}/STATIC/image/logo.png" alt="" width="149" height="39"/></a></div>
    <div class="nav fl">

      <a class="activity" href="${path}/frontActivity/frontActivityIndex.do" id="activityLabel" data-url="frontActivityIndex.do"><i></i>活动</a>
      <a class="venues" href="${path}/frontVenue/venueIndex.do" id="venueLabel"   data-url="venueIndex.do" ><i></i>场馆</a>
      <%--<a class="group" href="${path}/frontTeamUser/groupIndex.do" id="groupLabel" data-url="groupIndex.do"><i></i>团体</a>--%>
      <%--<a class="culture" href="${path}/frontCulture/cultureIndex.do" id="cultureLabel" data-url="cultureIndex.do"><i></i>非遗</a>--%>
    </div>

   <div class="header-right fr">

      <div class="user-info-top fr">

        <c:choose>
          <c:when test="${empty sessionScope.terminalUser}">
            <div class="txt">
              <div class="txt-login" id="txt-login">
                <a class="txt-login-btn" href="${path}/frontTerminalUser/userLogin.do">登录</a>
                <div class="txt-menu">
                  <a class="cloud" href="${path}/frontTerminalUser/userLogin.do"><i></i><span>文化云登录</span></a>
                  <a class="qq" href="${path}/qq/login.do"  title="QQ"><i></i><span>QQ登录</span></a>
                  <a class="sina" href="${path}/sina/login.do"  title="新浪微博" ><i></i><span>新浪微博登录</span></a>
                  <a class="weixin" href="${path}/wechat/login.do" title="微信"><i></i><span>微信登录</span></a>
                </div>
              </div>
              <a class="txt-register-btn" href="${path}/frontTerminalUser/userRegister.do">注册</a>
            </div>
          </c:when>

          <c:otherwise>
            <a href="#" class="photo"><img id="headImg" src="" alt="" width="50" height="50"/></a>
            <div class="menu">
              <ul>
                  <%--<a href="${path}/frontTerminalUser/userModifyPwd.do">修改密码</a>--%>
                <li><a href="${path}/userActivity/userActivity.do">我的主页</a></li>
                <li><a href="${path}/userActivity/userActivity.do" >我的活动</a><span></span></li>
                <li><a href="${path}/roomOrder/queryRoomOrder.do" >我的场馆</a><span></span></li>
                      <%--2015.10.20 niu注释--%>
<%--                    <c:if test="${sessionScope.terminalUser.userType == 1}">
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
            </div
          </c:otherwise>
        </c:choose>

      </div>

    </div>
  </div>
</div>



<div id="in-top" class="clearfix" >
  <div class="in-ban">
    <ul class="in-ban-img">

      <li><a href="#">
            <img src="" alt="" width="1200" height="530"/>
          </a>
      </li>

      <li>
        <a href="#">
          <img src="" alt="" width="1200" height="530"/>
        </a>
      </li>

      <li>
        <a href="#">
          <img src="" alt="" width="1200" height="530"/>
        </a>
      </li>

    </ul>
    <ul class="in-ban-icon">
      <li class="on"></li>
      <li></li>
      <li></li>
    </ul>
  </div>

  <input type="hidden" id="otherUserImg" value="">

  <%--引入QQ互联登陆js--%>
<%--  <script type="text/javascript"
          src="http://qzonestyle.gtimg.cn/qzone/openapi/qc_loader.js"
          data-appid="101229091"
          data-callback="true"
          charset="utf-8">
  </script>--%>
  <script type="text/javascript">
    /*SuperSlide图片切换*/
    jQuery(".in-ban").slide({
      titCell:".in-ban-icon",
      mainCell:".in-ban-img",
      effect:"fold",
      autoPlay:true,
      autoPage:true,
      delayTime:600,
      trigger:"click"
    });

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



  <div class="top-search cateList" id="area_div">
    <span>区县索引：</span>
    <a class="cur" href="javascript:;" data-option="">上海市</a>
    <a href="javascript:;" data-option='46'>黄浦区</a>
    <a href="javascript:;" data-option="48">徐汇区</a>
    <a href="javascript:;" data-option="50">静安区</a>
    <a href="javascript:;" data-option="49">长宁区</a>
    <a href="javascript:;" data-option="51">普陀区</a>
    <a href="javascript:;" data-option="52">闸北区</a>
    <a href="javascript:;" data-option="53">虹口区</a>
    <a href="javascript:;" data-option="54">杨浦区</a>
    <a href="javascript:;" data-option="58">浦东新区</a>
    <a href="javascript:;" data-option="56">宝山区</a>
    <a href="javascript:;" data-option="57">嘉定区</a>
    <a href="javascript:;" data-option="60">松江区</a>
    <a href="javascript:;" data-option="61">青浦区</a>
    <a href="javascript:;" data-option="55">闵行区</a>
    <a href="javascript:;" data-option="59">金山区</a>
    <a href="javascript:;" data-option="63">奉贤区</a>
    <a href="javascript:;" data-option="64">崇明县</a>
    <br/>
      <a href="${path}/frontActivity/venueNoIndex.do" class="area_culture">文化馆</a>
      <a href="${path}/frontActivity/venueBookIndex.do" class="area_culture2">图书馆</a>
  </div>
</div>
<%--<%@include file="thirdLogin.jsp"%>--%>
