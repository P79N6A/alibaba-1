<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>活动室详情</title> -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
<script type="text/javascript">
			var phoneWidth = parseInt(window.screen.width);
			var phoneScale = phoneWidth / 750;
			var ua = navigator.userAgent; //浏览器类型
			if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
				var version = parseFloat(RegExp.$1); //安卓系统的版本号
				if (version > 2.3) {
					document.write('<meta name="viewport" content="width=750, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
				} else {
					document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
				}
			} else {
				document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
			}
		</script>
		
<script>
	
	$(function(){
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
	        }
			
			var userId=$("#userId").val();
			var roomOrderId=$("#roomOrderId").val();
			var userType;
			
			$.post("${path}/wechatUser/userRoomOrderDetail.do",{roomOrderId:roomOrderId,userId:userId}, function(data) {
				if(data.status==200){
					var dom = data.data;
					
					var bookStatus=dom.bookStatus;
					var checkStatus=dom.checkStatus;
					var tuserId=dom.tuserId;
					var tuserIsDisplay=dom.tuserIsDisplay;
					userType=dom.userType;
					
					$("#roomName").html(dom.roomName);
					var roomPicUrl = getIndexImgUrl(dom.roomPicUrl,"_300_300");
					$("#roomUrl").attr("src", roomPicUrl);
					$("#venueName").html(dom.cmsVenueName);
					
					lat=dom.venueLat;
					lon=dom.venueLon;
					$("#date").html(dom.date);
					$("#openPeriod").html(dom.openPeriod);
					$("#price").html(dom.price);
					$("#tuserName").html(dom.tuserName)
					$("#orderName").html(dom.orderName)
					$("#orderTel").html(dom.orderTel)
					
					if(bookStatus>0&&bookStatus==1)
					{
						$("#orderValidateCode").html(dom.orderValidateCode);
						$("#roomQrcodeUrl").attr("src",dom.roomQrcodeUrl);
						
						$("#ticket").show();
					}
					
					if(bookStatus==0&&userType==2&&tuserIsDisplay=="1")
					{
						$(".showBtn").html("待审核");
					}
					else if(bookStatus==1)
					{
						$(".showBtn").html("待使用");
					}
					else if(bookStatus==2)
					{
						$(".showBtn").html("已取消");
					}
					else if(bookStatus==4)
					{
						$(".showBtn").html("已删除");
					}
					else if(bookStatus==5||bookStatus==3)
					{
						$(".showBtn").html("已使用");
					}
					else if(bookStatus==6)
						$(".showBtn").html("已失效");
					else
						$(".showBtn").hide();
					
					if(bookStatus==0||bookStatus==1)
					{
						var can="<button onclick='cancelVenueOrder();' class='f-left w50-pc height100 fs30 c6771a7 bgf4f4f4 cancelBtn'>取消订单</button>"
						
						var text="前往认证";
						
						if((tuserIsDisplay&&tuserIsDisplay==0)||userType==3)
						{
							text="认证中"
						}
						
						if(!tuserId||tuserIsDisplay==0||tuserIsDisplay==3||userType==1||userType==4||userType==3)
						{
							can+=("<button class='f-left bg7279a0 w50-pc height100 fs30 cfff authBtn'>"+text+"</button>")
							$(".showBtn").hide();
						}
						else
							can="<button onclick='cancelVenueOrder();' class='f-left w50-pc height100 fs30 c6771a7 bgf4f4f4 cancelBtn'>取消订单</button>"
							
						$(".order-button").prepend(can)
					}
					else
						$(".showBtn").attr("class","bgccc w100-pc height100 fs30 cfff")
					
					
					$(".venueName").html(dom.venueName);
					$("#venueAddress").html(dom.venueAddress);
					$("#orderNumber").html(dom.orderNumber);
					
					
					var orderDate = getLocalTime(dom.orderTime);
                    var orderTime = orderDate.getFullYear() + "." + (orderDate.getMonth() + 1) + "." + orderDate.getDate() + " " + orderDate.getHours() + ":" + orderDate.getMinutes() + "";
                    
                    $("#orderTime").html(orderTime)
				}
			},"json");
			
			$(".order-button").on("click", ".authBtn", function(){
				
				var roomOrderId=$("#roomOrderId").val();
				
				if(userType==1||userType==4||userType==3)
					window.location.href="${path}/wechatUser/auth.do?roomOrderId="+roomOrderId;
				else
					window.location.href = '${path}/wechatRoom/authTeamUser.do?roomOrderId='+roomOrderId;
				
			});
	});
	
	function getLocalTime(nS) {
        return new Date(parseInt(nS) * 1000);
    }

	 //地址地图
    function preAddressMap() {
        window.location.href = "${path}/wechat/preAddressMap.do?lat=" + lat + "&lon=" + lon;
    }
	
	 function cancelVenueOrder() {
		 
			var userId=$("#userId").val();
			var roomOrderId=$("#roomOrderId").val();
			
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
                 location.href = "${path}/wechatActivity/wcOrderList.do";
                 
             } else if (result.status == 10115) {
                 dialogAlert("提示", "该用户不存在");
             } else if (result.status == 1) {
                 dialogAlert("提示", "取消活动室失败");
             } else if (result.status == 10114) {
                 dialogAlert("提示", "用户或活动室id缺失");
             } else if (result.status == 2) {
                 dialogAlert("提示", "该活动室已取消");
             }
             
         }, "json");
                     }
                 },{
                     value: '取消'
                 }]
             });
             d.showModal();
     }
</script>
</head>
<body>
		<div class="main">
			<input type="hidden" id="roomOrderId" value="${roomOrderId }"/>
			<input type="hidden" id="userId" value="${userId }"/>
			<div class="header">
				<div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
					</span>
					<span class="index-top-2">订单详情</span>
				</div>
			</div>
			<div class="content margin-top100 padding-bottom110">
				<div class="my-order">
					<ul>
						<li>
							<div class="activity-title bgfff list-div-arrow-right ">
								<img src="" id="roomUrl" />
								<div class="activity-p">
									<p class="fs30 c26262 w300" id="roomName"></p>
									<p class="fs26 c808080 activity-p-place venueName w300" onclick="preAddressMap();" ></p>
								</div>
								<div style="clear: both;"></div>
							</div>
						</li>
						<li>
							<div class="list-div fs30 c26262">
								<ul>
									<li class="border-bottom">
										<label>日期：</label>
										<span id="date"></span>
									</li>
									<li class="border-bottom">
										<label>场次：</label>
										<span id="openPeriod"></span>
									</li>
									<li class="border-bottom">
										<label>价格：</label>
										<span id="price"></span>
									</li>
									<li class="border-bottom">
										<label>使用者：</label>
										<span id="tuserName"></span>
									</li>
									<li class="border-bottom">
										<label>预定联系人：</label>
										<span id="orderName"></span>
									</li>
									<li>
										<label>联系人手机号：</label>
										<span id="orderTel"></span>
									</li>
								</ul>
							</div>
						</li>
						<li>
							<div class="list-div fs30" id="ticket" style="display: none;">
								<p class="padding-top20 padding-bottom20">取票码：<span id="orderValidateCode" class="cd58185"></span></p>
								<img style="margin-left: 120px;height: 288px;width: 288px;" src="" id="roomQrcodeUrl"/>
								<p class="fs24 c26262" style="margin-left: 120px;">出示二维码获取票验证使用</p>
							</div>
						</li>
						<li>
							<div class="list-div padding-bottom20 padding-top20 ">
								<p class="fs30 c262626 venueName" ></p>
								<p class="fs26 c808080" id="venueAddress"></p>
							</div>
						</li>
						<li>
							<div class="list-div padding-bottom20 padding-top20 ">
								<ul class="border-bottom padding-bottom20">
									<li class="f-left p2-font">
										<div>
											<p class="w3">订单号</p>
											<p>下单时间</p>
										</div>
									</li>
									<li class="f-left">
										<div>
											<p>&nbsp;:&nbsp;&nbsp;<span id="orderNumber"></span></p>
											<p>&nbsp;:&nbsp;&nbsp;<span id="orderTime"></span></p>
										</div> 
									</li>
									<div style="clear: both;"></div>
								</ul>
								<div class="help-center fs30 padding-bottom20 padding-top20">
									<p>帮助中心</p>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="footer">
				<div class="order-button">
					
					<!--已使用后删除bg7279a0类，添加bgccc类-->
					
					<button class="f-left bgccc w50-pc height100 fs30 cfff showBtn" ></button>
					<div style="clear: both;"></div>
				</div>
			</div>
		</div>
</body>

	
</html>