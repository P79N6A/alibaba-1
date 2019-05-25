<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>取票机--我的场馆--当前订单--文化云</title>
    <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ticket.css"/>
    <script type="text/javascript">
        $(function() {
            $(".user-part").on("click", " ul li .btn-cancel-order", function () {
                var roomOrderId = $(this).attr("id");
                var orderNum = $(this).parent().attr("data-orderNum");
                dialogConfirm("取消预订", "您确定取消订单编号为"+ orderNum +"的场馆活动室预订吗？", function(){
                    $.post("${path}/ticketRoomOrder/cancelRoomOrderFront.do",{"roomOrderId":roomOrderId}, function(data) {
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
                    des.animate({height: "96px"});
                    that.siblings(".btn").hide();
                }else{
                    that.addClass("open");
                    that.html("收起<i></i>");
                    des.animate({height: infoHeight+70});
                    that.siblings(".btn").show();
                }
            });

            $('#roomOrder').addClass('cur').siblings().removeClass('cur');

            getActivityList();
        });

        function getActivityList(){
            var reqPage=$("#reqPage").val();
            var countPage = $("#countpage").val();
            $("#collectionList").load("${path}/ticketRoomOrder/queryRoomOrderList.do",{countPage:countPage,page:reqPage},function(){
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
<%@include file="/WEB-INF/why/ticket/ticket-nav.jsp"%>

<div id="register-content" class="ticket-user">
    <div class="user-content clearfix">
        <%@include file="ticketUser_center_left.jsp"%>

        <div class="user-right fr">
            <div class="user-tab">
                <a href="${path}/ticketRoomOrder/queryRoomOrder.do" class="cur">当前订单</a>
                <a href="${path}/ticketRoomOrder/queryRoomOrderHistory.do">历史订单</a>
            </div>
            <div class="user-part user-part-b" id="collectionList">

            </div>
            <input type="hidden" id="reqPage"  value="1">
        </div>
    </div>
</div>

</body>
</html>