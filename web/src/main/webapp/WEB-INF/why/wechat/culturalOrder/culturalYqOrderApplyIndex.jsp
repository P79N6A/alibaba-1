<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>文化点单</title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css" />
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/iosSelect.css" />
		<script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/datePicker.js"></script>

		<script type="text/javascript">
			var culturalOrderId = '${order.culturalOrderId}';
			var culturalOrderLargeType = '${order.culturalOrderLargeType}';
			var culturalOrderAreaLimit = '${order.culturalOrderAreaLimit}';
			var culturalOrderDemandLimit = '${order.culturalOrderDemandLimit}';
			var orderAddress ;
			var isNext = true;
			$(function(){
				queryCulturalOrderAreaLimit();									
			});
			
			function queryCulturalOrderAreaLimit() {
				 if (userId == null || userId == '') {
					 publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
		                return;
		            }else{
		            	var code = culturalOrderAreaLimit.split(",")[0];
						if(code == "-1"){
		            		 $("#dz").show();
		            		//加载地区
		        		    var venueProvince = '2822,广东省';
		        		    var venueCity = '2958,佛山市';
		        		    //省市区
		        		    var loc = new Location();
		        		    var json = loc.find( '0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
		        		    if (json){
			        		    var option ='';
			        		    $.each(json , function(k , v) {
			        		       option +='<option value="'+k+','+v+'">'+v+'</option>';		        		     
			        		    });
			        		    $("#dz").html(option);
		        		    }
		            	}
		            	
		            	queryOrderByDictCode();	
		            	
						 var calendar = new datePicker();
						 var minDate = '${order.startDateStr}';
						 if(new Date(timeStamp2String(new Date())).getTime()>new Date('${order.startDateStr}').getTime()){
							 minDate = timeStamp2String(new Date());
     			    	 }
		                 calendar.init({
		                     'trigger': '#beginDate', /*按钮选择器，用于触发弹出插件*/
		                     'type': 'date',/*模式：date日期；datetime日期时间；time时间；ym年月；*/
		                     'minDate':minDate,/*最小日期*/
		                     'maxDate':'${order.endDateStr}',/*最大日期*/
		                     'onSubmit':function(){/*确认时触发事件*/
		                         var theSelectData=calendar.value;
		                     },
		                     'onClose':function(){/*取消时触发事件*/
		                     }
		                 });
						

		            }			 
			}
			//在Jquery里格式化Date日期时间数据
			function timeStamp2String(time){
			    var datetime = new Date();
			    datetime.setTime(time);
			    var year = datetime.getFullYear();
			    var month = datetime.getMonth() + 1 < 10 ? "0" + (datetime.getMonth() + 1) : datetime.getMonth() + 1;
			    var date = datetime.getDate() < 10 ? "0" + datetime.getDate() : datetime.getDate();
			    return year + "-" + month + "-" + date;
			}
			
			function queryOrderByDictCode(){
				var code = culturalOrderAreaLimit.split(",")[0];
				if(code == "-1"){
					var sel = document.getElementById("dz");
					    orderAddress = sel.options[sel.selectedIndex].value;	
					 code = orderAddress.split(",")[0];
				}else{
	            	var areaLimit = culturalOrderAreaLimit.split(",")[1];
					$("#orderAreaLimit").html("该邀请仅限"+areaLimit);
				}
				
				console.log(code);
				$.post("${path}/sysdict/queryChildSysDictByDictCode.do", {dictCode: code}, function (data) {
			        var list = eval(data);
			        var dictHtml = '';
			        for (var i = 0; i < list.length; i++) {
			            var obj = list[i];
			            var dictId = obj.dictId;
			            var dictName = obj.dictName;
			            dictHtml += '<option value="'+dictId+'">'+dictName+'</option>';
			        }
			        $("#jd").html(dictHtml);
			    });
			}
		
			function addApply(){
				if(isNext){
					if (userId == null || userId == '') {
						 publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
			                return;
			            }else{			            	
			            	var culturalOrderOrderDate = $('#beginDate').val();
			            	var culturalOrderOrderPeriod = $('#culturalOrderOrderPeriod').val();
			            	var code = culturalOrderAreaLimit.split(",")[0];
							if(code == "-1"){
			            		var culturalOrderOrderArea = orderAddress;	
			            	}else{
			            		var culturalOrderOrderArea = culturalOrderAreaLimit;
			            	}			            	
			            	var culturalOrderOrderTown = $('#jd').val();
			            	var culturalOrderOrderAddress = $('#culturalOrderOrderAddress').val();
			            	var userDescription = $("#userDescription").val();
			            	
			            	if(culturalOrderOrderDate == "" || culturalOrderOrderDate == undefined){
			        			dialogAlert('报名提示', '服务日期不能为空！');
			        			return;
			        		}
			            	if(culturalOrderOrderPeriod == "" || culturalOrderOrderPeriod == undefined){
			        			dialogAlert('报名提示', '服务时段不能为空！');
			        			return;
			        		}
			            	if(culturalOrderOrderTown == "" || culturalOrderOrderTown == undefined){
			        			dialogAlert('报名提示', '服务街道不能为空！');
			        			return;
			        		}
			            	if(culturalOrderOrderAddress == "" || culturalOrderOrderAddress == undefined){
			        			dialogAlert('报名提示', '详细地址不能为空！');
			        			return;
			        		}
			        		if(userDescription.trim() == "" || userDescription.trim() == undefined){
			        			dialogAlert('报名提示', '报名说明不能为空！');
			        			return;
			        		}
			        		if(userDescription.length < 4){
			        			dialogAlert('报名提示', '报名说明不能少于4个字！');
			        			return;
			        		}
			        		
			        		var data = {
			     					userId:userId,
			     					culturalOrderId:culturalOrderId,
			     					culturalOrderLargeType:culturalOrderLargeType,
			     					culturalOrderOrderDateStr:culturalOrderOrderDate,
			     					culturalOrderOrderPeriod:culturalOrderOrderPeriod,
			     					culturalOrderOrderArea:culturalOrderOrderArea,
			     					culturalOrderDemandLimit:culturalOrderDemandLimit,
			     					culturalOrderOrderTown:culturalOrderOrderTown,
			     					culturalOrderOrderAddress:culturalOrderOrderAddress,
			     					userDescription:userDescription
			        		}
			        		
			        		$.post("${path}/wechatCulturalOrder/addCulturalOrderOrder.do", data , function (data) {
			        			isNext = false;
			                    if (data.status == 200) {
			                    	if(data.data == 102411){
			                    		window.location.href = "${path}/wechatCulturalOrder/culturalOrderWinIndex.do?culturalOrderId="+culturalOrderId+"&culturalOrderLargeType=3";
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
				<p>服务对象：<c:if test="${order.culturalOrderDemandLimit == 1}">个人</c:if><c:if test="${order.culturalOrderDemandLimit == 2}">机构</c:if><c:if test="${order.culturalOrderDemandLimit == 3}">不限</c:if></p>
			</div>
			<div class="bmInfo">
				<div class="infoWrap clearfix" id="selectDate">
					<span class="name">请选择服务日期</span>
					<input type="text" placeholder="请选择服务日期" onfocus="this.blur()" class="txtInput" style="float: left;width: 443px;" id="beginDate" />
				</div>
				<div class="infoWrap clearfix">
					<span class="name">请填写服务时段</span>
					<input type="text" placeholder="例如：14:00-15:00" class="txtInput" id="culturalOrderOrderPeriod"  style="float: left;width: 443px;">
				</div>
				<div class="infoWrap clearfix">
					<span class="name">请选择服务地址</span>
					<p class="tipsTit" id="orderAreaLimit"></p>
					<select class="selInput smallInput fl" id="dz" onchange="queryOrderByDictCode()" style="display: none;float: left;width: 485px;">
						<option value="">请选择服务地址</option>						
					</select>
				</div>

				<div class="infoWrap clearfix" style="margin-bottom: 20px;">
					<select class="selInput smallInput fl" id="jd">
						<option>街道</option>
					</select>
					<input type="text" placeholder="请填写详细地址" class="txtInput" id="culturalOrderOrderAddress">
				</div>
				<textarea class="addInfo" placeholder="请填写报名说明，限200字以内" id="userDescription" maxlength="200"></textarea>
				<p class="tipsTit">*邀请须知</p>				
				<p class="tips">${order.culturalOrderMustKnow}</p>
			</div>
		</div>
		<div class="postBm" onclick="addApply();"><a>提交邀请</a></div>
	</div>
</body>

</html>