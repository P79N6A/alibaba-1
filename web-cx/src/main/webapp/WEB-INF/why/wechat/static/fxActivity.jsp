<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>中国国际青年艺术周</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '【邀请函】文化云邀你参加2016中国国际青年艺术周(上海·奉贤)';
	    	appShareDesc = '文艺老中青必备 让你的九月嗨翻天！！！';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/youthArt/fxShare.png';
	    	
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
					title: "【邀请函】文化云邀你参加2016中国国际青年艺术周(上海·奉贤)",
					desc: '文艺老中青必备 让你的九月嗨翻天！！！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/youthArt/fxShare.png'
				});
				wx.onMenuShareTimeline({
					title: "【邀请函】文化云邀你参加2016中国国际青年艺术周(上海·奉贤)",
					imgUrl: '${basePath}/STATIC/wxStatic/image/youthArt/fxShare.png'
				});
				wx.onMenuShareQQ({
					title: "【邀请函】文化云邀你参加2016中国国际青年艺术周(上海·奉贤)",
					desc: '文艺老中青必备 让你的九月嗨翻天！！！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/youthArt/fxShare.png'
				});
				wx.onMenuShareWeibo({
					title: "【邀请函】文化云邀你参加2016中国国际青年艺术周(上海·奉贤)",
					desc: '文艺老中青必备 让你的九月嗨翻天！！！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/youthArt/fxShare.png'
				});
				wx.onMenuShareQZone({
					title: "【邀请函】文化云邀你参加2016中国国际青年艺术周(上海·奉贤)",
					desc: '文艺老中青必备 让你的九月嗨翻天！！！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/youthArt/fxShare.png'
				});
			});
		}
		
		$(function () {
			$(".youthArtMonth>ul>li").click(function() {
				$(".youthArtMonth>ul>li").removeClass("monthBtLine")
				$(this).addClass("monthBtLine")
				$(this).index()
				$(".youthArtList>ul").hide()
				$(".youthArtList>ul").eq($(this).index()).show()
			})

			var dataLilen = $(".youthArtMonth>ul>li").length;
			var dataLiWidth = $(".youthArtMonth>ul>li").width() + 40;
			var dataUlWidth = dataLilen * dataLiWidth;
			$(".youthArtMonth>ul").css("width", dataUlWidth);

			var youthMusicLilen = $(".youthMusic>ul>li").length;
			var youthMusicLiWidth = $(".youthMusic>ul>li").width() + 22;
			var youthMusicUlWidth = youthMusicLilen * youthMusicLiWidth + 20;
			$(".youthMusic>ul").css("width", youthMusicUlWidth);

			var youthYouthLilen = $(".youthYouth>ul>li").length;
			var youthYouthLiWidth = $(".youthYouth>ul>li").width() + 22;
			var youthYouthUlWidth = youthYouthLilen * youthYouthLiWidth + 20;
			$(".youthYouth>ul").css("width", youthYouthUlWidth);

			var youthSpringLilen = $(".youthSpring>ul>li").length;
			var youthSpringLiWidth = $(".youthSpring>ul>li").width() + 22;
			var youthSpringUlWidth = youthSpringLilen * youthSpringLiWidth + 20;
			$(".youthSpring>ul").css("width", youthSpringUlWidth);

			$(".youthArtMonth>ul>li").each(function() {
				var myDate = new Date();
				var day = myDate.getDate(); //获取当前日(1-31)
				var month = myDate.getMonth()+1;
				if(month==9){
					if($(this).attr("data") < day) {
						$(this).hide()
					}

					if($(this).attr("data") == day) {
						$(".youthArtMonth>ul>li").removeClass("monthBtLine")
						$(this).addClass("monthBtLine")
						$(".youthArtList>ul").hide()
						$(".youthArtList>ul").eq($(this).index()).show()
					}
				}
			})
			
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
			
			if (!/wenhuayun/.test(ua)&&self == top) {		//APP端
				$(".newMenuBTN").show();
			}
			
			//底部菜单
			if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
				$(document).on("touchmove", function() {
					$(".footer").hide()
				}).on("touchend", function() {
					$(".footer").show()
				})
			}
			$(".newMenuBTN").click(function() {
				$(".newMenuList").animate({
					"bottom": "0px"
				})
			})
			$(".newMenuCloseBTN>img").click(function() {
				var height = $(".newMenuList").width();
				$(".newMenuList").animate({
					"bottom": "-"+height+"px"
				})
			})
		});
		
		//跳转到日历
        function preCalendar(){
        	window.location.href = '${path}/wechatActivity/preActivityCalendar.do';
        }
		
      	//跳转到奉贤答题
        function preFxAnswer(){
        	window.location.href = '${path}/wechatStatic/fxAnswer.do';
        }
	</script>
	
	<style>
		.youthArtList>ul {
			display: none;
		}
		.footer{
			position: fixed;
			width: 750px;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/youthArt/fxShare.png"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="youthArt">
		<div class="youthArtHead">
			<img src="${path}/STATIC/wxStatic/image/youthArt/youthArt_01.gif" />
			<img class="shareBut" src="${path}/STATIC/wxStatic/image/youthArt/share.png" style="position: absolute;right: 30px;top: 30px;" />
		</div>
		<div class="youthArtMonth">
			<ul>
				<li data="17" class="monthBtLine">9/17</li>
				<li data="18">9/18</li>
				<li data="19">9/19</li>
				<li data="20">9/20</li>
				<li data="21">9/21</li>
				<li data="22">9/22</li>
				<li data="23">9/23</li>
				<li data="24">9/24</li>
				<li data="25">9/25</li>
				<div style="clear: both;"></div>
			</ul>
		</div>
		<div class="youthArtList">
			<ul style="display: block;">
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/hmlt.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年戏剧贤城展《哈姆雷特》</p>
							<p class="youthArtPlace">华东理工大学</p>
							<p class="youthArtTime">15:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('a98efd75a2e342b9a67bf4ee2481380c')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/sjqnyyjxkms.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">世界青年交响音乐会（开幕式）</p>
							<p class="youthArtPlace">奉贤区会议中心大礼堂</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('354e3b5c0c6d48cd9bab8762b6ab1acf')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/syzy.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">“赛乐尔三益之音”音乐会</p>
							<p class="youthArtPlace">奉贤区会议中心大礼堂</p>
							<p class="youthArtTime">18:30</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('be746ae453b444c29ab74e76dd5c6248')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/yyhj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">音乐话剧《好人老康发财记》</p>
							<p class="youthArtPlace">牡丹影剧院</p>
							<p class="youthArtTime">18:30</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('6e0e949c301b41598bddeaf8aff7bf02')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/sjqnyyjxkms.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">世界青年交响音乐会</p>
							<p class="youthArtPlace">上海大剧院</p>
							<p class="youthArtTime">19:15</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('9777aa02d6884f35870a891e0405bebc')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/klzz.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年戏剧贤城展《快乐的战争》</p>
							<p class="youthArtPlace">格致中学</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('1ee73f1d2d944a33a0405cb723550a79')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/zwxszc.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">上海音乐学院：中外学生专场</p>
							<p class="youthArtPlace">华东理工大学</p>
							<p class="youthArtTime">14:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('9b67960f646f47c39c32ffc48ad2fc01')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/yyhj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">音乐话剧《好人老康发财记》</p>
							<p class="youthArtPlace">柘林影剧院</p>
							<p class="youthArtTime">18:30</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('8afe9bc0ee1642e88b8a3fa2770dd609')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/zwxszc.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">上海音乐学院：中外学生专场</p>
							<p class="youthArtPlace">格致中学</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('99ca4210c19c4f0da5b0ed5db93c5916')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/jtys.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年静态艺术系列展</p>
							<p class="youthArtPlace">奉贤图书馆</p>
							<p class="youthArtTime">10:00-17:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('cf16aa61a15a496e99f4a84d4b7ecb84')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/yyhj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">音乐话剧《好人老康发财记》</p>
							<p class="youthArtPlace">奉城影剧院</p>
							<p class="youthArtTime">18:30</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('152649a8e684414dbb2052fec85fc861')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/bmn.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">经典芭蕾舞剧《白毛女》</p>
							<p class="youthArtPlace">奉贤区会议中心大礼堂</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('21d3da31224c4c17b29b2a4377ba6eab')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/qsnzyzc.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">在奉大学生综艺专场</p>
							<p class="youthArtPlace">上海应用技术大学</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('a4bd6708aec64657a234bb5ec4dae0c7')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/jtys.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年静态艺术系列展</p>
							<p class="youthArtPlace">奉贤图书馆</p>
							<p class="youthArtTime">10:00-17:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('cf16aa61a15a496e99f4a84d4b7ecb84')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/yyhj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">音乐话剧《好人老康发财记》</p>
							<p class="youthArtPlace">青村影剧院</p>
							<p class="youthArtTime">18:30</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('0073da69160e44baa66af295dd1c461a')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/jtys.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年静态艺术系列展</p>
							<p class="youthArtPlace">奉贤图书馆</p>
							<p class="youthArtTime">10:00-17:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('cf16aa61a15a496e99f4a84d4b7ecb84')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/sxmoj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">上戏木偶剧</p>
							<p class="youthArtPlace">恒贤小学</p>
							<p class="youthArtTime">14:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('fb93bf19c2314e3cb5b3a60653a4cc41')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/yyhj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">音乐话剧《好人老康发财记》</p>
							<p class="youthArtPlace">金汇影剧院</p>
							<p class="youthArtTime">18:30</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('215b7d6510b84bcba2826c344363c140')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/qsnmyzc.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">奉贤区青少年民乐专场</p>
							<p class="youthArtPlace">奉贤区会议中心大礼堂</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('6b3c14170bd5484887cda20f53645acf')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/jtys.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年静态艺术系列展</p>
							<p class="youthArtPlace">奉贤图书馆</p>
							<p class="youthArtTime">10:00-17:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('cf16aa61a15a496e99f4a84d4b7ecb84')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/sxmoj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">上戏木偶剧</p>
							<p class="youthArtPlace">解放路小学</p>
							<p class="youthArtTime">14:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('371c9dc6c878452195d2a5d3d65ee531')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/yyhj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">音乐话剧《好人老康发财记》</p>
							<p class="youthArtPlace">南桥影剧院</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('e26799638b9f4f138617194f4eff681e')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/czjxxl.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">春之觉醒</p>
							<p class="youthArtPlace">上海文化广场</p>
							<p class="youthArtTime">19:15</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('14f35d4beeff49bab8b22d60e2fbff03')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/jtys.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年静态艺术系列展</p>
							<p class="youthArtPlace">奉贤图书馆</p>
							<p class="youthArtTime">10:00-17:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('cf16aa61a15a496e99f4a84d4b7ecb84')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/czjxxl.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">春之觉醒</p>
							<p class="youthArtPlace">上海文化广场</p>
							<p class="youthArtTime">14:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('3fec12cf4b5b4f058cda44601c51fbe2')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/qsnzyzc.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">在奉大学生综艺专场</p>
							<p class="youthArtPlace">奉贤中学</p>
							<p class="youthArtTime">19:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('c611836ec419498a813f9e57750816f5')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/td.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">《听道》</p>
							<p class="youthArtPlace">格致中学</p>
							<p class="youthArtTime">14:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('d5636036503d4ee38ba8cad127dc6f54')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/czjxxl.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">春之觉醒</p>
							<p class="youthArtPlace">上海文化广场</p>
							<p class="youthArtTime">19:15</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('8ebe5b4b564b4246aa915c21e9504eeb')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/mtyyj.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">魔途音乐会(闭幕式)</p>
							<p class="youthArtPlace">碧海金沙水上乐园</p>
							<p class="youthArtTime"></p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('3f0f10ed6fd84e65968d31bd92c125c6')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/jtys.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年静态艺术系列展</p>
							<p class="youthArtPlace">奉贤图书馆</p>
							<p class="youthArtTime">10:00-17:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('cf16aa61a15a496e99f4a84d4b7ecb84')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
			<ul>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/czjxxl.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">春之觉醒</p>
							<p class="youthArtPlace">上海文化广场</p>
							<p class="youthArtTime">14:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('ceccf368d2ff4e65981c6b97803e82a5')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/czjxxl.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">春之觉醒</p>
							<p class="youthArtPlace">上海文化广场</p>
							<p class="youthArtTime">19:15</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('0be27944db5a46bea83b67058944f854')">
							<p>已订完</p>
						</div>
					</div>
				</li>
				<li>
					<div>
						<img src="${path}/STATIC/wxStatic/image/youthArt/jtys.jpg" />
					</div>
					<div class="youthArtDetail">
						<div>
							<p class="youthArtTitle">国际青年静态艺术系列展</p>
							<p class="youthArtPlace">奉贤图书馆</p>
							<p class="youthArtTime">10:00-17:00</p>
						</div>
						<div class="youthArtObtn hkActBtnOffline" onclick="toActDetail('cf16aa61a15a496e99f4a84d4b7ecb84')">
							<p>已订完</p>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="youthArtTips">
			<p class="youthArtTipsTt">取票须知</p>
			<p class="youthArtTipsDt">取票时间：9月7日-活动开始前</p>
			<p class="youthArtTipsDt">取票方式：请在规定时间内，至指定地点的“文化云”取票机上，凭文化云取票码自助取票</p>
			<p class="youthArtTipsDt">取票地点：以下任一地点均可</p>
			<p class="youthArtTipsDt">🌼	南桥电影院    （开放时间：08:30-22:00）</p>
			<p class="youthArtTipsDt">🌼	奉贤区图书馆  （开放时间：周一13:00-17:00 ；周二至周日09:00-20:00）</p>
			<p class="youthArtTipsDt" style="color:red;font-size: 24px;">⚠	部分特殊场次活动票务须现场领取，具体请参照活动详情页面</p>
			<p class="youthArtTipsDt" style="color:red;font-size: 24px;">（艺术周活动非常热门，请珍惜票务名额，若有事不能前往，请及时取消。）</p>
		</div>
		<div class="youthArtTips">
			<p class="youthArtTipsTt">活动介绍</p>
			<p class="youthArtTipsDt">中国国际青年艺术周是我国首个由政府主导，以青年为主体的国家级、国际性大型多边文化交流活动，自2008年以来已成功举办了八届，艺术周是一个国际文化大熔炉，不同背景不同文化的青年艺术家和年轻人源源不断地留下各自的身影；艺术周也勾勒青年艺术家的未来，一批又一批的青年艺术家从这里走向更广阔的空间，为世界艺术生产输入中国创造力和中国影响力。<br/>本次2016中国国际青年艺术周（上海•奉贤）的举办，将有效拓展青年艺术人才的国际视野，并进一步促进和推动世界各国青年之间的文化交流分享，也将为上海奉贤“贤文化”更好地走向世界并打造青年艺术人才集聚地和创意集聚地、展现“奉贤美”良好形象提供有利契机和广阔的未来空间。</p>
			<div class="youthArtTipsImg" onclick="preFxAnswer();">
				<img src="${path}/STATIC/wxStatic/image/youthArt/youthArt_03.gif" />
			</div>
		</div>
		<div class="youthArtTips">
			<p class="youthArtTipsTt">精彩节目一览</p>
			<p class="youthArtTipsDt">世界青年交响音乐会（开幕式）</p>
			<div class="youthArtVMenu youthMusic">
				<ul class="youthArtVList">
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/music.jpg" />
						<div class="youthArtVTt">
							<p>领衔吴牧野</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/music2.jpg" />
						<div class="youthArtVTt">
							<p>巴黎索科大学交响乐团</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/music3.jpg" />
						<div class="youthArtVTt">
							<p>巴黎索科大学交响乐团</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/music4.jpg" />
						<div class="youthArtVTt">
							<p>艺术总监 指挥 李坚</p>
						</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
			<p class="youthArtTipsDt">国际青年戏剧贤城展</p>
			<div class="youthArtVMenu youthYouth">
				<ul class="youthArtVList">
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/youth.jpg" />
						<div class="youthArtVTt">
							<p>《哈姆雷特》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/youth2.jpg" />
						<div class="youthArtVTt">
							<p>《哈姆雷特》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/youth3.jpg" />
						<div class="youthArtVTt">
							<p>《快乐的战争》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/youth4.jpg" />
						<div class="youthArtVTt">
							<p>《快乐的战争》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/youth5.jpg" />
						<div class="youthArtVTt">
							<p>《快乐的战争》剧照</p>
						</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
			<p class="youthArtTipsDt">音乐剧《春之觉醒》</p>
			<div class="youthArtVMenu youthSpring">
				<ul class="youthArtVList">
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/spring.jpg" />
						<div class="youthArtVTt">
							<p>《春之觉醒》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/spring2.jpg" />
						<div class="youthArtVTt">
							<p>《春之觉醒》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/spring3.jpg" />
						<div class="youthArtVTt">
							<p>《春之觉醒》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/spring4.jpg" />
						<div class="youthArtVTt">
							<p>《春之觉醒》剧照</p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wxStatic/image/youthArt/spring5.jpg" />
						<div class="youthArtVTt">
							<p>《春之觉醒》剧照</p>
						</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
	</div>
	<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
</body>
</html>