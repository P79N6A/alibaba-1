<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

	<head>
		<title></title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
		<!--红星style-->
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-redstar.css">
		<!--大转盘js-->
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery.rotate.min.js"></script>
		
		<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
		
		<script>
		
		 var title='同志，这里有一只革命锦囊，组织正式邀请你成为革命的一份子！';
		 var desc= '纪念长征胜利80周年，点亮红星，五千只革命锦囊等你来拿！';
		 var imgUrl='${basePath}/STATIC/wxStatic/image/redStar/share_150.png';
		 
		//分享是否隐藏
	   	 if(window.injs){
	    	//分享文案
	    	appShareTitle = title;
	    	appShareDesc =desc;
	    	appShareImgUrl = imgUrl;
	    	
			injs.setAppShareButtonStatus(true);
			
			injs.changeNavTitle('红星照耀中国'); 
			
	   	}else{
			$(document).attr("title",'红星照耀中国');
		}
		
		
		 var playnum =0;
		 //topicArray为随机出来的结果，根据概率后的结果
		 // 浴血坚持 星火燎原 转战南北 共赴国难
		 var topicArray = [1, 2, 3, 4];
		 var topicNameArray=['浴血坚持','星火燎原','转战南北','共赴国难']
		 var topicIdArray =new Array();
		 
		 var isPass=true;
		 //用户成绩
		 var contestScores;
		 // 抽积分
		 var isUserInteger=false;
		 
		 var contestResult;
		 
		 var ua = navigator.userAgent.toLowerCase();	
     	
			$(function() {
				
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
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}wechatRedStar/index.do'
						});
						wx.onMenuShareTimeline({
							title: title,
							imgUrl: imgUrl,
							link: '${basePath}wechatRedStar/index.do'
						});
						wx.onMenuShareQQ({
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}/wechatRedStar/index.do'
						});
						wx.onMenuShareWeibo({
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}/wechatRedStar/index.do'
						});
						wx.onMenuShareQZone({
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}/wechatRedStar/index.do'
						});
					});
				}
				
				var $btn = $('.playbtn');
				
				if (userId == null || userId == '') {
					
					  publicLogin("${basePath}wechatRedStar/index.do");
					  
	            }else{
	            	$.post("${path}/wechatRedStar/getTopics.do", {}, function (data) {
	            		
	            		if(data.status ==1 ){
	            			var array=data.data;
	            			$.each(array,function(i,dom){
	            				
	            				var topName=dom.topicTitle;
	            				var index=$.inArray(topName, topicNameArray);
	            				if(index>-1){
	            					
	            					topicIdArray[index+1]=dom.topicId;
	            				}
	            			});
	            		}
	            		
	            	 }, "json");
	            	
	            	$.post("${path}/wechatUser/queryTerminalUserById.do", {userId: userId}, function (data) {
	            		
	            		 if (data.status == 0) {
	            			 
	            			 var user = data.data[0];
	                         var userHeadImgUrl = user.userHeadImgUrl;
	                         
	                         var userHeadImgHtml="";
	                         
	                         if(userHeadImgUrl){
	                             if(userHeadImgUrl.indexOf("http") == -1){
	                             	userHeadImgUrl = getImgUrl(userHeadImgUrl);
	                             }
	                             if (userHeadImgUrl.indexOf("http")==-1) {
	                             	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='80' height='80'/>";
	                             } else if (userHeadImgUrl.indexOf("/front/") != -1) {
	                                 var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
	                                 userHeadImgHtml = "<img src='" + imgUrl + "' width='80' height='80'/>";
	                             } else {
	                             	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' width='80' height='80'/>";
	                             }
	                         }else{
	                         	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='80' height='80'/>";
	                         }

	                         $(".redstarHeadImg").html(userHeadImgHtml);
	                         $(".redstarHeadName").html(user.userName)
	                         
	                         $(".userName").html(user.userName)
	                         
	            		 }
	            		
	            	 }, "json");
	            	

	            	$.post("${path}/wechatRedStar/getUserTestInfo.do", {userId: userId}, function (data) {
	            		
	            		 if (data.status == 1) {
	            			 
	            			 if (/wenhuayun/.test(ua)) {		//APP端
		            			 Log("data.status == 1");
	            		    }
	            			 
	            			 var data=data.data;
	            			 
	            			 var lastLoginTime=data.lastLoginTime;
	            			 
	            			 if (/wenhuayun/.test(ua)) {		//APP端
		            			 Log(lastLoginTime);
	            		    }
	            			 
	            			 if(!lastLoginTime){
	            				 $(".redstarRuleDiv").show()
	            			 }
	            			 
	            			 var successTime=data.successTime;
	            			 
	            			 if (/wenhuayun/.test(ua)) {		//APP端
		            			 Log(successTime);
	            		    }
	            			 
	            			 if(successTime){
	            				 successTime=formatTimestamp(successTime/1000);
	            				 
	            				 if (/wenhuayun/.test(ua)) {		//APP端
	            					 Log("formatTimestamp"+successTime);
		            		    }
	            				 
	            				 var successTimeArray=successTime.split(" ");
	            				 var date=successTimeArray[0];
	            				 var time=successTimeArray[1];
	            				 
	            				 var dateArray=date.split(".");
	            				  
	            				 $("#yyyy").html(dateArray[0]);
	            				 $("#mm").html(dateArray[1]);
	            				 $("#dd").html(dateArray[2]);
	            				 
	            				 if (/wenhuayun/.test(ua)) {		//APP端
	            					 Log("dateArray:"+dateArray[0]+dateArray[1]+dateArray[2]);
		            		    }

	            			 }
	            			 
	            			 
	            			 var chanceTemporaryNumber=data.chanceTemporaryNumber;
	            			 var chancePermanentNumber=data.chancePermanentNumber;
	            			 playnum=chanceTemporaryNumber+chancePermanentNumber; //初始次数，由后台传入
	            			 
	            			 if (/wenhuayun/.test(ua)) {		//APP端
	            				 Log("playnum:"+playnum);
	            		    }
	            			 
	            			 contestScores=data.contestScores;
	            			 
	            			
	            			 
	            			// 遍历成绩
		         			for (var i = 0; i < contestScores.length; i++) {
		         					var score=contestScores[i];
			         				if(score!=0){
			         					if(i==4){
			         						isUserInteger=true;
			         						
			         						$("#light"+(i+1)+" img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
			         					}else{
			         						
			         						var x=$.inArray((i+1),topicArray);
			         						
			         						topicArray.splice(x,1);
			         						
			         						$("#light"+(i+1)+" img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
			         					}
			         				}
			         				else
			         					isPass=false;
								}			
	            			
	         				if(playnum == 0) {
	         					
	         					 if (/wenhuayun/.test(ua)) {		//APP端
	         						 Log("playnum == 0");
		            		    }
	         					 
		            			
	         					if(!isPass){
	         						$(".playnumNone").show()
	         					}
	         					
	         					$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/roundBtnOff.png) no-repeat center center")
	         				}
	         				
	         				//else if(playnum>0){
	         				//	$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/roundBtn.png) no-repeat center center")
	         				//}
	         				$('.playnum').html(playnum);
	         				var helpNumber=data.helpNumber;
	         				$(".redstarUserBravo").html(helpNumber);
	         				
	         				if(isPass){
	         					
	         					 if (/wenhuayun/.test(ua)) {		//APP端
	         						Log("isPass is true");
		            		    }
	         					
	         					contestResult=data.contestResult;
	         					
	         					$("#successRanking").html(data.successRanking)
	         					
	         					// 通过未领取奖品
	         					if(contestResult==0){
	         						
	         						$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/roundBtnOff.png) no-repeat center center")
	         						
	         						$.post("${path}/wechatRedStar/getGift.do", {userId: userId}, function (data) {
	         							
	         							if (data.status == 1) {
	         								
	         								
	         								$(".gift").html(data.data)
	         								$(".allDone").show();
	         							}
	         							
	         						 }, "json");
	         					}
	         					else
	         					{
	         						$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/bigbag.png) no-repeat center center")
	         						
	         						$(".miniBag").show();
	         						
	         						var userTelephone=data.userTelephone;
		         					
		         					if(!userTelephone){
		         						
		         						$(".infoSubmit").show();
		         					}
		         					
	         					}
	         					
	         				//	$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/roundBtnOff.png) no-repeat center center")
	         				
	         				}
	         				
	            		 }
	            	
	            	 }, "json");
	            	
	            	
	            	
	            	$.post("${path}/wechatRedStar/getHelpRankingList.do", {userId: userId}, function (data) {
	            		
	            		 if (/wenhuayun/.test(ua)) {		//APP端
	            			 Log("getHelpRankingList.do status:"+data.status);
	            		    }
	            		
	            		 if (data.status == 1) {
	            			 // 用户排行
	            			 var userRank=data.data.userRank;
	            			 
	            			  
	            			  var userHeadImgUrl = userRank.headImg;
		                         
		                         var userHeadImgHtml="";
		                         
		                         if(userHeadImgUrl){
		                             if(userHeadImgUrl.indexOf("http") == -1){
		                             	userHeadImgUrl = getImgUrl(userHeadImgUrl);
		                             }
		                             if (userHeadImgUrl.indexOf("http")==-1) {
		                             	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='80' height='80'/>";
		                             } else if (userHeadImgUrl.indexOf("/front/") != -1) {
		                                 var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
		                                 userHeadImgHtml = "<img src='" + imgUrl + "' width='80' height='80' />";
		                             } else {
		                             	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' width='80' height='80'/>";
		                             }
		                         }else{
		                         	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='80' height='80' />";
		                         }
	            			 
	            			 <!--我的排名-->
	     					var div=
	     						'<div class="rankingMeImg">'+
	     						userHeadImgHtml+
	     						'</div>'+
	     						'<div class="rankingMeDetail">'+
	     							'<div class="MyInfo">'+
	     								'<p class="MyInfoR">我的排名<span style="color: #ff9c00;font-size: 34px;line-height: 30px;margin: 0 10px;">'+userRank.ranking+'</span></p>'+
	     								'<p class="My InfoN">'+userRank.name+'</p>'+
	     							'</div>'+
	     							'<div class="MyNum">'+
	     								userRank.helpCount
	     							'</div>'+
	     							'<div style="clear: both;"></div>'+
	     						'</div>'+
	     						'<div style="clear:both;"></div>';
	     					
	     					$(".redstarRankingMe").append(div);
	     					
	     					// 前十
	     					var topRank=data.data.topRank;
	     					
	     					$.each(topRank,function(i,dom){
	     						
	     						var topTwo=""
	     						
	     						if(i<2)
	     							topTwo="topTwo";
	     						
	     						userHeadImgUrl = dom.headImg;
		                         
		                         userHeadImgHtml="";
	     						
	     					    if(userHeadImgUrl){
		                             if(userHeadImgUrl.indexOf("http") == -1){
		                             	userHeadImgUrl = getImgUrl(userHeadImgUrl);
		                             }
		                             if (userHeadImgUrl.indexOf("http")==-1) {
		                             	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='80' height='80'/>";
		                             } else if (userHeadImgUrl.indexOf("/front/") != -1) {
		                                 var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
		                                 userHeadImgHtml = "<img src='" + imgUrl + "' width='80' height='80' />";
		                             } else {
		                             	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' width='80' height='80'/>";
		                             }
		                         }else{
		                         	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='80' height='80' />";
		                         }
	     						
	     						var div='<li class="redstarRankingOther '+topTwo+'">'+
									'<div class="rankingMeImg">'+
									userHeadImgHtml+
							'</div>'+
							'<div class="rankingMeDetail">'+
								'<div class="MyInfo">'+
									'<p class="otherInfoR">NO.'+dom.ranking+'</p>'+
									'<p class="otherInfoN">'+dom.name+'</p>'+
								'</div>'+
								'<div class="otherNum">'+
									dom.helpCount
								'</div>'+
								'<div style="clear: both;"></div>'+
							'</div>'+
							'<div style="clear:both;"></div>'+
							'</li>';
						
							$(".redstarRanking").append(div)
	     					})
	     					
	            		 }
	            	 }, "json");	 
	            	
	            	$.post("${path}/wechatRedStar/getJoinInfo.do", {userId: userId}, function (data) {
	            		
	            		 if (data.status == 1) {
	            			 
	            			 var totalUserCount=data.data.totalUserCount;
	            			 var finishUserCount=data.data.finishUserCount;
	            			 var todayFinishUserCount=data.data.todayFinishUserCount;
	            			
	            			 $("#totalUserCount span").html(totalUserCount);
	            			 $("#totalUserCount").show();
	            			 $("#finishUserCount span").html(finishUserCount);
	            			 $("#finishUserCount").show();
	            			 $("#todayFinishUserCount span").html(todayFinishUserCount);
	            			 $("#todayFinishUserCount").show();
	            			 
	            			//底部滚动swiper初始化
	         				var mySwiper = new Swiper('.swiper-container', {
	         					direction: 'horizontal',
	         					loop: true,
	         					autoplayDisableOnInteraction : false,
	         					autoplay : 4000
	         				})
	            		 }
	            	 }, "json");	
	            }
				
				
				
				
				//var playnum = 1; //初始次数，由后台传入
				//if(playnum == 0) {
				//	$(".playnumNone").show()
				//	$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/roundBtnOff.png) no-repeat center center")
				//}
				//$('.playnum').html(playnum);
				var istrue = 0;
				var clickfunc = function() {
				
					var get = Math.floor(Math.random() * 100)
					console.log(get)
					if(!isUserInteger &&topicArray.length==0){
						
						rotateFunc(5, 216); //8%的几率拿积分
						setTimeout(function() {	
							$.post("${path}/wechatRedStar/deduction.do", {userId: userId,index:5},function(data){
								if (data.status == 1) {
									$("#light4 img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
									$("#score").html(data.score)
									$(".redstarPoint").show(); //获得积分弹窗显示
								 }else
								{
									 
								}
							}, "json");
						}, 4000)
					}
					else if(!isUserInteger && get >= 92) {
						rotateFunc(5, 216); //8%的几率拿积分
						setTimeout(function() {
							$.post("${path}/wechatRedStar/deduction.do", {userId: userId,index:5},function(data){
								if (data.status == 1) {
									$("#light4 img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
									$("#score").html(data.score)
									$(".redstarPoint").show(); //获得积分弹窗显示
								 }else
								{
									 
								}
							}, "json");
						}, 4000)
					} else {
						i = topicArray[Math.floor(Math.random() * topicArray.length)];
						var topicId=topicIdArray[i];
						switch(i) {
							case 1:
								rotateFunc(1, 0);
								setTimeout(function() {
									$.post("${path}/wechatRedStar/deduction.do", {userId: userId,index:i},function(data){
										if (data.status == 1) {
										$("#light1 img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
										$(".startTitle").text("浴血坚持")
										$("#questionTitle").text("浴血坚持")
										$(".quesStartBtn").attr("topicId",topicId)
										$(".quesStartBtn").attr("index",1)
										$(".redstarQuesGo").show()
										 }else
											{
												 
											}
									}, "json");
								}, 4000)
								break;
							case 2:
								rotateFunc(2, 72);
								setTimeout(function() {
									$.post("${path}/wechatRedStar/deduction.do", {userId: userId,index:i},function(data){
										if (data.status == 1) {
										$("#light2 img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
										$(".startTitle").text("星火燎原")
										$("#questionTitle").text("星火燎原")
										$(".quesStartBtn").attr("topicId",topicId)
										$(".quesStartBtn").attr("index",2)
										$(".redstarQuesGo").show()
										 }else
											{
												 
											}
									}, "json");
								}, 4000)
								break;
							case 3:
								rotateFunc(3, 144);
								setTimeout(function() {
									$.post("${path}/wechatRedStar/deduction.do", {userId: userId,index:i},function(data){
										if (data.status == 1) {
										$("#light3 img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
										$(".startTitle").text("转战南北")
										$("#questionTitle").text("转战南北")
										$(".quesStartBtn").attr("topicId",topicId)
										$(".quesStartBtn").attr("index",3)
										$(".redstarQuesGo").show()
										 }else
											{
												 
											}
									}, "json");
								}, 4000)
								break;
							case 4:
								rotateFunc(4, 288);
								setTimeout(function() {
									$.post("${path}/wechatRedStar/deduction.do", {userId: userId,index:i},function(data){
										if (data.status == 1) {
										$("#light4 img").attr("src", "${path}/STATIC/wxStatic/image/redStar/lightOn.png")
										$(".startTitle").text("共赴国难")
										$("#questionTitle").text("共赴国难")
										$(".quesStartBtn").attr("topicId",topicId)
										$(".quesStartBtn").attr("index",3)
										$(".redstarQuesGo").show()
										 }else
											{
												 
											}
									}, "json");
								}, 4000)
								break;
								
						}
					}
					setTimeout(function() {
						if(playnum == 0) {
							$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/roundBtnOff.png) no-repeat center center")
						}
					}, 4000)

				}
				$btn.click(function() {
					
					return ;

					if(contestResult==1&&isPass)
					{
						$(".revlPop").show();
						return ;
					}
					
					if(playnum<=0){
						
						$(".playnumNone").show();
						return ;
					}
					
					if(istrue||isPass) return; // 如果在执行就退出
					
					istrue = true; // 标志为 在执行
					//先判断是否登录,未登录则执行下面的函数
					if(1 == 2) {
						$('.playnum').html('0');
						alert("请先登录");
						istrue = false;
					} else { //登录了就执行下面
						if(playnum <= 0) { //当抽奖次数为0的时候执行

							$('.playbtn').css("background", "url(${path}/STATIC/wxStatic/image/redStar/roundBtnOff.png) no-repeat center center")
							$('.playnum').html(0);
							istrue = false;
						} else { //还有次数就执行
							playnum = playnum - 1; //执行转盘了则次数减1
							if(playnum <= 0) {
								playnum = 0;
							}
							$('.playnum').html(playnum);
							clickfunc();
						}
					}
				});
				var rotateFunc = function(awards, angle) {
					istrue = true;
					$btn.stopRotate();
					$btn.rotate({
						angle: 0,
						duration: 4000, //旋转时间
						animateTo: angle + 1728, //让它根据得出来的结果加上1440度旋转
						callback: function() {
							istrue = false; // 标志为 执行完毕
						}
					});
				};
				//获得积分弹窗
				$(".redstarPointBtn").click(function() {
					$(".redstarPoint").hide()
					
					window.location.href = 'index.do';
				})

				//规则弹窗
				$(".redstarRule").click(function() {
					$("#redstarRuleDiv2").show()
				})
				$(".redstarRuleBtn").click(function() {
					$(".redstarRuleDiv").hide()
					$("#redstarRuleDiv2").hide()
				})

				//丰碑弹窗
				$(".redstarCup").click(function() {
					$("#redstarStele").show()
				})
				$(".redstarSteleBtn").click(function() {
					$("#redstarStele").hide()
				})
				
				// 获取锦囊
				$(".getbagBtn").click(function() {
					
					var contestResult=1;
					
					$.post("${path}/wechatRedStar/saveUserInfo.do", {userId: userId,contestResult:contestResult},function(data){
						
						$(".allDone").hide();
						
						if (data.status == 1) {
							
							$(".revlPop").show();
						}
					}, "json");
				})
				
				// 提交信息
				$(".submitBtn").click(function() {
					
					var userName=$("#userName").val();
					var userTelephone=$("#userTelephone").val();
					
					if(!userName)
						alert("请添写姓名！")
					else if(!userTelephone)
						alert("请添写手机！")
					else{
						
						$.post("${path}/wechatRedStar/saveUserInfo.do", {userId: userId,userName:userName,userTelephone:userTelephone},function(data){
							
							if (data.status == 1) {
								
								$(".submitPop").show();
							}
						}, "json");
					}					
				
				})
				
				$(".miniBag").click(function() {
					
					$(".revlPop").show();
					
				});
				
				
				//分享
				$(".share-button").click(function() {
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
				});
				
				//关注
				$(".keep-button").on("touchstart", function() {
					$('.div-share').show();
					$("body,html").addClass("bg-notouch")
				})
				
				
				$(".backIndex").click(function() {
					window.location.href = 'index.do';
				});
				
				$(".submitPopBtn").click(function(){
					window.location.href = 'inviteFriend.do?toUserId='+userId;
				})
	            
			});
			
			// 邀请
			function invite(){
				if (userId) {
					window.location.href = 'help.do?toUserId='+userId;
				}
			}
			
			// 开始答题
			function startAnswer(){
				
				var topicId=$(".quesStartBtn").attr("topicId");
				var index=$(".quesStartBtn").attr("index");
				
				window.location.href = 'startAnswer.do?topicId='+topicId;
			}
		</script>
	</head>

	<body>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="div-share" >
			<div class="share-bg"></div>
			<div class="share">
				<img src="${path}/STATIC/wechat/image/wx-er2.png" />
				<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
				<p>更多精彩活动、场馆等你发现</p>
				<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
			</div>
		</div>
		<input type="hidden" value="${staticServerUrl }" id="staticServerUrl">
		<div class="redstarMain indexBg" >
			<!--首页分享，WHY，关注按钮-->
			<div class="redstarBtnList">
				<div class="redstarKepp keep-button">
					<img src="${path}/STATIC/wxStatic/image/redStar/btn_keep.png" />
				</div>
				<div class="redstarShare share-button">
					<img src="${path}/STATIC/wxStatic/image/redStar/btn_share.png" />
				</div>
				<div style="clear: both;"></div>
			</div>
			<!--banner-->
			<div class="indexTtImg">
				<img src="${path}/STATIC/wxStatic/image/redStar/index_tt.png" />
			</div>
			<!--大转盘-->
			<div class="playChance">
				<div class="playChanceFont">
					<p>当前挑战机会<span class="playnum"></span>次</p>
					<!-- <div class="inviteBtn" onclick="invite();"><img src="${path}/STATIC/wxStatic/image/redStar/inviteBtn.png" /></div> -->
					<div style="clear: both;"></div>
				</div>
			</div>
			<div class="redstarRound">
				<div class="g-lottery-box">
					<div class="g-lottery-img">
						<a class="playbtn" href="javascript:;" title="开始抽奖"></a>
					</div>
					<div id="light1" style="position: absolute;top: 225px;left: -5px;">
						<img src="${path}/STATIC/wxStatic/image/redStar/light.png" />
					</div>
					<div id="light2" style="position: absolute;top: -5px;left: 313px;">
						<img src="${path}/STATIC/wxStatic/image/redStar/light.png" />
					</div>
					<div id="light3" style="position: absolute;top: 225px;left: 630px;">
						<img src="${path}/STATIC/wxStatic/image/redStar/light.png" />
					</div>
					<div id="light4" style="position: absolute;bottom: -10px;left: 115px;">
						<img src="${path}/STATIC/wxStatic/image/redStar/light.png" />
					</div>
					<div id="light5" style="position: absolute;bottom: -10px;left: 510px;">
						<img src="${path}/STATIC/wxStatic/image/redStar/light.png" />
					</div>
				</div>
			</div>
			<!--开始答题弹窗-->
			<div class="redstarQuesGo">
				<div class="redstarQuesGoPop">
					<p class="startTitle">星火燎原</p>
					<p class="startTips"><span class="userName" style="color: #aa0a28;margin-right: 10px;"></span>同志！您抽中了<span id="questionTitle" style="color: #aa0a28;margin: 0 10px;"></span>版块，组织考验你的时刻到了！</p>
					<div class="quesStartBtn" onclick="startAnswer();">
						<img src="${path}/STATIC/wxStatic/image/redStar/quesStartBtn.png" />
					</div>
				</div>
			</div>
			<!--用户-->
			<div class="redstarHead" >
				<div class="redstarHeadImg">
					<img src="../STATIC/wx/image/sh_user_header_icon.png" width="71" height="65" />
				</div>
				<div class="redstarHeadName">
					<p></p>
				</div>
				<div class="redstarUserBravo">
					<p></p>
				</div>
				<div class="redstarRule">
					<img src="${path}/STATIC/wxStatic/image/redStar/rule.png" />
				</div>
				<div class="redstarCup">
					<img src="${path}/STATIC/wxStatic/image/redStar/cup.png" />
				</div>
				<div class="miniBag" style="display: none;">
					<img src="${path}/STATIC/wxStatic/image/redStar/minibag.png" />
				</div>
			</div>
			<!--底部文字-->
			<div class="redstarP">
				<div class="redstarPDiv">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div id="totalUserCount" class="swiper-slide" style="display: none;">
								<p>全国已有<span>0</span>人走上点亮红星之路</p>
							</div>
							<div id="finishUserCount" class="swiper-slide" style="display: none;">
								<p>全国已有<span>0</span>人完成点亮红星之路</p>
							</div>
							<div id="todayFinishUserCount" class="swiper-slide" style="display: none;">
								<p>今日已有<span>0</span>人完成点亮红星之路</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--0次弹窗-->
			<div class="playnumNone" style="display: none;">
				<div class="playnumNonePop">
					<div class="redstarYaoqing" onclick="invite();">
						<img src="${path}/STATIC/wxStatic/image/redStar/yaoqingtongzhi.png" />
					</div>
					<div class="redstarXiaci" onclick="$('.playnumNone').hide()">
						<img src="${path}/STATIC/wxStatic/image/redStar/xiacitiaozhan.png" />
					</div>
				</div>
			</div>
			<!--获得积分弹窗-->
			<div class="redstarPoint" style="display: none;">
				<div class="redstarPointPop">
					<div class="redstarPointFont">
						<p><span style="color: #aa0a28;margin: 0 10px;" class="userName"></span>同志，感谢您参与革命，特奖励<span id="score" style="color: #aa0a28;margin: 0 10px;"></span>积分以示表彰！</p>
						<p>您可以登录安康文化云个人中心查看、使用积分。</p>
					</div>
					<div class="redstarPointBtn">
						<img src="${path}/STATIC/wxStatic/image/redStar/keepchan.png" />
					</div>
				</div>
			</div>
			<!--信息提交弹窗-->
			<div class="infoSubmit">
				<div class="infoSubmitDiv">
					<div class="infoName">
						<input type="text" id="userName"/>
					</div>
					<div class="infoPhone">
						<input type="text" id="userTelephone"/>
					</div>
					<div class="submitBtn">
						<img src="${path}/STATIC/wxStatic/image/redStar/submitBtn.png" />
					</div>
				</div>
			</div>
			<!--规则弹窗-->
			<div class="redstarRuleDiv" style="display: none;">
				<div class="redstarRuleFont">
					<div class="fontDiv">
						<p>转动红五星轮盘，获得随机题目挑战，挑战成功即刻点亮红星一角！</p>
						<p>点亮红星五个角，即有机会获得革命锦囊!</p>
						<p>每名用户每天有5次抽奖机会</p>
						<p>转发活动至朋友圈，邀请朋友来为我加油，每获得1次加油即多一次抽奖机会。</p>
						<p style="color: #d14445;">【奖项设置】</p>
						<p style="color: #d14445;">革命锦囊：</p>
						<p>所有挑战成功，点亮红五星的用户</p>
						<p>前500名获得价值80元的革命锦囊</p>
						<p>501-1000名获得价值50元的革命锦囊</p>
						<p>1001-5000名获得价值5元的革命锦囊</p>
					</div>
				</div>
				<div class="redstarRuleBtn">
					<img src="${path}/STATIC/wxStatic/image/redStar/confirmbtn.png" />
				</div>
			</div>
			
			<div class="redstarStele" id="redstarRuleDiv2" style="display: none;">
				<div class="redstarSteleDiv" style="overflow: hidden;background: url(${path}/STATIC/wxStatic/image/redStar/bg_rule.png) no-repeat center center;">
					<div style="width: 534px;height: 700px;overflow-y: scroll;margin-top: 170px;-webkit-overflow-scrolling : touch;">
						<div class="fontDiv" style="padding-top: 0;">
							<p>[活动时间]</p>
							<p>即日-2016.10.31</p>
							<p>[参与活动]</p>
							<p>1、转动红五星轮盘，获得随机题目挑战，挑战成功即刻点亮红星一角！</p>
							<p>&bull;每一关有若干道题目，必须一次性全部答对才能点亮一角喔！</p>
							<p>&bull;每名用户每天有5次挑战机会，不累计，成功挑战一关，当即可再多获得一次挑战机会。</p>
							<p>2、点亮红星五个角，即有机会获得革命锦囊!</p>
							<p>&bull;请在获取锦囊的页面根据引导填写正确的个人信息，便于发奖，如因手机号码错误等原因造成无法联系到用户的，则锦囊无法颁发。</p>
							<p>3、转发活动至朋友圈，邀请朋友为“我”加油，每获得1次加油，即多一次挑战机会（以独立用户记，每多一名独立用户为我“加油”，当即获赠挑战机会）</p>
							<p>[奖项设置]</p>
							<p>1、革命锦囊：</p>
							<p>（第一阶段）</p>
							<p>所有挑战成功，点亮红五星的用户中，</p>
							<p>&bull;前500名获得价值80元的革命锦囊</p>
							<p>l	501-1000名获得价值50元的革命锦囊</p>
							<p>l	1001-5000名获得价值5元的革命锦囊</p>
							<p>（第二阶段）（5000名之后）</p>
							<p>所有挑战成功，点亮红五星的用户中，</p>
							<p>每天前5名获得价值50元的革命锦囊</p>
							<p>2、星火燎原奖：</p>
							<p>至活动结束，获得加油最多的1名用户，获得价值4999元的“红色之旅”五天四晚双人自由行一份。</p>
							<p>[如何领奖]</p>
							<p>1、领奖的详细信息会在活动结束前在文化云微信公众号上公示，请关注文化云微信公众号。</p>
							<p>2、请用户妥善保管获得锦囊短信，部分奖品需凭手机号码+锦囊短信在2016.11.30前至文化云上海办公室领取，领奖时间正常为工作日：</p>
							<p>10:00-16:00</p>
							<p>3、具体地址与联系信息，会通过“文化云”微信公众号告知。</p>
							<p>4、在指定时间内，现场领奖需核对本人身份证原件，和登记身份证验证一致后方可领取。如请他人代领，需持代领人及登记人的身份证件。</p>
							<p>5、以上最终解释权归上海创图网络科技有限公司所有。</p>
						</div>
					</div>
				</div>
				<div class="redstarRuleBtn">
					<img src="${path}/STATIC/wxStatic/image/redStar/confirmbtn.png" />
				</div>
			</div>
			
			
			<!--革命锦囊弹窗-->
			<div class="revlPop">
				<div class="revlPopEr">
					<img src="${path}/STATIC/wxStatic/image/redStar/revlBag.png" />
					<p class="revlPopFont">您已于<span id="yyyy" style="color: #aa0a28;">${year }</span>年<span id="mm" style="color: #aa0a28;">${month }</span>月<span id="dd" style="color: #aa0a28;">${day }</span >日获得一只价值<span class="gift" style="color: #aa0a28;"></span>元的革命锦囊，请关注“文化云”微信公众号，关注锦囊领取信息。请妥善保管您的锦囊短信，届时兑现锦囊喔！</p>
					<div class="revlPopQrcode">
						<img src="${path}/STATIC/wxStatic/image/redStar/qrcode.png" />
					</div>
					<div class="revlPopBtn backIndex" >
						<img src="${path}/STATIC/wxStatic/image/redStar/confirm.png" />
					</div>
				</div>
			</div>
			<!--丰碑弹窗-->
			<div class="redstarStele" id="redstarStele" style="display: none;">
				<div class="redstarSteleDiv">
					<!-- 我的排名 -->
					<div class="redstarRankingMe">
					</div>
					<!--前十排名-->
					<div class="RankingList">
						<ul class="redstarRanking">
							
						</ul>
					</div>
				</div>
				<div class="redstarSteleBtn">
					<img src="${path}/STATIC/wxStatic/image/redStar/confirmbtn.png" />
				</div>
			</div>
			<!--通关-->
			<div class="allDone"  style="display: none;">
				<div class="allDoneImg">
					<p class="allDoneTitle">通关啦</p>
					<p class="allDoneFont"><span style="line-height: 30px;margin-right: 20px;color: #b21828;display:inline-block;width:160px;white-space : nowrap;text-overflow : ellipsis;-o-text-overflow : ellipsis;overflow : hidden;text-align:center;" class="userName"></span>同志！终于等到您走完长征之路！<br />您是第<span id="successRanking" style="width: 100px;display: inline-block;text-align: center;color: #b21828;"></span>位点亮红星的革命者，奖励您一个<img src="${path}/STATIC/wxStatic/image/redStar/bag.png" style="vertical-align: middle;" />革命锦囊</p>
					<p class="gift" style="width: 40px;height: 40px;position: absolute;left: 213px;top: 295px;font-size: 26px;color: #b21828;text-align: center;line-height: 40px;"></p>
					<div class="getbagBtn">
						<img src="${path}/STATIC/wxStatic/image/redStar/getbag.png" />
					</div>
				</div>
			</div>
			
			<!--提交成功弹窗-->
			<div class="submitPop">
				<div class="submitPopEr">
					<img src="${path}/STATIC/wxStatic/image/redStar/submitPop.png" />
					<div class="submitPopBtn">
						<img src="${path}/STATIC/wxStatic/image/redStar/submitPopBtn.png" />
					</div>
				</div>
			</div>
		</div>
	</body>

</html>