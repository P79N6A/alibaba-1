<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>文化云_联系我们-文化引领品质生活</title>
    <meta name="description" content="文化云客服热线400-018-2346/商务合作business@sun3d.com">
    <meta name="Keywords" content="文化云、联系电话、联系、客户服务">
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <!--移动端版本兼容 end -->
    <script type="text/javascript">
        var phoneWidth =  parseInt(window.screen.width);
        var phoneScale = phoneWidth/1200;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if(version>2.3){
                document.write('<meta name="viewport" content="width=1200, minimum-scale = '+phoneScale+', maximum-scale = '+(phoneScale)+', target-densitydpi=device-dpi">');
            }else{
                document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
        }
    </script>
</head>
<body>
<!-- 导入头部文件 -->
<%@include file="../header.jsp" %>
<div id="p_tit">我的位置：<a >首页</a>><a >移动文化云</a></div>
<div id="Mob_phone" class="clearfix">
    <!--left start-->
    <div class="mp_l fl">
        <!--切换start-->
        <!--left start-->
        <div id="banner-phone" class="fl">
            <div class="phone-ban">
                <ul class="in-ban-img">
                    <li><a ><img src="/STATIC/image/phone2.png" width="277" height="471"/></a></li>
                    <%--<li><a ><img src="/STATIC/image/scroll_phone.png" width="277" height="471"/></a></li>--%>
                </ul>
            </div>
            <script type="text/javascript">
                /*SuperSlide图片切换*/
                jQuery(".phone-ban").slide({ titCell:".in-ban-icon", mainCell:".in-ban-img",effect:"fold", autoPlay:true, autoPage:true, delayTime:300, trigger:"click"});
            </script>
        </div>
        <!--left end-->
        <!--切换end-->
    </div>
    <!--left end-->
    <!--right start-->
    <div class="mp_r fl">
        <div id="Swep" class="clearfix">
            <div class="s_img fl" target="_blank" href="http://www.wenhuayun.cn/appdownload/index.html"><img src="/STATIC/image/why_ss.png" width="151" height="152"></div>
            <div class="s_app fl">
                <a class="ios" target="_blank" href="http://www.wenhuayun.cn/appdownload/index.html">IOS 下载</a>
                <a class="android" target="_blank" href="http://www.wenhuayun.cn/appdownload/index.html">安卓 下载</a>
            </div>
        </div>
    </div>
    <!--right end-->
</div>
<!--phone end-->

<%--<!-- 导入foot文件 start -->--%>
<%@include file="/WEB-INF/why/index/footer.jsp"%>
<!--feet start-->


<script>
    function outLogin(){var a="${sessionScope.terminalUser}";if(a){$.post("${path}/frontTerminalUser/outLogin.do?asm="+new Date().getTime(),function(b){window.location.reload(true)})}else{window.location.reload(true)}};
    function feedBack(){
        if('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == ""){
            dialogAlert("提示","登录之后才能反馈！");
            return;

        }
        window.location.href="${path}/frontIndex/feedBack.do";

    }
</script>

<script>
    var _hmt = _hmt || [];
    (function() {
        var hm = document.createElement("script");
        hm.src = "//hm.baidu.com/hm.js?eec797acd6a9a249946ec421c96aafeb";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
<!--feet end-->
</body>
</html>