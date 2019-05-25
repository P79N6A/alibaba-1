<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·重大品牌活动</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	
	<script>
		$.ajaxSettings.async = false; 	//同步执行ajax
		var relateId = sessionStorage.getItem('relateId');
		
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '重磅 乐山文化届盛事全攻略';
        	appShareDesc = '市级活动、区县品牌“一网打尽”，一册在手，上海重大文化节日不错过。';
        	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018480YJeco5HlWjOx9m1Vm3DBYrwpgWa2wh.jpg';
        	
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
					title: "重磅 乐山文化届盛事全攻略",
					desc: '市级活动、区县品牌“一网打尽”，一册在手，上海重大文化节日不错过。',
					link: '${basePath}wechatStatic/brandAct.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018480YJeco5HlWjOx9m1Vm3DBYrwpgWa2wh.jpg'
				});
				wx.onMenuShareTimeline({
					title: "重磅 乐山文化届盛事全攻略",
					link: '${basePath}wechatStatic/brandAct.do',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018480YJeco5HlWjOx9m1Vm3DBYrwpgWa2wh.jpg'
				});
				wx.onMenuShareQQ({
					title: "重磅 乐山文化届盛事全攻略",
					desc: '市级活动、区县品牌“一网打尽”，一册在手，上海重大文化节日不错过。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018480YJeco5HlWjOx9m1Vm3DBYrwpgWa2wh.jpg'
				});
				wx.onMenuShareWeibo({
					title: "重磅 乐山文化届盛事全攻略",
					desc: '市级活动、区县品牌“一网打尽”，一册在手，上海重大文化节日不错过。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018480YJeco5HlWjOx9m1Vm3DBYrwpgWa2wh.jpg'
				});
				wx.onMenuShareQZone({
					title: "重磅 乐山文化届盛事全攻略",
					desc: '市级活动、区县品牌“一网打尽”，一册在手，上海重大文化节日不错过。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018480YJeco5HlWjOx9m1Vm3DBYrwpgWa2wh.jpg'
				});
			});
		}
		
		$(function() {
			loadData();
			loadDataQx();
		});
		
		
		
		 function loadData(){
			$.post("${path}/wechatStatic/queryBrandAct.do",{actType:0},function(data){
				var li='<li style="padding: 20px 0;background-color: #fff;margin-bottom: 15px;">'+
							'<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732019285001xk4shLzc2fVoK5mJvEvm68ituyT5.jpg" />'+
						'</li>';
				$.each(data, function (i, dom) { 
					var actHtml = '';
					var imgSrcs = dom.imgSrc.split(',');
					if(imgSrcs.length==1){
							var tag = dom.actTag.split('|');
							var actTag ='';
							for(var j = 0;j<tag.length;j++){
								actTag =actTag+ '<li><p>'+tag[j]+'</p></li>';
							}
							actHtml = '<li id="'+dom.id+'">'+
							'<div class="hotvenue-list">'+
								'<div class="hotvenue-title">'+
									'<p>'+dom.actName+'</p>'+
									'<ul>'+actTag+'</ul>'+
									'<div style="clear: both;"></div>'+
									'</div>'+
									'<p>'+dom.actText+'</p>'+
									
									'<div class="hotvenue-img" onclick="sessionStorage.setItem(\'relateId\',\''+dom.id+'\');location.href=\''+dom.actUrl+'\'">'+
										'<img src="'+dom.imgSrc+'" />'+
									'</div>'+
								'<div class="hotvenue-place">'+
									'<div class="f-right">'+
										'<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo(\''+dom.id+'\');">'+
											'<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />'+
											'<p class="f-left gd-num wantGoNum">236</p>'+
											'<div style="clear: both;"></div>'+
										'</div>'+
										'<div style="clear: both;"></div>'+
									'</div><div style="clear: both;"></div></div></div></li>';
					}else{
							
						var tag = dom.actTag.split('|');
						var actTag ='';
						for(var j = 0;j<tag.length;j++){
							actTag =actTag+ '<li><p>'+tag[j]+'</p></li>';
						}
						var actUrls = dom.actUrl.split('|');
						var actHtml = '<li id="'+dom.id+'">'+
						'<div class="hotvenue-list">'+
							'<div class="hotvenue-title">'+
								'<p>'+dom.actName+'</p>'+
								'<ul>'+actTag+'</ul>'+
								'<div style="clear: both;"></div>'+
								'</div>'+
								'<p>'+dom.actText+'</p>'+
				
								'<div class="hotvenue-img">'+
								'<div class="hotvenue-imgl" onclick="sessionStorage.setItem(\'relateId\',\''+dom.id+'\');location.href=\''+actUrls[0]+'\'">'+
									'<img src="'+imgSrcs[0]+'" width="480" height="365" />'+
								'</div>'+
								'<div class="hotvenue-imgr">'+
									'<div onclick="sessionStorage.setItem(\'relateId\',\''+dom.id+'\');location.href=\''+actUrls[1]+'\'">'+
										'<img src="'+imgSrcs[1]+'" width="240" height="180" />'+
									'</div>'+
									'<div onclick="sessionStorage.setItem(\'relateId\',\''+dom.id+'\');location.href=\''+actUrls[2]+'\'">'+
										'<img src="'+imgSrcs[2]+'" width="240" height="180" />'+
									'</div>'+
								'</div><div style="clear: both;"></div></div>'+
								
							'<div class="hotvenue-place">'+
								'<div class="f-right">'+
									'<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo(\''+dom.id+'\');">'+
										'<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />'+
										'<p class="f-left gd-num wantGoNum">236</p>'+
										'<div style="clear: both;"></div>'+
									'</div>'+
									'<div style="clear: both;"></div>'+
								'</div><div style="clear: both;"></div></div></div></li>';
						
					}
					li=li+actHtml;
				});
				$("#brandActUl").prepend(li);
			});
		} 
		
		
		 
		 function loadDataQx(){
			 $.post("${path}/wechatStatic/queryBrandAct.do",{actType:1},function(data){
					var li='<li id="04f2e7ebd9104689b6e7a699e362c866" style="padding-top: 20px;background-color: #fff;margin-bottom: 20px;">'+
						'<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320182843woGafU5qBUveueUSd1mcbpeIyzdab1.jpg" /></li>';
						$("#brandActUl").append(li);
						$.each(data, function (i, dom) { 
						var actHtml = '<div class="hotvenueImgList" onclick="sessionStorage.setItem(\'relateId\',\''+dom.id+'\');location.href=\''+dom.actUrl+'\'">'+
							'<img src="'+dom.imgSrc+'" />'+
							'</div>';
						$("#brandActUl li:last").append(actHtml);
					});

			 });
		 }
		 
		 
		
		$(function() {
			//登陆后重新定位
			if($("li[id='"+relateId+"']").offset()){
		  		$("html,body").animate({scrollTop:$("li[id="+relateId+"]").offset().top-100},1000);
			}
			
			//遍历场馆ID加载数据
			$("#brandActUl>li").each(function(index){
				var relateId = $(this).attr("id");
				var $li = $(this);
				var num = $li.find(".wantGoNum").text();
				
				//点赞数
				$.post("${path}/wechatStatic/brandActWantGo.do", {relateId:relateId,userId:userId}, function (data) {
					if (data.status == 200) {
						$li.find(".wantGoNum").text(eval(num)+eval(data.data));
						if (data.data1 == 1) {		//点赞（我想去）
							$li.find(".hotvenue-gd").find("img").attr("src", "${path}/STATIC/wechat/image/hot/gd-on.png");
	                    }
					}
				}, "json");
			});
			
		})
		
		//点赞（我想去）
        function addWantGo(id) {
			sessionStorage.setItem('relateId',id);
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/brandAct.do");
			}else{
				var $li = $("li[id='"+id+"']");
	            var num = $li.find(".wantGoNum").text();
	            $.post("${path}/wechatUser/addUserWantgo.do", {
	            	relateId: id,
                    userId: userId,
                    type: 10
	            }, function (data) {
	                if (data.status == 0) {
	                	$li.find(".wantGoNum").text(eval(num)+1);
	                    $li.find(".hotvenue-gd").find("img").attr("src", "${path}/STATIC/wechat/image/hot/gd-on.png");
	                } else if (data.status == 14111) {
	                    $.post("${path}/wechatUser/deleteUserWantgo.do", {
	                    	relateId: id,
	                        userId: userId
	                    }, function (data) {
	                        if (data.status == 0) {
	                        	$li.find(".wantGoNum").text(eval(num-1));
	                        	$li.find(".hotvenue-gd").find("img").attr("src", "${path}/STATIC/wechat/image/hot/gd.png");
	                        }
	                    }, "json");
	                }
	            }, "json");
			}
        }

	</script>
	
	<style>
		.hotvenueImgList{
			margin-top: 20px;
		}
		.hotvenue-list>p {
		    padding: 20px;
		    font-size: 24px;
		    line-height: 30px;
		    color: #808080;
		}
	</style>
</head>

<body>
	<div class="main">
		<div class="content padding-bottom0">
			<div class="hotvenue">
				<ul id="brandActUl">
				 <%--<li style="padding: 20px 0;background-color: #fff;margin-bottom: 15px;">
						<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732019285001xk4shLzc2fVoK5mJvEvm68ituyT5.jpg" />
					 </li>
					
					 <li id="f073b84090b145cf8de143b0adffc9fd">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海国际电影节</p>
								<ul>
									<li>
										<p>国际电影</p>
									</li>
									<li>
										<p>6月</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
								</div>
								<p>上海国际电影节创办于1993年，是中国唯一获国际电影制片人协会认可的国际A类电影节。堪称爱电影人士的心头大爱。即日起，佛山文化云也同时开展“电影中的真善美”征文活动，马上去抒写观影感受吧！</p>
								
								<div class="hotvenue-img" onclick="sessionStorage.setItem('relateId','f073b84090b145cf8de143b0adffc9fd');location.href='http://www.wenhuayun.cn/wechatStatic/movieIndex.do?from=singlemessage&isappinstalled=0'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20176918263Ea9YW7FwZJ4hUBKzaU104BI3LrNSR6.jpg" />
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('f073b84090b145cf8de143b0adffc9fd');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					<li id="a7ea9f8e8dcc4fd08d83a9c4c4668680">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海夏至音乐日</p>
								<ul>
									<li>
										<p>法国领事馆</p>
									</li>
									<li>
										<p>音乐盛宴</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
								</div>
								<p>1982年创立于巴黎的“夏至音乐日”，一经推出便在法国获得巨大的成功。 三十多年来，摩肩接踵的人群和美妙的音乐遍布法国各个城市的街头巷尾，而如今，“夏至音乐日”是全球最大的城市公共艺术盛宴，也已扩展至全球450多座城市。2017，是夏至音乐日的第八个年头。文化云可免费预订6月23日开幕音乐会门票。</p>
								
								<div class="hotvenue-img" onclick="sessionStorage.setItem('relateId','a7ea9f8e8dcc4fd08d83a9c4c4668680');location.href='http://hs.hb.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=a7ea9f8e8dcc4fd08d83a9c4c4668680'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201761617288dRagS371U9cEXGZF4wsZ933srlpR7Z.jpg" />
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('a7ea9f8e8dcc4fd08d83a9c4c4668680');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">302</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					<li id="fda321679c934e5ea82e7208bc07727a">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海市民文化节</p>
								<ul>
									<li>
										<p>文化盛会</p>
									</li>
									<li>
										<p>2017年</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>上海市民文化节自2013年开幕以来，已经成为全面展示市民文化风采的大舞台，成为上海市规模最大、覆盖面最广、参与程度最高、最具影响力的市民文化盛会！</p>
							<div class="hotvenue-img">
								<div class="hotvenue-imgl" onclick="sessionStorage.setItem('relateId','fda321679c934e5ea82e7208bc07727a');location.href='http://hs.hb.wenhuayun.cn/wechatStatic/cultureContestIndex.do'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201765104946wnpJeux5YnJRRdnioAbw3smqUP3NNc.png" width="480" height="365" />
								</div>
								<div class="hotvenue-imgr">
									<div onclick="sessionStorage.setItem('relateId','fda321679c934e5ea82e7208bc07727a');location.href='http://hs.hb.wenhuayun.cn:80/wechatStatic/walkIndex.do'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201741172440JDDzXdIskS4dZPmybSsDBH4rvWnWZb.png" width="240" height="180" />
									</div>
									<div onclick="sessionStorage.setItem('relateId','fda321679c934e5ea82e7208bc07727a');location.href='http://hs.hb.wenhuayun.cn/wechatStatic/poemIndex.do?userId=9afec5bea8104a5abed34ea257031120'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017516122341tTSGAHRC61l6x4e2jg7mcOeLWU673i.jpg" width="240" height="180" />
									</div>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('fda321679c934e5ea82e7208bc07727a');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					<li id="0c8c37b80e04474ba426fd1eb9480862">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>互联网+社会化运营</p >
								<ul>
									<li>
										<p>科技</p >
									</li>
									<li>
										<p>亲子</p >
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>建筑面积约2000平方米的安亭镇文体活动中心方泰分中心设有3层共11个活动空间，集文化、教育、娱乐、休闲、体育、健身、科技活动于一体。这个夏天带你玩翻天！针对不同年龄段，打造最适合的暑期活动，学习娱乐两不误，更有超多精彩的亲子活动，线上便捷支付正在预订中！</p >
							<div class="hotvenue-img" onclick="sessionStorage.setItem('relateId','0c8c37b80e04474ba426fd1eb9480862');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=92&from=singlemessage&isappinstalled=0'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201762017916S2zIoM6eQo9ydNATLdcWnNnqASDtHi.JPG" />
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('0c8c37b80e04474ba426fd1eb9480862');">
										<img src="/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p >
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					

					<li id="c749296cbe374dcea1d5c65cd39d7b3b">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>2017市民艺术大课堂</p>
								<ul>
									<li>
										<p>市民艺术</p>
									</li>
									<li>
										<p>系列活动</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>市民艺术系列大课堂让市民更加贴近文化艺术，6月23日主题：打击乐专场。来自朱宗庆打击乐团2的团员们传播音乐的欢乐、分享打击乐的感动。</p>
							<div class="hotvenue-img" onclick="sessionStorage.setItem('relateId','c749296cbe374dcea1d5c65cd39d7b3b');location.href='http://www.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=bd3cefad084d45eb9cd7ee8044d35ba4&from=singlemessage&isappinstalled=1'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017616104031OXPWrRxyuGXE4BUii2oT7uGrocu800.JPG" />
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('c749296cbe374dcea1d5c65cd39d7b3b');">
										<img src="/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>


					<li id="1484da95f5f243e1a5aa9d1667fdc00d">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>伊莎贝尔·于佩尔电影回顾展</p>
								<ul>
									<li>
										<p>法国电影</p>
									</li>
									<li>
										<p>美术馆</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>6月10日起，由中华艺术宫主办的“伊莎贝尔·于佩尔电影回顾展”将正式开映， 四部由法国著名女演员伊莎贝尔·于佩尔主演的电影将集中放映，除了经典的《白色物质》和《包法利力夫人》外，于佩尔2016年的新片《纪念》也将与观众见面。</p>
							<div class="hotvenue-img" onclick="sessionStorage.setItem('relateId','1484da95f5f243e1a5aa9d1667fdc00d');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=86'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017613113029nbAiCvQLCN0xoqi50ijoJ7HtsWffuI.JPG" />
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('1484da95f5f243e1a5aa9d1667fdc00d');">
										<img src="/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					
					<li id="7dfe20e7143941e7bdfc7979dc489f9f">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>中华艺术宫</p>
								<ul>
									<li>
										<p>现代艺术</p>
									</li>
									<li>
										<p>博物馆</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>中华艺术宫由2010年上海世博会中国馆改建而成，以打造整洁、美丽、友好、诚实、知性的艺术博物馆的目标，文化云与之紧密合作并在场馆内布有文化云自动取票机。</p>
							<div class="hotvenue-img">
								<div class="hotvenue-imgl" onclick="sessionStorage.setItem('relateId','7dfe20e7143941e7bdfc7979dc489f9f');location.href='http://www.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=2f579b2d7acd497f9ded78df0542d182'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732115732moxWk6m3LmoCDJqOk0OLK0SztUZ0zY.jpg" width="480" height="365" />
								</div>
								<div class="hotvenue-imgr">
									<div onclick="sessionStorage.setItem('relateId','7dfe20e7143941e7bdfc7979dc489f9f');location.href='http://hs.hb.wenhuayun.cn/wechatActivity/preActivityList.do?activityName=%E4%B8%AD%E5%8D%8E%E8%89%BA%E6%9C%AF%E5%AE%AB'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732115736pGqmCSqdEEHpvlzjGp3FKaYOv9stN5.jpg" width="240" height="180" />
									</div>
									<div onclick="sessionStorage.setItem('relateId','7dfe20e7143941e7bdfc7979dc489f9f');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=86'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201768135818gB3CYrbVHkGTmAnC5VxJ9aiC1AyrE2.jpg" width="240" height="180" />
									</div>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('7dfe20e7143941e7bdfc7979dc489f9f');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					<li id="8b1284877af4423ba62ff635ce1d037c">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海博物馆</p>
								<ul>
									<li>
										<p>人民广场</p>
									</li>
									<li>
										<p>博物馆</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>上海博物馆是世界闻名的中国古代艺术博物馆之一，始建于1952年，位于人民广场的新馆建成于1996年。馆藏文物近百万件，其中尤其以青铜器、陶瓷器、书法、绘画为特色。</p>
							<div class="hotvenue-img">
								<div class="hotvenue-imgl" onclick="sessionStorage.setItem('relateId','8b1284877af4423ba62ff635ce1d037c');location.href='http://www.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=05f6b63b4e5e4b2e95139099a8c08ce1'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173211517236en4SPjHC4rrmukPUeetkmvAWdK9t5.jpg" width="480" height="365" />
								</div>
								<div class="hotvenue-imgr">
									<div onclick="sessionStorage.setItem('relateId','8b1284877af4423ba62ff635ce1d037c');location.href='http://www.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=05f6b63b4e5e4b2e95139099a8c08ce1'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017321151727Er6RueITezckmPbsYnTXc7HcqioA2p.jpg" width="240" height="180" />
									</div>
									<div onclick="sessionStorage.setItem('relateId','8b1284877af4423ba62ff635ce1d037c');location.href='http://www.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=05f6b63b4e5e4b2e95139099a8c08ce1'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017321151729SP2wwTEicjXuse6VfKDWBpbjLQr4DR.jpg" width="240" height="180" />
									</div>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('8b1284877af4423ba62ff635ce1d037c');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					<li id="90b7432879d5451db948eeebdac0d3c5">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海世博会博物馆</p>
								<ul>
									<li>
										<p>世博记忆</p>
									</li>
									<li>
										<p>城市生活</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>上海博物馆是世界闻名的中国古代艺术博物馆之一，始建于1952年，位于人民广场的新馆建成于1996年。馆藏文物近百万件，其中尤其以青铜器、陶瓷器、书法、绘画为特色。</p>
							<div class="hotvenue-img">
								<div class="hotvenue-imgl" onclick="sessionStorage.setItem('relateId','90b7432879d5451db948eeebdac0d3c5');location.href='http://hs.hb.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=c505706f2e9140dc8fb3dbfd10f9b15b'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017516122847lclhKpmDPBf6tErgomuIzHzex8VkDY.jpg" width="480" height="365" />
								</div>
								<div class="hotvenue-imgr">
									<div onclick="sessionStorage.setItem('relateId','90b7432879d5451db948eeebdac0d3c5');location.href='http://hs.hb.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=c505706f2e9140dc8fb3dbfd10f9b15b'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201751612294CBebZUXCu8TyKgI96C2sHJZXjs7p1u.jpg" width="240" height="180" />
									</div>
									<div onclick="sessionStorage.setItem('relateId','90b7432879d5451db948eeebdac0d3c5');location.href='http://hs.hb.wenhuayun.cn/wechatVenue/venueDetailIndex.do?venueId=c505706f2e9140dc8fb3dbfd10f9b15b'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017516122918NJXG3gFjbD8dAh2PKUr1qnYkZrRJwF.jpg" width="240" height="180" />
									</div>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('8b1284877af4423ba62ff635ce1d037c');">
										<img src="/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					
					<li id="5bc300101819448c8458deee7aa9a836">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>文化与自然遗产日</p>
								<ul>
									<li>
										<p>上海市群众艺术馆</p>
									</li>
									<li>
										<p>6月10日</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>2017年6月10日，是我国的“文化和自然遗产日”。截至目前，我国世界遗产总数达到50项，总量位列世界第二。其中世界自然遗产11项，自然与文化双遗产4项，文化遗产30项，文化景观5项。上海市群众艺术馆在这一天开展系列活动，供市民欣赏。</p>
							<div class="hotvenue-img" onclick="sessionStorage.setItem('relateId','5bc300101819448c8458deee7aa9a836');location.href='http://hs.hb.wenhuayun.cn/wechatLive/liveActivity.do?liveActivityId=2e6aff8c572540e292e850671eb89f2a&from=singlemessage&isappinstalled=1'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20176121012294SUab2NyIlMEbMdn6eWEwz1NDx9nVi.jpg" />
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('5bc300101819448c8458deee7aa9a836');">
										<img src="/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					<li id="d3f54b31680d4ebbbc76e6a25a58758e">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海之春国际音乐节</p>
								<ul>
									<li>
										<p>音乐舞蹈</p>
									</li>
									<li>
										<p>4月末</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>上海之春国际音乐节是中国历史最悠久的音乐节，是上海音乐舞蹈文化的标志。2017年上海之a春国际音乐节将于4月28日开始。文化云同时上线音乐微评论征集活动。</p>
							<div class="hotvenue-img" onclick="sessionStorage.setItem('relateId','d3f54b31680d4ebbbc76e6a25a58758e');location.href='http://hs.hb.wenhuayun.cn/wechatStatic/musicIndex.do'">
								<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201765105053lXJwLgueOhMtYrGWMYqbRKwfDHCwDu.jpg" />
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('d3f54b31680d4ebbbc76e6a25a58758e');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					<li id="5934e988f0894b588c5fa830eed465e0">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>中国上海国际艺术节</p>
								<ul>
									<li>
										<p>高雅艺术</p>
									</li>
									<li>
										<p>10月-11月</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>中国上海国际艺术节是中国唯一的国家级综合性国际艺术节。文化云在第18届上海国际艺术节中与“艺术天空”紧密合作，受到群众的广泛赞誉。</p>
							<div class="hotvenue-img">
								<div class="hotvenue-imgl" onclick="sessionStorage.setItem('relateId','5934e988f0894b588c5fa830eed465e0');location.href='http://hs.hb.wenhuayun.cn/wechatStatic/artSky.do'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201765104956S4kQLKfPQlzsAlFmKsQJjIHKJ99JaU.png" width="480" height="365" />
								</div>
								<div class="hotvenue-imgr">
									<div onclick="sessionStorage.setItem('relateId','5934e988f0894b588c5fa830eed465e0');location.href='http://hs.hb.wenhuayun.cn:80/wechatStatic/artAnswer.do'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320175811bC4xP7tcnBDj4hs48UonDz8m3sVSDg.jpg" width="240" height="180" />
									</div>
									<div onclick="sessionStorage.setItem('relateId','5934e988f0894b588c5fa830eed465e0');location.href='http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=d17b74abaf444262b5d999a2598f251f'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320175814fSP29OzkSYRjnueKcJI9Gt7S10qQIn.jpg" width="240" height="180" />
									</div>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('5934e988f0894b588c5fa830eed465e0');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					<li id="df6a0ee2e3a54bc18d58c90c9bfc5b9e">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海当代戏剧节</p>
								<ul>
									<li>
										<p>最前沿</p>
									</li>
									<li>
										<p>11月-12月</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>作为非营利性艺术节，上海当代戏剧节是中国戏剧界最早致力于推介国内外当代戏剧的戏剧节。在第十二届上海当代戏剧节中文化云作为重要合作媒体之一。</p>
							<div class="hotvenue-img">
								<div class="hotvenue-imgl" onclick="sessionStorage.setItem('relateId','df6a0ee2e3a54bc18d58c90c9bfc5b9e');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=22'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017651050239AzzH0vqJtbxUKojOSzsmZiJNuWmER.png" width="480" height="365" />
								</div>
								<div class="hotvenue-imgr">
									<div onclick="sessionStorage.setItem('relateId','df6a0ee2e3a54bc18d58c90c9bfc5b9e');location.href='http://hs.hb.wenhuayun.cn:80/wechatStatic/dramaFestival.do'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018720GBPvcQ9K2yV3Bj0CX0IpHEt1JTcO2e.jpg" width="240" height="180" />
									</div>
									<div onclick="sessionStorage.setItem('relateId','df6a0ee2e3a54bc18d58c90c9bfc5b9e');location.href='http://hs.hb.wenhuayun.cn:80/wechatStatic/dramaAnswer.do'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018722V1VKvjNuxXAiPdhxbWJT7w7tHYbCJF.jpg" width="240" height="180" />
									</div>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('df6a0ee2e3a54bc18d58c90c9bfc5b9e');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					
					
					
					<li id="1b6752844d594d5a9d7f08fb4867137c">
						<div class="hotvenue-list">
							<div class="hotvenue-title">
								<p>上海书展</p>
								<ul>
									<li>
										<p>书香中国</p>
									</li>
									<li>
										<p>8月</p>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<p>上海书展是全国性的重要文化盛会，更是全国知名的文化品牌和全民阅读活动示范平台。2016年上海书展期间文化云与宝山文广局“陈伯吹童书屋”合作，广受好评。</p>
							<div class="hotvenue-img">
								<div class="hotvenue-imgl" onclick="sessionStorage.setItem('relateId','1b6752844d594d5a9d7f08fb4867137c');location.href='http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651693608&idx=3&sn=bc091a97cc9b74dbb78a0b740bb7e755'">
									<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201765105045Yk9yVn4GwMzFSZXDCzTACUzd3N5rt1.png" width="480" height="365" />
								</div>
								<div class="hotvenue-imgr">
									<div onclick="sessionStorage.setItem('relateId','1b6752844d594d5a9d7f08fb4867137c');location.href='http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651693608&idx=3&sn=bc091a97cc9b74dbb78a0b740bb7e755'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320181337VeQMtB09SeZ33EJGMwVDtXdB1oou1a.jpg" width="240" height="180" />
									</div>
									<div onclick="sessionStorage.setItem('relateId','1b6752844d594d5a9d7f08fb4867137c');location.href='http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651693608&idx=3&sn=bc091a97cc9b74dbb78a0b740bb7e755'">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320181339l7TAHhd56o6xKnuCjJSmbwIz1cJhId.jpg" width="240" height="180" />
									</div>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="hotvenue-place">
								<div class="f-right">
									<div class="hotvenue-gd f-left" style="border-right: none;" onclick="addWantGo('1b6752844d594d5a9d7f08fb4867137c');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum">236</p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>--%>
					
					
					
					
					
					<!-- <li id="04f2e7ebd9104689b6e7a699e362c866" style="padding-top: 20px;background-color: #fff;margin-bottom: 20px;">
						<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320182843woGafU5qBUveueUSd1mcbpeIyzdab1.jpg" />
						
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=49'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320183549jOxcUsQbpDRKdaRJ94IshZDL608XCN.jpg" />
						</div>
						
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=63'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320183555wIgxlBS9bAaRWkoRuTvUc59vTcoWKJ.jpg" />
						</div>
						
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=ef3918a1dd0f48d897660ca4501a067f&winzoom=1'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017320183556Y8GAqIzJzPpwIXJ0jKWmssF1k2gP4F.jpg" />
						</div>
						
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=70'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201761101512vH0SMWqV4GEzDspXHwRgjUB5IycwPy.png" />
						</div>
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://hs.hb.wenhuayun.cn/wechatActivity/preActivityList.do?activityName=%E9%95%BF%E5%AE%81%E6%98%9F%E6%9C%9F%E9%9F%B3%E4%B9%90%E4%BC%9A&from=singlemessage&isappinstalled=0'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017531133654cpAG0pQJr0MwJc17qyU9kL0fNtyyRw.png">
						</div>
						
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://hs.hb.wenhuayun.cn/wechatStatic/fxActivity.do'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018361IfMAznKHP9SAHdu7RoUfcjVWPkW690.jpg" />
						</div>
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://hs.hb.wenhuayun.cn/wechatStatic/hkVenue.do'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018366kFdKa3tQmIKE2UUpliQ9hh2XAzSlnQ.jpg" />
						</div>
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=e5705198b4654b479bd1688ea6b1478a'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201732018367t4hLWkZYzzlnHzxfMygpGaBUnHRR7v.jpg" />
						</div>
						<div class="hotvenueImgList" onclick="sessionStorage.setItem('relateId','04f2e7ebd9104689b6e7a699e362c866');location.href='http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=24'">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173201836908W7zTMbj4D4rJ261GoBUghffoxf4N.jpg" />
						</div>
					</li>  -->
				</ul>
			</div>
		</div>
	</div>
</body>
</html>