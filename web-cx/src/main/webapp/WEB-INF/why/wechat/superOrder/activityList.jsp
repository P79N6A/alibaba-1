<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云内部订票系统</title>
	<%@include file="/WEB-INF/why/wechat/superOrder/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	
	<script>
		var startIndex = 0;		//页数
		var searchKey = '';
	
		if (!userId) {
		    window.location.href = '${path}/wechatSuperOrder/login.do';
	    }
		
		$(function(){
			
			loadData(0,20);
			
		});
		
		//首页活动加载
        function loadData(index, pagesize) {
       		$.post("${path}/wechatSuperOrder/getActivityList.do",{firstResult:index,rows:pagesize,searchKey:searchKey,userId:userId}, function (data) {
       			if(data.data.length<20){
        			$("#loadingDiv").html("");
        		}
       			$.each(data.data, function (i, dom) {
       				var time = dom.activityStartTime.substring(0,10).replace("-",".").replace("-",".");
    				if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
    					time += "-"+dom.activityEndTime.substring(0,10).replace("-",".").replace("-",".");
    				}
    				var orderBtn =  "";
    				if (dom.activityIsPast==1) {
    					orderBtn = "<td class='th4'><input class='dpBtn' type='button' value='已结束' style='background-color:#ccc'></td>"
    				}else{
    					if(dom.availableCount > 0){
        					orderBtn = "<td class='th4'><input class='dpBtn' type='button' value='订票' onclick='location.href=\"${path}/wechatSuperOrder/preActivityOrder.do?activityId="+dom.activityId+"\"'></td>"
                		}else{
                			orderBtn = "<td class='th4'><input class='dpBtn' type='button' value='已订完' style='background-color:#ccc'></td>"
                		}
    				}
       				$("#activityTable").append("<tr>" +
						       						"<td class='th1'>"+dom.activityName+"</td>" +
						       						"<td class='th2'>"+time+"</td>" +
						       						"<td class='th3'>"+dom.availableCount+"</td>" +
						       						orderBtn +
						       				   "</tr>");
       			});
       		}, "json");
		}
		
		//搜索
		function searchActivity(){
			searchKey = $("#searchKey").val();
			startIndex = 0;
			$("#activityTable tr:gt(0)").remove();
			if($("#loadingDiv").html() == ""){
				$("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif' /><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
			}
			loadData(0,20);
		}
		
      	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 100)) {
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
		<div class="inTicSearch">
			<div class="snc clearfix">
				<input class="txt" id="searchKey" type="text" placeholder="请输入完整的活动名称">
				<input class="btn" type="button" value="立即搜索" onclick="searchActivity();">
			</div>
		</div>
		<div class="inTicOrderTab_wc">
			<table class="inTicOrderTab" id="activityTable">
				<tr>
					<th class="th1">活动名称</th>
					<th class="th2">活动时间</th>
					<th class="th3">剩余票数</th>
					<th class="th4">操作</th>
				</tr>
			</table>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
		<div class="seeQpBtn"><a href="${path}/wechatSuperOrder/preActivityOrderList.do">查看我的取票码</a></div>
	</div>
</body>
</html>