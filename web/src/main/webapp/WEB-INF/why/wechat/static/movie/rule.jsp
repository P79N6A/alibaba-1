<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·电影中的真善美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-movie.css" />
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
	<script type="text/javascript">
		$(function() {
			
			$.ajaxSettings.async = false; 	//同步执行ajax
			
			//跳转查看排名
			$(".rankingBtn").on("click",function(e){
				 window.location.href='${basePath}wechatStatic/movieRanking.do?userId='+userId
			});
			
			
			
			//微评和征文的切换
			$(".musicMenu").find("a").on("click",function(){
				if($(this).index() == 0){
					window.location.href='${path}/wechatStatic/movieIndex.do?indexTag=1';
					return false;
				}
			});
			
			
			
			$(".myBtn")[0].addEventListener('click',jumpToMy,false);
			//跳转到我的页面
			function jumpToMy(){
				if (userId == null || userId == '') {
					publicLogin('${basePath}wechatStatic/myMovieIndex.do?indexTag=1');
				}
				else{
					 window.location.href='${basePath}wechatStatic/myMovieIndex.do?indexTag=1';
				}
			}
			
			

		})
	</script>

	<body>

		<div class="musicMain">
			<!--头图-->
			<div class="musicBanner">
				<!-- 回到文化云 -->
				<a href="" class="gobackculture">
					回到文化云
				</a>
				<!-- 片单，资讯 -->
				<div class="message">
					<div class="message_child">
						<a href="http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=2280d976a13343ebbd48578e58614f60&from=singlemessage&isappinstalled=0"></a>
						<a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=0933bfca389245ff8ba9d80e430ff510"></a>
					</div>
				</div>
				<img src="${path}/STATIC/wxStatic/image/movieZSM/banner.jpg?20170609" />
				<div class="myBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/myBtn.png" />
				</div>
				<div class="rankingBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/rankingBtn.png" />
				</div>
				<div class="ruleBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/ruleBtn.png" />
				</div>
			</div>

			
			<!--菜单-->
			<div class="musicMenu clearfix">
				<a href="javascript:void(0)" >主&nbsp;页</a>
				<a href="javascript:void(0)" class="musicMenuOn">活动规则</a>
			</div>

			<div class="content musicFontList">
				<div class="musicRuleDiv" style="max-height: 999999px;">

					<div class="musicRuleTitle">#&emsp;活动背景&emsp;#</div>
					<div class="movieintroduce">
						作为全球15家非专门类竞赛型国际电影节之一，多年来，上海国际电影节以“关注亚洲、关注华语、关注新人”确立了自己的独特风格，成为最受观众追捧的电影节活动。
					</div>
					<div class="movieintroduce">
						在连续三年成功举办市民影评活动后，今年上海国际电影节再次和上海市民文化节牵手，推出“电影中的真善美”第20届上海国际电影节市民征文活动，以引导和激发市民在观赏电影的同时发现真善美，弘扬真善美，传播正能量。今年是上海国际电影节20届，从1993年创办以来，电影节相伴市民、相伴这座城市，在上海已家喻户晓、深入人心，所以，本次上海市民文化节“电影中的真善美”活动，<span>还特设“我与我的电影节”征文</span>，邀请广大市民用文字讲述与上海国际电影节的相识、相交与相知，抒发影迷们的电影情怀。电影节期间，将精选部分优秀作品，通过电影节微博、微信和官方刊物刊登。
					</div>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;活动奖励&emsp;#</div>
					<ul>
						<li class="clearfix">
							<p>A.</p>
							<p>以本届电影节展映的300多部电影为评论范围，围绕“真善美”撰写影评。</p>
						</li>
						<li class="clearfix">
							<p>B.</p>
							<p>也可以“我与我的电影节”为主题，从自我为视角撰写对20届的上海国际电影节的所思所想所感，以及自己的小故事，体裁不限。</p>
						</li>
					</ul>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;参赛对象&emsp;#</div>
					<div class="movieintroduce">
						凡在上海市常住的市民均可参加，不限年龄和国籍。
					</div>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;写作要求&emsp;#</div>
					<div class="movieintroduce">
						本次活动分为征文和微评两类。稿件必须为个人原创，尚未出版及公开发表，思想健康，文笔流畅，富有真情实感。
					</div>
					<div class="movieintroduce">
						字数要求
					</div>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>征文：600字~2000字</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>微评： 140字以内</p>
						</li>
					</ul>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;参与方式&emsp;#</div>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>请投稿市民于即日起至2017年7月17日截止，通过安康文化云（包含APP、官方网页及微信公众号）进入活动页面，填写报名资料并提交投稿作品。</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>微评和征文可以同时投稿，征文限制每人每个主题可投稿3篇(所评电影不可重复)；微评篇数不限制。注意留下个人信息予以核对。（个人信息包括：作者真实姓名+联系手机+本职工作+常用邮箱或QQ）。一旦投稿将默认授权主办单位刊发出版（非营利）征文的相关著作的使用权。</p>
						</li>
						<li class="clearfix">
							<p>3.</p>
							<p>您的作品需要符合活动主题，言之有物，不违反国家法律法规。</p>
						</li>
						<li class="clearfix">
							<p>4.</p>
							<p>主办方有权对不符合活动规则、违反国家法律法规的作品做删除处理。</p>
						</li>
					</ul>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;奖项设置&emsp;#</div>
					 <ul>
						<li class="clearfix">
							<p>1.</p>
							<p>征文</p>
							<div class="introdiv">
								征文由专家评委进行投票评选，最终将评选出20篇“市民征文佳作”。
							</div>
						</li>
						<li class="clearfix">
							<p><span class="point"></span></p>
							<p>参与积分奖：</p>
							<div class="introdiv">
								投稿征文的用户即可获得1000文化云积分。
							</div>
						</li>
						<li class="clearfix">
							<p><span class="point"></span></p>
							<p>征文特别奖：</p>
							<div class="introdiv">
								征文将由专家评委进行投票评选，最终将评选出20篇“市民征文佳作”，每人将得到奖金1000元。
							</div>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>微评</p>
							<div class="introdiv">
								参与微评的市民将进行网络点赞投票评选，按照最终投票排名，选出投票最多前20名用户，获得“妙语连珠市民”称号。投票市民登录安康文化云后可对微评作品进行投票，每人每日可对多名用户投一次票。为保证活动的公正性，活动主办方禁止任何形式的刷票行为，一经查实，有权删除违规文稿，取消参赛资格。
							</div>
						</li>
						<li class="clearfix">
							<p><span class="point"></span></p>
							<p>参与积分奖：</p>
							<div class="introdiv">
								投稿微评的用户即可获得500文化云积分（可以多次投稿微评，但积分只能获得一次哟）。
							</div>
						</li>
						<li class="clearfix">
							<p><span class="point"></span></p>
							<p>微评排名奖：</p>
							<div class="introdiv">
								微评按照最终投票排名，选出投票最多前20名用户，获得“妙语连珠市民”称号，获得奖品奖励。
							</div>
						</li>
						<li class="clearfix">
							<p>1.</p>
							<p>第1-3名：文化云特制福袋（含上海地区两张文化活动的入场券，音乐会、话剧票、演出票随机发放）</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>第4-15名： 价值300元文化大礼包（含笔记本，纪念杯，上海手绘地图等）</p>
						</li>
						<li class="clearfix">
							<p>3.</p>
							<p>价值168元京东读书卡</p>
						</li>
						<li class="clearfix musicRuleTips">
							<p>*</p>
							<p>若一名用户多次投稿微评，投票排名仅计算该用户投票最高的作品。</p>
						</li>
					</ul>
					<div class="musicRuleTitle" style="border-top: 1px solid #eeeeee;">#&emsp;时间安排&emsp;#</div>
					<ul>
						<li class="clearfix">
							<p>1.</p>
							<p>投稿时间：即日至2017年7月17日截止（7月17日24点关闭线上投稿通道）</p>
						</li>
						<li class="clearfix">
							<p>2.</p>
							<p>微评投票时间： 即日至2017年8月14日截止</p>
						</li>
						<li class="clearfix">
							<p>3.</p>
							<p>征文评选时间： 即日至2017年8月中旬</p>
						</li>
						<li class="clearfix">
							<p>4.</p>
							<p>公布结果：2017年8月30日通过“文化云”官方微信公示获奖结果。</p>
						</li>
					</ul>
				</div>

			</div>
		</div>
	</body>

</html>