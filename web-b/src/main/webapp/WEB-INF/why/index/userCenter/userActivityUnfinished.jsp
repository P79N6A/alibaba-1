<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

<%@include file="../../common/frontPageFrame.jsp"%>


    <script type="text/javascript">

        $(function(){
            // 得到我的活动未完成列表
            $('#userActivity').addClass('cur').siblings().removeClass('cur');

            getActivityList('${page.countPage}','${page.page}');
            // 得到图片
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



        // 得到活动收藏
        function getActivityList(countPage,page){
            var activityName = $("#keyword").val() == "请输入关键词" ? "":$("#keyword").val();
            $("#userActivityUnFinish").load("${path}/userActivity/userActivityUn.do",{
                activityName:activityName,countPage:countPage,page:page
            },function(){
                getPagination();
            });
        }
        function showAndHide(){
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
        }
    </script>

<!-- dialog end -->
</head>
<body>
<%--引入个人中心头文件--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div class="crumbs"><i></i>您所在的位置： <a href="#">个人主页</a> &gt; 我的收藏</div>
<div class="activity-content user-content clearfix">
    <%@include file="user_center_left.jsp"%>
    <%--<div class="user-left fl">--%>
        <%--<div class="user-info">--%>
            <%--<div class="user-photo">--%>
                <%--<a href="#"><img src="image/user-photo1.jpg" alt="" width="140" height="140"/></a>--%>
            <%--</div>--%>
            <%--<h3>777</h3>--%>
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
        <div class="user-tab">
            <a href="${path}/userActivity/userActivity.do" class="cur">当前活动</a>
            <a href="${path}/userActivity/userActivityDetail.do" class="cur">未完成订单</a>
            <a href="${path}/userActivity/userActivityHistory.do" class="cur">历史活动</a>
        </div>
        <div class="in-part1 activity-content clearfix" id="userActivityUnFinish">

        </div>
    </div>
</div>
<!-- 导入foot文件 start -->
<%@include file="../index_foot.jsp"%>

</body>
</html>