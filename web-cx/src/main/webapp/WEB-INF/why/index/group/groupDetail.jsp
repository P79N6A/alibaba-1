<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>团体详情--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/index/group/groupDetail.js"></script>

  <script type="text/javascript">

    $(function(){
      //选中当前label
      $('#groupListLabel').addClass('cur').siblings().removeClass('cur');
      // 推荐团体图片
      $(".recommend-venues li").each(function(index,item){
        var imgUrl = $(this).attr("data-icon-url");
        imgUrl= getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
    });

      var url = $(".content").attr("group-icon-url");
      url= getImgUrl(url);
      url = getIndexImgUrl(url,"_750_500");
      $(".content").find("#tuserPicture").attr("src", url);

      //判断用户是否收藏了该条内容
      $.ajax({
        type: 'POST',
        dataType : "json",
        url: "${path}/collect/isHadCollect.do?relateId=${teamUser.tuserId}&type=4",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
          if (data > 0) {
            $("#zanId").attr("class","zan love");
          }
        }
      });

      // 添加浏览量
      $.ajax({
        type: 'POST',
        dataType : "json",
        url: "${path}/cmsTypeUser/termUserSave.do?tuserId=${teamUser.tuserId}&operateType=1",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
        }
      });

      //得到喜欢的人数
      $(function () {
        $.ajax({
          type: 'POST',
          dataType : "json",
          url: "${path}/collect/getHotNum.do?relateId=${teamUser.tuserId}&type=4",//请求的action路径
          error: function () {//请求失败处理函数
          },
          success:function(data){ //请求成功后处理函数。
            $("#likeCount").html(data);
          }
        });
      });

      $("#keyword").blur(function(){
        var key =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
        if($.trim(key) != ""){
          window.location.href="${path}/frontTeamUser/teamUserList.do?tuserName="+key;
        }
      });

      $('#keyword').keydown(function(event){
        if(event.keyCode == "13"){
          var key =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
          if($.trim(key) != ""){
            window.location.href="${path}/frontTeamUser/teamUserList.do?tuserName="+key;
            event.preventDefault();
          }
        }
      });
    });

    function changeClass(){

      if('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == ""){
        dialogAlert("提示","登录之后才能收藏");
        return;
      }

      //判断是收藏还是取消 收藏
      if($("#zanId").attr("class") == 'zan love') {
        $.ajax({
          type: 'POST',
          dataType : "json",
          url: "${path}/collect/deleteUserCollect.do?type=4&relateId=${teamUser.tuserId}",//请求的action路径
          error: function () {//请求失败处理函数
          },
          success:function(data){ //请求成功后处理函数。
            $("#likeCount").html(data);
          }
        });
        $("#zanId").attr("class","zan");
      }else {
        $.ajax({
          type: 'POST',
          dataType : "json",
          url: "${path}/cmsTypeUser/termUserSave.do?tuserId=${teamUser.tuserId}&operateType=3",//请求的action路径
          error: function () {//请求失败处理函数
          },
          success:function(data){ //请求成功后处理函数。
            $("#likeCount").html(data);
          }
        });

        $("#zanId").attr("class","zan love");
      }
    }

    function addComment(){
      if('${sessionScope.terminalUser}' ==null || '${sessionScope.terminalUser}' == ''){
        dialogAlert("评论提示", "登录之后才能评论");
        return;
      }

      var status = '${sessionScope.terminalUser.commentStatus}';
      if(parseInt(status) == 2){
        dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
        return;
      }

      var commentRemark = $("#commentRemark").val();
      if(commentRemark == undefined || $.trim(commentRemark) == ""){
        dialogAlert("评论提示", "输入评论内容");
        return;
      }

      $.post("${path}/frontTeamUser/addComment.do",$("#commentForm").serialize(),function(result){
        if(result == "success"){
          $("#commentRemark").val("");
          dialogAlert("评论提示","评论成功，正在审核中!");
        }else if(result == "exceedNumber"){
          dialogAlert("评论提示","每天仅能评论1次，请明天再来!");
        }else if(result == "sensitiveWords"){
          dialogAlert("评论提示","评论内容有敏感词，不能评论!");
        }else{
          dialogAlert("评论提示","评论失败!");
        }
      });
    }
  </script>
</head>
<body>
<!-- 导入头部文件 -->
<%@include file="../list_top.jsp"%>

<div class="crumbs"><i></i>您所在的位置： <a href="${path}/frontTeamUser/groupIndex.do">团体</a> &gt; ${teamUser.tuserName}</div>
<div class="detail-content">
  <div class="detail-left fl">
    <div class="detail-note">
      <div class="tit">
        <h1>${teamUser.tuserName}</h1>
        <div class="time"><fmt:formatDate value="${teamUser.tCreateTime}" pattern="yyyy-MM-dd HH:mm:ss" />创立 / 收藏：
          <span class="red" id="likeCount"></span>
          <%--<span class="red">
            <c:choose>
              <c:when test="${not empty statistics.yearCollectCount}">${statistics.yearCollectCount}</c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
          </span>--%> / 浏览：<span class="red">
             <c:choose>
               <c:when test="${not empty statistics.yearBrowseCount}">${statistics.yearBrowseCount}</c:when>
               <c:otherwise>0</c:otherwise>
             </c:choose>
          </span></div>
        <div class="tag">
          <c:if test="${not empty tagList}">
            <c:forEach items="${tagList}" var="tag">
              <a>${tag.tagName}</a>
            </c:forEach>
          </c:if>
            <c:if test="${not empty dict && dict.dictName != '其他'}">
                <a>${dict.dictName}</a>
            </c:if>
        </div>

        <c:choose>
          <c:when test="${teamUser.tuserLimit > alreadyApplyCount}">
            <c:choose>
              <c:when test="${applyJoinCount > 0}">
                <span class="join-not red">已加入</span>
              </c:when>
              <c:otherwise>
                <a class="join-btn" data-name="${teamUser.tuserName}">我要加入</a>
              </c:otherwise>
            </c:choose>
          </c:when>
          <c:otherwise>
            <span class="join-not red">成员已满</span>
          </c:otherwise>
        </c:choose>
        <div class="joinNum"><span class="red">${alreadyApplyCount}</span> 人已加入 </div>

      </div>
      <div class="line"></div>
      <div class="info">
        <ul>
          <li class="address"><i></i><span>${fn:substringAfter(teamUser.tuserCity,',')}&nbsp;${fn:substringAfter(teamUser.tuserCounty,',')}</span></li>
          <li class="name"><i></i><span>管理人：${userNickName}</span></li>
          <%--<li class="time"><i></i><span>近期活动：2015.08.24 闸北区 彭浦社区活动中心</span></li>--%>
        </ul>
      </div>
      <div class="line"></div>
      <div class="content" group-icon-url="${teamUser.tuserPicture}">
        <img width="710" id="tuserPicture"/>
        ${teamUser.tuserTeamRemark}
      </div>
      <div class="icon">
        <span><a class="zan" id="zanId" onclick="changeClass()"></a></span>
        <span class="bdsharebuttonbox"><a class="share" data-cmd="count"></a></span>
        <!--分享代码 start-->
        <script type="text/javascript">
          with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
        </script>
        <!--分享代码 end-->
      </div>
    </div>
    <div class="comment mt20 clearfix">
      <div class="comment-tit">
        <h3>我要评论</h3><span>${commentCount}条评论</span>
      </div>
      <form id="commentForm">
        <input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId}"/>
        <textarea class="text" name="commentRemark" id="commentRemark"></textarea>
        <div class="tip">
          <span>文明上网理性发言，请遵守新闻评论服务协议</span>
          <input type="button" class="btn" value="发表评论" id="commentButton" onclick="addComment()"/>
        </div>
      </form>
      <div class="comment-list" id="comment-list-div">
        <ul>

        </ul>
        <input type="hidden" id="commentPageNum" value="1"/>
        <c:if test="${commentCount >= 5}">
          <a href="javascript:;" class="load-more" onclick="loadMoreComment()" id="moreComment">查看更多...</a>
        </c:if>
      </div>
    </div>
  </div>
  <div class="detail-right fr">
    <%--<div class="recommend mb20">
      <div class="tit"><i></i>相关活动推荐</div>
      <ul class="recommend-list">
        <li>
          <a href="activity-detail.hml" class="img"><img src="${path}/STATIC/image/detail-img2.png" alt="" width="300" height="300"/></a>
          <div class="info">
            <h3><a href="activity-detail.hml">30年300件：国人的记忆展</a></h3>
            <p>地址：南京西路社区</p>
            <p>时间：2014年10月19日14:00</p>
          </div>
        </li>
      </ul>
    </div>--%>
    <c:if test="${not empty list}">
    <div class="recommend mb20">
      <div class="tit"><i></i>团体推荐</div>
      <ul class="recommend-venues">
        <c:forEach items="${list}" var="cmsTeamUser">
          <li data-icon-url="${cmsTeamUser.tuserPicture}">
            <a href="${path}/frontTeamUser/groupDetail.do?tuserId=${cmsTeamUser.tuserId}" class="img fl">
              <img width="72" height="72"/></a>
            <div class="info fr">
              <h4><a href="${path}/frontTeamUser/groupDetail.do?tuserId=${cmsTeamUser.tuserId}">${cmsTeamUser.tuserName}</a></h4>
              <p>类型：${cmsTeamUser.dictName}</p>
              <p>所在：${fn:substringAfter(cmsTeamUser.tuserCounty,',')}</p>
            </div>
          </li>
        </c:forEach>
      </ul>
    </div>
    </c:if>
  </div>
</div>

<%@include file="../index_foot.jsp"%>
<script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
<script type="text/javascript">
  seajs.config({
    alias: {
      "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
    }
  });
  seajs.use(['${path}/STATIC/js/dialog/src/dialog-plus'], function (dialog) {
    window.dialog = dialog;
  });

  window.console = window.console || {log:function () {}}
  seajs.use(['jquery'], function ($) {
    $('.join-btn').on('click', function () {
      var name = $(this).attr("data-name");
      // 登陆之后才可加入团体
      if('${sessionScope.terminalUser}' == ''){
        dialogAlert("提示", "登录之后才能加入团体");
        return;
      }

      // 登陆之后点击‘我要加入’按钮，提示已经申请过了，不可再申请
      $.ajax({
        type: "POST",
        url: "${path}/frontTeamUser/checkIsApply.do",
        data: {tuserId:'${teamUser.tuserId}',userId:'${sessionScope.terminalUser.userId}'},
        async:false,
        success: function(data){
          if(data){
            dialogAlert("提示", "您已经申请过了，不能再申请了");
            return;
          }

          top.dialog({
            url: '${path}/frontTeamUser/groupJoin.do?tuserId=${teamUser.tuserId}',
            title: '申请加入团体',
            width: 460,
            fixed: true,
            data: name, // 给 iframe 的数据
            onclose: function(){
              if(this.returnValue){
                location.reload();
              }
            }
          }).showModal();
        }
      });
      return false;
    });
  });
</script>
</body>
</html>