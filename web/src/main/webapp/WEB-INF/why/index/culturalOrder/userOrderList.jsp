<%@ page import="org.apache.commons.lang3.StringUtils ,com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/culture.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/style.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
	<script type="text/javascript" src="${path}/STATIC/js/jquery-1.9.0.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.1.js" ></script>
	<script type="text/javascript" src="${path}/STATIC/js/laydate/laydate.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/layer/layer.js"></script>

	<title>安康文化云</title>
	<style type="text/css">
		html, body {background-color: #f6f6f6;}
	</style>
	
	<script type="text/javascript">
		var pageIndex = 1;
		var culturalOrderLargeType = '${culturalOrderLargeType}';
		$(function () {
			$("#culturalOrderOrder").addClass('cur').siblings().removeClass('cur');
			loadData('${page.countPage}','${page.page}');
		});
		
		function showReply(orderId){
			$.post("${path}/culturalOrderOrder/getOrderReply.do", {culturalOrderOrderId : orderId}, function(result){
				var hfHtml = '<div style="padding:40px;font-size:14px;color:#333;line-height:1.5;">' + result + '</div>';
				layer.open({
					type: 1,
					title: '回 复',
					closeBtn: 1,
					shade: 0.01,
					shadeClose: true,
					resize: false,
					area: ['600px', '390px'],
					content: hfHtml
				});
			});
		}
		
		function loadData(countPage, page) {
			var params = {
					"culturalOrderLargeType" : culturalOrderLargeType,
					"countPage":countPage,
					"page":page
			};
       		
	        $("#orderDetailDiv").load("${path}/culturalOrderOrder/loadUserOrderList.do", params,function(){
	             getPagination();
	             setScreen();
	        })
		}
		
		function getPagination(){
            //分页
            kkpager.generPageHtml({

                pno :$("#pages").val() ,
                //总页码
                total :$("#countPage").val(),
                //总数据条数
                totalRecords :$("#total").val(),
                mode : 'click',
                click : function(n){
                    this.selectPage(n);
                    $("#reqPage").val(n);
                    loadData('${page.countPage}', $("#reqPage").val());
                    return false;
                }
            });
        }
    	
	   	function getDate(date, mode){
	   		var resultDate = "";
    		if((date.getMonth + 1) < 10){
    			resultDate = date.getFullYear() + '-0' + (date.getMonth() + 1); 
    		}else{
    			resultDate = date.getFullYear() + '-' + (date.getMonth() + 1); 
    		}
    		
    		if(date.getDate() < 10){
    			resultDate = resultDate + '-0' + date.getDate() + " ";
    		}else{
    			resultDate = resultDate + '-' + date.getDate() + " ";
    		}
    		
    		if(mode == 1){
    			if(date.getHours() < 10){
    				resultDate += '0' + date.getHours() + ":";
    			}else{
    				resultDate += date.getHours() + ":";
    			}
    			if(date.getMinutes() < 10){
    				resultDate += '0' + date.getMinutes() + ":";
    			}else{
    				resultDate += date.getMinutes() + ":";
    			}
    			if(date.getSeconds() < 10){
    				resultDate += '0' + date.getSeconds();
    			}else{
    				resultDate += date.getSeconds();
    			}
    		}
    		
    		return resultDate;
	   	}
	   	
	   	function cancelOrderOrInvitation(obj,orderId){
	   		$.post("${path}/culturalOrderOrder/cancelCulturalOrderOrder.do", {culturalOrderOrderId : orderId}, function(result){
				if(result == 'success'){
					dialogAlert('系统提示', '取消操作成功',function(){
						if(culturalOrderLargeType == 1){
							window.location.href = "${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=1";
						}else{
							window.location.href = "${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=2";
						}
					});
				}else{
					dialogAlert('系统提示', '取消操作失败');
				}
			});
	   	}
	</script>
</head>

<body>
<div class="fsMain">
	<!-- start 头部  -->
	<div class="header">
		<%@include file="../header.jsp" %>
	</div>
	<!-- end 头部  -->

	<div id="register-content" style="height: 925px;">
		<div class="crumb">您所在的位置：
			<a href="#">个人主页</a> &gt;
			<a href="#">当前活动</a>
		</div>
		<div class="activity-content user-content clearfix">
			<%@include file="/WEB-INF/why/index/userCenter/user_center_left.jsp"%>
	
			<div class="user-right fr">
				<div class="user-tab" id="webDiv">
					<c:choose>
						<c:when test="${culturalOrderLargeType == 1}">
							<a href='${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=1' class="cur">我的报名</a>
							<a href='${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=2'>我的邀请</a>
						</c:when>
						<c:otherwise>
							<a href='${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=1'>我的报名</a>
							<a href='${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=2' class="cur">我的邀请</a>
						</c:otherwise>
					</c:choose>
					
				</div>
				<div class="myOrderBaoList">
					<div class="myOrderBaoList" id="orderDetailDiv">
						
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- start 底部 -->
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
	<!-- end 底部 -->
</div>
</body>

</html>
