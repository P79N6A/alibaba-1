<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>我的预订--文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="../../common/frontPageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <script type="text/javascript">
    $(function() {

        var localUrl = top.location.href;
        var webPage = document.getElementById("webDiv");
        var appPage = document.getElementById("appDiv");

        if(localUrl.indexOf("collect_info.jsp") == -1){
            appPage.innerHTML = "";
            appPage.style.display = "none";

        }else{
            webPage.innerHTML = "";
            webPage.style.display = "none";

        }

        $(".user-part").on("click", " ul li .btn-cancel-order", function () {
            var roomOrderId = $(this).attr("id");
            var orderNum = $(this).parent().attr("data-orderNum");
            dialogConfirm("取消预订", "您确定取消订单编号为"+ orderNum +"的场馆活动室预订吗？", function(){
                $.post("${path}/roomOrder/cancelRoomOrderFront.do",{"roomOrderId":roomOrderId}, function(data) {
                    if (data!=null && data=='success') {
                        getActivityList();
                    }else{
                        dialogAlert("提示","取消活动室预订订单失败!");
                    }
                });
            });
        });

        $(".user-part").on("click", " ul li .btn-order-detail", function () {
            var that = $(this);
            var des = that.parent().find(".info");
            var infoHeight = des.find("div").height();
           
            if(that.hasClass("open")){
                that.removeClass("open");
                that.html("订单详情");
                des.animate({height: "90px"});
                that.siblings(".btn-cancel-order").hide();
            }else{
                that.addClass("open");
                that.html("收起<i></i>");
                des.animate({height: infoHeight});
                that.siblings(".btn-cancel-order").show();
            }
        });

        $('#roomOrder').addClass('cur').siblings().removeClass('cur');

        getActivityList();
    });

    function getActivityList(){
        var reqPage=$("#reqPage").val();
        var countPage = $("#countpage").val();
        $("#collectionList").load("${path}/roomOrder/queryRoomOrderList.do",{countPage:countPage,page:reqPage},function(){
            setScreen();
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
                    getActivityList();
                    return false;
                }
            });
        });
    }
</script>
<!-- dialog end -->
</head>
<body>


<%--引入个人中心头文件--%>
<div class="header">
	<%@include file="../header.jsp" %>
</div>

<div id="register-content">
<div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt; <a href="#"> 我的场馆</a></div>
<div class="activity-content user-content clearfix">
    <%@include file="user_center_left.jsp"%>
    <div class="user-right fr">
        <div class="user-tab" id="webDiv">
            <a href="${path}/roomOrder/queryRoomOrder.do" class="cur">当前订单</a>
            <a href="${path}/roomOrder/queryRoomOrderHistory.do">历史订单</a>
        </div>
        <div class="user-tab" id="appDiv">
            <a href="${path}/roomOrder/queryRoomOrder.do?fromTicket=Y" class="cur">当前预订</a>
            <a href="${path}/roomOrder/queryRoomOrderHistory.do?fromTicket=Y">历史预订</a>
        </div>
        <!--像div中写入数据-->
        <div class="user-part user-part-b" id="collectionList">

        </div>
        <input type="hidden" id="reqPage"  value="1">
    </div>
    <form action="${path}/frontRoom/roomDetail.do#comment" id="roomDetailForm" method="post">
        <input id="roomId" name="roomId" type="hidden"/>
    </form>
</div>
</div>
<!-- 导入foot文件 start -->
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>