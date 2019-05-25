<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·音乐中的真善美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?v=20161021"/>
	<script src="${path}/STATIC/js/common.js"></script>
	<style>
		html,
		body {
			height: 100%;
		}
		
		.musicMain {
			width: 750px;
			margin: auto;
			min-height: 100%;
			background-color: #eeeeee;
		}
	</style>
	<script>
		$(function() {

			//菜单标签按钮点击事件
			$(".musicMenuBtn").on("click", function() {
				
				var indexTag=$(this).attr("indexTag");
				
				if(indexTag==1){
					
					window.location.href = '${path}/wechatStatic/musicIndex.do?indexTag=1';
				}
				
			})
			
			$(".myBtn").on("click",function(e){
				
				if (userId == null || userId == '') {
					publicLogin("${basePath}wechatStatic/myMusicIndex.do?indexTag="+indexTag);
				}
				else{
					 window.location.href='${basePath}wechatStatic/myMusicIndex.do?indexTag='+indexTag
				}
			})
			
			$(".rankingBtn").on("click",function(e){
				
				 window.location.href='${basePath}wechatStatic/musicRanking.do?userId='+userId
			})
			
			$(".ruleBtn").on("click",function(e){
				
				 window.location.href='${basePath}wechatStatic/musicRule.do'
			})

		})
	</script>
</head>

		<body>
		
		<div class="musicMain">
			<!--头图-->
			<div class="musicBanner">
				<img src="${path}/STATIC/wechat/image/musicZSM/banner.jpg" />
				<div class="myBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/myBtn.png" />
				</div>
				 <div class="rankingBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/rankingBtn.png" />
				</div>
				<div class="ruleBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/ruleBtn.png" />
				</div> 
			</div>

			<!--菜单-->
			<div class="musicMenu clearfix">
				<div class="musicWeiping musicRightLine" onclick="window.location.href='${basePath}wechatStatic/musicIndex.do?indexTag=1'">
					<div class="musicMenuBtn" >主&emsp;页</div>
				</div>
				<div class="musicZhengwen">
					<div class="musicMenuBtn musicMenuOn">规&emsp;则</div>
				</div>
			</div>

			<div class="content musicFontList">
				<div class="musicRuleDiv" style="max-height: 999999px;">

					<div class="musicRuleTitle">#&emsp;撰写内容&emsp;#</div>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;">以“音乐中的真善美”为主题，参与本届（第34届）上海之春国际音乐节所有参演节目、节中节以及艺术教育展演等活动，从自我为视角撰写对音乐节的所思所想所感，体裁不限。可以评论作品本身，也可以描写你与音乐关系和感受。</p>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;参加对象&emsp;#</div>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;">凡在上海市常住的市民均可参加，不限年龄和国籍。</p>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;写作要求&emsp;#</div>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;">本次征文分为<span style="color:#c63633">征文</span>和<span style="color:#c63633">微评</span>两类。稿件必须为个人原创，尚未出版及公开发表，思想健康，文笔流畅，富有真情实感。</p>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;">字数要求</p>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>征文：600字~1500字</p>
						</li>
						<li class="clearfix">
							<p>2</p>
							<p>微评：140字以内</p>
						</li>
					</ul>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;参加方式&emsp;#</div>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;"><strong>（1）如何参与：</strong></p>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>请投稿市民于即日起至2017年5月20日截止，通过安康文化云（包含APP、官方网页及微信公众号）进入活动页面，填写报名资料并提交投稿作品。</p>
						</li>
						<li class="clearfix">
							<p>2</p>
							<p>微评和征文可以同时投稿，征文限制每人可投稿3篇；微评篇数不限制。注意留下个人信息予以核对。（个人信息包括：作者真实姓名+联系手机+常用邮箱或QQ）。一旦投稿将默认授权主办单位刊发出版（非营利）征文的相关著作的使用权。</p>
						</li>
						<li class="clearfix">
							<p>3.</p>
							<p>您的作品需要符合活动主题，言之有物，不违反国家法律法规， 主办方有权对不合规作品做删除处理。</p>
						</li>
					</ul>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;"><strong>（2）如何评选：</strong></p>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>征文活动由专家评委进行投票评选。参与长征文的市民最终将评选出10篇“市民征文佳作”。</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>参与微评论的市民，将通过市民在线投票的方式，评出20位“市民优秀微评人”。投票市民登录安康文化云后可对微评作品进行投票，每人每日可对多名用户投一次票。为保证活动的公正性，活动主办方禁止任何形式的刷票行为，一经查实，有权删除违规文稿。</p>
						</li>
					</ul>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;"><strong>（3）时间安排：</strong></p>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>投稿时间：2017年4月28日至2017年5月20日截止（5月20日24点关闭线上投稿通道）</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>投票时间：2017年4月28日至2017年6月5日（6月5日24点关闭线上投票通道）</p>
						</li>
						<li class="clearfix">
							<p>3.</p>
							<p>评选时间：2017年6月中旬</p>
						</li>
						<li class="clearfix">
							<p>4.</p>
							<p>公布结果：2017年6月20日通过“文化云”官方微信公示获奖结果。</p>
						</li>
					</ul>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;奖项设置&emsp;#</div>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;">活动奖项分为征文和微评两类。</p>、
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;"><strong>（1）参与积分奖：</strong></p>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 20px;">文化云积分可用于在“文化云”平台上预订热门票务</p>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>投稿征文的用户即可获得1000文化云积分</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>投稿微评的用户即可获得500文化云积分（可以多次投稿微评，但积分只能获得一次哟）</p>
						</li>
					</ul>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;"><strong>（2）征文特别奖：</strong></p>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;">征文将由专家评委进行投票评选，最终将评选出10篇“市民征文佳作”，每人获得奖金1000元，同时作品也可刊登至《青年报》等社会媒体。</p>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;"><strong>（3）微评排名奖：</strong></p>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;">微评按照最终投票排名，选出投票最多前20名用户，获得“市民优秀微评人”称号，获得奖品奖励。</p>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>第1-3名：文化云特制音乐福袋（含上海地区两张文化活动的入场券，音乐会、话剧票、演出票随机发放）</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>第4-15名： 价值300元文化大礼包（含笔记本，纪念杯，上海手绘地图等）</p>
						</li>
						<li class="clearfix">
							<p>3.</p>
							<p>第16-20名：价值168元京东读书卡</p>
						</li>
						<li class="clearfix musicRuleTips">
							<p>*</p>
							<p>若一名用户多次投稿微评，投票排名仅计算该用户投票最高的作品。</p>
						</li>
					</ul>
					<p style="font-size: 26px;line-height:40px;padding:0 20px;margin-bottom: 30px;">主办方享有活动的最终解释权。</p>
				</div>

			</div>
		</div>
	</body>

</html>