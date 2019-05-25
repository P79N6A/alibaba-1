<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
	<title>文化联盟.${member.memberName}</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css">


<style type="text/css">
	.whlmBanner .swiper-pagination-fraction{
		font-size: 22px;color: #ffffff;
	}
	.whlmBanner .swiper-pagination-current{
		color: #e63917;
	}
	.swiper-container {
		float: none;
	}


</style>
<script>


	$(function () {
        //分享是否隐藏
        if (window.injs) {
            //分享文案
            appShareTitle = '佛山文化联盟“联盟成员标题”精彩内容看不停！';
            appShareDesc = '欢迎进入安康文化云·文化联盟';
            appShareImgUrl = '${images[0]}';
            injs.setAppShareButtonStatus(true);
        }
        if (is_weixin()) {
            var title = "佛山文化联盟“联盟成员标题”精彩内容看不停！";
            var desc = "欢迎进入安康文化云·文化联盟";
            var imgUrl = '${images[0]}';
            var link = window.location.href;

            wx.config({
                debug: false,
                appId: '${sign.appId}',
                timestamp: '${sign.timestamp}',
                nonceStr: '${sign.nonceStr}',
                signature: '${sign.signature}',
                jsApiList: ['previewImage', 'onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
            });
            wx.ready(function () {

                wx.onMenuShareAppMessage({
                    title: title,
                    desc: desc,
                    imgUrl: imgUrl,
                    link: link,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareTimeline({
                    title: title,
                    imgUrl: imgUrl,
                    link: link,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareQQ({
                    title: title,
                    desc: desc,
                    link: link,
                    imgUrl: imgUrl,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareWeibo({
                    title: title,
                    desc: desc,
                    link: link,
                    imgUrl: imgUrl,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareQZone({
                    title: title,
                    desc: desc,
                    link: link,
                    imgUrl: imgUrl,
                    success: function () {
                        //shareIntegral();
                    }
                });
            });
        }
    })




	// 导航固定
		function navFixed(ele, type) {
			var topH = ele.offset().top;
		    $(document).on(type, function() {
		        if($(document).scrollTop() > topH) {
		            ele.addClass('fixed');
		        } else {
		            ele.removeClass('fixed');
		        }
		    });
		}
	$(document).ready(function() {
		/*轮播图*/
		var mySwiper3 = new Swiper('.whlmBanner', {
			freeMode: false,
			autoplay: 5000,
			speed:500,
			loop: true,
			pagination : '.swiper-pagination',
			paginationType : 'fraction',
			autoplayDisableOnInteraction : false,
		});
  		/*菜单*/
		navFixed($(".dhshMenu .swiper-container"),'touchmove');
		navFixed($(".dhshMenu .swiper-container"),'scroll');
		var mySwiper = new Swiper('.whzsMenu .swiper-container', {
			slidesPerView: 'auto',
			spaceBetween: 50,
		})
		$(".whzsMenu .swiper-slide").on('click',function(){
			
			$(this).addClass('on').siblings().removeClass("on");
		});
		$(".menuTab").on('click','li',function(i){
			$(this).addClass('on').siblings().removeClass("on");
			var culturalOrderLargeType = $(this).attr('culturalOrderLargeType');
			loadCulturalOrderData(culturalOrderLargeType)
		})

		$("li img").each(function () {
		    var url = $(this).attr("data-src");
		    if(url) {
                if (url.indexOf("http://") < 0) {
                    var imgUrl = getIndexImgUrl(getImgUrl(url), "_300_300");
                    $(this).attr("src", imgUrl);
                } else {
                    $(this).attr("src", url);
                }
            }
        })
		//加载评论
        loadComment();
	})

	//页码
    var pageIndex=0;
	//操作标签名
	var n;
	//成员id
    var menberId="${memberId}";
    //请求同步
    var a=true;
    //不是最后一页
    var lastPage=true;

    var culturalOrderLargeType = 1;//1我要参与，2我要邀请

    function loadComment() {
        var data = {
            moldId: menberId,
            type: 21,
            pageIndex: pageIndex,
            pageNum: 6
        };
        $.post("${path}/wechat/weChatComment.do", data, function (data) {
            if (data.status == 0) {
                if(data.data.length <6){
                    lastPage=false;
				}
                $.each(data.data, function (i, dom) {
                    var commentImgUrlHtml = "";
                    if (dom.commentImgUrl.length != 0) {
                        var commentImgUrls = dom.commentImgUrl.split(",");
                        $.each(commentImgUrls, function (i, commentImgUrl) {
                            if(commentImgUrl)
                            // var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                            commentImgUrlHtml += "<li style='margin-right: 10px;'><img  width=150 height=150 src='" + commentImgUrl + "' onclick='previewImage(\"" + commentImgUrl + "\",\""+dom.commentImgUrl+"\");'></li>"
                        });
                    }
                    var userHeadImgUrl = '';
                    if (dom.userHeadImgUrl.indexOf("http") == -1) {
                        userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
                    } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
                        var smallUrl = getIndexImgUrl(dom.userHeadImgUrl, "_72_72");
                        var bigUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
                        var ImgObj = new Image();
                        ImgObj.src = smallUrl;
                        if (ImgObj.fileSize > 0 || (ImgObj.width > 0 && ImgObj.height > 0)) {
                            userHeadImgUrl = smallUrl;
                        } else {
                            userHeadImgUrl = bigUrl;
                        }
                    } else {
                        userHeadImgUrl = dom.userHeadImgUrl;
                    }
                    $("#activityComment").append("<li>" +
                        "<div class='p7-user-list'>" +
                        "<div class='p7-user'>" +
                        "<img src='" + userHeadImgUrl + "' width='65' height='65' onerror='imgNoFind();'/>" +
                        "<div class='p7-user-name'>" +
                        "<p class='user-name'>"+dom.commentUserNickName+"</p>" +
                        "<p class='user-time'>"+dom.commentTime.replace("-",".").replace("-",".")+"</p>" +
                        "</div>" +
                        "<div style='clear: both;'></div>" +
                        "</div>" +
                        "<div class='p7-say'>" +
                        "<p>" + dom.commentRemark + "</p>" +
                        "</div>" +
                        "<div class='p7-user-list-img commentImgUrlHtml'><ul>" + commentImgUrlHtml + "</ul></div>" +
                        "</div>" +
                        "</li>");
                });
            }
        }, "json");
        pageIndex+=10;
        a=true;
    }

    //滑屏分页
    $(window).on("scroll", function () {
        var scrollTop = $(document).scrollTop();
        var pageHeight = $(document).height();
        var winHeight = $(window).height();
        if (scrollTop >= (pageHeight - winHeight - 100) && a && lastPage) {
            a=false;
            setTimeout(function () {
                if(n=="comment"){
                    loadComment();
				}else {
                    appendli(n);
                    pageIndex+=1;
                }
            }, 1000);
        }
    });

    function switchAddData(name,data) {
        switch(name)
        {
            case "activity":
                for (c in data)
                {
                    var url = data[c].activityIconUrl;
                    var imgUrl = getIndexImgUrl(getImgUrl(url),"_300_300");
                    $("#activity ul").append('<li onclick="window.location=\'${path}/wechatActivity/preActivityDetail.do?activityId='+data[c].activityId+'\'"><div class="img"><img style="width: 336px;height: 213px;" src="'+imgUrl+'"></div> <div class="char"><p class="tit">'+data[c].activityName+'</p>  <p class="info">时间：'+data[c].activityCreateTime+'</p><p class="info">地址：'+data[c].activityAddress+'</p></div></li>');
                }
                break;
            case "venue":
                for (c in data)
                {
                    var url = data[c].venueIconUrl;
                    var imgUrl = getIndexImgUrl(getImgUrl(url),"_300_300");
                    $("#venue ul").append('<li onclick="window.location=\'${path}/wechatVenue/venueDetailIndex.do?venueId='+data[c].venueId+'\'"><div class="img"><img src="'+imgUrl+'" style="width: 336px;height: 213px;"></div> <div class="char"><p class="tit">'+data[c].venueName+'</p><p class="info">地址：'+data[c].venueAddress+'</p></div></li>');
                }
                break;
            case "information":
                for (c in data)
                {
                    var imgUrl = data[c].beipiaoinfoHomepage;
                    $("#information ul").append('<li onclick="window.location=\'${path}/wechatChuanzhou/chuanzhouDetail.do?infoId='+data[c].beipiaoinfoId+'\'"><div class="img"><img style="width: 336px;height: 213px;" src="'+imgUrl+'"></div> <div class="char"><p class="tit">'+data[c].beipiaoinfoTitle+'</p><p class="info">地址：'+data[c].beipiaoinfoContent+'</p></div></li>');
                }
                break;
            case "orders":
                var obj;
                for (c in data)
                {
                    obj = data[c];
					if(culturalOrderLargeType==1){
						var date1 = new Date(obj.startDate);
						var date2 = new Date(obj.endDate);
					}else{
						var date1 = new Date(obj.culturalOrderStartDate);
						var date2 = new Date(obj.culturalOrderEndDate);
					}
					var startDate  =  date1.Format('yyyy-MM-dd');
					var endDate = date2.Format('yyyy-MM-dd')
					///wechatCulturalOrder/culturalOrderDetail.do?culturalOrderId=4685dac03e3945f2aa90e117f640457f&culturalOrderLargeType=1&userId=

					var str ='<li onclick="window.location.href=\'../wechatCulturalOrder/culturalOrderDetail.do?culturalOrderId='+obj.culturalOrderId+'&culturalOrderLargeType='+culturalOrderLargeType+'&userId='+userId+'\'"> \n' +
						'\t\t\t\t\t\t<div class="img"><img style="width: 336px;height: 213px" src="'+obj.culturalOrderImg+'"></div>\n' +
						'\t\t\t\t\t\t<div class="char">\n' +
						'\t\t\t\t\t\t\t<p class="tit">'+obj.culturalOrderName+'</p>\n' +
						'\t\t\t\t\t\t\t<p class="info">日期：'+startDate+'</p>\n' +
						'\t\t\t\t\t\t</div>\n' +
						'\t\t\t\t\t</li>'

                    $("#orders ul.whzsList").append(str);
                }
                break;

        }
    }

	function appendli(name) {
        $.ajaxSettings.async = false;
            $.get("${path}/wechatUnion/unionActivity.do",{name:name,menberId:menberId,pageIndex:pageIndex,culturalOrderLargeType:culturalOrderLargeType},function(data) {
                if(data.length <4){lastPage=false;}else{lastPage=true}
                switchAddData(name,data);
                a=true;
            });
    }

	function activityPageData(name) {
        //有下一页
        lastPage=true;
        //正在访问的标签
        n=name;
        pageIndex=0;
        $("#activity").hide()
		$("#information").hide()
        $("#venue").hide()
        $("#orders").hide()
        $("#comment").hide()
        $("#memMsg").hide()
        $("#memIntroduce").hide()
        $("#comment_div").hide()
		if(name!='orders'){
			//删除里面的内容
			$("#"+name+" li").remove()
			$("#"+name+"").show()
			//查看全部,隐藏
			$("#"+name+" h2 a").hide();
		}else{

            $("#"+name+" .whzsList li").remove();
			$("#orders .menuTabUl").show();
            $("#"+name+" h2").hide();
            //查看全部,隐藏
            $("#"+name+" h2 a").hide();

            $("#"+name+"").show()
		}

		if(name=="comment"){
            $("#btn").show()
            $("#discuss").show()
			$("#comment_div").show();
            loadComment();
		}else{
            $.get("${path}/wechatUnion/unionActivity.do",{name:name,menberId:menberId,
				pageIndex:pageIndex,culturalOrderLargeType:culturalOrderLargeType },function(data) {
                switchAddData(name,data);
                pageIndex+=1;
            });
		}
    }

    function changeLable(name) {
        $("#"+name+"_").click();
    }

    function toaddComment() {
        if (userId == null || userId == '') {
            window.location.href = '${path}/muser/login.do?type=${path}/wechatUnion/index.do?member=${memberId}';

        } else {
            var status = '${sessionScope.terminalUser.commentStatus}';
            if (status == 2) {
                dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
            } else {
                window.location.href = "${path}/wechat/preAddWcComment.do?commentRkName=${member.memberName}&moldId=${memberId}&type=21";
            }
        }
    }

    //图片预览
    function previewImage(url,urls) {
        wx.previewImage({
            current: url, // 当前显示图片的http链接
            urls: urls.substring(0, urls.length - 1).split(",")	 // 需要预览的图片http链接列表
        });
    }

</script>
</head>
<body style="background-color: #f3f3f3;">
	<div class="fsMain">

		<div class="swiper-container whlmBanner">
				<div class="swiper-wrapper">
				<c:forEach items="${images}" var="image">
						<a href="#" class="swiper-slide"><img src="${image}" width="100%" height="100%"></a>
				</c:forEach>
				</div>
			<div class="swiper-pagination"></div>
		</div>

		<div class="whzsMenu dhshMenu">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide on" onclick="window.open('${path}/wechatUnion/index.do?member=${memberId}','_self')">首页</div>
					<div id="activity_" class="swiper-slide" onclick="activityPageData('activity')">文化活动</div>
					<div id="venue_" class="swiper-slide" onclick="activityPageData('venue')">文化场馆</div>
					<div id="orders_"  class="swiper-slide" onclick="activityPageData('orders')">文化点单</div>
					<div id="information_" class="swiper-slide" onclick="activityPageData('information')">动态资讯</div>
					<div id="comment_" class="swiper-slide" onclick="activityPageData('comment')">用户留言</div>
				</div>
			</div>
		</div>


		<div class="dhshWrap">
			<div class="dhshInfo" id="memMsg">
				<h1 class="tit">${member.memberName}</h1>
				<p >${member.address}</p>
			</div>
			<div class="sortInfo" id="memIntroduce">
				<h2 class="infoTit">简 介</h2>
				<div class="sortDetail">
					<p>${member.introduction}</p>
				</div>
			</div>

			<!-- 文化活动 -->
			<div class="whzsWrap dhshListWrap" id="activity">
				<h2 class="infoTit clearfix">文化活动<a onclick="changeLable('activity')" class="more">查看全部</a></h2>
				<ul class="whzsList clearfix" id="activityUl">
					<c:forEach items="${cmsActivities}" var="cmsActivity">
						<li onclick="window.location='${path}/wechatActivity/preActivityDetail.do?activityId=${cmsActivity.activityId}'">
							<div class="img"><img data-src="${cmsActivity.activityIconUrl}" style="width: 336px;height: 213px;"></div>
							<div class="char">
								<p class="tit">${cmsActivity.activityName}</p>
								<p class="info">时间：<fmt:formatDate value="${cmsActivity.activityCreateTime}" pattern="yyyy/MM/dd  HH:mm:ss" /></p>
								<p class="info">地址：${cmsActivity.activityAddress}</p>
							</div>
						</li>
					</c:forEach>

				</ul>
			</div>
			<!-- 文化场馆 -->
			<div class="whzsWrap dhshListWrap" id="venue">
				<h2 class="infoTit clearfix">文化场馆<a onclick="changeLable('venue')" class="more">查看全部</a></h2>
				<ul class="whzsList clearfix">

					<c:forEach items="${cmsVenues}" var="cmsVenue">
						<li onclick="window.location='${path}/wechatVenue/venueDetailIndex.do?venueId=${cmsVenue.venueId}'">
							<div class="img"><img data-src="${cmsVenue.venueIconUrl}" style="width: 336px;height: 213px;"></div>
							<div class="char">
								<p class="tit">${cmsVenue.venueName}</p>
								<p class="info">地址：${cmsVenue.venueAddress}</p>
							</div>
						</li>
					</c:forEach>
				</ul>
			</div>

			<!-- 文化点单 -->
		<div class="whzsWrap dhshListWrap" id="orders">
				<h2 class="infoTit clearfix">
					文化点单
					<ul class="menuTab clearfix">
						<li class="on" culturalOrderLargeType="1">我要参与</li><em>/</em>
						<li culturalOrderLargeType="2">我要邀请</li>
					</ul>
					<a href="#"  onclick="changeLable('orders')" class="more">查看全部</a>
				</h2>
				<ul class="menuTabUl clearfix" style="display: none">
					<li class="on" culturalOrderLargeType="1">我要参与</li>
					<li culturalOrderLargeType="2">我要邀请</li>
				</ul>
				<ul class="whzsList clearfix">
				</ul>
			</div>

			<!-- 动态资讯 -->
			<div class="whzsWrap dhshListWrap" id="information">
				<h2 class="infoTit clearfix">动态资讯<a onclick="changeLable('information')" class="more">查看全部</a></h2>
				<ul class="whzsList clearfix">
					<c:forEach items="${bpInfos}" var="bpInfo">
						<li onclick="window.location='${path}/wechatChuanzhou/chuanzhouDetail.do?infoId=${bpInfo.beipiaoinfoId}'">
							<div class="img"><img data-src="${bpInfo.beipiaoinfoHomepage}" style="width: 336px;height: 213px;"></div>
							<div class="char">
								<p class="tit">${bpInfo.beipiaoinfoTitle}</p>
								<p class="info h60">${bpInfo.beipiaoinfoContent}</p>
							</div>
						</li>
					</c:forEach>



				</ul>
			</div>
			<!-- 用户留言 -->
			<div class="whzsWrap dhshListWrap" id="comment">

				<div style="width: 600px">
					<h2 class="infoTit clearfix">用户留言<a onclick="changeLable('comment')" class="more">查看全部</a></h2>
				</div>

				<%--<div style="margin-bottom: 0px;" class="active-border" id="comment_div">--%>
					<%--<div class="active-detail-p7 commentImgHtml" style="margin-top: -45px;">--%>
						<%--<ul id="activityComment"></ul>--%>
					<%--</div>--%>
				<%--</div>--%>
				<ul id="activityComment"></ul>

				<div style="display: none;" id="btn">
					<button id="discuss"  onclick="toaddComment()" style="width:750px;height: 100px;line-height: 100px;font-size: 40px;color: #fff;text-align: center;background-color: #4b70b7;position: fixed;right: 0;bottom: 0;left: 0;margin: auto;z-index: 3;">我要评论</button>
				</div>


			</div>
		</div>
	</div>
<script type="text/javascript">

	$(function () {
        loadCulturalOrderData(1);

        $(".menuTabUl").on('click','li',function(){
            $(this).addClass('on').siblings().removeClass("on");
            pageIndex = 0;
            culturalOrderLargeType = $(this).attr('culturalOrderLargeType');
            $("#orders .whzsList  li").remove();
            appendli('orders');
            pageIndex+=1;
        })

    })

    function loadCulturalOrderData(culturalOrderLargeType) {
        $.ajax({
            url: "../member/loadCulturalOrderList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 4,page:1,culturalOrderLargeType:culturalOrderLargeType},
            success: function (result) {
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var rsObj = jQuery.parseJSON(result);
                    var data = rsObj.list;
                    if (data.length > 0) {
                        var str = '';
                        for (var k in data) {
                            var obj = data[k];
                            if(culturalOrderLargeType==1){
                                var date1 = new Date(obj.startDate);
                                var date2 = new Date(obj.endDate);
                            }else{
                                var date1 = new Date(obj.culturalOrderStartDate);
                                var date2 = new Date(obj.culturalOrderEndDate);
                            }
                            var startDate  =  date1.Format('yyyy-MM-dd');
                            var endDate = date2.Format('yyyy-MM-dd')

							str+='<li onclick="window.location.href=\'../wechatCulturalOrder/culturalOrderDetail.do?culturalOrderId='+obj.culturalOrderId+'&culturalOrderLargeType='+culturalOrderLargeType+'&userId='+userId+'\'"> \n' +
                                '\t\t\t\t\t\t<div class="img"><img style="width: 336px;height: 213px" src="'+obj.culturalOrderImg+'"></div>\n' +
                                '\t\t\t\t\t\t<div class="char">\n' +
                                '\t\t\t\t\t\t\t<p class="tit">'+obj.culturalOrderName+'</p>\n' +
                                '\t\t\t\t\t\t\t<p class="info">日期：'+startDate+'</p>\n' +
                                '\t\t\t\t\t\t</div>\n' +
                                '\t\t\t\t\t</li>'
                        }

                        $("#orders ul.whzsList").html(str);
                    }
                }
            }
        });
    }

    // 对Date的扩展，将 Date 转化为指定格式的String
    // 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符，
    // 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)
    Date.prototype.Format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "H+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }
</script>
</body>
</html>