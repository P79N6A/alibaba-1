<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>取票机-我的活动--文化云</title>

    <!-- 导入头部文件 start -->

    <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ticket.css"/>
    <script type="text/javascript">
    $(function() {
        $('#userActivityId').addClass('cur').siblings().removeClass('cur');

        getActivityList('${page.countPage}','${page.page}');

        //得到历史活动
        function getActivityList(countPage,page){
            var activityName = $("#keyword").val() == "请输入关键词" ? "":$("#keyword").val();
            $("#userActivityHistorys").load("${path}/ticketUserActivity/ticketUserActivityHistoryList.do",{
                activityName:activityName,countPage:countPage,page:page
            },function(){
                getPagination();
                setScreen();

                $(".user-part ul li").on("click", ".btn-delete-order", function () {
                    var that = $(this);
                    var orderNum = $(this).parent().attr("data-orderNum");
                    dialogConfirm("删除订单", "您确定要删除该订单吗？", removeParent);
                    function removeParent() {
                        $.post("${path}/ticketUserActivity/deleteTicketUserActivityHistory.do",{
                            'activityOrderId':orderNum
                        })
                        that.parent().fadeOut(function(){
                            that.parent().remove();
                        });
                    }
                });

                    $(".user-part ul li").on("click", ".btn-order-detail", function () {
                        var that = $(this);
                        var des = that.parent().find(".info");
                        var infoHeight = des.find("div").height();

                        if(that.hasClass("open")){
                            that.removeClass("open");
                            that.html("订单详情");
                            des.animate({height: "90px"});
                            $(".btn-delete-order").hide();
                        }else{
                            that.addClass("open");
                            that.html("收起<i></i>");
                            des.animate({height: infoHeight}, function(){
                                $(".btn-delete-order").show();
                            });
                        }
                    });

            });
        }

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

    });
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
            <a href="${path}/ticketUserActivity/ticketUserActivity.do" >当前活动</a>
            <a href="${path}/ticketUserActivity/ticketUserActivityHistory.do" class="cur">历史活动</a>
        </div>
        <!--像div中写入数据-->
        <div class="user-part user-part-b" id="userActivityHistorys">

        </div>
    </div>
</div>
</div>

</body>
</html>