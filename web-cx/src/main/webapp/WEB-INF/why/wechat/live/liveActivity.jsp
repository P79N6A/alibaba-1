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
		
		var toDay='${toDay}'
		
		var loadRecommend=0;
		
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
						link: '${basePath}wechatLive/liveActivity.do?liveActivityId='+liveId,
						imgUrl: imgUrl
					});
					wx.onMenuShareTimeline({
						title: desc,
						imgUrl: imgUrl,
						link: '${basePath}wechatLive/liveActivity.do?liveActivityId='+liveId
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
			    	publicLogin('${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId);
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
						history.pushState(null, null,'${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId+'&tab='+tab); 
					}
				}
				var dom=data.data;
				var liveCoverImg=dom.liveCoverImg;
				var liveId=dom.liveActivityId;
				var userName=dom.userName;
				var userHeadImgUrl=dom.userHeadImgUrl;
				var liveTitle=dom.liveTitle;
				var liveStartTime=formatTimestamp(dom.liveStartTime/1000);
				var liveTopText =dom.liveTopText;
				
				var liveActivityTimeStatus=dom.liveActivityTimeStatus;
				var liveCreateUser=dom.liveCreateUser;
				var liveStatus=dom.liveStatus;
				
				var liveWatermarkImg=dom.liveWatermarkImg;
				var liveWatermarkImgPosition=dom.liveWatermarkImgPosition;
				var liveBackgroudCover=dom.liveBackgroudCover;
				var liveBackgroudMusic=dom.liveBackgroudMusic;
				var liveHot=dom.liveHot;
				
				if(liveBackgroudMusic){
					
					$('.videoKj audio').attr("src",liveBackgroudMusic)
					
					$("#videoKjDiv").show();
					
					//$('.videoKj audio')[0].play();
					autoPlayMusic("videoKj")
				}

				waterHtml=dom.watermarkHtml;
				waterHtml2=dom.watermarkHtml2;
				
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
					$("#liveStartTime").html(liveStartTime+'<span style="padding-left:60px;background:url(${path}/STATIC/wechat/image/live/icon15.png) no-repeat 20px center;">'+liveHot+'</span>')
					$("#userName").html(userName)
				
					$("#userHeadImgUrl").attr("src",getUserHead(userHeadImgUrl))
					
					$(".tou").attr("onclick",'window.location.href="${basePath}wechatLive/userActivityIndex.do?liveCreateUser='+liveCreateUser+'"')
					
					if(liveTopText){
						$("#gongg").find(".nc").html(liveTopText);
						$("#gongg").show();
					}
					if(liveStatus==0){
						$("#noStart").show();
						$(".djs").html("直播尚未发布");
						return false;
					}
					
					// 直播活动状态 1.正在直播 
					if(liveActivityTimeStatus==1){
						
						$("#listNr").append(
								'<div id="loadingLiveMessageDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
						
						loadLiveMessage(startIndex,num);
						
						//循环直播
						setInterval(
							function(){
								autoloadLiveMessage();
							}
						,1000*30);
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
						
						
						$("#noStart").show();
					}
					//3.已结束
					else if(liveActivityTimeStatus==3){
						
						$.post("${path}/wechatLive/getLiveHistoryVideoList.do",{liveActivityId:liveActivityId}, function (data) {
							
							if (data.status == 1 && data.data.length>0) {
								
								var videoCoverImg='${path}/STATIC/wechat/image/live/default_video_s.jpg';
								
								$.each(data.data, function (i, dom) {
									
									var messageVideoImg = dom.messageVideoImg;
									
									if(messageVideoImg)
									{
										messageVideoImg+="@200w"
									}
									else
										messageVideoImg=videoCoverImg;
									
									$("#jcVideoWc ul").append(
									"<li><video onpause='videoPause();' onplay='videoPlay();' poster='"+messageVideoImg+"' width='300' height='200' src='"+dom.messageVideo+"' controls='controls' preload='meta'/></li>")
								});
								
								$('.jcVideo ul').css('width',$('.jcVideo ul li').size() * (300+20));
								$("#jcVideoWc").show();
							}
							
						},"json");
						
						$("#listNr").append(
							'<div id="loadingLiveMessageDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
						
						
						loadLiveMessage(startIndex,num);
					}
					
					loadHdLiveMessage(startIndex2,num);
				
				
			
			//},"json");
			loadUserInfo();
			
			// 评论
			$("#pinglun").click(function(){
				
				var liveActivityId=$("#liveActivityId").val();
				
				if (userId == null || userId == '') {
					//判断登陆
			    	publicLogin('${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId);
				}
				else 
					window.location.href='${basePath}wechatLive/addComment.do?liveActivityId='+liveActivityId+"&tab="+tab+"&template=1";
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
				$(".djs").html("直播倒计时："+parseInt(s)+"秒");
				return false;
			}
			
			var m=s/60
			if(m<60){
				$(".djs").html("直播倒计时："+parseInt(m)+"分钟");
				return false;
			}						
			
			var h=m/60
			
			if(h<24){
				$(".djs").html("直播倒计时："+parseInt(h)+"小时");
				return false;
			}	
			
			$(".djs").html("直播倒计时："+parseInt(h/24)+"天");
		}
		
		// 自动加载
		function autoloadLiveMessage(){
			
			var liveActivityId=$("#liveActivityId").val();
			var data = {
				messageActivity: liveActivityId,
				resultEndTime:resultEndTime
            };
			
			$.post("${path}/wechatStatic/getLiveMessageList.do",data, function (data) {
				
				if (data.status == 1) {
					
					if(data.data.resultEndTime){
						resultEndTime=data.data.resultEndTime;
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
								
								messageImgHtml += "<p style='padding-top:30px;'><img src='"+imgDom+"?x-oss-process=image/resize,w_500/auto-orient,1"+waterHtml+"' onclick='previewImg(\""+imgDom+"\",\""+dom.messageImg+"\",\"?x-oss-process=image/resize,w_1000,limit_1/auto-orient,1"+waterHtml2+"\")'></p>";
							});
						}
						
						var userName=dom.userName;
						var userHeadImgUrl=dom.userHeadImgUrl;
						var messageIsInteraction=dom.messageIsInteraction;
						
						var messageIsInteractionDiv="";
						
						if(messageIsInteraction==1)
							
							messageIsInteractionDiv='<div class="wyjx"></div>'
						
						$("#listNr .listNr").prepend("<li class='clearfix'>" +
											"<div class='toux'><img src='"+getUserHead(userHeadImgUrl)+"' width='74' height='7'></div>" +
											"<div class='char'>" +
												"<div class='tit'>"+userName+"</div>" +
												"<div class='time'>"+formatTimeStr(formatTimestamp(dom.messageCreateTime/1000),true)+"</div>" +
												messageIsInteractionDiv+
												" <div class='cont'><p>"+TransferString(dom.messageContent)+"</p>" +
												messageImgHtml +
											"</div>" +
									  "</li>");
					});
				}
			},"json");
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
               			$("#loadingHdLiveMessageDiv").html("");
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
								messageImgHtml += "<p style='padding-top:30px;'><img src='"+imgDom+"?x-oss-process=image/resize,w_500/auto-orient,1"+waterHtml+"' onclick='previewImg(\""+imgDom+"\",\""+dom.messageImg+"\",\"?x-oss-process=image/resize,w_1000,limit_1/auto-orient,1"+waterHtml2+"\")'></p>";
							});
						}
						
						var userName=dom.userName;
						var userHeadImgUrl=dom.userHeadImgUrl;
						var messageCreateUser=dom.messageCreateUser;
						
						var delSpan="";
						if(messageCreateUser==userId){
							delSpan="<span class='btn' onclick='delMessage(this);'>删除</span>";
						}
						$("#listHd .listNr").append("<li class='clearfix'>" +
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
					
					var liveActivityId=$("#liveActivityId").val();
					 window.location.href='${basePath}wechatLive/liveActivity.do?liveActivityId='+liveActivityId+"&tab="+tab;
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
				messageActivity: liveActivityId,
               	resultFirst: index,
               	resultSize: pagesize,
               	resultStartTime:rStartTime
            };
			$.post("${path}/wechatStatic/getLiveMessageList.do",data, function (data) {
				if (data.status == 1) {
					
					if(data.data.resultStartTime&&!resultStartTime){
						resultStartTime=data.data.resultStartTime;
					}
					if (data.data.resultStartTime&&!resultEndTime){
						resultEndTime=data.data.resultStartTime;
					}
					if(data.data.list.length<num){
               			$("#loadingLiveMessageDiv").html("");
               			
               			var display =$('#jcLive').css('display');
               			
               			if(display == 'none' && loadRecommend==0){
               				
               				loadRecommend=1;
               			
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
	            							'<div class="tit">'+dom.liveTitle+'</div>'+
	            							'<div class="botime clearfix">'+
	            								'<div>'+dom.liveHot+'</div>'+
	            								'<div>'+date+'</div>'+
	            							'</div>'+
	            						'</li>'
	            						)
	            					});
	            					
	            					$("#jcLive").find('img').picFullCentered({'boxWidth' : 700,'boxHeight' : 420});
	            				}
	            			},"json");
               			}
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
							
								messageImgHtml += "<p style='padding-top:30px;'><img src='"+imgDom+"?x-oss-process=image/resize,w_500/auto-orient,1"+waterHtml+"' onclick='previewImg(\""+imgDom+"\",\""+dom.messageImg+"\",\"?x-oss-process=image/resize,w_1000,limit_1/auto-orient,1"+waterHtml2+"\")'></p>";
							});
						}
						
						var userName=dom.userName;
						var userHeadImgUrl=dom.userHeadImgUrl;
						var messageIsInteraction=dom.messageIsInteraction;
						
						var messageIsInteractionDiv="";
						
						if(messageIsInteraction==1)
							
							messageIsInteractionDiv='<div class="wyjx"></div>'
						
						$("#listNr .listNr").append("<li class='clearfix'>" +
											"<div class='toux'><img src='"+getUserHead(userHeadImgUrl)+"' width='74' height='7'></div>" +
											"<div class='char'>" +
												"<div class='tit'>"+userName+"</div>" +
												"<div class='time'>"+formatTimeStr(formatTimestamp(dom.messageCreateTime/1000),true)+"</div>" +
												messageIsInteractionDiv+
												" <div class='cont'><p>"+TransferString(dom.messageContent)+"</p>" +
												messageImgHtml +
											"</div>" +
									  "</li>");
					});
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
		    	publicLogin('${path}/wechatLive/liveActivity.do?liveActivityId='+liveActivityId);
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
		.twzbMain .listNr .toux{
			background:none;
		}
		</style>
		
</head>
<body>

<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wechat/image/live/shareIcon.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 105%;display: none;z-index: 100;">
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
<div class="twzbMain">
	<input  type="hidden" id="template" value="1"/>
	<input type="hidden" id="liveActivityId" name="liveActivityId" value="${liveActivityId }"/>
	<div class="ban">
        <img id="liveCoverImg" src="">
        <div class="tit">
            <div class="nc">
               <div id="liveTitle"  class="pp1"></div>
            </div>
        </div>
    	<img src="${path}/STATIC/wechat/image/live/icon9.png" style="width:70px;height:70px;position:absolute;left:10px;top:0;"/>
       	 <div id="videoKjDiv" class="videoKj" style="display: none;">
          <audio id="videoKj" class="videoKj" loop src="">您的浏览器不支持 audio 元素。</audio>
        	
        </div>
        <div class="lccfengx" style="position:absolute;right:0;top:0;">
            <a class="share-button" >分享</a>
            <a class="guanzhu" >关注</a>
            <a onclick="toWhyIndex();">首页</a>
        </div>
    </div>
    <div class="bantnt">
        <div class="nc clearfix">
            <div class="tou"><img id="userHeadImgUrl" src=""></div>
            <div class="char">
                <div id="userName" class="wz"></div>
                <div id="liveStartTime" class="time"></div>
            </div>
        </div>
    </div>
    <div class="listTitWc">
        <ul class="listTit clearfix">
            <li class="current" tab="1" list="listNr"><a href="javascript:;">图文直播</a></li>
            <li tab="2" list="listHd"><a href="javascript:;">互动专区</a></li>
        </ul>
    </div>
    
    <div id="gongg" class="gongg" style="display: none;"><div class="nc"></div></div>

    <!-- 精彩视频 -->
    <div id="jcVideoWc" class="jcVideoWc clearfix" style="display: none;">
        <div class="jclable">精<br>彩<br>视<br>频</div>
        <div class="jcVideo">
            <ul class="clearfix">
                
            </ul>
        </div>
    </div>

	<div id="listNr" class="zbcont twzb" >
		 <!-- 图文直播尚未开始 -->
	    <div class="noStart" id="noStart" style="display: none;">
	        <div class="djs" ></div>
	        <p>先去互动专区看看吧~</p>
	    </div>
	    <!-- 列表内容 -->
	    <ul class="listNr">
	       
	    </ul>
	    
		<!-- 精彩直播 -->
		<span id="jcLive" style="display: none;">
		<div style="font-size:30px;color:#62688a;margin-left:25px;border-bottom:1px solid #eee;padding:26px 0;"><span style="display:block;height:32px;line-height:32px;padding-left:27px;border-left:4px solid #62678b;">精彩直播</span></div>
		<div class="wonderfulLive">
			<ul class="clearfix">
				
			</ul>
			<div class="gd" onclick="javascript:location.href='${path}/wechatLive/index.do'">更多精彩直播</div>
		</div>
		</span>
	</div>
	
	
	<div id="listHd" class="zbcont twzb"  style="display: none;">
		<!-- 互动专区尚未开始 -->
	    <div class="noStart" style="display: none;">
	        <p>还没有互动评论，你来说几句吧~</p>
	    </div>
	    <!-- 列表内容 -->
	    <ul class="listNr">
	       
	    </ul>
		<div id="loadingHdLiveMessageDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	
	</span>
	</div>

    <!-- 点赞，分享，评论 -->
    <div class="twzbFootWc">
        <div class="twzbFoot clearfix">
            <div class="sc">
                <span></span>
                <div id="likeSum"></div>
            </div>
            <div id="pinglun" class="fx"><span></span>评论<em></em></div>
            <div class="pinglun">切换版式</div>
        </div>
    </div>
    
    
      <!-- 提示弹出框 -->
    <div id="twInfoBox_hei_1" class="twInfoBox_hei" style="display:none;">
        <div class="twInfoBox clearfix">
            <div class="char">
                <div class="nr">参与互动，为你喜欢的直播<span class="orange">点赞</span>或<span class="orange">评论</span><br>可获得积分~</div>
            </div>
            <div class="btn">知道了</div>
        </div>
        <div class="jiantou"></div>
        <div class="twzbFoot_bun"></div>
        <div class="twzbFoot clearfix">
            <div class="sc">
                <span></span>
                <div class="likeSum"></div>
            </div>
            <div class="fx"><span></span>评论<em></em></div>
            <div class="pinglun">切换版式</div>
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
    
     <!-- 版本选择提示框 -->
    <div class="versionDoorWc">
        <div class="versionDoor">
            <ul>
                <li template="1" class="cur">默认版<span></span></li>
                <li template="2">美文阅读版<span></span></li>
                <li template="3">美图欣赏版<span></span></li>
            </ul>
            <div class="vBtn">
                <div class="btn kong">取 消</div>
                <div class="btn qie">确 认</div>
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
       // $('.videoKj audio')[0].play();
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
    $('.twzbFoot .pinglun').bind('click', function () {
        $('.versionDoorWc').show();
    });
    $('.versionDoorWc').bind('click', function () {
        $('.versionDoorWc').hide();
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


});

//滑屏分页
$(window).on("scroll", function () {
	 var scrollTop = $(document).scrollTop();
       var pageHeight = $(document).height();
       var winHeight = $(window).height();
       if (scrollTop >= (pageHeight - winHeight - 80)) {
      		setTimeout(function () { 
      			if(list=='listNr'){
      				startIndex += num;
             		var index = startIndex;
             		loadLiveMessage(index,num,resultStartTime);
      			}
      			else if (list=='listHd'){
      				startIndex2 += num;
             		var index = startIndex2;
             		loadHdLiveMessage(index,num);
      			}
      		},800);
       }
   });           

</script>
</body>
</html>