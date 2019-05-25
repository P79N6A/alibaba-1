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
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
    <!--移动端版本兼容 end -->
</head>
<!-- 导入头部文件 -->
<%@include file="/WEB-INF/why/index/index_top.jsp"%>
<body class="body">
<!--partner start-->
<div id="partner">
    <div id="p_tit">我的位置：<a >首页</a>><a >合作伙伴</a></div>
    <div class="p_con">
        <!--logo start-->
        <div class="pic">
        </div>
        <!--logo end-->
        <!--link start-->
        <div class="link">
            <a href="http://wgj.sh.gov.cn/node2/n2029/n2033/index.html" target="_blank">上海市文化广播影视管理局</a>
            <a href="http://www.shqyg.com/" target="_blank">上海市群众艺术馆 </a>
            <a href="http://www.shculturesquare.com/" target="_blank">上海文化广场</a>
            <a href="http://www.shoac.com.cn/" target="_blank">上海东方艺术中心</a>
            <a href="http://www.shgtheatre.com/" target="_blank">上海大剧院</a>
            <a href="http://www.china-drama.com/" target="_blank">上海话剧艺术中心 </a>
            <a href="http://www.rockbundartmuseum.org/cn/" target="_blank">上海外滩美术馆</a>
            <a href="http://www.snhm.org.cn/" target="_blank">上海自然博物馆</a>
            <a target="_blank" href="http://www.jdlib.com/">嘉定区图书馆</a>
            <a target="_blank" href="http://www.pdlib.com/">浦东图书馆 </a>
            <a target="_blank" href="http://www.library.sh.cn/">上海图书馆</a>

        </div>
        <!--link end-->
    </div>
</div>
<!-- 导入尾部文件 -->
<%@include file="/WEB-INF/why/index/index_foot.jsp"%>
<script>
    function outLogin(){var a="${sessionScope.terminalUser}";if(a){$.post("${path}/frontTerminalUser/outLogin.do?asm="+new Date().getTime(),function(b){window.location.reload(true)})}else{window.location.reload(true)}};
    function feedBack(){
        if('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == ""){
            dialogAlert("提示","登录之后才能反馈！");
            return;

        }
        window.location.href="${path}/frontIndex/feedBack.do";

    }
    var _hmt = _hmt || [];
    (function() {
        var hm = document.createElement("script");
        hm.src = "//hm.baidu.com/hm.js?eec797acd6a9a249946ec421c96aafeb";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
<!--feet end-->
<a style="visibility: hidden"><img alt="文化云"src="${path}/STATIC/image/baiduLogo.png" width="121" height="75" /></a>
</body>
</html>