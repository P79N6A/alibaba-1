<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <!-- <title>场馆</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    
    <script type="text/javascript">
        var userId = '${sessionScope.terminalUser.userId}';
        var latitude = 31.22;
        var longitude = 121.48;
        var appType = '${type}';
        var startIndex = 0;		//页数

        $(function () {

            //判断是否是微信浏览器打开
            if (is_weixin()) {

                //通过config接口注入权限验证配置
                wx.config({
                    debug: false,
                    appId: '${sign.appId}',
                    timestamp: '${sign.timestamp}',
                    nonceStr: '${sign.nonceStr}',
                    signature: '${sign.signature}',
                    jsApiList: ['getLocation', 'onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
                });
                wx.ready(function () {
                    wx.onMenuShareAppMessage({
                        title: "我在“文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "我在“文化云”发现一大波文化空间，快来和我一起参观吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "我在“文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在“文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在“文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.getLocation({
                        type: 'gcj02', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                        success: function (res) {
                            latitude = (res.latitude == null || res.latitude == "") ? 0 : res.latitude; // 纬度，浮点数，范围为90 ~ -90
                            longitude = (res.longitude == null || res.longitude == "") ? 0 : res.longitude; // 经度，浮点数，范围为180 ~ -180。

                            loadArea();
                            loadTag();
                            loadData(0, 20);
                        },
    	    		    fail: function (res){
    	    		    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
    	    		    	loadArea();
                            loadTag();
                            loadData(0, 20);
    	    		    }
                    });
                });
            } else {
                if (window.navigator.geolocation) {
                    var options = {enableHighAccuracy: true};
                    window.navigator.geolocation.getCurrentPosition(handleSuccess, handleError, options);
                } else {
                    dialogAlert("系统提示", "浏览器不支持html5来获取地理位置信息");
                }

                function handleSuccess(position) {
                    var lng = position.coords.longitude;
                    var lat = position.coords.latitude;
                    longitude = wgs84togcj02(lng, lat)[0];
                    latitude = wgs84togcj02(lng, lat)[1];

                    loadArea();
                    loadTag();
                    loadData(0, 20);
                }

                function handleError(error) {
                	dialogAlert("系统提示", "获取坐标失败，定位未启用");
                	loadArea();
                    loadTag();
                    loadData(0, 20);
                } 
            }
            
          	//底部菜单
			$(document).on("touchmove", function() {
				$(".footer").hide()
			}).on("touchend", function() {
				$(".footer").show()
			})
			$(".footer-menu-button").click(function() {
				if ($(".footer-menu-list").offset().left == 25) {
					$(".footer-menu-list").animate({
						"left": "630px",
					},200);
				} else {
					$(".footer-menu-list").animate({
						"left": "0px",
					},200);
				}
			})
			//回到顶部按钮显示
			$(window).scroll(function() {
				var screenheight = $(window).height() * 2
				if ($(document).scrollTop() > screenheight) {
					$(".totop").show()
				} else {
					$(".totop").hide()
				}
			})
        });

		function loadData(index, pagesize){
			//图片懒加载开始位置
        	var liCount = $("#venueList li").length;
			var venueArea = $("#nearby_val_1").val();
            var venueMood = $("#nearby_val_2").val();
            var venueType = $("#Regional_val").val();
            var sortType = $("#Sort_val").val();
            var bookType = $("#Brand_status_val").val();
			var data = {
				pageIndex:index,
				pageNum:pagesize,
				Lon: longitude,
                Lat: latitude,
                venueType:venueType,
                venueArea:venueArea,
                venueMood:venueMood,
                venueIsReserve:bookType,
                sortType:sortType
			}
			$.post("${path}/wechatVenue/wcVenueList.do",data, function (data) {
        		if(data.status==1){
        			if(data.data.length<20){
            			if(data.data.length==0&&index==0){
            				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
            			}else{
            				$("#loadingDiv").html("");
            			}
	        		}
        			$.each(data.data, function (i, dom) {
        				var venueIconUrl = getIndexImgUrl(dom.venueIconUrl, "_750_500");
        				var venueIsReserveHtml = "";
        				if(dom.venueIsReserve==2){
        					venueIsReserveHtml = "<div class='tab-right'></div>";
        				}
        				$("#venueList").append("<li onclick=\"window.location.href='${path}/wechatVenue/venueDetailIndex.do?venueId=" + dom.venueId + "'\">" +
					        						"<img class='lazy masking-down' src='${path}/STATIC/wechat/image/placeholder.png' data-original=\'" + venueIconUrl + "\'/>" +
					        						"<img src='${path}/STATIC/wechat/image/蒙板.png' class='masking' />" +
					        						venueIsReserveHtml +
					        						"<span class='tab-p1'>"+dom.venueName+"</span>" +
					        						"<span class='tab-p16'>"+dom.activityName+"</span>" +
					        						"<span class='tab-p17' style='width:660px;'>"+dom.venueAddress+"</span>" +
					        					"</li>");
        			});
        			
        			//图片懒加载
        			$("#venueList li:gt("+liCount+") img.lazy,#venueList li:eq("+liCount+") img.lazy").lazyload({
	        		    effect : "fadeIn",
	        		    effectspeed : 1000
	        		});
        		}
        	}, "json");
		}        
        
      	//加载区域
        function loadArea() {
            $.post("${path}/wechatActivity/getAllArea.do", function (data) {
                $("#areaList").append("<a data-option='' class='active'>全上海</a>");
                $("#locationList").append("<div class='list_con'></div>");
                if (data.status == 200) {
                    $.each(data.data, function (i, dom) {
                        $("#areaList").append("<a data-option=" + dom.dictCode + ">" + dom.dictName + "</a>");
                        var addressHtml = "<div class='list_con' style='display:none;'><a data-id='' data-name='" + dom.dictName + "'>全部" + dom.dictName + "</a>";
                        $.each(dom.dictList, function (i, dom2) {
                            addressHtml += "<a date-id=" + dom2.id + " data-name='" + dom2.name + "'>" + dom2.name + "</a>";
                        });
                        addressHtml += "</div>";
                        $("#locationList").append(addressHtml);
                    });

                    var lists = $(".right_list .list_con");
                    $(".nearby_tit a").click(function () {
                        var indexs = $(this).index();
                        var dataOption = $(this).attr("data-option");
                        $("#nearby_val_1").val(dataOption);
                        $(this).addClass("active").siblings().removeClass("active");
                        lists.eq(indexs).show().siblings().hide();
                        if (dataOption == '') {
                            var currParenrIndex = parseInt($("#title1").attr("data-parent"));
                            $(".right_list>.list_con").eq(currParenrIndex).find(".curr").removeClass("curr");
                            $("#nearby_val_2").val('');
                            $("#title1").html("区域")
                            $(this).parents("#div1").hide();
                            $("html,body").removeClass("bg-notouch");
                            $("#screen_ul li").find("a[tip='#div1']").removeClass("for_on");
                          	//搜索重载页面
                			reloadList();
                			$("html").css("overflow", "auto");
                            loadData(0, 20);
                        }
                    })

                    $(".right_list a").click(function () {
                        var currParenrIndex = parseInt($("#title1").attr("data-parent"));
                        $(".right_list>.list_con").eq(currParenrIndex).find(".curr").removeClass("curr");
                        var dataId = $(this).attr("date-id");
                        $("#nearby_val_2").val(dataId);
                        var dataName = $(this).attr("data-name");
                        $("#title1").html(dataName).attr("data-parent", $(this).parent().index());
                        $(this).parents("#div1").hide();
                        $("html,body").removeClass("bg-notouch");
                        $("#screen_ul li").find("a[tip='#div1']").removeClass("for_on");
                        $(this).addClass("curr");
                      	//搜索重载页面
            			reloadList();
                        $("html").css("overflow", "auto");
                    })
                }
            }, "json");
        }
        
      	//加载标签
        function loadTag() {
            $.post("${path}/wechatVenue/venueTagByType.do", function (data) {
                if (data.data.length > 0) {
                    $.each(data.data, function (i, dom) {
                        $("#typeList").append("<a date-id=" + dom.tagId + ">" + dom.tagName + "</a>");
                    });
                    
                    //分类 传值
                    $("#groups").find("a").click(function () {
                        var dataId = $(this).attr("date-id");
                        if ($(this).text() == "全部") {
                            $("#Regional_val").val("");
                            $(this).addClass("currblue");
                            $(".g_list").find(".currblue").removeClass("currblue");
                        } else {
                            $("#Regional_val").val(dataId);
                            $(".g_tit").find(".currblue").removeClass("currblue");
                        }
                        var dataName = $(this).text();
                        $("#title2").html(dataName);
                        $(this).parents("#div2").hide();
                        $("html,body").removeClass("bg-notouch");
                        $("#screen_ul li").find("a[tip='#div2']").removeClass("for_on");
                      	//搜索重载页面
            			reloadList();
                        $("html").css("overflow", "auto");
                    })
                }
            }, "json");
        };
        
        //搜索重载页面
        function reloadList(){
        	$(".bgBlack").hide();
			//重置分页
            startIndex = 0;		
        	//重置加载中
        	$("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif'/><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
			$("#venueList").html("");
			loadData(startIndex, 20);
        }
        
      	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 10)) {
            	startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
   					loadData(index, 20);
           		},200);
            }
        });
      	
      	//跳转到日历
        function preCalendar(){
        	if (is_weixin()) {
        		window.location.href = '${path}/wxUser/silentInvoke.do?type=${path}/wechatActivity/preActivityCalendar.do';
        	}else{
        		window.location.href = '${path}/wechatActivity/preActivityCalendar.do';
        	}
        }
    </script>
    
    <style>
    	html,body,.main{height:100%}
        .content {padding-top: 190px;position:relative;}
        .menu-venue {background: url(${path}/STATIC/wechat/image/menu-icon01.png) no-repeat -321px center;;}
    </style>
</head>

<body>
	<div class="main">
		<div class="header">
			<div class="index-top">
				<span class="index-top-2">场馆</span>
				<span class="index-top-3">
					<img src="${path}/STATIC/wechat/image/放大镜.png" width="38px" height="30px" onclick="window.location.href='${path}/wechatVenue/venueTagPage.do'"/>
				</span>
			</div>
			<div class="screening">
				<ul id="screen_ul">
					<li class="meishi"><a id="title1" tip="#div1">区域</a></li>
					<li class="Regional"><a id="title2" tip="#div2">分类</a></li>
					<li class="Sort"><a id="title3" tip="#div3">排序</a></li>
					<li class="Brand"><a id="title4" tip="#div4">状态</a></li>
				</ul>
				<input type="hidden" id="nearby_val_1">
				<input type="hidden" id="nearby_val_2">
				<input type="hidden" id="Regional_val">
				<input type="hidden" id="Sort_val">
				<input type="hidden" id="Brand_status_val">
			</div>

			<div>
				<div id="div1" style="display:none;">
					<div id="nearby">
						<ul class="nearby_tit" id="areaList"></ul>
						<div class="right_list" id="locationList"></div>
					</div>
				</div>

				<div id="div2" style="display:none;">
					<div id="groups">
						<div class="g_tit"><a>全部</a></div>
						<div class="g_list" id="typeList"></div>
					</div>
				</div>

				<div id="div3" style="display:none;">
					<div id="sort">
						<a date-id="1">浏览量</a>
						<a date-id="2">距离</a>
					</div>
				</div>

				<div id="div4" style="display:none;">
					<div id="brand">
						<div class="state clearfix" id="atatus_list">
							<a date-id="2">可预订</a>
							<a date-id="1">全部</a>
						</div>
						<!-- <div class="btn">
							<a id="reset_brand">重置</a>
							<a id="sure_brand">确定</a>
						</div> -->
					</div>
				</div>
			</div>
		</div>
		<div class="content padding-bottom0">
			<div class="bgBlack" style="display:none"></div>
			<div class="venue-list">
				<ul id="venueList"></ul>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
		<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
			<div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 200);"><img src="${path}/STATIC/wechat/image/totop.png" /></div>
			<div style="clear: both;"></div>
			<div class="footer-menu">
				<div class="footer-menu-list">
					<ul>
						<li><a href="${path}/wechat/index.do"><div class="menu-home"></div><p>首页</p></a></li>
						<li><a href="${path}/wechatActivity/preMap.do"><div class="menu-near"></div><p>附近</p></a></li>
						<li><a href="javascript:preCalendar();"><div class="menu-data"></div><p>日历</p></a></li>
						<li><a><div class="menu-venue"></div><p class="c7279a0">场馆</p></a></li>
						<li><a href="${path}/wechatUser/preTerminalUser.do"><div class="menu-me"></div><p>我</p></a></li>
						<div style="clear: both;"></div>
					</ul>
				</div>
			</div>
			<div class="footer-menu-button">
				<img src="${path}/STATIC/wechat/image/menu-button.png" />
			</div>
		</div>
	</div>

	<script type="text/javascript">
		//ul tab切换
		$("#screen_ul li a").click(function() {
			var tips = $(this).attr("tip");
			if ($(this).hasClass("for_on")) {
				$("html,body").removeClass("bg-notouch");
				$(this).removeClass("for_on");
				$(tips).hide();
				$(".bgBlack").hide();
				$("html").css("overflow", "auto");
			} else {
				$("html,body").addClass("bg-notouch");
				$(this).addClass("for_on");
				$(this).parent("li").siblings("li").children("a").removeClass("for_on");
				$(tips).show().siblings().hide();
				$(".bgBlack").show();
				$("html").css("overflow", "hidden");
			}
		})
		$("#groups .g_list").on("click","a",function(){
			$(this).addClass("currblue").siblings().removeClass("currblue");
		})
	    $("#sort").on("click","a",function(){
			$(this).addClass("cur").siblings().removeClass("cur");
		})
		
		//排序 传值
		$("#sort").find("a").click(function() {
			var dataId = $(this).attr("date-id");
			$("#Sort_val").val(dataId);
			var dataName = $(this).text();
			$("#title3").html(dataName);
			$(this).parents("#div3").hide();
			$("html,body").removeClass("bg-notouch");
			$("#screen_ul li").find("a[tip='#div3']").removeClass("for_on");
			//搜索重载页面
			reloadList();
			$("html").css("overflow", "auto");
		})
		
		//状态
		$("#atatus_list").find("a").click(function(){
	      if($(this).hasClass("curr")){
			   $(this).removeClass("curr");
			   $("#Brand_status_val").val("");
		  }else{
			   $(this).addClass("curr").siblings().removeClass("curr"); 
		  }
		})
		$("#atatus_list").find("a").click(function() {
			var dataId = $(this).attr("date-id");
			$("#Brand_status_val").val(dataId);
			
			//确定加载
			$(this).parents("#div4").hide();
			$("html,body").removeClass("bg-notouch");
			$("#screen_ul li").find("a[tip='#div4']").removeClass("for_on");
			//搜索重载页面
			reloadList();
			$("html").css("overflow", "auto");
		})
		/* //重置
		$("#reset_brand").click(function() {
			$("#Brand_status_val").val("");
			$(".state").find("a").removeClass("curr");
		})
		//确定new
		$("#sure_brand").click(function() {
			$(this).parents("#div4").hide();
			$("#screen_ul li").find("a[tip='#div4']").removeClass("for_on");
			//搜索重载页面
			reloadList();
			$("html").css("overflow", "auto");
		}) */
	</script>
</body>
</html>