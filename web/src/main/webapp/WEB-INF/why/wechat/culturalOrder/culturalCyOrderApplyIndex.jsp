<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>文化点单</title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css" />

		<script type="text/javascript">
		var culturalOrderId = '${order.culturalOrderId}';
		var culturalOrderLargeType = '${order.culturalOrderLargeType}';
		var json;
		var isNext = true;
		$(function(){
			queyOrderEventDateList();
		})
		
		function queyOrderEventDateList() {
			 if (userId == null || userId == '') {
				 publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
	                return;
	            }else{
	            	$.post("${path}/wechatCulturalOrder/queyOrderEventList.do", {
	   				 culturalOrderId: culturalOrderId,
	                 userId: userId
	             }, function (data) {
	            	 if (data.status == 200) {	
	            		 var khtml = "";
	            		 json = data.data;
	            		 var set = new Set();
	            		 var arr = new Array();
	            		 $.each(json, function (i, v) {
	            			 if(new Date(timeStamp2String(new Date())).getTime()>new Date(v.culturalOrderEventDateStr).getTime()){
	            				 return true;
	     			    	 }
	            			 if (!set.has(v.culturalOrderEventDateStr)){
	            				 var ifdisable = false;
	            				 $.each(json,function(ii,vv){
            						if (vv.culturalOrderEventDateStr == timeStamp2String(new Date())){
            							var d_1 = new Date(timeStamp2String(new Date())+" "+ vv.culturalOrderEventTime.substr(6,5)+":00").getTime();
            							var d_2 = new Date().getTime();
            							if (d_2<d_1){
            								ifdisable = true;
            								return false;
            							}
            						}else{
            							ifdisable = true;
            						}
	            				 });
	            				 if(ifdisable){
			            			 arr.push(v.culturalOrderEventDateStr);
			            			 set.add(v.culturalOrderEventDateStr);
	            				 }
	            				 
	            			 }
						});	
	            		for (var i=0;i<arr.length;i++){
	            			khtml += "<option value='"+arr[i]+"'>"+arr[i]+"</option>";
	            		}
	            		 $("#fwDate").html(khtml);
	            		 queryOrderEventTimeList();
	                 }
	             }, "json");
	            }			 
		}
		//在Jquery里格式化Date日期时间数据
		function timeStamp2String(time){
		    var datetime = new Date();
		    datetime.setTime(time);
		    var year = datetime.getFullYear();
		    var month = datetime.getMonth() + 1 < 10 ? "0" + (datetime.getMonth() + 1) : datetime.getMonth() + 1;
		    var date = datetime.getDate() < 10 ? "0" + datetime.getDate() : datetime.getDate();
		    return year + "/" + month + "/" + date;
		}
		
		function queryOrderEventTimeList(){
			var culturalOrderEventDateStr = $('#fwDate').val();
			var html = "";
			$.each(json,function(i,v){
				if (v.culturalOrderEventDateStr == culturalOrderEventDateStr){
					if(v.culturalOrderEventDateStr == timeStamp2String(new Date())){
						var d_1 = new Date(timeStamp2String(new Date())+" "+ v.culturalOrderEventTime.substr(6,5)+":00").getTime();
						var d_2 = new Date().getTime();
						if (d_2<d_1){
							html += "<option value='"+v.culturalOrderEventId+"'>"+v.culturalOrderEventTime+"</option>";
						}
					}else{
						html += "<option value='"+v.culturalOrderEventId+"'>"+v.culturalOrderEventTime+"</option>";
					}
				}
			});
			$("#fwTime").html(html);
			changeTicketNum();
		}
		
		function changeTicketNum(){
			var culturalOrderEventId = $('#fwTime').val();
			var usedNum,ticketNum,residueNum;
			$.each(json,function(i,v){
				if (v.culturalOrderEventId == culturalOrderEventId){
					usedNum  = v.usedTicketNum;
					ticketNum = v.eventTicketNum;
					residueNum = ticketNum-usedNum;
				}
			});
			$("#ticketNum").html("剩余名额：&emsp;<em style='font-size:32px;color: #e63917;'>"+residueNum+"</em>／"+ticketNum);
		}
		
		function addApply(){
			var culturalOrderEventId = $('#fwTime').val();
			var hasFlag = false;
			$.each(json,function(i,v){
				if (v.culturalOrderEventId == culturalOrderEventId){
					if (v.userHasOrder == 1){
						hasFlag = true;
						return;
					}
				}
			});
			if (hasFlag){
				dialogAlert('报名提示', '该服务时段你已报名，请勿重复报名！');
    			return;
			}
			if(isNext){
				if (userId == null || userId == '') {
					 publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
		                return;
		            }else{
		            	var userDescription = $("#userDescription").val();
		        		if(userDescription.trim()==""){
		        			dialogAlert('报名提示', '报名说明不能为空！');
		        			return;
		        		}
		        		if(userDescription.length<4){
		        			dialogAlert('报名提示', '报名说明不能少于4个字！');
		        			return;
		        		}
		        		
		        		var data = {
		     					userId:userId,
		     					culturalOrderId:culturalOrderId,
		     					culturalOrderLargeType:culturalOrderLargeType,
		     					culturalOrderEventId:culturalOrderEventId,
		     					userDescription:userDescription
		        		}
		        		
		        		$.post("${path}/wechatCulturalOrder/addCulturalOrderOrder.do", data , function (data) {
		        			isNext = false;
		                    if (data.status == 200) {
		                    	if(data.data == -1){
		                    		window.location.href = "${path}/wechatCulturalOrder/culturalOrderWinIndex.do?culturalOrderId="+culturalOrderId+"&culturalOrderLargeType=4";
		                    	}else if(data.data == 1){
		                    		window.location.href = "${path}/wechatCulturalOrder/culturalOrderWinIndex.do?culturalOrderId="+culturalOrderId+"&culturalOrderLargeType=${culturalOrderLargeType}";
		                    	}else{
			                    	dialogAlert('报名提示', '报名失败，请检查数据重新提交！');
			                    }
		                    }else{
		                    	dialogAlert('报名提示', '报名失败，请检查数据重新提交！');
		                    }
		                    isNext = true;
		                }, "json");
		            }		
   			}
		}
		</script>
	</head>

<body style="background-color: #f3f3f3;">
	<div class="fsMain">

		<div class="swiper-container whlmBanner">
			<div class="swiper-wrapper">
				<a href="#" class="swiper-slide"><img src="${order.culturalOrderImg}" width="750px" height="260px"></a>
			</div>
		</div>
		
		<div class="dhshWrap">
			<div class="dhshInfo">
				<h1 class="tit">${order.culturalOrderName}</h1>
				<p>服务类型：${order.culturalOrderTypeName}</p>
				<p>服务地址：${order.culturalOrderAddress}</p>
			</div>
			<div class="bmInfo">
				<div class="infoWrap clearfix">
					<span class="name">请选择服务日期</span>
					<select class="selInput" id="fwDate" onchange="queryOrderEventTimeList()">
						<option>请选择服务日期</option>			  		
					</select>
				</div>
				<div class="infoWrap clearfix">
					<span class="name">请选择服务时段</span>
					<select class="selInput" id="fwTime" onchange="changeTicketNum()">						
				  		<option>请选择服务时段</option>
					</select>
				</div>
				<div class="infoWrap clearfix" id="ticketNum">
				</div>
				<textarea class="addInfo" placeholder="请填写报名说明，限200字以内" id="userDescription" maxlength="200"></textarea>
				<p class="tipsTit">*报名须知</p>
				<p class="tips">${order.culturalOrderMustKnow}</p>
			</div>
		</div>
		<div class="postBm" onclick="addApply();"><a>提交报名</a></div>
	</div>
</body>

</html>