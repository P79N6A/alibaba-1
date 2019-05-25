<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8"/>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>

		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>

		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
		<%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css"/>--%>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
		<title>安康文化云</title>
		<script type="text/javascript">
			var userId = '${sessionScope.terminalUser.userId}';
			var startIndex = 0;	
			var isNext = true;
			var pageSize=5;
			 $(function () {
				 loadBpAntiqueList(startIndex, pageSize);

		        });

			 function loadBpAntiqueList(index, pagesize){
				 $("#loadingDiv").show();
				 var data = {
			                pageIndex: startIndex,
			                pageNum: pageSize
			            };	
				 var content='';
					$.post("${path}/wechatBpAntique/antiqueList.do",data, function (data) {
						if (data.data.length > 0) {		                	  
							 $.each(data.data, function (i, dom) {
								 var imgs=new Array();
								 var antiqueInfo = dom.antiqueInfo;
						          if(antiqueInfo.length>20){
						        	  antiqueInfo = antiqueInfo.substring(0,17)+"...";
						          }
								 imgs=dom.antiqueImgUrl.split(",");
								 content += "<li>"+
												"<div class='wenwu-list'>"+
												 "<a href='${path}/wechatBpAntique/preAntiqueDetail.do?antiqueId="+dom.antiqueId+"&type=21'>"+
														"<div class='wenwu-title'>"+
															"<p>"+dom.antiqueName+"</p>"+
															"<div class='bpshpTag'><span>"+dom.antiqueDynasty+"</span><span>"+dom.antiqueType+"</span></div>"+
																	"<div style='clear: both;'></div>"+
															"</div>"+
															"<div class='wenwu-img'>"+
															"<div class='wenwu-imgl'>"+
																"<img src='"+imgs[0]+"' width='480' height='365'>"+
															"</div>"+	
															"<div class='wenwu-imgr'>"+
																"<div>"+
																	"<img src='"+imgs[1]+"' width='240' height='180'>"+
																"</div>"+
																"<div>"+
																	"<img src='"+imgs[2]+"' width='240' height='180'>"+
																"</div>"+
															"</div>"+
															"<div style='clear: both;'></div>"+
														"</div>"+
														"<p>"+antiqueInfo+"</p>"+
													"</a>"+
												"</div>"+
											  "</li>";			
								 
		                     });
							 $(".wenwuList ul").append(content);
							 $("#loadingDiv").hide();
					   		 startIndex = (parseInt(index) + pagesize);
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
	            if (scrollTop >= (pageHeight - winHeight)-100) {
	            	$("#loadingDiv").show();
	           		setTimeout(function () { 
	           			if (isNext) {
	           				loadBpAntiqueList(startIndex, pageSize);
	           			}else
	           				$("#loadingDiv").hide();           			
	           		},300);
	            }
	        });
	
		
		</script>
		<style>
			body{
				background-color: #f3f3f3;
			}
		</style>
		
	</head>

	<body>
		<div class="wenwuList">
			<ul>
					
			</ul>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
		
	</body>

</html>