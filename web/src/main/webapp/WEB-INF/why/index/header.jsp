<%@ page language="java" pageEncoding="UTF-8" %>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/styleChild.css"/>
<style>
	.headNavList li{
		margin:0 20px;
		display:inline-block;
	}
</style>
<!-- start 头部  -->
	<div style="height: 30px;line-height: 30px;overflow: hidden;background-color: #f3f3f3;font-size: 12px;color: #333;display:none">
		<div class="jzCenter">hi<c:if test="${not empty sessionScope.terminalUser}">，${sessionScope.terminalUser.userName}</c:if>，欢迎来到安康文化云
		</div>
	</div>
<div  id="pageHeader" style="display: inline-block;margin-left:250px;padding:5px;font-size: 12px"></div>
<div style="display: inline-block;float:right;margin-right:200px;padding:5px;font-size: 12px">您好，欢迎进入安康文化云，享受更多文化服务</div>
	<div class="ptHeadLogSear">
		<div class="jzCenter clearfix">
			<h1 class="logo fl">
                <%--${path}/STATIC/image/logo-sq.png--%>
				<div style="height:100px">
				     <a href="${path}/bpFrontIndex/index.do"><img src="${path}/STATIC/image/logoAk.png" alt="" /></a>
				</div>	<%--<p style="display:inline-block">[安康]</p>--%>
			</h1>

				<form action="" method="get" name="searchForm">
					<div class="headSearDiv fl clearfix">
						<dl class="selDiv">
							<dt>全部</dt>
							<dd style="display: none;">
								<a class="cur" href="javascript:;" data-val="全部" id="all">全部</a>
								<a href="javascript:;" data-val="活动" id="activityA">活动</a>
								<a href="javascript:;" class="" data-val="场馆" id="venueA">场馆</a>
							</dd>
						</dl>
						<input class="stxt" type="text" placeholder="查找你感兴趣的内容" id="searchVal">
						<input type="hidden" id="queryType" class="sim-select-val" value="活动"/>
						<input type="button" id="globalSearchBtn" class="sbtn" value="搜索">
						<!-- <button class="sbtn"></button> -->
					</div>

				</form>
			<%--<div class="dlzcCenter fr">
				<a class="dl" href=""><img src="${path}/STATIC/image/help.png"/>帮助</a>
			</div>--%>
				<c:choose>
					<c:when test="${empty sessionScope.terminalUser}">
						<!-- 登录前  -->
						<div class="dlzcCenter fr">
							<a class="dl" href="${path}/frontTerminalUser/userLogin.do">登 录</a>
							<a>|</a>
							<a class="zc" href="${path}/frontTerminalUser/userRegister.do">注 册</a>
							<a class="dl" style="width: 100px;" href=""><img src="${path}/STATIC/image/help.png"/>帮助</a>
						</div>
					</c:when>
					<c:otherwise>
						<!-- 登录后  -->
						<div class="dlzcCenter fr">
							<a class="dl" href="${path}/frontTerminalUser/userInfo.do"><img style="display: inline-block;vertical-align: middle;" src="${path}/STATIC/image/child/fs_tbzx.png" />个人中心</a>
							<a>|</a>
							<a class="zc" href="javascript:;" onclick="outLogin()">退 出</a>
								<%-- <a href="${path}/userActivity/userActivity.do" class="a_two">我的订单</a> --%>
						</div>
					</c:otherwise>
				</c:choose>

		</div>
	</div>
	<div class="headNavListWc">
		<ul class="headNavList clearfix" id="headNavList">
			<li class="cur"><a href="${path}/frontIndex/index.do">首 页</a></li>
			<li id="activityLi">
				<a href="javascript:void(0);">文化服务</a>
				<ul<%-- style="display: none"--%>>
					<li><a style="font-weight:normal;border-bottom:1px solid #ccc " href="${path}/frontActivity/activityList.do">文化活动</a></li>
					<li><a style="font-weight:normal;border-bottom:1px solid #ccc " href="${path}/cmsTrain/cmsTrainIndex.do">培训讲座</a></li>
				</ul>
			</li>
			<li id="lyfw"><a href="${path}/zxInformation/zbfrontindex.do?module=ce9dd09433474f9d8ec9eccfb3e97962">旅游服务</a></li>
			<li id="venueLi"><a href="${path}/frontVenue/venueList.do">文化空间</a></li>
			<li id="whzb"><a href="${path}/zxInformation/zbfrontindex.do?module=932e4be2fd3f42d3847ef71e9f2c34f1">文化直播</a></li>
			<li id="toAssnList"><a href="${path}/frontAssn/toAssnList.do">文化社团</a></li>


			<li id="szzg">
				<a href="javascript:void(0);">数字展馆</a>
				<ul<%-- style="display: none"--%>>
					<li><a style="font-weight:normal;border-bottom:1px solid #ccc" href="${path}/zxInformation/zbfrontindex.do?module=afa6dfe23a9745afa749f89e1f5b9b8a">数字文化场馆</a></li>
					<li><a style="font-weight:normal;border-bottom:1px solid #ccc" href="${path}/zxInformation/zbfrontindex.do?module=12df5837827741c1a53424ceffbaeada">数字文化资源</a></li>
				</ul>
			</li>

			<%--<li id="cultureMapIndex"><a href="${path}/cultureMap/cultureMapList.do">文化地图</a></li>--%>
			<%--<li id="calendarIndex"><a href="${path}/cultureMap/calendar.do">文化日历</a></li>--%>
			<%--<li id="whmk"><a href="${path}/cmsTrain/cmsTrainIndex.do">培训讲座</a></li>--%>
			<li id="volunteerRecruitIndex"><a href="${path}/volunteer/volunteerRecruitIndex.do">志愿服务</a></li>
			<li id="wlzx"><a href="${path}/zxInformation/zbfrontindex.do?module=767707e242a8486da7089b62ea4921d9">文旅资讯</a></li>
			<%--<li id="rwsq"><a href="${path}/zxInformation/zbfrontindex.do?module=394ff76fdf39443991f03c1a4a81b6d3">人文安康</a></li>--%>

			<%--<li id="文化非遗"><a href="${path}/zxInformation/zbfrontindex.do?module=75744595d509401c80564ce63d3fc12a">文化非遗</a></li>--%>

            <li id="ours"><a href="javascript:void(0);">关于我们</a></li>
		</ul>
	</div>
<!-- end 头部  -->


<script type="text/javascript">
/*  start  头部js  */
function setStopPropagation(evt) {
    var e = evt || window.event;
    if(typeof e.stopPropagation == 'function') {
        e.stopPropagation();
    } else {
        e.cancelBubble = true;
    }
}


$('.selDiv dt').bind('click', function () {
	$(this).parent('.selDiv').find('dd').toggle();
});
$('.selDiv dd').on('click', 'a', function () {
	$(this).parent('dd').find('a').removeClass('cur');
	$(this).addClass('cur');
	$(this).parents('.selDiv').find('dt').html($(this).html());
	$(this).parent('dd').hide();
	var selVal = $(this).attr("data-val");
	$("#queryType").val(selVal);
});
$('html,body').bind('click', function () {
	$('.selDiv dd').hide();
})
$('.selDiv').bind('click', function (evt) {
	setStopPropagation(evt)
});
function formatTime(time){
    var y = time.getFullYear();
    var m = time.getMonth()+1;
    if(m<10){
        m="0"+m;
    }
    var d = time.getDate();
    if(d<10){
        d="0"+d;
    }
    var week=time.getDay();
    var str=""
    switch (week) {
        case 0 :
            str += "（周日）";
            break;
        case 1 :
            str += "（周一）";
            break;
        case 2 :
            str += "（周二）";
            break;
        case 3 :
            str += "（周三）";
            break;
        case 4 :
            str += "（周四）";
            break;
        case 5 :
            str += "（周五）";
            break;
        case 6 :
            str += "（周六）";
            break;
    }
    time = y + "-" + m + "-" + d+"  "+str;
    return time;
}

$(function(){
    getWeather();

	$('.headNavList li').on('click',function () {
	      var thisId=$(this).attr("id");
	      if(thisId=="activityLi"||thisId=="szzg"){
               return;
		  }
	      $(this).addClass('cur').siblings().removeClass('cur')
	    });
	
	 $("#globalSearchBtn").on("click", function () {
         var queryType = $("#queryType").val();
         var searchVal = $("#searchVal").val();
         if (queryType == "场馆") {
             searchTopVenueList(searchVal);
         } else {
             searchTopActivityList(searchVal);
         }
     });
	 $('#searchVal').keydown(function (event) {
         if (event.keyCode == 13) {
             $("#globalSearchBtn").trigger("click");
             event.preventDefault();
         }
     })
	 function searchTopVenueList(venueName) {
         window.location.href = "${path}/frontVenue/venueList.do?keyword=" + encodeURI(venueName);
     }
     function searchTopActivityList(activityName) {
         window.location.href = "${path}/frontActivity/activityList.do?activityName=" + encodeURI(activityName);
     }
});
function getWeather(){
    $.ajax({
        url:'http://wthrcdn.etouch.cn/weather_mini?city=安康',
        data:"",
        dataType:"jsonp",
        success:function(data){
            var resToday=data.data.forecast[0];
            var low=resToday.low.substring(3,6);
			var high=resToday.high.substring(3,6);
			var wd=low+"~"+high+"&nbsp"+resToday.type;
            var now = new Date();
            var thisDay=formatTime(now);
            var pageHeader=thisDay+"&nbsp&nbsp 安康"+"&nbsp&nbsp"+wd;
            $("#pageHeader").html(pageHeader)
        }
    })
}
/*  end  头部js  */
</script>
