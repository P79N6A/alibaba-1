<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云内部订票系统</title>
	<%@include file="/WEB-INF/why/wechat/superOrder/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	
	<script>
		var startIndex = 0;		//页数
	
		if (!userId) {
		    window.location.href = '${path}/wechatSuperOrder/login.do?type=${basePath}wechatSuperOrder/preActivityOrderList.do';
	    }
		
		$(function(){
			
			loadData(0,20);
			
		});
		
		//首页活动加载
        function loadData(index, pagesize) {
       		$.post("${path}/wechatSuperOrder/getActivityOrderList.do",{firstResult:index,rows:pagesize,userId:userId}, function (data) {
       			if(data.data.length<20){
        			$("#loadingDiv").html("");
        		}
       			$.each(data.data, function (i, dom) {
    				var orderStatus =  "";
    				var orderClass = "";
    				if (dom.orderPayStatus == 1) {
    					orderStatus = "未出票";
    					orderClass = "hong";
                    } else if (dom.orderPayStatus == 2) {
                    	orderStatus = "已取消";
                    	orderClass = "lan";
                    } else if (dom.orderPayStatus == 3) {
                        orderStatus = "已出票";
                        orderClass = "lan";
                    } else if (dom.orderPayStatus == 4) {
                        orderStatus = "已验票";
                        orderClass = "lan";
                    } else if (dom.orderPayStatus == 5) {
                        orderStatus = "已失效";
                        orderClass = "lan";
                    }
       				$("#activityOrderTable").append("<tr>" +
							       						"<td class='th1'>"+dom.activityName+"</td>" +
							       						"<td class='th2'>"+dom.orderValidateCode+"</td>" +
							       						"<td class='th3'>"+dom.orderVotes+"</td>" +
							       						"<td class='th4'><span class='qpzt "+orderClass+"'>"+orderStatus+"</span></td>" +
							       					"</tr>");
       			});
       		}, "json");
		}
		
      	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 10)) {
           		startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
   					loadData(index, 20);
           		},200);
            }
        });
	</script>
	
</head>

<body>
	<div class="inTickets">
		<div class="inTicOrderTab_wc">
			<p class="tit">我的取票码</p>
			<table class="inTicOrderTab" id="activityOrderTable">
				<tr>
					<th class="th1">活动名称</th>
					<th class="th2">取票码</th>
					<th class="th3">票数</th>
					<th class="th4">取票状态</th>
				</tr>
			</table>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
	</div>
</body>
</html>