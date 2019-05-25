<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>活动室详情</title> -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<!--<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">-->
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/common.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
		<title></title>
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
		<style>
			.home {
				/*background: url(image/button.gif) no-repeat 25px 10px;*/
				background: url(image/首页.png) no-repeat center center;
			}
			
			.nearby {
				/*background: url(image/button.gif) no-repeat -120px 10px;*/
				background: url(image/附近.png) no-repeat center center;
			}
			
			.calendar {
				/*background: url(image/button.gif) no-repeat -268px 10px;*/
				background: url(image/日历.png) no-repeat center center;
			}
			
			.site {
				/*background: url(image/button.gif) no-repeat -414px 10px;*/
				background: url(image/场馆.png) no-repeat center center;
			}
			
			.me {
				background: url(image/button.gif) no-repeat -562px 10px;
				/*background: url(image/我.png) no-repeat center center;*/
			}
		</style>
		<script>
			$(function() {
				var i = 0;
				$(".user-select").click(function() {
					if (i == 0) {
						$(".user-select").html("取消")
						$(".user-select-name").show()
						i = 1;
					} else {
						$(".user-select").html("选择")
						$(".user-select-name").hide()
						i = 0;
					}
				})
				$(".user-select-name ul").on("click","li",function() {
					var name = $(this).find("p").text()
					$(".user-select-name").hide()
					$(".user-select").html("选择")
					i = 0;
					$(".user-order-name").val(name)
					$("#tuserId").val($(this).attr("tuserId"))
				})
			})
		</script>
		<script type="text/javascript">
			var lat,lon;
		
			$(function(){
				
				var roomId=$("#roomId").val();
				var bookId=$("#bookId").val();
				
				$.post("${path}/wechatVenue/roomBook.do",{roomId:roomId,bookId:bookId}, function(data) {
				
					if(data.status==0){
						
						var dom = data.data;
						$("#roomName").html(dom.roomName);
						var roomPicUrl = getIndexImgUrl(dom.roomPicUrl,"_300_300");
						$("#roomPicUrl").attr("src", roomPicUrl);
						$("#venueName").html(dom.cmsVenueName);
						
						lat=dom.venueLat;
						lon=dom.venueLon;
						$("#date").html(dom.date);
						$("#openPeriod").html(dom.openPeriod);
						$("#price").html(dom.price);
						$("#priceAll").html("总金额："+dom.price);
						
						var teamList=dom.teamList;
						//var teamList=[{tuserId:'1',tuserName:'xsdsd'},{tuserId:'2',tuserName:'fdsfds'}]
						
						if(teamList.length>0)
						{
							$(".user-select").show();
							
							var html="";
							
							$.each(teamList,function(i,tuser){
								
							var li="<li tuserId='"+tuser.tuserId+"'>"+
								"<p>"+tuser.tuserName+"</p>"+
								"</li>";
								
							html+=li;
							});
							
							$(".user-select-name ul").append(html);
						}
					}
				},"json");
			});
			
			 //地址地图
	        function preAddressMap() {
	            window.location.href = "${path}/wechat/preAddressMap.do?lat=" + lat + "&lon=" + lon;
	        }
			 
			// 提交
			function sub(){
				var textReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);		//中文，字母，数字组成正则
				
				var tuserName=$("#tuserName").val();
				if(!tuserName){
			    	dialogAlert('系统提示', '请输入或选择使用者！');
			        return false;
			    }
				if(!tuserName.match(textReg)){
    		    	dialogAlert('提示', '使用者只能由中文，字母，数字组成！');
    		        return false;
    		    }
				
				var orderName=$("#orderName").val(); 
				if(!orderName){
			    	dialogAlert('系统提示', '请输入联系人名称！');
			        return false;
			    }
				if(!orderName.match(textReg)){
    		    	dialogAlert('提示', '名称只能由中文，字母，数字组成！');
    		        return false;
    		    }
				
				var orderTel=$("#orderTel").val(); 
				var telReg = (/^1[34578]\d{9}$/);
				if(!orderTel){
			    	dialogAlert('系统提示', '请输入手机号码！');
			        return false;
			    }else if(!orderTel.match(telReg)){
			    	dialogAlert('系统提示', '请正确填写手机号码！');
			        return false;
			    }
				
				var purpose=$("#purpose").val();
				if(!purpose){
			    	dialogAlert('系统提示', '请输入场馆用途！');
			        return false;
			    }
				
				var data=$("#roomOrderForm").serialize();
				
				 var encode = function(json) {  
			              
			            var tmps = [];  
			            for (var key in json) {  
			                tmps.push(key + '=' + json[key]);  
			            }  
			              
			            return tmps.join('&');  
			        }  
				
				$.ajax({
					type:"post",
					url:"${path}/wechatVenue/roomOrderConfirm.do",
					data:data,
					dataType: "json",
					success:function(data){
						if(data.status==0){
							
							location.href= "${path}/wechatVenue/roomOrderComplete.do?"+encode(data.data);
						}
						else
						{
							dialogAlert('系统提示', data.data);
						}
						
					}
				});
			}
		</script>
	</head>

<body>
<form id="roomOrderForm" >
		<input type="hidden" id="roomId" name="roomId" value="${roomId }"/>
		<input type="hidden" id="bookId" name="bookId" value="${bookId }"/>
		<div class="main">
			<div class="header">
				<div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
					</span>
					<span class="index-top-2">活动室预订</span>
				</div>
			</div>
			<div class="content margin-top100 padding-bottom110">
				<div class="my-order">
					<ul>
						<li>
							<div class="activity-title bgfff list-div-arrow-right ">
								<img src="" id="roomPicUrl"/>
								<div class="activity-p">
									<p class="fs30 c26262 w300" id="roomName"></p>
									<p class="fs26 c808080 activity-p-place w300" id="venueName" onclick="preAddressMap();"></p>
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
									<li>
										<label>价格：</label>
										<span id="price"></span>
									</li>
								</ul>
							</div>
						</li>
						<li>
							<div class="list-div fs30 c26262 list-div-input">
								<ul>
									<li class="border-bottom">
										<p>使用者：</p>
										<input class="user-order-name" id="tuserName" name="tuserName" type="text" placeholder="请填写使用者名称" />
										<div style="clear: both;"></div>
										<div class="user-select" style="display: none;">选择</div>
										<div class="user-select-name">
										<input type="hidden" id="tuserId" name="tuserId" />
											<ul>
												
											</ul>
										</div>
									</li>
									<li class="border-bottom">
										<p>预定联系人：</p>
										<input type="text" id="orderName" name="orderName" placeholder="请填写预定联系人" value="${userNickName }"/>
										<div style="clear: both;"></div>
									</li>
									<li class="border-bottom">
										<p>预定人手机：</p>
										<input type="text" id="orderTel" name="orderTel" placeholder="请填写预定人手机" value="${userTelephone }"/>
										<div style="clear: both;"></div>
									</li>
									<li>
										<p>预定用途：</p>
										<textarea class="fs30" id="purpose" name="purpose" style="resize: none;width: 480px;border: none;float: left;height: 200px;" placeholder="请填写活动室使用用途"></textarea>
										<div style="clear: both;"></div>
									</li>
								</ul>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="footer">
				<div class="order-button">
					<div class="f-left w50-pc height100 fs30 c808080 bgf4f4f4">
						<p style="margin-top: 20px;padding-left: 20px;" id="priceAll">总金额：</p>
					</div>
					<button class="f-left bg7279a0 w50-pc height100 fs30 cfff" type="button" onclick="sub()">确认预订</button>
					<div style="clear: both;"></div>
				</div>
			</div>
		</div>
</form>
	</body>
</html>
