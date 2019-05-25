<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>注册成功--文化安康云</title>
<%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <script type="text/javascript">

        $(function(){

            var localUrl = top.location.href;
            var webPage = document.getElementById("webDiv");
            var appPage = document.getElementById("appDiv");

            if(localUrl.indexOf("collect_info.jsp") == -1){
                appPage.innerHTML = "";
                appPage.style.display = "none";

            }else{
                webPage.innerHTML = "";
                webPage.style.display = "none";

            }});
            </script>
</head>
<body>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
    <div class="register-content">
        <div class="steps">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.基本信息<i class="tab_status"></i></li>
                <li class="step_2 visited_pre">2.个性化设置<i class="tab_status"></i></li>
                <li class="step_3 active">3.注册成功</li>
            </ul>
        </div>
        <div class="register-part part3">
            <div class="part3-box1">
                <div class="box1a">
                    <a class="return" href="${path}/frontIndex/index.do">&lt;返回首页</a>
                    <a class="orange" href="${path}/frontTerminalUser/userInfo.do">完善个人资料&gt;</a>
                </div>
                <div class="register-text">
                    <img src="${path}/STATIC/image/transparent.gif">
                    <span>恭喜您，已注册成功！</span>
                </div>
            </div>
            <div class="part3-box2">
                <div class="bdsharebuttonbox">
                    <span>分享</span>
                    <a href="#" class="bds_sqq" data-cmd="sqq" title="分享到QQ好友"></a>
                    <a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博"></a>
                    <a href="#" class="bds_weixin" data-cmd="weixin" title="分享到微信"></a>
                </div>
                <script>
                    window._bd_share_config={
                        "common":{
                            "bdSnsKey":{},
                            "bdText":"",
                            "bdMini":"2",
                            "bdMiniList":false,
                            "bdPic":"",
                            "bdStyle":"0",
                            "bdSize":"16"
                        },
                        "share":{}
                    };
                    with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
                </script>
            </div>
        </div>
    </div>
</div>
<!--底部通用文件-->
<%@include file="../index_foot.jsp"%>
</body>
</html>