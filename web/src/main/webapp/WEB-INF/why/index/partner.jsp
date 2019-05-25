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
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
    <!--移动端版本兼容 end -->
</head>
<!-- 导入头部文件 -->
<div class="header">
	<%@include file="/WEB-INF/why/index/header.jsp" %>
</div>
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
            <a href="http://wx.asohui.com/app/index.php?i=11&c=home&t=14&from=groupmessage" target="_blank">中共佛山市委宣传部</a>
            <a href="http://mp.weixin.qq.com/s/HAf46CpL4pRHD5mLQN7DJg" target="_blank">视听佛山 </a>
            <a href="https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MzAwMzgyNTIyMw==&scene=124#wechat_redirect" target="_blank">佛山妇联</a>
            <a href="http://www.lnbptour.cn/" target="_blank">旅游局</a>
        </div>
        <!--link end-->
    </div>
</div>
<!-- 导入尾部文件 -->
<%@include file="/WEB-INF/why/index/footer.jsp" %>
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