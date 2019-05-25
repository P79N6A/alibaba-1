<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>场馆详情</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bar-ui.css"/>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/swipe.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/soundmanager2-nodebug.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/bar-ui.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>

    <script type="text/javascript">
        var venueId = '${venueId}';
        var userType = '${sessionScope.terminalUser.userType}';
        var lat = '';
        var lon = '';
        var venueTel = '';
        var shareUrl = '';
        var pageSize = 0, startIndex = 0, isScroll = true;
        $(function () {
        	//判断是否从评论页返回
    	    if ('${type}' == 'fromComment') {
    	        setTimeout(function () {
    	            var url = window.location.href;
    	            if (url.indexOf("#commentLi") == -1)
    	                window.location.href = url + "#commentLi";
    	        }, 100);
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
            }

            venueLoad();	//场馆详情
            roomLoad();		//相关活动室
            activityLoad();		//相关活动
            wantGo();	//我想去列表
            loadComment(0, 10);		//评论

            audiojs.events.ready(function () {
                audiojs.createAll();
            });
        });

        //加载场馆详情
        var venueLoad = function () {
        	$.post("${path}/wechatVenue/venueDetail.do",{venueId: venueId,userId: userId}, function (data) {
        		if (data.status == 0) {
        			var dom = data.data[0];
        			venueTel = dom.venueMobile;
                    lat = dom.venueLat;
                    lon = dom.venueLon;
                    shareUrl = dom.shareUrl;
                    var venueIconUrl = getIndexImgUrl(dom.venueIconUrl, "_750_500");
                    $("#venueImg").attr("src",venueIconUrl);
                    $("#tagName").append("<li>"+dom.tagName+"</li>");
                    if(dom.dictName.length>0){
                    	$("#tagName").append("<li>"+dom.dictName+"</li>");
                    }
                    if(dom.venueIsFree==2){
    					$("#venuePrice").html("收费");
    					if(dom.venuePrice.length != 0){
    						$("#venuePriceLi").show();
    						if (dom.venuePrice > 0) {
        						$("#venuePriceDetail").html(dom.venuePrice+"元/人");
    	                    }else{
        						$("#venuePriceDetail").html(dom.venuePrice);
    	                    }
    					}
    				}else{
    					$("#venuePrice").html("免费");
    				}
                    $("#venueName").html(dom.venueName);
                    $("#venueAddress").html(dom.venueAddress);
                    $("#venueOpenTime").html(dom.venueOpenTime);
                    if (dom.venueEndTime.length != 0) {
                        $("#venueOpenTime").append("&nbsp;-&nbsp;"+dom.venueEndTime);
                    }
                    if(dom.openNotice.length != 0){
                    	$("#venueOpenTime").append("</br>"+dom.openNotice);
                    }
                    $("#venueMobile").html(dom.venueMobile);
                    if (dom.venueVoiceUrl.length > 0) {
                        $("#venueVoiceLi").show();
                        $("#venueVoice").attr("data-href", dom.venueVoiceUrl);
                    }
                    if (data.data1.length > 0) {
                        $("#venueVideoLi").show();
                        var video = data.data1;
                        if (video.length > 0) {
                            $("#videoTitle").html(video[0].videoTitle);
                            $("#btn-play").attr("poster", getIndexImgUrl(video[0].videoImgUrl, "_750_500"));
                            $("#btn-play").attr("src", video[0].videoLink);
                        }
                    }
                    if (data.data1.length > 1) {
                        $("#moreVideo").show();
                        $.each(data.data1, function (i, dom) {
                            var videoImgUrl = getIndexImgUrl(dom.videoImgUrl, "_750_500");
                            if (i == 0) {
                                $("#moreVideo .swiper-wrapper").append("<a class='swiper-slide orange' videoTitle='" + dom.videoTitle + "' videoImgUrl='" + videoImgUrl + "' videoLink='" + dom.videoLink + "'>" +
                                        "<p>" + dom.videoTitle + "</p><span>" + dom.videoCreateTime + "</span>" +
                                        "</a>");
                            } else {
                                $("#moreVideo .swiper-wrapper").append("<a class='swiper-slide' videoTitle='" + dom.videoTitle + "' videoImgUrl='" + videoImgUrl + "' videoLink='" + dom.videoLink + "'>" +
                                        "<p>" + dom.videoTitle + "</p><span>" + dom.videoCreateTime + "</span>" +
                                        "</a>");
                            }
                        });
                        var swiperVideo = new Swiper('#videoList', {
                            slidesPerView: 'auto'
                        });
                        $("#moreVideo .swiper-wrapper a").click(function () {
                            $(this).siblings().removeClass("orange");
                            $(this).addClass("orange");
                            $("#videoTitle").html($(this).attr("videoTitle"));
                            $("#btn-play").attr("poster", $(this).attr("videoImgUrl"));
                            $("#btn-play").attr("src", $(this).attr("videoLink"));
                        });
                    }
                    if (dom.venueMemo.length > 0) {
                        $("#cgDetail").show();
                        $("#venueMemo").html(dom.venueMemo);
                        formatStyle("venueMemo");
                        
                        /* var height = $(".active-detail-p1-show").height();
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
                    if (dom.venueHasAntique == 2) {		//藏品
                    	var data = {
                            venueId: venueId,
                            pageIndex: 0,
                            pageNum: 3
                        };
                    	$.post("${path}/wechatAntique/antiqueAppIndex.do", data, function (data) {
                            if (data.status == 0) {
                            	$("#antiqueTotal").append(data.data3);
                            	if(data.data3>0){
                            		$("#venueAntique").show();
                                    $.each(data.data, function (i, dom) {
                                    	$("#venueAntiqueList").append("<li class='p3-video-right' onclick=\"window.location.href='${path}/wechatAntique/preAntiqueDetail.do?antiqueId=" + dom.antiqueId + "'\">" +
    																		"<div class='p3-video-1'>" +
    																			"<img src='" + dom.antiqueImgUrl + "' width='226' height='150'/>" +
    																			"<p>" + dom.antiqueName + "</p>" +
    																		"</div>" +
    																  "</li>");
                                    });
                            	}
                            }
                        }, "json");
                    }
                    if (dom.venueIsWant != 0) {		//点赞（我想去）
                    	$(".footmenu-button2").addClass("footmenu-button2-ck");
                    }
                    if (dom.venueIsCollect == 1) {	//收藏
                        $(".footmenu-button3").addClass("footmenu-button3-ck");
                    }
                    
                  	//微信分享
                    wx.ready(function () {
                        wx.onMenuShareAppMessage({
                            title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
                            desc: "带你逛遍${cityName}每一个文化角落",
                            imgUrl: venueIconUrl,
                            link: '${basePath}wechatVenue/venueDetailIndex.do?venueId=${venueId}&callback=${callback}&sourceCode=${sourceCode}',
                            success: function () { 
                            	shareIntegral();
                            }
                        });
                        wx.onMenuShareTimeline({
                            title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
                            imgUrl: venueIconUrl,
                            link: '${basePath}wechatVenue/venueDetailIndex.do?venueId=${venueId}&callback=${callback}&sourceCode=${sourceCode}',
                            success: function () { 
                            	shareIntegral();
                            }
                        });
                        wx.onMenuShareQQ({
                        	title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
                        	desc: '带你逛遍${cityName}每一个文化角落',
                            imgUrl: venueIconUrl,
                            link: '${basePath}wechatVenue/venueDetailIndex.do?venueId=${venueId}&callback=${callback}&sourceCode=${sourceCode}',
                            success: function () { 
                            	shareIntegral();
                            }
                        });
                        wx.onMenuShareWeibo({
                        	title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
                        	desc: '带你逛遍${cityName}每一个文化角落',
                            imgUrl: venueIconUrl,
                            link: '${basePath}wechatVenue/venueDetailIndex.do?venueId=${venueId}&callback=${callback}&sourceCode=${sourceCode}',
                            success: function () { 
                            	shareIntegral();
                            }
                        });
                        wx.onMenuShareQZone({
                        	title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
                        	desc: '带你逛遍${cityName}每一个文化角落',
                            imgUrl: venueIconUrl,
                            link: '${basePath}wechatVenue/venueDetailIndex.do?venueId=${venueId}&callback=${callback}&sourceCode=${sourceCode}',
                            success: function () { 
                            	shareIntegral();
                            }
                        });
                    });
        		}
        	}, "json");
        };

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
        
        //评论列表
        function loadComment() {
            var data = {
                moldId: venueId,
                type: 1,
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
                        $("#venueComment").append("<li>" +
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
        ;

      	//图片预览
        function previewImage(url,urls) {
            wx.previewImage({
                current: url, // 当前显示图片的http链接
                urls: urls.substring(0, urls.length - 1).split(",")	 // 需要预览的图片http链接列表
            });
        }

        //添加评论
        function addComment() {
            if (userId == null || userId == '') {
                publicLogin('${basePath}wechatVenue/venueDetailIndex.do?venueId=' + venueId);
                return;
            } else {
                var status = '${sessionScope.terminalUser.commentStatus}';
                if (status == 2) {
                    dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
                } else {
                	window.location.href = "${path}/wechat/preAddWcComment.do?moldId="+venueId+"&type=1&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
                }
            }
        }

        //相关活动室列表
        function roomLoad() {
            var data = {
                venueId: venueId,
                pageIndex: 0,
                pageNum: 3
            };
            $.post("${path}/wechatVenue/activityWcRoom.do", data, function (data) {
                if (data.status == 0) {
                	$("#activityRoomTotal").html(data.pageTotal);
                    $.each(data.data, function (i, dom) {
                        $("#aboutRoom").show();
                        var roomPicUrl = getIndexImgUrl(dom.roomPicUrl, "_300_300");
                        var roomOrder = "";
                        if (dom.roomIsReserve > 0) {
                            roomOrder = "<div class='venue-detail-button' onclick='showRoom(\"" + dom.roomId + "\")'>" +
											"<button type='button'>预订</button>" +
										"</div>";
                        }
                        var price = '';
                        if(dom.roomIsFree==2){
        					price = "收费";
        				}else{
        					price = "免费";
        				}
                        $("#venueRoom").append("<li class='border-bottom'>" +
													"<div class='live-1'>" +
														"<div class='live-left' onclick='showRoom(\"" + dom.roomId + "\");'>" +
															"<img src='" + roomPicUrl + "' width='230' height='150'/>" +
														"</div>" +
														"<div style='margin-left: 10px;' class='live-left' onclick='showRoom(\"" + dom.roomId + "\");'>" +
															"<p class='p1'>" + dom.roomName + "</p>" +
															"<p class='p2'>面积"+dom.roomArea+"平米&nbsp;容纳"+dom.roomCapacity+"人</p>" +
															"<p class='p2'>"+price+"</p>" +
														"</div>" +
														roomOrder +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
                    });
                }
            }, "json");
        };

        //活动室详情
        function showRoom(roomId) {
        	window.location.href = "${path}/wechatRoom/preRoomDetail.do?roomId="+roomId+"&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
        }

        //相关活动列表
        function activityLoad() {
            var data = {
                venueId: venueId,
                pageIndex: 0,
                pageNum: 3
            };
            $.post("${path}/wechatVenue/venueWcActivity.do", data, function (data) {
                if (data.status == 0) {
                	$("#activityTotal").html(data.pageTotal);
                    $.each(data.data, function (i, dom) {
                        $("#aboutActivity").show();
                        var time = dom.activityStartTime.substring(5,10).replace("-",".");
	    				if(dom.activityEndTime.length>0){
	    					time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
	    				}
	    				var price = '';
	    				if(dom.activityAbleCount > 0 || dom.activityIsReservation == 1){
	    					if(dom.activityIsFree==2 || dom.activityIsFree==3){
       	    					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
       	    						if(dom.priceType==0){
       	    							price += "<div class='activePay'><p>" + dom.activityPrice + "元起</p></div>";
    	 	   	    				}else if(dom.priceType==1){
    	  								price += "<div class='activePay'><p>" + dom.activityPrice + "元/人</p></div>";
    	 	   	    				}else if(dom.priceType==2){
    	  								price += "<div class='activePay'><p>" + dom.activityPrice + "元/张</p></div>";
    	 	   	    				}else if(dom.priceType==3){
    	  								price += "<div class='activePay'><p>" + dom.activityPrice + "元/份</p></div>";
    	 	   	    				}else{
       	    							price += "<div class='activePay'><p>" + dom.activityPrice + "元/张</p></div>";
       	    						}
       	                        } else {
       	                        	price += "<div class='activePay'><p>收费</p></div>";
       	                        }
       	    				}else{
       	    					price += "<div class='activePay'><p>免费</p></div>";
       	    				}
	    				}else{
	    					price = "<div class='venue-pay'><span>已订完</span></div>";
	    				}
                        var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_300_300");
                        $("#venueActivity").append("<li class='border-bottom' onclick='showActivity(\"" + dom.activityId + "\")'>" +
														"<div class='live-1' style='border: none;'>" +
															"<div class='live-left'>" +
																"<img src='" + activityIconUrl + "' width='230' height='150'/>" +
															"</div>" +
															"<div style='margin-left: 10px;' class='live-left'>" +
																"<p class='p1'>" + dom.activityName + "</p>" +
																"<p class='p2'>" + dom.activitySubject + "</p>" +
																"<p class='p2'>"+time+"</p>" +
															"</div>" +
															"<div style='clear: both;'></div>" +
															price +
														"</div>" +
													"</li>");
                    });
                }
            }, "json");
        };
        
      	//点赞（我想去）
        function addWantGo() {
            if (userId == null || userId == '') {
            	publicLogin('${basePath}wechatVenue/venueDetailIndex.do?venueId=' + venueId);
                return;
            }

            $.post("${path}/wechatVenue/wcAddVenueUserWantgo.do", {
            	venueId: venueId,
                userId: userId
            }, function (data) {
                if (data.status == 0) {
                    wantGo();
                    $(".footmenu-button2").addClass("footmenu-button2-ck");
                } else if (data.status == 14111) {
                    $.post("${path}/wechatVenue/wcDeleteVenueUserWantgo.do", {
                    	venueId: venueId,
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
        
      	//我想去列表
        function wantGo() {
            var data = {
            	venueId: venueId,
                pageIndex: 0,
                pageNum: 10
            };
            $.post("${path}/wechatVenue/wcVenueUserWantgoList.do", data, function (data) {
                if (data.status == 1) {
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
            $.post("${path}/wechatVenue/wcCmsVenueBrowseCount.do", data, function (data) {
                if (data.status == 1) {
                	if(data.data>50){	//超过50浏览显示
                		$("#browseTotal").html("，"+data.data+"人浏览");
                	}
                }
            }, "json");
        };

        function showActivity(activityId) {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
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

        //地址地图
        function preAddressMap() {
            window.location.href = "${path}/wechat/preAddressMap.do?lat=" + lat + "&lon=" + lon;
        }

        //拨打电话
        function callTel() {
            window.location = "tel:" + venueTel;
        }
        //藏品详情
        function showAntique() {
            window.location.href = "${path}/wechatAntique/preAntiqueList.do?venueId=" + venueId;
        }
        //停车场
        function preParking() {
            window.location.href = "${path}/wechat/preParking.do?lat=" + lat + "&lon=" + lon;
        }

        //收藏
        function venueCollect(){
        	if (userId == null || userId == '') {
        		publicLogin('${basePath}wechatVenue/venueDetailIndex.do?venueId=' + venueId);
                return;
            }

            if ($(".footmenu-button3").hasClass("footmenu-button3-ck")) {
                $.post("${path}/wechatVenue/wcDelCollectVenue.do", {
                    venueId: venueId,
                    userId: userId
                }, function (data) {
                    if (data.status == 0) {
                    	$(".footmenu-button3").removeClass("footmenu-button3-ck");
                        dialogAlert("收藏提示", "已取消收藏！");
                    }
                }, "json");
            } else {
                $.post("${path}/wechatVenue/wcCollectVenue.do", {
                    venueId: venueId,
                    userId: userId
                }, function (data) {
                    if (data.status == 0) {
                    	$(".footmenu-button3").addClass("footmenu-button3-ck");
                        dialogAlert("收藏提示", "收藏成功！");
                    }
                }, "json");
            }
        }
        
      	//活动室查找
        function refRommList() {
            /* if (userId == null || userId == '') {
            	publicLogin('${basePath}wechatVenue/venueDetailIndex.do?venueId=' + venueId);
                return;
            }  */
            window.location.href="${path}/wechatRoom/preRoomList.do?venueId=${venueId}&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
        }
        
      	//活动查找
        function refActList() {
            /* if (userId == null || userId == '') {
            	publicLogin('${basePath}wechatVenue/venueDetailIndex.do?venueId=' + venueId);
                return;
            }  */
            window.location.href="${path}/wechatActivity/preActivityList.do?venueId=${venueId}&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
        }
        
        //分享
        function venueShare(){
        	if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
				dialogAlert('系统提示', '请用微信浏览器打开分享！');
			}else{
				$("html,body").addClass("bg-notouch");
				$(".background-fx").css("display", "block")
			}
        }
    </script>
    
    <style>
		.header {position: relative;}
	</style>
</head>
<body>
	<c:if test="${not empty sessionScope.terminalUser}">
	    <input type="hidden" id="teamUserSize" value="${fn:length(teamUserList)}"/>
	</c:if>
	<div class="main">
		<div class="header"></div>
		<div class="content" style="padding-bottom: 100px;">
			<div class="active-top-bor">
				<img src="" class="masking-down" id="venueImg" height="475" width="750"/>
				<img src="${path}/STATIC/wechat/image/蒙板.png" class="masking" />
				<span class="tab-p7">
					<ul id="tagName"></ul>
				</span>
				<%-- <span class="tab-p12">
					<a><img src="${path}/STATIC/wechat/image/arrow2.png" width="74px" height="74px" onclick="history.go(-1);"/></a>
				</span> --%>
				<span class="tab-p18">
					<img src="${path}/STATIC/wechat/image/index.png" onclick="toWhyIndex();"/>
				</span>
				<span class="tab-p11" id="venuePrice"></span>
			</div>
			<div class="active-top">
				<ul>
					<li style="padding:20px 10px;"><h1 id="venueName"></h1></li>
					<li class="border-bottom active-place" onclick="preAddressMap();">
						<img src="${path}/STATIC/wechat/image/icon_地址.png" />
						<p class="active-detail-place" id="venueAddress"></p>
						<div style="clear: both;"></div>
					</li>
					<li class="border-bottom">
						<img src="${path}/STATIC/wechat/image/icon_时间.png" />
						<p style="width: 600px;" id="venueOpenTime"></p>
						<div style="clear: both;"></div>
					</li>
					<li class="border-bottom" onclick="callTel();">
						<img src="${path}/STATIC/wechat/image/icon_电话.png" />
						<p style="color: #929edb;float: left;" id="venueMobile"></p>
						<div style="clear: both;"></div>
					</li>
					<li id="venuePriceLi" style="display: none;">
						<img src="${path}/STATIC/wechat/image/icon_价格.jpg" />
						<p class="active-detail-place" id="venuePriceDetail"></p>
						<div style="clear: both;"></div>
					</li>
				</ul>
			</div>
			<div class="active-detail">
				<ul>
					<li id="aboutActivity" style="display: none;">
						<div class="active-border">
							<div class="active-detail-p5">
								<h1 class="border-bottom active-p4-arrowr" onclick="refActList();">场馆活动</h1>
								<p class="p3-right" style="margin-right: 30px;line-height: 30px;">
									共<span style="color: #fcaf5b;" id="activityTotal"></span>个活动
								</p>
								<div class="live">
									<ul id="venueActivity"></ul>
								</div>
							</div>
						</div>
					</li>
					<li id="cgDetail" style="display: none;">
						<div class="active-border active-tab">
							<div class="active-detail-p1 active-detail-p1-hide">
								<div class="active-detail-p1-show">
									<h1 class="border-bottom">场馆详情</h1>
									<p id="venueMemo"></p>
								</div>
							</div>
							<!-- <div class="active-detail-p1-arrowdown"></div> -->
						</div>
					</li>
					<li class="active-border" id="venueVoiceLi" style="display: none;">
						<div class="venue_vivid">
							<div class="related_video venue_audio">
								<h1 class="border-bottom">语音导览</h1>
								<div class="sm2-bar-ui compact full-width">
									<div class="bd sm2-main-controls">
										<div class="sm2-inline-element sm2-inline-status">
											<div class="sm2-playlist">
												<div class="sm2-playlist-target">
													<ul class="sm2-playlist-bd">
														<li id="venueVoice" data-href=""><b></b></li>
													</ul>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</li>
					<li class="active-border" id="venueVideoLi" style="display: none;padding:0px;">
						<div class="venue_vivid">
							<div class="related_video venue_audio">
								<div class="related_video">
									<h1 class="border-bottom" style="padding: 20px;">相关视频</h1>
									<div class="video_cont">
										<h2 id="videoTitle"></h2>
										<video id="btn-play" src="" width="100%" height="500" poster="" controls></video>
									</div>
									<div class="M_anthology" id="moreVideo" style="display: none;">
										<h4>选集</h4>
										<div class="vplay_list clearfix" id="videoList">
											<div class="swiper-wrapper"></div>
										</div>
									</div>
								</div>

							</div>
						</div>
					</li>
					<li id="venueAntique" style="display: none;">
						<div class="active-border">
							<div class="active-detail-p3">
								<h1 class="border-bottom active-p4-arrowr" onclick="showAntique();">藏品</h1>
								<p class="p3-right" style="margin-right: 30px;line-height: 30px;">
									共<span style="color: #fcaf5b;" id="antiqueTotal"></span>个藏品
								</p>
								<div class="p3-video">
									<ul id="venueAntiqueList"></ul>
								</div>
							</div>
						</div>
					</li>
					<li id="aboutRoom" style="display: none;">
						<div class="active-border">
							<div class="active-detail-p5">
								<h1 class="border-bottom active-p4-arrowr" onclick="refRommList()">活动室</h1>
								<p class="p3-right" style="margin-right: 30px;line-height: 30px;">
									共<span style="color: #fcaf5b;" id="activityRoomTotal"></span>个活动室
								</p>
								<div class="live">
									<ul id="venueRoom"></ul>
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
								<ul id="venueComment"></ul>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="footer">
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
							<div class="footmenu-button3" onclick="venueCollect();"></div>
						</li>
						<li style="padding-right: 13px;">
							<div class="footmenu-button4" onclick="venueShare();"></div>
						</li>
						<div style="clear: both;"></div>
					</ul>
					<div class="footmenu-button5">
						<button type="button" onclick="callTel();">咨询</button>
					</div>
					<div style="clear: both;"></div>
				</div>

			</div>
			<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none" onclick="$(this).css('display', 'none');$('html,body').removeClass('bg-notouch');">
				<img src="${path}/STATIC/wxStatic/image/fx-bg2.png" style="width: 100%;height: 100%;" />
			</div>
		</div>
	</div>
</body>
</html>