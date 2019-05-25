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
<div class="ptHeadLogSear">
	<div class="jzCenter clearfix">
		<h1 class="logo fl">

			<a href="${path}/bpFrontIndex/index.do"><img src="${path}/STATIC/image/logoAk.png" alt="" /></a></h1>

		<form action="" method="get" name="searchForm">
			<div class="headSearDiv fl clearfix">
				<dl class="selDiv">
					<dt>活动</dt>
					<dd style="display: none;">
						<a class="cur" href="javascript:;" data-val="活动" id="activityA">活动</a>
						<a href="javascript:;" class="" data-val="场馆" id="venueA">场馆</a>
					</dd>
				</dl>
				<input class="stxt" type="text" placeholder="查找你感兴趣的内容" id="searchVal">
				<input type="hidden" id="queryType" class="sim-select-val" value="活动"/>
				<input type="button" id="globalSearchBtn" class="sbtn">
				<!-- <button class="sbtn"></button> -->
			</div>
		</form>
		<c:choose>
			<c:when test="${empty sessionScope.terminalUser}">
				<!-- 登录前  -->
				<div class="dlzcCenter fr">
					<a class="dl" href="${path}/frontTerminalUser/userLogin.do">登 录</a>
					<a>|</a>
					<a class="zc" href="${path}/frontTerminalUser/userRegister.do">注 册</a>
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
		<%--<li class="cur"><a href="${path}/bpFrontIndex/index.do">首 页qqq</a></li>--%>
		<%--<li id="chuanzhouIndex"><a href="${path}/beipiaoInfo/czfrontindex.do?module=WHZX">文化资讯</a></li>--%>
		<%--<li id="webBookIndex"><a href="${path}/beipiaoInfo/list.do">网上书房</a></li>--%>
		<%--<li id="venueLi"><a href="${path}/frontVenue/venueList.do">文化场馆</a></li>--%>
		<%--<li id="activityLi"><a href="${path}/frontActivity/activityList.do">文化活动</a></li>--%>
		<%--<li id="cmsTrain"><a href="/cmsTrain/cmsTrainIndex.do">文化培训</a></li>--%>
		<%--&lt;%&ndash;<li id="leagueIndex"><a href="${path}/league/leagueIndex.do">文化联盟</a></li>&ndash;%&gt;--%>
		<%--<li id="toAssnList"><a href="${path}/frontAssn/toAssnList.do">文化社团</a></li>--%>
		<%--<li id="volunteerRecruitIndex"><a href="${path}/volunteer/volunteerRecruitIndex.do">文化志愿者</a></li>--%>
		<%--<li id="ysjs"><a href="${path}/beipiaoInfo/czfrontindex.do?module=YSJS">艺术鉴赏</a></li>--%>
		<%--<li id="wenhuayichan"><a href="${path}/beipiaoInfo/chuanzhouList.do?parentTagCode=wenhuayichan">文化遗产</a></li>--%>
		<%--<li id="cultureMapIndex"><a href="${path}/cultureMap/cultureMapList.do">文化地图</a></li>--%>
		<%--<li><a target="_blank" href="http://www.suqian.gov.cn/">网上安康</a></li>--%>
		<%--<li id="cultureMapIndex"><a href="${path}/cultureMap/cultureMapList.do">文化日历</a></li>--%>
		<%--<li id="ysjs" style="width:160px;"><a href="###">全民艺术普及培训</a></li>--%>
		<%--<li id="culturalOrderIndex"><a href="${path}/culturalOrder/culturalOrderIndex.do">文化点单</a></li>--%>
		<%--<li id="resourceIndex"><a href="${path}/frontResource/resourceIndex.do">资源库</a></li>--%>
		<%--<li id="volunteerRecruitIndex"><a href="${path}/volunteer/volunteerRecruitIndex.do">文化志愿者</a></li>--%>
		<%--<li id="resourceIndex"><a target="_blank" href="">网上书房</a></li>--%>
		<%--3.21--%>
		<li class="cur"><a href="${path}/bpFrontIndex/index.do">首 页</a></li>
		<li id="chuanzhouIndex"><a href="${path}/beipiaoInfo/czfrontindex.do?module=WHZX">文化资讯</a></li>
		<li id="webBookIndex"><a href="${path}/zxInformation/zxfrontindex.do?module=1c75e1bef46547178b1191b68798e8f6">网上书房</a></li>
		<li id="rwsq"><a href="${path}/beipiaoInfo/chuanzhouList.do?parentTagCode=wenhualvyou">人文安康</a></li>
		<li id="venueLi"><a href="${path}/frontVenue/venueList.do">文化空间</a></li>
		<li id="activityLi"><a href="${path}/frontActivity/activityList.do">文化活动</a></li>
		<li id="whmk"><a href="${path}/cmsTrain/cmsTrainIndex.do">培训讲座</a></li>
		<li id="toAssnList"><a href="${path}/frontAssn/toAssnList.do">文化社团</a></li>
		<li id="whzb"><a href="${path}/zxInformation/zbfrontindex.do?module=80f65566172843a5b450c0d6eaea5bda">文化直播</a></li>
		<li id="volunteerRecruitIndex"><a href="${path}/volunteer/volunteerRecruitIndex.do">文化志愿者</a></li>
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

    $(function(){
        $('.headNavList').on('click', 'li', function () {
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
    /*  end  头部js  */
</script>
