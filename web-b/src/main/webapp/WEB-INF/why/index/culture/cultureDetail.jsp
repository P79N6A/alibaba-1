<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>非遗详情--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/ckplayer/ckplayer.js" charset="utf-8"></script>

  <script type="text/javascript">

    $(function(){
      // 添加浏览量
      $.get("${path}/cmsTypeUser/cultureSave.do?id=${culture.cultureId}&operateType=1");
      //选中当前label
      $('#cultureLabel').addClass('cur').siblings().removeClass('cur');

      // 视屏
      var cultureVediourl = '${culture.cultureVediourl}';
      //var cultureVediourl = 'http://movie.ks.js.cn/flv/other/2014/06/20-2.flv';
      //var cultureVediourl = 'http://player.youku.com/player.php/Type/Folder/Fid/25900235/Ob/1/sid/XMTMzMDg2MDk0NA==/v.swf';

      if(cultureVediourl != undefined && cultureVediourl != ""){
        if(cultureVediourl.indexOf(".swf") == -1){
          var flashvars={
            f:cultureVediourl,
            b:1
          };
          var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
          var video=[cultureVediourl + '->video/mp4'];
          CKobject.embed('${path}/STATIC/js/ckplayer/ckplayer.swf','vedioDiv','ckplayer_a1','710','470',false,flashvars,video,params);
        }else{
          var htmlStr = '<embed src="'+ cultureVediourl +'" quality="high" width="710" height="470" align="middle" allowScriptAccess="always" allowFullScreen="true" mode="transparent" type="application/x-shockwave-flash"></embed>';
          $("#vedioDiv").html(htmlStr);
        }
      }

      // 非遗图片
      var url = $(".content").attr("culture-img-url");
      url= getImgUrl(url);
      url = getIndexImgUrl(url,"_750_500");
      $(".content").find("#cultureImgUrl").attr("src", url);

      // 推荐非遗图片
      $("#recommendUl li").each(function(index,item){
        var imgUrl = $(this).attr("data-icon-url");
        imgUrl= getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
      });

      // 传承人图片
      $("#inheritorUl li").each(function(index,item){
        var imgUrl = $(this).attr("inheritor-head-img-url");
        if(imgUrl != undefined && imgUrl != ""){
          imgUrl= getImgUrl(imgUrl);
          imgUrl = getIndexImgUrl(imgUrl, "_300_300");
          $(item).find("img").attr("src", imgUrl);
        }
      });

      // 初始化显示评论
      loadCommentList();

      // 展开
      $(".smriti-people").on("click", ".btn-icon", function(){
        var $this = $(this);
        var siblingsNote = $this.parent().siblings(".note");
        var noteHeight = siblingsNote.height() - 72;
        var parent = $this.parents("li");
        if($this.hasClass("collapse")){
          $this.html("收起<i></i>").removeClass("collapse").addClass("expand");
          parent.animate({"height": (noteHeight+104)});
        }else if($this.hasClass("expand")){
          $this.html("展开<i></i>").removeClass("expand").addClass("collapse");
          parent.animate({"height": 104});
        }
      });
    });

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

      $.post("${path}/frontCulture/addComment.do",$("#commentForm").serialize(),function(result){
        if(result == "success"){
          dialogAlert("评论提示","评论成功，正在审核中!");
          $("#commentRemark").val("");
        }else if(result == "exceedNumber"){
          dialogAlert("评论提示","当天最多评论一次!");
        }else if(result == "sensitiveWords"){
          dialogAlert("评论提示","评论内容有敏感词，不能评论!");
        }else{
          dialogAlert("评论提示","评论失败!");
        }
      });
    }

    function loadCommentList(){
      $("#comment-list-div ul").html();
      var cultureId = $("#cultureId").val();
      var data = {cultureId:cultureId};
      $.post("${path}/frontCulture/commentList.do",data ,
              function(data) {
                var commentHtml = "";
                if(data != null && data != ""){
                  $("#moreComment").show();
                  for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime.substring(0,16);
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;
                    commentHtml = commentHtml + "<li data-id='"+userHeadImgUrl+"'>"+
                    "<a class='img fl'><img width='50' height='50'/></a>"+
                    "<div class='info fr'>"+
                    "<h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+
                    "<p>"+commentRemark+"</p>"+
                    "</div>"+
                    "</li>";
                  }
                }else{
                  $("#moreComment").hide();
                }
                $("#comment-list-div ul").html(commentHtml);
                loadCommentListPics();
              });
    }

    /**
     * 加载更多评论
     */
    function loadMoreComment(){
      var cultureId = $("#cultureId").val();
      var pageNum = parseInt($("#commentPageNum").val())+1;
      $("#commentPageNum").val(pageNum)
      var data = {"cultureId":cultureId,"pageNum":pageNum};
      $.post("${path}/frontCulture/commentList.do",data ,
              function(data) {
                var commentHtml = "";
                if(data != null && data != ""){
                  for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime.substring(0,16);
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;

                    commentHtml = commentHtml + "<li data-id='"+userHeadImgUrl+"'>"+
                    "<a class='img fl'><img src='../STATIC/image/portrait-img1.jpg' alt='' width='50' height='50'/></a>"+
                    "<div class='info fr'>"+
                    "<h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+
                    "<p>"+commentRemark+"</p>"+
                    "</div>"+
                    "</li>";
                  }
                }else{
                  $("#moreComment").removeAttr("onclick");
                  $("#moreComment").html("没有更多了!");
                }
                $("#comment-list-div ul").append(commentHtml);
                loadCommentListPics();
              });
    }

    // 评论会员头像
    function loadCommentListPics() {
      //请求页面下方团体所有图片
      $("#comment-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        imgUrl = getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
      });
    }
  </script>
</head>
<body>
<!-- 导入头部文件 -->
<%@include file="../list_top.jsp"%>

<div class="crumbs"><i></i>您所在的位置： 非遗 &gt; ${culture.cultureName}</div>
<div class="detail-content">
  <div class="detail-left fl">
    <div class="detail-note">
      <div class="tit">
        <h1>${culture.cultureName}</h1>
        <div class="time"><fmt:formatDate value="${culture.createTime}" pattern="yyyy-MM-dd HH:mm:ss" />创立 /  浏览：
          <span class="red">
             <c:choose>
               <c:when test="${not empty statistics.yearBrowseCount}">${statistics.yearBrowseCount}</c:when>
               <c:otherwise>0</c:otherwise>
             </c:choose>
          </span>
        </div>
        <div class="tag">
          <c:if test="${not empty dictNameList}">
            <c:forEach items="${dictNameList}" var="dictName">
              <a>${dictName}</a>
            </c:forEach>
          </c:if>
        </div>
      </div>

      <div class="line"></div>

      <div id="vedioDiv" style="text-indent: 0; margin: 20px auto;"></div>

      <div class="content" culture-img-url="${culture.cultureImgurl}">
        <img width="710" id="cultureImgUrl"/>
        ${culture.cultureDes}
      </div>

      <%--<c:if test="${not empty cultureInheritorList}">
        <div class="recommend mb20">
          <h2>传承人代表</h2>
          <ul class="recommend-venues" id="inheritorUl">
            <c:forEach items="${cultureInheritorList}" var="cultureInheritor">
              <li inheritor-head-img-url="${cultureInheritor.inheritorHeadImgUrl}">
                <a class="img fl"><img width="72" height="72"
                                       <c:if test="${cultureInheritor.inheritorSex == 1}">src="${path}/STATIC/image/face_boy.png"</c:if> <c:if test="${cultureInheritor.inheritorSex == 2}"> src="${path}/STATIC/image/face_girl.png"</c:if>/></a>
                <div class="info fr">
                  <h4>
                      ${cultureInheritor.inheritorName}&nbsp;&nbsp;&nbsp;&nbsp;
                    <c:if test="${cultureInheritor.inheritorSex == 1}">男</c:if>
                    <c:if test="${cultureInheritor.inheritorSex == 2}">女</c:if>&nbsp;&nbsp;&nbsp;&nbsp;
                    <c:if test="${not empty cultureInheritor.inheritorAge}">${cultureInheritor.inheritorAge}岁&nbsp;&nbsp;&nbsp;&nbsp;</c:if>
                      ${cultureInheritor.dictName}
                  </h4>
                  <div class="line"></div>
                  <p>${cultureInheritor.inheritorRemark}</p>
                </div>
              </li>
            </c:forEach>
          </ul>
        </div>
      </c:if>--%>
      <div class="line"></div>

      <c:if test="${not empty cultureInheritorList}">
        <div class="smriti-people" id="inheritorUl">
          <h2>传承人代表</h2>
          <ul class="list">
            <c:forEach items="${cultureInheritorList}" var="cultureInheritor">
              <li inheritor-head-img-url="${cultureInheritor.inheritorHeadImgUrl}">
                <div class="img fl"><img onload="fixImage(this, 100, 100)"
                                         <c:if test="${cultureInheritor.inheritorSex == 1}">src="${path}/STATIC/image/face_boy.png"</c:if> <c:if test="${cultureInheritor.inheritorSex == 2}"> src="${path}/STATIC/image/face_girl.png"</c:if>/></div>
                <div class="info fr">
                  <h3><span>${cultureInheritor.inheritorName}&nbsp;&nbsp;&nbsp;&nbsp;
                    <c:if test="${not empty cultureInheritor.inheritorSex}">
                      <c:if test="${cultureInheritor.inheritorSex == 1}">男</c:if>
                      <c:if test="${cultureInheritor.inheritorSex == 2}">女</c:if>&nbsp;&nbsp;&nbsp;&nbsp;
                    </c:if>
                    <c:if test="${not empty cultureInheritor.inheritorAge}">${cultureInheritor.inheritorAge}岁&nbsp;&nbsp;&nbsp;&nbsp;</c:if>
                      ${cultureInheritor.dictName}</span><a class="btn-icon collapse">展开<i></i></a></h3>
                  <div class="note">
                    <p>${cultureInheritor.inheritorRemark}</p>
                  </div>
                </div>
              </li>
            </c:forEach>
          </ul>
          <a class="load-more">查看更多...</a>
        </div>
      </c:if>

      <div class="icon">
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
        <input type="hidden" id="cultureId" name="cultureId" value="${culture.cultureId}"/>
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
    <c:if test="${not empty recommendCultureList}">
    <div class="recommend mb20">
      <div class="tit"><i></i>非遗推荐</div>
      <ul class="recommend-venues" id="recommendUl">
        <c:forEach items="${recommendCultureList}" var="recommendCulture">
          <li data-icon-url="${recommendCulture.cultureImgurl}">
            <a href="${path}/frontCulture/cultureDetail.do?cultureId=${recommendCulture.cultureId}" class="img fl"><img width="72" height="72"/></a>
            <div class="info fr">
              <h4><a href="${path}/frontCulture/cultureDetail.do?cultureId=${recommendCulture.cultureId}">${recommendCulture.cultureName}</a></h4>
              <p>类型：${recommendCulture.dictName}</p>
            </div>
          </li>
        </c:forEach>
      </ul>
    </div>
    </c:if>
  </div>
</div>

<%@include file="../index_foot.jsp"%>
</body>
</html>