<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>
		<script>
			//分享是否隐藏
			if (is_weixin()) {
			    //通过config接口注入权限验证配置
			    wx.config({
			        debug: false,
			        appId: '${sign.appId}',
			        timestamp: '${sign.timestamp}',
			        nonceStr: '${sign.nonceStr}',
			        signature: '${sign.signature}',
			        jsApiList: ['hideAllNonBaseMenuItem']
			    });
			    wx.ready(function () {
			    	wx.hideAllNonBaseMenuItem();
			    });
			}
		
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
			
			$.post("${path}/wechatRoom/roomWcDetail.do",{roomId:roomId}, function(data) {
				if(data.status==0){
					var dom = data.data[0];
					if(window.injs){	//判断是否存在方法
    					injs.changeNavTitle(dom.roomName); 
    				}else{
    					$(document).attr("title",dom.roomName);
    				}
					var roomPicUrl = getIndexImgUrl(dom.roomPicUrl,"_750_500");
					$("#roomUrl").attr("src", roomPicUrl);
					var roomTags = dom.roomTagName.split(",");
					$.each(roomTags,function(i,roomTag){
						$("#roomTag").append("<li>"+roomTag+"</li>");
					});
					$("#roomTel").html(dom.roomTel);
					$("#roomArea").html(dom.roomArea+"m<sup>2</sup>");
					$("#roomCapacity").html(dom.roomCapacity+"人");
					var price = ''; 
					if(dom.roomIsFree==2){
    					if (dom.roomFee.length != 0) {
    						if(dom.roomFee>0){
    							price = dom.roomFee + "元/人";
    						}else{
    							price = dom.roomFee;
    						}
                        } else {
                        	price = "收费";
                        }
    				}else{
    					price = "免费";
    				}
					$("#roomPrice").html(price);
					if(dom.roomRemark.length>0){
						$("#roomRemarkLi").show();
						$("#roomRemark").append(dom.roomRemark);
					}
					var roomFacilitys = dom.facility.split(",");
					$.each(roomFacilitys,function(i,facility){
						$("#roomFacility").append("<li>"+facility+"</li>");
					});
					if(data.data1){	
						var dom1 = data.data1;
						
						$(".time-menu-tab").show();
						
						if(dom1.length>4)
							$(".time-menu-tab2").show()
							
						var count=0;
						
						$.each(dom1,function(i,dom11){
							//显示预订按钮
							//if(dom11.status.indexOf("1")>=0){
							//	$(".footer").show();
							//	return false;
							//}
							var time="<li>";
							
							if(count>3)
								time="<li style='display: none;'>";
							
							time+="<ul class='time-menu-act c26262 fs24'>"+
								"<li class='time-menu-data'>"+
									"<p>"+dom11.curDate+"</p>"+
									"</li>";
									
							var statusArr=dom11.status.split(",");
							var openPeriodArr=dom11.openPeriod.split(",");
							var bookIdArr=dom11.bookId.split(",");
							var bookStatusArr=dom11.bookStatus.split(",");
							
							 for (var i = 0; i < bookIdArr.length; i++) 
							{
								var bookId=bookIdArr[i];
								var status=statusArr[i];
								var openPeriod=openPeriodArr[i];
								var bookStatus=bookStatusArr[i];
								 
								if(bookId)
								{
									var cls="";
									var text="";
									//活动室时间状态 0.已过期 1.未过期
									
									//活动室状态 1-可选 2-已选 3-不可选
									if(status=="0"||bookStatus=="3")
									{
										cls="bgf2f2f2";
										text="不开放";
									}
									else if(status=="1")
									{
										if(bookStatus=="1")
										{
											cls="bgdde0f2";
											text="可预订";
										}
										else if(bookStatus=="2")
										{
											cls="bgf2ebca";
											text="已被预订";
										}
									}
									
									time+="<li bookId='"+bookId+"' class='"+cls+"'>"+
									"<p>"+openPeriod+"</p>"+
									"<p>"+text+"</p>"+
									"</li>";
								}
							}
							 
							if(dom11.bookId.length>0){
								
								time+="</ul></li>";
								
								$(".time-menu").append(time);
								
								count++;
							}
								
						
						});
						
						TimeClick(count);
					}
					
					
				}
			},"json");
	});

	//拨打电话
    function callTel() {
        window.location = "tel:" + $("#roomTel").html();
    }
	
	
	//预订
	function roomBook(){
		
		 /* if (!userId) {
			 
			 publicLogin("${basePath}wechatRoom/preRoomDetail.do?roomId="+roomId);
         }
		 else
		{
			var bookId=$(".bg7279a0").attr("bookId");
			
			if(bookId)
			{
				window.location.href="${path}/wechatVenue/roomBookOrder.do?roomId="+roomId+"&bookId="+bookId+"&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
			}
			else
			{
			    dialogAlert("提示", "请选择预订场次");
			}
			
		} */
		$("#sho").show();
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
<div class="erPopBlack" id="sho" style="width: 100%;height: 100%;background-color: rgba(0,0,0,.5);position: fixed;top: 0;left: 0;z-index: 30;display: none">
		<div style="width: 550px;height: 730px;background-color: #fff;position: absolute;top: 50%;left: 50%;margin-top: -365px;margin-left: -275px;-webkit-border-radius: 12px;border-radius: 12px;">
			<div style="width: 106px;height: 106px;background: url(${path}/STATIC/wechat/image/ewm2.png) no-repeat center;position: absolute;right: 0;top: 0;" onclick="$(this).parents('.erPopBlack').stop().hide();"></div>
			<div style="width: 380px;height: 380px;padding: 15px; margin: 0 auto;margin-top: 120px; background: url(${path}/STATIC/wechat/image/ewm1.png) no-repeat center;position: relative;overflow: hidden;">
				<img style="display: block;width: 100%;height: 100%;" src="${path}/STATIC/image/print-qr-code.jpg">
			</div>
			<div style="font-size: 28px;color: #333;text-align: center;margin-top: 90px;">微信扫一扫，登录大沥文化云</div>
		</div>
	</div>
	<input type="hidden" id="roomId"/>
	<div class="main venue-detail">
			<%-- <div class="header">
				<div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
					</span>
					<span id="roomName" class="index-top-2"></span>
				</div>
			</div> --%>
			<div class="content padding-bottom110">
				<img id="roomUrl" src=""  class="masking-down" />
				<img src="${path}/STATIC/wechat/image/蒙板.png" class="masking" />
				<span class="tab-p7">
					<ul id="roomTag"></ul>
				</span>		
				<div class="active-top">
					<ul>
						<li class="border-bottom">
							<p>电话：</p>
							<p id="roomTel" class="break2 w590" onclick='callTel();'></p>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p>面积：</p>
							<p id="roomArea" class="break2 w590"></p>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p>容纳：</p>
							<p id="roomCapacity" class="break2 w590"></p>
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
				<div class="active-detail bgfff">

					<ul>
						<li>
							<div class="time-menu-tab" style="display: none;">
								<h1 class="bgfff fs32 c666" style="text-align: center;line-height: 80px;">活动室预定</h1>
								<div class="time-menu-tab1" style="display: none;"></div>
								<div class="time-menu-tab2" style="display: none;"></div>
							</div>
							<div class="time-menu-div">
								<ul class="time-menu">
							
							
									<div style="clear: both;"></div>
								</ul>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="footer w100-pc height100">
				<button class="w100-pc height100-pc fs30 time-menu-button" disabled="disabled" type="button" onclick="roomBook()">立即预约</button>
			</div>
			<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none">
				<img src="${path}/STATIC/wechat/image/fenxiang.png" style="width: 100%;height: 100%;" />
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