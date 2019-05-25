<%@ page import="org.apache.commons.lang3.StringUtils ,com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
	String userId = "";
	if (session.getAttribute("terminalUser") != null) {
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		userId = terminalUser.getUserId();
		if (StringUtils.isNotBlank(terminalUser.getUserId())) {
			userId = terminalUser.getUserId();
		} else {
			userId = "";
		}
	}
%>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<title>志愿服务</title>
<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp" %>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bzStyle.css">
<script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/cutimg.js"></script>
<!-- <style type="text/css">
	html, body {background-color: #fafafa;}
</style> -->
	<style>
		.beVolunteer{
			width:100%;
			height:50px;
			text-align: center;
			margin:0 auto;
			line-height:50px;
		}
		.beVolunteer a{
             border:1px solid #0c80fe;
			 padding:10px 30px;
			 background-color: #00a0e9;
			border-radius: 5%;
			color:#fff;
		}
	</style>
<script>
$(function () {
    $("#volunteerRecruitIndex").addClass('cur').siblings().removeClass('cur');
	$("#toBeVolunteer").click(function(){
		var userId=$("#userId").val();
		if(userId==""){
            dialogAlert(
                "提示信息",
                "请登录后再进行注册！",
				function () {
                    //登录
                    window.location.href="${path}/frontTerminalUser/userLogin.do";
                }
            );
		}else{
			//注册志愿者
			window.location.href="${path}/newVolunteerActivity/signVolunteer.do";
			//$("#toMyVolunteer").attr("href","${path}/newVolunteerActivity/signVolunteer.do");
		}
	});
    $("#toMyVolunteer").click(function(){
        var userId=$("#userId").val();
        if (userId==""){
            dialogAlert(
                "提示信息",
                "请登录后再进行查询！",
                function () {
                    //登录
                    window.location.href="${path}/frontTerminalUser/userLogin.do";
                }
            );
		}else {
            //根据用户id进行查询
            $.post("${path}/newVolunteer/queryNewVolunteerListByUserId.do?userId="+userId,function (data) {
                var str=""
                if(data.length==0){
                    dialogAlert(
                        "提示信息",
                        "您还不是志愿者"
                    );
                    return;
                }
                for(var i=0;i<data.length;i++){
                    if(i!=data.length-1){
                        str+=data[i].uuid+","
                    }else{
                        str+=data[i].uuid
                    }
                }
                window.location.href="${path}/newVolunteerActivity/queryVolunteerActivityByRelation.do?volunteerIds="+str;

            });
		}
	})

	/*$.post("${path}/newVolunteerActivity/queryNewVolunteerActivityListJson.do",{volunteerActivity:"",page:1}, function (data) {
       console.log(data);
	}, "json");*/
    $("#volunteerListDivChild").load("${path}/newVolunteerActivity/queryNewVolunteerActivityList.do #activityNewUl",{volunteerActivity:"",page:1}, function(data) {

    });

});
/*function setScreen(){
    var $content = $("#volun-content");
    if($content.length > 0) {
        $content.removeAttr("style");
        var contentH = $content.outerHeight();
        var otherH = $("#header").outerHeight() + $("#in-footer").outerHeight();
        var screenConH = $(window).height() - otherH;
        if (contentH < screenConH) {
            $content.css({"height": screenConH});
        }
    }
}*/
function toVolunteerDetail(recruitId,recruitName){
	window.location.href="${path}/volunteer/toVolunteerDetail.do?recruitId="+recruitId+"&recruitName="+encodeURI(encodeURI(recruitName));
}
</script>
</head>
<body>
<div class="hpMain">
	<div class="header">
	   <!-- 导入头部文件 -->
	<%@include file="/WEB-INF/why/index/header.jsp" %>
	</div>
	<input type="hidden" id="userId" value="<%=userId%>"/>
	<div id="volun-content">
	<!-- start 标题 -->
	<div class="hpAllLanTitle" style="background-image: url(${path}/STATIC/image/child/hp_bgVolunteers.jpg);">
		<div class="jzCenter"><img src="${path}/STATIC/image/child/hp_tVolunteers.png" /></div>
	</div>
	<!-- end 标题 -->

	<!-- start 列表 -->
	<div class="volunteerListWc">
		<div class="beVolunteer">
			<a id="toBeVolunteer" >注册志愿者</a>
			<a id="toMyVolunteer">我的志愿活动</a>
		</div>
		<div class="volunteerBan"><img src="${path}/STATIC/image/child/hp_volunteerBan.jpg" /></div>
		<%--<ul class="volunteerList clearfix" id="volunteerRecruitList">
		</ul>--%>

		<div id="hot_list">
			<div class="ul_list" id="volunteerListDivChild">
				<ul class="hl_list clearfix">
                    <%--<li>
						<a href="${path}/newVolunteerActivity/queryNewVolunteerActivityById.do?uuid=">
							<div class="pic">
								<img src="" alt="" width="285" height="190">
							</div>
							<div class="char" style="height:auto">
								<div class="titEr"></div>
								<div class="wenYi">地点：</div>
								<div class="wenYi">时间：

								</div>
							</div>
						</a>
					</li>--%>
				</ul>
			</div>
		</div>
	</div>
	<!-- end 列表 -->
	</div>
	<!-- 导入尾部文件 -->
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
</body>
</html>