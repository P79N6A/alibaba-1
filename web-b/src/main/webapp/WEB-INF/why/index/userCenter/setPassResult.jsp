<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>找回密码成功--文化云</title>
    <%--头部通用文件--%>
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
</head>
<body>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
    <div class="register-content">
        <div class="steps">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.验证手机<i class="tab_status"></i></li>
                <li class="step_2 visited_pre">2.设置新密码<i class="tab_status"></i></li>
                <li class="step_3 active">3.完成</li>
            </ul>
        </div>
        <div class="register-part part3">
            <div class="part3-box1">
                <div class="register-text">
                    <i></i>
                    <p style="font-size:30px;color:#252525">恭喜您，密码修改成功！</p>
                    <p class="f12"><a href="${path}/frontIndex/index.do" style="color: #CC0000">< 返回首页</a></p>
                </div>
            </div>
            <div class="part3-box2">
                <div class="bdsharebuttonbox">
                    <span>分享：</span>
                    <a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间"></a>
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