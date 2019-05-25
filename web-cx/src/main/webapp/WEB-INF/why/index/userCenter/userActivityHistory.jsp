<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>个人中心-我的活动--文化云</title>

    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
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

        $('#userActivityId').addClass('cur').siblings().removeClass('cur');

        getActivityList('${page.countPage}','${page.page}');





        //得到历史活动
        function getActivityList(countPage,page){
            var activityName = $("#keyword").val() == "请输入关键词" ? "":$("#keyword").val();
            $("#userActivityHistorys").load("${path}/userActivity/userActivityHistoryList.do",{
                activityName:activityName,countPage:countPage,page:page
            },function(){
                getPagination();
                setScreen();

                $(".user-part ul li").on("click", ".btn-delete-order", function () {
                    var that = $(this);
                    var orderNum = $(this).parent().attr("data-orderNum");
                    dialogConfirm("删除订单", "您确定要删除该订单吗？", removeParent);
                    function removeParent() {
                        $.post("${path}/userActivity/deleteUserActivityHistory.do",{
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
                        des.animate({height: "90px"},function(){
                            that.siblings(".btn-cancel-order").hide();
                        });
                    }else{
                        that.addClass("open");
                        that.html("收起<i></i>");
                        des.animate({height: infoHeight},function(){
                            that.siblings(".btn-cancel-order").show();
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



    function deleteUserHistoryActivity(id){


    }
</script>

<!-- dialog end -->
</head>
<body>

<%--引入个人中心头文件
<%@include file="/WEB-INF/why/index/index_top.jsp"%>--%>
<!-- 导入头部文件  无搜索按钮 -->
<div class="header">
	<%@include file="../header.jsp" %>
</div>

<div id="register-content">
<div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt;<a href="#"> 历史活动</a></div>
<div class="activity-content user-content clearfix">
    <%@include file="user_center_left.jsp"%>
    <%--<div class="user-left fl">--%>
        <%--<div class="user-info">--%>
            <%--<div class="user-photo">--%>
                <%--<a href="#"><img src="image/user-photo1.jpg" alt="" width="140" height="140"/></a>--%>
            <%--</div>--%>
            <%--<h3>捕光的人</h3>--%>
            <%--<h4>上海市 / 团体用户</h4>--%>
        <%--</div>--%>
        <%--<div class="user-menu">--%>
            <%--<a href="User-activity.html" class="cur">我的活动</a>--%>
            <%--<a href="User-venues.html">我的场馆</a>--%>
            <%--<a href="User-group.html">我的团体</a>--%>
            <%--<a href="User-MyCollection-activity.html">我的收藏</a>--%>
            <%--<a href="User-information.html">我的消息</a>--%>
            <%--<a href="User-setting.html" class="setting">账号设置</a>--%>
        <%--</div>--%>
    <%--</div>--%>
    <div class="user-right fr">
        <div class="user-tab" id="webDiv">
            <a href="${path}/userActivity/userActivity.do" >当前活动</a>
            <a href="${path}/userActivity/userActivityHistory.do" class="cur">历史活动</a>
        </div>
        <div class="user-tab" id="appDiv">
            <a href="${path}/userActivity/userActivity.do?fromTicket=Y" >当前活动</a>
            <a href="${path}/userActivity/userActivityHistory.do?fromTicket=Y" class="cur">历史活动</a>
        </div>
        <!--像div中写入数据-->
        <div class="user-part user-part-b" id="userActivityHistorys">

        </div>
    </div>
</div>
</div>
<!-- 导入foot文件 start -->
	<%@include file="/WEB-INF/why/index/footer.jsp" %>

</body>
</html>