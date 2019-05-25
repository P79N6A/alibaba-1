<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp" %>
<title>${recruitName}_安康公共文化艺术中心</title>
<meta name="description" content="${recruitName}"/>
<script>
var userId = '${sessionScope.terminalUser.userId}';
var recruitId = '${recruitId}';

$(function () {
	$('#volunLi').addClass('cur').siblings().removeClass('cur');
	$.post("${path}/volunteer/getVolunteerDetail.do",{recruitId:recruitId}, function (data) {
		if (data.status == 1) {
			var dom=data.data;
			var recruitName = dom.recruitName;
			var recruitIconUrl=getImgUrl(dom.recruitIconUrl);
			// 招募条件
			var recruitCondition=dom.recruitCondition;
			// 消费者权益
			var recruitInterest= dom.recruitInterest;
			// 团队介绍
			var teamIntroduce= dom.teamIntroduce;
			var otherCondition = "";
			if (dom.ageRequirement){
				otherCondition += "<li><label>年龄限制</label><span>"+dom.ageRequirement+"</span></li>";
			}
			if (dom.educationRequirement){
				otherCondition += "<li><label>学历限制</label><span>"+dom.educationRequirement+"</span></li>";
			}
			$("#otherCondition").append(otherCondition);
			$('#position').append(recruitName);
			$("#recruitName").html(recruitName);
			$("#recruitIconUrl").attr("src",recruitIconUrl);
			$("#recruitCondition").html(recruitCondition);
			$("#recruitInterest").html(recruitInterest);
			$("#teamIntroduce").html(teamIntroduce);
			
		}
	}, "json");
	/* $.post("${path}/volunteer/getVolunteerDetailCode.do",{recruitId:recruitId}, function (data) {
		$("#qrCode").attr("src",data);
	}, "json"); */
	
});
function voluJoin(){
	if (userId == null || userId == "") {
    	dialogAlert("提示", '登录之后才能报名', function () {
        		
        	});
        return;
    }else{
    	location.href="${path}/volunteer/toVoluJoin.do?recruitId="+recruitId;
    }
}
</script>
</head>
<body>
<div class="hpMain">
	<div class="header">
	   <!-- 导入头部文件 -->
	<%@include file="/WEB-INF/why/index/header.jsp" %>
	</div>
	<input type="hidden" id="recruitId" value="${recruitId}"/>
	<!-- start 详情 -->
	<div class="detailMain">
		<div class="breadNavHp" id="position">所在位置：志愿者招募&emsp;&gt;&emsp;</div>
		<div class="disDetailTopBox clearfix">
			<div class="pic"><img src="" id="recruitIconUrl" width="355" height="260"/></div>
			<div class="char">
				<div class="title" id="recruitName"></div>
				<div class="mhActNameInfo">
					<ul id="otherCondition">
					</ul>
				</div>
				<div class="xuxian"></div>
				<a class="totalBtn" onclick="voluJoin()">我要报名</a>
			</div>
		</div>
		<div class="disDetailContent">
			<div class="detailTit">志愿者详情</div>
			<div class="detailNeir">
				<div class="zhiyzDetLie">
					<div class="zyzTit">招募条件<em></em></div>
					<p id="recruitCondition">
					</p>
				</div>
				<div class="zhiyzDetLie">
					<div class="zyzTit">志愿者权益<em></em></div>
					<p id="recruitInterest">
					</p>
				</div>
				<div class="zhiyzDetLie">
					<div class="zyzTit">团队简介<em></em></div>
					<p id="teamIntroduce">
					</p>
				</div>
			</div>
		</div>
	</div>
	<!-- end 详情 -->

	
	<!-- 导入尾部文件 -->
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
</body>
</html>