<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>我的订单</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>

    <script type="text/javascript">
        var userId = '${sessionScope.terminalUser.userId}';
        var userType='${requestScope.userType}';
        function getLocalTime(nS) {
            return new Date(parseInt(nS) * 1000);
        }
        $(function () {
            //判断是否是微信浏览器打开
            if (is_weixin()) {
                //通过config接口注入权限验证配置
                wx.config({
                    debug: false,
                    appId: '${sign.appId}',
                    timestamp: '${sign.timestamp}',
                    nonceStr: '${sign.nonceStr}',
                    signature: '${sign.signature}',
                    jsApiList: ['previewImage']
                });
            }
            hd.pick("check");
            
            $(".content").show();
        });
        //滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 100)) {
                setTimeout(function () {
                    hd.page();
                }, 1000);
            }
        });
        function cancelActivityOrder(userId, activityOrderId, orderSeat) {
        	
        	 var winW = Math.min(parseInt($(window).width() * 0.82), 670);
             var d = dialog({
                 width: winW,
                 title: '取消提示',
                 content: '确定取消该订单？',
                 fixed: true,
                 button: [{
                     value: '确定',
                     callback: function () {
                    	  $.post("${path}/wechatActivity/removeAppActivity.do", {
                              userId: userId,
                              activityOrderId: activityOrderId,
                              orderSeat: orderSeat
                          }, function (result) {
                              if (result.status == 0) {
                                  dialogAlert("提示", "退订成功！");
                              } else if (result.status == 10111) {
                                  dialogAlert("提示", "用户不存在");
                              } else if (result.status == 1) {
                                  dialogAlert("提示", "退票失败");
                              } else if (result.status == 10112) {
                                  dialogAlert("提示", "用户与活动订单id缺失");
                              }
                              hd.pick("now");
                          }, "json");
                     }
                 },{
                     value: '取消'
                 }]
             });
             d.showModal();
        }

      
        
        function cancelVenueOrder(userId, roomOrderId) {
        	
        	 var winW = Math.min(parseInt($(window).width() * 0.82), 670);
             var d = dialog({
                 width: winW,
                 title: '取消提示',
                 content: '确定取消该订单？',
                 fixed: true,
                 button: [{
                     value: '确定',
                     callback: function () {
            $.post("${path}/wechatActivity/removeAppRoomOrder.do", {
                userId: userId,
                roomOrderId: roomOrderId
            }, function (result) {
                if (result.status == 0) {
                    dialogAlert("提示", "退订成功！");
                } else if (result.status == 10115) {
                    dialogAlert("提示", "该用户不存在");
                } else if (result.status == 1) {
                    dialogAlert("提示", "取消活动室失败");
                } else if (result.status == 10114) {
                    dialogAlert("提示", "用户或活动室id缺失");
                } else if (result.status == 2) {
                    dialogAlert("提示", "该活动室已取消");
                }
                hd.pick("now");
            }, "json");
                     }
                 },{
                     value: '取消'
                 }]
             });
             d.showModal();     
        }

    </script>
    <script>
        var hd = avalon.define({
            $id: "header",
            toggle: 1,
            pageEnd: true,
            type: "",
            pageNum: 20,
            pageIndex: 0,
            page: function () {
                hd.pageIndex += 20;
                if (hd.toggle==1) {
                	hd.type = "userCheckOrder"
                }
                else if (hd.toggle==2){
                    hd.type = "userOrder"
                } else {
                    hd.type = "userHistoryOrder"
                }
                hd.loadOrder(hd.pageNum, hd.pageIndex, hd.type);
            },
            check:function (){
            	 hd.toggle = 1;
                 hd.type = "userCheckOrder";
                 hd.loadOrder(hd.pageNum, hd.pageIndex, hd.type);
            },
            now: function () {
                hd.toggle = 2;
                hd.type = "userOrder";
                hd.loadOrder(hd.pageNum, hd.pageIndex, hd.type);
            },
            history: function () {
                hd.toggle = 3;
                hd.type = "userHistoryOrder"
                hd.loadOrder(hd.pageNum, hd.pageIndex, hd.type);
            },
            pick: function (choose) {
                co.order = "";
                hd.pageEnd = true;
                hd.pageIndex = 0;
                co.page=co.pageLoad;
                if (choose == 'now') {
                    hd.now();
                } else if(choose == 'history') {
                    hd.history();
                }
                else {
                	hd.check();
                }
            },
            loadOrder: function (pageNum, pageIndex, type) {
                if (userId == null || userId == '') {
                    window.location.href = "${path}/muser/login.do";
                    return;
                }
                var param = {
                    userId: '${sessionScope.terminalUser.userId}',
                    pageIndex: pageIndex,
                    pageNum: pageNum
                };
                $.post("${path}/wechatUser/" + type + ".do", param, function (result) {
                    var orderListHtml = "";
                    var userId = '${sessionScope.terminalUser.userId}';
                    if (result.status == 1) {
                    	if(result.data1==undefined){
                    		result.data1=[];
                    	}
                        if((result.data.length+result.data1.length)<20){
                			if((result.data.length+result.data1.length)==0&&pageIndex==0){
                				co.page="<div id='loadingDiv' class='loadingDiv'><span class='noLoadingSpan' style='padding-left:196px;'>您还没参加过任何活动~</span></div>";
                			}else{
                				co.page="";
                			}
    	        		}
                        var activityOrderAry = result.data;
                        var venueOrderAry = result.data1;
                        Array.prototype.push.apply(activityOrderAry, venueOrderAry);
                        var orderSortAry = activityOrderAry.sort(function (a, b) {
                            a = a.orderTime;
                            b = b.orderTime;
                            return b - a;
                        })
                        
                        var userType=$("#userType").val();
                        
                        for (var i = 0; i < orderSortAry.length; i++) {
                            if (orderSortAry[i].activityName != '' && orderSortAry[i].activityName != undefined) {
                                var activityName = orderSortAry[i].activityName;
                                var activityAddress = orderSortAry[i].activityAddress;
                                var activityEventDateTime = orderSortAry[i].activityEventDateTime;
                                var orderVotes = orderSortAry[i].orderVotes;
                                var orderValidateCode = orderSortAry[i].orderValidateCode;
                                
                                var activityIconUrl = orderSortAry[i].activityIconUrl;
                                if(activityIconUrl)
                                {
                                 	activityIconUrl = getIndexImgUrl(orderSortAry[i].activityIconUrl, "_300_300");
                                }
                                var orderNumber = orderSortAry[i].orderNumber;
                                var orderPrice=orderSortAry[i].orderPrice;
                                var orderTime = getLocalTime(orderSortAry[i].orderTime).format("yyyy.MM.dd hh:mm");
                                var activitySalesOnline = orderSortAry[i].activitySalesOnline;
                                var activityOrderId = orderSortAry[i].activityOrderId;
                                var orderLine = orderSortAry[i].orderLine;
                                var onlineOrderVotes = 0;
                                var setSeatHtml = "";
                                if (activitySalesOnline == "Y") {
                                    var activitySeats = new Array();
                                    activitySeats = result.data[i].activitySeats.split(",");
                                    var orderLineArr = result.data[i].orderLine.split(",");
                                    if (activitySeats != undefined && activitySeats != '' && activitySeats.length > 0) {
                                        var seat = "";
                                        for (var j = 0; j < activitySeats.length; j++) {
                                            if (activitySeats[j] == null || activitySeats[j] == "") {
                                                continue;
                                            }
                                            onlineOrderVotes++;
                                            var activityTimeStr = activityEventDateTime.split(' ')[0] + " " + (activityEventDateTime.split(' ')[1]).split("-")[0];
                                            var activityDate = new Date(activityTimeStr);
                                            var activitySeat = activitySeats[j].split("_");
                                            if (activityDate < new Date(orderSortAry[i].currentServiceTime)) {
                                                seat +=  activitySeat[0] + "排" + activitySeat[1] + "座 ";
                                            } else {
                                                seat += activitySeat[0] + "排" + activitySeat[1] + "座";
                                            }
                                        }
                                        setSeatHtml+=seat;
                                    } 
                                } 
                                var orderPayStatus = orderSortAry[i].orderPayStatus;
                                var payHtml = "";
                                var canselHtml = "";
                                var clickHtml = "";
                                var colorHtml = "class='order-down-b1'";
                                if (orderPayStatus == 1) {
                                    payHtml = "未出票";
                                    canselHtml = "取消订单";
                                    colorHtml = "class='order-down-b1'";
                                    if (activitySalesOnline == "Y") {
                                        clickHtml = " onclick='cancelActivityOrder(\"" + userId + "\",\"" + activityOrderId + "\",\"" + orderLine + "\")'";
                                    } else if (activitySalesOnline == "N") {
                                        clickHtml = " onclick='cancelActivityOrder(\"" + userId + "\",\"" + activityOrderId + "\")'";
                                    }
                                } else if (orderPayStatus == 2) {
                                    payHtml = "";
                                    canselHtml = "已取消";
                                    colorHtml = "class='order-down-b2'";
                                    clickHtml = "";
                                } else if (orderPayStatus == 3) {
                                    payHtml = "";
                                    canselHtml = "已出票";
                                    colorHtml = "class='order-down-b2'";
                                    clickHtml = "";
                                } else if (orderPayStatus == 4) {
                                    payHtml = "";
                                    canselHtml = "已验票";
                                    colorHtml = "class='order-down-b2'";
                                    clickHtml = "";
                                } else if (orderPayStatus == 5) {
                                    payHtml = "";
                                    canselHtml = "已失效";
                                    colorHtml = "class='order-down-b2'";
                                    clickHtml = "";
                                }

                                orderListHtml += "<li><div class='my-order-list'><div class='my-order-list-title'>" +
                                "<div class='m-o-l-1'><p>活动</p></div>" +
                                "<div class='m-o-l-2'><p>订单号："+orderNumber+"</p></div>"+
                            	"<div class='m-o-l-3'><p>"+orderTime+"</p></div>"+
                                "<div style='clear: both;'></div></div>" +
                                
                                "<div class='my-order-list-detail' activityOrderId='"+activityOrderId+"'>"+
								"<img width='270' height='170' src='" + activityIconUrl + "' />"+
								"<div class='my-order-list-p'>"+
								"<p class='fs30 c26262'>"+activityName+"</p>"+
								"<p class='fs26 c808080'>"+activityAddress+"</p>"+
								"<p class='fs26 c808080'>"+activityEventDateTime+"</p>"+
								"<p class='fs26 c808080'>"+setSeatHtml+"</p>"+
								"</div>"+
								"<div style='clear: both;'></div>"+
								"</div>"+
								"<div class='my-order-list-bottom'>"+
									"<div class='order-pay fs30'>";
									
									if(orderPrice=="免费")
									{
										orderListHtml +="<p>总金额："+orderPrice+"</p>"+
										"</div>";
									}
									else
									{
										orderListHtml +="<p>总金额：<span class='cd58185'>￥"+orderPrice+"</span></p>"+
										"</div>";
									}
									
									
								if(type=="userHistoryOrder")
								{
									 orderListHtml += "<div class='order-check fs24 c808080'>"+
									"<p>"+canselHtml+"</p>";
									"</div>";
								}
									
								orderListHtml +="<div style='clear: both;'></div>"+
								"</div>";
								
                            } else {
                                var venueName = orderSortAry[i].venueName;
                                var roomName = orderSortAry[i].roomName;
                                var venueAddress = orderSortAry[i].venueAddress;
                                var roomTime = orderSortAry[i].roomTime;
                                var tuserTeamName = orderSortAry[i].tuserTeamName;
                                var validCode = orderSortAry[i].validCode;
                                
                                var roomPicUrl = orderSortAry[i].roomPicUrl;
                                if(roomPicUrl)
                                {
                                	roomPicUrl = getIndexImgUrl(orderSortAry[i].roomPicUrl, "_300_300");
                                }
                                
                                var roomOrderNo = orderSortAry[i].roomOrderNo;
                                var orderTime = getLocalTime(orderSortAry[i].orderTime).format("yyyy.MM.dd hh:mm");
                                var roomOrderId = orderSortAry[i].roomOrderId;
                                var price = orderSortAry[i].price;
                                var tuserId= orderSortAry[i].tuserId;
								var tuserIsDisplay=orderSortAry[i].tuserIsDisplay;
                                var orderStatus = orderSortAry[i].orderStatus;
                                var checkStatus = orderSortAry[i].checkStatus;
                                var payHtml = "";
                                var canselHtml = "";
                                var clickHtml = "";
                                var colorHtml = "class='order-down-b1'";
                                var roomTimeAry = roomTime.split(" ");
                                var timeStr = roomTimeAry[0]  +" "+" " + roomTimeAry[1];
                                var dataTime = new Date(timeStr)
                                var flag = dataTime < (new Date(orderSortAry[i].currentServiceTime));
                                if (orderStatus == 1) {
                                    payHtml = "未出票";
                                    canselHtml = "取消订单";
                                    clickHtml = " onclick='cancelVenueOrder(\"" + userId + "\",\"" + roomOrderId + "\")'";
                                    colorHtml = "class='order-down-b1'";
                                } else if (orderStatus == 2) {
                                    colorHtml = "class='order-down-b2'";
                                    payHtml = "";
                                    canselHtml = "已取消";
                                    if(checkStatus==2)
                                    	canselHtml = "审核未通过";
                                    clickHtml = "";
                                } else if (orderStatus == 3) {
                                    colorHtml = "class='order-down-b2'";
                                    payHtml = "";
                                    canselHtml = "已验票";
                                    clickHtml = "";
                                } else if (orderStatus == 4) {
                                    colorHtml = "class='order-down-b2'";
                                    payHtml = "";
                                    canselHtml = "已删除";
                                    clickHtml = "";
                                } else if (orderStatus == 5) {
                                    colorHtml = "class='order-down-b2'";
                                    payHtml = "";
                                    canselHtml = "已出票";
                                    clickHtml = "";
                                }else if (orderStatus == 6) {
                                    colorHtml = "class='order-down-b2'";
                                    payHtml = "";
                                    canselHtml = "已失效";
                                    clickHtml = "";
                                }
                                if (flag) {
                                    colorHtml = "class='order-down-b2'";
                                    payHtml = "已失效";
                                    clickHtml = "";
                                }
                                
                                

                                orderListHtml += "<li><div class='my-order-list'><div class='my-order-list-title'>" +
                                        "<div class='m-o-l-1'><p>场馆</p></div>" +
                                        "<div class='m-o-l-2'><p>订单号："+roomOrderNo+"</p></div>"+
                                    	"<div class='m-o-l-3'><p>"+orderTime+"</p></div>"+
                                        "<div style='clear: both;'></div></div>" +
                                        
                                        "<div class='my-order-list-detail' roomOrderId='"+roomOrderId+"'>"+
    									"<img width='270' height='170' src='" + roomPicUrl + "' />"+
    									"<div class='my-order-list-p'>"+
    									"<p class='fs30 c26262'>"+roomName+"</p>"+
    									"<p class='fs26 c808080'>"+venueName+"</p>"+
    									"<p class='fs26 c808080'>"+timeStr+"</p>"+
    									"<p class='fs26 c808080'>"+roomTimeAry[2]+" "+" "+roomTimeAry[3]+"</p>"+
    									"</div>"+
    									"<div style='clear: both;'></div>"+
    									"</div>"+
    									"<div class='my-order-list-bottom'>"+
											"<div class='order-pay fs30'>";
										
										if(price=="免费")
										{
											orderListHtml +="<p>总金额："+price+"</p>"+
											"</div>";
										}
										else
										{
											orderListHtml +="<p>总金额：<span class='cd58185'>￥"+price+"</span></p>"+
											"</div>";
										}
											
										if(type=="userHistoryOrder")
										{
											 orderListHtml += "<div class='order-check fs24 c808080'>"+
											"<p>"+canselHtml+"</p>";
											"</div>";
										}	
											
										if(orderStatus==0)
										{
											var text="前往认证";
											
											if((tuserIsDisplay&&tuserIsDisplay==0)||userType==3)
											{
												text="认证中"
											}
											
											if(!tuserId||tuserIsDisplay==0||tuserIsDisplay==3||userType==1||userType==4||userType==3)
											{
												orderListHtml +=
												"<div class='order-check bg7279a0 fs30 cfff authBtn'>"+
												"<p roomOrderId='"+roomOrderId+"'>"+text+"</p>"+
													"</div>";
											}
										}
											
										orderListHtml +="<div style='clear: both;'></div>"+
										"</div>";
                            }
                        }
                        if (orderListHtml == "") {
                            if (hd.pageEnd) {
                            }
                            hd.pageEnd = false;
                        } else {
                            co.order += orderListHtml;
                        }
                    } else {

                    }
                }, "json");
            }
        });
        var co = avalon.define({
            $id: "content",
            order: "",
            page: "",
            pageLoad: "<div id='loadingDiv' class='loadingDiv'><img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif' /><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div></div>",

        });
    </script>
	<script>
			$(document).ready(function() {
				$('.my-keep-place>ul>li>div').click(function() {
					$('.my-keep-place>ul>li>div').removeClass("keep-bottom-br")
					$(this).addClass("keep-bottom-br")
				
				})
				
				$(".content").on("click", ".my-order-list-detail", function(){
					var roomOrderId=$(this).attr("roomOrderId");
					if(roomOrderId){
						window.location.href="${path}/wechatRoom/roomOrderDetail.do?roomOrderId="+roomOrderId;
					}
					
					var activityOrderId=$(this).attr("activityOrderId");
					if(activityOrderId){
						window.location.href="${path}/wechatActivity/preActivityOrderDetail.do?activityOrderId="+activityOrderId;
					}
				});
				
				$(".content").on("click", ".authBtn", function(){
					
					var roomOrderId=$(this).find("p").attr("roomOrderId");
					
					var userType=$("#userType").val();
					
					if(userType==1||userType==4||userType==3)
						window.location.href='${path}/wechatUser/auth.do?roomOrderId='+roomOrderId;
					else
						window.location.href = '${path}/wechatRoom/authTeamUser.do?roomOrderId='+roomOrderId;
					
				});
			})
		</script>	
    <style>
    	html,body{
    		background-color: #f3f3f3;
    	}
    </style>
</head>
<body>
<div class="main">
	<input type="hidden" id="userType" value="${userType }"/>
    <div class="header" ms-controller="header">
        <div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
					</span>
            <span class="index-top-2">我的订单</span>
        </div>
      <!--  <div class="my-keep-place">
            <ul>
                <li>
                    <a>
                        <div 
                             ms-class="keep-bottom-br:toggle">
                            <p>进行中</p>
                        </div>
                    </a>
                </li>
                <li>
                    <a>
                        <div 
                             ms-class="keep-bottom-br:!toggle">
                            <p>历史</p>
                        </div>
                    </a>
                </li>
                <div style="clear: both;"></div>
            </ul>
        </div>-->  
        
        <div class="my-keep-place" style="border-bottom: 5px solid #f0f0f0;">
					<ul>
						<li ms-click="pick('check')" class="border-right w248">
							<div class="keep-bottom-br">
								<img src="${path}/STATIC/wechat/image/icon-review.png" />
								<p style="margin-top:5px;">待审核</p>
							</div>
						</li>
						<li ms-click="pick('now')" id="activityTag" class="border-bottom border-right w248">
							<div>
								<img src="${path}/STATIC/wechat/image/icon-join.png" />
								<p>待参加</p>
								
								<!--<c:choose>
									<c:when test="${orderCount>0 }">
										<span class="order-num fs24">${orderCount}</span>
									</c:when>
								</c:choose>-->
							</div>
						</li>
						<li ms-click="pick('history')" id="venueTag" class="w248">
							<div>
								<img src="${path}/STATIC/wechat/image/icon-history.png" />
								<p>历史</p>
							</div>
						</li>
						<div style="clear: both;"></div>
					</ul>
				</div>
    </div>
    <div class="content margin-top230 padding-bottom0" ms-controller="content" style="display: none;">
        <div class="my-order my-order-list1">
            <ul> {{order|html}}</ul>
        </div>
        {{page|html}}
    </div>
</div>
</body>
</html>