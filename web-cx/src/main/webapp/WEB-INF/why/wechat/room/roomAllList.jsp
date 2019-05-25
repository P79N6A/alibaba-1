<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>佛山文化云·活动室预订</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
		
		<style>
			.rotate180 {
				transform: rotate(180deg);
				-o-transform: rotate(180deg);
				-webkit-transform: rotate(180deg);
				-moz-transform: rotate(180deg);
				filter: progid: DXImageTransform.Microsoft.BasicImage(Rotation=2);
			}
		</style>
		
<script>
	//分享是否隐藏
	if(window.injs){
		//分享文案
		appShareTitle = '我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！';
		appShareDesc = '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。';
		appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
		
		injs.setAppShareButtonStatus(true);
	}
	
	//判断是否是微信浏览器打开
    if (is_weixin()) {
        //通过config接口注入权限验证配置
        wx.config({
            debug: false,
            appId: '${sign.appId}',
            timestamp: '${sign.timestamp}',
            nonceStr: '${sign.nonceStr}',
            signature: '${sign.signature}',
            jsApiList: ['onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
        });
        wx.ready(function () {
            wx.onMenuShareAppMessage({
                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
            });
            wx.onMenuShareTimeline({
                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
            });
            wx.onMenuShareQQ({
                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
            });
            wx.onMenuShareWeibo({
                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
            });
            wx.onMenuShareQZone({
                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
            });
        });
    }
	
	$(function(){
		
		//下拉菜单
		$(".activeroom-list>ul>li").click(function() {
			
			$(".activeroom-list>ul>li").find("img").removeClass('rotate180')
			$(this).find("img").addClass('rotate180')
			$(".activeroom-list-bg").show()
			$(".activeroom-list-menu>ul>li").hide()
			$(".activeroom-list-menu>ul>li").eq($(this).index()).show()

		})
		$(".activeroom-list-bg").click(function() {
			$(".activeroom-list-bg").hide()
			$(".activeroom-list-menu>ul>li").hide()
		})

		$(".activeroom-tab1").on('click','ul>li>div',function() {
			$(".activeroom-tab1>ul>li>div").removeClass("topic-tag-bg")
			$(this).addClass("topic-tag-bg")
			$(".activeroom-list-bg").hide()
			$(".activeroom-list-menu>ul>li").hide()
			search()
		})
		
		$(".activeroom-tab2").on('click','ul>li>div',function() {
			$(".activeroom-tab2>ul>li>div").removeClass("topic-tag-bg")
			$(this).addClass("topic-tag-bg")
			$(".activeroom-list-bg").hide()
			$(".activeroom-list-menu>ul>li").hide()
			search()
		})
		
		$(".activeroom-tab3").on('click','ul>li>div',function() {
			$(".activeroom-tab3>ul>li>div").removeClass("topic-tag-bg")
			$(this).addClass("topic-tag-bg")
			$(".activeroom-list-bg").hide()
			$(".activeroom-list-menu>ul>li").hide()
			search()
		})

		//下拉菜单标签选中样式
		$(".check-more").on('click','ul>li>div',function() {
			$(this).toggleClass("topic-tag-bg")
		})
		$(".checkall").click(function() {
			if($(".checkall").hasClass("topic-tag-bg")) {
				$(this).removeClass("topic-tag-bg")
				$(".activeroom-list-menu-tab>ul>li>div").removeClass("topic-tag-bg")
			} else {
				$(this).addClass("topic-tag-bg")
				$(".activeroom-list-menu-tab>ul>li>div").addClass("topic-tag-bg")
			}
		})
		
		$(".checksure").click(function() {
			$(".activeroom-list-bg").hide()
			$(".activeroom-list-menu>ul>li").hide()
			search()
		});
		
		//活动室标签
        $.post("${path}/tag/getChildTagByType.do?code=ROOM_TAG", function(data) {
            var list = eval(data);
            var tagHtml = '';
            for (var i = list.length-1; i >=0; i--) {
                var obj = list[i];
                var tagId = obj.tagId;
                var tagName = obj.tagName;
               
                tagHtml += '<li tagId=\"'
                + tagId + '\">' +'<div>'+ tagName
                + '</div></li>';
            }
            $("#roomTagLabel").prepend(tagHtml);
        });
		
		 // 配套设施
        $.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=ROOM_FACILITY", function(data) {
            var list = eval(data);
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                var dictId = obj.dictId;
                var dictName = obj.dictName;
                $("#roomFacilityDictLabel").prepend('<li dictId="'+dictId+'"><div>'+dictName+'</div></li>');
            }
            
         
        });
			
	        var startIndex = 0;		//页数
			
			loadData(startIndex, 10);
			
			   //滑屏分页
	        $(window).on("scroll", function () {
	            var scrollTop = $(document).scrollTop();
	            var pageHeight = $(document).height();
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight - 100)) {
	           		startIndex += 10;
	           		var index = startIndex;
	           		setTimeout(function () { 
	           			$("#loadingDiv").show();
	   					loadData(index, 10);
	           		},200);
	            }
	        });
	});
	
	function initLoadingDiv(){
		$("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif' /><span  class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
		$("#loadingDiv").show();
	}
	
	function search(){
		
		$($(".keep-list ul").get(0)).html("")
		initLoadingDiv();
		startIndex=0
		loadData(startIndex, 10);
	}
	
	function searchData(){
		
		var data=new Array();
		
		// 用途
		$(".activeroom-tab1").find(".topic-tag-bg").each(function () {
			
			var tagId=$(this).parent().attr("tagId");
			data.push({'name':'roomTag','value':tagId});
		});
		
		// 面积
		$(".activeroom-tab2").find(".topic-tag-bg").each(function () {
			
			var roomAreaType=$(this).parent().attr("roomAreaType");
			
			if(roomAreaType)
				data.push({'name':'roomAreaType','value':roomAreaType});
		});
		
		// 人数
		$(".activeroom-tab3").find(".topic-tag-bg").each(function () {
			
			var roomCapacityType=$(this).parent().attr("roomCapacityType");
			
			if(roomCapacityType)
				data.push({'name':'roomCapacityType','value':roomCapacityType});
		});
		
		// 设备
		$(".check-more").find(".topic-tag-bg").each(function () {
			
			var dictId=$(this).parent().attr("dictId");
			data.push({'name':'roomFacility','value':dictId});
		});
		
		return data;
	}
	
	  function loadData(index, pagesize) {
		  
		  var data= searchData();
		  
		  data.push({'name':'pageIndex','value':index});
		  data.push({'name':'pageNum','value':pagesize});
		  
		  $.post("${path}/wechatRoom/queryRoomAllList.do",data, function (data) {
		  
			if(data.status==1)
			{
				var roomList=data.data;
				
				if(roomList.length<10){
	      			if(roomList.length==0&&index==0){
	      				$("#loadingDiv").html("<span class='loadingSpan' style='padding-left:210px;'>没有数据</span>");
	      			}else{
	      				$("#loadingDiv").html("");
	      			}
	      		}
				else
				{
					$("#loadingDiv").hide();
				}
				
				
				$.each(roomList, function (i, dom) {
					
					var tagNames="";
					
					var roomTags = dom.roomTagName.split(",");
					$.each(roomTags,function(i,roomTag){
						
						if(i<2)
						if(roomTag){
							if(i==0)
								tagNames+="<li class='margin-right10'>"+roomTag+"</li>";
							else
								tagNames+="<li>"+roomTag+"</li>";
						}
						
					});
					
					var roomPicUrl=dom.roomPicUrl;
					
					if(roomPicUrl)
						roomPicUrl=getIndexImgUrl(roomPicUrl, "_300_300");
					
					var li='<li>'+
						"<div class='keep-list-p'  onclick='showRoom(\"" + dom.roomId + "\")'>" +
							"<div class='keep-list-img'>"+
								"<img src='"+roomPicUrl+"' width='270' height='170'   />"+
							"</div>"+
							"<div class='f-left room-place'>"+
								"<p class='room-place-title'>"+dom.roomName+"</p>"+
								"<p class='room-place-m' onclick='preAddressMap();'>"+dom.venueName+"</p>"+
								"<div class='room-place-tab'>"+
									"<ul>"+
									tagNames+
								"<div style='clear: both;'></div>"+
									"</ul>"+
								"</div>"+
								"<p class='room-place-content'>面积：<span>"+dom.roomArea+"</span>&nbsp;&nbsp;&nbsp;&nbsp;人数：<span>"+dom.roomCapacity+"</span></p>"+
									"</div>"+
									"<div style='clear: both;'></div>"+
								"</div>"+
							"</li>";
				
      				
				$($(".keep-list ul").get(0)).append(li);
      			});
			}
			else
			{
				 dialogAlert("提示", data.data);
			}
			
		  }, "json")
	  };
	  
	  function showRoom(roomId){
    	if (window.injs) {		//APP端
       		injs.accessAppPage(3,roomId); 
       	}else{
       		location.href='${path}/wechatRoom/preRoomDetail.do?roomId='+roomId;
       	}
	  }
	  
</script>

<style>
	html,body{
   		height: 100%;
   		background-color: #f3f3f3;
   	}
</style>
</head>
<body>
	<div class="main">
		<div class="header">
			<%-- <div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
				</span>
				<span class="index-top-2">活动室预定</span>
			</div> --%>
			<div class="activeroom-list" >
				<ul>
					<li>
						<div>
							<div class="activeroom-list-button">
								<p class="f-left">用途</p>
								<img class="f-left" src="${path}/STATIC/image/activeroom-arrow.png" />
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<div class="activeroom-list-button">
								<p class="f-left">面积</p>
								<img class="f-left" src="${path}/STATIC/image/activeroom-arrow.png" />
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<div class="activeroom-list-button">
								<p class="f-left">活动人数</p>
								<img class="f-left" src="${path}/STATIC/image/activeroom-arrow.png" />
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div style="border: none;">
							<div class="activeroom-list-button">
								<p class="f-left">配套设施</p>
								<img class="f-left" src="${path}/STATIC/image/activeroom-arrow.png" />
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
			<div class="activeroom-list-menu" >
				<ul>
					<li>
						<div class="activeroom-list-menu-tab activeroom-tab1">
							<ul id="roomTagLabel" >
								
								<li>
									<div class="topic-tag-bg">不限</div>
								</li>
								<div style="clear: both;"></div>
							</ul>
						</div>
					</li>
					<li>
						<div class="activeroom-list-menu-tab activeroom-tab2">
							<ul>
								<li roomAreaType="1">
									<div>0-20</div>
								</li>
								<li roomAreaType="2">
									<div>20-40</div>
								</li>
								<li roomAreaType="3">
									<div>40-60</div>
								</li>
								<li roomAreaType="4">
									<div>60-100</div>
								</li>
								<li roomAreaType="5">
									<div>100以上</div>
								</li>
								<li>
									<div class="topic-tag-bg">不限</div>
								</li>
								<div style="clear: both;"></div>
							</ul>
							<div class="tab-tip">
								<p>单位：m²</p>
							</div>
						</div>
					</li>
					<li>
						<div class="activeroom-list-menu-tab activeroom-tab3">
							<ul>
								<li roomCapacityType="1">
									<div>0-20</div>
								</li>
								<li roomCapacityType="2">
									<div>20-40</div>
								</li>
								<li roomCapacityType="3">
									<div>40-60</div>
								</li>
								<li roomCapacityType="4">
									<div>60-100</div>
								</li>
								<li roomCapacityType="5">
									<div>100-200</div>
								</li>
								<li>
									<div class="topic-tag-bg">不限</div>
								</li>
								<div style="clear: both;"></div>
							</ul>
							<div class="tab-tip">
								<p>单位：人</p>
							</div>
						</div>
					</li>
					<li>
						<div class="activeroom-list-menu-tab check-more">
							<ul id="roomFacilityDictLabel">
							
								<div style="clear: both;"></div>
							</ul>
						</div>
						<div style="border: none;">
							<div class="checkall f-left">全选</div>
							<div class="checksure f-right">确定</div>
							<div style="clear: both;"></div>
						</div>
					</li> 
				</ul>
			</div>
		</div>
		<div class="activeroom-list-bg" style="background: url(${path}/STATIC/image/500.png);width: 100%;height: 100%;position: fixed;z-index: 90;display: none;"></div>
		<div class="content padding-bottom0" style="padding-top: 100px!important;">
			<div class="keep-list">
				<ul >
					
				</ul>
			</div>
		</div>
		<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span  class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	</div>
</body>
</html>