<%@ page import="com.sun3d.why.util.PropertiesReadUtils" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	request.setAttribute("basePath", basePath);
	String staticurl = PropertiesReadUtils.getInstance().getPropValueByKey("staticServerUrl","http://127.0.0.1:8080/") ;
%>
<!DOCTYPE html>
<input type="hidden" name="staticImgServerUrl" id="staticImgServerUrl" value="<%=staticurl%>">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<title>安康文化云首页</title>
	<link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon"
		  mce_href="${path}/STATIC/image/favicon.ico">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
	<%-- <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/styleChild.css"/> --%>
	<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/swiper.min.css"/>
	<link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<%-- <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.min.js"></script> --%>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery-1.9.0.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/swiper.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.SuperSlide.2.1.1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/owl.carousel.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/qiehuan.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
	<%-- <script type="text/javascript" src="${path}/STATIC/js/index/index/index.js?version=20160507"></script> --%>
	<script src="http://webapi.amap.com/maps?v=1.3&key=a5b9a436f67422826aef2f4cb7e36910&plugin=AMap.AdvancedInfoWindow"></script>
	<style type="text/css">
		html, body {background-color: #fff;/*b/*ackground: url("${path}/STATIC/image/bg.png")*/}
		.bgDiv{
			background-color: #fff;
			width: 100%;
			background: url(${path}/STATIC/image/bg.png) no-repeat center;
			background-size: 100% 100%;
		}
		.swiper-container-horizontal>.swiper-pagination-bullets, .swiper-pagination-custom, .swiper-pagination-fraction{
			bottom: 40px;
			left: 250px;
		}
		.swiper-pagination-bullet-active {
			opacity: 1;
			width: 16px;
			background: #36c7de;
			border-radius: 30%;
		}
	</style>
</head>
<body>
<div class="fsMain">
	<!-- 导入头部文件  start 头部 -->
	<%@include file="../header.jsp" %>
	<!-- end 头部  -->

	<!-- start banner -->
	<%--<div class="bannerWc" style="background-image: url(${path}/STATIC/image/child/fs_banBg1.jpg);">--%>
	<div class="slideBox">
		<img src="${path}/STATIC/image/newBanner.png"/>
	</div>
	<%--</div>--%>
	<!-- end banner -->

	<!-- start 动态资讯 -->

		<div class="biaoTopWrap clearfix">
			<div class="titZong fl"></div>
			<a class="more fr" href="${path}/zxInformation/zbfrontindex.do?module=767707e242a8486da7089b62ea4921d9">更多</a>
		</div>
		<div class="syListWcAll" id="tuijianInfo">
		</div>

	<!-- end 动态资讯 -->
	<a href="${path}/zxInformation/zbfrontindex.do?module=ced4b1ebcd524da8b81c2a87968d2013">
		<div class="createDiv" style="position:relative;margin:auto;margin-bottom:20px;width:1200px;height:150px;">
		</div>
	</a>



	<!-- start 文化空间 -->
	<div style="width: 100%;background: url('${path}/STATIC/image/child/whIndexBj.png') no-repeat;background-size: 100% 100%;">
		<div class="biaoTopWrap clearfix">
			<div class="titZongAll whkj fl"></div>
			<a class="more fr" href="${path}/frontVenue/venueList.do">更多</a>

		</div>

		<div class="syMapVenCont">
			<div class="syListWcAll contNeic" id="tuijianVenues"></div>
			<%--<div class="cultureMap contNeic" id="cultureMap" style="height: 560px;display:none;"></div>--%>

		</div>
	</div>
	<!-- end 文化空间 -->

	<!-- end 文化地图 -->
	<%--<div class="bgDiv">
	<div class="biaoTopWrap clearfix">
		<div class="titZong fl">文化地图&lt;%&ndash;<img class="iconTitle" src="${path}/STATIC/image/3.png">&ndash;%&gt;</div>
	</div>
	&lt;%&ndash;<ul class="filterTypeUl clearfix " id="tagList">
		<li class="cur" venueType="">全部</li>
	</ul>&ndash;%&gt;
	<div class="syMapVenCont" style="margin-bottom: 66px">
		<div class="cultureMap contNeic" id="cultureMap" style="height: 560px; border:1px solid #e5e5e5;">
			<div class="mapSear clearfix">
				<input class="txt" type="text" id="venueName" name="venueName" placeholder="请输入场馆名称" />
				<span class="close" onclick="$(this).siblings('.txt').val('');"></span>
				<span class="ssBtn" onclick="loadData()"></span>
			</div>
		</div>
	</div>
	</div>--%>

	<!-- end 文化地图 -->

	<!-- start 文化服务 -->

		<div class="biaoTopWrap clearfix" >
			<div class="titZongAll whfw fl"></div>
			<a class="more fr" href="${path}/frontActivity/activityList.do">更多</a>

		</div>
		<div class="syListWcAll" id="activityNew">
		</div>


	<!-- end 文化服务 -->


	<!-- start 培训讲座 -->
	<div style="width: 100%;margin-bottom:30px;background: url('${path}/STATIC/image/child/whIndexJz.png') no-repeat;background-size: 100% 100%;">
		<div class="biaoTopWrap clearfix" >
			<div class="titZongAll pxjz fl"></div>
			<a class="more fr" href="${path}/cmsTrain/cmsTrainIndex.do">更多</a>

		</div>
		<div class="syListWcAll" id="trainNew">
		</div>
	</div>

	<!-- start 特色活动 -->
	<%--<div class="biaoTopWrap clearfix">--%>
	<%--<div class="titZong fl">文化活动<img class="iconTitle" src="${path}/STATIC/image/4.png"></div>--%>
	<%--<a class="more fr" href="${path}/frontActivity/activityList.do">更多&nbsp;&gt;&gt;</a>--%>
	<%--<a class="more fr" href="${path}/frontVenue/venueList.do">更多<img class="moreIcon" src="${path}/STATIC/image/icon2.png"></a>--%>

	<%--</div>--%>
	<%--<div class="syListWcAll" id="tuijianActivity">--%>
	<%--</div>--%>
	<!-- end 特色活动 -->

	<%@include file="/WEB-INF/why/index/footer.jsp" %>

	<!-- start 右侧 -->
	<%--<div class="fs-rightNav">
		<a class="wechat" href="javascript:;">
			<span>微信<br>公众号</span>
			<div class="ewm"><img src="${path}/STATIC/image/child/fs_ewm.jpg" /></div>
		</a>
		<a href="${path}/beipiaoInfo/czfrontindex.do?module=WHZX"><span>文化<br>资讯</span></a>
		&lt;%&ndash;<a href="${path}/zxInformation/zxfrontindex.do?module=1c75e1bef46547178b1191b68798e8f6"><span>网上<br>书房</span></a>&ndash;%&gt;
		<a href="${path}/beipiaoInfo/chuanzhouList.do?parentTagCode=wenhualvyou"><span>人文<br>安康</span></a>
		<a href="${path}/frontVenue/venueList.do"><span>文化<br>场馆</span></a>
		<a href="${path}/frontActivity/activityList.do"><span>文化<br>活动</span></a>
		<a href="${path}/cmsTrain/cmsTrainIndex.do"><span>文化<br>慕课</span></a>
		<a href="${path}/frontAssn/toAssnList.do"><span>文化<br>社团</span></a>
		<a href="${path}/zxInformation/zbfrontindex.do?module=80f65566172843a5b450c0d6eaea5bda"><span>文化<br>直播</span></a>
		<a href="${path}/volunteer/volunteerRecruitIndex.do"><span>文化<br>志愿者</span></a>

&lt;%&ndash;		<a href="${path}/cultureMap/cultureMapList.do"><span>文化<br>地图</span></a>
		<a href="${path}/beipiaoInfo/czfrontindex.do?module=YSJS"><span>艺术<br>鉴赏</span></a>
		<a href="${path}/beipiaoInfo/chuanzhouList.do?parentTagCode=wenhuayichan"><span>文化<br>非遗</span></a>
	    <a href="${path}/league/leagueIndex.do"><span>文化<br>联盟</span></a>
		<a href="${path}/culturalOrder/culturalOrderIndex.do"><span>文化<br>点单</span></a>&ndash;%&gt;
		<a class="top" href="javascript:;"><span>回到<br>顶部</span></a>
	</div>--%>
	<!-- end 右侧 -->
</div>

</body>
<script type="text/javascript">

    $(function () {
        /* $.ajaxSetup({
            async: false
          }); */
        //显示轮播图
        //showAdvertPicture();
        //获取活动搜索类型
        getActivitySearchType()
        //最新活动
        loadpcnewActivityIndex("");
        //最新培训
        loadpcnewTrainIndex();
        //热门场馆推荐
        loadpctuijianVenueIndex();
        //资讯推荐
        loadpctuijianInfoIndex();
        //特色活动推荐
        loadpctuijianActivityIndex();
        //获取分类搜索条件
        //toLoadTag();
        //点击li添加样式
        $('.filterTypeUl').on('click', 'li', function () {
            $(this).parent().find('li').removeClass('cur');
            $(this).addClass('cur');
            loadData();
        });

    })
    // 暂无轮播图
    function showAdvertPicture() {
        $.post("${path}/ccpAdvert/loadAdvertIndex.do?advertPostion=1&advertType=A&version=" + new Date().getTime(), '', function (data) {
            if (data != undefined && data != null && data != "" && data.length > 0) {
                $(".slideBox").html(getAdvertHtml(data));
                jQuery(".slideBox").slide({mainCell:".bd ul",titCell:".hd span", effect:"left",autoPlay:true,interTime: 3500, delayTime:500});
            } else {
            }
        });
    }
    //获取活动搜索类型
    function getActivitySearchType() {
        $.post("${path}/tag/getChildTagByType.do", {code: 'ACTIVITY_TYPE'}, function (data) {
            var activityTypeHtml = "";
            var list = eval(data);

            var arr = new Array("演出","亲子","展览","讲座","公益电影","培训");
            for(var j= 0;j<arr.length;j++){
                for (var i = 0; i < list.length; i++) {
                    var tag = list[i];
                    console.log(tag.tagName+"---"+arr[j]);
                    if(arr[j]==tag.tagName){
                        activityTypeHtml += '<a href="javascript:;" data-val="'+tag.tagId+'">'+tag.tagName+'</a>';
                        break;
                    }
                }
            }
            /* for (var i = 0; i < list.length; i++) {
                var tag = list[i];
                activityTypeHtml += '<a href="javascript:;" data-val="'+tag.tagId+'">'+tag.tagName+'</a>';
            } */
            $("#activitySearchType").append(activityTypeHtml);
            $('.huoNavList').on('click', 'a', function () {
                $(this).addClass('cur').siblings().removeClass('cur');
                loadpcnewActivityIndex($(this).attr("data-val"));
            });
        });
    }
    //最新文化活动
    function loadpcnewActivityIndex(activityType){
        $("#activityNew").load("${path}/bpFrontIndex/pcnewActivityIndex.do #activityNewUl",{activityType:activityType}, function() {
            $("#activityNewUl li").each(function (index, item) {
                var imgUrl = $(this).attr("data-url");
                if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                    $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                } else {
                    $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                }
            });
        });
    }

    //最新培训讲座
    function loadpcnewTrainIndex(){
        $("#trainNew").load("${path}/bpFrontIndex/advertIndex.do.do?type=M #trainNewUl", function() {
            $("#trainNewUl li").each(function (index, item) {
                var imgUrl = $(this).attr("data-url");
                if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                    // $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                    $(item).find("img").attr("src", imgUrl);
                } else {
                    $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                }
            });
        });
    }

    //推荐文化场馆
    function loadpctuijianVenueIndex(){
        $("#tuijianVenues").load("${path}/bpFrontIndex/advertIndex.do?type=D #tuijianVenuesDiv",null, function () {
            $("#tuijianVenuesDiv li").each(function (index, item) {
                var imgUrl = $(this).attr("data-url");
                if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                    $(item).find(".venueImg").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                } else {
                    $(item).find(".venueImg").attr("src", "../STATIC/image/default.jpg");
                }
            });
            var bigImg = $('.daLi').attr("data-url") ;
            $(".tup:first").attr("src", getImgUrl(bigImg));
        });
    }
    //推荐资讯
    function loadpctuijianInfoIndex(){
        $("#tuijianInfo").load("${path}/bpFrontIndex/advertIndex.do?type=K #tuijianInfoUl",null, function () {
            var all_html=$("#newsLeft").html();//轮播体代码
            //jQuery(".newsLeft").slide({autoPlay:true})
            var mySwiper = new Swiper('.swiper-container', {
                pagination : '.swiper-pagination',
                autoplay: 1500,//可选选项，自动滑动
            })
            $('.newsItem').hover(function(){
                $(this).addClass('emphasizeB')
                $(this).find('.newsTitle').addClass('emphasizeF')
                $(this).find('.newNum').addClass('emphasizeF')/*.addClass('emphasizeB')*/
                $(this).find('.newNum span').addClass('emphasizeF')
                var dataurl=$(this).attr("data-url")
                var href=$(this).find('.xiang').attr("href")
                var imgsrc=dataurl
                var value=$(this).find('.newsTitle').text();
                var new_html='<div class="bd">\n' +
                    '<ul class="clearfix" data-url="'+dataurl+'">\n' +'<li>\n' +
                    '<a class="xiang clearfix" href="'+href+'">\n' +
                    '<div class="pic fl"><img class="bigimg" src="'+imgsrc+'"></div>\n' +
                    '<div class="char fl">\n' +
                    '<div class="titEr" style="height:70px;line-height:70px;padding:5px;font-size:20px">'+value
                '</div>\n' +
                '</div>\n' +'</a>\n' +'</li>\n' +'</ul>\n' +'</div>';
                $('.newsLeft').html("")
                $('.newsLeft').append(new_html)
                /*$(".zxTab").click(function(){
                    $(this).addClass("activeTab").siblings().removeClass("activeTab");
                });*/
            })

            $('.newsItem').mouseleave(function(){
                $('.newsLeft').html("")
                $('.newsLeft').append(all_html)
                //jQuery(".newsLeft").slide({autoPlay:true})
                var mySwiper = new Swiper('.swiper-container', {
                    pagination : '.swiper-pagination',
                    autoplay: 1500,//可选选项，自动滑动
                })
                $(this).removeClass("emphasizeB");
                $(this).find('.newNum').removeClass("emphasizeF").removeClass('emphasizeB');
                $(this).find('.newNum span').removeClass("emphasizeF");
                $(this).find('.newsTitle').removeClass("emphasizeF");
            });

        })



    }
    //特色活动推荐
    function loadpctuijianActivityIndex(){
        $("#tuijianActivity").load("${path}/bpFrontIndex/advertIndex.do?type=L #tuijianActivityUl",null, function() {
            $("#tuijianActivityUl li").each(function (index, item) {
                var imgUrl = $(this).attr("data-url");
                if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                    $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                } else {
                    $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                }
            });
        });
    }


    // 拼接轮播图ul下的li
    function getAdvertHtml(data) {
        var htmlimg = "";
        var htmlindex = "";
        htmlimg += "<div class='bd'><ul class='picList' style='height: 500px;'>";
        htmlindex += "<div class='hd'>";
        var imgUrl = '';
        var connectUrl = '';
        for (var i in data) {
            if (data[i].advertState != undefined && data[i].advertState == 1 && data[i].advertImgUrl != "") {
                htmlindex += "<span></span>";
                imgUrl = getIndexImgUrl(getImgUrl(data[i].advertImgUrl), "");
                connectUrl = data[i].advertUrl;
                if ("" == connectUrl || connectUrl.indexOf("http") == -1) {
                    htmlimg += "<li><a><img src='" + getIndexImgUrl(imgUrl,"_1920_500") + "'/></a></li>";
                } else {
                    htmlimg += "<li><a target='_blank' href='" + connectUrl + "'><img src='" + getIndexImgUrl(imgUrl,"_1920_500") + "'/></a></li>";
                }
            }
        }

        htmlimg += "</ul></div>";
        htmlindex += "</div>";
        return htmlimg + htmlindex;
    }

    /* start 文化活动 */
    /* $('.huoNavList').on('click', 'a', function () {
        $(this).addClass('cur').siblings().removeClass('cur');
        loadpcnewActivityIndex($(this).attr("data-val"));
    }); */
    /* end 文化活动 */
    /* start 回到顶部 */
    $('.fs-rightNav .top').on('click', function () {
        $("html,body").animate({scrollTop: 0},800);
    });
    /* end 回到顶部 */

    /* start 文化地图 & 热门场馆 */
    $('.syMapVenTit').on('click', 'a', function () {
        $(this).addClass('cur').siblings().removeClass('cur');
        $('.syMapVenCont .contNeic').hide();
        $('.syMapVenCont .contNeic').eq($(this).index()).show();
        if($(this).index() == 1){
            if(center_dot != null){
                center_dot.emit('click', {target: center_dot});
            }
        }
    })



    /* end 文化地图 & 热门场馆 */
</script>
<script type="text/javascript">
    var infoJson;
    var infoMapWindow;
    var markerObject;
    var infoWindowVerticalOffset;
    var center_dot;
    // 初始化地图
    function initMap() {
        // 初始化地图
        var map = new AMap.Map("cultureMap", {
            // 地图缩放
            zoomEnable: true,
            resizeEnable: false,
            zoom: 15
            // 设置中心点
            // center:[121.438199, 31.284143],
        });

        return map;
    }
    // 地图上添加单个点
    function addMarket(map, pos, zx, id) {
        var marker = new AMap.Marker({
            map: map,
            position: pos,
            extData:id
        });

        if(typeof zx == 'undefined') {
            marker.setContent('<img src="${path}/STATIC/image/child/hp_site.png"/>');
        } else {
            if(zx == 'center') {
                // 是中心点
                marker.setContent('<img src="${path}/STATIC/image/child/hp_sites.png"/>');
                map.setCenter(pos);
            } else {
                // 不是是中心点
                marker.setContent('<img src="${path}/STATIC/image/child/hp_site.png"/>');
            }
        }
        return marker;
    }

    function toLoadTag(){
        $.post("${path}/wechatVenue/venueTagByType.do", function (data) {
            if (data.data.length > 0) {
                $.each(data.data, function (i, dom) {
                    $("#tagList").append('<li venueType='+dom.tagId+'><a href="javascript:;">'+dom.tagName+'</a></li>');
                });
                loadData();
            }
        }, "json");
    }

    // 信息提示窗
    function markerClick(e) {
        var venueId=e.target.getExtData()[0];
        var venueName=e.target.getExtData()[1];
        markerObject = e;
        var aa = '<div class="fs-cultureMapInfo">'+
            '<div class="tit"><span>' +venueName+ '</span><a href="javascript:toVenueDetail(\''+venueId+'\');">场馆详情&nbsp;&gt;&gt;</a></div>' +
            '<div class="culNav clearfix"><span class="cur">相关活动</span><span>场馆预约</span><em></em></div>' +
            '<div class="culContWc">' +
            '<div class="culCont">' +
            '<ul class="culActVenList" id="activityList">';

        var data={
            venueId:venueId,
            pageIndex:0,
            pageNum:2
        }
        var activityDiv = "";
        var venueDiv = "";

        $.ajax({
            type: "post",
            url: "${path}/wechatVenue/venueWcMapActivity.do",
            data: data,
            async: false,
            dataType: "json",
            success: function(data){
                if(data.status==0){
                    if(data.data.length == 2){
                        if(venueName.length >= 16){
                            infoWindowVerticalOffset = 350;
                        }else{
                            infoWindowVerticalOffset = 325;
                        }
                    }else if(data.data.length == 1){
                        if(venueName.length >= 16){
                            infoWindowVerticalOffset = 275;
                        }else{
                            infoWindowVerticalOffset = 250;
                        }
                    }else{
                        if(venueName.length >= 16){
                            infoWindowVerticalOffset = 185;
                        }else{
                            infoWindowVerticalOffset = 160;
                        }
                    }

                    $.each(data.data,function(i,dom){
                        activityDiv=activityDiv+"<li class='clearfix'>"+
                            "<a href='javascript:activityDetail(\""+dom.activityId+"\");'>"+
                            "<div class='pic'><img src='"+dom.activityIconUrl+"'/></div>"+
                            "<div class='char'>"+
                            "<div class='titYi'>"+dom.activityName+"</div>"+
                            "<div class='wenYi'>时间："+dom.activityStartTime+"</div>"+
                            "</div>"+
                            "</a>"+
                            "</li>";

                    });
                }
            }
        });
        $.ajax({
            type: "post",
            url: "${path}/wechatVenue/activityWcRoom.do",
            data: data,
            async: false,
            dataType: "json",
            success: function(data){
                if(data.status==0){
                    $.each(data.data,function(i,dom){
                        venueDiv=venueDiv+"<li class='clearfix'>"+
                            "<a href='javascript:roomDetail(\""+dom.roomId+"\");'>"+
                            "<div class='pic'><img src='"+dom.roomPicUrl+"'/></div>"+
                            "<div class='char'>"+
                            "<div class='titYi'>"+dom.roomName+"</div>"+
                            "<div class='wenYi'>面积："+dom.roomArea+"㎡</div>"+
                            "<div class='wenYi'>容纳："+dom.roomCapacity+"人</div>"+
                            "</div>"+
                            "</a>"+
                            "</li>";

                    });
                }
            }
        });

        aa=aa+activityDiv+'</ul>' +
            '<a class="more" href="javascript:moreActivity(\''+venueId+'\',\''+venueName+'\');">查看更多&nbsp;&gt;&gt;</a>' +
            '</div>';
        infoMapWindow = new AMap.AdvancedInfoWindow({
            offset: new AMap.Pixel(240,infoWindowVerticalOffset)
        });
        infoMapWindow.setContent(aa);
        infoMapWindow.open(culMapInit, e.target.getPosition());
    }

    function showRoomInfo(){
        var venueId = markerObject.target.getExtData()[0];
        var venueName = markerObject.target.getExtData()[1];

        var aa = '<div class="fs-cultureMapInfo">'+
            '<div class="tit"><span>' +venueName+ '</span><a href="javascript:toVenueDetail(\''+venueId+'\');">场馆详情&nbsp;&gt;&gt;</a></div>' +
            '<div class="culNav clearfix"><span>相关活动</span><span  class="cur">场馆预约</span><em></em></div>' +
            '<div class="culContWc">' +
            '<div class="culCont">' +
            '<ul class="culActVenList" id="venueRoom">';

        var data={
            venueId:venueId,
            pageIndex:0,
            pageNum:2
        }

        var venueDiv = "";

        $.ajax({
            type: "post",
            url: "${path}/wechatVenue/activityWcRoom.do",
            data: data,
            async: false,
            dataType: "json",
            success: function(data){
                if(data.status==0){
                    if(data.data.length == 2){
                        if(venueName.length >= 16){
                            infoWindowVerticalOffset = 350;
                        }else{
                            infoWindowVerticalOffset = 325;
                        }
                    }else if(data.data.length == 1){
                        if(venueName.length >= 16){
                            infoWindowVerticalOffset = 275;
                        }else{
                            infoWindowVerticalOffset = 250;
                        }
                    }else{
                        if(venueName.length >= 16){
                            infoWindowVerticalOffset = 185;
                        }else{
                            infoWindowVerticalOffset = 160;
                        }
                    }
                    $.each(data.data,function(i,dom){
                        venueDiv=venueDiv+"<li class='clearfix'>"+
                            "<a href='javascript:roomDetail(\""+dom.roomId+"\");'>"+
                            "<div class='pic'><img src='"+dom.roomPicUrl+"'/></div>"+
                            "<div class='char'>"+
                            "<div class='titYi'>"+dom.roomName+"</div>"+
                            "<div class='wenYi'>面积："+dom.roomArea+"㎡</div>"+
                            "<div class='wenYi'>容纳："+dom.roomCapacity+"人</div>"+
                            "</div>"+
                            "</a>"+
                            "</li>";

                    });
                }
            }
        });

        aa=aa+venueDiv+'</ul>' +
            '<a class="more" href="javascript:moreRoom(\''+venueId+'\',\''+venueName+'\');">查看更多&nbsp;&gt;&gt;</a>' +
            '</div>' +
            '</div>';
        infoMapWindow = new AMap.AdvancedInfoWindow({
            offset: new AMap.Pixel(240,infoWindowVerticalOffset)
        });
        infoMapWindow.setContent(aa);
        infoMapWindow.open(culMapInit, markerObject.target.getPosition());
    }

    function loadMap(map, infoJson) {
        // 清空地图的点
        map.clearMap();
        // 中心点
        center_dot = null;
        // 添加点的集合
        var markers = [];
        // 数据的条数
        var len_dot = infoJson.length;
        // 弹窗内容
        var contentNeir = '';
        for (var i = 0; i < len_dot; i++) {
            var marker = null;
            if(i == 0) {
                // 第一个设置为中心点，并且添加不同的样式
                marker = addMarket(map, [infoJson[i].venueLon, infoJson[i].venueLat], 'center',new Array(infoJson[i].venueId,infoJson[i].venueName));
                // 把中心点赋给全局变量
                center_dot = marker;
            } else {
                // 除了中心点，添加其他点，并且设置普通样式
                marker = addMarket(map, [infoJson[i].venueLon, infoJson[i].venueLat],null,new Array(infoJson[i].venueId,infoJson[i].venueName));
            }
            // 给每个点赋予一个这些内容的信息框
            contentNeir = "";/* '<div class="fs-cultureMapInfo">'+
				'<div class="tit"><span>' + infoJson[i].venueName + '</span><a href="javascript:toVenueDetail(\''+infoJson[i].venueId+'\');">场馆详情&nbsp;&gt;&gt;</a></div>' +
				'<div class="culNav clearfix"><span class="cur">相关活动</span><span>场馆预约</span><em></em></div>' +
				'<div class="culContWc">' + 
					'<div class="culCont">' +
					'<ul class="culActVenList" id="activityList">' +
						
					'</ul>' +
					'<a class="more" href="javascript:moreActivity(\''+infoJson[i].venueId+'\');">查看更多&nbsp;&gt;&gt;</a>' +
					'</div>' +
					'<div class="culCont" style="display:none;">' +
					'<ul class="culActVenList" id="venueRoom">' +
						
					'</ul>' +
					'<a class="more" href="javascript:moreRoom(\''+infoJson[i].venueId+'\');">查看更多&nbsp;&gt;&gt;</a>' +
					'</div>' +
				'</div>'; */
            marker.content = contentNeir;
            markers.push(marker);
        }
        if(center_dot != null){
            center_dot.setzIndex(101);
        }
        /* 默认第一个弹窗
        if(markers[0]!=undefined&&markers[0].length!=0){
            markers[0].on('click', markerClick);
            markers[0].emit('click', {target: markers[0]});
            map.setCenter([infoJson[0].venueLon,infoJson[0].venueLat]);
        }*/
        for(var i = 0; i < len_dot; i++) {
            (function(i) {
                markers[i].on("click", function(e) {
                    // 弹窗显示，这必须放在下面的return前面，因为这个必须执行
                    markerClick(e);
                    // 设置中心点并更新样式
                    if(center_dot == this) {
                        return;
                    }

                    center_dot.setzIndex(100);
                    markers[i].setzIndex(101);

                    center_dot.setContent('<img src="${path}/STATIC/image/child/hp_site.png"/>');
                    markers[i].setContent('<img src="${path}/STATIC/image/child/hp_sites.png"/>');
                    map.setCenter([infoJson[i].venueLon,infoJson[i].venueLat]);
                    center_dot = this;
                });
            })(i);
        }
    }

    // 初始化地图，只需要初始化一次
    var culMapInit = initMap();
    // 加载地图并绑定事件
    loadData();
    function loadData(){
        /* var data = {
            venueType: $("#tagList li.cur").attr("venueType")
        } */
        var data = {
            venueType: $("#tagList li.cur").attr("venueType"),
            venueName: $("#venueName").val()
        }
        $.post("${path}/wechatVenue/queryVenueByType.do",data, function (data) {
            if(data.status==1){
                infoJson = new Array();
                $.each(data.data, function (i, dom) {
                    infoJson.push({
                        'venueId' : dom.venueId,
                        'venueName' : dom.venueName,
                        'venueAddress' : dom.venueAddress,
                        'venueLat' : dom.venueLat,
                        'venueLon': dom.venueLon,
                        'venueIconUrl': dom.venueIconUrl
                    });

                });
                loadMap(culMapInit,infoJson);
            }
        }, "json");
    }


    // 切换
    $('body').on('click', '.culNav span', function () {
        $(this).addClass('cur').siblings().removeClass('cur');
        $('.culContWc .culCont').hide();
        if($(this).index() == 0){
            markerClick(markerObject);
        }else{
            showRoomInfo();
        }
    });

    //跳转到活动详情页
    function activityDetail(activityId){
        window.location.href = "${path}/frontActivity/frontActivityDetail.do?activityId="+activityId;
    }
    //活动室详情
    function roomDetail(roomId){
        window.location.href = "${path}/frontRoom/roomDetail.do?roomId="+roomId;
    }
    //场馆详情
    function toVenueDetail(venueId){
        window.location.href = "${path}/frontVenue/venueDetail.do?venueId="+venueId;
    }
    //更多相关活动
    function moreActivity(venueId){
        window.location.href = "${path}/cultureMap/relativeActivityList.do?venueId="+venueId;
    }
    //更多活动室
    function moreRoom(venueId){
        window.location.href = "${path}/cultureMap/relativeRoomList.do?venueId="+venueId;
    }

</script>
</html>
