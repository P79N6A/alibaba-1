<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>个人中心-我的团体-消息审核--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

  <script type="text/javascript">
    $(function() {
      $('#group').addClass('cur').siblings().removeClass('cur');

      // load加载页面
      getUserGroupAuditingLoad('${page.countPage}','${page.page}');
    });

    function getUserGroupAuditingLoad(countPage,page){
      $("#userGroupAuditing").load("${path}/frontTeamUser/userGroupAuditingLoad.do", {tuserId:'${tuserId}',applyIsState:2,countPage:countPage,page:page} ,function(){
        getAllTerminalUserHeadImg();

        auditingDialogOpen();

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
          getUserGroupAuditingLoad('${page.countPage}', $("#reqPage").val());
          return false;
        }
      });
    }

    // 通过审核与拒绝加入
    function auditingDialogOpen(){
      $(".user-part ul li").on("click", ".btn-refuse", function () {
        var that = $(this);
        var name = $(this).parent().attr("data-name");
        var applyId = $(this).parent().attr("data-applyId");
        dialogConfirm("提示", "您确定要拒绝 "+ name +" 的加入吗？", removeParent);
        function removeParent() {
          that.parent().fadeOut(function(){
            $.post("${path}/frontTeamUser/refuseApplyJoinTeam.do",{applyId:applyId,applyCheckState:2},function(result){
              if(result == "success"){
                that.parent().remove();
              }
            });
          });
        }
      });
      $(".user-part ul li").on("click", ".btn-approved", function () {
        var that = $(this);
        var name = $(this).parent().attr("data-name");
        var applyId = $(this).parent().attr("data-applyId");
        var tuserId = $(this).parent().attr("tuser-id");
        var tuserLimit = $(this).parent().attr("tuser-limit");
        $.ajax({
          type: "POST",
          url: "${path}/frontApplyJoinTeam/queryApplyJoinTeamCount.do",
          data:{tuserId:tuserId,applyCheckState:3},
          async:false,
          success: function(data){
            if(parseInt(tuserLimit) > parseInt(data)){
              function removeParent() {
                $.post("${path}/frontTeamUser/checkApplyJoinTeamPass.do",{applyId:applyId,applyCheckState:3},function(result){
                  if(result == "success"){
                    that.parent().fadeOut().remove();
                  }
                });
              }
              dialogAlert("提示", "您已通过了 "+ name +" 的加入", removeParent);
            }else{
              dialogAlert("提示", "该团体成员已满，修改团体成员上限才能通过审核");
            }
          }
        });
      });
    }

    // 获取列表所有会员头像
    function getAllTerminalUserHeadImg(){
      $("#userHeadImgDiv li").each(function(index,item){
        var imgUrl = $(this).attr("user-head-img");
        if(imgUrl != undefined && imgUrl != "") {
          imgUrl = getImgUrl(imgUrl);
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
    <div class="user-part user-part-b" id="userGroupAuditing">

    </div>
  </div>
</div>

<%@include file="../index_foot.jsp"%>

</body>
</html>