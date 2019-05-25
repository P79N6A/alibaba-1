<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·热门场馆</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var venueId = sessionStorage.getItem('venueId');
		
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '上博，少图，艺术宫...上海顶级文化场馆全攻略';
        	appShareDesc = '魔都最热门的文化场馆都在这里，精彩活动在线预订立即参与';
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
					title: "上博，少图，艺术宫...上海顶级文化场馆全攻略",
					desc: '魔都最热门的文化场馆都在这里，精彩活动在线预订立即参与',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "魔都最热门的文化场馆都在这里，精彩活动在线预订立即参与",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "上博，少图，艺术宫...上海顶级文化场馆全攻略",
					desc: '魔都最热门的文化场馆都在这里，精彩活动在线预订立即参与',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "上博，少图，艺术宫...上海顶级文化场馆全攻略",
					desc: '魔都最热门的文化场馆都在这里，精彩活动在线预订立即参与',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "上博，少图，艺术宫...上海顶级文化场馆全攻略",
					desc: '魔都最热门的文化场馆都在这里，精彩活动在线预订立即参与',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		$(function() {
			//登陆后重新定位
			if($("li[venueId='"+venueId+"']").offset()){
		  		$("html,body").animate({scrollTop:$("li[venueId="+venueId+"]").offset().top-100},1000);
			}
			
			//遍历场馆ID加载数据
			$("#hotVenueUl>li").each(function(index){
				var venueId = $(this).attr("venueId");
				var $li = $(this);
				//相关活动
				$.post("${path}/wechatVenue/venueWcActivity.do", {venueId:venueId}, function (data) {
	                if (data.status == 0) {
	                	$.each(data.data, function (i, dom) {
	                		if(i==1){
	                			return false;
	                		}
	                		var time = dom.activityStartTime.substring(5, 10).replace("-", ".");
	                        if (dom.activityEndTime.length > 0&&dom.activityStartTime!=dom.activityEndTime) {
	                            time += "-" + dom.activityEndTime.substring(5, 10).replace("-", ".");
	                        }
	                        $li.find(".venueActivity").append("<div class='hotvenue-tag' onclick='sessionStorage.setItem(\"venueId\",\""+venueId+"\");toActDetail(\""+dom.activityId+"\");'>" +
																"<p class='hotvenue-name f-left'>" +
                													"<span style='color: #d3b350;font-size: 28px;'>活动</span>" +
                													"<span style='font-size: 30px;margin: 0px 10px;'>|</span>" +
                													dom.activityName +
                												"</p>" +
																"<p class='hotvenue-time f-right'>"+time+"</p>" +
																"<div style='clear: both;'></div>" +
															  "</div>");
	                	});
	                }
				}, "json");
				
				//点赞数、评论数
				$.post("${path}/wechatStatic/hotVenueInfo.do", {venueId:venueId,userId:userId}, function (data) {
					if (data.status == 0) {
						$li.find(".wantGoNum").text(data.data);
						$li.find(".commentNum").text(data.data1);
						if (data.data2 == 1) {		//点赞（我想去）
							$li.find(".hotvenue-gd").find("img").attr("src", "${path}/STATIC/wechat/image/hot/gd-on.png");
	                    }
					}
				}, "json");
			});
			
		})
		
		//点赞（我想去）
        function addWantGo(id) {
			sessionStorage.setItem('venueId',id);
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/hotVenue.do");
			}else{
				var $li = $("li[venueId='"+id+"']");
	            var num = $li.find(".wantGoNum").text();
	            $.post("${path}/wechatVenue/wcAddVenueUserWantgo.do", {
	            	venueId: id,
	                userId: userId
	            }, function (data) {
	                if (data.status == 0) {
	                	$li.find(".wantGoNum").text(eval(num)+1);
	                    $li.find(".hotvenue-gd").find("img").attr("src", "${path}/STATIC/wechat/image/hot/gd-on.png");
	                } else if (data.status == 14111) {
	                    $.post("${path}/wechatVenue/wcDeleteVenueUserWantgo.do", {
	                    	venueId: id,
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
</head>

<body>
	<div class="main">
		<div class="content padding-bottom0">
			<div class="hotvenue">
				<ul id="hotVenueUl">
					<li venueId="2f579b2d7acd497f9ded78df0542d182">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','2f579b2d7acd497f9ded78df0542d182');toVenueDetail('2f579b2d7acd497f9ded78df0542d182');">
								<div class="hotvenue-title">
									<p>中华艺术宫</p>
									<ul>
										<li>
											<p>美术馆</p>
										</li>
										<li>
											<p>上南地区</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：2010年上海世博会中国国家馆改建而成，建筑本身特色鲜明，馆藏丰富，以中国近现代美术艺术珍品为特色。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/zhysg/03.jpg" width="480" height="365" />
										<!--<img src="${path}/STATIC/wechat/image/assn/hotvenue-imglplay.png" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;" />-->
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/zhysg/02.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/zhysg/01.jpg" width="240" height="180" />
											<!--<img src="${path}/STATIC/wechat/image/hot/zhysg/02.jpg" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;" />-->
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市浦东新区上南路205号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('2f579b2d7acd497f9ded78df0542d182');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="05f6b63b4e5e4b2e95139099a8c08ce1">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','05f6b63b4e5e4b2e95139099a8c08ce1');toVenueDetail('05f6b63b4e5e4b2e95139099a8c08ce1');">
								<div class="hotvenue-title">
									<p>上海博物馆</p>
									<ul>
										<li>
											<p>博物馆</p>
										</li>
										<li>
											<p>人民广场</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：上海最大的博物馆，馆藏文物近百万件，其中精品文物12万件，其中尤其是以青铜器、陶瓷器、书法、绘画为特色。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/shbwg/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shbwg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shbwg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市黄浦区人民大道201号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('05f6b63b4e5e4b2e95139099a8c08ce1');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="5e8739f0511b4caeb05c974273b83b96">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','5e8739f0511b4caeb05c974273b83b96');toVenueDetail('5e8739f0511b4caeb05c974273b83b96');">
								<div class="hotvenue-title">
									<p>上海市群众艺术馆</p>
									<ul>
										<li>
											<p>文化馆</p>
										</li>
										<li>
											<p>徐家汇</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：广大市民群众享受公共文化服务的重要场所，是全市群众文化创作、培训、活动、理论研究等业务工作的组织指导和协调机构，是引领示范全市群众文化发展的重要基地。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722113509rpkOaToWBVwHraQQfqJGv8yamiqkpG.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shqyg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shqyg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市徐汇区古宜路125号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('5e8739f0511b4caeb05c974273b83b96');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					<li venueId="02f59032bdaa4a578ad48f3701dc27d4">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','02f59032bdaa4a578ad48f3701dc27d4');toVenueDetail('02f59032bdaa4a578ad48f3701dc27d4');">
								<div class="hotvenue-title">
									<p>刘海粟美术馆</p>
									<ul>
										<li>
											<p>美术馆</p>
										</li>
										<li>
											<p>虹桥</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：国内第一个以个人命名的国家美术馆，主要馆藏为刘海粟先生捐赠的903件中国历代名家书画和个人书画作品。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017221134935RepPfNBRIkSs54ntFCQII83awIl9gz.png" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/lhs/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/lhs/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市长宁区延安西路1609号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('02f59032bdaa4a578ad48f3701dc27d4');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					<li venueId="ec2c78a8b27748f29f881b4b9bed03c9">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','ec2c78a8b27748f29f881b4b9bed03c9');toVenueDetail('ec2c78a8b27748f29f881b4b9bed03c9');">
								<div class="hotvenue-title">
									<p>上海当代艺术博物馆</p>
									<ul>
										<li>
											<p>博物馆</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：坐落于上海的母亲河黄浦江畔，2010年上海世博会期间，曾是“城市未来馆”。它见证了上海从工业到信息时代的城市变迁，其粗砺不羁的工业建筑风格给艺术工作者提供了丰富的想像和创作可能。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017620151538WjnPiegxOXuserhXhiPlINaTcr0BkI.png" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017620151556pPOAGW9wo2W3RDkVCTDpqRIHKTHzGS.png" width="240" height="180" />
										</div>
										<div>
											<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201762015168cbsyhwwty8HOLrcjFUewFrN5OgWCJR.png" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市黄浦区花园港路200号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('ec2c78a8b27748f29f881b4b9bed03c9');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					<li venueId="8717cc42e5b54dc0a177db642fe13e6b">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','8717cc42e5b54dc0a177db642fe13e6b');toVenueDetail('8717cc42e5b54dc0a177db642fe13e6b');">
								<div class="hotvenue-title">
									<p>上海少年儿童图书馆</p>
									<ul>
										<li>
											<p>图书馆</p>
										</li>
										<li>
											<p>南京西路</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：全国历史最悠久的省级少儿图书馆，推出上海童话节、少图讲堂、娃娃欢乐时光等活动特别受到家长和孩子的喜爱。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/shsetsg/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shsetsg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shsetsg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市静安区南京西路962号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('8717cc42e5b54dc0a177db642fe13e6b');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="adc72ef856914b73ac7c23855f53c73c">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','adc72ef856914b73ac7c23855f53c73c');toVenueDetail('adc72ef856914b73ac7c23855f53c73c');">
								<div class="hotvenue-title">
									<p>上海保利大剧院</p>
									<ul>
										<li>
											<p>综合剧场</p>
										</li>
										<li>
											<p>水景剧院</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：上海保利大剧院是国内首家拥有水景剧场的剧院，简单的外部造型与丰富的内部空间形成对比。建筑与水、风、光等自然元素相结合，各方向都有观景平台，观众能从不同的角度看到不同的景观。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017424155832IZ7VYo2ICTRX584iXRYnngdN2byTzL.jpg" width="480" height="365" />
										<!--<img src="../image/assn/hotvenue-imglplay.png" style="position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;" />-->
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017424155846itVzy0VJBLOrqGwf2n7VX7oGFzMC8N.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017424155951c19UNbUjHmTktCoIFVXjOQVjXde7si.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div class="hotvenue-tag">
									<p class="hotvenue-name f-left"><span style="color: #d3b350;font-size: 28px;">活动</span><span style="font-size: 30px;margin: 0px 10px;">|</span>音乐剧《北京遇上西雅图》</p>
									<p class="hotvenue-time f-right">05.04</p>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市嘉定区白银路159号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('adc72ef856914b73ac7c23855f53c73c');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="5845b3043a5344a0bbd561e5522fdb60">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','5845b3043a5344a0bbd561e5522fdb60');toVenueDetail('5845b3043a5344a0bbd561e5522fdb60');">
								<div class="hotvenue-title">
									<p>上海图书馆</p>
									<ul>
										<li>
											<p>图书馆</p>
										</li>
										<li>
											<p>衡山路</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：上海最大的图书馆，现藏中外文献5300余万册（件），长期开展各类形式的公益性全民阅读活动。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/shtsg/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shtsg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shtsg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市徐汇区淮海中路1555号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('5845b3043a5344a0bbd561e5522fdb60');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="ce70de99a6784193a3d6bb1b572aed0c">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','ce70de99a6784193a3d6bb1b572aed0c');toVenueDetail('ce70de99a6784193a3d6bb1b572aed0c');">
								<div class="hotvenue-title">
									<p>环球艺术空间</p>
									<ul>
										<li>
											<p>文化景点</p>
										</li>
										<li>
											<p>艺术空间</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：陆家嘴金融城环球艺术空间致力于以更易于亲近的方式，将生活和艺术融为一体，为上海陆家嘴金融城提供不可多得的畅想生活、灵感发现之所。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017413222825hhefUS0nDSaHqBNMoEnbReUuAv7aOa.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017413222942G1dYt7AZ9KOBBwrqWuZbcvxcfwtEn8.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017413223060R06iYzu509yorP5HLgawy0ty8dYns.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div class="hotvenue-tag">
									<p class="hotvenue-name f-left"><span style="color: #d3b350;font-size: 28px;">活动</span><span style="font-size: 30px;margin: 0px 10px;">|</span>“环球之眼”成龙团队的再生艺术特展</p>
									<p class="hotvenue-time f-right">03.16－05.21</p>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市浦东新区上海浦东环球金融中心四楼</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('ce70de99a6784193a3d6bb1b572aed0c');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="8c4b2c4eba50498d8af40e3abb5788ea">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','8c4b2c4eba50498d8af40e3abb5788ea');toVenueDetail('8c4b2c4eba50498d8af40e3abb5788ea');">
								<div class="hotvenue-title">
									<p>静安区图书馆</p>
									<ul>
										<li>
											<p>图书馆</p>
										</li>
										<li>
											<p>衡山路</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：2001年成为文化部一级图书馆，日常开展图书借阅、参考咨询等服务，多年打磨形成了“悦读静安”系列品牌读书活动。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/jatsg/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/jatsg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/jatsg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市静安区新闸路1702号(近胶州路)</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('8c4b2c4eba50498d8af40e3abb5788ea');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="b6e1451537014cf092dfc510660c9761">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','b6e1451537014cf092dfc510660c9761');toVenueDetail('b6e1451537014cf092dfc510660c9761');">
								<div class="hotvenue-title">
									<p>静安区少年儿童图书馆</p>
									<ul>
										<li>
											<p>图书馆</p>
										</li>
										<li>
											<p>其他</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：安妮女王复兴风格的建筑风格鲜明有趣，将传统服务模式与现代创新理念相结合，打造一个寓教于乐的少儿“悦读”天地。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/jasetsg/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/jasetsg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/jasetsg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市静安区上海市静安区康定东路28号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('b6e1451537014cf092dfc510660c9761');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="ab15c291c1344bd1b1c6a15aba923035">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','ab15c291c1344bd1b1c6a15aba923035');toVenueDetail('ab15c291c1344bd1b1c6a15aba923035');">
								<div class="hotvenue-title">
									<p>人民大舞台</p>
									<ul>
										<li>
											<p>艺术馆</p>
										</li>
										<li>
											<p>人民广场</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：建筑具有欧洲巴洛克风韵，兼具歌剧、芭蕾等国内外各类演出及其他综艺活动的演出功能。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/rmdwt/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/rmdwt/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/rmdwt/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市黄浦区九江路663号亚洲大厦裙楼</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('ab15c291c1344bd1b1c6a15aba923035');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="af1d2e9588dc487f9aa963bb47f1a0f2">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','af1d2e9588dc487f9aa963bb47f1a0f2');toVenueDetail('af1d2e9588dc487f9aa963bb47f1a0f2');">
								<div class="hotvenue-title">
									<p>上海交响乐团音乐厅</p>
									<ul>
										<li>
											<p>复兴西路/丁香花园</p>
										</li>
										<li>
											<p>其他</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：严格按照音乐厅科学规律设计、以世界顶级音乐厅标准建造的上海交响乐团音乐厅，是中国乃至世界最好的音乐厅之一。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/shjxytyyt/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shjxytyyt/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/shjxytyyt/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">徐汇区上海市徐汇区复兴中路1380号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('af1d2e9588dc487f9aa963bb47f1a0f2');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="eae22f63ecf945d6be1dc9f78b1e417c">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','eae22f63ecf945d6be1dc9f78b1e417c');toVenueDetail('eae22f63ecf945d6be1dc9f78b1e417c');">
								<div class="hotvenue-title">
									<p>黄浦文化馆</p>
									<ul>
										<li>
											<p>文化馆</p>
										</li>
										<li>
											<p>打浦桥</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：拥有白玉兰剧场、评弹主题馆等，是艺术团队展演交流的时尚、现代与多功能场所。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/hpwhg/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/hpwhg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/hpwhg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市黄浦区重庆南路308号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('eae22f63ecf945d6be1dc9f78b1e417c');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="23dc8d7b046a40e2abf0ee398f5b85b4">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','23dc8d7b046a40e2abf0ee398f5b85b4');toVenueDetail('23dc8d7b046a40e2abf0ee398f5b85b4');">
								<div class="hotvenue-title">
									<p>上海三山会馆</p>
									<ul>
										<li>
											<p>博物馆</p>
										</li>
										<li>
											<p>董家渡</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：上海市文物保护单位，1909年由福建旅沪水果业商人集资兴建，古建筑雕梁画栋，别致秀丽。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/sshg/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/sshg/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/sshg/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">黄浦区中山南路1551号 (近南车站路)</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('23dc8d7b046a40e2abf0ee398f5b85b4');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="49ed6c3c5368446d8e96fd6323b4e3e8">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','49ed6c3c5368446d8e96fd6323b4e3e8');toVenueDetail('49ed6c3c5368446d8e96fd6323b4e3e8');">
								<div class="hotvenue-title">
									<p>长宁民俗中心</p>
									<ul>
										<li>
											<p>文化馆</p>
										</li>
										<li>
											<p>北新泾</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：上海市第一个经营特色群众文化的事业单位，也是全国首家以民俗文化命名的主题文化馆。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/cnmszx/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/cnmszx/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/cnmszx/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市长宁区天山西路201号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('49ed6c3c5368446d8e96fd6323b4e3e8');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					
					<li venueId="c8af10f8b9d64339a3a980a922502230">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','c8af10f8b9d64339a3a980a922502230');toVenueDetail('c8af10f8b9d64339a3a980a922502230');">
								<div class="hotvenue-title">
									<p>申通地铁</p>
									<ul>
										<li>
											<p>其他</p>
										</li>
										<li>
											<p>漕河泾/田林</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：文化长廊、音乐角、文化列车等系列活动承载了文化进地铁的重任，使得地铁空间成为公共文化空间。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/stdt/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/stdt/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/stdt/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市徐汇区桂林路909号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('c8af10f8b9d64339a3a980a922502230');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li venueId="97be0bb6f4c94d73a4d9d33ff444ee59">
						<div class="hotvenue-list">
							<a href="javascript:;" onclick="sessionStorage.setItem('venueId','97be0bb6f4c94d73a4d9d33ff444ee59');toVenueDetail('97be0bb6f4c94d73a4d9d33ff444ee59');">
								<div class="hotvenue-title">
									<p>上海喜玛拉雅美术馆</p>
									<ul>
										<li>
											<p>美术馆</p>
										</li>
										<li>
											<p>世纪公园</p>
										</li>
									</ul>
									<div style="clear: both;"></div>
								</div>
								<p>推荐理由：由著名建筑师矶琦设计，是从事艺术收藏、展览、教育、研究与学术交流的民营非营利性公益艺术机构。</p>
								<div class="hotvenue-img">
									<div class="hotvenue-imgl">
										<img src="${path}/STATIC/wechat/image/hot/xmlyzx/03.jpg" width="480" height="365" />
									</div>
									<div class="hotvenue-imgr">
										<div>
											<img src="${path}/STATIC/wechat/image/hot/xmlyzx/01.jpg" width="240" height="180" />
										</div>
										<div>
											<img src="${path}/STATIC/wechat/image/hot/xmlyzx/02.jpg" width="240" height="180" />
										</div>
									</div>
									<div style="clear: both;"></div>
								</div>
							</a>
							<div class="venueActivity"></div>
							<div class="hotvenue-place">
								<p class="f-left hotvenue-placep">上海市浦东新区樱花路869号</p>
								<div class="f-right">
									<div class="hotvenue-gd f-left" onclick="addWantGo('97be0bb6f4c94d73a4d9d33ff444ee59');">
										<img src="${path}/STATIC/wechat/image/hot/gd.png" class="f-left" />
										<p class="f-left gd-num wantGoNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div class="hotvenue-pl f-left">
										<img src="${path}/STATIC/wechat/image/hot/pl.png" class="f-left" />
										<p class="f-left gd-num commentNum"></p>
										<div style="clear: both;"></div>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>