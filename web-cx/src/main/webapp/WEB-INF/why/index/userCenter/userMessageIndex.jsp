<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>个人中心-我的消息--佛山文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/index/userCenter/userMessageIndex.js"></script>
  <script type="text/javascript">
    $(function(){
      //左侧选中
      $('#message').addClass('cur').siblings().removeClass('cur');
    });
    function delMessage(id){
        dialogConfirm("删除消息", "您确定要删除此消息吗？", removeParent);
        function removeParent() {
            $.ajax({
                type: "POST",
                data:{
                    id:id
                },
                url: "${path}/userMessage/deleteUserMessage.do",
                dataType: "json",
                success: function (data) {
                    if(data == "success") {
                        window.location.href="${path}/userMessage/userMessageIndex.do";
                    }else{
                        window.location.href="${path}/frontActivity/frontActivityIndex.do";
                    }
                }
            });
        }
    }

    function delAllMsg(){
        dialogConfirm("删除消息", "您确定要删除全部消息吗？", removeParent);
        function removeParent() {
            $.ajax({
                type: "POST",
                data:$("#msgForm").serialize(),
                url: "${path}/userMessage/deleteUserMessage.do",
                dataType: "json",
                success: function (data) {
                    if(data == "success") {
                        window.location.href="${path}/userMessage/userMessageIndex.do";
                    }else{
//                        dialogAlert("提示","没有被删除的消息！");
                    }
                }
            });
        }
    }


    //该文件不能单独写
    function messageLoad(page){
      $("#userMessageIndex").load("${path}/userMessage/userMessageLoad.do #userMessageIndexLoad",{applyIsState:1,userId:'${sessionScope.terminalUser.userId}',page:page},function(){
          messagePage();
          setScreen();

        $(".user-part .des div").each(function(){
              if($(this).height() <= 26){
                  $(this).parent().siblings(".btn-system-info").hide();
              }
          });

        $(".user-part ul li").on("click", ".btn-system-info", function () {
              var that = $(this);
              var des = that.parent().find(".des");
              var infoHeight = des.find("div").height();

              if(that.hasClass("open")){
                  that.removeClass("open");
                  that.html("展开<i></i>");
                  des.animate({height: "26px"});
              }else{
                  that.addClass("open");
                  that.html("收起<i></i>");
                  des.animate({height: infoHeight});
              }

          });
      });
    }
  </script>
</head>
<body>

<%--引入个人中心头文件--%>

<div class="header">
	<%@include file="../header.jsp" %>
</div>

<div id="register-content">
<div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt; <a href="#">我的消息</a></div>
    <div class="activity-content user-content clearfix">
    <%@include file="user_center_left.jsp"%>
        <div class="user-right fr">
            <div class="user-tab">
                <h3>我的消息</h3>
                 <span class="btn-delete-all"><a class="btn btn-red btn-delete-info" href="javascript:delAllMsg();"  style="color: #F58636;">全部删除</a></span>
            </div>
            <form id="msgForm" name="msgForm" method="post">
                <div class="user-part user-part-b" id="userMessageIndex">

                </div>
            </form>
        </div>

</div>
</div>
<input type="hidden" value="1" id="reqPage"/>
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>