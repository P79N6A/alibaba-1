<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>安康文化社团</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpStyle.css" />
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpColorCtrl.css">
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

    <script>
        var assnId = '${assnId}';
        var isWifi = true;
        
      	//判断是否是微信浏览器打开
        if (is_weixin()) {

            //通过config接口注入权限验证配置
            wx.config({
                debug: false,
                appId: '${sign.appId}',
                timestamp: '${sign.timestamp}',
                nonceStr: '${sign.nonceStr}',
                signature: '${sign.signature}',
                jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone','getNetworkType']
            });
        };
        
        $(function(){
        	//加载社团信息
        	$.post("${path}/wechatAssn/getAssnDetail.do",{associationId:assnId,userId:userId}, function (data) {
    			if(data.status == 1){
    				var assn = data.data;
    				var assnImgUrl = assn.assnImgUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(assn.assnImgUrl),"_750_500"):(assn.assnImgUrl+"@800w");
					var assnIconUrl = assn.assnIconUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(assn.assnIconUrl),"_150_150"):(assn.assnIconUrl+"@200w");
    				if(assn.assnVideoUrl){
    					$("#assnHead").append("<video id='assnVideo' src='"+assn.assnVideoUrl+"' poster='"+assnImgUrl+"' style='width:750px;' controls webkit-playsinline></video>" +
    										  "<div class='community-video-name'>" +
    												"<p class='f-left'>"+assn.assnVideoName+"</p>" +
    												"<div style='clear: both;'></div>" +
    										  "</div>");
    					
    					$('#assnVideo').on('play', function() {
   							if(!isWifi){
   								dialogAlert("提示", "您的流量正在燃烧哟~~");
   							}
   						});
    				}else{
    					$("#assnHead").append("<img src='"+assnImgUrl+"' width='750' height='435'/>");
    				}
        			//是否关注
    				if(assn.isFollow==1){
    					$(".community-video-btn").addClass("keep-on");
    					$("#isFollow").append("<img src='${path}/STATIC/wechat/image/assn/video-keepon-BTN.png'/>");
        			}else{
        				$("#isFollow").append("<img src='${path}/STATIC/wechat/image/assn/video-keep-BTN.png'/>");
        			}
    				$("#assnIconUrl").append("<img src='"+assnIconUrl+"' width='171' height='171'/>");
    				$("#assnName").html(assn.assnName);
    				//是否浇花
    				if(assn.todayIsFlower==1){
    					$(".flower").addClass("flower-on");
    					$(".community-flower").html("<img src='${path}/STATIC/wechat/image/assn/flower-up.png'/>");
    				}else{
    					$(".community-flower").html("<img src='${path}/STATIC/wechat/image/assn/flower-down.png'/>");
    				}
    				//标签
    				var tagHtml = ""
    				var tagList = assn.assnTag.split(",");
    				$.each(tagList, function (i, tag) {
   						tagHtml += "<li class='f-left'><div><p>"+tag+"</p></div></li>";
   					});
					tagHtml += "<div style='clear: both;'></div>";
    				$("#tagUl").html(tagHtml);
    				
   					var memberCount = assn.assnMember;
   					var fansCount = eval(assn.fansCount) + eval(assn.assnFansInit);
   					var flowerCount = eval(assn.flowerCount) + eval(assn.assnFlowerInit);
   					var shareTitle = assn.shareTitle;
   					var shareDesc = assn.shareDesc;
					
    				//社团介绍
    				$("#assnContent").html(assn.assnContent.replace(/\r\n/g,"<br/>"));
    				var font_h = $(".community-video-card-p>p").height();
    				var font_num = 0;
    				if(font_h > 90) {
    					$(".font-down").show()
    				} else {
    					$(".font-down").hide()
    				}
    				//成员、粉丝、浇花
    				$("#memberCount").html(memberCount);
    				$("#fansCount").html(fansCount);
    				$("#flowerCount").html(flowerCount);
    				
    				//分享是否隐藏
    		        if(window.injs){
    		        	//分享文案
    		        	appShareTitle = shareTitle;
    		        	appShareDesc = shareDesc;
    		        	appShareImgUrl = assnIconUrl;
    		        	
    		    		injs.setAppShareButtonStatus(true);
    		    	}
    				
    				if (is_weixin()) {
	    				wx.ready(function () {
	    	            	wx.onMenuShareAppMessage({
	    	                    title: shareTitle,
	    	                    desc: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.onMenuShareTimeline({
	    	                    title: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.onMenuShareQQ({
	    	                	title: shareTitle,
	    	                    desc: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.onMenuShareWeibo({
	    	                	title: shareTitle,
	    	                    desc: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.onMenuShareQZone({
	    	                	title: shareTitle,
	    	                    desc: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.getNetworkType({
	    		        	    success: function (res) {
	    		        	        var networkType = res.networkType; // 返回网络类型2g，3g，4g，wifi
	    		        	        if(networkType!='wifi'){
	    		        	        	isWifi = false;
	    		        	        	if(assn.assnVideoUrl){
	    		        	        		dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
	    		        	        	}
	    		        	        }
	    		        	    }
	    		        	});
	    	            });
    				}else{
    					//APP判断网络
    					if(window.injs){
    						if(injs.currentNetworkState()!=1){
    							isWifi = false;
		        	        	if(assn.assnVideoUrl){
		        	        		dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
		        	        	}
    						}
    					}
    				}
    			}
        	}, "json");
        	
        	//加载社团图片
        	$.post("${path}/wechatAssn/getAssnRes.do",{associationId:assnId,resType:1}, function (data) {
        		if(data.status == 1){
        			if(data.data.length>0){
        				if(data.data.length<7){
        					$.each(data.data, function (i, dom) {
        						var assnResUrl = dom.assnResUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResUrl),"_750_500"):(dom.assnResUrl+"@800w");
        						var ImgObj = new Image();
        						ImgObj.src = assnResUrl;
        						ImgObj.onload = function(){
	        						if(ImgObj.width/ImgObj.height>24/17){
	        							$("img[srcId="+dom.resId+"]").css("height","170px");
	        						}else{
	        							$("img[srcId="+dom.resId+"]").css("width","240px");
	        						}
        						}
        						var assnResName = dom.assnResName!=null?dom.assnResName:"";
        						$("#assnImgUl").append("<li class='community-tab-pv-btn'><img srcId='"+dom.resId+"' src='"+assnResUrl+"'/></li>");
        						$("#assnImgDetail").append("<div class='swiper-slide'>" +
						        								"<img src='"+assnResUrl+"' />" +
								    							"<div class='upload-user'>" +
								    								"<p class='upload-user-p1'>"+assnResName+"</p>" +
								    								"<p class='upload-user-p2'>"+formatTimestamp(dom.createTime).substring(0,10)+" 上传</p>" +
								    								"<div style='clear: both;'></div>" +
								    							"</div>" +
								    						"</div>");
        					});
        				}else{
        					$.each(data.data, function (i, dom) {
        						var assnResUrl = dom.assnResUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResUrl),"_750_500"):(dom.assnResUrl+"@800w");
        						var ImgObj = new Image();
        						ImgObj.src = assnResUrl;
        						ImgObj.onload = function(){
	        						if(ImgObj.width/ImgObj.height>24/17){
	        							$("img[srcId="+dom.resId+"]").css("height","170px");
	        						}else{
	        							$("img[srcId="+dom.resId+"]").css("width","240px");
	        						}
        						}
        						var assnResName = dom.assnResName!=null?dom.assnResName:"";
        						if(i==5){
        							$("#assnImgUl").append("<li onclick='location.href=\"${path}/wechatAssn/toAssnImg.do?assnId="+dom.assnId+"\"'><img srcId='"+dom.resId+"' src='"+assnResUrl+"'/><img src='${path}/STATIC/wechat/image/400.png' style='position: absolute;left: 0px;top: 0px;'><div class='community-tab-pv-more'><p>+"+eval(data.data.length-5)+"</p></div></li>");
        							return false;
        						}else{
        							$("#assnImgUl").append("<li class='community-tab-pv-btn'><img srcId='"+dom.resId+"' src='"+assnResUrl+"'/></li>");
        							$("#assnImgDetail").append("<div class='swiper-slide'>" +
							        								"<img src='"+assnResUrl+"' />" +
									    							"<div class='upload-user'>" +
									    								"<p class='upload-user-p1'>"+assnResName+"</p>" +
									    								"<p class='upload-user-p2'>"+formatTimestamp(dom.createTime).substring(0,10)+" 上传</p>" +
									    								"<div style='clear: both;'></div>" +
									    							"</div>" +
									    						"</div>");
        						}
        					});
        				}
        				
        				//点击图片放大swiper初始化
        				$(".pb-on").css("display", "block")
        				var mySwiper2 = new Swiper('.swiper-container2', {
        					pagination: '.swiper-pagination',
        					paginationType: "fraction",
        					slidesPerView: 1,
        					spaceBetween: 20,
        					freeMode: false
        				})
        				$(".pb-on").css("display", "none")
        				
        				$(".community-tab-pv-btn").click(function() {
        					mySwiper2.slideTo($(this).index());
        					$(".pb-on").fadeIn("fast");
        					
        					//点击关闭swiper图片
        					$(".swiper-container2 .swiper-slide").click(function() {
        						$(".pb-on").fadeOut("fast");
        					})
        				})
        			}else{
        				$("#assnImgUl").append("<p class='video-no'>－暂无图片－</p>");
        			}
        			$("#assnImgUl").append("<div style='clear: both;'></div>");
        		}
        	}, "json");
        	
        	//加载社团视频
        	$.post("${path}/wechatAssn/getAssnRes.do",{associationId:assnId,resType:2}, function (data) {
        		if(data.status == 1){
        			if(data.data.length>0){
        				if(data.data.length<7){
        					$.each(data.data, function (i, dom) {
        						var assnResCover = dom.assnResCover.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResCover),"_750_500"):(dom.assnResCover+"@800w");
        						$("#assnVideoUl").append("<li>" +
        													"<video src='"+dom.assnResUrl+"' poster='"+assnResCover+"' controls style='width:240px;'/>" +
        												 "</li>");
        					});
        				}else{
        					$.each(data.data, function (i, dom) {
        						var assnResCover = dom.assnResCover.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResCover),"_750_500"):(dom.assnResCover+"@800w");
        						if(i==5){
        							$("#assnVideoUl").append("<li onclick='location.href=\"${path}/wechatAssn/toAssnVideo.do?assnId="+dom.assnId+"\"'><img srcId='"+dom.resId+"' src='"+assnResCover+"'/><img src='${path}/STATIC/wechat/image/400.png' style='position: absolute;left: 0px;top: 0px;'><div class='community-tab-pv-more'><p>+"+eval(data.data.length-5)+"</p></div></li>");
        							return false;
        						}else{
        							$("#assnVideoUl").append("<li>" +
        														"<video src='"+dom.assnResUrl+"' poster='"+assnResCover+"' controls style='width:240px;'/>" +
															 "</li>");
        						}
        					});
        				}
        			}else{
        				$("#assnVideoUl").append("<p class='video-no'>－暂无视频－</p>");
        			}
        			$("#assnVideoUl").append("<div style='clear: both;'></div>");
        		}
        	}, "json");
        	
        	//加载社团在线活动
        	$.post("${path}/wechatAssn/getAssnActivity.do",{associationId:assnId}, function (data) {
        		if(data.status == 1){
        			if(data.data.length>0){
        				$("#hasAssnActivity").show();
        				$("#assnActDiv").show();
        				$.each(data.data, function (i, dom) {
        					var activityIconUrl = getIndexImgUrl(getImgUrl(dom.activityIconUrl), "_750_500");
        					var time = dom.activityStartTime.replace("-",".").replace("-",".");
                            if (dom.activityEndTime.length != 0&&dom.activityStartTime!=dom.activityEndTime) {
                                time += "&nbsp;-&nbsp;"+dom.activityEndTime.replace("-",".").replace("-",".");
                            }
                            var location = "";
                            if(dom.venueName){
                            	location = "."+dom.venueName;
                            }else{
                            	if(dom.activitySite){
                            		location = "."+dom.activitySite;
                            	}
                            }
        					$("#assnActUl").append("<li onclick='toActDetail(\""+dom.activityId+"\");'>" +
					        							"<img src='"+activityIconUrl+"' width='750' height='475'/>" +
					        							"<div class='community-active-font'>" +
					        								"<p class='fs28'>"+dom.activityName+"</p>" +
					        								"<p class='fs24 c808080'>"+dom.activityArea+location+"&nbsp;|&nbsp;"+time+"</p>" +
					        							"</div>" +
					        						"</li>");
        				});
        			}
        		}
        	}, "json");
        	
        	//加载社团历史活动
        	$.post("${path}/wechatAssn/getAssnHistoryActivity.do",{associationId:assnId}, function (data) {
				if(data.status == 1){
					if(data.data.length>0){
						$("#assnHisActDiv").show();
						$.each(data.data, function (i, dom) {
        					if(i==4){
        						$("#assnHisActUl").append("<div style='clear: both;'></div>");
        						$("#assnHisActMore").show();
        						return false;
        					}
        					var activityIconUrl = getIndexImgUrl(getImgUrl(dom.activityIconUrl), "_750_500");
        					$("#assnHisActUl").append("<li onclick='toActDetail(\""+dom.activityId+"\");'>" +
						        							"<img src='"+activityIconUrl+"' width='360' height='230'/>" +
						        							"<p>"+dom.activityName+"</p>" +
						        							"<div class='community-active2-ps'>" +
						        								"<p>"+dom.tagName+"</p>" +
						        							"</div>" +
						        					  "</li>");
        				});
					}
        		}
        	}, "json");
        	
        	//加载社团招募信息
        	$.post("${path}/frontAssn/getAssnRecruit.do",{assnId:assnId}, function () { 
        		
        	})
        	.success(function(data) {
        		if(data!=null&&data!=""){
        			$("#recruitId").val(data.recruitId);
            		$("#endTime").html(data.recruitEndTime);
            		$("#maxPeople").html(data.recruitNumber);
            		$("#require").html(data.recruitRequirment.replace(/\r\n/g,"<br/>"));
        			$("#zhaomu").show();
        		}
        		
        		}, "json")
            .error(function() {
            	 
            	});
        	
        	
        	//图片视频换页
        	$(".community-tab-list1>.f-left").click(function() {
				$(".community-tab-list1>.f-left").removeClass("community-tab-on")
				$(this).addClass("community-tab-on")
				var num_t = $(this).index()
				$(".community-tab-pv").hide()
				$(".community-tab-pv").eq(num_t).show()
			})
			
			//关注
			$(".community-video-btn").on("click", function() {
				if (userId == null || userId == '') {
					//判断登陆
		        	publicLogin("${basePath}wechatAssn/toAssnDetail.do?assnId="+assnId);
				}else{
					if($(".community-video-btn").hasClass("keep-on")) {
						$.post("${path}/wechatAssn/wcDelCollectAssn.do", {assnId: assnId, userId: userId}, function (data) {
	                        if (data.status == 0) {
	                        	$(".community-video-btn").find("img").attr("src", "${path}/STATIC/wechat/image/assn/video-keep-BTN.png");
	        					$(".community-video-btn").removeClass("keep-on");
	        					$("#fansCount").html(eval($("#fansCount").text()-1));
	                            dialogAlert("关注提示", "已取消关注！");
	                        }
	                    }, "json");
					} else {
						$.post("${path}/wechatAssn/wcCollectAssn.do", {assnId: assnId, userId: userId}, function (data) {
	                        if (data.status == 0) {
	                        	$(".community-video-btn").find("img").attr("src", "${path}/STATIC/wechat/image/assn/video-keepon-BTN.png");
	        					$(".community-video-btn").addClass("keep-on");
	        					$("#fansCount").html(eval($("#fansCount").text())+1);
	                            dialogAlert("关注提示", "关注成功！");
	                        }
	                    }, "json");
					}
				}
			});

        	//浇花
			$(".flower").on("click", function() {
				if (userId == null || userId == '') {
					//判断登陆
		        	publicLogin("${basePath}wechatAssn/toAssnDetail.do?assnId="+assnId);
				}else{
					if(!$(".flower").hasClass("flower-on")) {
						$.post("${path}/wechatAssn/saveAssnFlower.do", {associationId: assnId, userId: userId}, function (data) {
							if(data.status == 1){
								$(".flower").append( "<div class='add-flower'><p>浇花+1</p></div>");
								$(".add-flower").show().animate({
									"top": "-50px"
								},300).fadeOut(function() {
									$(this).remove()
								});;

								$(".flower").find("img").attr("src", "${path}/STATIC/wechat/image/assn/flower-up.png");
								$(".flower").addClass("flower-on");
								$("#flowerCount").html(eval($("#flowerCount").text())+1);
							}
						}, "json");
					}else{
						$(".flower").append( "<div class='add-flower'><p>今日已浇花！</p></div>");
						$(".add-flower").show().animate({
							"top": "-50px"
						},300).fadeOut(function() {
							$(this).remove()
						});
					}
				}
			})
			
			//显示说明
			$(".community-help").click(function() {
				if($(".community-helpps").hasClass("psshow")) {
					$(".community-helpps").hide()
					$(".community-helpps").removeClass("psshow")
				} else {
					$(".community-helpps").show()
					$(".community-helpps").addClass("psshow")
				}
			})

			//文字下拉选项
			var font_num = 0;
			$(".font-down").on("click", function() {
				if(font_num == 0) {
					$(".font-down").css("transform", "rotate(180deg)")
					$(".community-video-card-p").css({
						"height": "auto",
						"overflow": "visible"
					})
					font_num = 1;
				} else {
					$(".font-down").css("transform", "rotate(0deg)")
					$(".community-video-card-p").css({
						"height": "150px",
						"overflow": "hidden"
					})
					font_num = 0;
				}
			})
			
        })
        function goRecruitApply(assnId){
        	if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatAssn/toAssnDetail.do?assnId="+assnId);
			}else{
				window.location.href="${path}/wechatAssn/toRecruitApply.do?assnId="+assnId+"&userId="+userId+"&recruitId="+$("#recruitId").val();
			}
        }

    </script>
    
    <style>
    	.swiper-container-horizontal>.swiper-pagination-bullets,
		.swiper-pagination-custom,
		.swiper-pagination-fraction {
			top: 200px;
			height: 50px;
			font-size: 40px;
			color: #fff;
		}
		.community-tab-on{background-color:#a09ee0;}
    </style>
</head>
<body class="photo">
<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 105%;display: none;z-index: 100;">
	<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
</div>
	<div class="main">
		<%-- <div class="header">
			<div class="index-top">
				<span class="index-top-5" onclick="history.go(-1);">
					<img src="${path}/STATIC/wechat/image/arrow1.png" />
				</span>
				<span class="index-top-2">平湖文化云-大咖圈</span>
			</div>
		</div> --%>
		<div class="content padding-bottom0">
			<div class="community-video margin-bottom15" id="assnHead"></div>
			<div class="community-video-card padding-top20 margin-bottom15">
				<div class="community-video-btn" id="isFollow"></div>
				<div class="f-left community-video-userhead" id="assnIconUrl"></div>
				<div class="f-left margin-left20 community-video-person">
					<p class="fs32" id="assnName"></p>
					<ul class="community-video-person-tab1 margin-top10" id="tagUl"></ul>
					<ul class="community-video-person-tab2 margin-top30">
						<li class="f-left">
							<div>
								<img class="f-left" src="${path}/STATIC/wechat/image/assn/community-right.png">
								<p class="f-left">实名认证</p>
								<div style="clear: both;"></div>
							</div>
						</li>
						<li class="f-left">
							<div>
								<img class="f-left" src="${path}/STATIC/wechat/image/assn/community-right.png">
								<p class="f-left">资质认证</p>
								<div style="clear: both;"></div>
							</div>
						</li>
						<li class="f-left" id="hasAssnActivity" style="display: none;">
							<div>
								<img class="f-left" src="${path}/STATIC/wechat/image/assn/community-right.png">
								<p class="f-left">可预订活动</p>
								<div style="clear: both;"></div>
							</div>
						</li>
						<div style="clear: both;"></div>
					</ul>
				</div>
				<div style="clear: both;"></div>
				<div class="community-video-card-p"><p id="assnContent"></p></div>
				<div class="font-down">
					<img src="${path}/STATIC/wechat/image/arrow_down.png" />
				</div>
				<div class="community-counter clearfix">
					<div class="f-left community-counter-line" style="width: 50%;">
						<p class="fs32 c262626" id="memberCount"></p>
						<p class="fs26 c808080">成员</p>
					</div>
					<div class="f-left community-counter-line" style="width: 50%;background: none">
						<p class="fs32 c262626" id="fansCount"></p>
						<p class="fs26 c808080">粉丝</p>
					</div>
					<%--<div class="f-left flower">
						<div class="f-left community-flower"></div>
						<div class="f-left">
							<p class="fs32 c262626" id="flowerCount"></p>
							<p class="fs26 c808080">浇花</p>
						</div>
						<div style="clear: both;"></div>
					</div>--%>
					<div style="clear: both;"></div>
					<%--<div class="community-help"><img src="${path}/STATIC/wechat/image/assn/help.png" /></div>
					<div class="community-helpps">
						<p>每天24：00后，可以为圈主浇花一次</p>
					</div>--%>
				</div>
				
				<div id="zhaomu" style="display:none;margin-top:50px;padding: 0 20px 50px;border-bottom:15px solid #f3f3f3;">
					<input type="hidden" id="recruitId"></input>
					<p style="font-size:30px;text-align: center;color:#262626;margin-bottom:50px;">——&emsp;社团招募&emsp;——</p>
					<p style="font-size:28px;color:#7c7c7c;margin-bottom:30px;"><lable style="color:#262626;">截止时间：</lable><b id="endTime"></b></p>
					<p style="font-size:28px;color:#7c7c7c;margin-bottom:30px;"><lable style="color:#262626;">招募人数：</lable><b id="maxPeople"></b></p>
					<p style="font-size:28px;color:#7c7c7c;margin-bottom:30px;"><lable style="color:#262626;">招募要求：</lable></p>
					<ul>
						<li style="font-size:26px;color:#7c7c7c;margin-bottom:30px;" id="require"></li>
						<!-- <li style="font-size:26px;color:#7c7c7c;margin-bottom:30px;">2.五官端正，形象大方，热情有礼，乐观向上，机智敏捷；</li>
						<li style="font-size:26px;color:#7c7c7c;margin-bottom:30px;">3.能确保参加赛前培训和相关活动；</li> -->
					</ul>
					<div style="width:300px;text-align: center;color:#fff;height:70px;line-height:70px;font-size:28px;background-color:#a09ee0;border-radius:5px;margin:auto;" onclick="goRecruitApply('${assnId}')">我要报名</div>
				</div>
				
				<div class="community-tab">
					<div class="community-tab-list1">
						<div class="f-left community-tab-on">
							<p>社团照片</p>
						</div>
						<div class="f-left">
							<p>社团视频</p>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="community-tab-list2">
						<div class="community-tab-pv">
							<ul id="assnImgUl"></ul>
						</div>
						<div class="community-tab-pv" style="display: none;">
							<ul id="assnVideoUl"></ul>
						</div>
					</div>
				</div>
			</div>
			
			<div class="community-active" id="assnActDiv" style="display: none;">
				<p class="community-active-title">—&nbsp;&nbsp;热门活动进行中&nbsp;&nbsp;—</p>
				<ul id="assnActUl"></ul>
			</div>
			<div class="community-active2" id="assnHisActDiv" style="display: none;">
				<p class="community-active-title">—&nbsp;&nbsp;精彩回顾&nbsp;&nbsp;—</p>
				<ul id="assnHisActUl"></ul>
				<div class="community-list-more" id="assnHisActMore" style="display: none;">
					<div class="community-list-morebtn">
						<p onclick="location.href='${path}/wechatAssn/toAssnActivity.do?assnId=${assnId}'">查看更多</p>
					</div>
				</div>
			</div>
			<div class="pb-on">
				<div class="swiper-container2">
					<div class="swiper-wrapper" id="assnImgDetail"></div>
					<!--分页器-->
					<div class="swiper-pagination"></div>
				</div>
			</div>
			<ul id ="commentUl">
				<li>
					<div style="margin-bottom: 0px;" class="active-border">
						<div class="active-detail-p7">
							<p class="border-bottom">共<span style="color: #fcaf5b;">${commentCount}</span>条评论</p>
							<ul id ="comment">

							</ul>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="bpFoot">
			<div class="bpRwczDetailFoot clearfix">
				<div class="bpPinglun" onclick="addComment()">
					<span>评论</span>
				</div>
				<div class="bpLove" onclick="addWantGo('${assnId}','$(this)')" id="bpLove">
					<span>点赞</span>
				</div>
				<div class="bpShare" id ="share">
					<span>分享</span>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
    var commentIndex=0;
    var pageNum=5;
    $(function(){
        if(userId){
            $.post("${path}/wechatAssn/userIsWant.do?userId="+userId+"&id="+assnId,function(data){
                if(data>0){
                    $("#bpLove").attr("class","bpLove on");
                }
            })
        }
        //页面首次载入时加载评论
        loadComment(commentIndex,pageNum);
        //分享
        $("#share").click(function() {
            if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
                dialogAlert('系统提示', '请用微信浏览器打开分享！');
            }else{
                $("html,body").addClass("bg-notouch");
                $(".background-fx").css("display", "block")
            }
        });

        $(".background-fx").click(function() {
            $("html,body").removeClass("bg-notouch");
            $(".background-fx").css("display", "none")
        })
	})
    //点赞（我想去）
    function addWantGo(relateId,$this) {
        if (userId == null || userId == '') {
            //判断登陆
            publicLogin("${basePath}wechatAssn/toAssnDetail.do?assnId="+assnId);
        }else{
            $.post("${path}/wechatUser/addUserWantgo.do", {
                relateId: relateId,
                userId: userId,
                type: 30
            }, function (data) {
                if (data.status == 0) {
                    $("#bpLove").attr("class","bpLove on");
                } else if (data.status == 14111) {
                    $.post("${path}/wechatUser/deleteUserWantgo.do", {
                        relateId: relateId,
                        userId: userId
                    }, function (data) {
                        if (data.status == 0) {
                            $("#bpLove").attr("class","bpLove");
                        }
                    }, "json");
                }
            }, "json");
        }

    }
    //添加评论
    function addComment() {
        if (userId == null || userId == '') {
            //判断登陆
            publicLogin("${basePath}wechatAssn/toAssnDetail.do?assnId="+assnId);
        } else {
            var status = '${sessionScope.terminalUser.commentStatus}';
            if (status == 2) {
                dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
            } else {
                window.location.href = "${path}/wechat/preAddWcComment.do?moldId=" + assnId + "&type=30";
            }
        }
    }
    //滑屏分页
    $(window).on("scroll", function () {
        var scrollTop = $(document).scrollTop();
        var pageHeight = $(document).height();
        var winHeight = $(window).height();
        if (scrollTop >= (pageHeight - winHeight)) {
            commentIndex += pageNum;
            var index = commentIndex;
            setTimeout(function () {
                loadComment(index,pageNum);
            },1000);
        }
    });

    //加载评论列表
    function loadComment(pageIndex,pageNum) {
        var data = {
            moldId: assnId,
            type: 30,
            pageIndex:pageIndex,
            pageNum:pageNum
        };
        $.post("${path}/wechat/weChatComment.do", data, function (data) {
            if (data.status == 0) {
                if(data.data.length>0){
                    $("#comment").show();
                }
                $.each(data.data, function (i, dom) {
                    var commentImgUrlHtml = "";
                    if (dom.commentImgUrl.length != 0) {
                        var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length - 1).split(",");
                        $.each(commentImgUrls, function (i, commentImgUrl) {
                            var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                            commentImgUrlHtml += "<li><img src='" + smallCommentImgUrl + "' onclick='previewImage(\"" + commentImgUrl + "\",\""+dom.commentImgUrl+"\");'></li>"
                        });
                    }
                    var userHeadImgUrl = '';
                    if (dom.userHeadImgUrl.indexOf("http") == -1) {
                        userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
                    } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
                        userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
                    } else {
                        userHeadImgUrl = dom.userHeadImgUrl;
                    }
                    $("#comment").append("<li>" +
                        "<div class='p7-user-list'>" +
                        "<div class='p7-user'>" +
                        "<img src='" + userHeadImgUrl + "' width='65' height='65' onerror='imgNoFind();'/>" +
                        "<div class='p7-user-name'>" +
                        "<p class='user-name'>"+dom.commentUserNickName+"</p>" +
                        "<p class='user-time'>"+dom.commentTime.replace("-",".").replace("-",".")+"</p>" +
                        "</div>" +
                        "<div style='clear: both;'></div>" +
                        "</div>" +
                        "<div class='p7-say'>" +
                        "<p>" + dom.commentRemark + "</p>" +
                        "</div>" +
                        "<div class='p7-user-list-img commentImgUrlHtml'><ul>" + commentImgUrlHtml + "</ul></div>" +
                        "</div>" +
                        "</li>");
                });
                imgStyleFormat('commentImgHtml','commentImgUrlHtml');
            }
        }, "json");
    }
</script>
</html>