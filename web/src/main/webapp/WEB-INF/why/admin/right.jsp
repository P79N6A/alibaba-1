<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<%@include file="/WEB-INF/why/common/limit.jsp"%>
	<title>首页--文化云</title>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main-ie.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/swiper.min.css"/>
	
	<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/swiper.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
	<script type="text/javascript">
		var userId = '${sessionScope.user.userId}';
	  
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
	  
	    $(function() {
	    	if('${indexStatistics.activityCreateTime}'){
	    		$('#activityCreateTime').val('${indexStatistics.activityCreateTime}');
	    	}else{
	    		$('#activityCreateTime').val((new Date()).getFullYear() + '-' + (((new Date()).getMonth() + 1) < 10 ? '0' + ((new Date()).getMonth() + 1) : ((new Date()).getMonth() + 1)));
	    	}
	    	
	    	$('#activityCreateTime').bind('focus', function () {
	            WdatePicker({
	                dateFmt:'yyyy-MM',
	                minDate:'%y-{%M-12}',
	                maxDate:'%y-{%M+11}',
	                onpicked:function () {
	                	$('#activityCreateTime').val($dp.cal.getP('y')+'-'+$dp.cal.getP('M'));
	                }
	            });
	        });
	
	        var swiper = new Swiper('.lunSwipet .swiper-container', {
	            prevButton:'.lunSwipet .swiper-button-prev',
	            nextButton:'.lunSwipet .swiper-button-next',
	            effect: 'coverflow',
	            grabCursor: true,
	            centeredSlides: true,
	            slidesPerView: 'auto',
	            loop: true,
	            coverflow: {
	                rotate: 10,
	                stretch: 0,
	                depth: 100,
	                modifier: 1,
	                slideShadows: true
	            }
	        });
	    	
			/* $('#epiClock').epiclock({
				format : ' Y-F-j　G:i:s'
			}); //绑定
			$.epiclock(); //开始运行 */
	
			selectModel();
	    });
	    
	    function loadArea(){
    		var userProvince = '${user.userProvince}';
       	 	var userCity = '${user.userCity}';
			var loc = new Location();
			var area = loc.find('0,' + userProvince.split(",")[0]);
            var ulHtml = '';
            $.each(area , function(k , v) {
                if(k == userCity.split(",")[0]){
                	ulHtml += '<li data-option="'+v+'">'+v+'</li>';
                }
   			});
            area = loc.find('0,' + userProvince.split(",")[0] + ',' + userCity.split(",")[0]);
   			$.each(area , function(k , v) {
                ulHtml += '<li data-option="'+v+'">'+v+'</li>';
   			});
            $('#areaUl').html(ulHtml);
    	}
	</script>
  
	<style type="text/css">
		.shouyhcz {padding: 30px 0 10px 0;}
		.shouyhcz li {width: 220px;height: 80px;background-color: #fff;float: left;margin-left: 30px;margin-bottom: 20px;cursor: pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;
		    -webkit-box-shadow: -1px 1px 1px #ccc;
		    -,oz-box-shadow: -1px 1px 1px #ccc;
		    -o-box-shadow: -1px 1px 1px #ccc;
		    box-shadow: -1px 1px 1px #ccc;
		}
		.shouyhcz li img {display:block;width: 52px; float: left;margin-left: 17px;margin-top: 14px;}
		.shouyhcz li span {display: block;float: left;width: 150px;text-align: center;font-size: 24px;height: 52px;line-height: 52px;overflow: hidden;margin-top: 14px;}
		
		.shouylblx {width: 100%;padding: 30px 0;}
		.shouylblx .lblx_main {width: 100%;float: left;} 
		.shouylblx .lblx_body {margin-right: 475px;margin-left: 30px;}
		.shouylblx .lblx_right {width: 470px;margin-left: -470px;float: left;} 
		.shouylblx .lunbo {width: 100%; background-color: #fff;height: 290px;}
		.shouylblx .lianx {width: 420px;background-color: #fff;height: 290px;margin: 0 auto;}
		.shouylblx .tit {font-size: 16px;color: #1b2b44;font-weight: bold;height: 50px;line-height: 50px;background-color: #f7f6f6;overflow: hidden;padding: 0 20px;}
		.shouylblx .ewmphone {width: 350px;margin: 0 auto;margin-top: 20px;font-size: 16px;color: #1b2b44;}
		.shouylblx .ewmphone .ewm {width: 177px;float: left;font-weight: bold;}
		.shouylblx .ewmphone .ewm p {text-align: center;margin-top: 4px;}
		.shouylblx .ewmphone .phone {overflow: hidden;width: 140px;float: right;}
		
		.lunSwipet {padding: 0 50px;position: relative;margin-top: 20px;}
		.lunSwipet .swiper-slide {background-position: center;background-size: cover;width: 740px;height: 200px;}
		.lunSwipet .swiper-button-next, .lunSwipet .swiper-button-prev {width: 16px;height: 60px;background: url(${path}/STATIC/image/xsyicon5.jpg) no-repeat;margin-top: -30px;}
		.lunSwipet .swiper-button-prev {background-position: 0 0;left: 10px;}
		.lunSwipet .swiper-button-next {background-position: -16px 0;right: 10px;}
	</style>
</head>
<body>
	<!-- <div class="site">
		<em>您现在所在的位置：</em>首页
	</div>
	<div class="site-title">当前时间：<span id="epiClock"></span></div> -->

	<%if (whyIndex) {%>
		<script>$("html,body").css("background-color","#edeef2");</script>
		<div id="loadingDiv" style="position:fixed;height:100%;width:100%;left:0;right:0;top:0;bottom:0;margin:auto;display:none;background-color:#EFEFEF;z-index:100;">
			<div style="position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;text-align: center;height: 393px;width: 621px;font-size: 20px;">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173151850293HDYx0a7yMrHKDuPOCgcx97PzdiuWN.gif" />
			</div>
		</div>
		<ul class="shouyhcz clearfix">
			<%if(activityPublishButton){%>
	        	<li style="color: #ff8942;" onclick="location.href='${path}/activity/preAddActivity.do'"><img src="${path}/STATIC/image/xsyicon1.png"><span>新增活动</span></li>
	      	<%}%>
	      	<%if(selectVenueListButton){%>
	        	<li style="color: #c392dc;" onclick="location.href='${path}/venue/venueIndex.do'"><img src="${path}/STATIC/image/xsyicon3.png"><span>场馆管理</span></li>
	      	<%}%>
	      	<%if(activityRoomAddButton){%>
	      		<c:if test="${venue.venueHasRoom == 2}">
	        		<li style="color: #84bae8;" onclick="location.href='${path}/activityRoom/preAddActivityRoom.do?venueId=${venue.venueId}'"><img src="${path}/STATIC/image/xsyicon2.png"><span>新增活动室</span></li>
	        	</c:if>
	      	<%}%>
		</ul>
		<div style="background-color: #fff;font-size: 16px;color: #1b2b44;font-weight: bold;padding: 27px 20px;margin-bottom:20px;">
			截至昨日，
			<c:if test="${userIsManger == 1}">本市（${fn:split(user.userCity, ",")[1]}）活动数据如下：</c:if>
			<c:if test="${userIsManger == 2}">本市（${user.userCity}）活动数据如下：</c:if>
			<c:if test="${userIsManger == 3}">本区（${user.userCounty}）馆均活动发布数<fmt:formatNumber type="number" pattern="0.00" maxFractionDigits="2" value="${averageActivityCount}"/>，数据如下：</c:if>
			<c:if test="${userIsManger == 4}">本区（${user.userCounty}）馆均活动发布数<fmt:formatNumber type="number" pattern="0.00" maxFractionDigits="2" value="${averageActivityCount}"/>，本场馆（${venue.venueName}）活动数据如下：</c:if>
		</div>
		<form id="indexForm" class="form-table" action="" method="post">
			<div class="search">
	        	<div class="td-time" style="margin-top: 0px;float: left;">
	                <div class="start" style="margin-left: 8px;width: 186px;height: 42px;padding:0;">
	                    <input type="text" id="activityCreateTime" name="activityCreateTime" value='' readonly style="width:180px;height: 42px;padding: 0 6px;background:url(${path}/STATIC/image/data-icon1.png) no-repeat 88% 50%;"/>
	                </div>
	            </div>
	            <c:if test="${userIsManger == 1 || userIsManger == 2}">
	            	<div class="select-box w135">
				        <input type="hidden" id="activityArea" name="activityArea" value="${indexStatistics.activityArea}"/>
				        <div id="areaDiv" class="select-text" data-value="">全部区县</div>
				        <ul class="select-option" id="areaUl"></ul>
			        </div>
			        <script>
			        	loadArea();
			        </script>
	            </c:if>
	            <c:if test="${userIsManger == 3}">
	            	<div class="select-box" style="margin-left: 0;width: 250px;">
				        <input type="hidden" id="venueId" name="venueId" value="${indexStatistics.venueId}"/>
				        <div id="venueDiv" class="select-text" data-value="" style="width: 210px;background-position: 230px 19px;text-align: center;">全部场馆</div>
				        <ul class="select-option" id="venueUl" style="width: 250px;">
				        	<c:forEach items="${venueList}" var="dom" varStatus="i">
				        		<li data-option="${dom.venueId}">${dom.venueName}</li>
				        	</c:forEach>
				        </ul>
			        </div>
	            </c:if>
	            <div class="select-btn">
		            <input type="button" onclick="$('#loadingDiv').show();$('#indexForm').submit();" value="搜索"/>
		        </div>
	        </div>
	    </form>
	    <div class="main-content" style="min-height: 300px;">
	        <table width="100%">
	            <thead>
	            <tr>
	            	<th width="50">NO</th>
	            	<th width="200">
		            	<c:choose>
		            		<c:when test="${userIsManger == 1 || userIsManger == 2}">区县</c:when>
		            		<c:otherwise>场馆</c:otherwise>
		            	</c:choose>
	            	</th>
	            	<th width="140">活动发布数</th>
	            	<c:if test="${userIsManger == 1 || userIsManger == 2}"><th width="140">馆均活动发布数</th></c:if>
	            	<th width="140">可预约活动数</th>
	            	<th width="140">可预约活动比例</th>
	            	<th width="140">可预约活动室数</th>
	            </tr>
	            </thead>
	            <tbody>
		            <c:forEach items="${list}" var="dom" varStatus="i">
		                <tr>
		                	<td>${i.index+1}</td>
		                    <td>
								<c:choose>
				            		<c:when test="${userIsManger == 1 || userIsManger == 2}">${fn:split(dom.activityArea, ",")[1]}</c:when>
				            		<c:otherwise>${dom.venueName}</c:otherwise>
				            	</c:choose>
							</td>
		                    <td>${dom.activityCount}</td>
		                    <c:if test="${userIsManger == 1 || userIsManger == 2}"><td><fmt:formatNumber type="number" pattern="0.00" maxFractionDigits="2" value="${dom.averageActivityCount}"/></td></c:if>
		                    <td>${dom.reserveActivityCount}</td>
		                    <td><fmt:formatNumber type="number" pattern="0.00" maxFractionDigits="2" value="${dom.reserveActivityProportion*100}"/>%</td>
		                    <td>${dom.reserveActivityRoomCount}</td>
		                </tr>
		            </c:forEach>
		            <c:if test="${empty list}">
		                <tr>
		                    <td colspan="7"><h4 style="color:#DC590C">暂无数据!</h4></td>
		                </tr>
		            </c:if>
		    	</tbody>
	    	</table>
	    </div>
		<div class="shouylblx clearfix">
		    <div class="lblx_main">
		        <div class="lblx_body">
		            <div class="lunbo">
		                <div class="tit">市民意见反馈告示区</div>
		                <div class="lunSwipet">
		                    <div class="swiper-container">
		                        <div class="swiper-wrapper">
		                        	<div class="swiper-slide" style="background-image:url(http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017314211754kDQL7wRVzbV3YoEscoYaLnF3NoKcrC.jpg)"></div>
		                            <div class="swiper-slide" style="background-image:url(http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173142117393NsWn9HY3KhEIqVAiF0hoYm4ZxQ7K6.jpg)"></div>
		                            <div class="swiper-slide" style="background-image:url(http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017314211725r8TysRvMcl5NypTvuMxThZMuL5IgHi.jpg)"></div>
		                        </div>
		                    </div>
		                    <div class="swiper-button-prev"></div>
		                    <div class="swiper-button-next"></div>
		                </div>
		
		            </div>
		        </div>
		    </div>
		    <div class="lblx_right">
		        <div class="lianx">
		            <div class="tit">联系我们</div>
		            <div class="ewmphone clearfix">
		                <div class="ewm"><img src="${path}/STATIC/image/xsyicon6.jpg" width="177" height="177"><p>文化云公众号</p></div>
		                <div class="phone">
		                    <p style="margin-top:70px;">联系电话：</p>
		                    <p style="font-weight: bold;margin-top:20px;">400-018-2346</p>
		                </div>
		            </div>
		        </div>
		    </div>
		</div>
	<%}else{%>
		<div style="padding: 250px;">
			<img src="http://oss-cn-hangzhou.aliyuncs.com/culturecloud/H5/20161027110185haCFaygL8LPpzyyjrEs9EEwjDdmZ9.jpg" alt="" />
		</div>
	<%}%>
</body>
</html>