<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>海派小品 文脉虹口-小品专场演出</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '文化云邀请你来参加《海派小品  文脉虹口》小品专场演出';
	    	appShareDesc = '国家一级编剧俞志清领衔中国剧协上海（虹口）小戏小品基地倾情呈现';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/hongkouAct/hkShare.jpg';
	    	
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
					title: "文化云邀请你来参加《海派小品  文脉虹口》小品专场演出",
					desc: '国家一级编剧俞志清领衔中国剧协上海（虹口）小戏小品基地倾情呈现',
					imgUrl: '${basePath}/STATIC/wxStatic/image/hongkouAct/hkShare.jpg'
				});
				wx.onMenuShareTimeline({
					title: "文化云邀请你来参加《海派小品  文脉虹口》小品专场演出",
					imgUrl: '${basePath}/STATIC/wxStatic/image/hongkouAct/hkShare.jpg'
				});
				wx.onMenuShareQQ({
					title: "文化云邀请你来参加《海派小品  文脉虹口》小品专场演出",
					desc: '国家一级编剧俞志清领衔中国剧协上海（虹口）小戏小品基地倾情呈现',
					imgUrl: '${basePath}/STATIC/wxStatic/image/hongkouAct/hkShare.jpg'
				});
				wx.onMenuShareWeibo({
					title: "文化云邀请你来参加《海派小品  文脉虹口》小品专场演出",
					desc: '国家一级编剧俞志清领衔中国剧协上海（虹口）小戏小品基地倾情呈现',
					imgUrl: '${basePath}/STATIC/wxStatic/image/hongkouAct/hkShare.jpg'
				});
				wx.onMenuShareQZone({
					title: "文化云邀请你来参加《海派小品  文脉虹口》小品专场演出",
					desc: '国家一级编剧俞志清领衔中国剧协上海（虹口）小戏小品基地倾情呈现',
					imgUrl: '${basePath}/STATIC/wxStatic/image/hongkouAct/hkShare.jpg'
				});
			});
		}
		
		$(function () {
			
			$(".youthArtMonth>ul>li").click(function() {
				$(".youthArtMonth>ul>li").removeClass("monthBtLine")
				$(this).addClass("monthBtLine")
				$(this).index()
				$(".hkArtList>ul").hide()
				$(".hkArtList>ul").eq($(this).index()).show()
			})
			var dataLilen = $(".youthArtMonth>ul>li").length;
			var dataLiWidth = $(".youthArtMonth>ul>li").width() + 40;
			var dataUlWidth = dataLilen * dataLiWidth;
			$(".youthArtMonth>ul").css("width", dataUlWidth);
			
			$(".youthArtMonth").scrollLeft(650);
			
			//分享
			$(".shareBut").click(function() {
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
			
		});
		
	</script>
	
	<style>
		.youthArtList>ul {
			display: none;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/hongkouAct/hkShare.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="div-share">
		<div class="share-bg"></div>
		<div class="share">
			<img src="${path}/STATIC/wechat/image/wx-er2.png" />
			<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
			<p>更多精彩活动、场馆等你发现</p>
			<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
		</div>
	</div>
	<div class="youthArt">
		<div class="youthArtHead">
			<img src="${path}/STATIC/wxStatic/image/hongkouAct/banner.jpg" />
			<img class="shareBut" src="${path}/STATIC/wxStatic/image/hongkouAct/hkshare.png" style="position: absolute;right: 30px;top: 30px;" />
			<img class="keep-button" src="${path}/STATIC/wxStatic/image/hongkouAct/hkkeep.png" style="position: absolute;right: 120px;top: 30px;" />
		</div>
		<div class="youthArtMonth">
			<ul>
				<li>9/18</li>
				<li>9/25</li>
				<li>10/9</li>
				<li>10/16</li>
				<li>10/23</li>
				<li>10/30</li>
				<li>11/6</li>
				<li>11/13</li>
				<li>11/20</li>
				<li class="monthBtLine">11/27</li>
				<div style="clear: both;"></div>
			</ul>
		</div>
		<div class="hkArtList">
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：王汝刚  吕弢</p>
							<div class="hkActor">
								<p>1.沪剧《弯弯河水》</p>
								<p>2.小品《实话实说》</p>
								<p>3.魔 术《千变万化》</p>
								<p>4.小品《醉了》</p>
								<p>5.数来宝《老邻居》</p>
								<p>6.小品《失联》 </p>
							</div>
							<div class="hkActor">
								<p>演唱:李燕萍 伴舞：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程 蕾</p>
								<p>表演者：单滨</p>
								<p>表演者：石磊、曹 玻</p>
								<p>表演者：李国靖、卢云杰</p>
								<p>表演者：石磊、程 蕾、王 萌</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：李瑞</p>
							<div class="hkActor">
								<p>1.舞蹈《荷花颂》</p>
								<p>2.小品《实话实说》</p>
								<p>3.魔术《万紫千红》</p>
								<p>4.小品《清白》</p>
								<p>5.相声《欢歌笑语》</p>
								<p>6.小品《回家过年》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程蕾</p>
								<p>表演者：单滨</p>
								<p>表演者：石磊、李源、陆兰珍</p>
								<p>表演者：李腾洲、石磊</p>
								<p>表演者：石磊、李源</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：吕 弢</p>
							<div class="hkActor">
								<p>1.舞蹈《中国梦》</p>
								<p>2.小品《离合契》</p>
								<p>3.沪剧《今日梦圆》选段《雨中情》</p>
								<p>4.小品《500块钱》</p>
								<p>5.相声《欢歌笑语》</p>
								<p>6.肢体剧小品《谁动了我的爱情》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程蕾、王萌、彭峥嵘</p>
								<p>表演者：沈伟、李燕萍</p>
								<p>表演者：石磊、程蕾、王萌</p>
								<p>表演者：李腾洲、石磊</p>
								<p>表演者：石磊、程蕾、李瑞、李源、王萌、岳超、张亚晓、叶梓懿、陈铎</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：祥子、李瑞</p>
							<div class="hkActor">
								<p>1.舞蹈《荷花颂》</p>
								<p>2.小品《实话实说》</p>
								<p>3.脱口秀《笑品人生》</p>
								<p>4.小品《回家过年》</p>
								<p>5.数来宝《老邻居》</p>
								<p>6.小品《500块钱》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程蕾</p>
								<p>表演者：祥子</p>
								<p>表演者：石磊、李源</p>
								<p>表演者：李国靖、卢云杰</p>
								<p>表演者：石磊、程蕾、王萌</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：祥子、李瑞</p>
							<div class="hkActor">
								<p>1.舞蹈《中国梦》</p>
								<p>2.小品《非成不可》</p>
								<p>3.相声《礼仪杂谈》</p>
								<p>4.小品《失联》</p>
								<p>5.脱口秀《笑品人生》</p>
								<p>6.小品《清白》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：岳超、李源、石磊、祥子</p>
								<p>表演者：李腾洲、石磊</p>
								<p>表演者：石 磊、程 蕾、王萌</p>
								<p>表演者：祥子</p>
								<p>表演者：石磊、李源、陆兰珍</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：吕弢</p>
							<div class="hkActor">
								<p>1.沪剧《弯弯河水》</p>
								<p>2.小品《实话实说》</p>
								<p>3.魔术《千变万化》</p>
								<p>4.小品《醉了》</p>
								<p>5.数来宝《老邻居》</p>
								<p>6.小品《失联》 </p>
							</div>
							<div class="hkActor">
								<p>演唱:李燕萍 伴舞：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程蕾</p>
								<p>表演者：单滨</p>
								<p>表演者：石磊、曹玻</p>
								<p>表演者：李国靖、卢云杰</p>
								<p>表演者：石磊、程蕾、王萌</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：吕弢</p>
							<div class="hkActor">
								<p>1.舞蹈《荷花颂》</p>
								<p>2.小品《离合契》</p>
								<p>3.魔术《万紫千红》</p>
								<p>4.小品《醉了》</p>
								<p>5.相声《欢歌笑语》</p>
								<p>6.小品《回家过年》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程蕾、王萌、彭峥嵘</p>
								<p>表演者：单滨</p>
								<p>表演者：石磊、曹玻</p>
								<p>表演者：李腾洲、石磊</p>
								<p>表演者：石磊、李源</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：吕弢</p>
							<div class="hkActor">
								<p>1.舞蹈《中国梦》</p>
								<p>2.小品《离合契》</p>
								<p>3.沪剧《今日梦圆》选段《雨中情》</p>
								<p>4.小品《500块钱》</p>
								<p>5.相声《欢歌笑语》</p>
								<p>6.肢体剧小品《谁动了我的爱情》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程蕾、王萌、彭峥嵘</p>
								<p>表演者：沈伟、李燕萍</p>
								<p>表演者：石磊、程蕾、王萌</p>
								<p>表演者：李腾洲、石磊</p>
								<p>表演者：石磊、程蕾、李瑞、李源、王萌、岳超、张亚晓、叶梓懿、陈铎</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：祥子、李瑞</p>
							<div class="hkActor">
								<p>1.舞蹈《妈妈咪呀》</p>
								<p>2.小品《实话实说》</p>
								<p>3.脱口秀《笑品人生》</p>
								<p>4.小品《回家过年》</p>
								<p>5.数来宝《老邻居》</p>
								<p>6.小品《500块钱》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：石磊、程蕾</p>
								<p>表演者：祥子</p>
								<p>表演者：石磊、李源</p>
								<p>表演者：李国靖、卢云杰</p>
								<p>表演者：石磊、程蕾、王萌</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
			<ul style="display: block;">
				<li>
					<div class="hkActDiv">
						<div class="hkActImg">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/actImg.jpg" width="230" height="320" />
						</div>
						<div class="hkActTitle">
							<p>主持人：祥子、吕弢</p>
							<div class="hkActor">
								<p>1.沪剧《妈妈咪呀》</p>
								<p>2.小品《非成不可》</p>
								<p>3.数来宝《老邻居》</p>
								<p>4.小品《失联》</p>
								<p>5.脱口秀《笑品人生》</p>
								<p>6.小品《清白》 </p>
							</div>
							<div class="hkActor">
								<p>表演者：虹口区文化馆舞蹈队</p>
								<p>表演者：岳超、李源、石磊、祥子</p>
								<p>表演者：李国靖、卢云杰</p>
								<p>演者：石磊、程蕾、王萌</p>
								<p>表演者：祥子</p>
								<p>表演者：石磊、李源、陆兰珍</p>
							</div>
							<div style="clear: both;"></div>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="hkActBtn hkActBtnOffline">
						<p>已结束</p>
					</div>
				</li>
			</ul>
		</div>
		<div class="youthArtTips">
			<p class="youthArtTipsTt">取票须知</p>
			<ul class="hkTips">
				<li>
					<p class="hkTipsTitle">取票时间：</p>
					<p class="hkTipsDetl">9月10日（周六）—活动开始前（每日09:00-17:00）</p>
					<div style="clear: both;"></div>
				</li>
				<li>
					<p class="hkTipsTitle">取票地址：</p>
					<p class="hkTipsDetl">上海市虹口区水电路1412号·虹口区文化馆</p>
					<div style="clear: both;"></div>
				</li>
				<li>
					<p class="hkTipsTitle">取票方式：</p>
					<p class="hkTipsDetl">请在规定时间内，至虹口区文化馆一楼的“文化云”取票机上，凭文化云取票码自助取票</p>
					<div style="clear: both;"></div>
				</li>
			</ul>
			<div class="hkTipsBf">
				<p>公益票务有限，请珍惜票务名额，若有事不能前往，请及时取消。</p>
			</div>
		</div>
		<div class="youthArtTips">
			<p class="youthArtTipsTt">活动介绍</p>
			<p class="youthArtTipsDt">《海派小品 文脉虹口》小品专场演出针对上海市文化配送定向制作。精心挑选了中国剧协上海（虹口）小戏小品基地成立9年来的十几部贴近百姓生活、反应百姓期盼、引起百姓共鸣、记录时代变迁的佳作。</p>
		</div>

		<div class="youthArtTips">
			<p class="youthArtTipsTt">基地介绍</p>
			<p class="youthArtTipsDt">虹口区小戏小品创作基地成立于2007年，秉承“立足虹口、带动全市”的创作目标，以“讲日常发生的事，演身边熟悉的人，述心中感动的情”为创作宗旨，全力打造小戏小品这一虹口群文品牌，积极推动区域文化建设的创新发展，取得了丰硕的成果。几年来，小戏小品创作基地创作的《实话实说》《回家过年》《拉链夫妻》《牵手》《梦回提篮》《我的社区我的家》《告别最后的棚户人家》等一系列小戏小品荣获全国、华东地区和市级奖项70余个。</p>
			<div class="youthArtTipsImg" onclick="location.href='http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651693777&idx=1&sn=31b88ed63d90d1bec206c331e7e32880&scene=1&srcid=0912K2r8FwZ1OBnieOd09vuZ&from=singlemessage&isappinstalled=0#wechat_redirect'">
				<img src="${path}/STATIC/wxStatic/image/hongkouAct/banner2.jpg" />
			</div>
		</div>

		<div class="youthArtTips">
			<p class="youthArtTipsTt">精彩节目一览</p>
			<div class="hkVedioList">
				<ul>
					<li style="position: relative;width: 325px;height: 200px;">
						<video id="video1" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4"  style="width:325px;height: 200px;"></video>
						<img class="hkPlayBtn" src="${path}/STATIC/wxStatic/image/hongkouAct/vedio1.jpg" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 10;width: 325px;height: 200px;" onclick="document.getElementById('video1').play()" />
					</li>
					<li style="position: relative;width: 325px;height: 200px;">
						<video id="video2" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E7%89%B5%E6%89%8B.mp4"  style="width:325px;height: 200px;"></video>
						<img class="hkPlayBtn" src="${path}/STATIC/wxStatic/image/hongkouAct/vedio2.jpg" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 10;width: 325px;height: 200px;" onclick="document.getElementById('video2').play()" />
					</li>
					<li style="position: relative;width: 325px;height: 200px;">
						<video id="video3" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E8%B0%81%E5%8A%A8%E4%BA%86%E6%88%91%E7%9A%84%E7%88%B1%E6%83%85.mp4" style="width:325px;height: 200px;"></video>
						<img class="hkPlayBtn" src="${path}/STATIC/wxStatic/image/hongkouAct/vedio3.jpg" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 10;width: 325px;height: 200px;" onclick="document.getElementById('video3').play()" />
					</li>
					<li style="position: relative;width: 325px;height: 200px;">
						<video id="video4" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E7%A4%BE%E5%8C%BA%E9%87%8C%E7%9A%84%E5%A4%A7%E7%BC%96%E5%89%A7.mp4" poster="${path}/STATIC/wxStatic/image/hongkouAct/vedio4.jpg" style="width:10px;height: 10px;position: absolute;z-index: 1;left: 0;right: 0;bottom: 0;top: 0;margin: auto;"></video>
						<img class="hkPlayBtn" src="${path}/STATIC/wxStatic/image/hongkouAct/vedio4.jpg" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 10;width: 325px;height: 200px;" onclick="document.getElementById('video4').play()" />
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
		<div class="youthArtTips">
			<p class="youthArtTipsTt">嘉宾介绍</p>
			<div class="hkPeoList">
				<ul>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/yzq.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">俞志清</p>
							<p class="hkPeoListDetl">国家一级编剧</p>
							<p class="hkPeoListDetl">国家一级编剧、剧作家，虹口文化馆党支部书记、副馆长。代表作品《寻找男子汉》《调解明星》《拉链夫妻》荣获中国戏剧奖·小戏小品奖;《回家过年》《牵手》荣获国家文化部中国艺术节·群星奖;《一句话的事》登上央视虎年春晚;《回家过年》入选2013央视元宵晚会并被全国七个地市级电视春晚选用。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/wrg.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">王汝刚</p>
							<p class="hkPeoListDetl">国家一级演员</p>
							<p class="hkPeoListDetl">上海市人民滑稽剧团表演艺术家、上海市人大代表、中国曲艺家协会副主席、上海市文联副主席、上海曲艺家协会主席、上海戏剧家协会主席团委员、中国农工民主党上海市委副秘书长、上海市慈善基金会理事，中华炎黄文化委员会理事，上海警备区文化顾问。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/wzx.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">祥 子</p>
							<p class="hkPeoListDetl">知名演员</p>
							<p class="hkPeoListDetl">祥哥，本名王兆祥。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/gbj.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">顾邦俊</p>
							<p class="hkPeoListDetl">演员、导演</p>
							<p class="hkPeoListDetl">上海沪剧院原院长，上海话剧艺术中心著名演员、导演，长期扶持群文戏剧创作，导演作品有小品《一束康乃馨》《实话实说》《爸爸再爱我一次》，大型情景剧《我的社区我的家》《最后的棚户人家》等，曾荣获全总戏剧小品大赛金奖，中国戏剧奖小戏小品奖等殊荣。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/wlh.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">王丽鹤</p>
							<p class="hkPeoListDetl">导演</p>
							<p class="hkPeoListDetl">上海戏剧学院导演系本科系毕业、上海市文联会员，上海语言协会特聘教师，就职于上海电视台小荧星艺术团影视团。编导作品《寻找男子汉》《死去活来》《醉了》《失联》等分别获得中国戏剧奖金奖、最佳导演奖，全国群星奖等;编导的肢体剧《借我一声》获上海之春新人新作金奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/yl.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">岳 磊</p>
							<p class="hkPeoListDetl">国家二级导演</p>
							<p class="hkPeoListDetl"> 毕业于上海戏剧学院导演系，现任郑州市艺术创作研究院国家二级导演。导演话剧《小平你好》《因为爱》等；导演电影《脱单宝典》、《安阳劫》、电视连续剧《中国神探》；导演戏剧小品《50元钱》在2010年中央电视台春节联欢晚会演出,获得最受欢迎的节目三等奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/xpsl.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">石 磊</p>
							<p class="hkPeoListDetl">小品演员</p>
							<p class="hkPeoListDetl">上海虹口区政协委员、上海虹口文化馆创作部主任及活动部大型晚会导演， 2004年毕业于上海戏剧学院导演系。 执导过多部话剧〈死去活来〉、〈不骗你骗谁〉等。参演作品屡次选入CCTV小品大赛，并登上2013年央视春晚元宵晚会的舞台。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/cl.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">程 蕾</p>
							<p class="hkPeoListDetl">编剧、演员</p>
							<p class="hkPeoListDetl">武警文工团原话剧队队长、现任虹口区文化馆活动部主任，虹口区文联会员；创作小品《心结》荣获上海之春群文新人新作展评展演金奖；创作小品《演练》荣获全军文艺汇演一等奖、群星奖纪念奖；主演作品《谁动了我的爱情》《心结》等连续多年荣获上海市新人新作展评展演金奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/sw.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">沈 伟</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">扮相英俊潇洒，一表人才，是沪剧泰斗王盘声爱徒。他的唱腔完全继承了“王派”的风格，宽厚持重，韵味清醇，运腔自如，一招一式，一板一眼，感情相当丰富，给沪剧戏迷带来了一股清新震撼，是难得一见的沪剧小生。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/cb.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">曹 玻</p>
							<p class="hkPeoListDetl">导演</p>
							<p class="hkPeoListDetl">毕业于上海戏剧学院，话剧制作作品：《朝九晚无》《我的老板我的班》等；上海东方卫视春晚节目导演、《笑傲江湖》节目导演、《生活大爆笑》节目导演；情景剧《迷案大世界》导演；微电影：《爱的传承》《暖情》等； MV《就是这个味道》导演；爱奇艺《开心密室》导演。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/ly.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">李 源</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">上海戏剧学院导演系毕业，曾获中国群星奖小品一等奖、中国戏剧奖小品一等奖、上海之春小品金奖、华东六省小品大赛一等奖、江苏省戏剧奖金奖。影视作品代表：《赤松山魂》《蚀金风暴》等，广告作品：娃哈哈VE钙奶等，小品作品：《回家过年》《失联》《清白》等。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/wm.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">王 萌</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">上海戏剧学院导演系毕业。原武警文工团相声、小品演员，现为职业演员。曾荣获2013年中国“群星奖”小品表演一等奖；多次获得“上海之春”金奖；影视剧及情景剧代表：《岁月1978》《老房新客》《哈哈笑餐厅》《浙江廉政建设系列微电影》仁和药业广告等。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/lgj.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">李国靖</p>
							<p class="hkPeoListDetl">知名演员</p>
							<p class="hkPeoListDetl">上海品欢相声会馆主力演员、快板书演员。1987年生于山东，自幼喜爱曲艺，自学快板，后毕业于上海戏剧学院导演系。中国曲艺家协会会员，上海市曲艺家协会理事。师承相声名家李立山。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/yc.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">岳 超</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">上海戏剧学院表演系、电视导演系毕业。主要出演电视剧：《蜗居》《千金女贼》《面包树上的女人》等。网络剧：《咖啡间疯云》电影：《天地告白》《三月情流感》等。广告：《美汁源•原味果粒奶优》《桂格燕麦》《2014世界杯•这一刻》哈尔滨啤酒。导演编剧校园剧《我的愿望》，获得全国第五届全国青少年艺术比赛一等奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/llz.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">陆兰珍</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">中国剧协上海（虹口）小戏小品基地演员；二十多年一直活跃在舞台上的小品演员。话剧作品：《白骨精列传》《知识工人有力量》等，参演《牵手》《幸福广场》等上百个小品。曾获得全国戏剧“群星奖”，华东六省一市小品一等奖和上海市新人新作优秀奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/lr.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">李 瑞</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">虹口区文化馆馆长，虹口区文联副主席，主演作品《谁动了我的爱情》荣获上海市新人新作展评展演金奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/lt.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">吕 弢</p>
							<p class="hkPeoListDetl">播音员、主持人、配音员</p>
							<p class="hkPeoListDetl">播音员、主持人、配音员，毕业于上海戏剧学院播音主持专业，上海市朗诵协会理事、虹口区文联会员。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/lyp.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">李燕萍</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">曾2次举办个人戏曲专场演出,获得众多奖项，有众多戏迷粉丝；舞蹈艺术爱好及组织者,组织参演舞蹈节目《雪之玫》荣获全国老年艺术节舞蹈银奖、《荷花颂》上海老年舞蹈比赛冠军。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/zyx.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">张亚晓</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">毕业于上海戏剧学院，话剧演员、儿童艺术教育资深教师；多年从事舞台剧、话剧表演。曾获得“上戏举办才艺大赛”舞蹈三等奖，魔术表演三等奖。开办“心艺坊”少儿培训中心，主要培训少儿表演小主持、少儿舞蹈等。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/pzr.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">彭峥嵘</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">中国剧协上海（虹口）小戏小品基地演员；综艺类节目主持，曾多次在市、区演讲、故事、朗诵大赛中获奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/ltz.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">李腾洲 </p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">中国北方曲艺学院毕业，原警备区文工团演员。曾获得战士文艺奖，全军优秀演员，四次江苏省曲艺节一等奖，华东六省一市文艺汇演一等奖等。曾参加“中央电视台心连心艺术团”赴凤阳慰问演出，安徽电视台“江淮行”全省巡演等等，担任安徽电视台“江淮行”执行制作人。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/xssl.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">石 磊</p>
							<p class="hkPeoListDetl">编剧</p>
							<p class="hkPeoListDetl">笔名石泰龙，毕业于中国北方曲艺学校，CCTV相声大赛编剧，中国相声节编剧，CCTV3《我爱满堂彩》编剧，曾任西安青曲社影视文化传媒公司剧本统筹，第二界全国相声大赛三等奖 “南开杯”全国相声大赛传承奖，安徽卫视《超级笑星》年度第四名。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/lyj.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">卢云杰</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">上海品欢相声会馆相声演员。捧哏沉稳，张弛有度。常演作品：《评书趣谈》《写状》《打灯谜》等。连续三届荣获中国曲艺牡丹奖新人奖提名；2013年7月，在首届“武清-李润杰杯”全国快板书大赛中凭借快板书《追杀令》荣获专业组一等奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/sb.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">单 滨</p>
							<p class="hkPeoListDetl">魔术师</p>
							<p class="hkPeoListDetl">中国魔术家协会，上海演艺工作者联合会，首批获的国家中级职称魔术师，东亚五王大赛上海赛区特约佳宾。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/cd.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">陈 铎</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">毕业于上海师范大学谢晋影视艺术学院表演系本科班，话剧影视剧演员，多年从事影视话剧的演出。参演肢体剧《谁动了我的爱情》荣获上海之春群文新人新作展评展演金奖。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/hongkouAct/people/yzy.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">叶梓懿</p>
							<p class="hkPeoListDetl">演员</p>
							<p class="hkPeoListDetl">在校小学生，3岁半启蒙戏剧表演、书法、舞蹈、钢琴、将棋等，表演类：6周岁参演小品《电梯•楼梯》、肢体剧小品《谁动了我的爱情》、舞台剧《你很特别》《红孩子》、音乐剧《神奇校车》。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
				</ul>
			</div>
		</div>
		<div>
			<img src="${path}/STATIC/wxStatic/image/hongkouAct/hongkouer.jpg" style="display: block;" />
		</div>
	</div>
</body>
</html>