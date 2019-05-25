<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>文化活动</title>
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon"
          mce_href="${path}/STATIC/image/favicon.ico">
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/index/index/frontIndex.js?version=20160513"></script>
    <script type="text/javascript" src="${path}/STATIC/js/location.js"></script>

    <!--移动端版本兼容 -->
    <script type="text/javascript">
        var phoneWidth = parseInt(window.screen.width);
        var phoneScale = phoneWidth / 1200;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if (version > 2.3) {
                document.write('<meta name="viewport" content="width=1200, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
            } else {
                document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
        }
    </script>
    <!--移动端版本兼容 end -->
    
    <script>
    	$(function () {
            $("#pageName").html("所在位置：文化活动");
    		loadArea();
            collect();
    	})
    	//加载区域
	    function loadArea(){
    	    // debugger
			var provinceNo = '${provinceNo}';
	   	 	var cityNo = '${cityNo}';
			var loc = new Location();
			var area = loc.find('0,' + provinceNo + ',' + cityNo);
	        $.each(area , function(k , v) {
	            $('#areaUl').append("<li id="+k+"><a href='javascript:clickArea(\""+k+"\");'>"+v+"</a></li>");
			});
		}


        //点击收藏
        function collect() {
            $('.ul_list').on('click','.collect a',function () {
                if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
                    dialogAlert("提示", "登录之后才能收藏");
                    return;
                }
                var obj =  $(this);
                var activityId = obj.attr('data-id');
                if($(this).hasClass('collected')){
                    $.ajax({
                        type: 'POST',
                        dataType: "json",
                        url: "${path}/collect/deleteUserCollect.do?relateId="+activityId+"&type=2",//请求的action路径
                        error: function () {//请求失败处理函数
                        },
                        success: function (data) { //请求成功后处理函数。
                            obj.removeClass("collected");
                        }
                    });
                }else{
                    $.ajax({
                        type: 'POST',
                        dataType: "json",
                        url: "${path}/cmsTypeUser/activitySave.do?activityId="+activityId+"&operateType=3",//请求的action路径
                        error: function () {//请求失败处理函数
                        },
                        success: function (data) { //请求成功后处理函数。
                            obj.addClass("collected");
                        }
                    });
                }
            })
        }

    	//加载区域
	    /* function loadArea(){
			var provinceNo = '${provinceNo}';
	   	 	var cityNo = '${cityNo}';
            clickArea(cityNo);
		} */
    </script>
</head>
<body class="body">
<!-- 导入头部文件 -->
	<div class="header">
	<%@include file="../header.jsp" %>
	</div>
<!--banner_recommond start-->
<form action="" id="indexForm" method="post">
    <!--banner_recommond end-->
    <input type="hidden" name="activityType" id="activityType"/>
    <input type="hidden" name="activityName" id="activityName" value="${activityName}"/>
    <input type="hidden" name="page" id="page"/>
    <div id="in_search">
        <div class="in_search">
            <div class="prop-attrs prop-attrs-type">
                <div class="attr">
                    <div class="attrKey">类型：</div>
                    <div class="attrValue" id="activitySearchType">
                        <ul class="av_list">
                        </ul>
                    </div>
                    <a class="btn-icon">收起</a>
                </div>
            </div>
            <div class="prop-attrs prop-attrs-area" id="prop-attrs-area" style="display: block" >
                <input type="hidden" name="activityLocation" id="activityLocation" value=""/>
                <div class="attr">
                    <div class="attrKey">区域：</div>
                    <input type="hidden" name="activityArea" id="areaCode" value=""/>
                    <div class="attrValue attr-collapse" id="attr-area">
                        <ul class="av_list" id="areaUl">
                            <li class="cur"><a href="javascript:clickArea('');">全部</a></li>
                        </ul>
                        <ul class="av_list" id="businessDiv">
                        </ul>
                    </div>
                </div>
                <div class="prop-attrs prop-attrs-other">
                    <div class="attr">
                        <div class="attrKey" style="margin-top:12px; ">时间：</div>
                        <div class="attrValue">
                            <input type="hidden" name="chooseType" id="chooseType"/>
                            <ul class="av_list">
                                <li class="cur"><a href="javascript:setValueById('chooseType','');">不限</a></li>
                                <li><a href="javascript:setValueById('chooseType','1');">5天内</a></li>
                                <li><a href="javascript:setValueById('chooseType','2');">5-10天</a></li>
                                <li><a href="javascript:setValueById('chooseType','3');">10-15天</a></li>
                                <li><a href="javascript:setValueById('chooseType','4');">15天以上</a></li>
                            </ul>
                        </div>
                    </div>
                    <%--<div class="attr">--%>
                        <%--<input type="hidden" name="isWeekend" id="isWeekend"/>--%>
                        <%--<div class="attrKey">其他：</div>--%>
                        <%--<div class="attrValue">--%>
                            <%--<ul class="av_list">--%>
                                <%--<li class="cur"><a href="javascript:setValueById('isWeekend','');">不限</a></li>--%>
                                <%--<li><a href="javascript:setValueById('isWeekend','0');">工作日</a></li>--%>
                                <%--<li><a href="javascript:setValueById('isWeekend','1');">周末</a></li>--%>
                            <%--</ul>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                    <div class="attr">
                        <input type="hidden" name="bookType" id="bookType"/>
                        <div class="attrKey">状态：</div>
                        <div class="attrValue">
                            <ul class="av_list">
                                <li class="cur"><a href="javascript:setValueById('bookType','');">不限</a></li>
                                <li><a href="javascript:setValueById('bookType','1');">需要预订</a></li>
                                <li><a href="javascript:setValueById('bookType','0');">直接前往</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--list start-->
    <div id="hot_list">
        <!--tit start-->
        <div class="tit clearfix">
            <input type="hidden" name="sortType" id="sortType" value=""/>
            <div class="tit_l fl">
                <a href="javascript:setValueById('sortType','');" class="cur">智能排序</a>
                <a href="javascript:setValueById('sortType','2');">即将开始</a>
                <a href="javascript:setValueById('sortType','3');">即将结束</a>
                <a href="javascript:setValueById('sortType','4');">最新发布</a>
                <a href="javascript:setValueById('sortType','5');">人气最高</a>
            </div>
            <div class="tit_r fr">
                <label><%--<input type="checkbox" /><span>只显示未订光的</span>--%></label>
            </div>
        </div>
        <!--tit end-->
        <!--list start-->
        <div class="ul_list" id="activityListDivChild" style="padding-bottom: 0px;">
            <ul class="hl_list clearfix">
            </ul>
            <%-- <div id="Sweep" class="clearfix">
                <div class="s_img fl"><img src="${path}/STATIC/image/why_ss.png" width="151" height="152"/></div>
                <div class="s_app fl">
                    <p>浏览更多内容,请下载文化云APP</p>
                    <a class="ios">IOS 下载</a>
                    <a class="android">安卓 下载</a>
                </div>
            </div> --%>
        </div>

    </div>
    <!--list end-->
    <div id="kkpager" width:750px;margin:10 auto;></div>
</form>
<!--feet start-->
<%@include file="/WEB-INF/why/index/footer.jsp" %>
<!--list end-->
<script>
    var _hmt = _hmt || [];
    (function () {
        var hm = document.createElement("script");
        hm.src = "//hm.baidu.com/hm.js?eec797acd6a9a249946ec421c96aafeb";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
<%-- 
<a class="cd-top"><img src="${path}/STATIC/image/hp_toparrow.png" width="40" height="40"/></a>
<a style="visibility: hidden"><img alt="文化云" src="${path}/STATIC/image/baiduLogo.png" width="121" height="75"/></a> --%>
</body>
</html>
