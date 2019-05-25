<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>团体首页--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

  <script type="text/javascript">
    $(function(){
      $('#collect').addClass('cur').siblings().removeClass('cur');
      getGroupList('${page.countPage}','${page.page}');
      keywordBlur();
    });


    //分页
    function getPagination(){
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
          getGroupList('${page.countPage}', $("#reqPage").val());
          return false;
        }
      });
    }

    //文本框失去焦点时查询活动
    function keywordBlur(){
      $("#keyword").blur(function(){
        getGroupList('${page.countPage}',$("#reqPage").val());
      });
    }

    // 得到列表
    function getGroupList(countPage,page){
      var tuserName = $("#keyword").val() == "请输入关键词" ? "":$("#keyword").val();
      $("#collectGroup").load("${path}/frontCollect/collectGroupLoad.do",{tuserName:tuserName,countPage:countPage,page:page},function(){
        getPictures();
        getPagination();
      });
    }

    //获取列表元素中所包含的图片
    function getPictures(){
      //请求页面下方团体所有图片
      $("#groupUl li").each(function (index, item) {
        var imgUrl = $(this).attr("data-icon-url");
        imgUrl= getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
      });
    }

    // 删除团体收藏
    function deleteCollectGroup(id){
      dialogConfirm("取消收藏", "您确定要取消收藏此团体吗？", removeParent);
      function removeParent() {
        $.post("${path}/frontCollect/deleteCollect.do",{relateId:id,type:4},function(result){
          if(result == "success"){
            getGroupList();
          }
        });
      }
    }
  </script>
</head>
<body>
<%--引入个人中心头文件--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div class="crumbs"><i></i>您所在的位置： <a href="#">个人主页</a> &gt; 我的收藏</div>
<div class="activity-content user-content clearfix">
  <%--引入个人中心左边菜单--%>
  <%@include file="user_center_left.jsp"%>

  <div class="user-right fr">
    <div class="user-tab">
      <a href="${path}/frontCollect/collectActivity.do">我收藏的活动</a>
      <a href="${path}/frontCollect/collectVenue.do">我收藏的场馆</a>
      <a href="${path}/frontCollect/collectGroup.do" class="cur">我收藏的团体</a>
    </div>
    <div class="user-part user-part3" id="collectGroup">

    </div>
  </div>
</div>

<%@include file="../index_foot.jsp"%>

</body>
</html>