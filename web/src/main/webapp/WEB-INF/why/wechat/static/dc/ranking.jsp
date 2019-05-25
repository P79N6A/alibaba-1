<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>2016春华秋实市民投票通道</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-dc.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var tab = '${tab}';
		var videoType = '${videoType}';
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatDc/toRanking.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……';
        	appShareDesc = '展演名单已公布，点击进入……';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg';
        	
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
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					link: '${basePath}wechatDc/toRanking.do?tab='+tab,
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg',
					link: '${basePath}wechatDc/toRanking.do?tab='+tab
				});
				wx.onMenuShareQQ({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			if (tab == null || tab == '') {
				tab = 0;
			}
			
			//loadDcList();
			
			menuChange(tab);
			
			// 回到顶部
			var topH = $(".hdtop").offset().top;
			$(window).scroll(function(){
				var scroH = $(this).scrollTop();
				if(scroH>topH){
					$(".hdtop").fadeIn(300);
				}else{
					$(".hdtop").fadeOut(300);
				}
			});
			$(".hdtop").click(function(){
				$("html,body").animate({scrollTop:0},400);
			});

			// 规则
			$('.delivery .deban .zpge .gz').bind('click', function () {
				$('.delivery .derule').stop().fadeIn(300);
				$('html,body').css('overflow','hidden');
			});
			$('.delivery .derule .zhidaol').bind('click', function () {
				$('html,body').css('overflow','visible');
				$('.delivery .derule').stop().fadeOut(300);
			});

			// 切换标题栏固定
			$(document).scroll(function() {
				if($(document).scrollTop() > 542) {
					$(".delivery .delivetit").css("position", "fixed")
				} else {
					$(".delivery .delivetit").css("position", "static")
				}
			});
			$(document).on('touchmove', function() {
				if($(document).scrollTop() > 542) {
					$(".delivery .delivetit").css("position", "fixed")
				} else {
					$(".delivery .delivetit").css("position", "static")
				}
			});
			
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
		});
		
		//加载剧评列表
		function loadDcList(){
			var data = {
					userId:userId,
					videoType:videoType,
					reviewType:7
	            };
			$.post("${path}/wechatDc/queryDclist.do",data, function (data) {
				$.each(data, function (i, dom) {
					var ImgObj = new Image();
					ImgObj.src = dom.videoImgUrl+"@300w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>141/105){
							$("img[videoId="+dom.videoId+"]").css("height","105px");
						}else{
							$("img[videoId="+dom.videoId+"]").css("width","141px");
						}
					}
					var videoActivityCenter = "";
					if(dom.videoActivityCenter.lastIndexOf("文化活动中心")>0){
						videoActivityCenter = dom.videoActivityCenter.substring(0,dom.videoActivityCenter.lastIndexOf("文化活动中心"));
					}else{
						videoActivityCenter = dom.videoActivityCenter;
					}
					$("#dcVideoTable").append("<tr>" +
									    		"<td class='td1' ><div class='shu'>"+(eval(i)+1)+"</div></td>" +
									    		"<td class='td2'>" +
									    			"<div class='pic'>" +
									    				"<a href='javascript:;' style='display:block;width:141px;height:105px;overflow:hidden;'>" +
									    					"<img videoId='"+dom.videoId+"' src='"+dom.videoImgUrl+"@300w'>" +
									    				"</a>" +
									    			"</div>" +
									    		"</td>" +
									    		"<td class='td3'>" +
									    			"<a href='javascript:;'>" +
										    			"<div class='char'>" +
										    				"<h5>"+dom.videoName+"</h5>" +
										    				"<h6>"+videoActivityCenter+"</h6>" +
										    			"</div>" +
									    			"</a>" +
									    		"</td>" +
									    		"<td class='td4' onclick='location.href=\"${path}/wechatDc/toDetail.do?videoId="+dom.videoId+"\"'><img src='${path}/STATIC/wxStatic/image/delivery/pic11.png'></td>" +
									    	  "</tr>");
				});
				
				// 前三名红色
				/* $('.deresultList').each(function () {
					$(this).find('tr:lt(3) .shu').addClass('red');
				}); */
			},"json");
		}
		
		//图片重置位置
		function reloadImg(src,videoId) {
			var ImgObj = new Image();
			ImgObj.src = src;
			ImgObj.onload = function(){
				if(ImgObj.width/ImgObj.height>141/105){
					var pLeft = (ImgObj.width*(105/ImgObj.height)-141)/2;
					$("img[videoId="+videoId+"]").css({"height":"105px","position":"absolute","left":"-"+pLeft+"px"});
				}else{
					var pTop = (ImgObj.height*(141/ImgObj.width)-105)/2;
					$("img[videoId="+videoId+"]").css({"width":"141px","position":"absolute","top":"-"+pTop+"px"});
				}
			}
		}
		
     	//进页面菜单显示
		function menuChange(num) {
			$('.delivetit li').eq(num).addClass('current');
			$('.delivery .deresultList_wc .deresultList').eq(num).show();
      	}
	</script>
	
	<style type="text/css">
		html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;/*Google Chrome*/-webkit-tap-highlight-color: transparent;}
		img {vertical-align: middle;}
		.delivery {background: url(${path}/STATIC/wxStatic/image/delivery/bg1.jpg) repeat;}
		.zuitg {font-size: 26px;color: #af81b8;height: 80px;line-height: 80px;background-color: #2b1538;padding: 0 44px;}
		.zuitg img {margin-right: 15px;}
		.delivery .deresultList_wc .deresultList{display: none;}
	</style>
</head>

<body style="background: url(${path}/STATIC/wxStatic/image/delivery/bg1.jpg) repeat;">
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg"/></div>
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
	<div class="delivery">
		<div class="deban">
			<img src="${path}/STATIC/wxStatic/image/delivery/ban1.jpg">
			<ul class="lccshare clearfix" style="margin-top:10px;">
		        <li style="background-color: transparent">
		        	<a class="share-button" style="background-color: rgba(0,0,0,0.5);margin-bottom:10px;" href="javascript:;">分享</a>
		        	<a class="keep-button" style="background-color: rgba(0,0,0,0.5);" href="javascript:;">关注</a>
		        </li>
		    </ul>
		    <div class="zymd">展演名单</div>
		    <div class="zpge">
		    	<a class="zp" href="${path}/wechatDc/index.do"><img src="${path}/STATIC/wxStatic/image/delivery/pic16.png"></a>
		    	<a class="gz" href="javascript:;"><img src="${path}/STATIC/wxStatic/image/delivery/pic15.png"></a>
		    </div>
	    </div>
	    <div class="zuitg"><img src="${path}/STATIC/wxStatic/image/delivery/pic20.png">排名不分先后，按节目名称首字母排序</div>
	    <div class="delivetit_wc">
		    <ul class="delivetit clearfix">
		    	<li onclick="location.href='${path}/wechatDc/toRanking.do?tab=0'">舞 蹈</li>
		    	<li onclick="location.href='${path}/wechatDc/toRanking.do?tab=1'">合 唱</li>
		    	<li onclick="location.href='${path}/wechatDc/toRanking.do?tab=2'">时 装</li>
		    	<li onclick="location.href='${path}/wechatDc/toRanking.do?tab=3'">戏曲/曲艺</li>
		    </ul>
	    </div>
	    <!-- <div class="deresultList_wc jz710">
		    <table class="deresultList" id="dcVideoTable"></table>
	    </div> -->
	    <div class="deresultList_wc jz710">
		    <table class="deresultList">
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=7cf2f45c6bab49878a7e9c1b47371f74'">
		    		<td class="td1"><div class="shu">1</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='7cf2f45c6bab49878a7e9c1b47371f74' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024142038mrjwjc9eZTg8ozrbV8Ptt9OUW5dz9h.bmp@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《阿木塞诺》</h5>
		    				<h6>金山工业区社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024142038mrjwjc9eZTg8ozrbV8Ptt9OUW5dz9h.bmp@200w','7cf2f45c6bab49878a7e9c1b47371f74')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=64ac0b7a432c41a6a930b0f7c3b15644'">
		    		<td class="td1"><div class="shu">2</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='64ac0b7a432c41a6a930b0f7c3b15644' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610271740259191UpFwLmg4legZpR1eGtNfttNX3S.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《爱国卫生大扫除》</h5>
		    				<h6>石门二路社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610271740259191UpFwLmg4legZpR1eGtNfttNX3S.png@200w','64ac0b7a432c41a6a930b0f7c3b15644')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=1c2cc4804ea14e7ebde50d5801dc315d'">
		    		<td class="td1"><div class="shu">3</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='1c2cc4804ea14e7ebde50d5801dc315d' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102617532Vg1yzy73G7Dnm22R3IBk8xptisnCsN.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《春韵》</h5>
		    				<h6>七宝镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102617532Vg1yzy73G7Dnm22R3IBk8xptisnCsN.png@200w','1c2cc4804ea14e7ebde50d5801dc315d')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=3a529c1dcc07457fb7d44f1242066ad1'">
		    		<td class="td1"><div class="shu">4</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='3a529c1dcc07457fb7d44f1242066ad1' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102714245lXNadzz2YLx69XUmJWevnSzpuCkSQY.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《待到槐花开》</h5>
		    				<h6>虹梅社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102714245lXNadzz2YLx69XUmJWevnSzpuCkSQY.png@200w','3a529c1dcc07457fb7d44f1242066ad1')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=04ccf53013f546798df49eb985a8df0f'">
		    		<td class="td1"><div class="shu">5</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='04ccf53013f546798df49eb985a8df0f' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025101621UW0tjEzpGrbNkERgZhgJ50X7vPb492.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《顶碗舞》</h5>
		    				<h6>新泾镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025101621UW0tjEzpGrbNkERgZhgJ50X7vPb492.jpg@200w','04ccf53013f546798df49eb985a8df0f')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=66ce521af6a44c269dc5bff6bae035c9'">
		    		<td class="td1"><div class="shu">6</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='66ce521af6a44c269dc5bff6bae035c9' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028101758kGC8lp6tcj0racmDIQbONOvW9N3CqP.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《罐香情》</h5>
		    				<h6>方松街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028101758kGC8lp6tcj0racmDIQbONOvW9N3CqP.png@200w','66ce521af6a44c269dc5bff6bae035c9')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=cfe5a056a49049369014af4e652a11bb'">
		    		<td class="td1"><div class="shu">7</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='cfe5a056a49049369014af4e652a11bb' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031142551RecjnsgECreMWNmG5FPU44W5J1yzNF.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《花影月色》</h5>
		    				<h6>殷行社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031142551RecjnsgECreMWNmG5FPU44W5J1yzNF.jpg@200w','cfe5a056a49049369014af4e652a11bb')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=e857442201a44acab1abf49c95458110'">
		    		<td class="td1"><div class="shu">8</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='e857442201a44acab1abf49c95458110' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610211643u6Ync1IPZcKJJ2owyXLMc5XVKmCZ6O.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《孔雀飞来》</h5>
		    				<h6>虹桥社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610211643u6Ync1IPZcKJJ2owyXLMc5XVKmCZ6O.png@200w','e857442201a44acab1abf49c95458110')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=6c4e8d2a44f744f2a82522f5b3e47fbc'">
		    		<td class="td1"><div class="shu">9</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='6c4e8d2a44f744f2a82522f5b3e47fbc' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016103193621FoDaFstuiB4gVVU7QCDvYGsOj8vtlm.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《黎乡笠影》</h5>
		    				<h6>宜川社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016103193621FoDaFstuiB4gVVU7QCDvYGsOj8vtlm.png@200w','6c4e8d2a44f744f2a82522f5b3e47fbc')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=236c5c626d3f454299bcb3a93caaced8'">
		    		<td class="td1"><div class="shu">10</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='236c5c626d3f454299bcb3a93caaced8' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102114375G8urMRdeAmpP7sp3NJrfO9E3mbXZc9.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《妈妈咪呀》</h5>
		    				<h6>嘉兴社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102114375G8urMRdeAmpP7sp3NJrfO9E3mbXZc9.jpg@200w','236c5c626d3f454299bcb3a93caaced8')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=ee2e774bc48f475bb82f849b88614f1b'">
		    		<td class="td1"><div class="shu">11</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='ee2e774bc48f475bb82f849b88614f1b' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027115163NWqyyoF1PsZk0cMSPdrnKhnExx0VE.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《蒙古风韵》</h5>
		    				<h6>湖南社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027115163NWqyyoF1PsZk0cMSPdrnKhnExx0VE.png@200w','ee2e774bc48f475bb82f849b88614f1b')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=b2586d05f99d4db8879a6880517aae97'">
		    		<td class="td1"><div class="shu">12</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='b2586d05f99d4db8879a6880517aae97' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102810232Deqypo1Lw9jLyeYlcS9mFKreZxQa1I.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《茉莉芬芳》</h5>
		    				<h6>瑞金二路街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102810232Deqypo1Lw9jLyeYlcS9mFKreZxQa1I.jpg@200w','b2586d05f99d4db8879a6880517aae97')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=1d434889d25249e1823c8d839000710c'">
		    		<td class="td1"><div class="shu">13</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='1d434889d25249e1823c8d839000710c' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028115346YPZMmxdHmTZj6YKBkjlPjrmFhGrg9G.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《亲情电话》</h5>
		    				<h6>嘉定工业社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028115346YPZMmxdHmTZj6YKBkjlPjrmFhGrg9G.jpg@200w','1d434889d25249e1823c8d839000710c')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=f655468360c448acbe895cd9dde2d20a'">
		    		<td class="td1"><div class="shu">14</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='f655468360c448acbe895cd9dde2d20a' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102893947ff94oxE0FRnKhSj5VTRrWIVVgRkyRs.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《天边》</h5>
		    				<h6>五里桥社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102893947ff94oxE0FRnKhSj5VTRrWIVVgRkyRs.jpg@200w','f655468360c448acbe895cd9dde2d20a')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=731064e8b76d4e0ea81536d68507563e'">
		    		<td class="td1"><div class="shu">15</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='731064e8b76d4e0ea81536d68507563e' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102810369ubdPljhDzFgIbKWDRgoxKnXwuKX9P4.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《袖舞新蕊》</h5>
		    				<h6>淮海中路社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102810369ubdPljhDzFgIbKWDRgoxKnXwuKX9P4.jpg@200w','731064e8b76d4e0ea81536d68507563e')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=b45deb8a4ff74053975117f2d539bd2d'">
		    		<td class="td1"><div class="shu">16</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='b45deb8a4ff74053975117f2d539bd2d' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025144917HersX8CRKW9gD50Mx1SijBy1dU4ghp.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《绣画织梦》</h5>
		    				<h6>高境镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025144917HersX8CRKW9gD50Mx1SijBy1dU4ghp.png@200w','b45deb8a4ff74053975117f2d539bd2d')
		    	</script>
		    </table>
		    <table class="deresultList">
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=75f63a7b4ecb48c88e0d7d0831825698'">
		    		<td class="td1"><div class="shu">1</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='75f63a7b4ecb48c88e0d7d0831825698' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028821309odNnDklJOEfh7xG1liSQSqMqHIpVl.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《乘胜进军》</h5>
		    				<h6>友谊社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028821309odNnDklJOEfh7xG1liSQSqMqHIpVl.jpg@200w','75f63a7b4ecb48c88e0d7d0831825698')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=b51055de4c18467c8aa36e0ce56497de'">
		    		<td class="td1"><div class="shu">2</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='b51055de4c18467c8aa36e0ce56497de' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024135915Zz3LFl8iqILxQmOfzShv9THTQZqefq.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《大海啊！故乡》</h5>
		    				<h6>浦江镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024135915Zz3LFl8iqILxQmOfzShv9THTQZqefq.jpg@200w','b51055de4c18467c8aa36e0ce56497de')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=a5fd424e28a34d4da52c74293399954e'">
		    		<td class="td1"><div class="shu">3</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='a5fd424e28a34d4da52c74293399954e' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102714556Kp9apzmA91r6qzME3x0nd1rrkFIoY2.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《灯光》</h5>
		    				<h6>大宁社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102714556Kp9apzmA91r6qzME3x0nd1rrkFIoY2.png@200w','a5fd424e28a34d4da52c74293399954e')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=832cebe31bc94271905168b0314b457b'">
		    		<td class="td1"><div class="shu">4</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='832cebe31bc94271905168b0314b457b' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021111538PRo65U4gIqLpl5I5C5zx312PTTEHGT.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《告别》</h5>
		    				<h6>四平社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021111538PRo65U4gIqLpl5I5C5zx312PTTEHGT.jpg@200w','832cebe31bc94271905168b0314b457b')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=e7c3196bf0f44ff8828e6ab317a23434'">
		    		<td class="td1"><div class="shu">5</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='e7c3196bf0f44ff8828e6ab317a23434' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610289141tWZFjdO47jATo7S1aL0L3DGkEPpZVv.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《黄水谣》</h5>
		    				<h6>石化街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610289141tWZFjdO47jATo7S1aL0L3DGkEPpZVv.png@200w','e7c3196bf0f44ff8828e6ab317a23434')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=e8ee4b4c1208488cb1cc954fa90cb1dd'">
		    		<td class="td1"><div class="shu">6</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='e8ee4b4c1208488cb1cc954fa90cb1dd' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021915253OYsh1sv108BW6l8qxx3MtFvNEWjOi.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《菊花台》</h5>
		    				<h6>延吉社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021915253OYsh1sv108BW6l8qxx3MtFvNEWjOi.png@200w','e8ee4b4c1208488cb1cc954fa90cb1dd')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=d80b8ff0469545d6987f8ea13238acd1'">
		    		<td class="td1"><div class="shu">7</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='d80b8ff0469545d6987f8ea13238acd1' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027113841Cs9DEMDZI31TyMcRR3ZYvpbUHC1dCV.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《跨越》</h5>
		    				<h6>真新社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027113841Cs9DEMDZI31TyMcRR3ZYvpbUHC1dCV.png@200w','d80b8ff0469545d6987f8ea13238acd1')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=67e570bef5d1444c85b204c6e95b4612'">
		    		<td class="td1"><div class="shu">8</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='67e570bef5d1444c85b204c6e95b4612' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027111926MPN1OID3pFDv2jEUcyE9GWC0l5pi1W.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《你是这样的人》</h5>
		    				<h6>江宁路社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027111926MPN1OID3pFDv2jEUcyE9GWC0l5pi1W.png@200w','67e570bef5d1444c85b204c6e95b4612')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=c46ab9f52f8f42aea8aa7505497e295d'">
		    		<td class="td1"><div class="shu">9</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='c46ab9f52f8f42aea8aa7505497e295d' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024151550v5vGX9UriCNr8rUxaaDq5yPlettldz.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《葡萄园夜曲》</h5>
		    				<h6>莘庄镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024151550v5vGX9UriCNr8rUxaaDq5yPlettldz.jpg@200w','c46ab9f52f8f42aea8aa7505497e295d')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=910ceb17159d4f1fbcba2c4861d8226d'">
		    		<td class="td1"><div class="shu">10</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='910ceb17159d4f1fbcba2c4861d8226d' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102714352C7Q1YyGXKMwgJ0GUjz6wGKwBqt8Nyo.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《葡萄园夜曲》</h5>
		    				<h6>徐家汇街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102714352C7Q1YyGXKMwgJ0GUjz6wGKwBqt8Nyo.png@200w','910ceb17159d4f1fbcba2c4861d8226d')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=1e5a2e8bf8ca4065b9506d96562a5865'">
		    		<td class="td1"><div class="shu">11</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='1e5a2e8bf8ca4065b9506d96562a5865' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028115234vrV1Cg44dloDDXefWwIgFAWepx7VRd.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《沁园春 雪》</h5>
		    				<h6>宝山社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028115234vrV1Cg44dloDDXefWwIgFAWepx7VRd.png@200w','1e5a2e8bf8ca4065b9506d96562a5865')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=698f1d704ce940b0b18f0a221a7b5529'">
		    		<td class="td1"><div class="shu">12</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='698f1d704ce940b0b18f0a221a7b5529' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/sshj.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《十送红军》</h5>
		    				<h6>庙行镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/sshj.jpg@200w','698f1d704ce940b0b18f0a221a7b5529')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=5a48221ac4044c4e8dd8c1c750425274'">
		    		<td class="td1"><div class="shu">13</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='5a48221ac4044c4e8dd8c1c750425274' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016103193737LkyZNsdix9GQypENLtclItg79ZoAy5.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《十送红军》</h5>
		    				<h6>曹杨社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016103193737LkyZNsdix9GQypENLtclItg79ZoAy5.png@200w','5a48221ac4044c4e8dd8c1c750425274')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=23d2d390840847cc87f231f6d37d8b0f'">
		    		<td class="td1"><div class="shu">14</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='23d2d390840847cc87f231f6d37d8b0f' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610251042285tzCXFZaKoFxwVdTIL2hugtoV8JFlq.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《忆秦娥·娄山关》、《草原夜色美》</h5>
		    				<h6>吴淞社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610251042285tzCXFZaKoFxwVdTIL2hugtoV8JFlq.jpg@200w','23d2d390840847cc87f231f6d37d8b0f')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=0e372144d2294f5992e63e66060efede'">
		    		<td class="td1"><div class="shu">15</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='0e372144d2294f5992e63e66060efede' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026202550RRUwZi26LPsS8lBBFjfYLQmtq5NAwR.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《游子情思》</h5>
		    				<h6>高行镇文广服务中心</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026202550RRUwZi26LPsS8lBBFjfYLQmtq5NAwR.png@200w','0e372144d2294f5992e63e66060efede')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=abe22b20df2a44ff80cf2d6cb53c1f13'">
		    		<td class="td1"><div class="shu">16</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='abe22b20df2a44ff80cf2d6cb53c1f13' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026174059MYTjNG2xNoZKNAnOtSClZfUXzc4yW0.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《致音乐》</h5>
		    				<h6>古美社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026174059MYTjNG2xNoZKNAnOtSClZfUXzc4yW0.png@200w','abe22b20df2a44ff80cf2d6cb53c1f13')
		    	</script>
		    </table>
		    <table class="deresultList">
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=2dd121e425304ebfab529cab9115858a'">
		    		<td class="td1"><div class="shu">1</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='2dd121e425304ebfab529cab9115858a' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031101736VDcGkUgxIsOuvjRgQfo0tVvBRqo6xC.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《“妙”纸生花》</h5>
		    				<h6>长征社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031101736VDcGkUgxIsOuvjRgQfo0tVvBRqo6xC.png@200w','2dd121e425304ebfab529cab9115858a')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=879dee57933944159bf2cdc3784cd784'">
		    		<td class="td1"><div class="shu">2</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='879dee57933944159bf2cdc3784cd784' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027175724QXJK3IsnJvRekq16naZUzganbsaqM0.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《春色满堂》</h5>
		    				<h6>斜土街道</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161027175724QXJK3IsnJvRekq16naZUzganbsaqM0.png@200w','879dee57933944159bf2cdc3784cd784')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=373494e4572e4356ac24f29bf642eba5'">
		    		<td class="td1"><div class="shu">3</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='373494e4572e4356ac24f29bf642eba5' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026161555jfs1pxDfZ6IFCYtASaF30063FJS0cY.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《都市风云》</h5>
		    				<h6>梅陇镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026161555jfs1pxDfZ6IFCYtASaF30063FJS0cY.png@200w','373494e4572e4356ac24f29bf642eba5')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=28df067974f44af396642a71836b97e7'">
		    		<td class="td1"><div class="shu">4</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='28df067974f44af396642a71836b97e7' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031142951sfbH4ujtAolqeH6vnPECCOd7AtgveK.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《红叶绽放》</h5>
		    				<h6>殷行社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031142951sfbH4ujtAolqeH6vnPECCOd7AtgveK.jpg@200w','28df067974f44af396642a71836b97e7')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=3d0db63e30534f20bad121def41c49e8'">
		    		<td class="td1"><div class="shu">5</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='3d0db63e30534f20bad121def41c49e8' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610241325382UUTWl60bExSLe2ElThE2rVrlrywTE.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《家乡美》</h5>
		    				<h6>青村镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610241325382UUTWl60bExSLe2ElThE2rVrlrywTE.jpg@200w','3d0db63e30534f20bad121def41c49e8')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=e93c900e77da48a39590bbc2fc24d618'">
		    		<td class="td1"><div class="shu">6</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='e93c900e77da48a39590bbc2fc24d618' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028115147SS34xWY4PY26RdgYKW8SHSj3pqgPcA.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《锦绣三林》</h5>
		    				<h6>三林镇</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028115147SS34xWY4PY26RdgYKW8SHSj3pqgPcA.png@200w','e93c900e77da48a39590bbc2fc24d618')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=4218e2940d074a36ba01a17fc52c1fb3'">
		    		<td class="td1"><div class="shu">7</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='4218e2940d074a36ba01a17fc52c1fb3' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031143918B20GzJmr12KxF76aEHvhaeSg1wjzvT.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《茉莉花》</h5>
		    				<h6>江浦社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031143918B20GzJmr12KxF76aEHvhaeSg1wjzvT.jpg@200w','4218e2940d074a36ba01a17fc52c1fb3')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=ff62e4c6e34a4cbe8d89785c723ab316'">
		    		<td class="td1"><div class="shu">8</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='ff62e4c6e34a4cbe8d89785c723ab316' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025161552qLxrw2i2X7DEQ4N9TrBjixxfUKLNhm.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《旗袍演变》</h5>
		    				<h6>七宝镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025161552qLxrw2i2X7DEQ4N9TrBjixxfUKLNhm.png@200w','ff62e4c6e34a4cbe8d89785c723ab316')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=d44df61177924b5989b7fa7f663a3313'">
		    		<td class="td1"><div class="shu">9</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='d44df61177924b5989b7fa7f663a3313' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102595831e2TizvpOCYIpL5mecPNrrRIHzS6g32.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《三月桃花》</h5>
		    				<h6>金杨社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102595831e2TizvpOCYIpL5mecPNrrRIHzS6g32.jpg@200w','d44df61177924b5989b7fa7f663a3313')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=f0df5a1aac1343d8a593380be58b5709'">
		    		<td class="td1"><div class="shu">10</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='f0df5a1aac1343d8a593380be58b5709' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102899381l2Kh1J1yKLu4J5XgwTCMd8BPBmthA.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《时尚雅韵》</h5>
		    				<h6>五里桥社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102899381l2Kh1J1yKLu4J5XgwTCMd8BPBmthA.jpg@200w','f0df5a1aac1343d8a593380be58b5709')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=15d0efb3b93c4a2c96b9509d78cac689'">
		    		<td class="td1"><div class="shu">11</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='15d0efb3b93c4a2c96b9509d78cac689' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610261559252aW5ZaveKacb3T9XmkRQK2PwXRjJ3I.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《舞动精彩》</h5>
		    				<h6>浦兴社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610261559252aW5ZaveKacb3T9XmkRQK2PwXRjJ3I.png@200w','15d0efb3b93c4a2c96b9509d78cac689')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=a3ebd6bc41ff4f0c937eeeb767f00672'">
		    		<td class="td1"><div class="shu">12</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='a3ebd6bc41ff4f0c937eeeb767f00672' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028151029fWNUofyJTdLRMSZECT1h0oFTEm6F7r.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《西湖晚秋》</h5>
		    				<h6>周浦镇</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028151029fWNUofyJTdLRMSZECT1h0oFTEm6F7r.png@200w','a3ebd6bc41ff4f0c937eeeb767f00672')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=1af96245d1384ea48ac26a182ead7633'">
		    		<td class="td1"><div class="shu">13</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='1af96245d1384ea48ac26a182ead7633' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610211418335EXe36RlGJd7J09pHhOY3J6QYnz6n5.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《向着儒香生长》</h5>
		    				<h6>金汇镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610211418335EXe36RlGJd7J09pHhOY3J6QYnz6n5.jpg@200w','1af96245d1384ea48ac26a182ead7633')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=89c1ea5d9a5e4bcf9bb54bca6ceba5e2'">
		    		<td class="td1"><div class="shu">14</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='89c1ea5d9a5e4bcf9bb54bca6ceba5e2' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028102254cKlY30dygOKNrwV74aYtYBuG0sQqRP.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《馨悦夕阳》</h5>
		    				<h6>九亭镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028102254cKlY30dygOKNrwV74aYtYBuG0sQqRP.png@200w','89c1ea5d9a5e4bcf9bb54bca6ceba5e2')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=75ca9131766f4edc9814b7bd7781f672'">
		    		<td class="td1"><div class="shu">15</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='75ca9131766f4edc9814b7bd7781f672' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026135951zPsmPluLM1sJNULVq4mZsXhddba77g.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《醉爱金山》</h5>
		    				<h6>石化街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026135951zPsmPluLM1sJNULVq4mZsXhddba77g.png@200w','75ca9131766f4edc9814b7bd7781f672')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=35241c88198840caab8ac7869e794222'">
		    		<td class="td1"><div class="shu">16</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='35241c88198840caab8ac7869e794222' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102114231wCduI8a7CCoqOVAEtOPglcCH4Tss01.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>时装走秀《花样年华》</h5>
		    				<h6>天山社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102114231wCduI8a7CCoqOVAEtOPglcCH4Tss01.jpg@200w','35241c88198840caab8ac7869e794222')
		    	</script>
		    </table>
		    <table class="deresultList">
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=d94dfb1de41641778dd86cc378850eb0'">
		    		<td class="td1"><div class="shu">1</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='d94dfb1de41641778dd86cc378850eb0' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028169164AGVa5n9FL0vk3FGtacWpA8kYcu50J.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《春香传》</h5>
		    				<h6>罗店镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028169164AGVa5n9FL0vk3FGtacWpA8kYcu50J.png@200w','d94dfb1de41641778dd86cc378850eb0')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=672353aa5b8e4ef19c7890de1e8bb50a'">
		    		<td class="td1"><div class="shu">2</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='672353aa5b8e4ef19c7890de1e8bb50a' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028173241LPjDMq0zfZ264DQAAH9PzcQ9uc9L2n.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《大雷雨》选段《人盼成双》</h5>
		    				<h6>岳阳街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028173241LPjDMq0zfZ264DQAAH9PzcQ9uc9L2n.png@200w','672353aa5b8e4ef19c7890de1e8bb50a')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=ad640ee412c443afaaae4c90e1df7091'">
		    		<td class="td1"><div class="shu">3</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='ad640ee412c443afaaae4c90e1df7091' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028109108ldIbMC9fkYxMxoSXAHEqm5fFTNDnW.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《蝶恋》</h5>
		    				<h6>中山街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161028109108ldIbMC9fkYxMxoSXAHEqm5fFTNDnW.png@200w','ad640ee412c443afaaae4c90e1df7091')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=ae1ac3cbdd384409889f92a3f02dbdb4'">
		    		<td class="td1"><div class="shu">4</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='ae1ac3cbdd384409889f92a3f02dbdb4' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026173563mtNrmR05pyxvd7TR0hi75qpwv5V0z.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《共产党员时刻听从党召唤》</h5>
		    				<h6>北站社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161026173563mtNrmR05pyxvd7TR0hi75qpwv5V0z.png@200w','ae1ac3cbdd384409889f92a3f02dbdb4')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=63441f32b3b54e15ae4bc6005e724f98'">
		    		<td class="td1"><div class="shu">5</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='63441f32b3b54e15ae4bc6005e724f98' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610281143568iMBNUpE4ECy9Tu3FkuS9qiB363TF9.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《画女情--离别》</h5>
		    				<h6>永丰街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201610281143568iMBNUpE4ECy9Tu3FkuS9qiB363TF9.png@200w','63441f32b3b54e15ae4bc6005e724f98')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=a0d8514e39474e8b8c6727ea9104693c'">
		    		<td class="td1"><div class="shu">6</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='a0d8514e39474e8b8c6727ea9104693c' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102414360el3D56cEcWt1Ewwnm2fZptGExrrlnW.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《决不能把共产党人党性抛开》</h5>
		    				<h6>仙霞社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102414360el3D56cEcWt1Ewwnm2fZptGExrrlnW.png@200w','a0d8514e39474e8b8c6727ea9104693c')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=f36fd69473b64d899bc6c0d05fb93fb6'">
		    		<td class="td1"><div class="shu">7</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='f36fd69473b64d899bc6c0d05fb93fb6' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021141315qjz88JKhhWpCCORkqcqIoENF6p1AD9.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《芦荡火种·智斗》</h5>
		    				<h6>周家渡街道</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021141315qjz88JKhhWpCCORkqcqIoENF6p1AD9.jpg@200w','f36fd69473b64d899bc6c0d05fb93fb6')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=d1497e95bf044b8a852bde35a2c0a1a6'">
		    		<td class="td1"><div class="shu">8</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='d1497e95bf044b8a852bde35a2c0a1a6' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102716446UhlxJxijA8Qt1YIgldPQdwZzTH5hpP.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《三娘教子》</h5>
		    				<h6>彭浦新村社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102716446UhlxJxijA8Qt1YIgldPQdwZzTH5hpP.png@200w','d1497e95bf044b8a852bde35a2c0a1a6')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=f0dfb3512b384f1ba095c1ae5ff5a77e'">
		    		<td class="td1"><div class="shu">9</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='f0dfb3512b384f1ba095c1ae5ff5a77e' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031142753hv8hTLqIif4oUjQyCg43jFyxaLbVIe.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《天女散花》</h5>
		    				<h6>华阳社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161031142753hv8hTLqIif4oUjQyCg43jFyxaLbVIe.jpg@200w','f0dfb3512b384f1ba095c1ae5ff5a77e')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=fc02d59064bc484caf0a0b90330e747e'">
		    		<td class="td1"><div class="shu">10</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='fc02d59064bc484caf0a0b90330e747e' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024104757catpQZLqDoRUDNRxcfIhLT3Wfi5WLS.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>《小池塘里荷花开》</h5>
		    				<h6>练塘社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024104757catpQZLqDoRUDNRxcfIhLT3Wfi5WLS.jpg@200w','fc02d59064bc484caf0a0b90330e747e')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=da3f08c8d2b840719ee28cd5895f1547'">
		    		<td class="td1"><div class="shu">11</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='da3f08c8d2b840719ee28cd5895f1547' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025153725AbUFzn7ieD8uY325lqDSvXLGAuXsef.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>红灯记选段《刑场母子同心》</h5>
		    				<h6>徐家汇街道社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161025153725AbUFzn7ieD8uY325lqDSvXLGAuXsef.png@200w','da3f08c8d2b840719ee28cd5895f1547')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=1e40ddb16509497b9a28fa6845a383c7'">
		    		<td class="td1"><div class="shu">12</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='1e40ddb16509497b9a28fa6845a383c7' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102514048l293C8G1W0Kkm7Ntvc4Ur1QHxqjP1n.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>沪剧《金绣娘》“巧斗老板鸭”</h5>
		    				<h6>马桥镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102514048l293C8G1W0Kkm7Ntvc4Ur1QHxqjP1n.jpg@200w','1e40ddb16509497b9a28fa6845a383c7')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=353d1536f14144a3b662a93a45730acb'">
		    		<td class="td1"><div class="shu">13</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='353d1536f14144a3b662a93a45730acb' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024152748M4m08vpysK3geHGmhp56fanQutnFSD.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>越剧《春香传.爱歌》</h5>
		    				<h6>虹桥镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161024152748M4m08vpysK3geHGmhp56fanQutnFSD.png@200w','353d1536f14144a3b662a93a45730acb')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=692bfc09acfe4b81be01a6320de304fa'">
		    		<td class="td1"><div class="shu">14</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='692bfc09acfe4b81be01a6320de304fa' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021154055pYZwSksgpnIMjLPvquVDWcIJsQrt9F.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>越剧《情探》</h5>
		    				<h6>天山社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021154055pYZwSksgpnIMjLPvquVDWcIJsQrt9F.jpg@200w','692bfc09acfe4b81be01a6320de304fa')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=d83009a8a2a24922b8f6d357e3afd596'">
		    		<td class="td1"><div class="shu">15</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='d83009a8a2a24922b8f6d357e3afd596' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102816656wgHc2VJYTWZeN9rejkfySr6G8cErrD.png@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>越剧《十八相送》</h5>
		    				<h6>宜川社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2016102816656wgHc2VJYTWZeN9rejkfySr6G8cErrD.png@200w','d83009a8a2a24922b8f6d357e3afd596')
		    	</script>
		    	<tr onclick="location.href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId=310ffd1f238641f0ad65d525fa8c9200'">
		    		<td class="td1"><div class="shu">16</div></td>
		    		<td class="td2">
		    			<div class="pic" style='display:block;width:141px;height:105px;overflow:hidden;position:relative;'>
		    				<img videoId='310ffd1f238641f0ad65d525fa8c9200' src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021125318mMbJMYZ0C3HvGaYKKLHYOBUoFUOb0w.jpg@200w">
		    			</div>
		    		</td>
		    		<td class="td3">
		    			<div class="char">
		    				<h5>赵君祥买囡《五更乱梦》</h5>
		    				<h6>五角场镇社区</h6>
		    			</div>
		    		</td>
		    		<td class="td4"><img src="${path}/STATIC/wxStatic/image/delivery/pic11.png"></td>
		    	</tr>
		    	<script type="text/javascript">
		    		reloadImg('http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021125318mMbJMYZ0C3HvGaYKKLHYOBUoFUOb0w.jpg@200w','310ffd1f238641f0ad65d525fa8c9200')
		    	</script>
		    </table>
	    </div>
	    
	    <div class="defoot">
	    	<div class="jz710">此活动最终解释权归上海市群众艺术馆所有<br>主办方：上海市群众艺术馆    上海市东方公共文化配送中心（筹）</div>
	    </div>
	
	    <!-- 回到顶部 -->
	    <img class="hdtop" src="${path}/STATIC/wxStatic/image/delivery/top.png">
	    <!-- 规则 -->
	    <div class="derule">
	    	<div class="derule_nc">
		    	<div class="jz690">
		    		<div class="tit"><span style="font-size:25px;">#</span>&nbsp;&nbsp;&nbsp;&nbsp;评选规则&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:25px;">#</span></div>
		    		<div class="cont">
		    			<div class="item">
			    			<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">活动简介</p>
			    			<p>上海市社区文艺指导员教学成果展演大众投票环节</p>
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">大众投票日期</p>
		    				<p>2016年  11月8日00:00—11月17日17:00</p>
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">展演名单公示日期</p>
		    				<p>2016年11月18日20:00</p>
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">评比方式</p>
		    				<p>1）由<span class="liang">专家评审</span>和<span class="liang">大众投票</span>两部分组成。</p>
							<p>2）专家对节目打分占总得分的<span class="liang">80%</span>。</p>
							<p>3）市民通过“文化云—市民投票通道”进行投票，投票数占总得分的<span class="liang">20%</span>。</p>
							<p>4）舞蹈、时装、合唱、戏曲/曲艺四大门类前十六名入围展演活动。</p>	
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">投票方式</p>
		    				<p>1）每个用户（同一ID）每天对每一个作品只能投一票。</p>
		    				<p>2）用户首次投票将有机会参与“文化云抽奖活动”，输入手机号码参与成功即进入抽奖数据库，活动将抽出10名幸运用户，每人获得“传统文化大礼包一份”。</p>
		    				<p>3）中奖名单于11月20日在文化云微信公众平台上公布，请提前关注文化云官方微信公众号。</p>
		    				<p>4）用户首次投票将被奖励文化云100积分，之后的每次投票成功将被奖励1积分，可累积不封顶。</p>
		    				<p>5）用户可以进入“文化云”--“个人中心”中查看并使用积分。</p>
		    			</div>
		    			<div class="item"><p>本活动禁止任何手段的恶意刷票或作弊行为，一经发现，取消活动资格及所获奖励。<br><br>此规则最终解释权归上海市群众艺术馆和文化云所有！</p></div>
		    		</div>
		    	</div>
		    	
		    </div>
		    <div class="zhidaol_wc"><div class="zhidaol">我知道了</div></div>
	    </div>
	</div>
</body>
</html>