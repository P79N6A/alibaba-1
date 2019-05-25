<%@ page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<link rel="stylesheet" type="text/css" href="/STATIC/css/normalize.css">
<link rel="stylesheet" type="text/css" href="/STATIC/css/style-series.css">
<link rel="stylesheet" type="text/css" href="/STATIC/wechat/css/common.css">
<link rel="stylesheet" type="text/css" href="/STATIC/wechat/css/ui-dialog.css"/>
<link rel="stylesheet" type="text/css" href="/STATIC/wechat/css/swiper-3.3.1.min.css">
<c:set var="currentDate">
    <fmt:formatDate value="<%=new Date()%>" pattern="yyyy-MM-dd HH:mm:ss" />
</c:set>

<script type="text/javascript" src="/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="/STATIC/wechat/js/dialog-min.js"></script>
<script type="text/javascript" src="http://m.wenhuayun.cn/STATIC/wechat/js/wechat-util.js"></script>
<script type="text/javascript" src="/STATIC/wechat/js/map-transform.js"></script>
<script type="text/javascript" src="/STATIC/wechat/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
<script src="${path}/STATIC/js/common.js"></script>
<script src="/STATIC/js/avalon.js"></script>
<script type="text/javascript" src="/stat/stat.js"></script>

<script src="/STATIC/js/common.js"></script>

<c:set value="/upload/" var="imgurlHost"/>

<title>${ActivityTopic.title}</title>

<script>

    var appShareTitle = '';
    var appShareDesc = '';
    var appShareImgUrl = '';
    var appShareLink = '';

    if (window.injs)
    {

        appShareImgUrl = "${IMGURL}${ActivityTopic.shareimg}";
        appShareTitle = "${ActivityTopic.sharetitle}";
        appShareDesc =  "${ActivityTopic.sharedesc}";
        injs.setAppShareButtonStatus(true);
    }

    if(is_weixin())
    {
        wx.config({
            debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
            appId: '${WCHATSIGN.appId}', // 必填，公众号的唯一标识
            timestamp: '${WCHATSIGN.timestamp}', // 必填，生成签名的时间戳
            nonceStr: '${WCHATSIGN.nonceStr}', // 必填，生成签名的随机串
            signature: '${WCHATSIGN.signature}',// 必填，签名，见附录1
            jsApiList: ['onMenuShareTimeline','onMenuShareAppMessage','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
        });
        wx.ready(function()
        {

            var   durl = "${WCHATSIGN.url}";
            var     url = '${WCHATSIGN.url}';
            var  imgurl = "${IMGURL}${ActivityTopic.shareimg}";
            var  title = "${ActivityTopic.sharetitle}";
            var  desc = "${ActivityTopic.sharedesc}";
            wx.onMenuShareTimeline({
                title: title, // 分享标题
                link: url, // 分享链接
                imgUrl: imgurl, // 分享图标
                success: function ()
                {

                },
                cancel: function ()
                {
                    // 用户取消分享后执行的回调函数
                }
            });


            wx.onMenuShareAppMessage({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl, // 分享图标
                type: 'link', // 分享类型,music、video或link，不填默认为link
                dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
                success: function ()
                {

                },
                cancel: function () {
                    // 用户取消分享后执行的回调函数
                }
            });

            wx.onMenuShareQQ({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl, // 分享图标
                success: function ()
                {

                },
                cancel: function () {
                    // 用户取消分享后执行的回调函数
                }
            });

            wx.onMenuShareWeibo({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl, // 分享图标
                success: function ()
                {

                },
                cancel: function () {
                    // 用户取消分享后执行的回调函数
                }
            });

            wx.onMenuShareQZone({
                title: title, // 分享标题
                desc: desc, // 分享描述
                link: url, // 分享链接
                imgUrl: imgurl, // 分享图标
                success: function ()
                {

                },
                cancel: function () {
                    // 用户取消分享后执行的回调函数
                }
            });

        });
        wx.error(function(res)
        {

        });
    }



</script>


<script type="text/javascript">
    var phoneWidth = parseInt(window.screen.width);
    var phoneScale = phoneWidth / 750;
    var ua = navigator.userAgent; //浏览器类型
    if(/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
        var version = parseFloat(RegExp.$1); //安卓系统的版本号
        if(version > 2.3) {
            document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
        } else {
            document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
        }
    } else {
        document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
    }
</script>
<style>
    /*Clear Css*/
    .clear{clear:both; font-size:0px; height:0px; line-height:0;}
    .clearfix:after{content:'\20';display:block;clear:both;visibility:hidden;line-height:0;height:0;}
    .clearb{ clear:both;}
    .clearfix{display:block;zoom:1;}
    html[xmlns] .clearfix{display:block;}
    * html .clearfix{height:1%;}
    img {vertical-align: middle;}
    .youthArtList>ul {
        display: none;
    }
    .fenmian_yindy {width: 750px;height: 100%;position: fixed;top: 0;right: 0;bottom: 0;left: 0;margin: auto;z-index: 100;}
    .fenmian_yindy img {vertical-align: middle;width: 100%;height: 100%;}
    .youthArtMonth>ul>li {
        width: auto;

    }
	.hkVedioList ul li .lccwz {
	    white-space: nowrap;
	    text-overflow: ellipsis;
	    -o-text-overflow: ellipsis;
	    overflow: hidden;
	    width: 325px;
	}
    .hkPeoListDetl
    {
        margin-top: 0px;
        font-size: 26px;
        color: #5a5a5a;
        line-height: 50px;
        max-height: 999999px;
    }

    .hkVideoBlock
    {
        height: 220px;
        padding-top:20px;
    }

    .hkVideoBlock > .text
    {
        float: left;
        width: 335px;
        margin-left: 20px;
    }

    .hkVideoBlock > .video
    {
        width: 325px;
        height: 200px;
        float:right;
        padding-right: 20px;
        position: relative;
    }

	.lcchk_rmzx .lccwz{
		width:690px!important;
	}
</style>
<script>
    function youthArtMonth() {

        //			var year = myDate.getFullYear(); //获取完整的年份(4位,1970-????)
        //			var month = myDate.getMonth() + 1; //获取当前月份

        //			console.log(day);
    }

    $(function() {
        $("iframe").remove()

        $(".youthArtMonth>ul>li").click(function() {
            $(".youthArtMonth>ul>li").removeClass("monthBtLine")
            $(this).addClass("monthBtLine")
            $(this).index()
            $(".hkArtList>ul").hide()
            $(".hkArtList>ul").eq($(this).index()).show()
        })

//        var dataLilen = $(".youthArtMonth>ul>li").length;
//        var dataLiWidth = $(".youthArtMonth>ul>li").width() + 40;
//        var dataUlWidth = dataLilen * dataLiWidth;
//        $(".youthArtMonth>ul").css("width", dataUlWidth);
        var dataUlWidth = 0;
        $(".youthArtMonth>ul>li").each(function(){
            dataUlWidth += $(this).width() + 40;
        })
        dataUlWidth += 10;
        dataUlWidth += 'px';
        $(".youthArtMonth>ul").css("width", dataUlWidth);

    })
</script>

<body>
<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
    <img src="/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
</div>
<div class="div-share">
    <div class="share-bg"></div>
    <div class="share">
        <img src="/STATIC/wechat/image/wx-er2.png" />
        <p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
        <p>更多精彩活动、场馆等你发现</p>
        <button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
    </div>
</div>

<div class="youthArt">
    <div class="youthArtHead">
        <img src="${IMGURL}${ActivityTopic.headimg}" style="width: 750px;height: 250px;" />
        <ul class="lcchk_ban_ul clearfix">
            <li><a href="javascript:void(0)" class="shareBtn">分享</a></li>
            <li><a href="javascript:void(0)" class="keepBtn">关注</a></li>
            <%--<li><a href="http://m.wenhuayun.cn">首页</a></li>--%>
        </ul>
    </div>
    <c:set var="titleDisplayed" value="" />
    <c:if test="${topicid==61}">
   		
		<script>
		  $(function() {  
			  
			  var videoDiv=$(".hkVedioList  ul li").find("div").eq("0");
			  videoDiv.css("width","700px")
			  videoDiv.css("height","430px")
			  videoDiv.find("video").css("width","700px")
			  videoDiv.find("video").css("height","430px")
			  videoDiv.find(".hkPlayBtn").css("width","700px")
			  videoDiv.find(".hkPlayBtn").css("height","430px")
			  
			  $(".hkVedioList  ul li").append('<div class="hkPeoListDetl" style="margin-top:0;">&emsp;&emsp;本期节目为你带来一门始于8000年前的中国石器时代，却在今天兴盛于日本的传统工艺制品——漆器。那份温润华丽，富含变化，与现代机械的冰冷格格不入的温暖。</div>')
			  
			  $(".hkPeoList .hkPeoListDetl").css("margin-top","0");
			  
			  var sly={"font-size":"26px","color":"#000","line-height":"50px","max-height":"999999px"}
			  var sly2={"font-size":"24px","color":"#000","line-height":"50px","max-height":"999999px"}
			  
			  $(".hkPeoListDetl").css(sly);
			  $(".youthArtTipsDt").css(sly2);
			  
		  })
		</script>
    </c:if>
    
    
    <c:if test="${topicid==64}">
   		
		<script>
		  $(function() {  
			  
			  var videoDiv=$(".hkVedioList  ul li").find("div").eq("0");
			  videoDiv.css("width","700px")
			  videoDiv.css("height","430px")
			  videoDiv.find("video").css("width","700px")
			  videoDiv.find("video").css("height","430px")
			  videoDiv.find(".hkPlayBtn").css("width","700px")
			  videoDiv.find(".hkPlayBtn").css("height","430px")
			  
			//  $(".hkVedioList  ul li").eq(0).append('<div class="hkPeoListDetl" style="margin-top:0;">&emsp;&emsp;本期节目我们介绍的是上海非物质文化遗产,一门来自于乡间田野的绘画艺术——金山农民画。从灶头上的简笔画,到现在的颜色跳跃,自由奔放的非遗文化,感受这门艺术的独特魅力。</div>')
			  
			  $(".hkPeoList .hkPeoListDetl").css("margin-top","0");
			  
			  var sly={"font-size":"26px","color":"#000","line-height":"50px","max-height":"999999px"}
			  var sly2={"font-size":"24px","color":"#000","line-height":"50px","max-height":"999999px"}
			  
			  $(".hkPeoListDetl").css(sly);
			  $(".youthArtTipsDt").css(sly2);
			  
		  })
		</script>
    </c:if>
    
    
    <c:if test="${topicid==65}">
   		
		<script>
		  $(function() {  
			  
			  var videoDiv=$(".hkVedioList  ul li").find("div").eq("0")·;
			  videoDiv.css("width","700px")
			  videoDiv.css("height","430px")
			  videoDiv.find("video").css("width","700px")
			  videoDiv.find("video").css("height","430px")
			  videoDiv.find(".hkPlayBtn").css("width","700px")
			  videoDiv.find(".hkPlayBtn").css("height","430px")
			//  $(".hkVedioList  ul li").eq(0).append('<div class="hkPeoListDetl" style="margin-top:0;">&emsp;&emsp;本期节目我们介绍的是一位缔造上海建筑传奇的大师——邬达克。短短三十年，设计了超过百余栋建筑：国际饭店、大光明电影院、市三女中等等，缔造了海派建筑的传说。让我们回到上海的黄金三十年，讲述他成为海派建筑之父的传奇故事。</div>')
			  $(".hkPeoList .hkPeoListDetl").css("margin-top","0");
			  var sly={"font-size":"26px","color":"#000","line-height":"50px","max-height":"999999px"}
			  var sly2={"font-size":"24px","color":"#000","line-height":"50px","max-height":"999999px"}
			  $(".hkPeoListDetl").css(sly);
			  $(".youthArtTipsDt").css(sly2);
			  
		  })
		</script>
    </c:if>
    
    
    <c:if test="${topicid==66}">
   		
		<script>
		  $(function() {  
			  
			  var videoDiv=$(".hkVedioList  ul li").find("div").eq("0");
			  videoDiv.css("width","700px")
			  videoDiv.css("height","430px")
			  videoDiv.find("video").css("width","700px")
			  videoDiv.find("video").css("height","430px")
			  videoDiv.find(".hkPlayBtn").css("width","700px")
			  videoDiv.find(".hkPlayBtn").css("height","430px")
			  
			//  $(".hkVedioList  ul li").eq(0).append('<div class="hkPeoListDetl" style="margin-top:0;">&emsp;&emsp;本期节目我们介绍的是“东方的莎士比亚”——中国戏曲大师汤显祖。“情不知所起，一往而深”，“良辰美景奈何天”…这些熟悉的诗句，竟都出自于汤显祖的戏曲《牡丹亭》！今天，让我们一同走进历史，揭晓这些哀怨动人的经典作品！</div>')
			  
			  $(".hkPeoList .hkPeoListDetl").css("margin-top","0");
			  
			  var sly={"font-size":"26px","color":"#000","line-height":"50px","max-height":"999999px"}
			  var sly2={"font-size":"24px","color":"#000","line-height":"50px","max-height":"999999px"}
			  
			  $(".hkPeoListDetl").css(sly);
			  $(".youthArtTipsDt").css(sly2);
			  
		  })
		</script>
    </c:if>
    
    
    
    
    <c:if test="${topicid==61}">
    
    		<script>
		  $(function() {  
			  
			  var videoDiv=$(".hkVedioList  ul li").find("div").eq("0");
			  videoDiv.css("width","700px")
			  videoDiv.css("height","430px")
			  videoDiv.find("video").css("width","700px")
			  videoDiv.find("video").css("height","430px")
			  videoDiv.find(".hkPlayBtn").css("width","700px")
			  videoDiv.find(".hkPlayBtn").css("height","430px")
		  })
			</script>
    
    </c:if>
    
    <c:if test="${!empty ActivityTopic.activytList}">
    <div class="youthArtMonth">
        <ul>
            <c:forEach items="${ActivityTopic.activytList}" var="actvity" varStatus="status">
                <c:if test="${!fn:contains(titleDisplayed,actvity.hname)}">
                    <c:choose>
                        <c:when test="${status.index == 0}">
                            <li class="monthBtLine">
                            <c:set var="titleDisplayed" value="${actvity.hname}" />
                        </c:when>
                        <c:otherwise>
                            <c:set var="titleDisplayed" value="${titleDisplayed};${actvity.hname}" />
                            <li>
                        </c:otherwise>
                    </c:choose>
                    ${actvity.hname}</li>

                </c:if>

            </c:forEach>
            <div style="clear: both;"></div>
        </ul>
    </div>
    </c:if>
    <div class="hkArtList">
    
        <c:forEach items="${fn:split(titleDisplayed, ';')}" var="hname" varStatus="status">
        <c:choose>
        <c:when test="${status.index == 0}">
        <ul style="display: block;">
            </c:when>
            <c:otherwise>
            <ul>
                </c:otherwise>
                </c:choose>
                <c:forEach items="${ActivityTopic.activytList}" var="actvity" >
                    <c:if test="${hname == actvity.hname}">
                        <li>
                            <div class="hkjz704">
                                <div class="lcchk_piao clearfix">
                                    <div class="pic"><img src="${IMGURL}${actvity.image}" style="width: 290px;height: 175px;"></div>
                                    <div class="char">
                                        <div class="tit">${actvity.title}</div>
                                        <div class="wz" style="background-image: url(/STATIC/image/lcchk2.png);">${actvity.addr}</div>
                                        <div class="wz" style="background-image: url(/STATIC/image/lcchk3.png);">${actvity.duration}</div>
                                    </div>
                                </div>
                                <c:if test="${actvity.linktitle != null  and  actvity.linktitle != ''}">
                                    <div class="cnmusic_ljdp <c:if test="${actvity.linkisblue == 0}">disable</c:if>" onclick="toActDetail('${actvity.activityid}')">${actvity.linktitle}</div>
                                </c:if>
                                <c:if test="${actvity.linktitle == '' or actvity.linktitle == null}">
                                    <c:if test="${actvity.activityid != null  and  actvity.activityid != ''}">

                                        <c:if test="${actvity.SPIKE_TYPE == 0}">
                                            <c:if test="${actvity.isExpired == 1}">
                                                <div class="cnmusic_ljdp disable" onclick="toActDetail('${actvity.activityid}')">已结束</div>
                                            </c:if>
                                            <c:if test="${actvity.isExpired != 1}">
                                                <c:if test="${actvity.ACTIVITY_IS_RESERVATION != 2}">
                                                    <div class="cnmusic_ljdp" onclick="toActDetail('${actvity.activityid}')">直接前往</div>
                                                </c:if>
                                                <c:if test="${actvity.ACTIVITY_IS_RESERVATION == 2}">
                                                    <c:if test="${actvity.AVAILABLE_COUNT > 0}">
                                                        <div class="cnmusic_ljdp" onclick="toActDetail('${actvity.activityid}')">立即预约</div>
                                                    </c:if>
                                                    <c:if test="${actvity.AVAILABLE_COUNT <= 0}">
                                                        <div class="cnmusic_ljdp disable" onclick="toActDetail('${actvity.activityid}')">已订完</div>
                                                    </c:if>
                                                </c:if>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${actvity.SPIKE_TYPE == 1}"><!--秒杀-->
                                            <c:if test="${actvity.isExpired == 1}">
                                                <div class="cnmusic_ljdp disable" onclick="toActDetail('${actvity.activityid}')">已结束</div>
                                            </c:if>
                                            <c:if test="${actvity.isExpired != 1}">
                                                <c:if test="${actvity.ACTIVITY_IS_RESERVATION != 2}">
                                                    <div class="cnmusic_ljdp" onclick="toActDetail('${actvity.activityid}')">直接前往</div>
                                                </c:if>
                                                <c:if test="${actvity.ACTIVITY_IS_RESERVATION == 2}">
                                                    <c:if test="${actvity.AVAILABLE_COUNT > 0}">
                                                        <fmt:parseDate var= "spiketime" value= "${actvity.spike_time}" pattern= "yyyy-MM-dd HH:mm:ss" />
                                                        <c:set value="<%=new Date()%>" var="nowtime" />
                                                        <c:set var= "interval" value= "${(spiketime.time - nowtime.time)/1000/60}" />
                                                        <c:choose>
                                                            <c:when test="${interval < 24*60 and interval > 0}"><!--秒杀 24小时内-->
                                                                <div class="cnmusic_ljdp" onclick="toActDetail('${actvity.activityid}')">即将秒杀</div>
                                                            </c:when>
                                                            <c:when test="${interval <= 0}"><!--秒杀时间已过-->
                                                                <div class="cnmusic_ljdp" onclick="toActDetail('${actvity.activityid}')">立即预约</div>
                                                            </c:when>
                                                            <c:when test="${interval >= 24*60}"><!--秒杀 24小时外-->
                                                                <div class="cnmusic_ljdp disable" onclick="toActDetail('${actvity.activityid}')">未开始</div>
                                                            </c:when>

                                                        </c:choose>

                                                    </c:if>
                                                    <c:if test="${actvity.AVAILABLE_COUNT <= 0}">
                                                        <div class="cnmusic_ljdp disable" onclick="toActDetail('${actvity.activityid}')">已订完</div>
                                                    </c:if>
                                                </c:if>
                                            </c:if>
                                        </c:if>
                                    </c:if>
                                </c:if>

                            </div>
                        </li>
                    </c:if>
                </c:forEach>
            </ul>
            </c:forEach>
    </div>

    <c:forEach var="block" items="${ActivityTopic.blockList}">

        ${block.showContent}

    </c:forEach>




</div>
</body>
<script language="JavaScript">




    $(".keepBtn").click(function () {

        $('.div-share').show()
        $("body,html").addClass("bg-notouch")
    });


    $(".background-fx").click(function () {

        $(".background-fx").css("display", "none");
        $("body,html").removeClass("bg-notouch")

    });

    $(".shareBtn").click(function() {
        if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
            dialogAlert('系统提示', '请用微信浏览器打开分享！');
        }else{
            $("html,body").addClass("bg-notouch");
            $(".background-fx").css("display", "block")
        }
    })



    function toActDetail(activityid)
    {
    	if(activityid){
    		var ua = navigator.userAgent.toLowerCase();
        	if (/wenhuayun/.test(ua)) {		//APP端
        		if (window.injs) {	//判断是否存在方法
    				injs.accessAppPage(1,activityid);
    			}else{
    				location.href = "com.wenhuayun.app://activitydetail?activityId=" + activityid;
    			}
        	}else{		//H5
        		location.href = getFrontUrl()+"wechatActivity/preActivityDetail.do?activityId=" + activityid;
//                window.open("http://m.wenhuayun.cn/wechatActivity/preActivityDetail.do?activityId=" + activityid);
        	}
    	}
    }

    function toVenueDetail(venueid)
    {
        if(venueid){
            var ua = navigator.userAgent.toLowerCase();
            if (/wenhuayun/.test(ua)) {		//APP端
                if (window.injs) {	//判断是否存在方法
                    injs.accessAppPage(1,activityid);
                }else{
                    location.href = "com.wenhuayun.app://venuedetail?venueId=" + venueid;
                }
            }else{		//H5
                location.href = getFrontUrl()+"wechatVenue/venueDetailIndex.do?venueId=" + venueid;
            }
        }
    }

    $("li,p").click(function () {

        var obj = $(this).attr("urldata");
        if( typeof obj !='undefined' &&  obj.trim() != '')
        {
            obj = obj.trim();
            if(obj.substring(0,4) == 'http')
            {
                window.open(obj);
                return;
            }
            var otype = obj.substring(0,1);
            var oid = obj.substring(1);
            if(otype == 'A')
            {//活动
                toActDetail(oid);
            }
            else if(otype == 'V')
            {//场馆
                toVenueDetail(oid);
            }

        }

    });


</script>
</html>