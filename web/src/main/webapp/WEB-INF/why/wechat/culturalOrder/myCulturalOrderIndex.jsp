<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>文化点单</title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css" />
		<style type="text/css">
			.whlmBanner .swiper-pagination-fraction{
				font-size: 22px;color: #ffffff;
			}
			.whlmBanner .swiper-pagination-current{
				color: #e63917;
			}
		</style>
		<script type="text/javascript">
		var array = new Array();
		var culturalOrderLargeType = '${culturalOrderLargeType}';
		//滑屏分页
		var startIndex = 1;
		var pageSize = 10;
		var isNext = true;
		$(function () {
			if(culturalOrderLargeType == 2){
				$(".menuTabUl").html('<li value="1">我的报名</li><li class="on" value="2">我的邀请</li>');
			}else{
				
			}
			queryOrderOrderList(startIndex,pageSize);
			
			$(".menuTabUl").on('click','li',function(){
				$(this).addClass('on').siblings().removeClass("on");
				startIndex = 1;
				$(".myNoteList").html("");
				queryOrderOrderList(startIndex,pageSize);
			})
			$(".closeBtn").click(function(){
				$(".blackMask").hide();
			})
		})
								
		function queryOrderOrderList(startIndex,pageSize) {				
			 if (userId == null || userId == '') {
				 publicLogin('${basePath}wechatCulturalOrder/myCulturalOrderIndex.do');
	                return;
	            }else{
	            	 $.post("${path}/wechatCulturalOrder/queryOrderOrderList.do", {
	            	 culturalOrderLargeType: $(".menuTabUl .on").attr("value"),
	                 userId: userId,
	                 page:startIndex,
	 				 rows:pageSize
	             }, function (data) {
	            	 isNext = false;
	            	 var ltHtml = "";
	            	 if (data.status == 200) {	
	            		 var listInfo = data.data;
		 					if(listInfo != null){
		 						$.each(listInfo, function (i, v) {
		 							ltHtml += '<li class="clearfix">'+
						 							'<div class="infoTop clearfix"><span>'+ v.culturalOrderName +'</span>';
						 							
		 							if(v.culturalOrderOrderStatus == 0){
		 								 ltHtml += '<em class="on">待确认</em>';
		 							}else if(v.culturalOrderOrderStatus == 1){
		 								 ltHtml += '<em>已确认</em>';
		 							}else if(v.culturalOrderOrderStatus == 2){
		 								 ltHtml += '<em class="gray">已拒绝</em>';
		 							}else if(v.culturalOrderOrderStatus == 3){
		 								 ltHtml += '<em class="gray">已取消</em>';
		 							}
						 														 							
						 		    ltHtml +=		'</div><div class="charMid clearfix">'+
						 							'<div class="img"><img src="'+ v.culturalOrderImg +'" width="200px" height="126px"></div>'+
						 							'<div class="char">';
						 							
						 		   if(v.culturalOrderLargeType == 1){
		 								 ltHtml += '<p>日期：'+ v.culturalOrderEventDateStr +'</p>'+
				 								   '<p>时段：'+ v.culturalOrderEventTime +'</p>';
		 							}else{
		 								 ltHtml += '<p>日期：'+ v.culturalOrderOrderDateStr +'</p>'+
		 								           '<p>时段：'+ v.culturalOrderOrderPeriod +'</p>';
		 							}				
						 							
						 		   if(v.culturalOrderOrderStatus == 0){
		 								 ltHtml += '<a href="#" class="noteBtn" onclick="cancelCulturalOrderOrder(\''+v.culturalOrderName+'\',\''+v.culturalOrderOrderId+'\')">取消报名</a>';
		 							}else if(v.culturalOrderOrderStatus == 1 || v.culturalOrderOrderStatus == 2){
		 								 ltHtml += '<a href="#" class="noteBtn" onclick="showReply(\''+v.culturalOrderOrderId+'\')">查看回复</a>';
		 							}
						 							
						 			ltHtml +=		'</div>'+
						 							'</div>'+
					 							'</li>';
					 				var obj = {
					 					culturalOrderOrderId:v.culturalOrderOrderId,
					 					culturalOrderReply:v.culturalOrderReply
					 				};
					 				array.push(obj);
		 						});
		 					}
	                 }else{
	 					
	 				 }	
	            	 $(".myNoteList").append(ltHtml);
	            	 isNext = true;
	             }, "json"); 
	            }			 
		}	
		
		function showReply(culturalOrderOrderId){
			var reply = "";
			for (var i=0;i<array.length;i++){
				if (array[i].culturalOrderOrderId == culturalOrderOrderId){
					reply=array[i].culturalOrderReply;
					break;
				}
			}
		    $("#culturalOrderReply").html(reply);
			$(".blackMask").show();
		}
		
		function cancelCulturalOrderOrder(culturalOrderName,culturalOrderOrderId){
			var html = '是否取消“'+culturalOrderName+'”报名订单？';
			dialogTypeConfirm('取消提示', html, function(){
				$.post("${path}/wechatCulturalOrder/cancelCulturalOrderOrder.do", {
					culturalOrderOrderId: culturalOrderOrderId
	            }, function (data) {
	            	var dom = JSON.parse(data);
	            	if (dom.status == 200) {
	                	window.location.href = "${path}/wechatCulturalOrder/myCulturalOrderIndex.do";
	                }else{
	                	dialogAlert('取消提示', '取消失败！');
	                }
	            })
			})		
		}
		
		function dialogTypeConfirm(title, content, fn){
	        var d = parent.dialog({
	            width:400,
	            title:title,
	            content:content,
	            fixed: true,
	            button:[{
	                value: '确定',
	                callback: function () {
	                    if(fn)  fn();
	                },
	                autofocus: true
	            },{
	                value: '取消'
	            }]
	        });
	        d.showModal();
	    }
			
			$(window).on("scroll", function () {
	            var scrollTop = $(document).scrollTop();
	            var pageHeight = $(document).height();
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight - 100)) {
	            	console.log(scrollTop);
	           		setTimeout(function () { 
	           			if(isNext){
	           				startIndex += 1;
	           				queryOrderOrderList(startIndex,pageSize);
	           			}
	           		},800);
	            }
	        });
		</script>
	</head>

<body style="background-color: #f3f3f3;">
	<div class="fsMain">
		<div class="dhshWrap ddWrap">
			<!-- 我的报名和我的邀请是一模一样的！！！！！！！！！！！！！！！！！！！ -->
			<div class="whzsWrap dhshListWrap noteWrap">
				<ul class="menuTabUl clearfix">
					 <li class="on" value="1">我的报名</li>
					<li value="2">我的邀请</li> 
				</ul>
			</div>

			<div class="myNoteWrap">
				<ul class="myNoteList">
					<!-- <li class="clearfix">
						<div class="infoTop clearfix"><span>佛山市图书馆玩具店</span><em>已确认</em></div>
						<div class="charMid clearfix">
							<div class="img"><img src="http://placehold.it/200x126"></div>
							<div class="char">
								<p>日期：2018-05-25</p>
								<p>时段：14：00-15：00</p>
								<a href="#" class="noteBtn" onclick="show()">查看回复</a>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="infoTop clearfix"><span>佛山市图书馆玩具店</span><em class="on">待确认</em></div>
						<div class="charMid clearfix">
							<div class="img"><img src="http://placehold.it/200x126"></div>
							<div class="char">
								<p>日期：2018-05-25</p>
								<p>时段：14：00-15：00</p>
								<a href="#" class="noteBtn">取消报名</a>
							</div>
						</div>
					</li>
					<li class="clearfix">
						<div class="infoTop clearfix"><span>佛山市图书馆玩具店</span><em class="gray">已拒绝</em></div>
						<div class="charMid clearfix">
							<div class="img"><img src="http://placehold.it/200x126"></div>
							<div class="char">
								<p>日期：2018-05-25</p>
								<p>时段：14：00-15：00</p>
								<a href="#" class="noteBtn">查看回复</a>
							</div>
						</div>
					</li> -->
				</ul>
			</div>
		</div>
	</div>
	<!-- 弹窗 -->
	<div class="blackMask">
		<div class="maskWrap">
			<p class="tit">查看回复</p>
			<div class="char">
				<p id="culturalOrderReply"></p>
				<span class="closeBtn">关 闭</span>
			</div>
		</div>
	</div>
</body>

</html>