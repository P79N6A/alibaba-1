<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>公共文化配送产品设计大赛</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
<style type="text/css">
html,body{height: 100%; width: 100%; background-color: #3c1d4c;}
</style>
<script type="text/javascript">
//分享是否隐藏
if(window.injs){
	//分享文案
	appShareTitle = '给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔';
	appShareDesc = '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动';
	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg';
	
	injs.setAppShareButtonStatus(true);
}

//判断是否是微信浏览器打开
if (is_weixin()) {
	//通过config接口注入权限验证配置
	wx.config({
		debug: false,
		appId: '${sign.appId}',
		timestamp: '${sign.timestamp}',
		nonceStr: '${sign.nonceStr}',
		signature: '${sign.signature}',
		jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
	});
	wx.ready(function () {
		wx.onMenuShareAppMessage({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			link: '${basePath}wechatDc/index.do?tab='+tab,
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
		wx.onMenuShareTimeline({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg',
			link: '${basePath}wechatDc/index.do?tab='+tab
		});
		wx.onMenuShareQQ({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
		wx.onMenuShareWeibo({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
		wx.onMenuShareQZone({
			title: "给喜欢的产品设计投票，为公共文化添上浓墨重彩的一笔",
			desc: '2016年上海市民文化节公共文化配送产品设计大赛市民投票活动',
			imgUrl: '${basePath}/STATIC/wxStatic/image/pszx/shareIcon.jpg'
		});
	});
}

$(function(){
	//分享
	$(".share-button").click(function() {
		if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
			dialogAlert('系统提示', '请用微信浏览器打开分享！');
		}else{
			$("html,body").addClass("bg-notouch");
			$(".background-fx").css("display", "block")
		}
	})
	$(".background-fx").click(function() {
		$("html,body").removeClass("bg-notouch");
		$(".background-fx").css("display", "none")
	})
    //关注
	$(".keep-button").on("touchstart", function() {
		$('.div-share').show()
		$("body,html").addClass("bg-notouch")
	})
	
})

</script>
</head>

<body>
<div class="div-share">
	<div class="share-bg"></div>
	<div class="share">
		<img src="${path}/STATIC/wechat/image/wx-er2.png" />
		<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
		<p>更多精彩活动、场馆等你发现</p>
		<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
	</div>
</div>
<div class="pszxMain">
    <div class="pszxBan">
        <img class="bg" src="${path }/STATIC/wxStatic/image/pszx/pic3.jpg">
        <div class="pszx_guanfx clearfix" style="top:25px;">
            <a href="javascript:;" class="keep-button">关注</a>
            <a href="javascript:;" class="share-button">分享</a>
        </div>
        <div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		    <img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
        </div>
        <div class="navIndex">
            <a class="a1" href="${path }/wechatQyg/index.do?guide=1&tab=0"></a>
            <a class="a2 current" href="${path }/wechatQyg/voteRule.do"></a>
            <a class="a3" href="${path }/wechatQyg/announcement.do"></a>
            <a class="a4" href="${path }/wechatQyg/toRanking.do"></a>
        </div>
    </div>
    <div class="pszxRank_wc">
        <div class="pszxRule">
            <div class="nc">
                <div class="tit"><span>#</span>&nbsp;&nbsp;&nbsp;&nbsp;活动规则&nbsp;&nbsp;&nbsp;&nbsp;<span>#</span></div>
                <div class="cont">
                    <div class="biao">活动简介</div>
                    <p>此活动是上海市民文化节公共文化配送产品设计大赛的市民投票环节。</p>
                </div>
                <div class="cont">
                    <div class="biao">大众投票日期</div>
                    <p>2017年  1月7日09:00—1月13日17:00</p>
                </div>
                <div class="cont">
                    <div class="biao">评比方式</div>
                    <p>1）由专家评审和大众投票两部分组成。</p>
                    <p>2）专家对节目打分占总得分的85%。</p>
                    <p>3）市民通过“文化云—市民投票通道”进行投票，投票数占总得分的15%。</p>
                    <p>4）大赛将评选出 “百强公共文化配送创新产品”，并颁发获奖证书、铜牌及产品画册。</p>
                </div>
                <div class="cont">
                    <div class="biao">投票方式</div>
                    <p>1）每个用户（同一ID）每天可以投多票，但对同一作品每天只能投一票；</p>
                    <p>2）实名制投票；</p>
                    <p>3）用户首次投票将有机会参与“文化云抽奖活动”，输入手机号码参与成功即进入抽奖数据库，活动将抽出10名幸运用户，每人获得“传统文化大礼包一份”；</p>
                    <p>4）中奖名单于2月10日在文化云微信公众平台上公布，请提前关注文化云官方微信公众号。</p>
                </div>
                <div class="cont">
                  <p>本活动禁止任何手段的恶意刷票或作弊行为，一经发现，取消活动资格及所获奖励。
                                                               此规则最终解释权归上海市群众艺术馆和文化云所有！
                   </p>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>