<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title>安徽文化云</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="format-detection" content="telephone=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css?v=20170223">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpStyle.css" />
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpColorCtrl.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
	<script type="text/javascript" src="${path}/STATIC/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/swiper-3.3.1.jquery.min.js"></script>
	<script type="text/javascript">
		var module = '${module}';
		//滑屏分页
		var startIndex = 0;
		var isNext = true;
		$(function() {
			var mySwiper = new Swiper('.bpTopMenu', {
				slidesPerView: 'auto',
				spaceBetween: 20,
			})
			
			$(".bpTopMenu .swiper-slide").on('click',function(){
				$(".bpTopMenu .swiper-slide").removeClass('on')
				$(this).addClass('on')
				window.location.href="${path}/wechatChuanzhou/wxczList.do?module="+module+"&beipiaoinfoTag="+$(this).attr("id");
			});
			loadDate(startIndex,6);
		});
		
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 100)) {
            	console.log(scrollTop);
           		setTimeout(function () { 
           			if(isNext){
           				$("#loadingDiv").show();
           				startIndex += 6;
           				loadDate(startIndex, 6);
           			}else{
           				$("#loadingDivEnd").show();
           			}
           		},800);
            }
        });
		
		function loadDate(start,pageSize){
			$.post("${path}/wechatChuanzhou/loadwxazList.do?module="+module,{
				beipiaoinfoTag:$("#beipiaoinfoTag").val(),
				startIndex:start,
				pageSize:pageSize
			},function(data){
				if(data!=''){
					var count = 0;
					var li ='';
					for(var i in data){
						count += 1;
						var beipiaoinfoContent = data[i].beipiaoinfoContent;
						if(beipiaoinfoContent.length>38){
							beipiaoinfoContent = beipiaoinfoContent.substring(0,35)+"...";
						}
						li += '<li class="bpRwczListDiv"><div class="clearfix"><div class="f-left bpRwczDivImg">';
						li += '<a href="${path}/wechatChuanzhou/chuanzhouDetail.do?infoId='+data[i].beipiaoinfoId+'&module='+module+'">';
						if(data[i].beipiaoinfoShowtype=='1'){
							li += '<img src="'+data[i].beipiaoinfoHomepage+'" width="228px" height="171px"/><div class="video"></div>';
						}else{
							li += '<img src="'+data[i].beipiaoinfoHomepage+'" width="228px" height="171px"/>';
						}
						li += '</a></div>';
						li += '<div class="f-left bpRwczDivName">';
						li += '<p><a href="${path}/wechatChuanzhou/chuanzhouDetail.do?infoId='+data[i].beipiaoinfoId+'&module='+module+'">'+data[i].beipiaoinfoTitle+'</a></p>';
						li += '<p><a href="${path}/wechatChuanzhou/chuanzhouDetail.do?infoId='+data[i].beipiaoinfoId+'&module='+module+'">'+ beipiaoinfoContent +'</a></p>';
						li += '</div></div></li>';
					}
					$("#infoUl").append(li);
					isNext = true;
					if(count<6){
						$("#loadingDiv").hide();
	                	$("#loadingDivEnd").show();
					}
				}else{
					isNext = false;
					$("#loadingDiv").hide();
				}				
			})
		}
	</script>
	<style>
		html,
		body {
			height: 100%;
			background-color: #f3f3f3
		}
		
		div.main~div {
			display: none!important;
			opacity: 0;
		}
		
		body>iframe {
			opacity: 0;
			display: none!important;
		}
		
		.swiper-slide {
			width: auto;
			height: 80px;
			line-height: 80px;
			font-size: 34px;
			padding: 0 14px;
		}
		ul .bpRwczDivImg .video {
		  width: 100%;
		  height: 100%;
		  position: absolute;
		  top: 0;
		  left: 0;
		  z-index: 5;
		  background: url(${path}/STATIC/image/qy_play.png) no-repeat center center;
		}
	</style>
	</head>
	<body>
		<div class="main">
			<div class="bpHead">
				<div class="bpTopMenuDiv">
					<div class="bpTopMenu">
						<div class="swiper-wrapper">
							<div <c:if test="${empty beipiaoinfoTag}">class="swiper-slide on"</c:if>
								 <c:if test="${not empty beipiaoinfoTag}">class="swiper-slide"</c:if>
							 	id="">全部
							</div>
							<c:forEach items="${infoTagList }" var="infoTag">
								<input type="hidden" id="beipiaoinfoTag" value="${beipiaoinfoTag }" /> 
								<div <c:if test="${beipiaoinfoTag==infoTag.tagId }">class="swiper-slide on"</c:if>
									 <c:if test="${beipiaoinfoTag!=infoTag.tagId }">class="swiper-slide"</c:if>	
								 	 id="${infoTag.tagId }" >${infoTag.tagName }
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
			<div class="content padding-bottom0 margin-top20">
				<div class="bpRwczList">
					<ul id="infoUl">
					</ul>
				</div>
			</div>
			<div id="loadingDiv" class="loadingDiv"  style="text-align: center;">
		        <img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif'/>
		        <span class='loadingSpan'>加载中</span>
		    </div>
		    <div id="loadingDivEnd"  class="loadingDiv"  style="display: none">
		        <span class='loadingSpan'>没有更多数据了</span>
		    </div>
		</div>
	</body>

</html>