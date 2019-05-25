<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>个人中心-我的收藏-场馆--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>

  <script type="text/javascript">
    $(function(){
      $('#collect').addClass('cur').siblings().removeClass('cur');
      getVenueList('${page.countPage}','${page.page}');
      keywordBlur();
    });

    function getVenueList(countPage,page){
      var venueName = $("#keyword").val() == "请输入关键词" ? "":$("#keyword").val();
      $("#collectVenue").load("${path}/frontCollect/collectVenueLoad.do",{venueName:venueName,countPage:countPage,page:page},function(){
        getPictures();
        getPagination();
        setScreen();
      });
    }

    // 删除场馆收藏
    function deleteCollectVenue(id){
      dialogConfirm("取消收藏", "您确定要取消收藏此场馆吗？", removeParent);
      function removeParent() {
        $.post("${path}/frontCollect/deleteCollect.do",{relateId:id,type:1},function(result){
          if(result == "success"){
            getVenueList('${page.countPage}',$("#reqPage").val());
          }
        });
      }
    }

    //文本框失去焦点时查询活动
    function keywordBlur(){
      $("#keyword").blur(function(){
        getVenueList('${page.countPage}',$("#reqPage").val());
      });
    }

    function getPagination(){
      //分页
      kkpager.generPageHtml({
        pno :$("#pages").val() ,
        //总页码
        total :$("#countPage").val(),
        //总数据条数
        totalRecords :$("#total").val(),
        mode : 'click',
        click : function(n){
          this.selectPage(n);
          $("#reqPage").val(n);
          getVenueList('${page.countPage}', $("#reqPage").val());
          return false;
        }
      });
    }

    //获取列表元素中所包含的图片
    function getPictures(){
      //请求页面下方团体所有图片
      $("#venueUl li").each(function (index, item) {
        var imgUrl = $(this).attr("data-icon-url");
        imgUrl= getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
      });
    }
  </script>
</head>
<body>

<%--引入个人中心头文件--%>
<%--<%@include file="/WEB-INF/why/index/index_top.jsp"%>--%>
<div class="header">
	<%@include file="../header.jsp" %>
</div>
<div id="register-content">
<div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt;<a href="#"> 我的收藏</a></div>
<div class="activity-content user-content clearfix">
  <%--引入个人中心左边菜单--%>
  <%@include file="user_center_left.jsp"%>

  <div class="user-right fr">
    <div class="user-tab">
      <a href="${path}/frontCollect/collectActivity.do">我收藏的活动</a>
      <a href="${path}/frontCollect/collectVenue.do" class="cur">我收藏的场馆</a>
      <%--<a href="${path}/frontCollect/collectGroup.do">我收藏的团体</a>--%>
    </div>
    <div class="user-part user-part-b" id="collectVenue">

    </div>
  </div>
</div>
</div>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>