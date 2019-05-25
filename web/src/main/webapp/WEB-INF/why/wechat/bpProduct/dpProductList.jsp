<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title>安康文化云</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="format-detection" content="telephone=no" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />
	
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
	<%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
	<script type="text/javascript">
	//滑屏分页
	var startIndex = 0;
	var pageSize=5;
	var p=0;
	var isNext = true;
	//首行菜单
	$(function() {
			$.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=PRODUCT_MODULE", function(data) {
				
	            var list = eval(data);
	            for (var i = 0; i < list.length; i++) {
	                var obj = list[i];
	                var dictId = obj.dictId;
	                var dictName = obj.dictName;
	                if(i==0){
	               	 	$(".swiper-wrapper").append('<div class="swiper-slide cur" id="'+dictId+'"><span>'+dictName+'</span></div>');
	               	 	$("#productModule").val(dictId);
	                }else{
	                	$(".swiper-wrapper").append('<div class="swiper-slide" id="'+dictId+'"><span>'+dictName+'</span></div>');
	                }
	            }
	            loadDate(startIndex, pageSize);
	            
				var dwList = new Swiper('.dwList', {
			        slidesPerView: 'auto',
			        spaceBetween: 0
			    });
			    $('.dwList').on('click', '.swiper-slide', function () {
			    	$(this).parent().find('.swiper-slide').removeClass('cur');
			    	$(this).addClass('cur');
			    	$("#productModule").val($(this).attr("id"));
			    	startIndex = 0;
			    	$("#index_list").empty();
			    	loadDate(startIndex, pageSize);
			    });
			})
	})

		
		
		function loadDate(si,ps){
			$("#loadingDiv").show();
			var li ='';
			$.post("${path}/wechatBpProduct/productList.do",{
				productModule:$("#productModule").val(),
				startIndex:si,
				pageSize:ps
			},function(data){
               	 if(data.length>0){
               		$.each(data, function (i, dom) {
   					 li += "<li onclick='goinfo(\""+dom.productId+"\")'>"+
   							 "<div class='activeList'>"+
   							  "<img src='"+dom.productIconUrl+"' width='750' height='475' style='display: block;'>"+
   							  "<div class='bpBooked'>预订</div>"+
   							 "</div>"+
   							 "<p class='activeTitle'>"+dom.productName+"</p>"+
   							 "<p class='bpInfo'>"+dom.productInfo+"</p>"
   							"<li>"
   				 	});
   				
   					$("#index_list").append(li);
   					$("#loadingDiv").hide();
   					startIndex += pageSize;
   				  	isNext = true;
					}else{
						$("#loadingDiv").hide();
						isNext = false;
					}
				 
				
			}, 'json') 
			
		}
		
		//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight-60)) {
            	console.log(scrollTop);
            	$("#loadingDiv").show();
           		setTimeout(function () { 
           			if(isNext){
           				loadDate(startIndex, pageSize);
           			}else
           				$("#loadingDiv").hide();            			
           		},1000);
            }
        });
        function goinfo(pid){
        	window.location.href="${path}/wechatBpProduct/preProductDetail.do?productId="+pid;
        }
		
	</script>
	
	<style>
			body{
				background-color: #f3f3f3;
			}
			.activeUl>li{
				margin-bottom: 20px;
			}
	</style>
	
	</head>
	<body>
		<input type="hidden" id="productModule" value="${productModule }" /> 
		
		<div class="shoppingMain">
			<div class="dwListWc">
				<div class="dwList swiper-container">
			        <div class="swiper-wrapper"></div>
			   </div>
		   </div>
		   <ul id="index_list" class="activeUl">
				
			</ul>
			<div id="loadingDiv" class="loadingDiv" ><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" />
				<span class="loadingSpan">加载中。。。</span>
				<div style="clear:both"></div>
			</div>
		</div>
	
	</body>

</html>