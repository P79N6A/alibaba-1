<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>文化点单</title>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/style.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
	<script type="text/javascript" src="${path}/STATIC/js/jquery-1.9.0.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.1.js" ></script>
    
    <script>
    	var pageIndex = 1;
    	var userId = '${sessionScope.terminalUser.userId}';
    	var noData = false;
    	var loadDataLock = true;
    	
    	$(function () {
    		$("#culturalOrderIndex").addClass('cur').siblings().removeClass('cur');
    		loadServiceType();
    		loadArea();
    		loadTarget();
    		setSortType();
    		coverFilters();
    		loadData();
    		
    		$("#orderAreaDiv").on("click", ".item", function () {
    			$(this).addClass("on").siblings().removeClass('on');
        		$("#culturalOrderArea").val($(this).attr("value") + ',' + $(this).html());
        		$("#orderTownDiv").html("");
        		$("#culturalOrderTown").val('');
        		if($(this).attr("value") == null || $(this).attr("value") == ''){
        			$("#culturalOrderUl").html('');
        			$("#culturalOrderArea").val('');
        			pageIndex = 1;
        			$("#pageIndex").val(pageIndex);
        			noData = false;
        			loadDataLock = false;
	        		loadData();
	        		$(".erjiList").hide();
	        		return;
        		}
        		loadTown($(this).attr("value"));
        		$("#culturalOrderUl").html('');
        		pageIndex = 1;
    			$("#pageIndex").val(pageIndex);
    			noData = false;
    			loadDataLock = false;
        		loadData();
    	    });
    		
    		$("#orderTownDiv").on("click", ".item", function () {
    			$(this).addClass("on").siblings().removeClass('on');
        		$("#culturalOrderTown").val($(this).attr("value"));
        		$("#culturalOrderUl").html('');
        		pageIndex = 1;
    			$("#pageIndex").val(pageIndex);
    			noData = false;
    			loadDataLock = false;
        		loadData();
    	    });
    		
    		var _hmt = _hmt || [];
    	    (function () {
    	        var hm = document.createElement("script");
    	        hm.src = "//hm.baidu.com/hm.js?eec797acd6a9a249946ec421c96aafeb";
    	        var s = document.getElementsByTagName("script")[0];
    	        s.parentNode.insertBefore(hm, s);
    	    })();
    	})
    	
    	//首页活动加载
        function loadData() {
        	//图片懒加载开始位置
        	$(".null_result").remove();
        	var liCount = $("#culturalOrderUl li").length;
       		$.post("${path}/culturalOrder/culturalOrderList.do", $("#indexForm").serialize(), function (result) {
       			var rsObj = jQuery.parseJSON(result);
	            var data = rsObj.list;
	            if(data.length<12){
           			if((data.length == 0 && pageIndex == 1) || noData){
           				noData = true;
           				if($(".null_result").length < 1){
           					$('<div class="null_result"><div class="cont"><h2>抱歉，没有找到相关结果</h2><p>您可以修改搜索条件重新尝试</p></div></div>').insertBefore("#culturalOrderUl");
           				}
           				return false;
           			}
        		}
        		var str = "";
        		$.each(data, function (i, dom) {
        			var serviceDate = "";
                    if(dom.startDateStr != null && dom.startDateStr != '' && dom.endDateStr != null && dom.endDateStr != ''){
	                    if(dom.startDateStr == dom.endDateStr){
	                    	serviceDate = dom.startDateStr;
	                    }else{
	                    	serviceDate = dom.startDateStr + " 至 " + dom.endDateStr;
	                    }
                    }
                    var limitAreaArr = dom.culturalOrderAreaLimit.split(',');
                    var limitArea = limitAreaArr[1];
					str += '<li class="qyItem" style="height: 303px;">';
                    str += '  <div class="pic">';
                    str += '    <a target="_blank" href="javascript:void(0);" onclick="showOrderDetail(\'' + dom.culturalOrderId + '\')"><img src="' + dom.culturalOrderImg + '" width="280" height="185" /></a>';
                    str += '  </div>';
                    str += '  <div class="char">';
                    str += '    <a target="_blank" href="javascript:void(0);" onclick="showOrderDetail(\'' + dom.culturalOrderId + '\')">' + dom.culturalOrderName + '</a>';
                    str += '    <p class="info info-1">服务日期：' + serviceDate + '</p>';
                    str += '    <p class="info info-1">服务地点： ' + limitArea + '</p>';
                    str += '  </div>';
                    str += '</li>';
        		});
        		$("#culturalOrderUl").append(str);
        		loadDataLock = true;
        	}, "json");
        }
    	
		//滑屏分页
		
	   	$(window).on("scroll", function () {
	            var scrollTop = $(document).scrollTop();
	            var pageHeight = $(document).height();
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight - 20)) {
	           	 	if(loadDataLock){
						loadDataLock = false;
		          		pageIndex += 1;
		          		$("#pageIndex").val(pageIndex);
		          		setTimeout(function () { 
		          			loadData();
		          		},400);
	           	 	}
	            }
	        });
		
    	//加载区域
	    function loadArea(){
   		 	var venueProvince = '2822,广东省';
   		    var venueCity = '2958,佛山市';
   		 	var loc = new Location();
   	    	var json = loc.find( '0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
   	    	if (json){
   	    		$.each(json , function(k , v) {
   	    			$('#orderAreaDiv').append('<div class="item" value="' + k + '">' + v + '</div>');
   	    		})
   	    	};
		}
    	
    	//加载服务对象
    	function loadTarget(){
    		$("#serviceTargetDiv").on("click", ".item", function () {
    			$(this).addClass("on").siblings().removeClass('on');
        		$("#culturalOrderDemandLimit").val($(this).attr("value"));
        		$("#culturalOrderUl").html('');
        		pageIndex = 1;
    			$("#pageIndex").val(pageIndex);
    			noData = false;
    			loadDataLock = false;
        		loadData();
    	    });
    	}
    	
    	//加载服务类型
    	function loadServiceType(){
    		$.ajax({
    	        type: "POST",
    	        url: "${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=CULTURAL_ORDER_TYPE",
    	        data: {},
    	        dataType: "json",
    	        success: function(data){
    	            for (var i=0;i<data.length;i++){
    	              $('#serviceTypeDiv').append("<div class='item' value='"+ data[i].dictId +"'>"+data[i].dictName+"</li>");
    	            }
    	            $("#serviceTypeDiv").on("click", ".item", function () {
    	    			$(this).addClass("on").siblings().removeClass('on');
    	        		$("#culturalOrderType").val($(this).attr("value"));
    	        		$("#culturalOrderUl").html('');
    	        		pageIndex = 1;
            			$("#pageIndex").val(pageIndex);
            			noData = false;
            			loadDataLock = false;
    	        		loadData();
    	    	    });
    	        }
    	    });
    	}
    	
    	//加载街道镇
    	function loadTown(code){
    		$.post("${path}/sysdict/queryChildSysDictByDictCode.do", {dictCode: code}, function (data) {
    	        var list = eval(data);
    	        var dictHtml = '';
    	        var otherHtml = '';
    	        $("#orderTownDiv").append('<div class="item on" value="">不限</div>');
    	        for (var i = 0; i < list.length; i++) {
    	            var obj = list[i];
    	            var dictId = obj.dictId;
    	            var dictName = obj.dictName;
    	            $("#orderTownDiv").append('<div class="item" value="' + dictId + '">' + dictName + '</div>');
    	        }
    	        $(".erjiList").show();
    	    });
    	}
    	
    	function setSortType(){
    		$("#sortTypeDiv").on("click", ".item", function () {
    			$(this).addClass("on").siblings().removeClass('on');
        		$("#culturalOrderSortType").val($(this).attr("value"));
        		$("#culturalOrderUl").html('');
        		pageIndex = 1;
    			$("#pageIndex").val(pageIndex);
    			noData = false;
    			loadDataLock = false;
        		loadData();
    	    });
    	}
    	
    	function showListByLargeType(largeType){
    		window.location.href = "${path}/culturalOrder/showCulturalOrderIndexByLargeType.do?largeType=" + largeType;
    	}
    	
    	function showOrderDetail(id){
    		window.location.href = '${path}/culturalOrder/culturalOrderDetail.do?culturalOrderId=' + id + '&culturalOrderLargeType=2&userId=' + userId;
    	}
  
		function coverFilters(){
			$('.shaiChooseWrap .btn-icon').on('click', function () {
				if($(this).hasClass('open')) {
					$(this).removeClass('open');
					$(this).html('收起');
					$('.shaiChooseWrap-area').show();
				} else {
					$(this).addClass('open');
					$(this).html('展开');
					$('.shaiChooseWrap-area').hide();
				}
			});
			$('.wukList, .kuangList').on('click', '.item', function () {
				$(this).addClass('on').siblings().removeClass('on');
				if($(this).index() == 0) {
					$(this).parent().siblings('.erjiList').hide();
					return;
				}
				$(this).parent().siblings('.erjiList').show();
			});
		}

		/*  end  头部js  */
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
    <input type="hidden" name="pageIndex" id="pageIndex" value="1"/>
    <input type="hidden" name="culturalOrderLargeType" id="culturalOrderLargeType" value="2"/>
    <input type="hidden" name="culturalOrderType" id="culturalOrderType" />
    <input type="hidden" name="culturalOrderArea" id="culturalOrderArea" />
    <input type="hidden" name="culturalOrderTown" id="culturalOrderTown" />
    <input type="hidden" name="culturalOrderDemandLimit" id="culturalOrderDemandLimit" />
    <input type="hidden" name="culturalOrderSortType" id="culturalOrderSortType" value="1"/>
    <!-- filter start -->
    <div class="shaiChooseBox">
		<div class="aqBread">
	        <div class="breadTag"><a href="javascript:void(0)" onclick="showListByLargeType(1)">我要参与</a></div>
	        <em style="display: inline-block;margin: 0 24px;color: #e3e3e3;font-size: 18px">|</em>
	        <div class="breadTag cur"><a href="javascript:void(0)" onclick="showListByLargeType(2)">我要邀请</a></div>
	    </div>
	    <div class="shaiChooseWrap clearfix">
	    	<div class="lab">服务类型：</div>
	    	<div class="kuangList clearfix" id="serviceTypeDiv">
	    		<div class="item on" value="">不限</div>
	    	</div>
	    	<a class="btn-icon" href="javascript:;">收起</a>
	    </div>
	    <div class="shaiChooseWrap-area">
		    <div class="shaiChooseWrap clearfix">
		    	<div class="lab">所在区域：</div>
		    	<div class="wukList clearfix" id="orderAreaDiv">
		    		<div class="item on" value="">不限</div>
		    	</div>
		    	
		    	<div class="erjiList" style="display: none;">
		    		<div class="wukList clearfix" style="width: auto;float: none;" id="orderTownDiv">
			    	</div>
		    	</div>
		    </div>
		    
		    <div class="shaiChooseWrap clearfix">
		    	<div class="lab">服务对象：</div>
		    	<div class="kuangList clearfix" id="serviceTargetDiv">
		    		<div class="item on" value="">不限</div>
		    		<div class="item" value="1">个人</div>
		    		<div class="item" value="2">机构</div>
		    	</div>
		    </div>
		    
		    <div class="shaiChooseWrap clearfix">
		    	<div class="lab">排序：</div>
		    	<div class="kuangList clearfix" id="sortTypeDiv">
		    		<div class="item on" value="1">最新发布</div>
		    		<div class="item" value="2">邀请次数</div>
		    	</div>
		    </div>
	    </div>
	</div>
    <!-- filter end -->

    <!--list start-->
    <div id="culturelist">
		<div class="jzCenter" style="overflow: hidden;padding-bottom: 80px;">
		<ul id="culturalOrderUl" class="unionUlList unionUlList-si clearfix" style="width: 1230px;">
		</ul>
	</div>
    </div>
    <!--list end-->
    <div id="kkpager" width:750px;margin:10 auto;></div>
</form>
<!--feet start-->
<%@include file="/WEB-INF/why/index/footer.jsp" %>
<!--list end-->

</body>
</html>
