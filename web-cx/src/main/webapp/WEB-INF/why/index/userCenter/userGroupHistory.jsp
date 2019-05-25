<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>个人中心-我的团体-历史记录--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

  <script type="text/javascript">
    $(function(){
      $('#group').addClass('cur').siblings().removeClass('cur');

      getUserGroupHistoryLoad('${page.countPage}','${page.page}');
    });

    function getUserGroupHistoryLoad(countPage,page){
      $("#userGroupHistory").load("${path}/frontTeamUser/userGroupHistoryLoad.do",{applyIsState:2,userId:'${sessionScope.terminalUser.userId}',countPage:countPage,page:page},function(){
        // 团体个性
        getTagName();
        // 团体位置
        getDictName();
        // 分页
        getPagination();
      });
    }

    // 分页
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
          getUserGroupHistoryLoad('${page.countPage}', $("#reqPage").val());
          return false;
        }
      });
    }

    // 团体个性
    function getTagName(){
      $("#userGroupHistoryLoadUl li").each(function(index,item){
        var tagIds = $(this).attr("tag-id");
        $.ajax({
          type: "post",
          url: "${path}/frontTeamUser/getTagName.do?tagIds="+tagIds,
          dataType: "json",
          contentType: "application/json; charset=utf-8",
          cache:false,//缓存不存在此页面
          async: false,//同步请求
          success: function (data) {
            if(data.length > 0){
              for(var i=0;i<data.length;i++){
                $(item).find(".tag").append(data[i].tagName+"&nbsp;");
              }
            }
          }
        });
      });
    }

    function getDictName(){
      $("#userGroupHistoryLoadUl li").each(function(index,item){
        var dictId = $(this).attr("dict-id");
        $.ajax({
          type: "post",
          url: "${path}/frontTeamUser/getDictName.do?dictId="+dictId,
          dataType: "json",
          contentType: "application/json; charset=utf-8",
          cache:false,//缓存不存在此页面
          async: false,//同步请求
          success: function (data) {
            if(data != null && data.dictName != '其他'){
              $(item).find(".tag").append(data.dictName+"&nbsp;");
            }
          }
        });
      });
    }
  </script>
</head>
<body>

<%--引入个人中心头文件--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div class="crumbs"><i></i>您所在的位置： <a href="#">个人主页</a> &gt; 我的团体</div>
<div class="activity-content user-content clearfix">
  <%--引入个人中心左边菜单--%>
  <%@include file="user_center_left.jsp"%>

  <div class="user-right fr">
    <div class="user-tab">
      <c:if test="${sessionScope.terminalUser.userType == 2}">
        <a href="${path}/frontTeamUser/userGroupIndex.do">我管理的团体</a>
      </c:if>
      <a href="${path}/frontTeamUser/userGroupJoin.do">我加入的团体</a>
      <a href="${path}/frontTeamUser/userGroupHistory.do" class="cur">历史记录</a>
    </div>
    <div class="user-part user-part-b" id="userGroupHistory">

    </div>
  </div>
</div>

<%@include file="../index_foot.jsp"%>

</body>
</html>