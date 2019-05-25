<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="/STATIC/html/css/reset.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/html/css/qastyle.css"/>
    <script type="text/javascript">
        /**left_menu**/
        $(function(){
            $(".hc_l dl dd a").click(function(){
                $(this).parents().addClass("curchoose").siblings().removeClass("curchoose");
                $(this).parents().siblings().children().removeClass("curchoose")
            })
        })
        /**right_fold**/
        $(function(){
            $(".subNav").click(function(){
                $(this).toggleClass("currentDd").siblings(".subNav").removeClass("currentDd");
                $(this).toggleClass("currentDt").siblings(".subNav").removeClass("currentDt");
                $(this).next(".navContent").slideToggle(300).siblings(".navContent").slideUp(500);
            })
        })
        /**左右高度一致**/
        $(function(){


             $('#'+'${link}').toggleClass("currentDd").siblings(".subNav").removeClass("currentDd");
            $('#'+'${link}').toggleClass("currentDt").siblings(".subNav").removeClass("currentDt");
            $('#'+'${link}').next(".navContent").slideToggle(300).siblings(".navContent").slideUp(500);

            var heightLeft= $(".hc_l").height();
            var heightRight= $(".hc_r").height();
            if (heightRight >  heightLeft)
            {
                $(".hc_l").height(heightRight);
            }
            else
            {
                $(".hc_r").height(heightLeft);
            }
        })
        function feedBack(){

            window.location.href="${path}/frontIndex/feedBack.do";

        }
    </script>

</head>

<body >

<div id="help_center" class="clearfix" style="float:left;margin-top:10px; margin-left:10px;">
    <div class="hc_l fl">
        <dl>
            <dt>问题帮助</dt>
            <dd class="curchoose" ><a href="#" >功能问题</a></dd>
            <dd  ><a href="#" >操作流程问题</a></dd>
            <dd  ><a href="#"  >新手入门</a></dd>
        </dl>
        <%--<dl>--%>
            <%--<dt class="fack">意见反馈</dt>--%>
            <%--<dd><a href="#">意见反馈</a></dd>--%>
        <%--</dl>--%>
    </div>
    <div class="hc_r fl">
        <div class="subNav currentDd currentDt" id="fail1">封面上传失败怎么办?</div>
        <ul class="navContent " style="display:block">
            <li><a href="#">1、上传图片是否750*500像素以上；</a></li>
            <li><a href="#">2、需要上传2M以下的照片；</a></li>
            <li><a href="#">3、请使用谷歌浏览器。</a></li>
        </ul>
        <div class="subNav" id="fail2">活动上传中没有对应的热区位置怎么办？</div>
        <ul class="navContent">
            <li><a href="#">请及时联系文化云进行添加，联系电话：4000182346*8002。</a></li>
        </ul>
        <div class="subNav" id="fail3">活动主题是什么？</div>
        <ul class="navContent">
            <li><a href="#">1、关于活动介绍的热词或者宣传语；</a></li>
            <li><a href="#">2、最多7个字符。</a></li>
        </ul>
        <div class="subNav" id="fail4">为什么我的日期一直选择不成功？</div>
        <ul class="navContent">
            <li><a href="#">只能选择当日级以后的日期。</a></li>
        </ul>
        <div class="subNav" id="fail5">如何添加地图坐标？</div>
        <ul class="navContent">
            <li><a href="#">输入地址后，鼠标变成“小手掌”时，即可点击，抓取坐标。</a></li>
        </ul>
        <div class="subNav" id="fail6">如何选择票务类型？</div>
        <ul class="navContent">
            <li><a href="#">1、选择“不可预订”，代表本活动不需要预约，可直接前往，前台将显示“直接前往”的字样；</a></li>
            <li><a href="#">2、选择“自由入座”，填写每场可预订票数即可，前台将显示“在线预订”的字样；</a></li>
            <li><a href="#">3、选择“在线选座”，添加座位模板即可。前台将显示“在线预订”的字样。</a></li>
        </ul>
    </div>
</div>
</body>
</html>