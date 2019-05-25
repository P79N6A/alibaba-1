<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>积分规则</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云-积分规则';
	    	appShareDesc = '拿佛山文化云积分，免费预订乐山公共文化活动，更多精彩活动等您来！';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	
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
	                title: "佛山文化云-积分规则",
	                desc: '拿佛山文化云积分，免费预订乐山公共文化活动，更多精彩活动等您来！',
	                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	            });
	            wx.onMenuShareTimeline({
	                title: "拿佛山文化云积分，免费预订乐山公共文化活动，更多精彩活动等您来！",
	                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	            });
	            wx.onMenuShareQQ({
	            	title: "佛山文化云-积分规则",
	            	desc: '拿佛山文化云积分，免费预订乐山公共文化活动，更多精彩活动等您来！',
	                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	            });
	            wx.onMenuShareWeibo({
	            	title: "佛山文化云-积分规则",
	            	desc: '拿佛山文化云积分，免费预订乐山公共文化活动，更多精彩活动等您来！',
	                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	            });
	            wx.onMenuShareQZone({
	            	title: "佛山文化云-积分规则",
	            	desc: '拿佛山文化云积分，免费预订乐山公共文化活动，更多精彩活动等您来！',
	                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	            });
	        });
	    
	    };
    
	
		$(document).ready(function() {
			$('.point-rule-tab1').click(function() {
				$('.point-rule-tab1>p').removeClass("border-bottom4").removeClass("c5e6d98").removeClass("fsbold")
				$(this).find("p").addClass("border-bottom4").addClass("c5e6d98").addClass("fsbold")
				var content = $('.point-rule-tab2');
				var num = $(this).index();
				content.css('display', 'none');
				content.eq(num).css('display', 'block');
			})
		})
	</script>
</head>
<body>
	<div class="main">
		<div class="header">
			<%-- <div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
				</span>
				<span class="index-top-2">积分规则</span>
			</div> --%>
			<div class="point-rule">
				<div class="f-left point-rule-tab1">
					<p class="fs30 border-bottom4 c5e6d98 fsbold">成为会员</p>
				</div>
				<div class="f-right point-rule-tab1">
					<p class="fs30">会员权益</p>
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
		<div class="content padding-bottom0 margin-top100">
			<div class="point-rule-tab2 c262626">
				<p>文化引领品质生活</p>
				<p>佛山文化云是一款聚焦公共文化服务领域，提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。</p>
				<c:if test="${type!='app'}">
					<p>您可以通过以下方式访问佛山文化云，获得免费公益文化活动机会。</p>
					<div class="waytoapp margin-bottom50">
						<ul>
							<%-- <li class="border-bottom">
								<p class="f-left">佛山文化云APP</p>
								<div class="f-left waytoapp-botton bg7279a0">
									<p class="cfff w170" onclick="location.href='${path}/appdownload/index.html'">下载APP</p>
								</div>
								<div style="clear: both;"></div>
							</li> --%>
							<li class="border-bottom">
								<p class="f-left">访问微官网</p>
								<div class="f-left waytoapp-botton bg7279a0">
									<p class="cfff" onclick="location.href='${path}/wechat/index.do'">点击进入微官网</p>
								</div>
								<div style="clear: both;"></div>
							</li>
						</ul>
					</div>
				</c:if>
				<p>想要预定热门免费公益的文化活动，您必须是我们的认证会员：</p>
				<p>无论您是在PC端、微信端、亦或是APP端发现佛山文化云，只需用手机号码注册，就能成为我们的会员。</p>
			</div>
			<div class="point-rule-tab2 c262626" style="display: none;">
				<p>一旦您成为了佛山文化云的会员，我们会竭尽全力为您奉上最新鲜、最热门的城市文化活动服务，权益包括但不限于：会员礼遇、会员积分、会员活动、异业合作。</p>
				<p class="c7485b7">在佛山文化云，您会发现更多高品质的生活，专享会员权益、便捷会员服务、丰富会员活动等你来体验！</p>
				<p class="fsbold margin-bottom20">会员权益之积分</p>
				<p class="border-bottom margin-bottom20 padding-bottom20" style="color:#7c7c7c;font-size: 20px">*积分系统为测试版本，仅适用于手机访问用户，使用PC访问操作暂不享受。</p>
				<table class="point-rule-tab">
					<tbody>
						<tr>
							<th class="bg666 cfff" colspan="4" style="line-height: 70px;">积分的获得</th>
						</tr>
						<tr>
							<td class="bg7279a0 cfff" rowspan="7" width="80px" style="text-align: center;">动作</td>
							<td class="bg7279a0 cfff" style="text-align: center;" width="180">项目</td>
							<td class="bg7279a0 cfff" width="80px" style="text-align: center;">分值</td>
							<td class="bg7279a0 cfff" style="text-align: center;">规则</td>
						</tr>
						<tr>
							<td>首次注册</td>
							<td>1200</td>
							<td>一次性</td>
						</tr>
						<tr>
							<td>评论一个</td>
							<td>5</td>
							<td>每日100封顶；删除评论后相应积分扣除</td>
						</tr>
						<tr>
							<td>转发一次活动或场馆</td>
							<td>10</td>
							<td>每日转发同一页面只计算一次；每日100封顶</td>
						</tr>
						<tr>
							<td>预约活动核销成功</td>
							<td>50</td>
							<td></td>
						</tr>
						<tr>
							<td>文化直播点赞</td>
							<td>5</td>
							<td>累计，单日100封顶</td>
						</tr>
						<tr>
							<td>文化直播评论</td>
							<td>5</td>
							<td>评论+5分，带图评论+100分，单日500分封顶；删除后扣除</td>
						</tr>
						<tr>
							<td class="bg7279a0 cfff" rowspan="2" width="80px">奖励</td>
							<td>每日打开</td>
							<td>10</td>
							<td>一次性</td>
						</tr>
						<tr>
							<td>自然周内打开过3次及以上</td>
							<td>50</td>
							<td>每周一次，次数可以不连续</td>
						</tr>
					</tbody>
				</table>
				<table class="point-rule-tab margin-bottom50" style="margin-top: 50px;">
					<tbody>
						<tr>
							<th class="bg666 cfff" colspan="4" style="line-height: 70px;">积分的使用</th>
						</tr>
						<tr>
							<td class="bg7279a0 cfff" rowspan="2" width="80px" style="text-align: center;">使用</td>
							<td class="bg7279a0 cfff" style="text-align: center;" width="180">项目</td>
							<td class="bg7279a0 cfff" width="80px" style="text-align: center;">分值</td>
							<td class="bg7279a0 cfff" style="text-align: center;">规则</td>
						</tr>
						<tr>
							<td>支付订单</td>
							<td>根据活动而定</td>
							<td>部分热门活动需使用相应的积分做抵扣，您在预订活动时，需要支付相应的积分，积分不足时不可预订。如果您预定不成功或在活动开始前取消订单，积分可返还。</td>
						</tr>
						<tr>
							<td class="bg7279a0 cfff" rowspan="2" width="80px" style="text-align: center;">限制</td>
							<td>活动参与限制</td>
							<td>根据活动而定</td>
							<td>部分热门活动需当前积分高于已定的值，详见活动本身</td>
						</tr>
						<tr>
							<td>预定未核销</td>
							<td>根据活动而定</td>
							<td>佛山文化云致力于为市民提供免费公益的文化活动，因活动热门，资源紧张，部分活动成功预订如果未及时到场，回扣一定的积分作为惩罚（活动内容上会有提示）；如果因个人原因实在不能及时赶到，在活动开始前取消订单将不做惩罚。</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>