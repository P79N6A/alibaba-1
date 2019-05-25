<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>活动详情</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>

    <script>
        var activityId = '${activityId}';
        var lat = '';
        var lon = '';
        var activityTel = '';
        var shareUrl = '';
        var integralStatus = '';	//0：可以预定；1：未达最低积分；2：未达抵扣积分
        var activityIsFree = ''; // 1.免费 2.收费 3.付款
        
        if (is_weixin()) {
            wx.config({
                debug: false,
                appId: '${sign.appId}',
                timestamp: '${sign.timestamp}',
                nonceStr: '${sign.nonceStr}',
                signature: '${sign.signature}',
                jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
            });
            wx.ready(function () {
            	var activityIconUrl = '${activity.activityIconUrl}'.indexOf("http://")<0?getIndexImgUrl(getImgUrl('${activity.activityIconUrl}'), "_750_500"):getIndexImgUrl('${activity.activityIconUrl}', "_750_500");
                wx.onMenuShareAppMessage({
                    title: "我在安康文化云免费预订了一个超棒的文化活动-[${activity.activityName}]",
                    desc: '汇聚${cityName}最全文化活动',
                    imgUrl: activityIconUrl,
                    link: '${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}&callback=${callback}&sourceCode=${sourceCode}',
                    success: function () { 
                    	shareIntegral();
                    }
                });
                wx.onMenuShareTimeline({
                	title: "我在安康文化云免费预订了一个超棒的文化活动-[${activity.activityName}]",
                    imgUrl: activityIconUrl,
                    link: '${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}&callback=${callback}&sourceCode=${sourceCode}',
                    success: function () { 
                    	shareIntegral();
                    }
                });
                wx.onMenuShareQQ({
                	title: "我在安康文化云免费预订了一个超棒的文化活动-[${activity.activityName}]",
                	desc: '汇聚${cityName}最全文化活动',
                	link: '${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}&callback=${callback}&sourceCode=${sourceCode}',
                    imgUrl: activityIconUrl,
                    success: function () {
                    	shareIntegral();
                    }
                });
                wx.onMenuShareWeibo({
                	title: "我在安康文化云免费预订了一个超棒的文化活动-[${activity.activityName}]",
                	desc: '汇聚${cityName}最全文化活动',
                	link: '${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}&callback=${callback}&sourceCode=${sourceCode}',
                    imgUrl: activityIconUrl,
                    success: function () { 
                    	shareIntegral();
                    }
                });
                wx.onMenuShareQZone({
                	title: "我在安康文化云免费预订了一个超棒的文化活动-[${activity.activityName}]",
                	desc: '汇聚${cityName}最全文化活动',
                	link: '${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}&callback=${callback}&sourceCode=${sourceCode}',
                    imgUrl: activityIconUrl,
                    success: function () { 
                    	shareIntegral();
                    }
                });
            });
        }
        
        $(function () {

            $.post("${path}/wechatActivity/activityWcDetail.do", {activityId: activityId,userId: userId}, function (data) {
                if (data.status == 1) {
                    var activity = data.data;
                    var _thisModule = activity.activityFunName;
                    lat = activity.activityLat;
                    lon = activity.activityLon;
                    activityTel = activity.activityTel;
                    shareUrl = activity.shareUrl;
                    integralStatus = activity.integralStatus;
                    activityIsFree = activity.activityIsFree;
                    
                    var index=activity.activityIconUrl.lastIndexOf("http://culturecloud.img-cn-hangzhou.aliyuncs.com");
                    
                    if(index>-1){
                    	 $("#activityUrl").attr("src", activity.activityIconUrl+"@800w");
                    }
                    else
                    	$("#activityUrl").attr("src", getIndexImgUrl(activity.activityIconUrl, "_750_500"));
                    if (activity.activityIsCollect == 1) {	//收藏
                        $(".footmenu-button3").addClass("footmenu-button3-ck");
                    }
                    $("#activityName").text(activity.activityName);
                    var tagName =activity.tagName;
                    if(tagName)
                    $("#tagNames").append("<li>" + tagName + "</li>");
                    
                    var subList=activity.subList;
                 
                    for (var i = 0; i < subList.length; i++) {
                        $("#tagNames").append("<li>" + subList[i].tagName + "</li>");
                        
                        if(i==1)
                        	break ;
                    }
                    $("#activityAddress").text(activity.activityAddress);
                    if(activity.activitySite.length>0){
                    	$("#activitySite").append("."+activity.activitySite);
                    }
                    $("#activityTel").text(activity.activityTel);
                    $("#activityStartTime").html(activity.activityStartTime.replace("-",".").replace("-","."));
                    if (activity.activityEndTime.length != 0&&activity.activityStartTime!=activity.activityEndTime) {
                        $("#activityStartTime").append("&nbsp;-&nbsp;"+activity.activityEndTime.replace("-",".").replace("-","."));
                    }
                    var timeQuantums = activity.timeQuantum.split(",");
                    for (var i=timeQuantums.length-1; i>=0; i--) {
                    	$("#timeQuantums").prepend("<li><p style='margin:0'>"+timeQuantums[i]+"</p></li>");
                    }
                    if(activity.activityIsFree==2||activity.activityIsFree==3){
    					if (activity.activityPrice.length != 0 && activity.activityPrice > 0) {
    						if(activity.priceType==0){
    							$("#activityPrice").html("<span style='font-size: 57px;'>"+activity.activityPrice+"</span>元起");
    						}else if(activity.priceType==1){
    							$("#activityPrice").html("<span style='font-size: 57px;'>"+activity.activityPrice+"</span>元/人");
    						}else if(activity.priceType==2){
    							$("#activityPrice").html("<span style='font-size: 57px;'>"+activity.activityPrice+"</span>元/张");
    						}else if(activity.priceType==3){
    							$("#activityPrice").html("<span style='font-size: 57px;'>"+activity.activityPrice+"</span>元/份");
    						}
	                    } else {
	                    	$("#activityPrice").html("<span style='font-size: 57px;'>收费</span>");
	                    }
    				}else{
    					$("#activityPrice").html("<span style='font-size: 57px;'>免费</span>");
    				}
                    if(activity.activityIsReservation == 2) {
                    	if(activity.spikeType==1){	//秒杀
                    		$("#activityAbleCount").append("限时秒杀");
                    	}else{
                    		$("#activityAbleCount").append("余票<span style='color: #FA880B;'>"+activity.activityAbleCount+"</span>张");
                    	}
                    }else{
                    	if(activity.activitySupplementType == 1){
                    		$("#activityAbleCount").append("不可预订");
                		}else if(activity.activitySupplementType == 2){
                			$("#activityAbleCount").append("无需预约");
                		}else if(activity.activitySupplementType == 3){
                			$("#activityAbleCount").append("电话预约");
                		}
                    }
                    if (activity.spikeType==0){		//非秒杀
                    	if (activity.activityIsPast==1) {
                        	$("#orderButton").append("<button type='button' class='button-dis'>已结束</button>");
                        }else{
                        	if(activity.activityIsReservation == 2){
                        		if(activity.activityAbleCount > 0){
                        			if(activity.status.indexOf(1)>=0){
                        				if(activity.activityIsFree==3){
                        					$("#orderButton").append("<button type='button' onclick='preOrder();'>立即预订</button>");
                        				}
                        				else
                        					$("#orderButton").append("<button type='button' onclick='preOrder();'>立即预约</button>");
                        			}else{
                        				$("#orderButton").append("<button type='button' class='button-dis'>无法预订</button>");
                        			}
                        		}else{
                        			$("#orderButton").append("<button type='button' class='button-dis'>已订完</button>");
                        		}
                        	}else{
                        		if(activity.activitySupplementType == 1){
                        			$("#orderButton").append("<button type='button' class='button-dis'>不可预订</button>");
                        		}else if(activity.activitySupplementType == 2){
                        			$("#orderButton").append("<button type='button' class='button-dis'>直接前往</button>");
                        		}else if(activity.activitySupplementType == 3){
                        			$("#orderButton").append("<button type='button' class='button-dis'>电话预约</button>");
                        		}
                        	}
                        }
                    }
                    if (activity.activityTimeDes.length > 0) {
                    	$("#activityTimeDes").text(activity.activityTimeDes);
                        $("#activityTimeDes").show();
                    }
                    if(activity.activityTips){
                    	 $("#activityTips").html(activity.activityTips.replace("温馨提示：",""));
                    }
                    if(activity.lowestCredit&&activity.costCredit){
                		$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>预订需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分，且每张需抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分</p></div>");
                	}else if(activity.lowestCredit&&!activity.costCredit){
                		$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分才可预订</p></div>");
                	}else if(!activity.lowestCredit&&activity.costCredit){
                		$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>每张票务需要抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分</p></div>");
                	}
                    if(activity.deductionCredit){
                    	$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>此活动热门，预订后未到场将会被扣除<span class='cd58185'>"+activity.deductionCredit+"</span>积分</p></div>");
                    	if($(".footer>.tips").length==2){
                    		$(".content").removeClass("padding-bottom170").addClass("padding-bottom220");
                    	}else if($(".footer>.tips").length==1){
                    		$(".content").addClass("padding-bottom170");
                    	}
                    }
                    if (activity.spikeType==1){		//秒杀
                    	activitySpike(activity.activityIsPast);
                    	if(activity.lowestCredit&&activity.costCredit){
                    		$("#spikeCredit").html("预订需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分，且每张需抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分");
                    	}else if(activity.lowestCredit&&!activity.costCredit){
                    		$("#spikeCredit").html("需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分才可预订");
                    	}else if(!activity.lowestCredit&&activity.costCredit){
                    		$("#spikeCredit").html("每张票务需要抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分");
                    	}
                    }
                    if (activity.activityMemo.length > 0) {
                        $("#activityMemoLi").show();
                        $("#activityMemo").html(activity.activityMemo);
                        formatStyle("activityMemo");
                        /* //判断详情收起展开
                        var height = $(".active-detail-p1-show").height();
        				if (height > 1000) {
        					$(".active-detail-p1-arrowdown").click(function() {
        						$(".active-detail-p1-arrowdown").toggleClass("active-detail-p1-arrowdown-rol")
        						$(".active-detail-p1").toggleClass("active-detail-p1-hide");
        					})
        				} else {
        					$(".active-detail-p1").css("height", height)
        					$(".active-detail-p1-arrowdown").css("display", "none")
        				} */
                    }
					if(activity.activityHost.length>0||activity.activityOrganizer.length>0||activity.activityCoorganizer.length>0
							||activity.activityPerformed.length>0||activity.activitySpeaker.length>0){
						$("#activityCompanyLi").show();
					}
					if(activity.activityHost.length>0){
						$("#activityCompanyUl").append("<li>" +
															"<div class='f-left w100 p2-font'><p class='w3 fs28'>主办方</p></div>" +
															"<div class='f-left w500'><p class='fs28'>:&nbsp;"+activity.activityHost+"</p></div>" +
															"<div style='clear: both;'></div>" +
													   "</li>");
					}
					if(activity.activityOrganizer.length>0){
						$("#activityCompanyUl").append("<li>" +
															"<div class='f-left w100 p2-font'><p class='fs28'>承办单位</p></div>" +
															"<div class='f-left w500'><p class='fs28'>:&nbsp;"+activity.activityOrganizer+"</p></div>" +
															"<div style='clear: both;'></div>" +
													   "</li>");
					}
					if(activity.activityCoorganizer.length>0){
						$("#activityCompanyUl").append("<li>" +
															"<div class='f-left w100 p2-font'><p class='fs28'>协办单位</p></div>" +
															"<div class='f-left w500'><p class='fs28'>:&nbsp;"+activity.activityCoorganizer+"</p></div>" +
															"<div style='clear: both;'></div>" +
													   "</li>");
					}
					if(activity.activityPerformed.length>0){
						var linkClass = "";
						if(activity.assnId.length>0){
							linkClass = "class='activeLink' onclick='location.href=\"${path}/wechatAssn/toAssnDetail.do?assnId="+activity.assnId+"\"'";
						}
						var assnSubUl = "";
						if(activity.assnSub){
							$.each(activity.assnSub, function (i, sub) {
								assnSubUl += "<li><p>"+sub+"</p></li>";
							});
						}
						assnSubUl += "<div style='clear: both;'></div>";
						$("#activityCompanyUl").append("<li "+linkClass+">" +
															"<div class='f-left w100 p2-font'><p class='fs28'>演出单位</p></div>" +
															"<div class='f-left w500'>" +
																"<p class='fs28'>:&nbsp;"+activity.activityPerformed+"</p>" +
																"<ul class='activeTag'>"+assnSubUl+"</ul>" +
															"</div>" +
															"<div style='clear: both;'></div>" +
													   "</li>");
					}
					if(activity.activitySpeaker.length>0){
						$("#activityCompanyUl").append("<li>" +
															"<div class='f-left w100 p2-font'><p class='w3 fs28'>主讲人</p></div>" +
															"<div class='f-left w500'><p class='fs28'>:&nbsp;"+activity.activitySpeaker+"</p></div>" +
															"<div style='clear: both;'></div>" +
													   "</li>");
					}
					
                    if (activity.activityIsWant != 0) {		//点赞（我想去）
                    	$(".footmenu-button2").addClass("footmenu-button2-ck");
                    }

                    //load视频
                    if (_thisModule.indexOf("视频") != -1 && data.data2.length > 0) {
                        $("#_thisVideo").show();
                        $("#videoTotal").html(data.data2.length);
                        $.each(data.data2, function (i, dom) {
                        	if(i==3){
                        		return false;
                        	}
                        	$("#videoUl").append("<li class='p3-video-right'>" +
													"<div class='p3-video-1'>" +
														"<video poster='" + getIndexImgUrl(dom.videoImgUrl, "_750_500") + "' src='"+dom.videoLink+"' style='width:226px;' controls></video>" +
														"<p>"+dom.videoTitle+"</p>" +
													"</div>" +
												 "</li>");
                        });
                    }

                    /* //load投票
                    if (_thisModule.indexOf("我要投票") != -1) {
                        $("#voteIndex").load("${path}/frontVote/index.do?activityId=${activityId}", function () {
                        	if ($("#voteNoData").val()) {
                                return;
                            }
                            $("#thisVote").show();
                            $("#voteIndex img").each(function () {
                                $(this).attr("src", getImgUrl(getIndexImgUrl($(this).attr("data-src"), "_750_500")));
                            });
                        });
                    }

                    //load实况直击
                    if (_thisModule.indexOf("实况直击") != -1) {
                        $("#actNews").load("${path}/frontNews/index.do?activityId=${activityId}", function () {
                        	if ($("#newsNoData").val()) {
                                return;
                            }
                            $("#thisNews").show();
                            $("#actNews img").each(function () {
                                $(this).attr("src", getImgUrl(getIndexImgUrl($(this).attr("data-src"), "_300_300")));
                            });
                        });
                    } */
					
                }  else if (data.status == 500) {
                    window.location.href = "${path}/timeOut.html";
                }
            }, "json");

            //收藏
            $(".footer").on("click", '.footmenu-button3', function () {
                if (userId == null || userId == '') {
                	publicLogin('${basePath}wechatActivity/preActivityDetail.do?activityId=' + activityId);
                    return;
                }

                if ($(this).hasClass("footmenu-button3-ck")) {
                    $.post("${path}/wechatActivity/wcDelCollectActivity.do", {
                        activityId: activityId,
                        userId: userId
                    }, function (data) {
                        if (data.status == 0) {
                            $(".footmenu-button3").removeClass("footmenu-button3-ck");
                            dialogAlert("收藏提示", "已取消收藏！");
                        }
                    }, "json");
                } else {
                    $.post("${path}/wechatActivity/wcCollectActivity.do", {
                        activityId: activityId,
                        userId: userId
                    }, function (data) {
                        if (data.status == 0) {
                            $(".footmenu-button3").addClass("footmenu-button3-ck");
                            dialogAlert("收藏提示", "收藏成功！");
                        }
                    }, "json");
                }
            });
            
            //底部菜单隐藏
            $(document).on("touchmove",function(){
            	if(/Android (\d+\.\d+)/.test(ua)) {
    				var version = parseFloat(RegExp.$1);
    				if(version < 5) {
    					return;
    				}
    			}
				$(".footer").hide()
			}).on("touchend",function(){
				$(".footer").show()
			});

            wantGo();	//我想去列表

            loadComment();		//评论列表
        });
        
        //秒杀播报
        function activitySpike(activityIsPast){
        	$.post("${path}/wechatActivity/wcActivityEventList.do", {activityId: activityId}, function (data) {
        		if(data.status==200){
        			if(data.data.length>0){
        				$("#spikeList").empty();
        				$("#orderButton").empty();
        				$("#spikeLi").show();
        				var spikeCurrCount = '';		//当前票数
        				var spikeAbleCount = 0;		//所有场次总票数
        				var spikeDifference = '';	//秒杀倒计时
        				//获取秒杀场次数组
        				var spikeArry = [];
        				$.each(data.data, function (i, dom) {
        					if(dom.spikeType==1){
        						spikeArry.push(dom);
        					}
        				});
        				//记录已结束的场次节点
        				var spikeIndex = -1;
        				for(var i=spikeArry.length-1;i>=0;i--){
        					if(spikeArry[i].spikeType==1){
        						if(spikeArry[i].spikeDifference<=0){
        							if(spikeArry[i].availableCount==0){
        								spikeIndex = i;
        								break;
        							}
        						}
        					}
        				}
        				$.each(spikeArry, function (i, dom) {
       						var d = new Date(dom.spikeTime * 1000);
           					var spikeClass = '';
           					var spikeStatus = '';
           					if(activityIsPast==1){
           						spikeClass = 'bgf2f2f2 c808080 ms-live-off';
           						spikeStatus = '已结束';
           					}else{
           						if(dom.spikeDifference<=0){
               						spikeCurrCount += dom.availableCount;
               						if(dom.availableCount==0){
               							spikeClass = 'bgf2f2f2 c808080 ms-live-off';
                   						spikeStatus = '已结束';
               						}else{
               							if(i<=spikeIndex){
               								spikeClass = 'bgf2f2f2 c808080 ms-live-off';
                       						spikeStatus = '已结束';
               							}else{
               								spikeClass = 'bgc05459 cfff ms-live-on';
                       						spikeStatus = '正在秒杀';
               							}
               						}
               					}else{
               						if(dom.spikeDifference<=86400){
                   						spikeClass = 'bg7279a0 cfff ms-live-on';
                   						spikeStatus = '即将开始';
                   						
                   						if(!spikeDifference&&spikeAbleCount==0){
                   							spikeDifference = dom.spikeDifference;
                   						}
                   					}else{
                   						spikeClass = 'bgdde0f2 c808080 ms-live-off';
                   						spikeStatus = '未开始';
                   					}
               					}
           					}
           					spikeAbleCount += dom.availableCount;
           					$("#spikeList").append("<li class='padding-left50 fs28 "+spikeClass+"'>" +
   		    											"<div class='ms-live-list'>"+(d.getFullYear())+"."+formatTime((d.getMonth()+1))+"."+formatTime((d.getDate()))+"</div>" +
   		    											"<div class='ms-live-list' style='width:80px;'>"+formatTime((d.getHours()))+":"+formatTime((d.getMinutes()))+"</div>" +
   		    											"<div class='ms-live-list border-right w100'>"+dom.availableCount+"张</div>" +
   		    											"<div class='ms-live-list'>"+spikeStatus+"</div>" +
   		    											"<div style='clear: both;'></div>" +
   		    									   "</li>");
        				});
        				
        				if(activityIsPast==1){
        					$("#orderButton").append("<button type='button' class='button-dis'>已结束</button>");
        				}else{
        					if(spikeAbleCount==0){
            					$("#orderButton").append("<button type='button' class='button-dis'>已订完</button>");
            				}else{
               					if(spikeDifference){
               						spikeTime(spikeDifference);
               					}else{
               						if(spikeCurrCount>0){
                   						$("#orderButton").append("<button type='button' class='bgc05459' onclick='activitySpike();preOrder();'>秒杀</button>");
                   					}else{
                   						$("#orderButton").append("<img class='renovate' src='${path}/STATIC/wechat/image/renovate.png'/>" +
                   											"<button type='button' class='button-dis' onclick='refreshSpike();'>未开始</button>");
                   					}
               					}
                			}
        				}
        			}
        		}
        	}, "json");
        }
        
      	//秒杀刷新按钮
        function refreshSpike(){
        	$(".renovate").css({
				"transform": "rotateZ(360deg)",
				"-webkit - transform": "rotateZ(360deg)",
				"- moz - transform": "rotateZ(360deg)",
				"- o - transform": "rotateZ(360deg)",
				"- ms - transform": "rotateZ(360deg)"
			});
        	setTimeout(function () { 
        		activitySpike();
       		},900);
        }
        
        //秒杀倒计时
        function spikeTime(Dtime) {
			var hour = Math.floor((Dtime / 3600) % 24);
			var min = Math.floor((Dtime / 60) % 60);
			var sec = Math.floor(Dtime % 60);
			$("#orderButton").html('<button type="button">'+formatTime(hour)+'<span class="fs24">小时</span>'+formatTime(min)+'<span class="fs24">分</span>'+formatTime(sec)+'<span class="fs24">秒  后开始</span></button>');
			var ss = setInterval(function() {
				sec -= 1;
				if (sec < 0) {
					sec = 59;
					min -= 1;
					if (min < 0) {
						min = 59;
						hour -= 1;
						if( hour < 0){
							hour = 23;
						}
					}
				}
				$("#orderButton").html('<button type="button">'+formatTime(hour)+'<span class="fs24">小时</span>'+formatTime(min)+'<span class="fs24">分</span>'+formatTime(sec)+'<span class="fs24">秒  后开始</span></button>');
				if (sec == 0 && min == 0 && hour == 0) {
					clearInterval(ss);
					activitySpike();
				}
			}, 1000)
		}
        
        //修正时间显示
        function formatTime(i){    
           if (i < 10) {    
               i = "0" + i;    
            }    
           return i;    
        }
        
        //分享获得积分
        function shareIntegral(){
        	if (userId != null && userId != '') {
        		$.ajax({
          			type: 'post',  
        			url : "${path}/wechatUser/forwardingIntegral.do",  
        			dataType : 'json',  
        			data: {userId: userId,url: shareUrl}
        		});
        	}
        }
        
      	//与当前时间做对比
        function compareTime(time) {
            var date = new Date();
            now = date.getFullYear() + "/";
            now = now + (date.getMonth() + 1) + "/";
            now = now + date.getDate();
            var cha = (Date.parse(now) - Date.parse(time.replace("-", "/").replace("-", "/"))) / 3600000;
            if (cha > 0) {
                return true;
            } else {
                return false;
            }
        }

        //点赞（我想去）
        function addWantGo() {
            if (userId == null || userId == '') {
            	publicLogin('${basePath}wechatActivity/preActivityDetail.do?activityId=' + activityId);
                return;
            }

            $.post("${path}/wechatActivity/wcAddActivityUserWantgo.do", {
                activityId: activityId,
                userId: userId
            }, function (data) {
                if (data.status == 0) {
                    wantGo();
                    $(".footmenu-button2").addClass("footmenu-button2-ck");
                } else if (data.status == 14111) {
                    $.post("${path}/wechatActivity/deleteActivityUserWantgo.do", {
                        activityId: activityId,
                        userId: userId
                    }, function (data) {
                        if (data.status == 0) {
                            wantGo();
                            $(".footmenu-button2").removeClass("footmenu-button2-ck");
                        }
                    }, "json");
                }
            }, "json");
        }

        //添加评论
        function addComment() {
            if (userId == null || userId == '') {
            	publicLogin('${basePath}wechatActivity/preActivityDetail.do?activityId=' + activityId);

            } else {
                var status = '${sessionScope.terminalUser.commentStatus}';
                if (status == 2) {
                    dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
                } else {
                	window.location.href = "${path}/wechat/preAddWcComment.do?moldId="+activityId+"&type=2&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
                }
            }
        }

        //我想去列表
        function wantGo() {
            var data = {
                activityId: activityId,
                pageIndex: 0,
                pageNum: 10
            };
            $.post("${path}/wechatActivity/wcActivityUserWantgoList.do", data, function (data) {
                if (data.status == 0) {
                	if(data.pageTotal>0){
                		$("#wantGoTotal").html(data.pageTotal);
                		$("#wantGoLi").show();
                	}else{
                		$("#wantGoLi").hide();
                		return;
                	}
                    $("#wantGoList").html("");
                    $.each(data.data, function (i, dom) {
                        
                        if (dom.userHeadImgUrl.indexOf("http") == -1) {
                            $("#wantGoList").append("<li><img src='../STATIC/wx/image/sh_user_header_icon.png' width='65' height='65'></li>");
                        } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
                            var imgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
                            $("#wantGoList").append("<li><img src='" + imgUrl + "' width='65' height='65' onerror='imgNoFind();'></li>");
                        } else {
                            $("#wantGoList").append("<li><img src='" + dom.userHeadImgUrl + "' width='65' height='65' onerror='imgNoFind();'></li>");
                        }
                    });
                }
            }, "json");
            
            //浏览量
            $.post("${path}/wechatActivity/wcCmsActivityBrowseCount.do", data, function (data) {
                if (data.status == 1) {
                	if(data.data>50){	//超过50浏览显示
                		$("#browseTotal").html("，"+data.data+"人浏览");
                	}
                }
            }, "json");
		}
		//更多评论
        function moreComment() {
            window.location.href = "${path}/wechat/preWcCommentList.do?moldId=" + activityId + "&type=2";
        }

        //评论列表
        function loadComment() {
            var data = {
                moldId: activityId,
                type: 2,
                pageIndex: 0,
                pageNum: 10
            };
            $.post("${path}/wechat/weChatComment.do", data, function (data) {
                if (data.status == 0) {
                	if(data.data.length>0){
                		$("#commentLi").show();
                		$("#commentToatl").append(data.pageTotal);
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
                        $("#activityComment").append("<li>" +
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
		//富文本格式修改
        function formatStyle(id) {
            var $cont = $("#" + id);
            $cont.find("img").each(function () {
                var $this = $(this);
                $this.css({"max-width": "710px"});
            });
            $cont.find("p,font").each(function () {
                var $this = $(this);
                $this.css({
                    "font-size": "24px",
                    "line-height": "44px",
                    "color": "#7C7C7C",
                    "font-family": "Microsoft YaHei"
                });
            });
            $cont.find("span").each(function () {
                var $this = $(this);
                $this.css({
                	"font-size": "24px",
                    "line-height": "44px",
                    "font-family": "Microsoft YaHei"
                });
            });
            $cont.find("a").each(function () {
                var $this = $(this);
                $this.css({
                	"text-decoration": "underline",
                	"color": "#7C7C7C"
                });
            });
            var str = $cont.html();
            str.replace(/<span>/g, "").replace(/<\/span>/g, "");
            $cont.html(str);
        }

        //更多视频
        function moreVideo() {
            window.location.href = "${path}/wechatActivity/preVideoList.do?activityId=" + activityId;
        }

        //预订
        function preOrder() {
            if (userId == null || userId == '') {
                publicLogin('${basePath}wechatActivity/preActivityDetail.do?activityId=' + activityId);
                return;
            }
            if(integralStatus==1){
            	dialogAlert("系统提示", "您的积分未达到该活动最低要求！");

            }else if(integralStatus==2){
            	dialogAlert("系统提示", "您的积分不够抵扣该活动！");
       
            }else if(integralStatus==0){
            	window.location.href = "${path}/wechatActivity/preActivityOrder.do?activityId="+activityId+"&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
            }
        }

        //停车场
        function preParking() {
            window.location.href = "${path}/wechat/preParking.do?lat=" + lat + "&lon=" + lon;
        }

        //地址地图
        function preAddressMap() {
        	if(lat<=1&&lon<=1){
        		dialogAlert("系统提示", "暂无相关位置信息");
        	}else{
        		window.location.href = "${path}/wechat/preAddressMap.do?lat=" + lat + "&lon=" + lon;
        	}
        }

        //拨打电话
        function callTel() {
            window.location = "tel:" + activityTel;
        }

        //图片预览
        function previewImage(url,urls) {
            wx.previewImage({
                current: url, // 当前显示图片的http链接
                urls: urls.substring(0, urls.length - 1).split(",")	 // 需要预览的图片http链接列表
            });
        }
    </script>
    
    <style>
		.tab-p5 {
				position: absolute;
				top: 410px;
				right: 36px;
				font-size: 24px;
				color: #fff;
				letter-spacing: 0px;
				height: 40px;
				text-align: center;
				line-height: 40px;
				border-radius: 10px;
				background: url(${path}/STATIC/wechat/image/500.png) no-repeat center center;
				padding: 3px 8px;
		}
		td {vertical-align: top;color:#7C7C7C;}
		#activityMemo img{margin:auto;}
	</style>
</head>
<body>
	<div class="main">
		<div class="header"></div>
		<div class="content">
			<div class="active-top-bor">
				<img id="activityUrl" height="470" width="750"/>
				<img src="${path}/STATIC/wechat/image/蒙板.png" class="masking" />
				<span class="tab-p7"><ul id="tagNames"></ul></span>
				<span class="tab-p8" id="activityPrice"></span>
				<span class="tab-p5" id="activityAbleCount"></span>
				<%-- <span class="tab-p12">
					<a><img src="${path}/STATIC/wechat/image/arrow2.png" width="74px" height="74px" onclick="history.go(-1);"/></a>
				</span>--%>
				<span class="tab-p18">
					<img src="${path}/STATIC/wechat/image/index.png" onclick="toWhyIndex();"/>
				</span>
			</div>
			<div class="active-top">
				<ul>
					<li style="padding:20px 10px;"><h1 id="activityName"></h1></li>
					<li class="border-bottom active-place" onclick="preAddressMap();">
						<img src="${path}/STATIC/wechat/image/icon_地址.png" />
						<p class="active-detail-place" id="activityAddress"></p>
						<div style="clear: both;"></div>
					</li>
					<li class="border-bottom">
						<img src="${path}/STATIC/wechat/image/icon_日期.png" />
						<p id="activityStartTime"></p>
						<div style="clear: both;"></div>
					</li>
					<li class="border-bottom">
						<img src="${path}/STATIC/wechat/image/icon_时间.png" />
						<div class="active-top-time">
							<ul id="timeQuantums" style="margin: 20px 0;">
								<div style="clear: both;"></div>
							</ul>
							<p id="activityTimeDes" style="margin-top: 0;display: none;"></p>
						</div>
					</li>
					<li>
						<img src="${path}/STATIC/wechat/image/icon_电话.png" />
						<p style="color: #929edb;float: left;" id="activityTel" onclick="callTel();"></p>
						<div style="clear: both;"></div>
					</li>
				</ul>
			</div>
			<div class="active-detail">
				<ul>
					<li id="spikeLi" style="display: none;">
						<div class="active-border active-tab">
							<div class="active-detail-p3">
								<h1 class="border-bottom">秒杀播报</h1>
								<p class="p4-right c808080 fs26" id="spikeCredit"></p>
								<div class="ms-live margin-top20">
									<ul id="spikeList"></ul>
								</div>
							</div>
						</div>
					</li>
					<li id="activityMemoLi" style="display: none;">
						<div class="active-border active-tab">
							<div class="active-detail-p1 active-detail-p1-hide">
								<div class="active-detail-p1-show">
									<h1 class="border-bottom">活动详情</h1>
									<p id="activityMemo"></p>
								</div>
							</div>
							<!-- <div class="active-detail-p1-arrowdown"></div> -->
						</div>
					</li>
					<li id="activityCompanyLi" style="display: none;">
						<div class="active-border">
							<div class="active-detail-p2">
								<h1 style="color:#808080" class="border-bottom">活动单位</h1>
								<ul style="color:#808080" class="unit-detail" id="activityCompanyUl"></ul>
							</div>
						</div>
					</li>
					<li>
						<div class="active-border active-tab">
							<div class="active-detail-p3">
								<h1 class="border-bottom">温馨提示</h1>
								<p class="fs24 c808080 margin-top20" id="activityTips"></p>
							</div>
						</div>
					</li>
					<li id="_thisVideo" style="display: none">
						<div class="active-border">
							<div class="active-detail-p3">
								<h1 class="border-bottom active-p4-arrowr" onclick="window.location.href='${path}/wechatActivity/preVideoList.do?activityId=${activityId}'">相关视频</h1>
								<p class="p3-right" style="margin-right: 30px;line-height: 30px;">共<span style="color: #fcaf5b;" id="videoTotal"></span>个视频</p>
								<div class="p3-video">
									<ul id="videoUl"></ul>
								</div>
							</div>
						</div>
					</li>
					<li id="thisVote" style="display: none">
						<div class="active-border">
							<div class="active-detail-p4">
								<h1 class="border-bottom active-p4-arrowr" onclick="window.location.href='${path}/frontVote/list.do?activityId=${activityId}'">投票活动</h1>
								<div class="p3-video">
									<ul id="voteIndex"></ul>
								</div>
							</div>
						</div>
					</li>
					<li id="thisNews" style="display: none">
						<div class="active-border">
							<div class="active-detail-p5">
								<h1 class="border-bottom active-p4-arrowr" onclick="window.location.href='${path}/frontNews/list.do?activityId=${activityId}'">实况直击</h1>
								<div class="live">
									<ul id="actNews"></ul>
								</div>
							</div>
						</div>
					</li>
					<li id="wantGoLi" style="display: none;">
						<div class="active-border">
							<div class="active-detail-p6">
								<p>共<span style="color: #fcaf5b;" id="wantGoTotal"></span>人赞过
								<span style="color: #fcaf5b;display: none;" id="browseTotal"></span></p>
								<ul id="wantGoList"></ul>
							</div>
						</div>
					</li>
					<li id="commentLi" style="display: none;">
						<div style="margin-bottom: 0px;" class="active-border">
							<div class="active-detail-p7 commentImgHtml">
								<p class="border-bottom">共<span style="color: #fcaf5b;" id="commentToatl"></span>条评论</p>
								<ul id="activityComment"></ul>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="footer">
			<div class="active-footmenu">
				<ul style="float: left;">
					<li class="active-footmenu-border">
						<div class="footmenu-button1" onclick="addComment();"><p>评论</p></div>
					</li>
					<li class="active-footmenu-border">
						<div class="footmenu-button2" onclick="addWantGo();"></div>
					</li>
					<li class="active-footmenu-border">
						<div class="footmenu-button3"></div>
					</li>
					<li style="padding-right: 13px;">
						<div class="footmenu-button4"></div>
					</li>
					<div style="clear: both;"></div>
				</ul>
				<div class="footmenu-button5" id="orderButton"></div>
				<div style="clear: both;"></div>
			</div>
		</div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
		<c:if test="${false}">
			<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
			<script>
				//底部菜单
				$(document).on("touchmove", function() {
					$(".footerBtn").hide()
				}).on("touchend", function() {
					$(".footerBtn").show()
				})
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
			</script>
		</c:if>
		
		<script>
			$(document).ready(function() {
				$(".footmenu-button4").click(function() {
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
		</script>
	</div>

<script type="text/javascript">
    //判断是否从评论页返回
    if ('${type}' == 'fromComment') {
        setTimeout(function () {
            var url = window.location.href;
            if (url.indexOf("#commentLi") == -1)
                window.location.href = url + "#commentLi";
        }, 100);
    }
</script>
</body>
</html>