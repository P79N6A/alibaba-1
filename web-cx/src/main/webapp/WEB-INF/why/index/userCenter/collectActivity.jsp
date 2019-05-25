<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>个人中心-我的收藏-活动--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
  <script type="text/javascript">

    $(function(){
      $('#collect').addClass('cur').siblings().removeClass('cur');
      //文本框失去焦点时查询活动
      keywordBlur();

      // 得到活动收藏
      getActivityList('${page.countPage}','${page.page}');
    });

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
          getActivityList('${page.countPage}', $("#reqPage").val());
          return false;
        }
      });
    }

    //文本框失去焦点时查询活动
    function keywordBlur(){
      $("#keyword").blur(function(){
        getActivityList('${page.countPage}',$("#reqPage").val());
      });
    }

    // 得到活动收藏
    function getActivityList(countPage,page){
      var activityName = $("#keyword").val() == "请输入关键词" ? "":$("#keyword").val();
      $("#collectActivity").load("${path}/frontCollect/collectActivityLoad.do",{activityName:activityName,countPage:countPage,page:page},function(){
        getPictures();
      //得到喜欢搜藏的人数
        $("#activityUl label").each(function (index, item) {
          var activityId = $(this).attr("tid");
          $.ajax({
            type: 'POST',
            dataType : "json",
            url: "${path}/collect/getHotNum.do?relateId="+activityId+"&type=2",//请求的action路径
            error: function () {//请求失败处理函数
            },
            success:function(data){ //请求成功后处理函数。
              $("#recommend_"+activityId).html(data);
            }
          });
        });
        getPagination();
        setScreen();
      });
    }

    //获取列表元素中所包含的图片
    function getPictures(){
      //请求页面下方团体所有图片
      $("#activityUl li").each(function (index, item) {
        var imgUrl = $(this).attr("data-icon-url");
        imgUrl= getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
      });
    }

    // 删除活动收藏
    function deleteCollectActivity(id){
      dialogConfirm("取消收藏", "您确定要取消收藏此活动吗？", removeParent);
      function removeParent() {
        $.post("${path}/frontCollect/deleteCollect.do",{relateId:id,type:2},function(result){
          if(result == "success"){
            getActivityList('${page.countPage}',$("#reqPage").val());
          }
        });
      }
    }

  </script>

</head>
<body>

<%--引入个人中心头文件--%>
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
      <a href="${path}/frontCollect/collectActivity.do" class="cur">我收藏的活动</a>
      <a href="${path}/frontCollect/collectVenue.do">我收藏的场馆</a>
     <%-- <a href="${path}/frontCollect/collectGroup.do">我收藏的团体</a>--%>
    </div>
    <div class="user-part user-part-b" id="collectActivity">

    </div>
  </div>
</div>
</div>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>