<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>个人中心-我的团体--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

  <script type="text/javascript">
    $(function() {
      $('#group').addClass('cur').siblings().removeClass('cur');

      // load加载页面
      getUserGroupManagerLoad('${page.countPage}','${page.page}');
    });

    function getUserGroupManagerLoad(countPage,page){
      $("#userGroupManager").load("${path}/frontTeamUser/userGroupManagerLoad.do", {tuserId:'${tuserId}',applyCheckState:3,countPage:countPage,page:page} ,function(){
        // 得到列表会员头像
        getAllTerminalUserHeadImg();
        // 分页
        getPagination();
        // 删除
        deleteUserGroupManager();
      });
    }

    function deleteUserGroupManager(){
      $(".user-part ul li").on("click", ".btn-delete", function () {
        var that = $(this);
        var name = $(this).parent().attr("data-name");
        var applyId = $(this).parent().attr("data-applyId");
        dialogConfirm("成员管理", "您确定要删除成员 "+ name +" 吗？", removeParent);
        function removeParent() {
          that.parent().fadeOut(function(){
            $.post("${path}/frontTeamUser/quitApplyJoinTeam.do",{applyId:applyId,applyCheckState:4},function(result){
              if(result == "success"){
                that.parent().remove();
              }
            });
          });
        }
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
          getUserGroupManagerLoad('${page.countPage}', $("#reqPage").val());
          return false;
        }
      });
    }

    function getAllTerminalUserHeadImg(){
      $("#userHeadImgDiv li").each(function(index,item){
        var imgUrl = $(this).attr("user-head-img");
        if(imgUrl != undefined && imgUrl != ""){
          imgUrl= getImgUrl(imgUrl);
          imgUrl = getIndexImgUrl(imgUrl, "_300_300");
          $(item).find("img").attr("src", imgUrl);
        }
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
        <a href="${path}/frontTeamUser/userGroupIndex.do" class="cur">我管理的团体</a>
      </c:if>
      <a href="${path}/frontTeamUser/userGroupJoin.do">我加入的团体</a>
      <a href="${path}/frontTeamUser/userGroupHistory.do">历史记录</a>
    </div>
    <div class="user-part user-part-b" id="userGroupManager">

    </div>
  </div>
</div>

<%@include file="../index_foot.jsp"%>

</body>
</html>