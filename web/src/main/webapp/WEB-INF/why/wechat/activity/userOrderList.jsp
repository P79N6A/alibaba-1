<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<title>安康文化云订单找回系统</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/wechat/css/style.css" />
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

<script>
	$(function() {
		
		var userMobileNo='${sessionScope.terminalUser.userMobileNo}';

		if (userMobileNo == null || userMobileNo == '') {

			window.location.href = "${path}/wechatActivity/userOrderLogin.do";

		} else {

			var param = {
					userMobileNo : userMobileNo
			};

			$.post("${path}/wechatActivity/searchOrderList.do", param, function(result) {
				
				  var orderListHtml = "";
				
				 if (result.status == 1) {
                 	if(result.data1==undefined){
                 		result.data1=[];
                 	}
                 	  var activityOrderAry = result.data;
                      var venueOrderAry = result.data1;
                      Array.prototype.push.apply(activityOrderAry, venueOrderAry);
                      var orderSortAry = activityOrderAry.sort(function (a, b) {
                          a = a.orderTime;
                          b = b.orderTime;
                          return b - a;
                      })
                      
                     for (var i = 0; i < orderSortAry.length; i++) {
                       if (orderSortAry[i].activityName != '' && orderSortAry[i].activityName != undefined) {
                    	   
                    	   var activityName = orderSortAry[i].activityName;
                    	   var activityEventDateTime = orderSortAry[i].activityEventDateTime;
                    	   var orderVotes = orderSortAry[i].orderVotes;
                           var orderValidateCode = orderSortAry[i].orderValidateCode;
                           
                           orderListHtml+=
                           '<tr>'+
		       					'<td class="th1">'+activityName+'</td>'+
		       					'<td class="th2">'+activityEventDateTime+'</td>'+
		       					'<td class="th3">'+orderVotes+'</td>'+
		       					'<td class="th4"><input class="dpBtn" type="button" value="查看取票码" onClick=see("'+orderValidateCode+'");></td>'+
		       				'</tr>';
                    	   
                       } else {
                    	   
                    	   
                       }
                     }
                      
                      if(orderListHtml.length>0){
                    	  $("#loadingDiv").remove();
                          $(".inTicOrderTab").append(orderListHtml)
                      }else {
                    	  $("#loadingDiv").html("没有数据！");
                  	}
                   	
				 }

			}, "json");
		}

	});
	
	function see(orderValidateCode){
		
		$("#orderValidateCode").html(orderValidateCode)
		
		$(".inTicWindow_success").show();
	}
	
	function inTicWindowClose(div){
		
		$(div).parents(".inTicWindow").hide();
	}
</script>
 
</head>
<body>
	<div class="inTickets">
		<div class="inTicOrderTab_wc">
			<table class="inTicOrderTab">
				<tr>
					<th class="th1">活动名称</th>
					<th class="th2">活动时间</th>
					<th class="th3">订票数</th>
					<th class="th4">操作</th>
				</tr>
				
			</table> 
		</div>
 		<div id='loadingDiv' align="center"  class='loadingDiv'>
	 		<img  class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif' />
	 		<span class='loadingSpan'>加载中。。。</span>
	 		<div style='clear:both'></div>
 		</div>
	</div>
	<!-- 订票数量弹窗 -->
	<div class="popUpsBlack"></div>
	<div class="inTicWindow inTicWindow_amount">
		<div class="char">
			<p>请输入订票数量</p>
			<input class="txtSL" type="text" placeholder="请输入数字1-5">
		</div>
		<div class="anniu clearfix">
			<div class="twoBtn queren">确认</div>
			<div class="twoBtn quxiao">取消</div>
		</div>
	</div>
	<div class="inTicWindow inTicWindow_success">
		<div class="char">
			<div class="tit"></div>
			<p >取票码：<span id="orderValidateCode"></span></p>
		</div>
		<div class="anniu clearfix">
			<div class="oneBtn close" onclick="inTicWindowClose(this);">关闭</div>
		</div>
	</div>
	<div class="inTicWindow inTicWindow_fail">
		<div class="char">
			<div class="tit">预订失败</div>
			<p>余票不足</p>
		</div>
		<div class="anniu clearfix">
			<div class="oneBtn close">关闭</div>
		</div>
	</div>
</body>

</html>