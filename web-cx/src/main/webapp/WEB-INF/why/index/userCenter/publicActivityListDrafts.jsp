<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>个人中心-发起活动--文化云</title>

    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>


    <script type="text/javascript">
        //删除活动
        function delPublicActivity(activityId) {
            dialogConfirm("删除活动", "您确定要删除该活动吗？", removeParent);
            function removeParent() {
                $.post("${path}/userActivity/delPublicActivity.do",{
                    'activityId':activityId
                },function (rsData) {
                    if (rsData == 'success') {
                        location.reload();
                    } else {
                        dialogAlert("提示","删除失败:" +rsData);
                    }
                });
            }
        }


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

        $('#publicActivityList').addClass('cur').siblings().removeClass('cur');

        getActivityList('${page.countPage}','${page.page}');

        //得到历史活动
        function getActivityList(countPage,page){
            var activityName = $("#keyword").val() == "请输入关键词" ? "":$("#keyword").val();
            $("#userActivityHistorys").load("${path}/userActivity/prePublicActivityListDraftsLoad.do",{
                activityName:activityName,countPage:countPage,page:page
            },function(){
                getPagination();

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
                            des.animate({height: "90px"});
                        }else{
                            that.addClass("open");
                            that.html("收起<i></i>");
                            des.animate({height: infoHeight});
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
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
<div class="crumb"><i></i>您所在的位置： <a href="#">个人主页</a> &gt; 发起活动</div>
<div class="activity-content user-content clearfix">
    <%@include file="user_center_left.jsp"%>
    <div class="user-right fr">
        <div class="user-tab" id="webDiv">
            <a href="${path}/userActivity/prePublicActivityList.do" >活动管理</a>
            <a href="${path}/userActivity/prePublicActivityListDrafts.do" class="cur" >草稿箱</a>
            <span class="btn-initiate"><a href="${path}/userActivity/prePublicActivity.do">发起活动</a></span>
        </div>
        <div class="user-tab" id="appDiv">
            <a href="${path}/userActivity/userActivity.do?fromTicket=Y" >活动管理</a>
            <a href="${path}/userActivity/userActivityHistory.do?fromTicket=Y" class="cur">草稿箱</a>
        </div>
        <!--像div中写入数据-->
        <div class="user-part user-part-b" id="userActivityHistorys">

        </div>
    </div>
</div>

<!-- 导入foot文件 start -->
<%@include file="../index_foot.jsp"%>

</body>
</html>