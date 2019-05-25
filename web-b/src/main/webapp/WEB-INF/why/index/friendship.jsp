<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%--<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>--%>
<%--<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>--%>
<%@ page language="java" pageEncoding="UTF-8" %>
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
<div id="fr_link">
    <div id="p_tit">我的位置：<a>首页</a>><a >友情链接</a></div>
    <!--list start-->
    <div class="fl_con clearfix">
        <!--left start-->
        <div class="l_menu fl">
            <h3>本站LOGO</h3>
            <div class="logos clearfix">
                <a class="logo_l">
                    <img src="/STATIC/image/f_logod.jpg" width="120" height="110"/>
                    <span>大小：120*110</span>
                </a>
                <a class="logo_r">
                    <img src="/STATIC/image/f_logos.png" width="75" height="70" />
                    <span>大小：75*70</span>
                </a>
            </div>
            <div class="code">
                <h6>LOGO链接代码</h6>
           <textarea><a href="http://www.wenhuayun.cn/" title="文化云"　target="_blank"><img src="http://www.wenhuayun.cn/STATIC/image/f_logod.jpg"　border="0" title="******" /></a>
           </textarea>
            </div>
            <div class="code">
                <h6>文字链接代码</h6>
           <textarea><a href="http://www.wenhuayun.cn/" title="文化云"　target="_blank">文化云</a>
           </textarea>
            </div>
            <!--font start-->
            <div class="font">
                <p>联系邮箱：service@sun3d.com</p>
                <p>链接地址：http://www.wenhuayun.cn/</p>
                <p>链接要求：</p>
                <p>1. 违反我国现行法律的或含有令人不愉快内容的网站勿扰；</p>
                <p>2. 友情链接网站之间有义务向对方报告链接失效，图片更新等问题，在解除友情链接之前亦应该通知对方；</p>
                <p>3. 以上各项，文化云保留全部解释权。</p>
            </div>
            <!--font end-->
        </div>
        <!--left end-->
        <div class="r_d fl">
            <div class="top">
            </div>
            <!--boTATIC/ttom start-->
            <div class="bottom">
                <div class="bl fl">
                    <a target="_blank" href="http://wgj.sh.gov.cn/node2/n2029/n2033/index.html">上海市文化广播影视管理局</a>
                    <a target="_blank" href="http://www.shqyg.com/">上海市群众艺术馆 </a>
                    <a target="_blank" href="http://www.shculturesquare.com/">上海文化广场</a>
                    <a target="_blank" href="http://www.jdlib.com/">嘉定区图书馆</a>
                </div>
                <div class="bc fl">
                    <a target="_blank" href="http://www.shoac.com.cn/">上海东方艺术中心</a>
                    <a target="_blank" href="http://www.shgtheatre.com/">上海大剧院</a>
                    <a target="_blank" href="http://www.china-drama.com/">上海话剧艺术中心 </a>
                    <a target="_blank" href="http://www.pdlib.com/">浦东图书馆 </a>
                </div>
                <div class="br fl">
                    <a target="_blank" href="http://www.rockbundartmuseum.org/cn/">上海外滩美术馆</a>
                    <a target="_blank" href="http://www.library.sh.cn/">上海图书馆</a>
                    <a target="_blank" href="http://www.snhm.org.cn/">上海自然博物馆</a>
                </div>
            </div>
            <!--bottom end-->
        </div>
    </div>
    <!--list end-->
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

