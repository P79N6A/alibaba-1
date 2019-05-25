<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<link rel="stylesheet" type="text/css" href="/STATIC/css/normalize.css">

<script type="text/javascript" src="/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="http://m.wenhuayun.cn/STATIC/wechat/js/wechat-util.js"></script>
<script type="text/javascript" src="/STATIC/wechat/js/jweixin-1.0.0.js"></script>

<script src="${path}/STATIC/js/common.js"></script>
<script type="text/javascript" src="/stat/stat.js"></script>

<title>${ActivityTopic.title}</title>

<script>

    var appShareTitle = '';
    var appShareDesc = '';
    var appShareImgUrl = '';
    var appShareLink = '';

    if (window.injs){
        appShareImgUrl = "${IMGURL}${ActivityTopic.shareimg}";
        appShareTitle = "${ActivityTopic.sharetitle}";
        appShareDesc =  "${ActivityTopic.sharedesc}";
        injs.setAppShareButtonStatus(true);
    }

    if(is_weixin()){
        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '${WCHATSIGN.appId}', // 必填，公众号的唯一标识
            timestamp: '${WCHATSIGN.timestamp}', // 必填，生成签名的时间戳
            nonceStr: '${WCHATSIGN.nonceStr}', // 必填，生成签名的随机串
            signature: '${WCHATSIGN.signature}',// 必填，签名，见附录1
            jsApiList: ['onMenuShareTimeline','onMenuShareAppMessage','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
        });
        wx.ready(function(){
            var   durl = "${WCHATSIGN.url}";
            var     url = '${WCHATSIGN.url}';
            var  imgurl = "${IMGURL}${ActivityTopic.shareimg}";
            var  title = "${ActivityTopic.sharetitle}";
            var  desc = "${ActivityTopic.sharedesc}";
            wx.onMenuShareTimeline({
                title: title, // 分享标题
                link: url, // 分享链接
                imgUrl: imgurl // 分享图标
            });


            wx.onMenuShareAppMessage({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl, // 分享图标
                type: 'link', // 分享类型,music、video或link，不填默认为link
                dataUrl: '' // 如果type是music或video，则要提供数据链接，默认为空
            });

            wx.onMenuShareQQ({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl // 分享图标
            });

            wx.onMenuShareWeibo({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl // 分享图标
            });

            wx.onMenuShareQZone({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl // 分享图标
            });

        });
    }
</script>

<script type="text/javascript">
    var phoneWidth = parseInt(window.screen.width);
    var phoneScale = phoneWidth / 750;
    var ua = navigator.userAgent; //浏览器类型
    if(/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
        var version = parseFloat(RegExp.$1); //安卓系统的版本号
        if(version > 2.3) {
            document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
        } else {
            document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
        }
    } else {
        document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
    }
</script>

<script>
    $(function() {
        
    })
</script>

<style>
	html,body {padding: 0;margin: 0;height: 100%;}
	.fenmian_yindy {width: 753px;height: 100%;position: fixed;top: 0;right: 0;bottom: 0;left: -3px;margin: auto;z-index: 100;}
    .fenmian_yindy img {vertical-align: middle;width: 100%;height: 100%;display:block;}
    .fenmian_yindy .btn {width: 285px;height: 98px;background: url(/STATIC/activityTopic/image/btn1.png) no-repeat;position: absolute;left: 50%;margin-left: -143px; top: 455px;z-index: 2;}
    .fenmian_yindy .btn .nb {width: 255px;height: 81px;background: url(/STATIC/activityTopic/image/btn2.png) no-repeat;position: absolute;left: 50%;top: -12px;margin-left: -128px;
        -webkit-animation:btnMove 1s ease-in 0.3s infinite;-moz-animation:btnMove 1s ease-in 0.3s infinite;-o-animation:btnMove 1s ease-in 0.3s infinite;animation:btnMove 1s ease-in 0.3s infinite;
    }

    @-webkit-keyframes btnMove{
        0% {transform:translate(0, 0);}
        50% {transform:translate(0, 3px);}
        0% {transform:translate(0, 0);}
    }
    @-moz-keyframes btnMove{
        0% {transform:translate(0, 0);}
        50% {transform:translate(0, 3px);}
        0% {transform:translate(0, 0);}
    }
    @-o-keyframes btnMove{
        0% {transform:translate(0, 0);}
        50% {transform:translate(0, 3px);}
        0% {transform:translate(0, 0);}
    }
    @keyframes btnMove{
        0% {transform:translate(0, 0);}
        50% {transform:translate(0, 3px);}
        0% {transform:translate(0, 0);}
    }

    #particles-js {
      position: fixed;
      width: 100%;
      height: 100%;
      z-index: 101;
    }
</style>

<body>
	<div class="fenmian_yindy">
	    <img src="/STATIC/activityTopic/image/fengmian.jpg">
	    <div class="btn"><div class="nb"></div></div>
	</div>
	<div id="particles-js" onclick="window.location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=41'"></div>
</body>

<script src="/STATIC/activityTopic/js/particles.min.js"></script>
<script src="/STATIC/activityTopic/js/fengmian.js"></script>

</html>