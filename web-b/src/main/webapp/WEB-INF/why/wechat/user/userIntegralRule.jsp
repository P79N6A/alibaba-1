<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>用户积分规则</title> -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<script>
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
			<c:if test="${type!='app'}">
				<div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
					</span>
					<span class="index-top-2">积分规则</span>
				</div>
			</c:if>
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
		<div class="content padding-bottom0">
			<c:if test="${type!='app'}">
				<script>
					$(".content").addClass("margin-top230");
				</script>
			</c:if>
			<c:if test="${type=='app'}">
				<script>
					$(".content").addClass("margin-top100");
				</script>
			</c:if>
			<div class="point-rule-tab2 c262626">
				<p>文化引领品质生活</p>
				<p>文化云是一款聚焦文化领域，提供公众文化生活和消费的互联网平台；目前已汇聚全上海22万场文化活动、5500余文化场馆，上万家文化社团，为公众提供便捷和有品质的文化生活服务。</p>
				<p>您可以通过以下方式访问文化云，获得免费公益文化活动机会。</p>
				<div class="waytoapp margin-bottom50">
					<ul>
						<c:if test="${type!='app'}">
							<li class="border-bottom">
								<p class="f-left">文化云APP</p>
								<div class="f-left waytoapp-botton bg7279a0">
									<p class="cfff w170" onclick="location.href='http://www.wenhuayun.cn/appdownload/index.html'">下载APP</p>
								</div>
								<div style="clear: both;"></div>
							</li>
							<li class="border-bottom">
								<p class="f-left">访问微官网</p>
								<div class="f-left waytoapp-botton bg7279a0">
									<p class="cfff" onclick="location.href='${path}/wechat/index.do'">点击进入微官网</p>
								</div>
								<div style="clear: both;"></div>
							</li>
						</c:if>
						<li class="border-bottom">
							<p class="f-left" style="margin-top:25px">关注微信号</p>
							<div class="f-left waytoapp-botton" style="margin-left:60px">
								<p style="width:385px">（请打开微信搜索公众号“文化云”，点击关注）</p>
							</div>
							<div style="clear: both;"></div>
						</li>
					</ul>
				</div>
				<p>想要预定热门免费公益的文化活动，您必须是我们的认证会员：</p>
				<p>无论您是在PC端、微信端、亦或是APP端发现文化云，只需用手机号码注册，就能成为我们的会员。</p>
			</div>
			<div class="point-rule-tab2 c262626" style="display: none;">
				<p>一旦您成为了文化云的会员，我们会竭尽全力为您奉上最新鲜、最热门的城市文化活动服务，权益包括但不限于：会员礼遇、会员积分、会员活动、异业合作。</p>
				<p class="c7485b7">在文化云，您会发现更多高品质的生活，专享会员权益、便捷会员服务、丰富会员活动等你来体验！</p>
				<p class="border-bottom fsbold margin-bottom20 padding-bottom20">会员权益之积分</p>
				<table class="point-rule-tab">
					<tbody>
						<tr>
							<th class="bg666 cfff" colspan="4" style="line-height: 70px;">积分的获得</th>
						</tr>
						<tr>
							<td class="bg7279a0 cfff" rowspan="5" width="80px" style="text-align: center;">动作</td>
							<td class="bg7279a0 cfff" style="text-align: center;" width="180">项目</td>
							<td class="bg7279a0 cfff" width="80px" style="text-align: center;">分值</td>
							<td class="bg7279a0 cfff" style="text-align: center;">规则</td>
						</tr>
						<tr>
							<td>首次注册</td>
							<td>200</td>
							<td>一次性</td>
						</tr>
						<tr>
							<td>评论一个</td>
							<td>5</td>
							<td>每日100封顶；删除评论后相应积分扣除</td>
						</tr>
						<tr>
							<td>转发一次</td>
							<td>10</td>
							<td>每日转发同一页面只计算一次；每日100封顶</td>
						</tr>
						<tr>
							<td>预约活动核销成功</td>
							<td>50</td>
							<td></td>
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
							<td>文化云致力于为市民提供免费公益的文化活动，因活动热门，资源紧张，部分活动成功预订如果未及时到场，回扣一定的积分作为惩罚（活动内容上会有提示）；如果因个人原因实在不能及时赶到，在活动开始前取消订单将不做惩罚。</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>