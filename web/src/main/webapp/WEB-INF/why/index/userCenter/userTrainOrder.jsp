<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
<link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">
<link rel="stylesheet" href="${path}/STATIC/layui/css/layui.css" media="all">
<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/zjStyleChild.css" />
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/layui/layui.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/owl.carousel.js"></script>

<script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.1.js" ></script>
<head>

    <title>我的培训</title>
    <!-- 导入头部文件 start -->
    <%@include file="../../common/frontPageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpCulture.css"/>
    <script type="text/javascript">
        $(function() {
            $('#userActivityId').addClass('cur').siblings().removeClass('cur');

            $(".user-part").on("click", "div .unsubscribe", function () {
                var orderId = $(this).attr("id");
                dialogConfirm("取消预订", "您确定取消该培训预订吗？", function(){
                    $.post("${path}/cmsTrain/saveOrder.do",{"id":orderId,"state":2}, function(data) {
                        data = JSON.parse(data);
                        if (data.status==200) {
                            loadOrderList('6');
                        }else{
                            dialogAlert("提示","取消培训预订订单失败!");
                        }
                    });
                });
            });

            $('#userTrainOrderId').addClass('cur').siblings().removeClass('cur');

            loadOrderList('6');
        });

        function loadOrderList(status){
            var reqPage=$("#reqPage").val();
            var countPage = $("#countpage").val();
            //按条件筛选
            $('.user-right').on('click', '.user-tab a', function () {
                $(this).addClass('cur').siblings().removeClass('cur');
            })
            $("#trainOrderList").load("${path}/cmsTrain/centerOrderList.do",{countPage:countPage,page:reqPage,status:status},function(){
                setScreen();
                kkpager.totalRecords = $("#total").val();
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
                        loadOrderList(status);
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
<!-- 导入foot文件 start -->
<div id="register-content">
    <div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt; <a href="#"> 我的培训</a></div>
    <div class="activity-content user-content clearfix">
        <%@include file="user_center_left.jsp"%>
        <div class="user-right fr">
            <div class="user-tab">
                <a href="#" onclick="loadOrderList('6');" value="6" class="cur"  style="width: 120px;">全部</a>
                <a href="#" onclick="loadOrderList('3');" value="3" style="width: 120px;">待审核</a>
                <a href="#" onclick="loadOrderList('1');" value="1" style="width: 120px;">已录取</a>
                <a href="#" onclick="loadOrderList('2');" value="2"  style="width: 120px;">已取消</a>
                <a href="#" onclick="loadOrderList('4');" value="4"  style="width: 120px;">审核未通过</a>
                <a href="#" onclick="loadOrderList('5');" value="5"  style="width: 120px;">培训已结束</a>
            </div>
            <!--像div中写入数据-->
            <div class="user-part user-part-b" id="trainOrderList">
            </div>
        </div>
    </div>
</div>
<!-- 导入foot文件 start -->
<div class="footer">
    <%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
</body>
</html>