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
    <!--移动端版本兼容 end -->
    <style type="text/css">
        .body{background:#f5f5f5;width:100%;height:100%;}
        #links_tit{width:1160px; margin:0 auto;height:43px; line-height:43px; border:1px solid #eaeceb;padding-left:40px; background:#ffffff; margin-top:5px; color:#333333; font-size:12px; font-family:"微软雅黑";}
        #links_tit a{color:#333333; font-size:12px; font-family:"微软雅黑";}
        #links_con{width:1178px;margin:0 auto;margin-top:7px;background:#ffffff; padding:0px 10px 65px;border:1px solid #eaeceb;}
        #links_con ul li{width:1128px; border-bottom:1px solid #ebebeb;padding:35px 25px 27px;}
        #links_con ul li h3{color:#0e597f;font-size:18px;font-family:"微软雅黑";font-weight:normal;margin-bottom:25px;}
        #links_con ul li p{color:#333333;font-size:14px;font-family:"微软雅黑"; line-height:24px;}
        #links_con ul li span{display:block;margin-top:15px;color:#00b0ec;font-size:14px;font-family:"微软雅黑";}
        #links_con ul li img{display:block;margin-top:18px;}
        #links_con ul li:last-child{border-bottom:none;}
    </style>
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
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="links_tit">
    我的位置：<a href="${path}/frontIndex/index.do">首页</a> > <a href="#">联系我们</a>
</div>
<div id="links_con">
    <ul>
        <li>
            <h3>用户服务（需求建议、bug反馈，意见反馈，使用文化云过程中遇到问题咨询等）</h3>
            <p>客服热线：400-018-2346 </p>
                <%--（周一至周日 9:00-18:00）--%>
            <p>电子邮箱：service@sun3d.com</p>
            <span>您也可以通过微信客户端留言，我们将尽快回复您！</span>
            <img src="/STATIC/image/link_logo.png" width="158" height="158" />
        </li>
        <li>
            <h3>商务合作（如您有机构入驻，发布活动、发布场馆等需求）</h3>
            <p>请您联系：山小姐</p>
            <p>电子邮箱：business@sun3d.com</p>

        </li>
        <li>
            <h3>创图科技</h3>
            <p>公司名称：上海创图网络科技发展有限公司</p>
            <p>地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址：上海市广中西路777弄上海多媒体谷10号楼</p>
            <p>电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话：021-36696098</p>
            <p>邮&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;编：200072</p>
        </li>

    </ul>
</div>


<%--<!-- 导入foot文件 start -->--%>
<%@include file="/WEB-INF/why/index/index_foot.jsp"%>
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
<a style="visibility: hidden"><img alt="文化云"src="${path}/STATIC/image/baiduLogo.png" width="121" height="75" /></a>
</body>
</html>