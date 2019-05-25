<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>活动详情</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

    <script>
        var activityId = '${activityId}';
        var userId = '${sessionScope.terminalUser.userId}';
        var lat = '';
        var lon = '';
        var activityTel = '';
        var integralStatus = '';	//0：可以预定；1：未达最低积分；2：未达抵扣积分
        
        $(function () {
			var list= window.localStorage.getItem("activity");
			var activity=JSON.parse(list);
                    lat = activity.activityLat;
                    lon = activity.activityLon;
                    activityTel = activity.activityTel;
                    integralStatus = activity.integralStatus;
                    $("#activityUrl").attr("src", getImgUrl(getIndexImgUrl(activity.activityIconUrl, "_750_500")));
                    if (activity.activityIsCollect == 1) {	//收藏
                        $(".footmenu-button3").addClass("footmenu-button3-ck");
                    }
                    $("#activityName").text(activity.activityName);
                    if (activity.activityTagName!=null) {
                        $("#tagNames").append("<li>" + activity.activityTagName + "</li>");
						var len =activity.activityLabName.length;
						if(len>2){
							len=2
						}
						for (var i = 0; i < len; i++) {
							$("#tagNames").append("<li>" + activity.activityLabName[i] + "</li>");

						}
                    }

                    $("#activityAddress").text(activity.activityAddress);

                    $("#activityTel").text(activity.activityTel);
                    $("#activityStartTime").html(activity.activityStartTime.replace("-",".").replace("-","."));
                    if (activity.activityEndTime.length != 0&&activity.activityStartTime!=activity.activityEndTime) {
                        $("#activityStartTime").append("&nbsp;-&nbsp;"+activity.activityEndTime.replace("-",".").replace("-","."));
                    }

                    if(activity.activityIsFree==2){
    					if (activity.activityPrice.length != 0 && activity.activityPrice > 0) {
    						if(activity.priceType==0){
    							$("#activityPrice").html("<span style='font-size: 57px;'>"+activity.activityPrice+"</span>元起");
    						}else{
    							$("#activityPrice").html("<span style='font-size: 57px;'>"+activity.activityPrice+"</span>元/人");
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
                    	}else if(activity.activityAbleCount!=null){
                    		$("#activityAbleCount").append("余票<span style='color: #FA880B;'>"+activity.activityAbleCount+"</span>张");
                    	}
                    }else{
                    	$("#activityAbleCount").append("无需预约");
                    }
                    if (activity.spikeType==0){		//非秒杀
                    	if (activity.activityIsPast==1) {
                        	$("#orderButton").append("<button type='button' class='button-dis'>已结束</button>");
                        }else{
                        	if(activity.activityIsReservation == 2){
                        		if(activity.activityAbleCount > 0){
                        			if(activity.status.indexOf(1)>=0){
                        				$("#orderButton").append("<button type='button' onclick='preOrder();'>立即预约</button>");
                        			}else{
                        				$("#orderButton").append("<button type='button' class='button-dis'>无法预订</button>");
                        			}
                        		}else{
                        			$("#orderButton").append("<button type='button' class='button-dis'>已订完</button>");
                        		}
                        	}else{
                        		$("#orderButton").append("<button type='button' class='button-dis'>直接前往</button>");
                        	}
                        }
                    }
                    if (activity.activityTimeDes.length > 0) {
                    	$("#activityTimeDes").text(activity.activityTimeDes);
                        $("#activityTimeDes").show();
                    }
//                    $("#activityTips").html(activity.activityTips.replace("温馨提示：",""));
                    if(activity.lowestCredit!=null&&activity.costCredit!=null){
                		$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>预订需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分，且每张需抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分</p></div>");
                	}else if(activity.lowestCredit!=null&&activity.costCredit==null){
                		$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分才可预订</p></div>");
                	}else if(activity.lowestCredit==null&&activity.costCredit!=null){
                		$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>每张票务需要抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分</p></div>");
                	}
                    if(activity.deductionCredit!=null){
                    	$(".footer").prepend("<div class='tips fs26 bgfff8df'><p>此活动热门，预订后未到场将会被扣除<span class='cd58185'>"+activity.deductionCredit+"</span>分</p></div>");
                    	if($(".footer>.tips").length==2){
                    		$(".content").removeClass("padding-bottom170").addClass("padding-bottom220");
                    	}else if($(".footer>.tips").length==1){
                    		$(".content").addClass("padding-bottom170");
                    	}
                    }
                    if (activity.spikeType==1){		//秒杀
                    	activitySpike(activity.activityIsPast);
                    	if(activity.lowestCredit!=null&&activity.costCredit!=null){
                    		$("#spikeCredit").html("预订需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分，且每张需抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分");
                    	}else if(activity.lowestCredit!=null&&activity.costCredit==null){
                    		$("#spikeCredit").html("需要达到<span class='cd58185'>"+activity.lowestCredit+"</span>积分才可预订");
                    	}else if(activity.lowestCredit==null&&activity.costCredit!=null){
                    		$("#spikeCredit").html("每张票务需要抵扣<span class='cd58185'>"+activity.costCredit+"</span>积分");
                    	}
                    }
                    if (activity.activityMemo.length > 0) {
                        $("#activityMemoLi").show();
                        $("#activityMemo").html(activity.activityMemo);
                        formatStyle("activityMemo");
                    }
					if(activity.activityHost.length>0||activity.activityOrganizer.length>0||activity.activityCoorganizer.length>0
							||activity.activityPerformed.length>0||activity.activitySpeaker.length>0){
						$("#activityCompanyLi").show();
					}
					if(activity.activityHost.length>0){
						$("#activityCompanyDiv").append("<tr><td style='width:135px;' class='w3'>主办方</td><td>：</td><td>"+activity.activityHost+"</td></tr>")
					}
					if(activity.activityOrganizer.length>0){
						$("#activityCompanyDiv").append("<tr><td style='width:135px;' class='w4'>承办单位</td><td>：</td><td>"+activity.activityOrganizer+"</td></tr>")
					}
					if(activity.activityCoorganizer.length>0){
						$("#activityCompanyDiv").append("<tr><td style='width:135px;' class='w4'>协办单位</td><td>：</td><td>"+activity.activityCoorganizer+"</td></tr>")
					}
					if(activity.activityPerformed.length>0){
						$("#activityCompanyDiv").append("<tr><td style='width:135px;' class='w4'>演出单位</td><td>：</td><td>"+activity.activityPerformed+"</td></tr>")
					}
					if(activity.activitySpeaker.length>0){
						$("#activityCompanyDiv").append("<tr><td style='width:135px;' class='w3'>主讲人</td><td>：</td><td>"+activity.activitySpeaker+"</td></tr>")
					}
					
                    if (activity.activityIsWant != 0) {		//点赞（我想去）
                    	$(".footmenu-button2").addClass("footmenu-button2-ck");
                    }





            
            //底部菜单隐藏
            $(document).on("touchmove",function(){
				$(".footer").hide()
			}).on("touchend",function(){
				$(".footer").show()
			})

        });
        



        //富文本格式修改
        function formatStyle(id) {
            var $cont = $("#" + id);
            $cont.find("img").each(function () {
                var $this = $(this);
                var oldHeight = $this.height();
                var oldWidth = $this.width();
                var newHeigth = 710*oldHeight/oldWidth;
                $this.removeAttr("style").attr({"width": "710px"});
                $this.removeAttr("style").attr({"height": newHeigth+"px"});
                $this.css("display", "block");
            });
            $cont.find("p,span,font").each(function () {
                var $this = $(this);
                $this.css({
                    "font-size": "24px",
                    "color": "#7C7C7C",
                    "line-height": "44px",
                    "font-family": "Microsoft YaHei"
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
                window.location.href = '${path}/muser/login.do?type=${path}/wechatActivity/preActivityDetail.do?activityId=' + activityId;
                return;
            }
            if(integralStatus==1){
            	dialogAlert("系统提示", "您的积分未达到该活动最低要求！");

            }else if(integralStatus==2){
            	dialogAlert("系统提示", "您的积分不够抵扣该活动！");

            }else if(integralStatus==0){
            	window.location.href = "${path}/wechatActivity/preActivityOrder.do?activityId=" + activityId;
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
				<span class="tab-p12">
					<a><img src="${path}/STATIC/wechat/image/arrow2.png" width="74px" height="74px" onclick="history.go(-1);"/></a>
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
					<%--<li class="border-bottom">--%>
						<%--<img src="${path}/STATIC/wechat/image/icon_时间.png" />--%>
						<%--<div class="active-top-time">--%>
							<%--<ul id="timeQuantums" style="margin: 20px 0;">--%>
								<%--<div style="clear: both;"></div>--%>
							<%--</ul>--%>
							<%--<p id="activityTimeDes" style="margin-top: 0;display: none;"></p>--%>
						<%--</div>--%>
					<%--</li>--%>
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
								<h1 class="border-bottom">活动单位</h1>
								<table style="font-size: 30px;margin-top:20px;line-height:50px;" id="activityCompanyDiv"></table>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<%--<li>--%>
						<%--<div class="active-border active-tab">--%>
							<%--<div class="active-detail-p3">--%>
								<%--<h1 class="border-bottom">温馨提示</h1>--%>
								<%--<p class="fs24 c808080 margin-top20" id="activityTips"></p>--%>
							<%--</div>--%>
						<%--</div>--%>
					<%--</li>--%>
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
		<%--<div class="footer">--%>
			<%--<div class="active-footmenu">--%>
				<%--<ul style="float: left;">--%>
					<%--<li class="active-footmenu-border">--%>
						<%--<div class="footmenu-button1" onclick="addComment();"><p>评论</p></div>--%>
					<%--</li>--%>
					<%--<li class="active-footmenu-border">--%>
						<%--<div class="footmenu-button2" onclick="addWantGo();"></div>--%>
					<%--</li>--%>
					<%--<li class="active-footmenu-border">--%>
						<%--<div class="footmenu-button3"></div>--%>
					<%--</li>--%>
					<%--<li style="padding-right: 13px;">--%>
						<%--<div class="footmenu-button4"></div>--%>
					<%--</li>--%>
					<%--<div style="clear: both;"></div>--%>
				<%--</ul>--%>
				<%--<div class="footmenu-button5" id="orderButton"></div>--%>
				<%--<div style="clear: both;"></div>--%>
			<%--</div>--%>
		<%--</div>--%>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
		<script>
			$(document).ready(function() {
				$(".footmenu-button4").click(function() {
					if (!is_weixin()) {
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