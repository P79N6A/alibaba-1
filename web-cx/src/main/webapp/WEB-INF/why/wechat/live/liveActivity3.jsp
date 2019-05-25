<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-live.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	<script>
		var num=10
		var startIndex = 0;		//页数
		var startIndex2 = 0;		//页数(互动专区)
		var userRealName = '';		//用于判断用户是否填写过个人信息
		var liveUserId = '';	//用户更新用户数据
		var list="listNr";//列表
		var tab='${tab}';//当前所在标签
		    
		var title;
		var desc;
		var imgUrl;
		
		var	resultStartTime;
		var resultEndTime;
		var countDown;

		var waterHtml="";
		var waterHtml2="";
		
		var liveActivityTimeStatus;
		var txt = [
					
					];
		
		var toDay='${toDay}'

		
		function initShare(liveId,liveTitle,userName,liveCoverImg,liveActivityTimeStatus,liveStartTime){
			
			 imgUrl=liveCoverImg+"@300w"
			 title=liveTitle;
			// 进行中
			 desc="【"+userName+"】正在文化云直播【"+liveTitle+"】，速来围观！"
			// 预告
			if(liveActivityTimeStatus==2){
				desc="直播预告：【"+userName+"】将于"+liveStartTime+"进行【"+liveTitle+"】直播，文化云第一现场，点收藏不错过！"
			}
			else if(liveActivityTimeStatus==3){
				desc="现场直击：一大波文化人正在文化云上围观【"+liveTitle+"】视频，一起来看吧"
			}
			
			//分享是否隐藏
		    if(window.injs){
		    	//分享文案在线·
	        	appShareTitle = title;
	        	appShareDesc = desc;
	        	appShareImgUrl = imgUrl;
	        	
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
						title:title,
						desc: desc,
						link: '${basePath}wechatLive/liveActivity.do?liveActivityId='+liveId+"&template=3",
						imgUrl: imgUrl
					});
					wx.onMenversionDooruShareTimeline({
						title: desc,
						imgUrl: imgUrl,
						link: '${basePath}wechatLive/liveActivity.do?liveActivityId='+liveId+"&template=3"
					});
					wx.onMenuShareQQ({
						title: title,
						desc: desc,
						imgUrl: imgUrl
					});
					wx.onMenuShareWeibo({
						title: title,
						desc: desc,
						imgUrl: imgUrl
					});
					wx.onMenuShareQZone({
						title: title,
						desc: desc,
						imgUrl: imgUrl
					});
				});
			}
		}
		
		$(function () {
			var liveActivityId=$("#liveActivityId").val();
			
			var liveActivity=localStorage.getItem("liveActivity");
			
			if(!liveActivity){
				
				$("#twInfoBox_hei_1").show();
				localStorage.setItem("liveActivity",1)
			}
			
			if (is_weixin()){
				if (userId == null || userId == '') {
					//判断登陆
			    	publicLogin('${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId+'&template=3');
				}
			}
			
			var liveActivityDetail='${liveActivityDetail}'
				
				var data=JSON.parse(liveActivityDetail); 
			
				var integralChange='${integralChange}'
				
				if(integralChange){
					var i = parseInt(integralChange);
					
					if(i==0){
						$("#twInfoBox_hei_3").show();
					}
					else
					{
						$("#twInfoBox_hei_2 .orange").text(i);
						$("#twInfoBox_hei_2").show()
					}
					
					if ('pushState' in history) {
						history.pushState(null, null,'${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId); 
					}
				}
				var dom=data.data;
				var liveCoverImg=dom.liveCoverImg;
				var liveId=dom.liveActivityId;
				var userName=dom.userName;
				var userHeadImgUrl=dom.userHeadImgUrl;
				var liveTitle=dom.liveTitle;
				var liveStartTime=formatTimestamp(dom.liveStartTime/1000).substring(0,10);
				var liveTopText =dom.liveTopText;
				
				liveActivityTimeStatus=dom.liveActivityTimeStatus;
				var liveCreateUser=dom.liveCreateUser;
				var liveStatus=dom.liveStatus;
				
				var liveWatermarkImg=dom.liveWatermarkImg;
				var liveWatermarkImgPosition=dom.liveWatermarkImgPosition;
				var liveWatermarkText=dom.liveWatermarkText;
				var liveBackgroudCover=dom.liveBackgroudCover;
				var liveBackgroudMusic=dom.liveBackgroudMusic;
				var liveHot=dom.liveHot;
				
				waterHtml=dom.watermarkHtml;
				waterHtml2=dom.watermarkHtml;
				
				if(liveBackgroudCover){
					
					$('.bg').attr("src",liveBackgroudCover)
				}
				else if (liveCoverImg){
					var ImgObj = new Image();
					ImgObj.src = liveCoverImg;
					if(ImgObj.height < 1000){
						$('.bg').attr("src",liveCoverImg)
						$('.bg').css({
							"position":"absolute",
							"left":"0px",
							"right":"0px",
							"top":"270px",
							"margin":"auto",
							"height":"auto",
							"width":"750px"
						})
					}else{
						$('.bg').attr("src",liveCoverImg)
					}
				}
				
				if(liveBackgroudMusic){
					
					$('.videoKj audio').attr("src",liveBackgroudMusic)
					
					$(".videoKj").show();
					
				}
				
				
				document.title="佛山文化云·"+ liveTitle
				
				initShare(liveId,liveTitle,userName,liveCoverImg,liveActivityTimeStatus,liveStartTime)	
			
			//$.post("${path}/wechatLive/toLiveActivityDetail.do",{liveActivityId:liveActivityId}, function (data) {
			
					
					var imgWidth =750
					var imgHeight=320
					
					var ImgObj = new Image();
					ImgObj.src =liveCoverImg+"@750w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>imgWidth/imgHeight){
							var pLeft = (ImgObj.width*(imgHeight/ImgObj.height)-imgWidth)/2;
							$("#liveCoverImg").css({"height":imgHeight+"px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(imgWidth/ImgObj.width)-imgHeight)/2;
							$("#liveCoverImg").css({"width":imgWidth+"px","position":"absolute","top":"-"+pTop+"px"});
						}
						$("#liveCoverImg").attr("src",ImgObj.src)
					}
					
					$("#liveTitle").html(liveTitle)
					$("#liveStartTime").prepend(liveStartTime)
					$("#userName").html(userName)
					
					$("#liveStartTime").append(liveHot);		
				
					$("#userHeadImgUrl").attr("src",getUserHead(userHeadImgUrl))
					
					$(".tou").attr("onclick",'window.location.href="${basePath}wechatLive/userActivityIndex.do?liveCreateUser='+liveCreateUser+'"')
					
					if(liveTopText){
						$("#gongg").find(".nc").html(liveTopText);
						$("#gongg").show();
					}
					if(liveStatus==0){
						$(".kqzb").html('<&nbsp;直播尚未发布&nbsp;>');
						return false;
					}
					
					// 直播活动状态 1.正在直播 
					if(liveActivityTimeStatus==1){
						
						loadLiveMessage(startIndex,num);
						
						$(".kqzb").html('<&nbsp;开始直播&nbsp;>');
					}
					//2.尚未开始 
					else if(liveActivityTimeStatus==2){
						
						countDown=dom.countDown;
						
						startCountDown();
						
						setInterval(
								function(){
									
									startCountDown();
									countDown-=1000;
								}
							,1000);		
						
						
					}
					//3.已结束
					else if(liveActivityTimeStatus==3){
						
						
						
						loadLiveMessage(startIndex,num);
						$(".kqzb").html('<&nbsp;开始直播&nbsp;>');
					}
					
					$.post("${path}/wechatLive/getLiveActivityRecommendList.do",{liveActivityId:liveActivityId,userId:userId}, function (data) {
						
						if (data.status == 1 && data.data.length>0) {
							
							$("#jcLive").show();
							
							var n=86400000;
							
							$.each(data.data, function (i, dom) {
								
								var date =formatTimestamp(dom.liveStartTime/1000).substring(5,16);
								if((toDay-dom.liveStartTime)/n>365){
									 date =formatTimestamp(dom.liveStartTime/1000);
								}
								
								$(".wonderfulLive ul").append(
								
								'<li onclick="loadLiveActivity(\''+dom.liveActivityId+'\');">'+
									'<div class="pic"><img src="'+ dom.liveCoverImg+"@750w"+'"></div>'+
									'<div class="tit" style="text-align: left;">'+dom.liveTitle+'</div>'+
									'<div class="botime clearfix">'+
										'<div style="text-align: left;">'+dom.liveHot+'</div>'+
										'<div>'+date+'</div>'+
									'</div>'+
								'</li>'
								)
							});
							
							$("#jcLive").find('img').picFullCentered({'boxWidth' : 700,'boxHeight' : 420});
						}
					},"json");
					
					loadHdLiveMessage(startIndex2,num);
				
				
			
			//},"json");
			loadUserInfo();
			
			// 评论
			$("#pinglun").click(function(){
				
				var liveActivityId=$("#liveActivityId").val();
				
				if (userId == null || userId == '') {
					//判断登陆
			    	publicLogin('${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId+'&template=3');
				}
				
				else 
					window.location.href='${basePath}wechatLive/addComment.do?liveActivityId='+liveActivityId+'&template=3';
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
			
			//关注
			$(".guanzhu").click(function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
			
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			})
			
			var slideLength;
			console.log(slideLength);
			
			if(liveActivityTimeStatus!=2)
			$(".kqzb").click(function() {
				$("#bs3Fm").remove()
				$("#bs3Detail").show()
				autoPlayMusic("videoKj")
				new Swiper('.swiper-container', {
					lazyLoading: true,
					lazyLoadingInPrevNext: true,
					lazyLoadingInPrevNextAmount: 1,
					observer: true,
					onInit: function(inSwiper) {
						$('.geshu .s2').html(inSwiper.slides.length);
						$('.geshu .s1').html(inSwiper.activeIndex + 1)
					},
					onSlideChangeEnd: function(inSwiper) {
						$('.geshu .s1').html(inSwiper.activeIndex + 1)
					},
					onSlideChangeStart: function(swiper) {
						slideLength = $(".swiper-slide").length - 1;
						$(".nc").html(txt[swiper.activeIndex])
						if(!txt[swiper.activeIndex]){
							$(".bans3Miaos").hide()
							$(".geshu").hide()
						} else {
							$(".bans3Miaos").show()
							$(".geshu").show()
						}
						if(slideLength == swiper.activeIndex) {
							$(".bans3Miaos").hide()
							$(".geshu").hide()
						} else {
							$(".bans3Miaos").show()
							$(".geshu").show()
						}
					}
				})
			});
			
		});
		
		// 开始倒计时
		function startCountDown(){
			var time=(countDown)/1000;
			 
			var s=time;
			
			if(s<=0){ 
				window.location.reload();
			}
			  
			// 秒
			if(s<60){
				$(".kqzb").html("<&nbsp;直播倒计时："+parseInt(s)+"秒&nbsp;>");
				return false;
			}
			
			var m=s/60
			if(m<60){
				$(".kqzb").html("<&nbsp;直播倒计时："+parseInt(m)+"分钟&nbsp;>");
				return false;
			}						
			
			var h=m/60
			
			if(h<24){
				$(".kqzb").html("<&nbsp;直播倒计时："+parseInt(h)+"小时&nbsp;>");
				return false;
			}	
			
			$(".kqzb").html("<&nbsp;直播倒计时："+parseInt(h/24)+"天&nbsp;>");
		}
		
		//加载互动直播
		function loadHdLiveMessage(index, pagesize){
			var liveActivityId=$("#liveActivityId").val();
			var data = {
				messageActivity: liveActivityId,
               	resultFirst: index,
               	resultSize: pagesize,
               	messageIsInteraction:1
            };
			$.post("${path}/wechatStatic/getLiveMessageList.do",data, function (data) {
				if (data.status == 1) {
					
					if(data.data.sum==0){
						$("#listHd .noStart").show();
						$("#listHd .listNr").html("")
					}
					
					if(data.data.list.length<num){
               			$("#W").html("");
               			
   	        		}
					$.each(data.data.list, function (i, dom) {
						var messageImgHtml = "";
						
						var videoCoverImg='${path}/STATIC/wechat/image/live/default_video_l.jpg';
						
						if(dom.messageVideo){
							
							var messageVideoImg = dom.messageVideoImg;
							
							if(messageVideoImg)
							{
								messageVideoImg+="@500w"
							}
							else
								messageVideoImg=videoCoverImg;
						
						messageImgHtml += "<p>"+
						"<video onpause='videoPause();' onplay='videoPlay();' poster='"+messageVideoImg+"' width='500' src='"+dom.messageVideo+"' controls='controls' preload='meta' style='width:500px;'/></p>";
					}
						if(dom.messageImg){
							var messageImg = dom.messageImg.split(",");
							$.each(messageImg, function (j, imgDom) {
								
								messageImgHtml += "<div class='item' style='margin-bottom:30px;'><img src='"+imgDom+"?x-oss-process=image/resize,w_500/auto-orient,1"+waterHtml+"' onclick='previewImg(\""+imgDom+"\",\""+dom.messageImg+"\",\"?x-oss-process=image/resize,w_1000,limit_1/auto-orient,1"+waterHtml2+"\")'></div>";
							});
						}
						
						var userName=dom.userName;
						var userHeadImgUrl=dom.userHeadImgUrl;
						var messageCreateUser=dom.messageCreateUser;
						
						var delSpan="";
						if(messageCreateUser==userId){
							delSpan="<span class='btn' onclick='delMessage(this);'>删除</span>";
						}
						
						$(".listNr").append("<li class='clearfix'>" +
								"<div class='toux'><img src='"+getUserHead(userHeadImgUrl)+"' width='74' height='7'></div>" +
								"<div class='char' messageId='"+dom.messageId+"'>" +
									"<div class='tit'>"+userName+"</div>" +
									"<div class='time'>"+formatTimeStr(formatTimestamp(dom.messageCreateTime/1000),true)+"</div>" +
									delSpan+
									" <div class='cont'><p>"+TransferString(dom.messageContent)+"</p>" +
									messageImgHtml +
								"</div>" +
						  "</li>");
					});
				}
			},"json");
		}
		
		 function videoPlay(){
		    	
		    	$('.videoKj').addClass('cur');
		    	$('.videoKj audio')[0].pause();
		    }
		    
		    function videoPause(){
		    	$('.videoKj').removeClass('cur');
				$('.videoKj audio')[0].play();
		    }
		
		function TransferString(content)  
		{  
		    var string = content;  
		    try{  
		        string=string.replace(/\r\n/g,"<BR>")  
		        string=string.replace(/\n/g,"<BR>");  
		    }catch(e) {  
		        alert(e.message);  
		    }  
		    return string;  
		}  
		
		function delMessage(dom){
			
			var messageId=$(dom).parents(".char").attr("messageId")
			
			  var showText = "您确定要删除该评论吗？";
            dialogDelConfirm("提示", showText, removeParent);
            function removeParent() {
			
			$.post("${path}/wechatLive/deleteMessage.do",{messageId:messageId,messageIsDel:2}, function (data) {
				
				if (data.status == 1) {
					
					 dialogAlert('提示', "删除成功");
					 startIndex2=0;
					 $(".listNr").html("")
						loadHdLiveMessage(startIndex2,num);
				}
				 else{
					 dialogAlert('提示', "删除失败,系统异常");
				 }
			},"json");	
			
			}
		}
		
		function dialogDelConfirm(title, content, fn){
		    var d = dialog({
		        width:400,
		        title:title,
		        content:content,
		        fixed: true,
		        button:[{
		            value: '确定',
		            callback: function () {
		                if(fn)  fn();
		                //this.content('你同意了');
		                //return false;
		            },
		            autofocus: true
		        },{
		            value: '取消'
		        }]
		    });
		    d.showModal();
		}


		function getUserHead(userHeadImgUrl){
			
			if(!userHeadImgUrl||userHeadImgUrl.indexOf("http") == -1){
				userHeadImgUrl='../STATIC/wx/image/sh_user_header_icon.png'
            }else if (userHeadImgUrl.indexOf("aliyuncs.com") != -1) {
            	userHeadImgUrl=userHeadImgUrl+"@74w"
            }
			else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgUrl = imgUrl
            } 
			return userHeadImgUrl;
		}
		
		//加载直播
		function loadLiveMessage(index, pagesize,rStartTime){
			var liveActivityId=$("#liveActivityId").val();
			var data = {
				messageActivity: liveActivityId
            };
			$.post("${path}/wechatStatic/getLiveMessageList.do",data, function (data) {
				if (data.status == 1) {
					
					if(data.data.resultStartTime&&!resultStartTime){
						resultStartTime=data.data.resultStartTime;
					}
					if (data.data.resultStartTime&&!resultEndTime){
						resultEndTime=data.data.resultStartTime;
					}
					
               		list='listHd'
              		
					$.each(data.data.list, function (i, dom) {
						var messageVideoHtml = "";
						
						var videoCoverImg='${path}/STATIC/wechat/image/live/default_video_l.jpg';
						
						var userName=dom.userName;
						var userHeadImgUrl=dom.userHeadImgUrl;
						var messageContent= TransferString(dom.messageContent);
						
						if(dom.messageVideo){
							
								var messageVideoImg = dom.messageVideoImg;
								
								if(messageVideoImg)
								{
									messageVideoImg+="@500w"
								}
								else
									messageVideoImg=videoCoverImg;
							
								$("#listNr").before(
										'<div class="swiper-slide">'+
							"<video onpause='videoPause();' onplay='videoPlay();' class='shipin' poster='"+messageVideoImg+"' src='"+dom.messageVideo+"' controls='controls' preload='meta' /></p>")+
							'</div>';
							
							txt.push(messageContent)
						}
							
						var messageImgHtml=	"";
						
						if(dom.messageImg){
							var messageImgArray = dom.messageImg.split(",");
							messageImgNum=messageImgArray.length;
							
							$.each(messageImgArray, function (j, imgDom) {
								
								$("#listNr").before("<div class='swiper-slide swiper-slide-active' style='width: 750px;'><img  class='swiper-lazy' data-src='"+imgDom+"?x-oss-process=image/resize,w_500/auto-orient,1"+waterHtml+"' onclick='previewImg(\""+imgDom+"\",\""+dom.messageImg+"\",\"?x-oss-process=image/resize,w_1000,limit_1/auto-orient,1"+waterHtml2+"\")'></div>");
							
								txt.push(messageContent)
							});
						}
						
						if(!dom.messageVideo&&!dom.messageImg){
							
							if(messageContent){
								
								$("#listNr").before("<div class='swiper-slide swiper-slide-active' style='width: 750px;'><img  class='swiper-lazy' data-src='${path}/STATIC/wechat/image/live/backgroud.jpg'></div>");
								
								txt.push(messageContent)
							}
								
							else
								return true;
						}
						
						if(!messageContent){
							$(".nc").hide()
						}else{
							$(".nc").show()
						}
						
					});
               		$(".nc").html(txt[0])
				
				}
			},"json");
		}
		
		function loadLiveActivity(liveId){
			
			sessionStorage.setItem("liveId", liveId);
			
			window.location.href='${basePath}wechatLive/liveActivity.do?liveActivityId='+liveId;
		}
		

		//保存用户初始信息
		function loadUserInfo(){
			
			var liveActivityId=$("#liveActivityId").val();
			
			$.post("${path}/wechatStatic/saveLiveUserInfo.do",{userId:userId,liveActivity:liveActivityId}, function (data) {
    			if (data.status == 1) {
    			
    				liveUserId = data.data.liveUserId;
    				if(data.data.userIsLike == 1){
    					$('.twzbFoot .sc').addClass('current');
    					$('.twzbFoot_bun .sc').addClass('current');
    				}else{
    					$('.twzbFoot .sc').attr("onclick","userLike();");
    				}
    				$("#likeSum").text(data.data.isLikeSum);
    				
    				$(".likeSum").text(data.data.isLikeSum);
    				
    			}else{
    				dialogAlert('系统提示', data.msg.errmsg);
    			}
    		},"json");
		}
		
		
		//点赞
		function userLike(){
			
			var liveActivityId=$("#liveActivityId").val();
			
			$('.twzbFoot .sc').attr("onclick","");
			if (userId == null || userId == '') {
				//判断登陆
		    	publicLogin('${path}/wechatLive/liveActivity.do?liveActivityId='+liveActivityId+'&template=3');
			}else{
				
				$.post("${path}/wechatStatic/saveLiveUserInfo.do",{userId:userId,liveActivity:liveActivityId,userIsLike:1,liveUserId:liveUserId}, function (data) {
	    			if (data.status == 1) {
	    				var likeSum = $("#likeSum").text();
	    				$("#likeSum").text(eval(likeSum)+1);
	    				$('.twzbFoot .sc').addClass('current');
	    			}else{
	    				$('.twzbFoot .sc').attr("onclick","userLike();");
	    				dialogAlert('系统提示', "点赞失败！");
	    			}
	    		},"json");
			}
		}
		
		function stopMusicFun() {
	    	$('.videoKj audio').get(0).pause();
	    }
		
		</script>
		
		<style>
			html,
			body {
				height: 100%;
				overflow: hidden;
			}
			
			.twzbMain {
				height: 100%;
				background-color: #000;
				overflow: hidden;
			}
			.char .tit,.char .time,.char p{
				text-align: left;
			}
			
			form{
				height:100%;
				width:750px;
			}
			
		</style>
		
</head>
<body>
<form id="form">
<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wechat/image/live/shareIcon.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;height: 105%;display: none;z-index: 100;">
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
		<input  type="hidden" id="template" value="3"/>
	<input type="hidden" id="liveActivityId" name="liveActivityId" value="${liveActivityId }"/>
	<input type="hidden" id="messageActivity" name="messageActivity" value="${liveActivityId }"/>
	 <input type="hidden" name="messageIsInteraction" value="1"/>
		 <input type="hidden" name="messageIsRecommend" value="0"/>
		 <input type="hidden" name="messageCreateUser" value="" id="messageCreateUser"/>
		 
<div class="twzbMain" id="bs3Fm">
			<div class="bansFeng3">
				<img class="bg" src="">
				<div class="meng"></div>
				<div class="ban bans3ban" style="top:0;">
					<img src="${path}/STATIC/wechat/image/live/icon9.png" style="width:70px;height:70px;position:absolute;left:10px;top:0;">
				
					<div class="lccfengx" style="position:absolute;right:0;top:12px;">
							 <a class="share-button" >分享</a>
				            <a class="guanzhu" >关注</a>
				            <a onclick="toWhyIndex();">首页</a>
					</div>
				</div>
				<div id="liveTitle" class="tit"></div>
				<div class="touwz clearfix">
					<span class="tx"><img id="userHeadImgUrl"></span>
					<span class="wz" id="userName"></span>
				</div>
				<div class="sjpeo" id="liveStartTime"><span id="liveHot"></span></div>
				<a class="kqzb"></a>
				<div class="qhban3 pinglun">切换版式</div>
			</div>
			
						  <!-- 版本选择提示框 -->
    <div class="versionDoorWc">
        <div class="versionDoor">
            <ul>
                <li template="1">默认版<span></span></li>
                <li template="2" >美文阅读版<span></span></li>
                <li template="3"  class="cur">美图欣赏版<span></span></li>
            </ul>
            <div class="vBtn">
                <div class="btn kong">取 消</div>
                <div class="btn qie">确 认</div>
            </div>
        </div>
    </div>

		</div>
		<div class="twzbMain" id="bs3Detail" style="display: none;">
			<div class="ban bans3ban">
				<img src="${path}/STATIC/wechat/image/live/icon9.png" style="width:70px;height:70px;position:absolute;left:10px;top:0;">
				 <div id="videoKjDiv" class="videoKj" style="display: none;">
		          <audio id="videoKj" class="videoKj"  loop src="">您的浏览器不支持 audio 元素。</audio>
		        </div>
				<div class="lccfengx" style="position:absolute;right:0;top:12px;">
						 <a class="share-button" >分享</a>
				            <a class="guanzhu" >关注</a>
				            <a onclick="toWhyIndex();">首页</a>
				</div>
			</div>

			<div class="swiper-container bans3Swiper">
				<div class="swiper-wrapper">
						<div id="listNr" class="swiper-slide" style="overflow: scroll;-webkit-overflow-scrolling : touch;background-color: #fff;display: block;padding-top: 90px;">
						<!-- 精彩直播 -->
						<span id="jcLive" style="display: none;">
						<div style="font-size:30px;color:#62688a;margin-left:25px;border-bottom:1px solid #eee;padding:26px 0;"><span style="display:block;height:32px;line-height:32px;padding-left:27px;border-left:4px solid #62678b;text-align: left;">精彩直播</span></div>
						<div class="wonderfulLive">
							<ul class="clearfix">
								
							</ul>
							<div style="height: 31px;line-height: 31px;" class="gd" onclick="javascript:location.href='${path}/wechatLive/index.do'">更多精彩直播</div>
						</div>
						</span>
						<div style="font-size:30px;color:#62688a;margin-left:25px;border-bottom:1px solid #eee;padding:26px 0;text-align: left;"><span style="display:block;height:32px;line-height:32px;padding-left:27px;border-left:4px solid #62678b;">评论</span></div>
						<ul class="listNr" style="padding-bottom: 190px;">
							
						</ul>
					</div>
				</div>
			</div>
			<div class="geshu"><span class="s1"></span>&nbsp;/&nbsp;<span class="s2"></span></div>
			<div class="bans3Miaos">
				<div class="nc">
				</div>
			</div>
			<!-- 点赞，分享，评论 -->
			<div class="twzbFoot clearfix bans3">
				<div class="sc">
					<span></span>
					<div id="likeSum"></div>
				</div>
				<div class="fx"><span></span>评论<em></em></div>
				<div class="pinglun">切换版式</div>
				<!-- <div class="pinglun gray">切换版式</div> -->
			</div>
			<div class="bans3Pin">
				<textarea id="messageContent" name="messageContent" autofocus="autofocus"></textarea>
				<div class="clearfix">
					<div class=""></div>
					<input class="fs" type="button" value="发送">
				</div>
			</div>
			
			 <!-- 评论成功弹出款 -->
		    <div id="twInfoBox_hei_2" class="twPopBox_hei" style="display:none;">
		        <div class="twPopBox">
		            <div class="tu"></div>
		            <div class="wz">
		                评论成功<br>
		                获得 <span class="orange"></span> 积分~
		            </div>
		            <div class="btn">我知道啦</div>
		        </div>
		    </div>
		    <div id="twInfoBox_hei_3" class="twPopBox_hei" style="display:none;">
		        <div class="twPopBox">
		            <div class="tu"></div>
		            <div class="wz">
		                评论成功~
		            </div>
		            <div class="btn">我知道啦</div>
		        </div>
		    </div>
			
			    <div class="versionDoorWc">
			        <div class="versionDoor">
			            <ul>
			                <li template="1">默认版<span></span></li>
			                <li template="2" >美文阅读版<span></span></li>
			                <li template="3"  class="cur">美图欣赏版<span></span></li>
			            </ul>
			            <div class="vBtn">
			                <div class="btn kong">取 消</div>
			                <div class="btn qie">确 认</div>
			            </div>
			        </div>
			    </div>
		</div>
    
   
</div>
</body>
<script type="text/javascript">

$(function () {
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
    navFixed($(".listTit"),'touchmove',437);
    navFixed($(".listTit"),'scroll',437);

    // 精彩视频
    console.log($('.jcVideo ul li').size());
	
    // 点赞
   /** $('.twzbFoot .sc').bind('click', function () {
        if($(this).hasClass('current')) {
            return;
        }
        $(this).addClass('current');
        $(this).find('div').html(parseInt($(this).find('div').html())+1);
    });**/
  
    if(!tab)
    	tab=1;
    else if (tab=="2"){
    	
    	$('.listTit li').each(function(i,dom){
    		
    		if($(dom).attr("tab")==tab){
    			 list=$(this).attr("list")
    		        
    		        $(".zbcont").hide();
    		        $("#"+list).show();
    		        
    			 $(dom).addClass('current');
    		}
    		else {
    			$(dom).parent().find('li').removeClass('current');
    		}
    	});
    }
    // 导航切换
    $('.listTit li').bind('click', function () {
        $(this).parent().find('li').removeClass('current');
        
        list=$(this).attr("list")
        
        $(".zbcont").hide();
        $("#"+list).show();
        
        tab=$(this).attr("tab")
        
        $(this).addClass('current');
    });
    
    // 阻止弹出框滑动
    $('.twInfoBox_hei, .twPopBox_hei').bind('touchmove',function () {
        return false;
    });

    // 提示弹出框隐藏
    $('.twInfoBox_hei').click(function () {
        $(this).stop().fadeOut(200);
    });
    
 // 评论成功弹出框关闭
    $('.twPopBox .btn').bind('click', function () {
        $(this).parents('.twPopBox_hei').stop().fadeOut(100);
    });
 
 // ban音乐按钮的开始和暂停
    $('body').bind('touchstart', function () {
      
    });
    $('.videoKj').bind('click', function () {
        if($(this).hasClass('cur')) {
            $(this).removeClass('cur');
            $(this).find('audio').get(0).play();
        } else {
            $(this).addClass('cur');
            $(this).find('audio').get(0).pause();
        }
    });

    // 版本选择弹窗
    $('.versionDoorWc').bind('touchmove',function () {
        return false;
    });
    $('.pinglun').bind('click', function () {
    	$("#bs3Fm").find('.versionDoorWc').show();
    });
    
    $('#bs3Detail .pinglun').bind('click', function () {
    	$("#bs3Detail").find('.versionDoorWc').show();
    });
    $('.versionDoorWc').bind('click', function () {
    	$(this).parents('.versionDoorWc').hide();
    });
    $('.versionDoor').bind('click', function (event) {
        event=event || window.event;
        event.stopPropagation();
    });
    $('.versionDoor li').bind('click', function () {
        $('.versionDoor li').removeClass('cur');
        $(this).addClass('cur');
    });
    $('.versionDoor .vBtn .kong').bind('click', function () {
        $(this).parents('.versionDoorWc').hide();
    });
    
  $('.versionDoor .vBtn .qie').bind('click', function () {
        
        var template=$(".versionDoor .cur").attr("template");
        
        var tmp=$("#template").val();
        
        if(tmp==template){
        	$(this).parents('.versionDoorWc').hide();
        }
        else{
        	var liveActivityId=$("#liveActivityId").val();
        	
        	window.location.href='${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId+"&template="+template;
        	
        }
        
    });
  
//评论框弹出
	$('.twzbFoot .fx').bind('click', function() {
		$('.bans3Pin').show();
		$('.bans3Pin textarea').focus();
	});
	
	$(".bans3Pin").on("click",function(e){
		e.stopPropagation();
		$(this).hide();
	})
	
	$("#messageContent").on("click",function(e){
		e.stopPropagation();
	})
	
	
	$(".fs").bind('click', function() {
		
		var liveActivityId=$("#liveActivityId").val();
		
		if (userId == null || userId == '') {
			//判断登陆
	    	publicLogin('${basePath}wechatLive/addComment.do?liveActivityId='+liveActivityId+'&template=3');
		}
		else{
			$("#messageCreateUser").val(userId)
		}
		
		var messageContent=$("#messageContent").val();
		
		if(!messageContent){
			 dialogAlert('提示', "请填写评论！");
			 
			 return false;
		}
			
		 $.post("${path}/wechatLive/createMessage.do", $("#form").serialize(), function(data) {
            
			 if (data.status == 1) {
				 
				 
				 var integralChange=data.integralChange;
				 
				 $('.bans3Pin').hide();
				 
				 $("#messageContent").val("")
						var i = parseInt(integralChange);
						
						if(i==0){
							$("#twInfoBox_hei_3").show();
						}
						else
						{
							$("#twInfoBox_hei_2 .orange").text(i);
							$("#twInfoBox_hei_2").show()
						}
				
				 startIndex2=0;
				 $(".listNr").html("")
					loadHdLiveMessage(startIndex2,num);
			 }
			 else{
				 dialogAlert('提示', "保存失败,系统异常！");
			 }
			 
		 },"json");
	});

});

//滑屏分页
$(window).on("scroll", function () {
	 var scrollTop = $(document).scrollTop();
       var pageHeight = $(document).height();
       var winHeight = $(window).height();
       if (scrollTop >= (pageHeight - winHeight - 80)) {
      		setTimeout(function () { 
      			if (list=='listHd'){
      				startIndex2 += num;
             		var index = startIndex2;
             		loadHdLiveMessage(index,num);
      			}
      		},800);
       }
   });          

</script>
</form>
</body>
</html>