<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>取票机--我的场馆--历史订单--文化云</title>
    <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
    <script type="text/javascript">
        $(function() {
            $(".user-part").on("click", " ul li .btn-cancel-order", function () {
                var roomOrderId = $(this).attr("id");
                var orderNum = $(this).parent().attr("data-orderNum");
                dialogConfirm("删除预订", "您确定删除订单编号为"+ orderNum +"的场馆活动室预订吗？", function(){
                    $.post("${path}/roomOrder/logicalDeleteRoomOrder.do",{"roomOrderId":roomOrderId}, function(data) {
                        if (data!=null && data=='success') {
                            getActivityList();
                        }else{
                            dialogAlert("提示","删除活动室预订订单失败!");
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
                    des.animate({height: infoHeight+70});
                    that.siblings(".btn-cancel-order").show();
                }
            });

            $('#roomOrder').addClass('cur').siblings().removeClass('cur');

            getActivityList();
        });

        function getActivityList(){
            var reqPage=$("#reqPage").val();
            var countPage = $("#countpage").val();
            $("#collectionListHistory").load("${path}/ticketRoomOrder/queryRoomOrderHistoryList.do",{countPage:countPage,page:reqPage},function(){
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
                <a href="${path}/ticketRoomOrder/queryRoomOrder.do">当前订单</a>
                <a href="${path}/ticketRoomOrder/queryRoomOrderHistory.do" class="cur">历史订单</a>
            </div>
            <div class="user-part user-part-b" id="collectionListHistory">

            </div>
            <input type="hidden" id="reqPage"  value="1">
        </div>
        <form action="${path}/frontRoom/roomDetail.do#comment" id="roomDetailForm" method="post">
            <input id="roomId" name="roomId" type="hidden"/>
        </form>
    </div>
</div>

</body>
</html>