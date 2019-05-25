<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>活动室详情</title> -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
		<script>
			$(document).ready(function() {
				var height = $(".active-detail-p1-show").height();
				//				alert(hight)
				if (height > 1000) {
					$(".active-detail-p1-arrowdown").click(function() {
						$(".active-detail-p1-arrowdown").toggleClass("active-detail-p1-arrowdown-rol")
						$(".active-detail-p1").toggleClass("active-detail-p1-hide");
					})
				} else {
					$(".active-detail-p1").css("height", height)
					$(".active-detail-p1-arrowdown").css("display", "none")
				}
			})
		</script>

<script>
	var roomId = '${roomId}';
	
	$(document).attr("title","活动室预览");
	
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
			
		
	       
			$("#roomName").html('${activityRoom.roomName}');
			
			var roomPicUrl='${activityRoom.roomPicUrl}';
			
			if(roomPicUrl)
			{
				var roomPicUrl = getIndexImgUrl(roomPicUrl,"_750_500");
				$("#roomUrl").attr("src", roomPicUrl);
			}
			var roomTags = '${activityRoom.roomTagName}'.split(",");
			$.each(roomTags,function(i,roomTag){
				$("#roomTag").append("<li>"+roomTag+"</li>");
				
				if(i==2)
					return false;
			});
			$("#roomTel").html('${activityRoom.roomConsultTel}');
			$("#roomArea").html('${activityRoom.roomArea}'+"m²");
			$("#roomCapacity").html('${activityRoom.roomCapacity}'+"人");
			var price = ''; 
			if('${activityRoom.roomIsFree}'==2){
				if ('${activityRoom.roomFee}'.length != 0) {
					if('${activityRoom.roomFee}'>0){
						price = '${activityRoom.roomFee}' + "元/人";
					}else{
						price = '${activityRoom.roomFee}';
					}
                } else {
                	price = "收费";
                }
			}else{
				price = "免费";
			}
			$("#roomPrice").html(price);
		
			if('${activityRoom.roomRemark}'.length>0){
				$("#roomRemarkLi").show();
				$("#roomRemark").append('${activityRoom.roomRemark}');
			}
			
			var facility='${activityRoom.roomFacilityInfo}';
			
			if(facility){
				var roomFacilitys = facility.split(",");
				$.each(roomFacilitys,function(i,facility){
					//roomFacilityHtml += "<li><div>"+facility+"</div></li>";
					
					$("#roomFacility").append("<li>"+facility+"</li>");
				});
			}
				
	});

	var userId = '${sessionScope.terminalUser.userId}';
	
	//function callTel(roomTel){
	//	window.location = "tel:"+roomTel;
	//}

	//拨打电话
    function callTel() {
     //   window.location = "tel:" + venueTel;
        window.location = "tel:" + $("#roomTel").html();
    }
	
	
	//预订
	function roomBook(){
		
		 if (!userId) {
			 
             window.location.href = "${path}/muser/login.do";
         }
		 else
		{
			var bookId=$(".bg7279a0").attr("bookId");
			
			if(bookId)
			{
				window.location.href="${path}/wechatVenue/roomBookOrder.do?roomId="+roomId+"&bookId="+bookId;
			}
			else
			{
			    dialogAlert("提示", "请选择预订场次");
			}
			
		}
	}
	
	function TimeClick(num) {
		var list_num = num;
		var pre = 0;
		var next = 0;
		if (list_num <= 4) {
			$(".time-menu-tab2").hide()
		}
		
		$(".time-menu-tab2").click(function() {
			next = pre + 4;
			if (next >= list_num - 4) {
				$(".time-menu-tab1").show() //显示向后按钮
				$(".time-menu-tab2").hide() //当前预定日期为第一列时，隐藏向前按钮
			} else {
				$(".time-menu-tab1").show() //显示向后按钮
			}
			$(".time-menu>li:eq(" + pre + ")").hide() //隐藏第一列
			$(".time-menu>li:eq(" + next + ")").show() //显示后一列
			pre += 1;
		})
		$(".time-menu-tab1").click(function() {
			if (pre == 1) {
				$(".time-menu-tab2").show() //显示向前按钮
				$(".time-menu-tab1").hide() //当前预定日期为最后一列时，隐藏向后按钮
			} else {
				$(".time-menu-tab2").show() //显示向前按钮
			}
			pre = next - 4;
			$(".time-menu>li:eq(" + next + ")").hide()
			$(".time-menu>li:eq(" + pre + ")").show() //显示前一
		});
	}
</script>

</head>
<body>
	<input type="hidden" id="roomId"/>
	<div class="main venue-detail">
			<div class="header">
				<div class="index-top">
					<span class="index-top-5">
					
					</span>
					<span id="roomName" class="index-top-2"></span>
				</div>
			</div>
			<div class="content padding-bottom110 margin-top100">
				<img id="roomUrl" src=""  class="masking-down" />
				<img src="${path}/STATIC/wechat/image/蒙板.png" class="masking" />
				<span class="tab-p7"><ul id="roomTag"></ul></span>
				<div class="active-top">
					<ul>
						<li class="border-bottom">
							<p>电话：</p>
							<p id="roomTel" class="break2 w590" onclick='callTel();'>021-67394812</p>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p>面积：</p>
							<p id="roomArea" class="break2 w590">71m</p>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p>容纳：</p>
							<p id="roomCapacity" class="break2 w590">25人</p>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p>费用：</p>
							<p id="roomPrice" class="break2 w590"></p>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom" id="roomRemarkLi" style="display: none;">
							<p>备注：</p>
							<p id=roomRemark class="break2 w590"></p>
							<div style="clear: both;"></div>
						</li>
						<li> 
							<p>设备：</p>
							<ul id="roomFacility" class="active-top-tab w590 c7c7c7c">
								<div style="clear: both;"></div>
							</ul>
							<div style="clear: both;"></div>
						</li>
					</ul>
				</div>
			</div>
			
			<script>
				$(document).ready(function() {
					$(".footmenu-button4").click(function() {
						$(".background-fx").css("display", "block")
					})
					$(".background-fx").click(function() {
						$(".background-fx").css("display", "none")
					})
					$(".footmenu-button2").click(function() {
						$(this).toggleClass("footmenu-button2-ck")
					})
					$(".footmenu-button3").click(function() {
						$(this).toggleClass("footmenu-button3-ck")
					})
				})
			</script>
			</div>
			
				<script>
			$(document).ready(function() {
				var plist = $(".active-detail-p7>ul>li");
				//					alert(plist.length)
				for (var i = 0; i < plist.length; i++) {
					var num = plist.eq(i).find(".p7-user-list-img>ul>li")
						//						alert(num.length)
					if (num.length == 1) {
						num.css("width", "640px")
						num.css("height", "640px")
						num.find("img").css("width", "600px")
						num.find("img").css("margin", "20px")
					} else if (num.length > 1 && num.length < 5) {
						num.css("width", "320")
						num.css("height", "320")
						num.find("img").css("width", "280px")
						num.find("img").css("margin", "20px")
					} else {
						num.css("width", "210")
						num.css("height", "210")
						num.find("img").css("width", "170px")
						num.find("img").css("margin", "20px")
					}
				}
			})
		</script>
</body>

		<script>
			$(document).ready(function() {
			//	$(".bgdde0f2").click(function() {
					
				$(".time-menu").on("click", ".bgdde0f2", function(){
					
					$(".bgdde0f2").not(this).removeClass("bg7279a0").removeClass("cfff")
					$(this).toggleClass("bg7279a0").toggleClass("cfff")
					if ($(".bgdde0f2").hasClass("bg7279a0")) {
						$(".time-menu-button").removeAttr('disabled')
						$(".time-menu-button").addClass("bg7279a0").addClass("cfff")
					} else {
						$(".time-menu-button").attr("disabled", "disabled");
						$(".time-menu-button").removeClass("bg7279a0").removeClass("cfff")
					} 
				})

			})
		</script>
</html>