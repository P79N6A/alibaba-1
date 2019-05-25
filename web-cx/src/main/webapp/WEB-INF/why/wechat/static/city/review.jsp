<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·邀你一起打造上海城市名片</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		var cityType;	//本次活动编号
		var startIndex = 0;		//页数
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云·邀你一起打造上海城市名片';
	    	appShareDesc = '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg';
	    	
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
				jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·邀你一起打造上海城市名片",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
			});
		}
		
		$(function () {
			//swiper初始化div
		    initSwiper();
			
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
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
		
		//最新照片
		function loadCityImg(index, pagesize){
			if(cityType == 0){	//最美城市
				$.post("${path}/wechatStatic/getBeautycityImgRankingList.do", function (data) {
					if (data.status == 1) {
						$("#loadingCityImgDiv").html("");
						$.each(data.data, function (i, dom) {
							var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
							var ImgObj = new Image();
							ImgObj.src = dom.beautycityImgUrl+"@400w";
							ImgObj.onload = function(){
								if(ImgObj.width/ImgObj.height>310/280){
									var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
									$("img[beautycityImgId="+dom.beautycityImgId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
								}else{
									var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
									$("img[beautycityImgId="+dom.beautycityImgId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
								}
							}
							$("#cityImgUl3").append("<li>" +
										                "<div class='char'>" +
									                        "<div class='nc clearfix'>" +
									                            "<div class='t1'>"+userHeadImgHtml+"</div>" +
									                            "<div class='t2'>" +
									                                "<h6>"+dom.userName+"</h6>" +
									                            "</div>" +
									                        "</div>" +
									                    "</div>" +
									                    "<div class='pic'>" +
									                        "<img beautycityImgId='"+dom.beautycityImgId+"' src='"+dom.beautycityImgUrl+"@400w' onclick='previewImg(\""+dom.beautycityImgUrl+"\",\""+dom.beautycityImgUrl+"\");'>" +
									                    "</div>" +
									                "</li>");
						});
					}
				},"json");
			}else{
				var data = {
					cityType: cityType,
	            	firstResult: index,
	               	rows: pagesize
	            };
				$.post("${path}/wechatFunction/queryCityImgList.do",data, function (data) {
					if(data.length<20){
	        			$("#loadingCityImgDiv").html("");
		        	}
					if(data.length>0){
						$.each(data, function (i, dom) {
							var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
							var ImgObj = new Image();
							ImgObj.src = dom.cityImgUrl.split(";")[0]+"@400w";
							ImgObj.onload = function(){
								if(ImgObj.width/ImgObj.height>310/280){
									var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
									$("img[cityImgId="+dom.cityImgId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
								}else{
									var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
									$("img[cityImgId="+dom.cityImgId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
								}
							}
							$("#cityImgUl3").append("<li>" +
										                "<div class='char'>" +
									                        "<div class='nc clearfix'>" +
									                            "<div class='t1'>"+userHeadImgHtml+"</div>" +
									                            "<div class='t2'>" +
									                                "<h6>"+dom.userName+"</h6>" +
									                                "<p>"+dom.cityImgContent+"</p>" +
									                            "</div>" +
									                        "</div>" +
									                    "</div>" +
									                    "<div class='pic'>" +
									                        "<img cityImgId='"+dom.cityImgId+"' src='"+dom.cityImgUrl.split(";")[0]+"@400w' onclick='previewImg(\""+dom.cityImgUrl.split(";")[0]+"\",\""+dom.cityImgUrl+"\");'>" +
									                    "</div>" +
									                "</li>");
						});
					}
				},"json");
			}
		}
		
		//精选照片
		function loadSelectImg(cityImgIds,position){
			if(position == 1){
				$("#module1").show();
			}else if(position == 2){
				$("#module2").show();
			}
			var data = {
				cityType: cityType,
            	userId: userId,
            	cityImgIds: cityImgIds
            };
			$.post("${path}/wechatFunction/querySelectCityImgList.do",data, function (data) {
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var ImgObj = new Image();
						ImgObj.src = dom.cityImgUrl.split(";")[0]+"@700w";
						ImgObj.onload = function(){
							if(ImgObj.width/ImgObj.height>645/300){
								var pLeft = (ImgObj.width*(300/ImgObj.height)-645)/2;
								$("img[cityImgId=select-"+dom.cityImgId+"]").css({"height":"300px","position":"absolute","left":"-"+pLeft+"px"});
							}else{
								var pTop = (ImgObj.height*(645/ImgObj.width)-300)/2;
								$("img[cityImgId=select-"+dom.cityImgId+"]").css({"width":"645px","position":"absolute","top":"-"+pTop+"px"});
							}
						}
						var tagHtml = "";
						if(position == 1){
							tagHtml = "<div class='biao hong'><span>最美</span></div>";
						}else{
							tagHtml = "<div class='biao lan'><span>"+(eval(i)+1)+"</span></div>";
						}
						$("#cityImgUl"+position).append("<li>" +
											                "<div class='toux clearfix'>" +
										                        "<div class='t1'>"+userHeadImgHtml+"</div>" +
										                        "<div class='t2'>" +
											                        "<h6>"+dom.userName+"</h6>" +
									                                "<p>"+dom.cityImgContent+"</p>" +
										                        "</div>" +
										                    "</div>" +
										                    "<div class='pic'>" +
										                    	"<img cityImgId='select-"+dom.cityImgId+"' src='"+dom.cityImgUrl.split(";")[0]+"@700w' onclick='previewImg(\""+dom.cityImgUrl.split(";")[0]+"\",\""+dom.cityImgUrl+"\");'>" +
										                        "<div class='fu clearfix'>" +
										                            "<div class='f2 current'><span></span>"+dom.voteCount+"</div>" +
										                        "</div>" +
										                    "</div>" +
										                    tagHtml +
										                "</li>");
					});
				}
			},"json");
		}
		
		//切换列表
		function changeItem(type,$this){
			cityType = type;
			$("#reviewTitle").html($this.find("p").text());
			$("#reviewSubtitle").html($this.find("span").text());
			loadCityImg(0,20);
			if(cityType == 1){	//我与艺术天空
				//最美空间
				loadSelectImg('f229b30f717049baa09b82e11271bda3',1);
				//月度之星
				loadSelectImg('a745c428b9fe4d0198f2efa0217dda31,64edb58f67ba40d5b2fec88b83efcee8,cc99152ef89d4c4191ffe82d3c186798,3a2bf30ca04c4646979c99b2f4b88571,8a01d4e2eee24c908fa875188936069a',2);
			}else if(cityType == 2){	//我与轻歌曼舞
				//最美空间
				loadSelectImg('ecfbf1812656418f9a057b4352e56709',1);
				//月度之星
				loadSelectImg('a6b25928196c41588b0e3d8320341575,e2471af2cf1f4120baa192944d7559eb,79c8ab7fd82a4c02a662b86b6ecf636e,e89c4e05f5e740549c19a1e4dea96ceb,b2b0b1acfb414f9ab501c9ed9f7daeec',2);
			}else if(cityType == 3){	//我与长宁艺术
				//最美空间
				loadSelectImg('63ea1af31c4e4565a02ecadc962ae307',1);
				//月度之星
				loadSelectImg('9d010819a34a43e5af7b9392d684e33f,11493de9cb70482d984775b354cf9295,421752f6576a45b58e7c38b7addd0cd6,012ef03392284457b029fd7684b5d567,6451101ca22e4dd48351c8e17ce7ec4c',2);
			}else if(cityType == 4){	//春季花开 香飘沪江
				//最美空间
				loadSelectImg('2117598e397e482db07a661287d1f07d',1);
				//月度之星
				loadSelectImg('84304d74fd45452d8f175b0752c87fbb,f444c3c8d8ef48b78525f1beb50d5319,19924395cbd3465db8dce74d13ed1f4f,759871eb973a466b9929d1dfe81d731f,04de41f36e224e6a8ea0e0d6c521057e',2);
			}else if(cityType == 5){	//阳光媚 踏春游
				//最美空间
				loadSelectImg('34f062b67fe6475a8a8098d8413e02b1',1);
				//月度之星
				loadSelectImg('b75734a44012404083f76e7e72eabd9c,dd8e1a5283d44e83b7272d0a5067bf28,eca83027e75e478ea77927abcc4f1f87,4ed86ebfe37d4656a1c7203599b3bc73,6e1ef2c0260449d484e9be23bc685ab7',2);
			}else if(cityType == 6){	//城市印象 文化空间
				//最美空间
				loadSelectImg('678050b0b36d4c05898bada6813e470c',1);
				//月度之星
				loadSelectImg('3a3bbb56a7a84ecdb46689039c2fb0d2,23140e244e084697ae1cc5c9acb8d88c,19749cb0f6e349688353af3030601dd3,f0e4ed4982c04829ad355af89b9f3e42,d1d225100cf145c5b1946d51ffdfd16a',2);
			}
			$('.roomage .wqhgList').hide();
	        $('.roomage .wqhgDetail').show();
		}
		
		//头像
		function getUserHeadImgHtml(userHeadImgUrl){
			var userHeadImgHtml = '';
			if(userHeadImgUrl){
                if(userHeadImgUrl.indexOf("http") == -1){
                	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                }
            }else{
            	userHeadImgUrl = '';
            }
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
            }
			return userHeadImgHtml;
		}
		
		// 导航固定
	    function navFixed(ele, type, topH) {
	        $(document).on(type, function() {
	            if($(document).scrollTop() > topH) {
	                ele.css('position', 'fixed');
	            } else {
	                ele.css('position', 'static');
	            }
	        });
	    }
		
	  	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 20)) {
            	if(cityType != 0){
            		setTimeout(function () { 
          				startIndex += 20;
                  		var index = startIndex;
                  		loadCityImg(index,20);
               		},500);
            	}
            }
        });
		
	</script>
	
	<style>
		html,body {height: 100%;}
		.roomage {min-height: 100%;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg"/></div>
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
	<div class="roomage">
		<div class="lccbanner">
			<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201761910580PO8neFr00YNFpdQh9scgaNJrKOc3wH.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatFunction/cityIndex.do?tab=1">首页</a></li>
				<li><a href="${path}/wechatFunction/cityRanking.do">排行榜</a></li>
				<li><a href="${path}/wechatFunction/cityRule.do">活动规则</a></li>
				<li class="current"><a href="${path}/wechatFunction/cityReview.do">往期回顾</a></li>
			</ul>
		</div>
		<div class="roomcont jz700"  style="background-color:transparent;">
	        <ul class="wqhgList">
	        	<li onclick="changeItem(6,$(this))">
	                <img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619133340g922w21SOxE4NST2GCPYIkL73Qm5df.jpg" width="700" height="220">
	                <div class="fu">
	                    <div>
	                        <p>城市印象 文化空间</p>
	                        <span>2017年5月回顾</span>
	                    </div>
	                </div>
	            </li>
	        	<li onclick="changeItem(5,$(this))">
	                <img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201758105211dEb9fABaIPzub4l3LHA7x1NGmIVpPO.jpg" width="700" height="220">
	                <div class="fu">
	                    <div>
	                        <p>阳光媚 踏春游</p>
	                        <span>2017年4月回顾</span>
	                    </div>
	                </div>
	            </li>
	        	<li onclick="changeItem(4,$(this))">
	                <img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732718622vRLkmosQorG9vOqHeucdw3r4tsPZCH.jpg" width="700" height="220">
	                <div class="fu">
	                    <div>
	                        <p>春季花开 香飘沪江</p>
	                        <span>2017年3月回顾</span>
	                    </div>
	                </div>
	            </li>
	        	<li onclick="changeItem(3,$(this))">
	                <img src="${path}/STATIC/wxStatic/image/roomage/pic19.jpg" width="700" height="220">
	                <div class="fu">
	                    <div>
	                        <p>我与长宁艺术</p>
	                        <span>2017年1月回顾</span>
	                    </div>
	                </div>
	            </li>
	        	<li onclick="changeItem(2,$(this))">
	                <img src="${path}/STATIC/wxStatic/image/roomage/pic18.jpg" width="700" height="220">
	                <div class="fu">
	                    <div>
	                        <p>我与轻歌曼舞</p>
	                        <span>2016年12月回顾</span>
	                    </div>
	                </div>
	            </li>
	        	<li onclick="changeItem(1,$(this))">
	                <img src="${path}/STATIC/wxStatic/image/roomage/pic14.jpg" width="700" height="220">
	                <div class="fu">
	                    <div>
	                        <p>我与艺术天空</p>
	                        <span>2016年11月回顾</span>
	                    </div>
	                </div>
	            </li>
	            <li onclick="changeItem(0,$(this))">
	                <img src="${path}/STATIC/wxStatic/image/roomage/pic15.jpg" width="700" height="220">
	                <div class="fu">
	                    <div>
	                        <p>城市空间·最美印象</p>
	                        <span>2016年10月回顾</span>
	                    </div>
	                </div>
	            </li>
	        </ul>
	        <div class="wqhgDetail">
                <div class="jinhaotit jz645" style="margin-bottom:0;border-bottom:none;padding-bottom:0;">
                    <div class="h1">#&nbsp;&nbsp;<span id="reviewTitle"></span>&nbsp;&nbsp;#</div>
                    <div class="h2"><span id="reviewSubtitle"></span></div>
                </div>
                
                <div id="module1" style="display: none;">
                	<div class="sytitxian_2">
		                <div><span>最美空间</span><em>获奖作品</em></div>
		            </div>
		            <ul id="cityImgUl1" class="roomOldUl jz645"></ul>
                </div>
                
                <div id="module2" style="display: none;">
                	<div class="sytitxian_2">
		                <div><span>月度之星</span><em>获奖作品</em></div>
		            </div>
		            <ul id="cityImgUl2" class="roomOldUl jz645"></ul>
                </div>
                
                <div id="module3">
                	<div class="sytitxian"><span>所有作品展示</span></div>
		            <ul id="cityImgUl3" class="syListUl clearfix"></ul>
		            <div id="loadingCityImgDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
                </div>
	        </div>
	    </div>
	</div>
</body>
</html>