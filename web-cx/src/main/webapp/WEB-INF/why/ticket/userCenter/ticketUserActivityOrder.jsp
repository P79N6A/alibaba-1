<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>取票机-我的活动--文化云</title>

    <!-- 导入头部文件 start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ticket.css"/>
    <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/getTicket.js"></script>

    <script type="text/javascript">

        $(function(){
            //文本框失去焦点时查询活动
            $('#userActivityId').addClass('cur').siblings().removeClass('cur');
//            keywordBlur();
            // 得到活动收藏
            getActivityList('${page.countPage}','${page.page}');
            // 得到用户图片
//            getTerminalUserHeadImg();
            CommentNu();
            
            $.ajaxSetup({
          	  async: false
          	  });
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


        // 得到活动
        function getActivityList(countPage,page){
            $("#userActivityList").load("${path}/ticketUserActivity/ticketUserActivityList.do",{
                countPage:countPage,page:page
            },function(){
                getPagination();
                setScreen();




                $(".user-part ul li").on("click", ".btn-order-detail", function () {

                    var that = $(this);
                    var des = that.parent().find(".info");
                    var infoHeight = des.find("div").height();
                    if(that.hasClass("open")){
                        that.removeClass("open");
                        that.html("订单详情");
                        des.animate({height: "96px"},function(){
                            that.siblings(".btn").hide();
                        });
                    }else{
                        that.addClass("open");
                        that.html("收起<i></i>");
                        des.animate({height: infoHeight+70},function(){
                            that.siblings(".btn").show();
                        });
                    }
                });

                $(".info").on("click", "label", function(){
                    var $this = $(this);
                    var $checkbox = $this.find("input[type=checkbox]");
                    if($checkbox.prop("checked") == true){
                        $this.removeClass("r-off").addClass("r-on");
                    }else{
                        $this.removeClass("r-on").addClass("r-off");
                    }
                });

                //取票
                $(".user-part ul li").on("click", ".btn-get-ticket", function () {
                    var $this= $(this);
                    var parentLi = $this.parents("li");
                    var orderValidateCode = $(this).parent().attr("data-orderValidateCode");
                    $("#ticketPage", window.parent.document).hide();
                    $("#get-ticket", window.parent.document).show();
                    getTicket(orderValidateCode);
                });

                /**
                 *  取消订单
                 */
                $(".user-part ul li").on("click", ".btn-cancel-order", function () {
                    var $this= $(this);
                    var parentLi = $this.parents("li");
                    var orderNum = $(this).parent().attr("data-orderNum");
                    var seatSel = parentLi.find(".info p .r-on");
                    var seatSeloff = parentLi.find(".info p .r-off");
                    var seatSelNum = seatSel.length;
                    var seatNum = seatSel.length + seatSeloff.length;
                    var seatTxt = "";
                    var seatArr = [];
                    var orderSeat ="";
                    var qxCount = 0;
                    seatSel.each(function(){
                        seatArr.push($(this).find("span").text());
                        orderSeat += $(this).find("span").attr("cancelSeat") + ",";
                        qxCount = qxCount + 1;
                    });
                    seatTxt = seatArr.join("、");
                    var seatSelNum = seatSel.length;
                    if (seatSel.length + seatSeloff.length > 0) {
                        if(seatSelNum == 0){
                            dialogAlert("提示", "请选择需要退订的座位",function () {
                            });
                        }
                        else {
                            var dialogMes = "您确定取消该订单吗?"
                            if (orderSeat != "") {
                                dialogMes = '您确定退订"' + '' + seatTxt  + '"'+ ' 吗?';
                            }
                            dialogConfirm("提示", dialogMes, removeParent);
                            function removeParent() {
                                $.post("${path}/ticketUserActivity/cancelTicketUserOrder.do",{
                                    'activityOrderId':orderNum,'orderSeat':orderSeat
                                },function (data) {
                                    var map = eval(data);
                                    if (map.success == 'Y') {
                                        if(seatSelNum == seatNum) {
                                            parentLi.fadeOut(function(){ parentLi.remove(); });
                                        } else if (orderSeat == '') {
                                            parentLi.fadeOut(function(){ parentLi.remove(); });
                                        } else if (orderSeat != '') {
                                            seatSel.fadeOut(function(){
                                                var count = parseInt($("#votes" + orderNum).text());
                                                $("#votes" + orderNum).html(count - seatSelNum);
                                                $(this).remove();
                                            });
                                        }
                                    } else {
                                        dialogAlert("提示","订单取消失败:" + map.msg);
                                    }
                                });

                            }
                        }
                    } else {
                        var dialogMes = "您确定取消该订单吗?"
                        if (orderSeat != "") {
                            dialogMes = '您确定退订"' + '' + '"' + seatTxt + ' 吗?';
                        }
                        dialogConfirm("提示", dialogMes, removeParent);
                        function removeParent() {
                            $.post("${path}/ticketUserActivity/cancelTicketUserOrder.do",{
                                'activityOrderId':orderNum,'orderSeat':orderSeat
                            },function (data) {
                                var map = eval(data);
                                if (map.success == 'Y') {
                                    if(seatSelNum == seatNum) {
                                        parentLi.fadeOut(function(){ parentLi.remove(); });
                                    } else if (orderSeat == '') {
                                        parentLi.fadeOut(function(){ parentLi.remove(); });
                                    } else if (orderSeat != '') {
                                        seatSel.fadeOut(function(){
                                            var count = parseInt($("#votes" + orderNum).text());
                                            $("#votes" + orderNum).html(count - seatSelNum);
                                            $(this).remove(); });
                                    }
                                } else {
                                    dialogAlert("提示","订单取消失败:" + map.msg);
                                }
                            });

                        }
                    }

                });


            });
        }

        function CommentNu(){
            $.post("${path}/ticketUserActivity/queryActivityCommentByActivityId.do",  function(data) {
                if (data != 0) {

                }  else {

                }
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
            <a href="${path}/ticketUserActivity/ticketUserActivity.do" class="cur">当前活动</a>
            <a href="${path}/ticketUserActivity/ticketUserActivityHistory.do">历史活动</a>
        </div>
        <div class="user-part user-part-b" id="userActivityList">
        </div>
    </div>
</div>
</div>

</body>
</html>